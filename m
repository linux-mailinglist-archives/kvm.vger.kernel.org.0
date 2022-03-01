Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFFF4C83B0
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 07:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiCAGEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 01:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbiCAGEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 01:04:47 -0500
Received: from mail-ot1-x349.google.com (mail-ot1-x349.google.com [IPv6:2607:f8b0:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF9960D87
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:07 -0800 (PST)
Received: by mail-ot1-x349.google.com with SMTP id f37-20020a9d2c28000000b005ad366aa68dso10577319otb.8
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=k/u5xT5AyOJ878deH0FLroHeIz5vo7dAUy4eq2iMv4Y=;
        b=Ox3zTHlfIntsxUPlNJjNgI3pzLeNdHy7CAuIS6TJ7sDG5BoqHOSpQsu9X3xj7Pc+3h
         3dxfXgUj6JrFQgBFZLuhhdFOexOhiFqIqGoIZDwy1Fv6vf6XVnTwISmfpNVPogqc75k1
         wyW80dZBSxdNDlNrtO4f+CDlRUc8jGJlwk8TAWQ+pFKdIJ08A+G8Hh7wVGnWbju6fJqI
         PqXHiLFfVn94GVmzDLR0L0dlc0l/XNwJyTHT0riYAyJc+3JucAWts/1LuyuLFK9bpIgW
         ZeYj41Xgrqo9R/0xlDAwSs5K9gnIkVPo/H9jpr3JzFtFoaNFJlyzjYUK2qRtRse6L0w+
         sz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=k/u5xT5AyOJ878deH0FLroHeIz5vo7dAUy4eq2iMv4Y=;
        b=6EBf2pTAFnlyUTwfviS8WY2QQsYrwwYDJ6VllMnQs3eer8SFjoB27BQfZA6oCKcO86
         HXSfTMm6xeAEw9bFOZqfj+pfn2oVo0SqNCvpMuGGffGA8ReortxxVqHQLiRxr+lSnA93
         qx7wFic/WdxB+uB/Z5mzvewcAMQIygk7PjaalGvOm3SEq58NwPhk7/8xqtIKfvYyOZcr
         +k25gGEPzLjk+HplFTCNejI6sVF1cVby8bIFRlup1AJp7kLeHHabEeLA9ww/gRrGuUYv
         9n2srCOlm8cQjH8vIpTJcm4wrlLsS+gLXefV3TwlBRLCm9x/4KOPlMfLMRJUB0KaU2zg
         gnkw==
X-Gm-Message-State: AOAM532Rs/ceXOrCKVBRi0Z9LV8WtYO9APIyAqhhebP6iIjQlimvyIJt
        6bnvcFKh2EPueCK+qWE/rWjwmyQ/8nzEEVMqVmzRbmi5gBg+2IU7GV05yfPPsAqwgMQwnujuKvR
        YyH+H8LxGjyIh6S4qbc7vnH4YOdttrQq8bJbg9ChK5NZ9id3GWW6SwhzOIw==
X-Google-Smtp-Source: ABdhPJz5eOtfH8//O4h26vbtDAVoKkYCeVIMNMUxZwTkWvygUXBuWcYhTVog87mlDLu/Ou9yKI3P/j2vlp8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6870:a1a3:b0:d3:f4a7:f3e3 with SMTP id
 a35-20020a056870a1a300b000d3f4a7f3e3mr2940202oaf.109.1646114646690; Mon, 28
 Feb 2022 22:04:06 -0800 (PST)
Date:   Tue,  1 Mar 2022 06:03:45 +0000
In-Reply-To: <20220301060351.442881-1-oupton@google.com>
Message-Id: <20220301060351.442881-3-oupton@google.com>
Mime-Version: 1.0
References: <20220301060351.442881-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 2/8] KVM: nVMX: Keep KVM updates to PERF_GLOBAL_CTRL ctrl
 bits across MSR write
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
VM-{Entry,Exit} control"), KVM has taken ownership of the "load
IA32_PERF_GLOBAL_CTRL" VMX entry/exit control bits. The ABI is that
these bits will be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS MSRs if
the guest's CPUID exposes a vPMU that supports the IA32_PERF_GLOBAL_CTRL
MSR (CPUID.0AH:EAX[7:0] > 1), and clear otherwise.

However, commit aedbaf4f6afd ("KVM: x86: Extract
kvm_update_cpuid_runtime() from kvm_update_cpuid()") partially broke KVM
ownership of the aforementioned bits. Before, kvm_update_cpuid() was
exercised frequently when running a guest and constantly applied its own
changes to the "load IA32_PERF_GLOBAL_CTRL" bits. Now, the "load
IA32_PERF_GLOBAL_CTRL" bits are only ever updated after a
KVM_SET_CPUID/KVM_SET_CPUID2 ioctl, meaning that a subsequent MSR write
from userspace will clobber these values.

Note that older kernels without commit c44d9b34701d ("KVM: x86: Invoke
vendor's vcpu_after_set_cpuid() after all common updates") still require
that the entry/exit controls be updated from kvm_pmu_refresh(). Leave
the benign call in place to allow for cleaner backporting and punt the
cleanup to a later change.

Uphold the old ABI by reapplying KVM's tweaks to the "load
IA32_PERF_GLOBAL_CTRL" bits after an MSR write from userspace.

Fixes: aedbaf4f6afd ("KVM: x86: Extract kvm_update_cpuid_runtime() from kvm_update_cpuid()")
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/pmu.h     |  5 +++++
 arch/x86/kvm/vmx/vmx.c | 12 ++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7a7b8d5b775e..2d9995668e0b 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -140,6 +140,11 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
+static inline u8 kvm_pmu_version(struct kvm_vcpu *vcpu)
+{
+	return vcpu_to_pmu(vcpu)->version;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3a97220c5f78..224ef4c19a5d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7261,6 +7261,18 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 			vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_CLEAR_BNDCFGS;
 		}
 	}
+
+	/*
+	 * KVM supports a 1-setting of the "load IA32_PERF_GLOBAL_CTRL"
+	 * VM-{Entry,Exit} controls if the vPMU supports IA32_PERF_GLOBAL_CTRL.
+	 */
+	if (kvm_pmu_version(vcpu) >= 2) {
+		vmx->nested.msrs.entry_ctls_high |= VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmx->nested.msrs.exit_ctls_high |= VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+	} else {
+		vmx->nested.msrs.entry_ctls_high &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+	}
 }
 
 static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
-- 
2.35.1.574.g5d30c73bfb-goog

