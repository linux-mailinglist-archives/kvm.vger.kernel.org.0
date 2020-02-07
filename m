Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C621555DB
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 11:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgBGKga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 05:36:30 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:54664 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbgBGKg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 05:36:29 -0500
Received: by mail-pg1-f201.google.com with SMTP id i21so1333822pgm.21
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 02:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=unQMDuml2JRM4lxYQH2f2pyITlNbCCf7jTarNpqVCtg=;
        b=iAy2sqKJeA5u4JT+aKW2ZATjLCzZ6D5Q7rsC1sHLCP+lQ9kIbvNhDGwPf7SQ2te/zf
         nxUMJGmotyhSNhO9eHPJf92319VtS+y7wL983u8ktJGoNKILbXshZgUfyVqplYpNtUgJ
         nIvwlNbcCpVY/rkSAJlvOVE/gwTCsE6OGyzuJ5msG1N4lmJRpQk4WZzQOBQnNGx+NspO
         I7xC9XTGQXpm8XU+Ftdc09y2CUAbcTbsO6GCDWf4gC8GWe/Aw8f+F/4rF6cMdjsUIW7o
         m33kncoEfF4Zt4SaW29mG2aajfA4Dj/zUgkzyBaMonzapqc92xIa96+bL6Vut2IL02LA
         PX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=unQMDuml2JRM4lxYQH2f2pyITlNbCCf7jTarNpqVCtg=;
        b=KPPV4lV2OW6wNoRDM8+j7kt7DRAGiZryxi5XTJwCsv3rWpyjFy/y+d4AVZq+CXGXiA
         g6kW5Rmb7uDryrk8tbivMhFzLD9Z9IfbSQ0Umf5BbSmreupZC1xlpcfU6COysydaZvB3
         S4rCY87Fg0OVVFrut9I2EEmYW6ygBi3sLKaPRS+2DpN7E/SChCab9RwIw+nLmh4cofLr
         mD6CzUMKFx5Tx4aLdMXQe7zZJ7CETL3jpicl9L+IDo7dBsPeeaB7Mk/QyKTINpYkSQ1Z
         qSaSutgXf3mIWsWszMTgFMxuCc/CdO1qvB0CUKwAQIp/gmMKJ5gJVNVcho1CAEq393XC
         bkHw==
X-Gm-Message-State: APjAAAXJZnGfD3OfGQZEZ3uIw/g+SCcIX/Jc1WyslIIY0fuj1AFhByQz
        27Oiav4O1mUuZKpsVJSrvj3M795PwrmflcOHWZC4ZNXhbYpYe+tlvUyNJVBGuqF9JeFHe10h6ly
        Z6SeCOGlo08Ixh6JemuWg6KJFZZ+U/V0JX6x1nPjOdTYfN9zDWINiwGSATA==
X-Google-Smtp-Source: APXvYqxClo4dpjDVyAe6XA2FLDc0x+PYkzKL+JCtlEPz5tMClKKtBg/12Gsl2A1IsE8tk4LKsyPsPQhxIok=
X-Received: by 2002:a63:646:: with SMTP id 67mr8731570pgg.376.1581071788480;
 Fri, 07 Feb 2020 02:36:28 -0800 (PST)
Date:   Fri,  7 Feb 2020 02:36:03 -0800
Message-Id: <20200207103608.110305-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v3 0/5] Handle monitor trap flag during instruction emulation
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1: http://lore.kernel.org/r/20200113221053.22053-1-oupton@google.com
v2: http://lore.kernel.org/r/20200128092715.69429-1-oupton@google.com

v1 => v2:
 - Don't split the #DB delivery by vendors. Unconditionally injecting
   #DB payloads into the 'pending debug exceptions' field will cause KVM
   to get stuck in a loop. Per the SDM, when hardware injects an event
   resulting from this field's value, it is checked against the
   exception interception bitmap.
 - Address Sean's comments by injecting the VM-exit into L1 from
   vmx_check_nested_events().
 - Added fix for nested INIT VM-exits + 'pending debug exceptions' field
   as it was noticed in implementing v2.
 - Drop Peter + Jim's Reviewed-by tags, as the patch set has changed
   since v1.

v2 => v3:
 - Merge the check/set_pending_dbg helpers into a single helper,
   vmx_update_pending_dbg(). Add clarifying comment to this helper.
 - Rewrite commit message, descriptive comment for change in 3/5 to
   explicitly describe the reason for mutating payload delivery
   behavior.
 - Undo the changes to kvm_vcpu_do_singlestep(). Instead, add a new hook
   to call for 'full' instruction emulation + 'fast' emulation.

KVM already provides guests the ability to use the 'monitor trap flag'
VM-execution control. Support for this flag is provided by the fact that
KVM unconditionally forwards MTF VM-exits to the guest (if requested),
as KVM doesn't utilize MTF. While this provides support during hardware
instruction execution, it is insufficient for instruction emulation.

Should L0 emulate an instruction on the behalf of L2, L0 should also
synthesize an MTF VM-exit into L1, should control be set.

The first patch corrects a nuanced difference between the definition of
a #DB exception payload field and DR6 register. Mask off bit 12 which is
defined in the 'pending debug exceptions' field when applying to DR6,
since the payload field is said to be compatible with the aforementioned
VMCS field.

The second patch sets the 'pending debug exceptions' VMCS field when
delivering an INIT signal VM-exit to L1, as described in the SDM. This
patch also introduces helpers for setting the 'pending debug exceptions'
VMCS field.

The third patch massages KVM's handling of exception payloads with
regard to API compatibility. Rather than immediately delivering the
payload w/o opt-in, instead defer the payload + inject
before completing a KVM_GET_VCPU_EVENTS. This maintains API
compatibility whilst correcting #DB behavior with regard to higher
priority VM-exit events.

Fourth patch introduces MTF implementation for emulated instructions.
Identify if an MTF is due on an instruction boundary from
kvm_vcpu_do_singlestep(), however only deliver this VM-exit from
vmx_check_nested_events() to respect the relative prioritization to
other VM-exits. Since this augments the nested state, introduce a new
flag for (de)serialization.

Last patch adds tests to kvm-unit-tests to assert the correctness of MTF
under several conditions (concurrent #DB trap, #DB fault, etc). These
tests pass under virtualization with this series as well as on
bare-metal.

Based on commit 2c2787938512 ("KVM: selftests: Stop memslot creation in
KVM internal memslot region").

Oliver Upton (4):
  KVM: x86: Mask off reserved bit from #DB exception payload
  KVM: nVMX: Handle pending #DB when injecting INIT VM-exit
  KVM: x86: Deliver exception payload on KVM_GET_VCPU_EVENTS
  KVM: nVMX: Emulate MTF when performing instruction emulation

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm.c              |  1 +
 arch/x86/kvm/vmx/nested.c       | 54 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/nested.h       |  5 +++
 arch/x86/kvm/vmx/vmx.c          | 37 +++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |  3 ++
 arch/x86/kvm/x86.c              | 39 ++++++++++++++++--------
 8 files changed, 126 insertions(+), 15 deletions(-)

-- 
2.25.0.341.g760bfbb309-goog

