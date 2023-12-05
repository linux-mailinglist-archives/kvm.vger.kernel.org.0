Return-Path: <kvm+bounces-3474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 06579804EC2
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:53:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B00B11F21390
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 09:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70DD74B5C6;
	Tue,  5 Dec 2023 09:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PDYoYaR0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEB2A7
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 01:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701770010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ru2Q8LqNVd+OfIoZSkL+gRLJdnRdSfTo4OU5DPaWpec=;
	b=PDYoYaR0gMfqm8nCz99VnvoGVsdMZPpgrdy8aeSR/uK4m04pkzTqqDtJ8EUuRtAIumTAtL
	PHsqjKDkl++hJjC6g8PUoxMKZYdg/0H5hipE9HoJdaJ5kdx5cWuctMCTqhAuipGfrSweZ6
	/AAwqjjxtE4quNZRGeY8qMqD+VJj/eA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-y40nIjA9NOS_B1EOSdWo5g-1; Tue, 05 Dec 2023 04:53:29 -0500
X-MC-Unique: y40nIjA9NOS_B1EOSdWo5g-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40b40234b64so42433625e9.0
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 01:53:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701770007; x=1702374807;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ru2Q8LqNVd+OfIoZSkL+gRLJdnRdSfTo4OU5DPaWpec=;
        b=AkDwEOnuPa3sLXaN9AC6GOKKfzvUSTeqhGHWNvsyaKuwqoBaZYzf+Y+PuLx3zs1e6E
         xvoVDGHbVpTr9+iML1HtKXvU2XogQ441vihBqeyB/Ugy3kfZ1T6Mp3j3blU4DJalQEqo
         MTX/UcCjSGTHRtKJvcjNqVvwXSvmdbHBELWpEVN+7o9xatQMXQ0C9O00csGuCUGshE1q
         3qDHPMe8bq3ykUSHsjaIKSlnFuXuTlCwaN3ai5UcxyrlWj1zUmaeNTapniIJDVx518/G
         KHAyZW+hIogINPgdVfl1pKoEMRVBUDPRscocu5g1fvmQqg+NnsXmoy6zbuYZIKniIukz
         Yc0w==
X-Gm-Message-State: AOJu0YynpM0LoDrR3ZuKuWGxG2PT/wdwBfO5vGEMzfVWM/R+a3YDZg4b
	1JRDdoCBKRDMid78lTK1VanATy/jR2i+EP5EcVVy1wcRvGbxzCz5i8QcEG+GYr+au95eg+R9ADg
	EppSw/ODXu6VCW1GDCF7y
X-Received: by 2002:a05:600c:4688:b0:40a:20f3:d127 with SMTP id p8-20020a05600c468800b0040a20f3d127mr311558wmo.35.1701770007515;
        Tue, 05 Dec 2023 01:53:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEUDPgWhFuD8g2XSbmPMaubU5h6S01wzv1LcabCc79waLe3iLvsP33xawM6QP4GRaBOLDkfxw==
X-Received: by 2002:a05:600c:4688:b0:40a:20f3:d127 with SMTP id p8-20020a05600c468800b0040a20f3d127mr311544wmo.35.1701770007169;
        Tue, 05 Dec 2023 01:53:27 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id c12-20020a056000104c00b00333339e5f42sm10701380wrx.32.2023.12.05.01.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 01:53:26 -0800 (PST)
Message-ID: <20d45cb6adaa4a8203822535e069cdbbf3b8ba2d.camel@redhat.com>
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 dave.hansen@intel.com,  pbonzini@redhat.com, seanjc@google.com,
 peterz@infradead.org, chao.gao@intel.com,  rick.p.edgecombe@intel.com,
 john.allen@amd.com
Date: Tue, 05 Dec 2023 11:53:24 +0200
In-Reply-To: <cdf53e44-62d0-452d-9c06-5c2d2ce3ce66@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-3-weijiang.yang@intel.com>
	 <c22d17ab04bf5f27409518e3e79477d579b55071.camel@redhat.com>
	 <cdf53e44-62d0-452d-9c06-5c2d2ce3ce66@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-12-01 at 14:51 +0800, Yang, Weijiang wrote:
> On 12/1/2023 1:26 AM, Maxim Levitsky wrote:
> > On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> > > Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
> > > reflect true dependency between CET features and the user xstate bit.
> > > Enable the bit in fpu_kernel_cfg.max_features when either SHSTK or IBT is
> > > available.
> > > 
> > > Both user mode shadow stack and indirect branch tracking features depend
> > > on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
> > > xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.
> > > 
> > > Note, the issue, i.e., CPUID only enumerates IBT but no SHSTK is resulted
> > > from CET KVM series which synthesizes guest CPUIDs based on userspace
> > > settings,in real world the case is rare. In other words, the exitings
> > > dependency check is correct when only user mode SHSTK is available.
> > > 
> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > ---
> > >   arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
> > >   1 file changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > > index 73f6bc00d178..6e50a4251e2b 100644
> > > --- a/arch/x86/kernel/fpu/xstate.c
> > > +++ b/arch/x86/kernel/fpu/xstate.c
> > > @@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
> > >   	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
> > >   	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
> > >   	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
> > > -	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
> > >   	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
> > >   	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
> > >   };
> > > @@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
> > >   			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
> > >   	}
> > >   
> > > +	/*
> > > +	 * CET user mode xstate bit has been cleared by above sanity check.
> > > +	 * Now pick it up if either SHSTK or IBT is available. Either feature
> > > +	 * depends on the xstate bit to save/restore user mode states.
> > > +	 */
> > > +	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
> > > +		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
> > > +
> > >   	if (!cpu_feature_enabled(X86_FEATURE_XFD))
> > >   		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> > >   
> > I am curious:
> > 
> > Any reason why my review feedback was not applied even though you did agree
> > that it is reasonable?
> 
> My apology! I changed the patch per you feedback but found XFEATURE_CET_USER didn't
> work before sending out v7 version, after a close look at the existing code:
> 
>          for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
>                  unsigned short cid = xsave_cpuid_features[i];
> 
>                  /* Careful: X86_FEATURE_FPU is 0! */
>                  if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
>                          fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>          }
> 
> With removal of XFEATURE_CET_USER entry from xsave_cpuid_features, actually
> above check will clear the bit from fpu_kernel_cfg.max_features. 

Are you sure about this? If we remove the XFEATURE_CET_USER from the xsave_cpuid_features,
then the above loop will not touch it - it loops only over the items in the xsave_cpuid_features
array.

What I suggested was that we remove the XFEATURE_CET_USER from the xsave_cpuid_features
and instead do this after the above loop.

if (!boot_cpu_has(X86_FEATURE_SHSTK) && !boot_cpu_has(X86_FEATURE_IBT))
   fpu_kernel_cfg.max_features &= ~BIT_ULL(XFEATURE_CET_USER);

Which is pretty much just a manual iteration of the loop, just instead of checking
for absence of single feature, it checks that both features are absent.

Best regards,
	Maxim Levitsky


> So now I need
> to add it back conditionally.
> Your sample code is more consistent with existing code in style, but I don't want to
> hack into the loop and handle XFEATURE_CET_USER specifically.  Just keep the handling
> and rewording the comments which is also straightforward.
> 
> > 
> > https://lore.kernel.org/lkml/c72dfaac-1622-94cf-a81d-9d7ed81b2f55@intel.com/
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 





