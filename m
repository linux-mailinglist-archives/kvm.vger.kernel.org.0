Return-Path: <kvm+bounces-39194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A38DA4503F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 23:34:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE9FE188D429
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C1C1EDA19;
	Tue, 25 Feb 2025 22:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cX/ZfDhb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC9F211A20
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 22:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740522776; cv=none; b=CnRNFnGFAPqPA9rnAdzyPxIN+jASfBjtP3h/5UaPfm7hdl0dNp/l7ooxdjf/b0E9/Auo34VdykAVPmWSXGPm1Xr27gxsp54LjIfAA3+zORFHUYdX3OzhVGLM4vqkgVS1qWWy1pUMSRTuN12fLoEe9pNWuKKoec+kh0ZwQ4PfkgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740522776; c=relaxed/simple;
	bh=ASZpiCaz/lujoT+hKvH2SvCb3OzGoif6hv9DMAwNjF0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FlYVz+QLOzZNg8OH9NhjphVEhf/OGANBs9ItCOiv5oQPzz5WuwJc2rUIBl1y4C4RLZ/2LcvVMcDYqrp6XUE5V1OpFLpHbUXfmr0MWuKa9vwOPr5yP5hqfFUZMgGsMT3SnkqqtjCNXsnCotLHVMN6RLTwnUf3HQDb3h+KpWkq3Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cX/ZfDhb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc0bc05bb5so12678420a91.2
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 14:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740522774; x=1741127574; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jGwMJeTN+dKZHBUUmf4B4DWcKF/PGoO9rdnWonYrQT4=;
        b=cX/ZfDhbchmpkuHqIBbEKjzXthQFuJZuxO0MOIT9drK22A1KoQuL/ceXy6wPa8qlI+
         aXD32f0NFjSoMIEXdF3YnCUDpVBfQrSV3pW4DF4omsxar4l3hyXwvmYTKxxAUVQGWeYd
         tdLWDiR/SBR+85eLXzbTzAnG4exYK5krHWpTyqeuZkabqr4H/pQ1pfAQSWthtHYwdkN0
         +2i14CN4j9AJTT8rQ5KlJ6rrXJU2025RBeP77yGargK1oxBS5GeTrSE7EwXR8HhqRSi/
         ISrLU8RtKtaqh4KPsvIkgcMUYQCf9z8UjTVIKayxFonpDe4ONvqr5p1iOCqLiYQJTb41
         IQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740522774; x=1741127574;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jGwMJeTN+dKZHBUUmf4B4DWcKF/PGoO9rdnWonYrQT4=;
        b=pxTl/5p3UNqrm9W8MXQwoMiJn9AWf4J+3ZSHfrITUuyHQetCeDTbjJGEgAZXSfksyK
         zEmrd4YFlrVKLM7wiSyoDPWpXkMWNKdkWb3lbxtzDQUQbxcecVRsTT8BDQQZ/wEj9vum
         /C7VUeNX2C4VvYwuXjVYTBy7zr+EHN2wLjBu7EJU3VwzYatlX3VJl2gJ+Y5QkRSaV+ck
         cZOzVJh67J6mrxk2fhRbb04fhvf84C0d8iKWLCO4RhvMOfl84wVzopJBoA33hBuHfWAk
         18IOlYSCSgtlG/FowY1oqzKvR7ZMQlfJ+ukgMKk8/8g92NAV3SoUqdtwamJJNDqpwiV/
         uU7g==
X-Forwarded-Encrypted: i=1; AJvYcCXzL4rvZdS+04CbSOOtJhFwdxvuW4y4NefgVAylX6T8uJEvQIgZvgZ+ZvZVEaczgIG9FKo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVFJJ/bJ/gG0+SXWMMH6e/Jljv8Ls9VTGDl+dDpthrd41vpfAK
	PnSrZmuz7/7n/5CPis9jaxgKx9qn5ldAuglWnQEpbgIB+g2OmoyN9P9sjj+km+zzWiXJDw3cnHf
	9Yw==
X-Google-Smtp-Source: AGHT+IFdywSgZgWisiM3fsWoKNuqZEmY/ulK9kNQX86fbh4TBv6Dn9TbtR9/PAKzKbHi2Sbm54RZsl1lrMs=
X-Received: from pjbqd16.prod.google.com ([2002:a17:90b:3cd0:b0:2ef:8a7b:195c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ecf:b0:2ee:f19b:86e5
 with SMTP id 98e67ed59e1d1-2fe68ada443mr9176092a91.14.1740522774713; Tue, 25
 Feb 2025 14:32:54 -0800 (PST)
Date: Tue, 25 Feb 2025 14:32:53 -0800
In-Reply-To: <20250225213937.2471419-3-huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250225213937.2471419-1-huibo.wang@amd.com> <20250225213937.2471419-3-huibo.wang@amd.com>
Message-ID: <Z75FFZqPLyJgt-4g@google.com>
Subject: Re: [PATCH v5 2/2] KVM: SVM: Provide helpers to set the error code
From: Sean Christopherson <seanjc@google.com>
To: Melody Wang <huibo.wang@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Paluri PavanKumar <pavankumar.paluri@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 25, 2025, Melody Wang wrote:
> @@ -3675,8 +3673,13 @@ static void snp_complete_psc(struct vcpu_svm *svm, u64 psc_ret)
>  	svm->sev_es.psc_inflight = 0;
>  	svm->sev_es.psc_idx = 0;
>  	svm->sev_es.psc_2m = false;
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
> -}
> +
> +	/*
> +	 * A value of zero in SW_EXITINFO1 does not guarantee that all operations have

"A value of zero" is largely redundant, and somewhat confusing.  There's no '0'
in the below code, so to understand the comment, the reader needs to know that
"no action" is a response code of '0' (and is communicated in SW_EXITINFO1,
though that's much less of a problem).

> +	 * completed or completed successfully.  PSC requests always get a "no action"
> +	 * response in SW_EXITINFO1, with a PSC-specific return code in SW_EXITINFO2.

Please wrap at ~80.  Yes, it's a "soft limit", but preferred KVM style is to
wrap at 80 unless running long makes the code more readable.  For a multi-line
comment, I don't see any reason to wrap in the mid-80s.

This is what I ended up with

	/*
	 * PSC requests always get a "no action" response in SW_EXITINFO1, with
	 * a PSC-specific return code in SW_EXITINFO2 that provides the "real"
	 * return code.  E.g. if the PSC request was interrupted, the need to
	 * retry is communicated via SW_EXITINFO2, not SW_EXITINFO1.
	 */

> +	 */
> +	svm_vmgexit_no_action(svm, psc_ret); }

Malformed change to the closing curly brace.

>  	case SVM_VMGEXIT_HV_FEATURES:
> -		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_HV_FT_SUPPORTED);
> +		/* Get hypervisor supported features */

This doesn't add any value.  If the logic isn't clear, then GHCB_HV_FT_SUPPORTED
needs to be renamed.

> +		svm_vmgexit_success(svm, GHCB_HV_FT_SUPPORTED);
>  
>  		ret = 1;
>  		break;

