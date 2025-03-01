Return-Path: <kvm+bounces-39796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88BEAA4A7FE
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 03:22:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D564D7A90A2
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 02:21:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E916190674;
	Sat,  1 Mar 2025 02:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X3m1gSYa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA8523C9
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 02:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795721; cv=none; b=iqQYUTIIja+ukpoer+wkQpWuwVn/zkmO4Kpv/YfbPmn1Zffrl6sHTEg/AU0LlJCWeI4R56oB71bLR0kk1kLg2TSfmzC0yoNpHVaN99Jz70TQ2ajEjm30gSwAKkBJme1D6WU1XhVPaW/H5CqOciJR+N+t3908y0WCuqJZ9/nbNDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795721; c=relaxed/simple;
	bh=bDibNU9cIAoysHjLeD71zv5dAzOetWpaXTYTDB0yu6Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TDilBXcKaqJJbF6yk/lZa8S/wAV7LKtwtGzI8s9OaqpfZIT9q9lDtLehUcU2l+kodl/xBq0Wa/fW0Tr2W/HduyKqPDQ9P0tmGE09LaZ03dDJOLFVSEfeH6p5PwD2QNI62KO/l53xPntmn7jh03aX2F0spIn5evH+SxXI2YX15QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X3m1gSYa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740795718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WXZzwbUKVjbHG2DfVdm6JTcxzSxRdgemZS7ziWqrxzA=;
	b=X3m1gSYagx9qhYKjisIeV1iCmKBOvTwFNCD2xI5iQ0PC4QkcSvBDSxenJPgu9/YRqy5VpP
	577632JPyc3atc4QNP3Wd2cSd4gJHBZsSYsd9P4s93OgSRivQs8Xc7qAtaTNJaCTyL3TcO
	bVDYIWQ2Gqomuf3ALZg53AUxPfNZpac=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-VpMIG3g6MBG12dJtlsdrwA-1; Fri, 28 Feb 2025 21:21:56 -0500
X-MC-Unique: VpMIG3g6MBG12dJtlsdrwA-1
X-Mimecast-MFC-AGG-ID: VpMIG3g6MBG12dJtlsdrwA_1740795716
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c09f73873fso462629785a.1
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 18:21:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795716; x=1741400516;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WXZzwbUKVjbHG2DfVdm6JTcxzSxRdgemZS7ziWqrxzA=;
        b=ncpzQoMu0HOBCzJ5iiYptFhIRao1hbsEKe7jn/K9aTOSGMTL6zIw5G7BgIJNiFVjP/
         6zXrKk1Y1Pcam8a5k4f3ITCqsL+GV9xvJ0SLkDg07/JOmrdU2JYyvVzEXPTH2SjcZLfD
         cp1UkhlgOrKlAdCXF2zHn7EeQp7pWqzwPU6MwUXZH8KL9+2DsIiVD+t11+U09FICRGm1
         7ppD46pdtJrN1ranGtfYIoBPqDw5+KvR5VZnG3EKZJBuB/aJ6oe4BlAv25atbmbihKU3
         wmWGmGZrPDBl1e+cQDOIVqYw++bZpgiCo15TmFwmAP7CYgg9K6AszxyANwvzZsHkpE86
         95Ng==
X-Gm-Message-State: AOJu0YwEjGnsB2Xq0pQ0H8FGoJfDpHAsIiD5S3auX5AgDtlph60cy/XO
	POfK/BLiNGl1smBDBuVE0KKWSujYG3qp2wnkD1HdbnBoYznqdAkAuECclak2/GO7mz+tsH+0cbE
	gg0C9nPYKZBAwXVR7bIUBR8Op+kGedQhXsA7yqVSziavzQUDcaw==
X-Gm-Gg: ASbGncsvuYRfFZIq78bquVub62flYweaMg4yPw2wVbPGyJUMtkBhYaESN/TeWdDIxcJ
	l7o+ezSzvEGow7ouPRAFUjhH9G+uW+/zZkH6SesNzdr27PkQGy1r5LaE1AMBnUZzDOco3VD8COU
	9rLbhOUNwDJAnX97bGuV/4y1C7mpEns846bE/kCKY7IBDGygBYQgWhBAV+WaFjhlcoPMyaLSZ2Q
	+7DjmSMCn0ycF6pDM9VM+0mtU+MWODABWZz7vbSKOQA/GxV5K+z76Iyc5A9i1ih+l17+Iss58ml
	m5ZZJpYvEB5+8CU=
X-Received: by 2002:a05:620a:19a5:b0:7c0:a3bd:a780 with SMTP id af79cd13be357-7c39c6778e2mr1065106485a.54.1740795716029;
        Fri, 28 Feb 2025 18:21:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFiVIxPbDW0c91j7RHZ7nyiiGATb61if+LbTMCmwDxjsFDBjOg8jBIWHtm8xjrLPxUNjm8vAQ==
X-Received: by 2002:a05:620a:19a5:b0:7c0:a3bd:a780 with SMTP id af79cd13be357-7c39c6778e2mr1065104985a.54.1740795715763;
        Fri, 28 Feb 2025 18:21:55 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8976534c0sm28514006d6.40.2025.02.28.18.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 18:21:55 -0800 (PST)
Message-ID: <da0b13813b11e5b13f01dced9a629ac07fad27cd.camel@redhat.com>
Subject: Re: [RFC PATCH 13/13] KVM: nSVM: Stop bombing the TLB on nested
 transitions
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Feb 2025 21:21:54 -0500
In-Reply-To: <20250205182402.2147495-14-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-14-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-02-05 at 18:24 +0000, Yosry Ahmed wrote:
> Now that nested TLB flushes are properly tracked with a well-maintained
> separate ASID for L2 and proper handling of L1's TLB flush requests,
> drop the unconditional flushes and syncs on nested transitions.
> 
> On a Milan machine, an L1 and L2 guests were booted, both with a single
> vCPU, and pinned to a single physical CPU to maximize TLB collisions. In
> this setup, the cpuid_rate microbenchmark [1] showed the following
> changes with this patch:
> 
> +--------+--------+-------------------+----------------------+
> > L0     | L1     | cpuid_rate (base) | cpuid_rate (patched) |
> +========+========+===================+======================+
> > NPT    | NPT    | 256621            | 301113 (+17.3%)      |
> > NPT    | Shadow | 180017            | 203347 (+12.96%)     |
> > Shadow | Shadow | 177006            | 189150 (+6.86%)      |
> +--------+--------+-------------------+----------------------+
> 
> [1]https://lore.kernel.org/kvm/20231109180646.2963718-1-khorenko@virtuozzo.com/
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 8e40ff21f7353..45a187d4c23d1 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -512,9 +512,6 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
>  		svm->nested.last_asid = svm->nested.ctl.asid;
>  		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
>  	}
> -	/* TODO: optimize unconditional TLB flush/MMU sync */
> -	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> -	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>  }
>  
>  static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
> @@ -530,10 +527,6 @@ static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
>  	 */
>  	if (svm->nested.ctl.tlb_ctl == TLB_CONTROL_FLUSH_ALL_ASID)
>  		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> -
> -	/* TODO: optimize unconditional TLB flush/MMU sync */
> -	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> -	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>  }
>  
>  /*


Assuming that all previous patches are correct this one should work as well.

However only a very heavy stress testing, including hyperv, windows guests
of various types, etc can give me confidence that there is no some ugly bug lurking
somewhere.

TLB management can be very tricky, so I can't be 100% sure that I haven't missed something.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


