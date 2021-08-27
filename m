Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D013F9187
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 03:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243877AbhH0A6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 20:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243811AbhH0A6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 20:58:20 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E236C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:57:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q80-20020a25d953000000b0059a45a5f834so4909164ybg.22
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=J1gV9tKuEUW347bCpCRKYVIA3sPFQNKnByLeTysAe1c=;
        b=nXu5TIDh95ZCVXgnqPsB5MnVB7h0DWCeq2WvI55h/YxVMn4UvB/0PXGzic8V1lImAR
         gkzVtaBzsqP9uk6o7rHF+pB2RTOlLz7ZmE8eEnP6TpErUHoLR6Z3y1ul2aW8AZoyvu88
         qf3qQzsVOyHB0k3MoOgHEyselDqB+bWPkRY11SCcmFM3sDoWd+TStfmni6LgyvOVBnbP
         WTC15pqLNheriIrcrp21jHT83qLTB/6Nelsm74BMGahqfznep4J2JYLMBCxHdz3uNE2u
         uw2NOHkkmuzCfwqhqL8S2VSJ8GEr9DgvO4+MZlIU7WbWxZ7rDsc6k8tAYRPFzFNt0mQf
         bwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=J1gV9tKuEUW347bCpCRKYVIA3sPFQNKnByLeTysAe1c=;
        b=pXssPpwYI8BcK2d0Silhw72klrF4a6XkZrXQVUAha8tX7dijxOJAUo8A06TglJXEbi
         h1DBEa6Ko1s38+r8IXT3AG3i3bzFnbd+rRE6bnJ2VHy/2Izqsiaa5oUZnSjTJcLlUk5d
         ZX1sXy1b7K7rzNQFbcfVTW2tHzPV6gaN/o3s6BiULvKh7MbkabtUkxsW1ol7sgSIeiPt
         1bwulE8ws5kn2LHB/FmRM4eWnJTNS6pxSRcb6bPvq++4xyIVjqvCdV3vqBV5wptri87X
         DBWLqSxOxDuk0fHvpNvzkE8f9LN8gI9kwYGiTKvlm6TmFQrHjwTZ9WNL+dgHKPqh24yq
         74sw==
X-Gm-Message-State: AOAM532qNWBmPchbTNThZLxq/NhlQtDiXLb/l5vzwLPYPLtdx+0uRHXf
        EHrfKzB4/kNDoelvOyE1lxjT3PEab0o=
X-Google-Smtp-Source: ABdhPJz56vr62vtEqqrEJytuFJ+pDWaaJX60HJE5Uei+MFkpG8+1SdGPGXBIDgjNq0cE0M+AxLJ7cPev7bI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a25:b845:: with SMTP id b5mr1965166ybm.343.1630025851738;
 Thu, 26 Aug 2021 17:57:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 Aug 2021 17:57:04 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 01/15] KVM: x86: Register perf callbacks after calling
 vendor's hardware_setup()
From:   Sean Christopherson <seanjc@google.com>
To:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wait to register perf callbacks until after doing vendor hardaware setup.
VMX's hardware_setup() configures Intel Processor Trace (PT) mode, and a
future fix to register the Intel PT guest interrupt hook if and only if
Intel PT is exposed to the guest will consume the configured PT mode.

Delaying registration to hardware setup is effectively a nop as KVM's perf
hooks all pivot on the per-CPU current_vcpu, which is non-NULL only when
KVM is handling an IRQ/NMI in a VM-Exit path.  I.e. current_vcpu will be
NULL throughout both kvm_arch_init() and kvm_arch_hardware_setup().

Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Artem Kashkanov <artem.kashkanov@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1686fa..fb6015f97f9e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8426,8 +8426,6 @@ int kvm_arch_init(void *opaque)
 
 	kvm_timer_init();
 
-	perf_register_guest_info_callbacks(&kvm_guest_cbs);
-
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
@@ -8461,7 +8459,6 @@ void kvm_arch_exit(void)
 		clear_hv_tscchange_cb();
 #endif
 	kvm_lapic_exit();
-	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
 
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
@@ -11064,6 +11061,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 	kvm_ops_static_call_update();
 
+	perf_register_guest_info_callbacks(&kvm_guest_cbs);
+
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
 
@@ -11091,6 +11090,8 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
+	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
+
 	static_call(kvm_x86_hardware_unsetup)();
 }
 
-- 
2.33.0.259.gc128427fd7-goog

