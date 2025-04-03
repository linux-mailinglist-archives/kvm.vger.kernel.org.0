Return-Path: <kvm+bounces-42600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 027B6A7AFF6
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AFD118949BE
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464B025484C;
	Thu,  3 Apr 2025 20:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fupkTVY+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92632550D5
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743710454; cv=none; b=bxSa10rccS84daJdHXRt33zfyofsKnQEKl4QuCgL/lF2OKXJtf+DMPgFHERls4wAunts5fzYc6eOih0C4X0/zIQV/QLGwCQSw1pR4lyFtGh9LdcVe15RAW2BUzXUgtSk5dtSqeyjKQuoei3AjIuDJ3030onvbvEvKkVjrhHvPR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743710454; c=relaxed/simple;
	bh=ryx0wKASwy0uhjPxQ442PdmmlD6H1YH4TXONa9Q+FyE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qUzjjb8aNRH5EII9LLe9MxzCy8iesplXHvM8tN6qt6+BwvC4ZfI85XAjKm6aG/BaC1n/w2va0XwDeakH+Q29OC0rSSWleDcT6yQe+e/KR1ljucRJjKtNiqV36zxYh2e7rP9X3C83ESLFUXi3BNdYkYql031HBvZPotzWPf78qAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fupkTVY+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743710452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GLNI9VGp1Wm5rLYd57L0Xp4ipMewoWDjGcDvpy893AU=;
	b=fupkTVY+XtVNmeq9hmrxSK583UQKbjMfXged14o2Nx4aFzrIhuO0T9eG28IAEWWWVqByV2
	KSFT1SVVwQXes1xYuWASNhD8+MKZyAHyM3RjgHWPELxo9YiEXG7PECJ8uMCfs2iCIaR83a
	6aQUi6rzTFgauoIHdUJCxXeWiGaKznA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-i9oIFfYnPQKA6RWDkl8Sbg-1; Thu, 03 Apr 2025 16:00:50 -0400
X-MC-Unique: i9oIFfYnPQKA6RWDkl8Sbg-1
X-Mimecast-MFC-AGG-ID: i9oIFfYnPQKA6RWDkl8Sbg_1743710450
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e8ffb630ffso19992976d6.1
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:00:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743710450; x=1744315250;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GLNI9VGp1Wm5rLYd57L0Xp4ipMewoWDjGcDvpy893AU=;
        b=cSF1Ne2Lk12fMEiZm8ah6xC4uUTQrBrJYLRne8JZGHKLK4GQQvKwaJqjT04lzvN9Et
         ngeNjG9jPtEv9SjHonF1zjF9lNgG7twsnh1t7ClYP3IkERIin2H10IfMubBTt7mYPMyD
         S24whJY6Wr7aKW9sZQbpgIo7TBwZV2PFD0WEalzhLb4Fg+ShQu9LdnCPrdeHbFJ/tGRi
         GJwMDRooXkclq+gBvfQTo+RS1ptpSW7UvAt09j6ZaHChXS6ZnIYE7nnehz3Lx6Xl34Gx
         Z9Sp30LEsYLnnUwa9jJcevwhPqJ593PfjlXL2PCEJKZ5Jt5o3jq3tX98qyoxg9gVmWP8
         4XYg==
X-Forwarded-Encrypted: i=1; AJvYcCXWP+Lumo6YUIKSCfKAkk32xDmK9eyztH1V+f1nwRGee58WIhbGAD7tP96jaVrk12bjWMg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk6kiXjqWAWkUcS6oOSYTw13rXXqeRGo0OUNhs/mOcXywbJunT
	TZ4CRIalG2sYFP/ARuwRPP6X1YsVMpnfNFz6tULER+F3A+DnEyUFICj0rWSFP5pNUxJly8VdanP
	mms56FmmKraB4auP+42i7YbjQjtbPDOd5QHZdSTwhxGHVFdFTLD6ESjZyXw==
X-Gm-Gg: ASbGnctBHb/+3jyy5ZAow4zF4xUqa5jYkaFP2CHZyPJWajtfIxhM62iMCZHcLVm+trH
	gnjX3VQK2xllGifgFRpgh3vVquXHCgtU3ADwziCXYw3BhPxSsDv+gwINUfk0LJ+3ZFjRU3nPJIV
	dUwiD5FMn3sYHkA2sV3Lwg0NK9IpXKl7fhNBe91LLWyDzpPq6Keg4H5Mjd22Bw0Ktda2mxgQSj/
	7+JOXOnYBbYunNely2MgYryuzuQ4CZ2BWqxUFLJHC5mzv+ZT+SDtn1fUPIeBbvVSMb52lfYy1vM
	0UsnLuZuQpQlfHI=
X-Received: by 2002:a05:6214:248f:b0:6ed:df6:cdcd with SMTP id 6a1803df08f44-6f00df1f687mr7864256d6.21.1743710450193;
        Thu, 03 Apr 2025 13:00:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEH3RbFcRIn58HCTEBNM31yCVKIBXI1JJ0q3Y51iA0rFaC8CQitL64IgDIZqaz1u52zOEzV7w==
X-Received: by 2002:a05:6214:248f:b0:6ed:df6:cdcd with SMTP id 6a1803df08f44-6f00df1f687mr7863656d6.21.1743710449849;
        Thu, 03 Apr 2025 13:00:49 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ef0f00ec2esm11313456d6.47.2025.04.03.13.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:00:49 -0700 (PDT)
Message-ID: <9db2d6e6124227fcda51bce5ac3169c3450685fb.camel@redhat.com>
Subject: Re: [RFC PATCH 04/24] KVM: SVM: Flush everything if FLUSHBYASID is
 not available
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:00:48 -0400
In-Reply-To: <20250326193619.3714986-5-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-5-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-03-26 at 19:35 +0000, Yosry Ahmed wrote:
> Currently, if FLUSHBYASID is not available when performing a TLB flush,
> the fallback is decrementing the ASID generation to trigger allocating a
> new ASID. In preparation for using a static ASID per VM, just fallback
> to flushing everything if FLUSHBYASID is not available. This is probably
> worse from a performance perspective, but FLUSHBYASID has been around
> for ~15 years and it's not worth carrying the complexity.
> 
> The fallback logic is moved within vmcb_set_flush_asid(), as more
> callers will be added and will need the fallback as well.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/svm.c | 5 +----
>  arch/x86/kvm/svm/svm.h | 5 ++++-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 0e302ae9a8435..5f71b125010d9 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4005,10 +4005,7 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
>  	 * unconditionally does a TLB flush on both nested VM-Enter and nested
>  	 * VM-Exit (via kvm_mmu_reset_context()).
>  	 */
> -	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
> -		vmcb_set_flush_asid(svm->vmcb);
> -	else
> -		svm->current_vmcb->asid_generation--;
> +	vmcb_set_flush_asid(svm->vmcb);
>  }
>  
>  static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d2c49cbfbf1ca..843a29a6d150e 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -416,7 +416,10 @@ static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
>  
>  static inline void vmcb_set_flush_asid(struct vmcb *vmcb)
>  {
> -	vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
> +	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
> +		vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
> +	else
> +		vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
>  }
>  
>  static inline void vmcb_clr_flush_asid(struct vmcb *vmcb)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




