Return-Path: <kvm+bounces-24435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 89F3D955182
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 21:32:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4C511C202F2
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 19:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13FDD1C3F2D;
	Fri, 16 Aug 2024 19:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e7Zht0cG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C634585283
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 19:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723836744; cv=none; b=BVcrngvtKFgyvoU2eOwyguMZAbmUraexqVlFiBRJF8l8Tm94yf8MToKWBw+I/sBQ5il/FIbRF/zhRV8VnW5xtjIh/i0Uh0xpQ5IpbjIQYdrj4wLy/Zvz/f/ER+CCRxKRNPu17xAUp4/UEzXBJ0Ko7tXtIsfIIO7ai/9cBHf0tAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723836744; c=relaxed/simple;
	bh=86dlDXREh6vxZqDbqVtKgn5EHSRPBEymw0B57y/Pp8Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kl0oM8IJxOezZQNC5cOPEv/HpIV9Bbtc4prU034FpTqYxDYfPOA2QiBifl9uFW9cDHxlCouNTibNUw3s255L3PfsuavGeaDTUJo9H8QXDk6Lue53pN+h7E/unp8udhxIFtp6fMj9NDOUwnjFkChfJMllGFySBhtwlIwPCiaMu0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e7Zht0cG; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ad97b9a0fbso45890517b3.0
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 12:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723836742; x=1724441542; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cbbwALysxAKAZiiwWFvsXslN5HMdm8PtgVwiZZNny5A=;
        b=e7Zht0cGuK+xwX00PIpA0paEeO+JQtsPCcT9Opms6ZpGlwIlJOD6bHfeNNpTTnKXML
         aNau1KcWZuHDFLy0SLAoKBh9Y32fPCmEyBuQXzXokcaIm5XSr2elnKm+Hj4UdY+rJWgF
         2ys+vTYqbLS2Y1CBE/XqgOa7wYKBoOUUy8EaFfKTB6XVBoUL0W4Hfgf7358O42oPammm
         7I+X2hM52zDHbdOtwABqhOOJEvocmQgZDQvnvySZnxKXgQWjbIBi6Kn71r0Ag9cmihfq
         ihQxwIA6L77gadAyXTbf46ZtpyeiLa+C78SHgLsSEf41aw3PVJryAGe/hW7iYLuZnQXy
         A2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723836742; x=1724441542;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cbbwALysxAKAZiiwWFvsXslN5HMdm8PtgVwiZZNny5A=;
        b=XB6LcRxKtOaQ2RpxMpitMPbY6DjPI7/b8L7Fv3Yt2VVKIEO1djIbsskDBshZFE4wLz
         Bi59T0fwA6S4JR+cmuxQ7/xE4ToTS/k94ofpHlwU7tw3fIciqpp9nreSBa73XCFEStvh
         3ZnfDVah/4ninq/OPEd3NWeAzQhJDv7Fu8gy5edwRb6EdDz9y1oxa5a9u9X7jeY4+Tbl
         6L8BeJG+ZrPHxdXIy/6lq4JzunYyG2st+k8uIEkcoYM9cJGturmtFN+HEJexuy9WdXaJ
         quBMs4hQS7+97BlbOVxvE4wxS2TNCGXUAELJNLQY8gEHaqxGvJsqyqKYl65rE0IN5h8V
         rATA==
X-Gm-Message-State: AOJu0YzpMzOQPdkEEKUlofoLMZUzV9dwEYp3R0ZPFZDcJ40sZ1FoZzcE
	/0wcs664zzymCJUJcwAmTINQC8scHyIGceFI3JEuxRKOfEc2jgmgZbiH5LTT29TYNdGYaLowQiA
	8Zw==
X-Google-Smtp-Source: AGHT+IHxI7a6saXi7ISTiFHJHCquHUevVm+Bv9GxPJERDYGDgVOOouWrzQkYJOULpNklx+j3O4vhJAjBF+M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:368a:b0:697:9aae:1490 with SMTP id
 00721157ae682-6b1b6cb8bc2mr1076867b3.1.1723836741860; Fri, 16 Aug 2024
 12:32:21 -0700 (PDT)
Date: Fri, 16 Aug 2024 12:32:20 -0700
In-Reply-To: <20240801090117.3841080-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801090117.3841080-1-tabba@google.com> <20240801090117.3841080-4-tabba@google.com>
Message-ID: <Zr-pRIWKOvN5px0P@google.com>
Subject: Re: [RFC PATCH v2 03/10] KVM: Implement kvm_(read|/write)_guest_page
 for private memory slots
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 01, 2024, Fuad Tabba wrote:
> Make __kvm_read_guest_page/__kvm_write_guest_page capable of
> accessing guest memory if no userspace address is available.
> Moreover, check that the memory being accessed is shared with the
> host before attempting the access.
> 
> KVM at the host might need to access shared memory that is not
> mapped in the host userspace but is in fact shared with the host,
> e.g., when accounting for stolen time. This allows the access
> without relying on the slot's userspace_addr being set.

Why?  As evidenced by the amount of code below, special casing guest_memfd isn't
trivial, and taking kvm->slots_lock is likely a complete non-starter.  In the
happy case, uaccess is about as fast as can be, and has no inherent scaling issues.

> This does not circumvent protection, since the access is only
> attempted if the memory is mappable by the host, which implies
> shareability.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  virt/kvm/kvm_main.c | 127 ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 111 insertions(+), 16 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f4b4498d4de6..ec6255c7325e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3385,20 +3385,108 @@ int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
>  	return kvm_gmem_toggle_mappable(kvm, start, end, false);
>  }
>  
> +static int __kvm_read_private_guest_page(struct kvm *kvm,

The changelog says this is for accessing memory that is shared, but this says
"private".

> +					 struct kvm_memory_slot *slot,
> +					 gfn_t gfn, void *data, int offset,
> +					 int len)

