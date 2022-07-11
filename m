Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F0E570D85
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 00:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiGKWn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 18:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiGKWnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 18:43:53 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7065B205E5
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 15:43:52 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f11so5683632plr.4
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 15:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yYIT4+JM9WjxzEKuVUw9xKwWpXL5bdh0tMvz2dYew/Q=;
        b=UyunWXv4VEh8X/Ly622zEpTk0dS8yXYDVIHDP0gNLt3pgrRut7Dw6DCTIVIFsGyqRe
         YuOk0xfTslV6WFp2YqFpM56Wm/sVrwjVdoXdTxe+QAxKwCj2dg6etcS6R06WJpA5+onM
         X9LkVyXwoMq7ywuA3mKQp4HLthPPahPPwBn7/dDAmexGcFMss7HIiwK2J3qnqxMWi4bw
         3bCD7k/PhPHpy6EUgXeac1DaXODcRGKnOjAdujuZnwoPttKHbxtezXgH5QuZRil+Augl
         CrlNafLwSDsajPbrmzqIHg1gpyLWKHKOWZtSYRE0NJnQIi/cLv55EpDYXFEzj4DoszLR
         goUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yYIT4+JM9WjxzEKuVUw9xKwWpXL5bdh0tMvz2dYew/Q=;
        b=TcBirhRF7WXWHhpxIa/Is+n4pH993vMB9dGbUsBA/+P1jsivZlyWSxJ470aep0fEzb
         bg8TkY0dEMHVWykoFyXvR2DTvIdXit70lj+aLqfwJUYgUukWJbIX3jLlC7kosHMtzsFp
         xV1Q/SppltAnmv9fw80sVYtXRDHJrAhtKhKWYlS8ieAMXWb6ial1TW5LwQDUxcraFrlY
         wVgOHUELH983rgrT80vMPZtA4rVPaT39IqLuCTWArpvLe0K8I0OB/jyCiagtLjGIjWyY
         5fjHCgJkVLDzOqKND1/C0Ktg7q61uRQ51UAWDJDoz2thXzABwpCJS0WmKdacSCnRlzrW
         4d/A==
X-Gm-Message-State: AJIora9TQzjjT6wVoxqjJ7Q2eMRZPs8zyCTeBtBVsMeip6kew/om8JCP
        cGRIRhE3OU1d+5hMTkQfPvsrWQ==
X-Google-Smtp-Source: AGRyM1vVN5RURJcRMZ2Tuwg7h//I5HmL/+RuSIUJuF7/v5XjO0+4xaCWMmb5vz0+LvdQ6mdHY8yRBg==
X-Received: by 2002:a17:90a:fb8d:b0:1ef:8d22:35e with SMTP id cp13-20020a17090afb8d00b001ef8d22035emr649801pjb.229.1657579431565;
        Mon, 11 Jul 2022 15:43:51 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id k1-20020a170902694100b0016a79b69f91sm5258935plt.26.2022.07.11.15.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 15:43:51 -0700 (PDT)
Date:   Mon, 11 Jul 2022 22:43:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paul Durrant <pdurrant@amazon.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v5] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info)
 sub-leaves, if present
Message-ID: <YsynoyUb4zrMBhRU@google.com>
References: <20220629130514.15780-1-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629130514.15780-1-pdurrant@amazon.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022, Paul Durrant wrote:
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 88a3026ee163..abb0a39f60eb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -638,6 +638,7 @@ struct kvm_vcpu_xen {
>  	struct hrtimer timer;
>  	int poll_evtchn;
>  	struct timer_list poll_timer;
> +	u32 cpuid_tsc_info;

I would prefer to follow vcpu->arch.kvm_cpuid_base and capture the base CPUID
function.  I have a hard time believing this will be the only case where KVM needs
to query XEN CPUID leafs.  And cpuid_tsc_info is a confusing name given the helper
kvm_xen_setup_tsc_info(); it's odd to see a "setup" helper immediately consume a
variable with the same name.

It'll incur another CPUID lookup in the update path to check the limit, but again
that should be a rare operation so it doesn't seem too onerous.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 031678eff28e..29ed665c51db 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3110,6 +3110,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  				   &vcpu->hv_clock.tsc_shift,
>  				   &vcpu->hv_clock.tsc_to_system_mul);
>  		vcpu->hw_tsc_khz = tgt_tsc_khz;
> +		kvm_xen_setup_tsc_info(v);

Any objection to s/setup/update?  KVM Xen uses "setup" for things like configuring
the event channel using userspace input, whereas this is purely updating existing
data structures.

>  	}
>  
>  	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 610beba35907..c84424d5c8b6 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -10,6 +10,9 @@
>  #include "xen.h"
>  #include "hyperv.h"
>  #include "lapic.h"
> +#include "cpuid.h"
> +
> +#include <asm/xen/cpuid.h>
>  
>  #include <linux/eventfd.h>
>  #include <linux/kvm_host.h>
> @@ -1855,3 +1858,51 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
>  	if (kvm->arch.xen_hvm_config.msr)
>  		static_branch_slow_dec_deferred(&kvm_xen_enabled);
>  }
> +
> +void kvm_xen_after_set_cpuid(struct kvm_vcpu *vcpu)
> +{
> +	u32 base = 0;
> +	u32 limit;
> +	u32 function;
> +
> +	vcpu->arch.xen.cpuid_tsc_info = 0;
> +
> +	for_each_possible_hypervisor_cpuid_base(function) {
> +		struct kvm_cpuid_entry2 *entry = kvm_find_cpuid_entry(vcpu, function, 0);
> +
> +		if (entry &&
> +		    entry->ebx == XEN_CPUID_SIGNATURE_EBX &&
> +		    entry->ecx == XEN_CPUID_SIGNATURE_ECX &&
> +		    entry->edx == XEN_CPUID_SIGNATURE_EDX) {
> +			base = function;
> +			limit = entry->eax;
> +			break;
> +		}
> +	}
> +	if (!base)
> +		return;

Rather than open code a variant of kvm_update_kvm_cpuid_base(), that helper can
be tweaked to take a signature.  Along with a patch to provide a #define for Xen's
signature as a string, this entire function becomes a one-liner.

If the below looks ok (won't compile, needs prep patches), I'll test and post a
proper mini-series.

---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  2 ++
 arch/x86/kvm/x86.c              |  1 +
 arch/x86/kvm/xen.c              | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/xen.h              | 22 +++++++++++++++++++++-
 5 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index de5a149d0971..b2565d05fc86 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -638,6 +638,7 @@ struct kvm_vcpu_xen {
 	struct hrtimer timer;
 	int poll_evtchn;
 	struct timer_list poll_timer;
+	u32 cpuid_base;
 };

 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0abe3adc9ae3..54ed51799b8d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -25,6 +25,7 @@
 #include "mmu.h"
 #include "trace.h"
 #include "pmu.h"
+#include "xen.h"

 /*
  * Unlike "struct cpuinfo_x86.x86_capability", kvm_cpu_caps doesn't need to be
@@ -309,6 +310,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);

 	kvm_hv_set_cpuid(vcpu);
+	kvm_xen_after_set_cpuid(vcpu);

 	/* Invoke the vendor callback only after the above state is updated. */
 	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 567d13405445..a624293c66c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3110,6 +3110,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 				   &vcpu->hv_clock.tsc_shift,
 				   &vcpu->hv_clock.tsc_to_system_mul);
 		vcpu->hw_tsc_khz = tgt_tsc_khz;
+		kvm_xen_update_tsc_info(v);
 	}

 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 610beba35907..3fc0c194b813 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -10,6 +10,9 @@
 #include "xen.h"
 #include "hyperv.h"
 #include "lapic.h"
+#include "cpuid.h"
+
+#include <asm/xen/cpuid.h>

 #include <linux/eventfd.h>
 #include <linux/kvm_host.h>
@@ -1855,3 +1858,30 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
 	if (kvm->arch.xen_hvm_config.msr)
 		static_branch_slow_dec_deferred(&kvm_xen_enabled);
 }
+
+void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *entry;
+	u32 function;
+
+	if (!vcpu->arch.xen.cpuid_base)
+		return;
+
+	entry = kvm_find_cpuid_entry(vcpu, vcpu->arch.xen.cpuid_base, 0);
+	if (WARN_ON_ONCE(!entry))
+		return;
+
+	function = vcpu->arch.xen.cpuid_base | XEN_CPUID_LEAF(3);
+	if (function > entry->eax)
+		return;
+
+	entry = kvm_find_cpuid_entry(vcpu, function, 1);
+	if (entry) {
+		entry->ecx = vcpu->arch.hv_clock.tsc_to_system_mul;
+		entry->edx = vcpu->arch.hv_clock.tsc_shift;
+	}
+
+	entry = kvm_find_cpuid_entry(vcpu, function, 2);
+	if (entry)
+		entry->eax = vcpu->arch.hw_tsc_khz;
+}
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 532a535a9e99..b8161b99b82a 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -9,9 +9,14 @@
 #ifndef __ARCH_X86_KVM_XEN_H__
 #define __ARCH_X86_KVM_XEN_H__

-#ifdef CONFIG_KVM_XEN
 #include <linux/jump_label_ratelimit.h>

+#include <asm/xen/cpuid.h>
+
+#include "cpuid.h"
+
+#ifdef CONFIG_KVM_XEN
+
 extern struct static_key_false_deferred kvm_xen_enabled;

 int __kvm_xen_has_interrupt(struct kvm_vcpu *vcpu);
@@ -32,6 +37,13 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe,
 int kvm_xen_setup_evtchn(struct kvm *kvm,
 			 struct kvm_kernel_irq_routing_entry *e,
 			 const struct kvm_irq_routing_entry *ue);
+void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu);
+
+static inline void kvm_xen_after_set_cpuid(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.xen.cpuid_base =
+		kvm_get_hypervisor_cpuid_base(vcpu, XEN_CPUID_SIGNATURE);
+}

 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 {
@@ -135,6 +147,14 @@ static inline bool kvm_xen_timer_enabled(struct kvm_vcpu *vcpu)
 {
 	return false;
 }
+
+static inline void kvm_xen_after_set_cpuid(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
+{
+}
 #endif

 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);

base-commit: b08b2f54c49d8f96a22107c444d500dff73ec2a6
--

