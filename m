Return-Path: <kvm+bounces-39793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62358A4A7E2
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 03:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2025E189A3FA
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 02:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C4A18FDAB;
	Sat,  1 Mar 2025 02:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fM4PWUSn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FACD2E630
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 02:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795205; cv=none; b=BDEDBHckE6j8w9fkjaDxVeu/loAnla5OE3+eEyWvTf61lsMo6iXX9dgWfMybptuYpNhajqGS8NA1Gnf4pvBnOxfA94cftN2K4DPOg6uOa0UCEK/H6fwM5b0Na6OobnL1cVePHKn98C0MN/tOhnuaFez8YEPHIeOaX0prgN32+7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795205; c=relaxed/simple;
	bh=T3w0SzYjhvJxk6k4bPntpWstEuXmDTnYB++0GwpZuVY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PdIbWLI0oDuf0L7b2XnEhFnmxwp+Qu0rIkDdmbgI7JviXJZadcyaMJe3HlkbTQ28FIb4hGeSW6Xjup4N24YNhAuht9suuX+s1EsWVHm2AkA2Q4LImu7B7pdzN/pJPUoOG/akxKSbLj5KFPz5PwZDo4GzNKk3GQnn9GTBCZoTIMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fM4PWUSn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740795201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=23HNObBRF7Awkr12Tspnod8eVeUfyWHo9QdOpe43DIM=;
	b=fM4PWUSnsPSlUZt0cAf5MUDV7OSVqhIADtcEg8MTUrUMNpx8x5g5PwNcLhsowSsx7ZvRSF
	kJSx5sz7vvFn8vjnskHJ1suvrKNiw76CYwVE/Ru+FX07/yrvdIfImXtyZBnN1Vu4vZrGCR
	04TRoQOjmrDv9HTMInp+UEOyvO90VmE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-327-NUavFBLKO7KcPcpcdbiIbA-1; Fri, 28 Feb 2025 21:13:19 -0500
X-MC-Unique: NUavFBLKO7KcPcpcdbiIbA-1
X-Mimecast-MFC-AGG-ID: NUavFBLKO7KcPcpcdbiIbA_1740795199
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6e8a04e1f91so51721456d6.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 18:13:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795199; x=1741399999;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=23HNObBRF7Awkr12Tspnod8eVeUfyWHo9QdOpe43DIM=;
        b=auEmk6kqlFwsp14Qkdelyldib2lJJjy+d8EYjzbVGNa6ZSA/K4Cf7B2R1kPsMZB2zF
         BQszbIWBC7wL7Jsehoe+RYbDCfSWWy/OsGf0+NSCyoQcQLB7pb8gus/DnSm1OShNsKj/
         EyHG9bKkxmCLjmhLok6lBWcJGDsCgIMhvSyps+Mf7IqZrFKx5dyHSjoDqK39BYKxq3i0
         tstz5I0zDdCCmJMpK4coLZS7y9NSVrG7GOodal2ekKDWipxlqkZ10VVywXzY8CKwSoaH
         f7laq21w13CYmXy78AauOfaKyaArbogTUYWIKbpccI+FXo0wod45Hr5Ug/KlC86FLFrZ
         7ABA==
X-Gm-Message-State: AOJu0Yzdfnt+6GLu2rJ5IiJhhPsDElheXINq5JW0dH5qFm6T0Q4yZjoL
	+EUqBdp2EpZUJ1R2+csG+CHqIYHfRh2dQVIfjvcSHGIIOK76Ag2cqTCfPvYwDVTDrrDF/bml389
	DmjgWpxsz3eiM1l8uNp914Vh+4r3eGootz9HC6G4vAl0KswOr4Q==
X-Gm-Gg: ASbGnctJacy7oEhWCziZt/dYlwL7ScPaQ837YarCc8P8LJwpGOIno51UDerVu+jTVYZ
	5puLMJiltkcyqnGydQtQOEKFdfnpQBrAebgkqFk8a+z+OuYxBtlhgeTc2QpHlYtzLepULGOzXmq
	3L+MLCsYRhBv2AW9i88+s2ZPkS2POhj1PCpBpJjT5klRX4yjxwN6AEWmnANwqXhkO6BwD+yMtfn
	S3opo+1JxhiqmDodGWPywDsQ+MuwHpbCW3+Wjd9d0ILRauEW16EXAuiLPKoo/IqYj/uONHyCfjG
	I4DLG1JE1DmsoMo=
X-Received: by 2002:ad4:5ec9:0:b0:6d4:c6d:17fe with SMTP id 6a1803df08f44-6e8a0d066f7mr100418696d6.25.1740795199458;
        Fri, 28 Feb 2025 18:13:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHby/pOI2/cjHxNFtoBza6WhUyo/Cy0uLxM68AvvFaPCh8WDcdpymODwF1urcBd/yOvWHIP9A==
X-Received: by 2002:ad4:5ec9:0:b0:6d4:c6d:17fe with SMTP id 6a1803df08f44-6e8a0d066f7mr100418576d6.25.1740795199220;
        Fri, 28 Feb 2025 18:13:19 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e89765347bsm28371566d6.37.2025.02.28.18.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 18:13:18 -0800 (PST)
Message-ID: <a8d8a373b41dbc72d007f60e83dcb7ee596a5ad5.camel@redhat.com>
Subject: Re: [RFC PATCH 10/13] KVM: nSVM: Flush the TLB if L1 changes L2's
 ASID
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Feb 2025 21:13:18 -0500
In-Reply-To: <20250205182402.2147495-11-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-11-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> KVM tracks a single ASID for L2 guests. L1 could change the ASID it has
> assigned L2 due to switching to a different L2 guest or simply to avoid
> flushing L2's existing ASID. Flush L2's TLB when this happens to avoid
> reusing TLB entries from the old ASID (from L1's perspective).
> 
> Remove the comment in __nested_copy_vmcb_control_to_cache() about the
> cached ASID usage, as this changes makes it stale by adding another
> usage.
> 
> This is heavily inspired by nVMX's handling of last_vpid.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 5 ++++-
>  arch/x86/kvm/svm/svm.h    | 2 ++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index e2c59eb2907e8..12bb391884299 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -368,7 +368,6 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  	to->pause_filter_count  = from->pause_filter_count;
>  	to->pause_filter_thresh = from->pause_filter_thresh;
>  
> -	/* Copy asid here because nested_vmcb_check_controls will check it.  */
>  	to->asid           = from->asid;
>  	to->msrpm_base_pa &= ~0x0fffULL;
>  	to->iopm_base_pa  &= ~0x0fffULL;
> @@ -509,6 +508,10 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
>  		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
>  	}
>  
> +	if (svm->nested.ctl.asid != svm->nested.last_asid) {
> +		svm->nested.last_asid = svm->nested.ctl.asid;
> +		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> +	}

>  	/*
>  	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
>  	 * things to fix before this can be conditional:
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 6a73d6ed1e428..f2352135b99d3 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -211,6 +211,8 @@ struct svm_nested_state {
>  	 * on its side.
>  	 */
>  	bool force_msr_bitmap_recalc;
> +
> +	u32 last_asid;
>  };
>  
>  struct vcpu_sev_es_state {


I can't be 100% sure but overall the patch looks correct to me.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


