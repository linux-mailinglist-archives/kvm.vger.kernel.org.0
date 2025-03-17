Return-Path: <kvm+bounces-41233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3450A653D5
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 15:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 282D3169B65
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 14:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954052459EB;
	Mon, 17 Mar 2025 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LnOYK8tK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EC02459DA
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 14:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742222341; cv=none; b=L0i/KxVndediDCuxb78rKGjjEohiHDZXdeoKnRAtrXcqVJSVU5BqCiZrKkgS/YoXcKyHkbvZv5oZEfRLf4+A+0cAM3ghf3WyGSBWJqfuG9BJ3RbGL8V223NKX1Q6hzLqxzdEqTMDP684hJk8HThlK9VTtJl2eyNlQTvLqKwESx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742222341; c=relaxed/simple;
	bh=/dAl0ynlZ2IY+8wi9m/qUg2v0tSHoWcC48n6Cx4/xfk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NsiOV+gyXSS53inoOgGhu1q7TB5O33rQDbKMIy2fW+KM4kbz/LNXBEeuLwuQD3e9OMScwTiEQFMxydmzfcqeJEpUuaZIZTk5+w6quO7KnP4KfzWnfrpPYEaPW6Kz4V6O4lCYUWkt0i2rPdyLlEaQDzp7WPjzXggXkcBQOBVXSMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LnOYK8tK; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2255ae39f8fso93864885ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 07:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742222339; x=1742827139; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Op4uidlCpeYwzoDgf0iPKy+/ekUTh6FlGoKnBfWlUE=;
        b=LnOYK8tKDad7wfZOgdkFpdekOUb5eTKo6yRbZcVscZOQBkT2T3ovKNjKC+idaFQjbb
         HKhuvEILxr7bGz05DvY0HGFMnwhk0ijqNuY6DjLmoZalexPFXo3oNUj6O7VnbPNuz2OX
         jqEQnCKB5lMAVi6G9QuCunHWBXuFBLFMwEmuxGaO+rByIIBYAUKJZ1pGzEDZjocJvARG
         KWWqSb8KOdB0yD3x7A1KAtsAJjZc0KmlaKLW2gnzbko9bpfAHM+0tJECnSw0oGh7IXXU
         0JMv0HzRNSDHF2kheUj1HVH6Qm+y0wlvO8Ti7a9iWEtt+GtEp9I0VxEWbfXulqzHSwiA
         50tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742222340; x=1742827140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Op4uidlCpeYwzoDgf0iPKy+/ekUTh6FlGoKnBfWlUE=;
        b=jEdo6mt0sanFdFqTr7FQ6yDGtCWHgH7VfCFwy1aGWry7uWrfb/9RqBgbvNtz0QRqa3
         zuWlD/R4D11AOdFZmOTJBbsXXAllrXDohhJADZKdwN0HgYPwLF+YPKsv+OSMuO+JGgFT
         AXjaU9Kq893GVOjacYKtdjwS8r5XEC+84CJlSwFXAL6HXtox8xGhkQQyTaofo3MUYOfp
         a+y9rBuaB3rySMk7SVPDQ9h7+q07rnY5NlZKIWRcMB1tPpo66jKm2Z2iccNHNaa1FuFf
         webW6E03s+m8XEnFHCyMbjt68jPx5DRw8X90GrTgBCG3/8jQbETrSeuJL9ET0fE3iYBW
         3sZA==
X-Forwarded-Encrypted: i=1; AJvYcCVdV84ZtzME1POqIl3Y9W6MSc58kne5lYoQasZ3GrQzV2GWHPprP0xm4UybGS+cyrNLhQA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfAQGpGMazXqybAnWPS6sHXGzN2Gr+RPE8Dik0VAzjHMUZm0G6
	0R2x+EVEW5IL+gp6pcKKZCr5TCvd742RiZzQeah2nUM364Eyfe1/x5a7S5KCtyb1rnUNXZjp/AH
	P1Q==
X-Google-Smtp-Source: AGHT+IH+0K/tTKkWUqTn+JnWKj5LdFmhPjMwWAnay0MeDaFc2pDrra16+lQ6NN5tULJSNZlBoZ6guoXVZ1I=
X-Received: from pjg13.prod.google.com ([2002:a17:90b:3f4d:b0:2ea:29de:af10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5247:b0:2ee:5c9b:35c0
 with SMTP id 98e67ed59e1d1-3015214a808mr14301008a91.9.1742222339603; Mon, 17
 Mar 2025 07:38:59 -0700 (PDT)
Date: Mon, 17 Mar 2025 07:38:52 -0700
In-Reply-To: <fe2955d4-c0a2-411a-9e50-a25cc15c75dd@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqzy0x9rqf4.fsf@ackerleytng-ctop.c.googlers.com> <fe2955d4-c0a2-411a-9e50-a25cc15c75dd@suse.cz>
Message-ID: <Z9gz_IwHScMkFQz4@google.com>
Subject: Re: [PATCH v6 03/10] KVM: guest_memfd: Handle kvm_gmem_handle_folio_put()
 for KVM as a module
From: Sean Christopherson <seanjc@google.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 17, 2025, Vlastimil Babka wrote:
> On 3/13/25 14:49, Ackerley Tng wrote:
> >> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> >> +static void gmem_folio_put(struct folio *folio)
> >> +{
> >> +#if IS_MODULE(CONFIG_KVM)
> >> +	void (*fn)(struct folio *folio);
> >> +
> >> +	fn = symbol_get(kvm_gmem_handle_folio_put);
> >> +	if (WARN_ON_ONCE(!fn))
> >> +		return;
> >> +
> >> +	fn(folio);
> >> +	symbol_put(kvm_gmem_handle_folio_put);
> >> +#else
> >> +	kvm_gmem_handle_folio_put(folio);
> >> +#endif
> >> +}
> >> +#endif
> 
> Yeah, this is not great. The vfio code isn't setting a good example to follow :(

+1000

I haven't been following guest_memfd development, so I've no idea what the context
of this patch is, but...

NAK to any approach that requires symbol_get().  Not only is it beyond gross,
it's also broken on x86 as it fails to pin the vendor module, i.e. kvm-amd.ko or
kvm-intel.ko.

> > Sorry about the premature sending earlier!
> > 
> > I was thinking about having a static function pointer in mm/swap.c that
> > will be filled in when KVM is loaded and cleared when KVM is unloaded.
> > 
> > One benefit I see is that it'll avoid the lookup that symbol_get() does
> > on every folio_put(), but some other pinning on KVM would have to be
> > done to prevent KVM from being unloaded in the middle of
> > kvm_gmem_handle_folio_put() call.
> 
> Isn't there some "natural" dependency between things such that at the point
> the KVM module is able to unload itself, no guest_memfd areas should be
> existing anymore at that point, and thus also not any pages that would use
> this callback should exist?

Yes.  File-backed VMAs hold a reference to the file (e.g. see get_file() usage
in vma.c), and keeping the guest_memfd file alive in turn prevents kvm.ko from
being unloaded.

The "magic" is this bit of code in kvm_gmem_init():

	kvm_gmem_fops.owner = module;

The fops->owner pointer is then processed by the try_get_module() call in
__anon_inode_getfile() to obtain a reference to the module which owns the fops.
The module reference won't be put until the file is fully closed/released; see
__fput() => fops_put().

On x86, that pins not only kvm.ko, but also the vendor module, because the
@module passed to kvm_gmem_init() points at the vendor module, not at kvm.ko.

If that's not working, y'all broke something :-)

