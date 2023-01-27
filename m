Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFC867F101
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 23:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbjA0WPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 17:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbjA0WPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 17:15:23 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5718286EBE
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 14:15:21 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id j5so5883024pjn.5
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 14:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p1OM1KDXb9Qfz9gyDWmx+cdbCnJyOugwK6Di6FN+pM4=;
        b=tknPbBbY/BuP9xKGpbiwIDE12BkTb/uGULXxa41kQhP3ug6i4muvEqVRAp+soJ++27
         bpa1DX2Zl/s0Oe5ebh99rFixL1SBn0Z6EJJFzgUR5u99qsCW0kZTFGC0kAq5lQk5qQYx
         /JVe/h9NM6W1IQuM9L5NCkNkKP3sVzVdgXTr5OgZGsM4+4VrGJYymmmY9Tcfk9TDjzac
         ci3OT1TjgtdAa/bZjYi+YppIbRXdzroqth1BqZatRUJiuDEJD673/QGGy0IUtc/gyM/t
         1jTqohB24syztLvDiH93nscjloxyZ68o4S3GbQov9gg/pQzm/H3B052ScnygVxpn5oSm
         GK8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p1OM1KDXb9Qfz9gyDWmx+cdbCnJyOugwK6Di6FN+pM4=;
        b=yQlNkLWRU11ZSDL6JEghC7B8d99mEp5vtoUfTrTcQSSymEhiXLiMlXnL1ExNsC31lU
         RJVqjkbE02YzVLa6IHZG1hmDiZEFDp+Gwgd4XmazExBIwzNHlggc+th/jTsDW4Ysw8uB
         GA1Tn5GTJa2m44REUqVoYs4SMRfmKsb2buu3wJq3/2V22ulIzJYqDuaL7us+tjoShWOr
         PmlRYQpQ/osAuo/fKPPugucRG8KbBnmCwRQrwMCjUb03Ad2R2sqGNwhMLIkDVspJkFGk
         v7sYvHWrR6/b/+LbWiOsu7QJkVUhQLoJ24LWb3mi3tb2jJysPCdtI9WagfnBXQpvPl8V
         oibA==
X-Gm-Message-State: AO0yUKU6A0//dGhhpY2p2WTUYz06GNi5RLPLmwgOrHKDKRTtKrvd8UvE
        7rFid+kaAZg54bmYdTPi9//jFw==
X-Google-Smtp-Source: AK7set/dfl3SMw9T0vaX3jTrYx4cah3xDIfPXHg+NIow16SNVI2DXH1eHSxqEkudoR+OqX6mAaqR8w==
X-Received: by 2002:a05:6a20:c18c:b0:b8:e33c:f160 with SMTP id bg12-20020a056a20c18c00b000b8e33cf160mr171347pzb.0.1674857720691;
        Fri, 27 Jan 2023 14:15:20 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c64-20020a624e43000000b00586fbbdf6e4sm3126948pfb.34.2023.01.27.14.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 14:15:19 -0800 (PST)
Date:   Fri, 27 Jan 2023 22:15:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v2 15/15] KVM: x86/cpuid: Advertise Arch LBR feature in
 CPUID
Message-ID: <Y9RM8ytJYLDIVMpq@google.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-16-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125040604.5051-16-weijiang.yang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022, Yang Weijiang wrote:
> Add Arch LBR feature bit in CPU cap-mask to expose the feature.
> Only max LBR depth is supported for guest, and it's consistent
> with host Arch LBR settings.
> 
> Co-developed-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 36 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 85e3df6217af..60b3c591d462 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -134,6 +134,19 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
>  		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
>  			return -EINVAL;
>  	}
> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
> +		best = cpuid_entry2_find(entries, nent, 0x1c, 0);
> +		if (best) {
> +			unsigned int eax, ebx, ecx, edx;
> +
> +			/* Reject user-space CPUID if depth is different from host's.*/
> +			cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);
> +
> +			if ((eax & 0xff) &&
> +			    (best->eax & 0xff) != BIT(fls(eax & 0xff) - 1))
> +				return -EINVAL;
> +		}
> +	}

Drop this.  While I think everyone agrees that KVM's CPUID uAPI sucks, the status
quo is to let userspace shoot itself in the foot.  I.e. disallow enabling LBRs
with a "bad" config, but don't reject the ioctl().

>  
>  	/*
>  	 * Exposing dynamic xfeatures to the guest requires additional
> @@ -652,7 +665,7 @@ void kvm_set_cpu_caps(void)
>  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>  		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>  		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
> -		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16)
> +		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(ARCH_LBR)

As mentioned earlier, omit this and make it opt-in.

>  	);
>  
>  	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> @@ -1074,6 +1087,27 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  				goto out;
>  		}
>  		break;
> +	/* Architectural LBR */
> +	case 0x1c: {
> +		u32 lbr_depth_mask = entry->eax & 0xff;
> +
> +		if (!lbr_depth_mask ||
> +		    !kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
> +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +			break;
> +		}
> +		/*
> +		 * KVM only exposes the maximum supported depth, which is the
> +		 * fixed value used on the host side.
> +		 * KVM doesn't allow VMM userspace to adjust LBR depth because
> +		 * guest LBR emulation depends on the configuration of host LBR
> +		 * driver.
> +		 */
> +		lbr_depth_mask = BIT((fls(lbr_depth_mask) - 1));

C'mon.  More unnecessary dependencies on perf using the max depth.

> +		entry->eax &= ~0xff;
> +		entry->eax |= lbr_depth_mask;
> +		break;
> +	}
>  	/* Intel AMX TILE */
>  	case 0x1d:
>  		if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
> -- 
> 2.27.0
> 
