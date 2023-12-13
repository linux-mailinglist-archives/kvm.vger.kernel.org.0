Return-Path: <kvm+bounces-4337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 426E78112F4
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 14:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F34262821CB
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EBBC2D057;
	Wed, 13 Dec 2023 13:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jEyh2AC1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA5D111
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 05:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702474313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gQtkRA/2TDpcW18aYB4J7SwpoOh/Je4S8M49iURqxd8=;
	b=jEyh2AC1nGfBQWt5OCZIJejs6TCmQiWBCrTAEUngVjj3DPvAC7/oNzuZZ3UPxj7Ynq+xqA
	zaILwy/7HUtAjvU2w+iPGZVOMWwYlkE4ZAV7WPhpFvCjhDBSsZ1acmrpfymdJqrIk3reuF
	0jNraP4308bk1y4OqSbdi7yMahau9kM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-eaoKHo90MxugDO1tZKnjfQ-1; Wed, 13 Dec 2023 08:31:52 -0500
X-MC-Unique: eaoKHo90MxugDO1tZKnjfQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40c514f9243so11202695e9.3
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 05:31:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702474311; x=1703079111;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gQtkRA/2TDpcW18aYB4J7SwpoOh/Je4S8M49iURqxd8=;
        b=K1ietQbLe8xTR7rimXzHO0Dw0/YZfoOuY6lEr+tCinbzXZRsugzYzZs1Jfcg+rnF5k
         6YXqgs2IN1Rm+L1WcGHHABe8eb392UMQQk+Aqpf0gl7uvH4wzvzWfyKeRfsTUfcEtDrg
         PHUmJePW/S/3QaFCZ/2s3nct+csqJDDWYsv11nTRx8BGzD6RPqU1waxUzCvyYDheuaPP
         MqG0bjlBWGe0Cl0dKCbIqSBNm00AjxjQLnrPkPd2yaCz6t8cx2ZLlQXCFKHdPZ6iSMn3
         fwPXPzzAfur6MEaWMP90x6lK2oEyibn4+QlBgC2u40xQ4gxHdpBLVDD4xBGndlMbT7kE
         XceA==
X-Gm-Message-State: AOJu0YxCr3TWbKGIo2/+fXdAzxFzjsjWujEEQVLk+IhTb6SsgPegea7c
	Jrd78F3CAkmN9OB1KRqFLV1qxgMrjwuYyFMkGdJyXwVdgfxbwGcbLFk4tGHiDY7uEPo12c8juSa
	U0jwW/3Bi5hlt
X-Received: by 2002:a05:600c:35c8:b0:40b:5e22:966 with SMTP id r8-20020a05600c35c800b0040b5e220966mr4019265wmq.85.1702474310854;
        Wed, 13 Dec 2023 05:31:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHz6/382oZVklkSfS7PyW38xqR9hfeJHgFvfuiQ5DRc+j3pBJLr2n9+6P9kv6aIsrbRQItCCg==
X-Received: by 2002:a05:600c:35c8:b0:40b:5e22:966 with SMTP id r8-20020a05600c35c800b0040b5e220966mr4019257wmq.85.1702474310423;
        Wed, 13 Dec 2023 05:31:50 -0800 (PST)
Received: from starship ([77.137.131.62])
        by smtp.gmail.com with ESMTPSA id q14-20020a05600c46ce00b0040c4c9c52a3sm8815394wmo.12.2023.12.13.05.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 05:31:50 -0800 (PST)
Message-ID: <47b946e58491b563f6ac572604b1bbc769100ff5.camel@redhat.com>
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, chang.seok.bae@intel.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 dave.hansen@intel.com,  pbonzini@redhat.com, seanjc@google.com,
 peterz@infradead.org, chao.gao@intel.com,  rick.p.edgecombe@intel.com,
 john.allen@amd.com
Date: Wed, 13 Dec 2023 15:31:48 +0200
In-Reply-To: <917a9dc4-bcae-4a1d-b5b5-d086431e8650@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-3-weijiang.yang@intel.com>
	 <c22d17ab04bf5f27409518e3e79477d579b55071.camel@redhat.com>
	 <cdf53e44-62d0-452d-9c06-5c2d2ce3ce66@intel.com>
	 <20d45cb6adaa4a8203822535e069cdbbf3b8ba2d.camel@redhat.com>
	 <a3a14562-db72-4c19-9f40-7778f14fc516@intel.com>
	 <039eaa7c35020774b74dc5e2d03bb0ecfa7c6d60.camel@redhat.com>
	 <eb30c3e0-8e13-402c-b23d-48b21e0a1498@intel.com>
	 <e7d7709a5962e8518ccb062e3818811cdbe110f8.camel@redhat.com>
	 <917a9dc4-bcae-4a1d-b5b5-d086431e8650@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-12-13 at 17:30 +0800, Yang, Weijiang wrote:
> On 12/8/2023 11:15 PM, Maxim Levitsky wrote:
> > On Fri, 2023-12-08 at 22:57 +0800, Yang, Weijiang wrote:
> > > On 12/6/2023 11:57 PM, Maxim Levitsky wrote:
> > > > On Wed, 2023-12-06 at 09:03 +0800, Yang, Weijiang wrote:
> > > > > On 12/5/2023 5:53 PM, Maxim Levitsky wrote:
> > > > > > On Fri, 2023-12-01 at 14:51 +0800, Yang, Weijiang wrote:
> > > > > > > On 12/1/2023 1:26 AM, Maxim Levitsky wrote:
> > > > > > > > On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> > > > > > > > > Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
> > > > > > > > > reflect true dependency between CET features and the user xstate bit.
> > > > > > > > > Enable the bit in fpu_kernel_cfg.max_features when either SHSTK or IBT is
> > > > > > > > > available.
> > > > > > > > > 
> > > > > > > > > Both user mode shadow stack and indirect branch tracking features depend
> > > > > > > > > on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
> > > > > > > > > xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.
> > > > > > > > > 
> > > > > > > > > Note, the issue, i.e., CPUID only enumerates IBT but no SHSTK is resulted
> > > > > > > > > from CET KVM series which synthesizes guest CPUIDs based on userspace
> > > > > > > > > settings,in real world the case is rare. In other words, the exitings
> > > > > > > > > dependency check is correct when only user mode SHSTK is available.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > > > > > > > Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > > > > > > > Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > > > > > > > ---
> > > > > > > > >      arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
> > > > > > > > >      1 file changed, 8 insertions(+), 1 deletion(-)
> > > > > > > > > 
> > > > > > > > > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > > > > > > > > index 73f6bc00d178..6e50a4251e2b 100644
> > > > > > > > > --- a/arch/x86/kernel/fpu/xstate.c
> > > > > > > > > +++ b/arch/x86/kernel/fpu/xstate.c
> > > > > > > > > @@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
> > > > > > > > >      	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
> > > > > > > > >      	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
> > > > > > > > >      	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
> > > > > > > > > -	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
> > > > > > > > >      	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
> > > > > > > > >      	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
> > > > > > > > >      };
> > > > > > > > > @@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
> > > > > > > > >      			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
> > > > > > > > >      	}
> > > > > > > > >      
> > > > > > > > > +	/*
> > > > > > > > > +	 * CET user mode xstate bit has been cleared by above sanity check.
> > > > > > > > > +	 * Now pick it up if either SHSTK or IBT is available. Either feature
> > > > > > > > > +	 * depends on the xstate bit to save/restore user mode states.
> > > > > > > > > +	 */
> > > > > > > > > +	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
> > > > > > > > > +		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
> > > > > > > > > +
> > > > > > > > >      	if (!cpu_feature_enabled(X86_FEATURE_XFD))
> > > > > > > > >      		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> > > > > > > > >      
> > > > > > > > I am curious:
> > > > > > > > 
> > > > > > > > Any reason why my review feedback was not applied even though you did agree
> > > > > > > > that it is reasonable?
> > > > > > > My apology! I changed the patch per you feedback but found XFEATURE_CET_USER didn't
> > > > > > > work before sending out v7 version, after a close look at the existing code:
> > > > > > > 
> > > > > > >             for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
> > > > > > >                     unsigned short cid = xsave_cpuid_features[i];
> > > > > > > 
> > > > > > >                     /* Careful: X86_FEATURE_FPU is 0! */
> > > > > > >                     if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
> > > > > > >                             fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
> > > > > > >             }
> > > > > > > 
> > > > > > > With removal of XFEATURE_CET_USER entry from xsave_cpuid_features, actually
> > > > > > > above check will clear the bit from fpu_kernel_cfg.max_features.
> > > > > > Are you sure about this? If we remove the XFEATURE_CET_USER from the xsave_cpuid_features,
> > > > > > then the above loop will not touch it - it loops only over the items in the xsave_cpuid_features
> > > > > > array.
> > > > > No,  the code is a bit tricky, the actual array size is XFEATURE_XTILE_DATA( ie, 18) + 1, those xfeature bits not listed in init code leave a blank entry with xsave_cpuid_features[i] == 0, so for the blank elements, the loop hits (i != XFEATURE_FP && !cid) then the relevant xfeature bit for i is cleared in fpu_kernel_cfg.max_features. I had the same illusion at first when I replied your comments in v6, and modified the code as you suggested but found the issue during tests. Please double check it.
> > > > Oh I see now. IMHO the current code is broken, or at least it violates the
> > > > 'Clear XSAVE features that are disabled in the normal CPUID' comment, because
> > > > it also clears all xfeatures which have no CPUID bit in the table (except FPU,
> > > > for which we have a workaround).
> > > > 
> > > > 
> > > > How about we do this instead:
> > > > 
> > > > 	for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
> > > > 		unsigned short cid = xsave_cpuid_features[i];
> > > > 
> > > > 		if (cid && !boot_cpu_has(cid))
> > > > 			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
> > > > 	}
> > > I think existing code is more reasonable,  the side-effect of current code, i.e., masking out
> > > the unclaimed xfeature bits, sanitizes the bits in max_features at the first place, then following calculations derived from it become reasonable too.
> > 
> > I strongly disagree with that. Kernel already removes all features bits which it knows nothing about.
> > 
> > There is no need to also remove the xfeatures that it knows about but knows nothing about a CPUID bit.
> > For such features the kernel needs either to accept it (like FPU) or remove the feature from set of supported features.
> 
> Let me involve Chang, the author of the code in question.
> 
> Hi, Chang,
> In commit 70c3f1671b0c ("x86/fpu/xstate: Prepare XSAVE feature table for gaps in state component numbers"),
> you modified the loop as below:
>          for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
> -               if (!boot_cpu_has(xsave_cpuid_features[i]))
> +               unsigned short cid = xsave_cpuid_features[i];
> +
> +               /* Careful: X86_FEATURE_FPU is 0! */
> +               if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
>                          fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>          }
> 
> IMHO the change resulted functional change of the loop, i.e., before that only it only clears the bits without CPUIDs,
> but after the change, the side-effect of the loop will clear the bits of blank entries ( where xsave_cpuid_features[i] == 0 )
> since the loop hits (i != XFEATURE_FP && !cid), is it intended or something else?
> 
> 
100% agree.

Best regards,
	Maxim Levitsky


