Return-Path: <kvm+bounces-23248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EFDB948172
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 20:13:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 241CE1F238C2
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A854115F3F2;
	Mon,  5 Aug 2024 18:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hQBffXES"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5657148CCD
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 18:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722881584; cv=none; b=RJosmSOcVSRys/iBawkwURi57tFtDZaWB1pLLb1TiZdX1NQsqyAPEYvHU0YZYYXZ4G60YGobEv6e9cgNsB3q/0X9nKI4dxVVznLGHqKWtWEsrk8a4p2/c3Rxfij2VHxR75Y+dZC27gxZl7qKBuifWnY+Md2pj3yPAISPHRgNA2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722881584; c=relaxed/simple;
	bh=DGhBnvZCORpIYf0nsNYRYGt3Ca38WQEt+2+0Vz8c6gY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IASI+jelvkloG7tWkM63dP8YYde2yW+BZdekWp1tWVHQvrui4B8ZM7nuuofXrqvSmo+sM8hYFZFXgfvwYNFNwPEbFgiZj2YdKOEh2/RbsMkni5PEHiNw/3jjMV8m577qpUk3GYB3G8be+m279eHCTcBFmV/fdhSbVXAizUogKAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hQBffXES; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4257d5fc9b7so98645545e9.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 11:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722881582; x=1723486382; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UW0Wmc3DPQnB7QJwc4l3hei2/xUr/kzYckSlq16EQ1o=;
        b=hQBffXESSSO5FYXAJ67CPySMgVT3/k+pQDCPcLAqG0M7RzbBMbnYzD4cEy2KU0HldG
         aWfIoxuWrYpFC5UNoqqulwe7lPXvfBduF29jPLhLaaVjkjymeYaYUAS0RWxkNZJXOGyq
         8cR9q59nJ/MWUJtgJGDp4F3hAOiMQlomronXnI8VnaN8AQs+hqDGwOzVxRjtstvPp9JA
         kttU2gVsUhcJIIHZMaG8ovv030IRc852bDW2VGJqHXSeBHKoGXRf1uDrvT07BtRdnYaw
         lEajLzxC6b0hfIK+2sikYSoiciitV04bPM2OvCYw187sxniZJFRjFENjtOnm3A87roU9
         cLNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722881582; x=1723486382;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UW0Wmc3DPQnB7QJwc4l3hei2/xUr/kzYckSlq16EQ1o=;
        b=hAGQzgzoSB7SNt/FrPF5IxOwfWy+x7QWqZDDsnLi/8KS2tkHVjQqJ0ACfxaR/tnKH/
         F4O422a5ABrNxWLaJP9Zv4tM1FgstO9yjpWmQdxaceLlPKdro7cofx5ZKwmmVRiMlyAx
         ekEbaiYmcnAwZXKh8LbcVmvCcwFSnThjTFLcFjuOm/J4UWI7pX56SAp/A43EpTmU8uDu
         p5fAINv98eZvK/V1JP/8rFwg9PPE1zfmYwrQzDNHV9LXL2TYlnvWy3wz84IASZ/F+0E4
         TSSmEjBu3e7N5WCe2VvpzXQp6cQtmwycoHejMCsjiW72Pcj8UfNQUb0q/MpaoKMFZPDa
         wXiw==
X-Gm-Message-State: AOJu0Yw4b6DsontIMWIew79SG7fyjKtgL7TL8QYkxr2RhmTwqoVIHpg+
	+nE35Aj8W05kYywlnzhI6FMEI0LoIEl5Y6W6CKpmLbkEAYlsgreMZqFHvmKmS4aYp/LZE2vc52A
	Q4+qDqhequP/xOMgQSaQm2tseVu9E28Xt+SXO
X-Google-Smtp-Source: AGHT+IESA8RrRXiihxn1rztAZidp/X3heFsBijC7CMdQ1hBATFBikQXRk+9X/qvN6wcNSOAM5dTt22wVGuXjUgoAjYw=
X-Received: by 2002:a05:6000:d91:b0:367:9114:4693 with SMTP id
 ffacd0b85a97d-36bbc117fafmr10130837f8f.31.1722881581490; Mon, 05 Aug 2024
 11:13:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801090117.3841080-5-tabba@google.com> <diqza5hqevle.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqza5hqevle.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 5 Aug 2024 19:12:24 +0100
Message-ID: <CA+EHjTwHXVxV_Y8Ckr6UkV9JE2ywcHddD3Q967QcDx6soxsR7A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 04/10] KVM: Add KVM capability to check if
 guest_memfd can be mapped by the host
To: Ackerley Tng <ackerleytng@google.com>
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
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Ackerley,

On Mon, 5 Aug 2024 at 18:19, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > Add the KVM capability KVM_CAP_GUEST_MEMFD_MAPPABLE, which is
> > true if mapping guest memory is supported by the host.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  include/uapi/linux/kvm.h | 3 ++-
> >  virt/kvm/kvm_main.c      | 4 ++++
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> >
> > <snip>
>
> Why do we need a cap for `KVM_CAP_GUEST_MEMFD_MAPPABLE` instead of just
> making guest_memfd mmap-able?
>
> Is this to prevent breaking userspace, because a user might be relying
> on guest_memfd being not mmap-able?

To be able to check that the ability is there, since it is a new
capability not available in Linux 6.9 not 6.10 (i.e., after
guest_memfd()) was introduced.

Cheers,
/fuad

