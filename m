Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B0432F292
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhCESbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbhCESb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:31:29 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63355C061574
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:31:29 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 131so3365700ybp.16
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=ImkS2ZR1p3G/2SDQfJ8HrKEAKHalQx7zguwSD6QHvf4=;
        b=YL0vcJHfRYSHkVgKACDQ3L9PjVHPp6sLUYoXm52dI16ZcNixwN16BIaqK2VTUebMrx
         k9Ub3Qcdxi7iiVh09Oa/NA9pmYhmxbXDaAj9mILJLnRY9Bg3qsqb4QD/VvunbMITPzpK
         RCOWh+TJ6fCcI0HSV2J9RmapDBoIV8L1E/29CyG9lBO73bw+/swuwfsTJCJgna0dbiCF
         DDCbM8w0lxUuqT16PE5ypiiEn1nssV6QwBoZUmJhsxXsLAM8LPWsRJVt49Ki6TxkRo4N
         NjlrP2GpOEkmp4ACxKyG26+Ycr3jci/eL3ROrETC6KesZLiu3CkZetIqGZCRTSKSG6BP
         BAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=ImkS2ZR1p3G/2SDQfJ8HrKEAKHalQx7zguwSD6QHvf4=;
        b=EFO2xlGcTL6ic5FSc5UsFTKcbqbmqBvimyG+vQJtE5q03kWmXWUm+VICBL8NsNdSef
         uANhOKlwh7FWssuiH92qX/PjdTQhqd42RvxoxY5+HRick6s/mmElnHX5CwZPd3mPzDnH
         AygoDwSsS8ka9b51H1352G26Cnjy+ZlLP61k5S+PaNKnT3E8KRQ8w1CrcDnwwd5BesU8
         h2qtDauU0ELV7YDHnA8gqqi2ak+NTaXxai98/nmvDFxrFs+KxqlcYAl5gtSRTsrUeL4L
         49+cfhbx2py4+096n5h/zm2Jn1tBam8jILkOnCB5XZYdn/lbZM5AB6kQX8cIuLCuBziQ
         Tohw==
X-Gm-Message-State: AOAM53200/zGBI+p4fm404LtpCSOfbSiazmKkR+XgwyAA6sN6ar5hGoI
        VIwqkVLYDl2TtJIWhDeIvQtJk8MiRGY=
X-Google-Smtp-Source: ABdhPJxkD12a1/MPoA7dPeZYo+wpri52SSaJlYIfFndPtwRa14t6bLCHd6V0p0YQqDRr1xe1rARfTwTbHf4=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:aae2:: with SMTP id t89mr16583064ybi.63.1614969088683;
 Fri, 05 Mar 2021 10:31:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 10:31:12 -0800
Message-Id: <20210305183123.3978098-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 00/11] KVM: VMX: Clean up Hyper-V PV TLB flush
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up KVM's PV TLB flushing when running with EPT on Hyper-V, i.e. as
a nested VMM.  No real goal in mind other than the sole patch in v1, which
is a minor change to avoid a future mixup when TDX also wants to define
.remote_flush_tlb.  Everything else is opportunistic clean up.

NOTE: Based on my NPT+SME bug fix series[*] due to multiple conflicts with
      non-trivial resolutions.

[*] https://lkml.kernel.org/r/20210305011101.3597423-1-seanjc@google.com


Patch 1 legitimately tested on VMX and SVM (including i386).  Patches 2+
smoke tested by hacking usage of the relevant flows without actually
routing to the Hyper-V hypercalls (partial hack-a-patch below).

-static inline int hv_remote_flush_root_ept(hpa_t root_ept,
+static inline int hv_remote_flush_root_ept(struct kvm *kvm, hpa_t root_ept,
                                           struct kvm_tlb_range *range)
 {
-       if (range)
-               return hyperv_flush_guest_mapping_range(root_ept,
-                               kvm_fill_hv_flush_list_func, (void *)range);
-       else
-               return hyperv_flush_guest_mapping(root_ept);
+       if (range) {
+               kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH);
+               return 0;
+       }
+
+       return -ENOMEM;
 }
 
 static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
@@ -7753,8 +7754,7 @@ static __init int hardware_setup(void)
                vmx_x86_ops.update_cr8_intercept = NULL;
 
 #if IS_ENABLED(CONFIG_HYPERV)
-       if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
-           && enable_ept) {
+       if (enable_ept) {
                vmx_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
                vmx_x86_ops.tlb_remote_flush_with_range =
                                hv_remote_flush_tlb_with_range;

v4: 
  - Rebased to kvm/queue, commit fe5f0041c026 ("KVM/SVM: Move vmenter.S
    exception fixups out of line"), plus the aforementioned series.
  - Don't grab PCID for nested_cr3 (NPT). [Paolo]
  - Collect reviews. [Vitaly]

v3:
  - https://lkml.kernel.org/r/20201027212346.23409-1-sean.j.christopherson@intel.com
  - Add a patch to pass the root_hpa instead of pgd to vmx_load_mmu_pgd()
    and retrieve the active PCID only when necessary.  [Vitaly]
  - Selectively collects reviews (skipped a few due to changes). [Vitaly]
  - Explicitly invalidate hv_tlb_eptp instead of leaving it valid when
    the mismatch tracker "knows" it's invalid. [Vitaly]
  - Change the last patch to use "hv_root_ept" instead of "hv_tlb_pgd"
    to better reflect what is actually being tracked.

v2:
  - Rewrite everything.
  - https://lkml.kernel.org/r/20201020215613.8972-1-sean.j.christopherson@intel.com

v1: ???

Sean Christopherson (11):
  KVM: x86: Get active PCID only when writing a CR3 value
  KVM: VMX: Track common EPTP for Hyper-V's paravirt TLB flush
  KVM: VMX: Stash kvm_vmx in a local variable for Hyper-V paravirt TLB
    flush
  KVM: VMX: Fold Hyper-V EPTP checking into it's only caller
  KVM: VMX: Do Hyper-V TLB flush iff vCPU's EPTP hasn't been flushed
  KVM: VMX: Invalidate hv_tlb_eptp to denote an EPTP mismatch
  KVM: VMX: Don't invalidate hv_tlb_eptp if the new EPTP matches
  KVM: VMX: Explicitly check for hv_remote_flush_tlb when loading pgd
  KVM: VMX: Define Hyper-V paravirt TLB flush fields iff Hyper-V is
    enabled
  KVM: VMX: Skip additional Hyper-V TLB EPTP flushes if one fails
  KVM: VMX: Track root HPA instead of EPTP for paravirt Hyper-V TLB
    flush

 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/mmu.h              |   4 +-
 arch/x86/kvm/svm/svm.c          |  10 ++-
 arch/x86/kvm/vmx/vmx.c          | 134 ++++++++++++++++++--------------
 arch/x86/kvm/vmx/vmx.h          |  19 ++---
 5 files changed, 92 insertions(+), 79 deletions(-)

-- 
2.30.1.766.gb4fecdf3b7-goog

