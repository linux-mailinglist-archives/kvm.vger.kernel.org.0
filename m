Return-Path: <kvm+bounces-54077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94A47B1BDBD
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 02:10:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B3327A84DE
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 00:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A8E749C;
	Wed,  6 Aug 2025 00:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="juTmG/Vo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D64136E
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 00:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754438995; cv=none; b=nqDQRazR7jbL+aXg/5Ix9Oq3LxlGEsZC2bdU9IBCzvDGWZwIwz9Nk8WP3J7t2SPI6iP4pWZgQ913XAOpOrtiR1PH1Dwt+5cLxgwcoakBBGCIFcKXfxNfOklEoH86FE6xBzez2/3ev1470V+G77sG2NRXVeSNilVVUyqU6jlfa7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754438995; c=relaxed/simple;
	bh=ZOQsJI4hllbXPJNAkCrOFd9A4zdldwqNbRW4Sk03H0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gcb3vgTIjRrsxI6JKVI4q4hPINkYY7jAed8z8qvsLtd5INLeqavEBNARhTzJ8AiQOYfsnIYO/OaShCTRnIC8ur3obFpGkhIB9J5qRe+IPbd1pVJoFMoiUPpyonAiIPn8B1BOCxYB3Im08B9DTXfVrYEpm2A1SbRGrSHKjomj8qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=juTmG/Vo; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-240708ba498so53625ad.1
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 17:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754438993; x=1755043793; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6I8HsqNpJhHWG5dLzFn7X6r6TawwSMkwMRxzvdZ6JwA=;
        b=juTmG/VoaZF8EpHaHwk1AiWvBGC/rsx7tFmWuvUXqYEfEQrGC8HvultKusfcXDK3U+
         t112rf225YJWYw+8GDIgQXq+PKw1cyoGJ6OYjvca94a7EnmbaN17rUK9+z3LMDG+5g6K
         5MXXvMc7MVVdCNQdW/tUfDS7SrekjUNbzIv79d4YhgFQIj9zArBTqkDrGtc8ykDN8+eg
         lIBjXtj2ol+h0UP2BfuBDydTLg1QsOLd2lirCDNKeCmWdGa4JLHi/YH6oQfg17A5Pb2v
         6U6wBgkfjhVJO8BP8DZZhFbP1PB7ecdIbMIgJ3+RFhn8lnN1RWmcLXZnn1aXynHj3lTK
         T2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754438993; x=1755043793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6I8HsqNpJhHWG5dLzFn7X6r6TawwSMkwMRxzvdZ6JwA=;
        b=UHwsQibL3wnXF68k1hkix6zMxRWkQjf5IhPK6hSeotqtKU0WHRrEj/JyXTu9zkFUAQ
         w0EyryNmGkB/czGfaAnxHkr4O+CXka2bW48mRg6aSDp4kv5NfD6xD9L/2F1cFxCaC2/X
         xvslfcVf6STPC8Gzfhd7bKb5CtbZTVqtFTqci7q2ly5StBFYmRUcBWY4f5a55ZZ6xwIF
         DFcosBg9W3sHmZA7IH8zhrLPDz9TzQmEkFTwPTg44jTqUSZL8hoxmyNXb7o14jsOzfsi
         5Cdp5lw0oI6sXOds6n3S7BPDewe/Ha75XJZGBGH8soxvpXuxiGY8Kaqy3RF9s70+CcQx
         Nmqg==
X-Forwarded-Encrypted: i=1; AJvYcCW28Y9bQ50BRCXEKjJouL+SEr9xIxPPOq53u1eg1wqENeXBLlpX8dKnblm2MRXrgVm2zxo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0OQbbc7RNcVVXzgNdYz4QdHxh2THlA0froys9qWPslkAwgZUM
	4T0Fx34CdwAhCg8W7h4I8c6WJWn/3Oif4pBeXuZ7aRk3sqAMtmMBZTUST6SRwd+R/9gFYcGgBCs
	q/gTFTwUWHtpWEoQVXxka4Yt+fkQlTzct/IRn4pXg
X-Gm-Gg: ASbGncs63C6RdpCItQkH6YP+V7ChBu+G2d6Qevrle891vZxSf2s3NNhvqE3sCEwVwVZ
	5x0BOGOfDZdqEAUc2GAp84US6Zb7fX1NQ8ACy43nySnXPdOBnYTt3cfz6vT5oO2gbSZfmeVdrcn
	7wGxqiZLMwdfgqSz3U/xieKPbJpkWyWYaUsZMwFnxxfncVqHgDkFy1e/OSuFXZed5X6CdLQ5yH1
	hHkjd38x82I/5hmFBCAiq3J1P5SyOfcQG5iog==
X-Google-Smtp-Source: AGHT+IFgK86TDS44ZXL6s1kOzOAnW/EHzdJN0Sj3gIaGmBtwp+yGICBZG/enSUARPg61J2n1DVpx5A/bVG/pmazuRVg=
X-Received: by 2002:a17:902:f70e:b0:240:469a:7e23 with SMTP id
 d9443c01a7336-2429ecf9ec0mr1693505ad.20.1754438992714; Tue, 05 Aug 2025
 17:09:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aHUmcxuh0a6WfiVr@google.com> <aHWqkodwIDZZOtX8@yzhao56-desk>
 <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com> <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
 <aIdHdCzhrXtwVqAO@yzhao56-desk.sh.intel.com> <CAGtprH-xGHGfieOCV2xJen+GG66rVrpFw_s9jdWABuLQ2hos5A@mail.gmail.com>
 <aIgl7pl5ZiEJKpwk@yzhao56-desk.sh.intel.com> <6888f7e4129b9_ec573294fa@iweiny-mobl.notmuch>
 <aJFOt64k2EFjaufd@google.com> <CAGtprH9ELoYmwA+brSx-kWH5qSK==u8huW=4otEZ5evu_GTvtQ@mail.gmail.com>
 <aJJimk8FnfnYaZ2j@google.com>
In-Reply-To: <aJJimk8FnfnYaZ2j@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 5 Aug 2025 17:09:39 -0700
X-Gm-Features: Ac12FXymbfJdEF0wBMOYP6-B3-5IXJh93gxKyNMf-PV_-6yUB3ZSwu9ht5Cy8wI
Message-ID: <CAGtprH9JifhhmTdseXLi9ax_imnY5b=K_+_bhkTXKSaW8VMFRQ@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
To: Sean Christopherson <seanjc@google.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Michael Roth <michael.roth@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, david@redhat.com, ackerleytng@google.com, 
	tabba@google.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 5, 2025 at 12:59=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Aug 04, 2025, Vishal Annapurve wrote:
> > On Mon, Aug 4, 2025 at 5:22=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > : 4) For SNP, if src !=3D null, make the target pfn to be shared, cop=
y
> > > : contents and then make the target pfn back to private.
> > >
> > > Copying from userspace under spinlock (rwlock) is illegal, as accessi=
ng userspace
> > > memory might_fault() and thus might_sleep().
> >
> > I would think that a combination of get_user_pages() and
> > kmap_local_pfn() will prevent this situation of might_fault().
>
> Yes, but if SNP is using get_user_pages(), then it looks an awful lot lik=
e the
> TDX flow, at which point isn't that an argument for keeping populate()?

Ack, I agree we can't ditch kvm_gmem_populate() for SNP VMs. I am ok
with using it for TDX/CCA VMs with the fixes discussed in this RFC.

>
> > Memory population in my opinion is best solved either by users assertin=
g
> > ownership of the memory and writing to it directly or by using guest_me=
mfd
> > (to be) exposed APIs to populate memory ranges given a source buffer. I=
MO
> > kvm_gmem_populate() is doing something different than both of these opt=
ions.
>
> In a perfect world, yes, guest_memfd would provide a clean, well-defined =
API
> without needing a complicated dance between vendor code and guest_memfd. =
 But,
> sadly, the world of CoCo is anything but perfect.  It's not KVM's fault t=
hat
> every vendor came up with a different CoCo architecture.  I.e. we can't "=
fix"
> the underlying issue of SNP and TDX having significantly different ways f=
or
> initializing private memory.
>
> What we can do is shift as much code to common KVM as possible, e.g. to m=
inimize
> maintenance costs, reduce boilerplate and/or copy+paste code, provide a c=
onsistent
> ABI, etc.  Those things always need to be balanced against overall comple=
xity, but
> IMO providing a vendor callback doesn't add anywhere near enough complexi=
ty to
> justify open coding the same concept in every vendor implementation.

Ack. My goal was to steer this implementation towards reusing existing
KVM synchronization to protect guest memory population within KVM
vendor logic rather than relying on guest_memfd filemap lock to
provide the needed protection here. That being said, I agree that we
can't solve this problem cleanly in a manner that works for all
architectures.

