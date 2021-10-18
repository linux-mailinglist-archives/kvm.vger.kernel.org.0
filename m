Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C823431A65
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 15:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhJRNKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 09:10:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229833AbhJRNKw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 09:10:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634562520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=56IuT+PdlkvXl/kACCVdLw1HVql/ugf55gkE2tIkTMM=;
        b=QJDcrA4DTImTt0JH0AzDzH07BDRd1u0eaz+TCzVWydWrMjFDqr8ie0wANFQR+ShrQk79by
        GAudN0nStck2HzbW2y1yIME6nsLQzcpYjl/0dm5VwmV1Kn2bX60fDuO2g3fb1bxKl7fs/t
        pn1u4RTGOtDFTmYe18TG6Fth6Nv9eYI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-9o_JmyMlPTawRvx9ODT99w-1; Mon, 18 Oct 2021 09:08:39 -0400
X-MC-Unique: 9o_JmyMlPTawRvx9ODT99w-1
Received: by mail-wr1-f70.google.com with SMTP id r16-20020adfb1d0000000b00160bf8972ceso8822763wra.13
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 06:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=56IuT+PdlkvXl/kACCVdLw1HVql/ugf55gkE2tIkTMM=;
        b=0VIeQenFDRGNDZ8rvcHan4jj1jSZblOm/HOW1suOaqMxqqiuykqRKlDCLKo/2+G8rL
         ANZWsRhqNmZ4dvp1dN4dmYYXV9Zq6xFmN53IXucZnjV6UkevcvZRw2A8IhQ6t77go2rJ
         l2jg4vFt285h9pMva8Nz0ogKcg2gDfBDEEGd//wtZ0DaaeNObhKOUtlLJK2AogtNp7YL
         VnVkOJFYQG0KJ+DC9KLsI/1aaf72KLn1Kn9TUKNuMRs8wayQmoY+VdIokwOIiPF+gk13
         trxnrumSNGgAeqBSKQcRZGGAaBFtJ5vkMlW+f6pU4o/Ax4ijvsZ6ln2/NeTpn07z186S
         chhg==
X-Gm-Message-State: AOAM5310cl0ZKqEdzMc97bxt//Tl53zoAuBj6/3RW1fJLVNOxj2O3RY+
        DHCRnAW/DKXiazf4vI0ouJJRTeXE99Jg+ySdFWqwgQYrnJhlAUFHyNUTE7P5EwyEgKiZxRO5n6z
        +dblQWAS3h1fw
X-Received: by 2002:a1c:e906:: with SMTP id q6mr44687531wmc.126.1634562518312;
        Mon, 18 Oct 2021 06:08:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7/6iHH2zKO8aeTMZ8TeUVukVlFcvS0CWBtbTcyYUWYiT+En4lXXHYBvpw9GD3DaLEfTDzbw==
X-Received: by 2002:a1c:e906:: with SMTP id q6mr44687461wmc.126.1634562517850;
        Mon, 18 Oct 2021 06:08:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v191sm12513939wme.36.2021.10.18.06.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 06:08:36 -0700 (PDT)
Message-ID: <50b4c1f0-be96-c1b5-aab1-69f4f61ec43f@redhat.com>
Date:   Mon, 18 Oct 2021 15:08:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 7/7] KVM: VMX: Only context switch some PT MSRs when
 they exist
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
 <20210827070249.924633-8-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210827070249.924633-8-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/21 09:02, Xiaoyao Li wrote:
> The enumeration of Intel PT feature doesn't guarantee the existence of
> MSR_IA32_RTIT_OUTPUT_BASE, MSR_IA32_RTIT_OUTPUT_MASK and
> MSR_IA32_RTIT_CR3_MATCH. They need to be detected from CPUID 0x14 PT
> leaves.
> 
> Detect the existence of them in hardware_setup() and only context switch
> them when they exist. Otherwise it will cause #GP when access them.

If intel_pt_validate_hw_cap is not fast enough, it should be optimized.
Something like this:

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 7f406c14715f..9c7167dcb719 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -41,13 +41,15 @@ static struct pt_pmu pt_pmu;
   * permitted values for certain bit fields).
   */
  #define PT_CAP(_n, _l, _r, _m)						\
-	[PT_CAP_ ## _n] = { .name = __stringify(_n), .leaf = _l,	\
-			    .reg = _r, .mask = _m }
+	[PT_CAP_ ## _n] = { .name = __stringify(_n),			\
+			    .index = _l * PT_CPUID_REGS_NUM + _r,	\
+			    .shift = __CONSTANT_FFS_32(_m),		\
+			    .mask = _m }
  
  static struct pt_cap_desc {
  	const char	*name;
-	u32		leaf;
-	u8		reg;
+	u16		index;
+	u8		shift;
  	u32		mask;
  } pt_caps[] = {
  	PT_CAP(max_subleaf,		0, CPUID_EAX, 0xffffffff),
@@ -71,10 +73,8 @@ static struct pt_cap_desc {
  u32 intel_pt_validate_cap(u32 *caps, enum pt_capabilities capability)
  {
  	struct pt_cap_desc *cd = &pt_caps[capability];
-	u32 c = caps[cd->leaf * PT_CPUID_REGS_NUM + cd->reg];
-	unsigned int shift = __ffs(cd->mask);
  
-	return (c & cd->mask) >> shift;
+	return (caps[cd->index] & cd->mask) >> cd->shift;
  }
  EXPORT_SYMBOL_GPL(intel_pt_validate_cap);
  
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 5e62e2383b7f..b4ee28d91b77 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -211,6 +211,17 @@ static inline int get_count_order_long(unsigned long l)
  	return (int)fls_long(--l);
  }
  
+#define __CONSTANT_FFS_2(w) \
+	(((w) & 1) == 0)
+#define __CONSTANT_FFS_4(w) \
+	(((w) & 0x3) == 0 ? 2 + __CONSTANT_FFS_2((w) >> 2) : __CONSTANT_FFS_2((w)))
+#define __CONSTANT_FFS_8(w) \
+	(((w) & 0xf) == 0 ? 4 + __CONSTANT_FFS_4((w) >> 4) : __CONSTANT_FFS_4((w)))
+#define __CONSTANT_FFS_16(w) \
+	(((w) & 0xff) == 0 ? 8 + __CONSTANT_FFS_8((w) >> 8) : __CONSTANT_FFS_8((w)))
+#define __CONSTANT_FFS_32(w) \
+	(((w) & 0xffff) == 0 ? 16 + __CONSTANT_FFS_16((w) >> 16) : __CONSTANT_FFS_16((w)))
+
  /**
   * __ffs64 - find first set bit in a 64 bit word
   * @word: The 64 bit word


Paolo

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 28 +++++++++++++++++++++-------
>   1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 394ef4732838..6819fc470072 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -204,6 +204,9 @@ module_param(ple_window_max, uint, 0444);
>   int __read_mostly pt_mode = PT_MODE_SYSTEM;
>   module_param(pt_mode, int, S_IRUGO);
>   
> +static bool has_msr_rtit_cr3_match;
> +static bool has_msr_rtit_output_x;
> +
>   static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
>   static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
>   static DEFINE_MUTEX(vmx_l1d_flush_mutex);
> @@ -1035,9 +1038,12 @@ static inline void pt_load_msr(struct pt_ctx *ctx, u32 addr_range)
>   	u32 i;
>   
>   	wrmsrl(MSR_IA32_RTIT_STATUS, ctx->status);
> -	wrmsrl(MSR_IA32_RTIT_OUTPUT_BASE, ctx->output_base);
> -	wrmsrl(MSR_IA32_RTIT_OUTPUT_MASK, ctx->output_mask);
> -	wrmsrl(MSR_IA32_RTIT_CR3_MATCH, ctx->cr3_match);
> +	if (has_msr_rtit_output_x) {
> +		wrmsrl(MSR_IA32_RTIT_OUTPUT_BASE, ctx->output_base);
> +		wrmsrl(MSR_IA32_RTIT_OUTPUT_MASK, ctx->output_mask);
> +	}
> +	if (has_msr_rtit_cr3_match)
> +		wrmsrl(MSR_IA32_RTIT_CR3_MATCH, ctx->cr3_match);
>   	for (i = 0; i < addr_range; i++) {
>   		wrmsrl(MSR_IA32_RTIT_ADDR0_A + i * 2, ctx->addr_a[i]);
>   		wrmsrl(MSR_IA32_RTIT_ADDR0_B + i * 2, ctx->addr_b[i]);
> @@ -1049,9 +1055,12 @@ static inline void pt_save_msr(struct pt_ctx *ctx, u32 addr_range)
>   	u32 i;
>   
>   	rdmsrl(MSR_IA32_RTIT_STATUS, ctx->status);
> -	rdmsrl(MSR_IA32_RTIT_OUTPUT_BASE, ctx->output_base);
> -	rdmsrl(MSR_IA32_RTIT_OUTPUT_MASK, ctx->output_mask);
> -	rdmsrl(MSR_IA32_RTIT_CR3_MATCH, ctx->cr3_match);
> +	if (has_msr_rtit_output_x) {
> +		rdmsrl(MSR_IA32_RTIT_OUTPUT_BASE, ctx->output_base);
> +		rdmsrl(MSR_IA32_RTIT_OUTPUT_MASK, ctx->output_mask);
> +	}
> +	if (has_msr_rtit_cr3_match)
> +		rdmsrl(MSR_IA32_RTIT_CR3_MATCH, ctx->cr3_match);
>   	for (i = 0; i < addr_range; i++) {
>   		rdmsrl(MSR_IA32_RTIT_ADDR0_A + i * 2, ctx->addr_a[i]);
>   		rdmsrl(MSR_IA32_RTIT_ADDR0_B + i * 2, ctx->addr_b[i]);
> @@ -7883,8 +7892,13 @@ static __init int hardware_setup(void)
>   
>   	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
>   		return -EINVAL;
> -	if (!enable_ept || !cpu_has_vmx_intel_pt())
> +	if (!enable_ept || !cpu_has_vmx_intel_pt()) {
>   		pt_mode = PT_MODE_SYSTEM;
> +	} else if (boot_cpu_has(X86_FEATURE_INTEL_PT)) {
> +		has_msr_rtit_cr3_match = intel_pt_validate_hw_cap(PT_CAP_cr3_filtering);
> +		has_msr_rtit_output_x = intel_pt_validate_hw_cap(PT_CAP_topa_output) ||
> +					intel_pt_validate_hw_cap(PT_CAP_single_range_output);
> +	}
>   
>   	setup_default_sgx_lepubkeyhash();
>   
> 

