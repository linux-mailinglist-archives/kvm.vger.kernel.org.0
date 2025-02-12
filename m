Return-Path: <kvm+bounces-37931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD4D1A31A45
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 01:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 366613A34DB
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 00:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A474C85;
	Wed, 12 Feb 2025 00:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zhBXK1ev"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D183C2F
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 00:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739319350; cv=none; b=OwUL5W/kW7MRWtPfHaXHP0yUxc5z2JOuEovpBOYDWL42LSpSuZAD0AR/c1Z8RlMfVRtAobtO/OQaAebY9xy0eVhLpH6qEh3puJAVw752hMcMg8X8iulnKEbvlCKKZiWamweINzpjzQ6OGMtR2+GDn9kltObf9ka/C8y4GlUXkAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739319350; c=relaxed/simple;
	bh=Ke65lJuiw+IUfKsigUZZ+MBS7crW6DPAJmgQd269pYc=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=nfO8ZSb/cpvzGL2iYGORWx9a7m/sTJ5rPK204OTS+Mc5ptfPjcifW5xx6qZlvCPQyykyZclExk9217Q+C3fYK1dPI53if7J03U1eR1Wo0XMTf5yC9iGn8fwzRpwA6MYIf7RN1g1TQp48AfpJM9ytdra9vpO+emSizyU7ylteI/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zhBXK1ev; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fa636e5283so6042303a91.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 16:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739319349; x=1739924149; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KszpPMWhiTphxF1n3ceF8GA/2mh4edAfa99QT34yVwg=;
        b=zhBXK1evGbJq79mAQclpt7j5cnDGmjFyY7Mv/Zcf9Y43LeKqhAUq+hweNeyM8Yl6O2
         Nl/mIev3x6wD92MWoxEa02y9PcPAoSs4UTLH8R0YQI0meg7H+gvYH4o2nxJstcyedHWe
         XVJNjmf8vL9zbJIyWZ9Wm0ILdV8GQksy0zu7vbz5usovu9G5t1cHTz5IXw3kCCkcFHtz
         hDNEBKa8Og6MqBQ8+H34Uidi0MKeq3i6y2BzQwFOYhKhhyjTEONo/LOFmelySUL2kqe2
         rVFLS053e0NuccJs6ZfMauXLmsOAqGig9qRhp2+c3y8fIW6hYYuZQVuFadJHJyk9s9Xt
         1i1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739319349; x=1739924149;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KszpPMWhiTphxF1n3ceF8GA/2mh4edAfa99QT34yVwg=;
        b=bufvONIaclfNWPF/OQ0nrvzryRuWhTB1vQRTEWZBl1SLniEfmcbSLk2ux+XuEV7Nup
         kvC37Var96vDCEmPeAvpdbHkqJEMVsvHD8oWqaJyaUIKeCJoe7R7W8bZI1d5JhgaIgXY
         gRbQdXfpw484/SswYSVqQ/4cbYMxSMjxcyYayrv6ZklXf2Cmgu1c8TG/xhK2nvVUXf4b
         ZhQsB3WezcgcwYK4uD1vEKlylqdnqq5Lolgls25+tHnpdV6lgJN3Rs4miTrqGYbwNBEC
         z2Jgye8YP+D42UH7/G0ArkURE0kQ/y0Mg3sLpXnYE5B/TaR1FrO1SYOT/4vaOBMRHE/P
         D4Hw==
X-Gm-Message-State: AOJu0Yy0xC7sJvUIow9cfzfNQJzuOKtlpcGrD6FwcYWpSixKeMQi9M+s
	+/vr2ePhk1vrtT3bDZs/UFiPw5wrrXz52CVkiY1lYpWkJ9lbFvYCwzGfxP8FXsnX1xyjimKzipe
	pbEfAYkxngg0u1ZWYBPb9DQ==
X-Google-Smtp-Source: AGHT+IF4sKMX+KgxjFI4PsB328sWkz/ZZMywxzy98yOo2qwvaqGJzCDlFLnSzmt/3FCDRYVqBqf7nAmLzbgghsG8Ug==
X-Received: from pji8.prod.google.com ([2002:a17:90b:3fc8:b0:2fa:1fac:269c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e185:b0:2ee:8430:b831 with SMTP id 98e67ed59e1d1-2fbf5bc0249mr1883029a91.2.1739319348587;
 Tue, 11 Feb 2025 16:15:48 -0800 (PST)
Date: Wed, 12 Feb 2025 00:15:47 +0000
In-Reply-To: <20250211121128.703390-6-tabba@google.com> (message from Fuad
 Tabba on Tue, 11 Feb 2025 12:11:21 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzh65081cc.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v3 05/11] KVM: guest_memfd: Handle in-place shared memory
 as guest_memfd backed memory
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> For VMs that allow sharing guest_memfd backed memory in-place,
> handle that memory the same as "private" guest_memfd memory. This
> means that faulting that memory in the host or in the guest will
> go through the guest_memfd subsystem.
>
> Note that the word "private" in the name of the function
> kvm_mem_is_private() doesn't necessarily indicate that the memory
> isn't shared, but is due to the history and evolution of
> guest_memfd and the various names it has received. In effect,
> this function is used to multiplex between the path of a normal
> page fault and the path of a guest_memfd backed page fault.
>

Thanks for this summary! It has always been confusing and this really
helps.

Is there any chance we could rename the functions in KVM, or maybe add a
comment at the function definitions? The name of the userspace flag will
have to remain, of course.

> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/kvm_host.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 438aa3df3175..39fd6e35c723 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2521,7 +2521,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  #else
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
> -	return false;
> +	return kvm_arch_gmem_supports_shared_mem(kvm) &&
> +	       kvm_slot_can_be_private(gfn_to_memslot(kvm, gfn));
>  }
>  #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */

