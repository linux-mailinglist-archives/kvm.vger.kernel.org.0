Return-Path: <kvm+bounces-3709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C8FC0807417
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:57:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8A0FB20F4F
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 15:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B072145BEB;
	Wed,  6 Dec 2023 15:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dAEFV/8X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B950C137
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 07:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701878247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8sfdxoKgydhasOw2S4cUX/lHBXVSYArPHOpqmrg8Q+0=;
	b=dAEFV/8XXUGX9GHqrLIkBdmRmMJEsBLEKmB+iGI75uxL98SWfwrQ+0etKqqfLU4y/NhM4m
	Agh1p67gRD1XafrJ9Oggf9uy9LSyuLrdI/7kka7O7evCU8PcYkvMKpD6UNBaDOFM1UwVtI
	0Bt+VrBNx1ezEkbGgTiYrpb/mDPBcFs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342--yd3y7R1OZu_D-get9SNgA-1; Wed, 06 Dec 2023 10:57:25 -0500
X-MC-Unique: -yd3y7R1OZu_D-get9SNgA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40b4a837eb8so59410425e9.3
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 07:57:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701878244; x=1702483044;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8sfdxoKgydhasOw2S4cUX/lHBXVSYArPHOpqmrg8Q+0=;
        b=lmzWgArdkY2SWN8Y5ITac8Wl/04+9Y4hXMz13Msa/TqgkKDtDUJx8b22XyV/sgDFTN
         0lQXreVER5sXN4u6vZNCmhL1UbhImb//HEj26f/xjT40uwrWkPxCSxVB5YXpiyRkyvbn
         Myh06fFOnudRPu8ryu3a30kqgoraa9K8958K0Uj+jZLS5aUd8seM0HjRkwmwRmNvnoIY
         X6SZ6OkTpDJNZNWhD9AM3IdQqDlj0kcgdu+aGNuTIbsby7ZDdp1EgDpqVgEKgIlbueDV
         26lBNe5NVwcmdxQxdpL+IBAXX+zLHfCHWFnISmk1bKR2oBffqyzWEIbBlWQE+l3ErMDE
         BS2w==
X-Gm-Message-State: AOJu0YyJYTPxXgMmry7UywCBjEOCoLnzA/yqpxnQhBsmfFvVViO/ehjB
	qHNv4AcnCRR1UW5BRMW1kWe30nkpfpZBCzR/J1uYjqWFZV5imU+Yq8ntA4xoVMjRE4YVNATGkGt
	9UChOL7Gd9SeX
X-Received: by 2002:a05:600c:2044:b0:40b:5e59:da9d with SMTP id p4-20020a05600c204400b0040b5e59da9dmr760889wmg.176.1701878244345;
        Wed, 06 Dec 2023 07:57:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHxJ/hfBS9snUizlX9qsHL4DO/N1vW1ATTIz2jHA5+RV3BQEgPiq2ZyCOSdbJL9p8BpS3UlUw==
X-Received: by 2002:a05:600c:2044:b0:40b:5e59:da9d with SMTP id p4-20020a05600c204400b0040b5e59da9dmr760883wmg.176.1701878243952;
        Wed, 06 Dec 2023 07:57:23 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id o17-20020a05600c4fd100b0040b4fca8620sm84489wmq.37.2023.12.06.07.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 07:57:23 -0800 (PST)
Message-ID: <039eaa7c35020774b74dc5e2d03bb0ecfa7c6d60.camel@redhat.com>
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 dave.hansen@intel.com,  pbonzini@redhat.com, seanjc@google.com,
 peterz@infradead.org, chao.gao@intel.com,  rick.p.edgecombe@intel.com,
 john.allen@amd.com
Date: Wed, 06 Dec 2023 17:57:21 +0200
In-Reply-To: <a3a14562-db72-4c19-9f40-7778f14fc516@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-3-weijiang.yang@intel.com>
	 <c22d17ab04bf5f27409518e3e79477d579b55071.camel@redhat.com>
	 <cdf53e44-62d0-452d-9c06-5c2d2ce3ce66@intel.com>
	 <20d45cb6adaa4a8203822535e069cdbbf3b8ba2d.camel@redhat.com>
	 <a3a14562-db72-4c19-9f40-7778f14fc516@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-12-06 at 09:03 +0800, Yang, Weijiang wrote:
> On 12/5/2023 5:53 PM, Maxim Levitsky wrote:
> > On Fri, 2023-12-01 at 14:51 +0800, Yang, Weijiang wrote:
> > > On 12/1/2023 1:26 AM, Maxim Levitsky wrote:
> > > > On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> > > > > Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
> > > > > reflect true dependency between CET features and the user xstate bit.
> > > > > Enable the bit in fpu_kernel_cfg.max_features when either SHSTK or IBT is
> > > > > available.
> > > > > 
> > > > > Both user mode shadow stack and indirect branch tracking features depend
> > > > > on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
> > > > > xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.
> > > > > 
> > > > > Note, the issue, i.e., CPUID only enumerates IBT but no SHSTK is resulted
> > > > > from CET KVM series which synthesizes guest CPUIDs based on userspace
> > > > > settings,in real world the case is rare. In other words, the exitings
> > > > > dependency check is correct when only user mode SHSTK is available.
> > > > > 
> > > > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > > > Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > > > Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > > > ---
> > > > >    arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
> > > > >    1 file changed, 8 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > > > > index 73f6bc00d178..6e50a4251e2b 100644
> > > > > --- a/arch/x86/kernel/fpu/xstate.c
> > > > > +++ b/arch/x86/kernel/fpu/xstate.c
> > > > > @@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
> > > > >    	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
> > > > >    	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
> > > > >    	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
> > > > > -	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
> > > > >    	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
> > > > >    	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
> > > > >    };
> > > > > @@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
> > > > >    			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
> > > > >    	}
> > > > >    
> > > > > +	/*
> > > > > +	 * CET user mode xstate bit has been cleared by above sanity check.
> > > > > +	 * Now pick it up if either SHSTK or IBT is available. Either feature
> > > > > +	 * depends on the xstate bit to save/restore user mode states.
> > > > > +	 */
> > > > > +	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
> > > > > +		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
> > > > > +
> > > > >    	if (!cpu_feature_enabled(X86_FEATURE_XFD))
> > > > >    		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> > > > >    
> > > > I am curious:
> > > > 
> > > > Any reason why my review feedback was not applied even though you did agree
> > > > that it is reasonable?
> > > My apology! I changed the patch per you feedback but found XFEATURE_CET_USER didn't
> > > work before sending out v7 version, after a close look at the existing code:
> > > 
> > >           for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
> > >                   unsigned short cid = xsave_cpuid_features[i];
> > > 
> > >                   /* Careful: X86_FEATURE_FPU is 0! */
> > >                   if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
> > >                           fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
> > >           }
> > > 
> > > With removal of XFEATURE_CET_USER entry from xsave_cpuid_features, actually
> > > above check will clear the bit from fpu_kernel_cfg.max_features.
> > Are you sure about this? If we remove the XFEATURE_CET_USER from the xsave_cpuid_features,
> > then the above loop will not touch it - it loops only over the items in the xsave_cpuid_features
> > array.
> 
> No,  the code is a bit tricky, the actual array size is XFEATURE_XTILE_DATA( ie, 18) + 1, those xfeature bits not listed in init code leave a blank entry with xsave_cpuid_features[i] == 0, so for the blank elements, the loop hits (i != XFEATURE_FP && !cid) then the relevant xfeature bit for i is cleared in fpu_kernel_cfg.max_features. I had the same illusion at first when I replied your comments in v6, and modified the code as you suggested but found the issue during tests. Please double check it.

Oh I see now. IMHO the current code is broken, or at least it violates the 
'Clear XSAVE features that are disabled in the normal CPUID' comment, because
it also clears all xfeatures which have no CPUID bit in the table (except FPU,
for which we have a workaround).


How about we do this instead:

	for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
		unsigned short cid = xsave_cpuid_features[i];

		if (cid && !boot_cpu_has(cid))
			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
	}


The only side effect is that this code will not clear features bits for which kernel knows
no CPUID bit but kernel anyway clears _all_ features that it knows nothing about so there
is no net change in behavior.

(That is kernel only allows XFEATURE_MASK_USER_SUPPORTED | XFEATURE_MASK_SUPERVISOR_SUPPORTED)

Best regards,
	Maxim Levitsky



> > What I suggested was that we remove the XFEATURE_CET_USER from the xsave_cpuid_features
> > and instead do this after the above loop.
> > 
> > if (!boot_cpu_has(X86_FEATURE_SHSTK) && !boot_cpu_has(X86_FEATURE_IBT))
> >     fpu_kernel_cfg.max_features &= ~BIT_ULL(XFEATURE_CET_USER);
> > 
> > Which is pretty much just a manual iteration of the loop, just instead of checking
> > for absence of single feature, it checks that both features are absent.
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 
> > > So now I need
> > > to add it back conditionally.
> > > Your sample code is more consistent with existing code in style, but I don't want to
> > > hack into the loop and handle XFEATURE_CET_USER specifically.  Just keep the handling
> > > and rewording the comments which is also straightforward.
> > > 
> > > > https://lore.kernel.org/lkml/c72dfaac-1622-94cf-a81d-9d7ed81b2f55@intel.com/
> > > > 
> > > > Best regard
> > > > 	Maxim Levitsky
> > > > 
> > 
> > 



