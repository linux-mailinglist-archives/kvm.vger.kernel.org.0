Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8012514B1B8
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 10:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgA1J13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 04:27:29 -0500
Received: from mail-yb1-f202.google.com ([209.85.219.202]:43644 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgA1J12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 04:27:28 -0500
Received: by mail-yb1-f202.google.com with SMTP id g11so9672739ybc.10
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2020 01:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1D2HqKC9xNZbgrwgnAL8n/SPKL7jL4ZkZkoq8tmp9b8=;
        b=JDNWLBhBFWoJl6jiprEuB62OWWTC69IaEjDtsRF8/NeuXZ/Dxss6EZoBeC+L+C9U+x
         lMczqXsg7XLlbPdDCme2pDMFv1UcsJiZ92eW4tJa/hdpX1PPTNzYb97GJBgelqVvv2f3
         BN5uxg+st9AQplCR3XccdgVx7ZW0ysjAk5fFE1JWwNzOcwF3a3OtIW23enJckYoqrbo8
         81/PfFHh0mM6+wTbXyCRnvE9jK5Ds0OYTm/XeK3Pdn+grDR7RXOlEzLwqD02ByER2jWV
         JqGZp1GwBueV51DUjB3NAK2d2xUfaUcFSxAZNedRWWn5RSBRzkT+pSbUWlNCy/LmF6s5
         HbsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1D2HqKC9xNZbgrwgnAL8n/SPKL7jL4ZkZkoq8tmp9b8=;
        b=W56dUtJ62FA/PYv0fqwcZe/1tkfTSKULFxTCJqrGKGBchvIWRzMJefL8ItkqjXQm8E
         GWy2Raa0SSK7b95S6iLzZbFkiq+TPSzYjZpH259IqCn9FqjQ3M28bOJR/Go6KOOuYZba
         CVva0bFrdgtgsHEB08nGEPOdSdSbDdWQfDj4rsrFudmuKQWggAkHnDg5lAXg1tx0Rp7i
         7P3YrA3MCMzbC74bBiLm5zQ9ieKdXE5YhiTdxd882rjg981XxjpzqlDw1rvMGN5OhcNl
         rg4e7f8YVCrvnlUTpqL0+ZkqLC1ZOC7c8HqDYjD53S0CKZqJfBNU+yKFuYUrP/nat6xR
         TtMQ==
X-Gm-Message-State: APjAAAVbRTpBrkPchUaXisDPkUZdCOx/132HyvBQ/K4YndLGINGp4NXO
        Rsad73ZZQZyWyu/hydJOo1jis4Dl9e/D2r3+9jASOZeG/96hjHBBak/XCEApaUSkWX3ydi29PL6
        29epXePZ4tcLTwHB/iwOZlbQbSBOeeysz0ZODKDM4TBzOtmbof62N1Cgs4g==
X-Google-Smtp-Source: APXvYqwRqeqGcIzZ8xLebgJnllx3kBwi/LiQU8PzrVDYXD1fiD8XhLCPgXdFIcmN3K+Y75RUgYm5+YDOFn8=
X-Received: by 2002:a81:6d17:: with SMTP id i23mr16153448ywc.58.1580203647427;
 Tue, 28 Jan 2020 01:27:27 -0800 (PST)
Date:   Tue, 28 Jan 2020 01:27:10 -0800
Message-Id: <20200128092715.69429-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v2 0/5] Handle monitor trap flag during instruction emulation
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
regard to API compatibility. Rather than immediately injecting the
payload w/o opt-in, instead defer the payload + immediately inject
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

Oliver Upton (4):
  KVM: x86: Mask off reserved bit from #DB exception payload
  KVM: nVMX: Handle pending #DB when injecting INIT VM-exit
  KVM: x86: Deliver exception payload on KVM_GET_VCPU_EVENTS
  KVM: nVMX: Emulate MTF when performing instruction emulation

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm.c              |  1 +
 arch/x86/kvm/vmx/nested.c       | 60 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/nested.h       |  5 +++
 arch/x86/kvm/vmx/vmx.c          | 22 ++++++++++++
 arch/x86/kvm/vmx/vmx.h          |  3 ++
 arch/x86/kvm/x86.c              | 52 +++++++++++++++++-----------
 8 files changed, 125 insertions(+), 20 deletions(-)

-- 
2.25.0.341.g760bfbb309-goog

