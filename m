Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22177A7699
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfICV6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:58:06 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:49190 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfICV6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:58:06 -0400
Received: by mail-pg1-f202.google.com with SMTP id a9so11824300pga.16
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LOed8xHDkaegAeo5Axit072oKoHV6ZG6l7ea8XZq2Ns=;
        b=XCSudaiT7tAW2/RIDLzggZMbgFGYWL6+z/vx0PeuVvuh57lwWTGYi1I0FK5a2Q21Ro
         xTQDhXz15BsX9VDZ/Fz6GEYIQwa/dCxjHdOcammtUNxlMRA1LHu+V7CyFwcbDAjdUWdo
         NIDDNz8RtrxjyNNoHCTMIyHXESB4DNHuf4XsADFfZSVkt155nMEMQU0fvT/dYkYKK1XX
         G0MuUrLbDkyk6d23VISMrjaGplz3LfaeQzGRcVpMd1RHrHYr8HUC6wOIVe98h/g68Ry9
         IZktg+0x6vXjW5DN+WdEcFxwhFVMUz8yjY+ckxmRDxMYYPUZVC2xuj+wvI6+BoX0OVx2
         KG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=LOed8xHDkaegAeo5Axit072oKoHV6ZG6l7ea8XZq2Ns=;
        b=lq8eQNoKN0vYboHTso9+mOLTIXXYda8EGSEdgANAQETzPu95p1sZzt0txdPBw+Au2T
         gG0Fq5ROH3/hZm9SOk2tEJkOWcK9jYymB5Nc7z4ucH0DFlzKdHx/QLz7zp6xFfQqBepc
         TPX50vvJRlIJ+dMqAPrEjbnopZbnCQSXu7T7eoujNQxkNXi2lL9sEdfjn9Mdi2Fay5Xm
         9QP/Gv17l/DYT/BUaxqQLBslWv/8ZObVuBuF9+79qT3aeKvIqX7l0BsH50ThXgn58tE/
         9EGXad59NCsjSgOplwwFwpVYuJtl3ohhxW674++iQ6VTCbyb/zh3ofZbMfb+U0xfIdnF
         Bl3g==
X-Gm-Message-State: APjAAAXXPReaAa6IHj4mb34i9N4sSu8pHCBjer/hoyOzuWT9f3H5rmuw
        qTwPlB5tiYxmY1rLwP0ul9R3dW1kz4XkAbMJ71bfLDY283YbEDOPi2IzXYnWnMD9FbDGgzGpkNZ
        WfsT0u77BGgmTr5MBUntW5FaIi3VJGyFgOyc/aF+K1SfyL0DWCdkDCdgv5Q==
X-Google-Smtp-Source: APXvYqw13t0lk2K87f3YMLW/E1jCO9bfofmKjOH3FTCjA9S/oOgtXt9FxP145nJrMiim3UHYHLUI9QdULUU=
X-Received: by 2002:a63:a35c:: with SMTP id v28mr32444194pgn.144.1567547885437;
 Tue, 03 Sep 2019 14:58:05 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:57:53 -0700
Message-Id: <20190903215801.183193-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v3 0/8] KVM: VMX: Add full nested support for IA32_PERF_GLOBAL_CTRL
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[v1] https://lore.kernel.org/r/20190828234134.132704-1-oupton@google.com
[v2] https://lore.kernel.org/r/20190903213044.168494-1-oupton@google.com

v1 => v2:
 - Add Krish's Co-developed-by and Signed-off-by tags.
 - Fix minor nit to kvm-unit-tests to use 'host' local variable
   throughout test_load_pgc()
 - Teach guest_state_test_main() to check guest state from within nested
   VM
 - Update proposed tests to use guest/host state checks, wherein the
   value is checked from MSR_CORE_PERF_GLOBAL_CTRL.
 - Changelog line wrapping

v2 => v3:
 - Remove the value unchanged condition from
   kvm_is_valid_perf_global_ctrl
 - Add line to changelog for patch 3/8

This patchset exposes the "load IA32_PERF_GLOBAL_CTRL" to guests for nested
VM-entry and VM-exit. There already was some existing code that supported
the VM-exit ctrl, though it had an issue and was not exposed to the guest
anyway. These patches are based on the original set that Krish Sadhukhan
sent out earlier this year.

Purpose of each patch:

(1) Change the existing code that implemented the VM-exit functionality
    to use kvm_set_msr() to avoid being overwritten by
    atomic_perf_switch_msrs().
(2) Update prepare_vmcs02() to implement the VM-entry functionality,
    again using kvm_set_msr().
(3) Create a helper function for checking the validity of an
    IA32_PERF_GLOBAL_CTRL value against pmu->global_ctrl_mask.
(4) Check guest state on VM-entry as described in the SDM.
(5) Check host state on VM-entry as described in the SDM.
(6) Expose the "load IA32_PERF_GLOBAL_CTRL" VM-entry and VM-exit
    controls if IA32_PERF_GLOBAL_CTRL is a valid MSR.
(7) Modify guest_state_test_main() to check guest state MSRs
(8) Tests in kvm-unit-tests to check the VM-entry and VM-exit controls
    work properly

Oliver Upton (6):
  KVM: nVMX: Use kvm_set_msr to load IA32_PERF_GLOBAL_CTRL on vmexit
  KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on vm-entry
  KVM: VMX: Add helper to check reserved bits in IA32_PERF_GLOBAL_CTRL
  KVM: nVMX: check GUEST_IA32_PERF_GLOBAL_CTRL on VM-Entry
  KVM: nVMX: Check HOST_IA32_PERF_GLOBAL_CTRL on VM-entry
  KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL vm control if supported

 arch/x86/kvm/pmu.h           |  6 ++++++
 arch/x86/kvm/vmx/nested.c    | 37 +++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/pmu_intel.c |  5 ++++-
 arch/x86/kvm/vmx/vmx.c       | 21 ++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h       |  1 +
 5 files changed, 66 insertions(+), 4 deletions(-)

-- 
2.23.0.187.g17f5b7556c-goog

