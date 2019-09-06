Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83285AC1CB
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 23:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388468AbfIFVDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 17:03:22 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:41568 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfIFVDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 17:03:22 -0400
Received: by mail-pf1-f202.google.com with SMTP id g15so5515057pfb.8
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 14:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=X3p9IC5KMyfjhH2AJpSb8AsD49T286nJ6y+FEn+DgIo=;
        b=GI+HZU3FqRbK5SdtZUfHusMTRh1WpfgISUCBrFbWcaPpoZgJPX5Z7t3uBt5nLLgqK5
         aNBnENRONB9tv5WaQi88o21skDUjlyPVI0PxTF6MmhQP/LgQfLPBLvbJcQ890Qw+htRl
         11ESH4eCtSItC074pgr9PMNtTr5g3HjEwmSDffGLxeNnUgXkIhMPW90L176Md/O2rkvE
         Ziol6ves4U4EjCbAhdqWZPZ1lGdI+f7VbEVBczn2hwa312MpBsRmtlIeZRBvyZat6H7q
         nJ5+L5TQdVDBzAuNuS0e3z6YyPkrnJiiYUaMZcOPPQcVhTl7Fo6qgy4WheFq14P3y03F
         PCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=X3p9IC5KMyfjhH2AJpSb8AsD49T286nJ6y+FEn+DgIo=;
        b=SMTme3F1/SYCrxxt53JJqtoRIqG2VTXvsb/pOQCbfq5fANSete66X+4zakkJrc4xAR
         xIRzQ5SpbO8j5oqhQiQL01ri8WpkSqo97CM6uQOZaYYhppNnC0Bs5Uz9qBwh30OURNab
         AEE14nnCQmjGSuzqjsjuBUfFp34TgqH0nqecEDOKVP2Sh/2NT4JzJ2xYQniYPXlimsd8
         GoSVUNPAJJeEatGifYP8s3y2Z9rQqzxsAZ0bsmyBeuPzgDM4eHK+YPbmuAFYv+EMhS98
         6RJh3gJcXyX86zrsorjH3gg9V7gLXW7SvmXr61ALXFFts1MTCTqP++irgbMfP7Iy/ehe
         TDPQ==
X-Gm-Message-State: APjAAAWcdaydO3ihYjtCLuZXk5yA3R4CkzWkQE2rnWaITHjw4D6m+Wrq
        uOCq8isSbW+9qpv8u3cBkmsdAPxcVeca8hL1AohLnjqaSY8aSKzqNfYx+ds3O4xapZqWT6gzEkw
        f+QuCcGz+JMD/H5TWXiOsoNU8db5axiwRfxNlAmdoLgsG3aoHNiyQY2yRQg==
X-Google-Smtp-Source: APXvYqxNdG4S1T4ON0y0OCcJPNj355A2BQvW+t+xyIbLenbmjjeNG/CrY53WlrKas2Lf8IVcIQY0nUA5d3Y=
X-Received: by 2002:a63:5b52:: with SMTP id l18mr9683664pgm.21.1567803801063;
 Fri, 06 Sep 2019 14:03:21 -0700 (PDT)
Date:   Fri,  6 Sep 2019 14:03:04 -0700
Message-Id: <20190906210313.128316-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v4 0/9] KVM: VMX: Add full nested support for IA32_PERF_GLOBAL_CTRL
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
[v3] https://lore.kernel.org/r/20190903215801.183193-1-oupton@google.com

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

v3 => v4:
 - Allow tests to set the guest func multiple times
 - Style fixes throughout kvm-unit-tests patches, per Krish's review

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

