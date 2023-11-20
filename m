Return-Path: <kvm+bounces-2060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2C37F124D
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 12:41:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B36BB21986
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 11:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B6516405;
	Mon, 20 Nov 2023 11:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MN8pTi4Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9058783
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 03:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700480478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XroWRvXs+Y4iSNm22W3/JdNTVL8TEZs8UV4UrMaRAU8=;
	b=MN8pTi4QohD/hwnx3yVhDYCabf81s7Tz/57W9xj2pS6Qq440tqwpfA6HuzvNXQCVB7p7Vs
	VaI/EvtIze4PngSs6sk+0H3cvAB376f7euXme48SypYC85cXNc8fzf4Oa9/9PhNhunpWd3
	230zWr4DQLnEqLXFDMcO76jYc71UjxA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-59_vxH4kMmW6A_xDQ2KJAQ-1; Mon, 20 Nov 2023 06:41:17 -0500
X-MC-Unique: 59_vxH4kMmW6A_xDQ2KJAQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-32d9cd6eb0bso2339486f8f.0
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 03:41:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700480476; x=1701085276;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XroWRvXs+Y4iSNm22W3/JdNTVL8TEZs8UV4UrMaRAU8=;
        b=CA0MAwy0jUbqSpoVNrdfKmo9kX9QP5BsP4jM5pEewQ20Bilm4pir5/G+srbiDU7dID
         AlbIl6UOxUUdzHXo0F7UQ54t4/qXqUk4cXNPqoSReYn9QxZoqIhWZzgc0ma/P/eGtZTJ
         sn0NCc9YZAuML+Tc+yukVyjRdn7De1LjtoN3lsI3aet1108/IzsAUjKTmPtiIJ9mjv3q
         IxXxpetj/OC5xrQqFpdpMG2xv/eH0fC0o1KKFFBI8RGCl8Otc5qoIvyv5HkpsGTP3yGr
         W+KDJAHg0iwiK9J/rXcuJ5zH6WRbiAG/xEzByHUoK3/RIX1Q2kbPjzivP8EXvKIU+e6g
         e+rA==
X-Gm-Message-State: AOJu0YxiNLZwoHnw3dbenvgx3spapD3ZFCFfPy9dmhVILYEbg/jZc+PN
	SuhJqSURpHBD/p1/I4jfbWHraSlr+nyLmbwIIyUN2aj02b3Pr998E2v4b7SSr6TGpj2qWhYATXn
	bjBmJGpq/Jc29VaHZuKVK
X-Received: by 2002:adf:8b5e:0:b0:331:6945:9d11 with SMTP id v30-20020adf8b5e000000b0033169459d11mr4491913wra.71.1700480475875;
        Mon, 20 Nov 2023 03:41:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQeYavQxEh9X/79Cw3cos/8euUJrt0jtYgzKPT2aR6UAKDUJgVcLEnoC7Ho8gMeRLd6M44Tw==
X-Received: by 2002:adf:8b5e:0:b0:331:6945:9d11 with SMTP id v30-20020adf8b5e000000b0033169459d11mr4491896wra.71.1700480475496;
        Mon, 20 Nov 2023 03:41:15 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id v9-20020a5d5909000000b0032f9688ea48sm10955278wrd.10.2023.11.20.03.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 03:41:15 -0800 (PST)
Message-ID: <8018a697eae37a5e749afcb19368ac7c32b91d57.camel@redhat.com>
Subject: Re: [PATCH 1/2] Revert "nSVM: Check for reserved encodings of
 TLB_CONTROL in nested VMCB"
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Stefan Sterz
	 <s.sterz@proxmox.com>
Date: Mon, 20 Nov 2023 13:41:13 +0200
In-Reply-To: <20231018194104.1896415-2-seanjc@google.com>
References: <20231018194104.1896415-1-seanjc@google.com>
	 <20231018194104.1896415-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-10-18 at 12:41 -0700, Sean Christopherson wrote:
> Revert KVM's made-up consistency check on SVM's TLB control.  The APM says
> that unsupported encodings are reserved, but the APM doesn't state that
> VMRUN checks for a supported encoding.  Unless something is called out
> in "Canonicalization and Consistency Checks" or listed as MBZ (Must Be
> Zero), AMD behavior is typically to let software shoot itself in the foot.
> 
> This reverts commit 174a921b6975ef959dd82ee9e8844067a62e3ec1.
> 
> Fixes: 174a921b6975 ("nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB")
> Reported-by: Stefan Sterz <s.sterz@proxmox.com>
> Closes: https://lkml.kernel.org/r/b9915c9c-4cf6-051a-2d91-44cc6380f455%40proxmox.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 15 ---------------
>  1 file changed, 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 3fea8c47679e..60891b9ce25f 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -247,18 +247,6 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
>  	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
>  }
>  
> -static bool nested_svm_check_tlb_ctl(struct kvm_vcpu *vcpu, u8 tlb_ctl)
> -{
> -	/* Nested FLUSHBYASID is not supported yet.  */
> -	switch(tlb_ctl) {
> -		case TLB_CONTROL_DO_NOTHING:
> -		case TLB_CONTROL_FLUSH_ALL_ASID:
> -			return true;
> -		default:
> -			return false;
> -	}
> -}
> -
>  static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>  					 struct vmcb_ctrl_area_cached *control)
>  {
> @@ -278,9 +266,6 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>  					   IOPM_SIZE)))
>  		return false;
>  
> -	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
> -		return false;
> -
>  	if (CC((control->int_ctl & V_NMI_ENABLE_MASK) &&
>  	       !vmcb12_is_intercept(control, INTERCEPT_NMI))) {
>  		return false;


Yes, after checking Jim's comment (*) on this I still agree that revert is OK.
KVM never passes through the tlb_ctl field (but does copy it to the cache),
thus there is no need to sanitize it.

https://www.spinics.net/lists/kvm/msg316072.html


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


