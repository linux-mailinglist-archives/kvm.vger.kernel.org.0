Return-Path: <kvm+bounces-17328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E19C8C446C
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 17:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43C4A1F20EAD
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 15:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BEBD154BE7;
	Mon, 13 May 2024 15:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DC2d40Ni"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D890154458
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 15:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715614796; cv=none; b=VdvF2Nsje5U9xcPD/qRqkVbquebd0rUKgxk/YJPjssWkYByCqV7Yv7slrVrzcfbfCDkYo/uhxrfQcHeGsOs4miAIWMEiJMg2yq+J+396qQpIqd+hLypP9vFlSiuDkru/Lz7FujMXH2jWrFS38fbtogqT4ULLZ4uNBIfq0j2Lwac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715614796; c=relaxed/simple;
	bh=t5/GGoZIm8krsLcMNp3AnUd/RW9fbbrJCuKFgYYH7e8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n9d7Fu36W964LBSLXtgrk6qf2PeCE7IYq7X+Dtsegh8RrzcuRfZ1lQ/abI2qVdvOAGyoVp91+nI3m75uN2j1rfFOkNEIZnnqtXbx2POgscOzNS4r/tJH25l1Xtuyws4kD3awyC1Wa07I0E5wF5zgQcM5Veja1UCM2HVhzb3PTjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DC2d40Ni; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dee5f035dd6so4973091276.0
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 08:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715614794; x=1716219594; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n3Z5PYvhEmOWZdAv2mF8wgraFReVMHPpsbJyP0PVGQk=;
        b=DC2d40Ni8e8VBB+Qau3n5hc0kEr1jvM0LnEghSr33cissZlr4yHw2xqQ6kV0uiWCHW
         0WGfwcURMzGocyTsR2XHamkKrFCO7E3ygCU3DTTQFTqlWu+mZkHCIeFdG1Oo5SyauyEb
         xnojQloCnoll7pfjGc2xZF41FY5ADK1b859MeSZralyRWaVDTW2gtApkmouUyyz2jPm+
         AgTFAQFf62O6IbjrYHo04To+9QHmOB6cDUAoejyrruPuYTqqEf/XJBig9CB+Q9SiWhPG
         0jynKwZc+lRfjwOiOuXCV80/MHLtbnMckIrRNJ/ojW3i8VacHqNieaJI+b/6+wYkbAaN
         3I1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715614794; x=1716219594;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n3Z5PYvhEmOWZdAv2mF8wgraFReVMHPpsbJyP0PVGQk=;
        b=rchUh0+rQIHk7SpcOx2QIOBto6U4iqzGl/xnKI7e9k6gQJVbpqdz7BE1R6vGqY8jY3
         pK835psC0RjEEhhEAEQlwWeWfj1zOZ4YqzkGCsgzWVsvF2p8Ygr2SHA1zNrUdlkNDh/1
         9oWlDVOe0kswCeSB3MrVAMW9jaVfLwl5bjITA9RazuF0MMNt6BMr55gOQwhMEV4iZSXC
         V3w/btHuy3VrRpNxJTjTlH6S0a7400dtg6D1OliJzQ6pfMT8hyJHvwzfZ1TFY4ErF11J
         TW7NyDLKY2mQxJiOIzv/wnPfvCNuV31hm4bBXTan04ZNXfPr3M4n59HAzWpVtJO3ORfb
         6Lzg==
X-Forwarded-Encrypted: i=1; AJvYcCX0czlm43oZQSIPlrLOjFyqdSokBYp13QfAS4OcFxDaDtypHKt7pyQpy+ZnPHXc9xvps9E0XI02cpBayTJyEB9yVVgZ
X-Gm-Message-State: AOJu0YxTMlfLiSWgsgYFhwiA4fMoFzIGNH94yjn1rIx5QW1SrFy9Vo3G
	5tqgkwiM1qbUz99XtnEnREgUKhznDHg37pS/+hbbRO1fOPzwlO5/s/av+p/63Gqb0SjjfjhH+B3
	ykw==
X-Google-Smtp-Source: AGHT+IHuwIc8fyCnlatjoe9Q2CYS4eVJOdzUScq69lTq3aH08Ut4sGUdSzstpLDLmLZVgoWu5DLZoOTvNRM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:fe0f:0:b0:de4:7be7:1c2d with SMTP id
 3f1490d57ef6-dee4f31fb93mr2560099276.11.1715614794264; Mon, 13 May 2024
 08:39:54 -0700 (PDT)
Date: Mon, 13 May 2024 08:39:52 -0700
In-Reply-To: <58f39f23-0314-4e34-a8c7-30c3a1ae4777@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
 <ZeudRmZz7M6fWPVM@google.com> <ZexEkGkNe_7UY7w6@kernel.org> <58f39f23-0314-4e34-a8c7-30c3a1ae4777@amazon.co.uk>
Message-ID: <ZkI0SCMARCB9bAfc@google.com>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
From: Sean Christopherson <seanjc@google.com>
To: Patrick Roy <roypat@amazon.co.uk>
Cc: Mike Rapoport <rppt@kernel.org>, James Gowans <jgowans@amazon.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, Derek Manwaring <derekmn@amazon.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Nikita Kalyazin <kalyazin@amazon.co.uk>, "lstoakes@gmail.com" <lstoakes@gmail.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"mst@redhat.com" <mst@redhat.com>, "somlo@cmu.edu" <somlo@cmu.edu>, Alexander Graf <graf@amazon.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 13, 2024, Patrick Roy wrote:

> For non-CoCo VMs, where memory is not encrypted, and the threat model ass=
umes a
> trusted host userspace, we would like to avoid changing the VM model so
> completely. If we adopt CoCo=E2=80=99s approaches where KVM / Userspace t=
ouches guest
> memory we would get all the complexity, yet none of the encryption.
> Particularly the complexity on the MMIO path seems nasty, but x86 does no=
t

Uber nit, modern AMD CPUs do provide the byte stream, though there is at le=
ast
one related erratum.  Intel CPUs don't provide the byte stream or pre-decod=
e in
any way.

> pre-decode instructions on MMIO exits (which are just EPT_VIOLATIONs) lik=
e it
> does for PIO exits, so I also don=E2=80=99t really see a way around it in=
 the
> guest_memfd model.

...

> Sean, you mentioned that you envision guest_memfd also supporting non-CoC=
o VMs.
> Do you have some thoughts about how to make the above cases work in the
> guest_memfd context?

Yes.  The hand-wavy plan is to allow selectively mmap()ing guest_memfd().  =
There
is a long thread[*] discussing how exactly we want to do that.  The TL;DR i=
s that
the basic functionality is also straightforward; the bulk of the discussion=
 is
around gup(), reclaim, page migration, etc.

[*] https://lore.kernel.org/all/ZdfoR3nCEP3HTtm1@casper.infradead.org

