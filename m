Return-Path: <kvm+bounces-50246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52714AE272F
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 05:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3F6A3BF98E
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 03:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922A91519BC;
	Sat, 21 Jun 2025 03:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KKlnZLs+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A41378F4E
	for <kvm@vger.kernel.org>; Sat, 21 Jun 2025 03:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750474818; cv=none; b=kxDt2Prh+4e9gqw1nGIggZXI8xK9zfMLXJOHdz+HLNEaO+2kBQGkFiDp76xp09G6oExECxklVm+NIk9vCpai6LHW9wtcZmon1OPZOJZ1ZeUW+GSleshhYkgukL78MPIWP5cYTyUHoEhLzcsq8A2WTE3FyB9CnCtKcbi30Gy1IVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750474818; c=relaxed/simple;
	bh=2tE1AtBTKQpyhv7sb8Qnj3jxbXpTFxtQpYNHli3DIjg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FhWknhJ+BS5UbPKDyn5x+WoXd37qjTvhXmveD3PUa2iufaVDQieZW9rD9PfuWRZ5cDz4z9m5xIiAVFQSLVQ2vFSgYCsO/Ut3OFJTkdeMHzkiGbgyPVF97wv1jINL54U+C18y4b5yKmPovNPonbSpJZfKDFqaDC3SgGwxgUBwkKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KKlnZLs+; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2357c61cda7so36375ad.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 20:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750474816; x=1751079616; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2tE1AtBTKQpyhv7sb8Qnj3jxbXpTFxtQpYNHli3DIjg=;
        b=KKlnZLs+k2Xb3JV1hw/wAeuBQZTjppFQkglRkCemzbSlVQ7LtX3dMZ9OZv/yIF8EB3
         Ta9QGL165XFLwDI7OYNot4Q/i/QpPEHIkDZSqMIY7BQPD4xNz5lG+L4CF+zO5E0jMdri
         Mcqn4BjZEiFGddBeRdE/RkwwdW+9xWW1SZGGs6iiwS1C2Ed5Kf/o+A7QO0JnJTktf86O
         46Dc30cmO2hT6lZdUin71ZU6QG+FBdjG0NPPYfI9macMxOMEA9PQALbtSgcbmR1pVaVh
         0KbGu8pS4dTnzQV/UwfiTarpKearyoHre2mo795PM915aWbifHSJGpf5qvMpR0KCT53m
         FD8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750474816; x=1751079616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2tE1AtBTKQpyhv7sb8Qnj3jxbXpTFxtQpYNHli3DIjg=;
        b=UMRWqBHs32JCgwPgl1hs3W/59Z/6sp/kpjQDYINF9ImbqfO0H3gGBRqtEbGmW7equ1
         1KjWVe8FMZNVQ8Qwy11Dp2PfFg0rtDnqNilefc7W78Jf955JV2VpYGWvuiFw0BKLqkq2
         Q6CMPqi20OUxqG0oSYKDFZeiMljP8Krtt/5Sz7swl98cmH0fliQyA4FlwWzz/WNI7dky
         PRKU8UoD7iGJCUZgsZX5YAb0vP52uIvSItAlx/KxH0RRDTG5v1aLEctHX3WX1e1aSgyf
         i0gsPgV1ZGtVZ9fIaWnHj9K5TBZa5lF0oeWWluEd/4w1R/RqI6lQpvNZdN72a8M2uIRZ
         5yIg==
X-Forwarded-Encrypted: i=1; AJvYcCUXk8P4UjNAoydaWGI+Edmvev78Xmb97EDQwK7xiOp7su3lCvjHqlruPC2nCNmBdp8OPao=@vger.kernel.org
X-Gm-Message-State: AOJu0YweL0wtXbzQsfMzOt16L235IKuISVWX7TyeHsadO4Rbtra/gIKp
	lmWxbmuHff6MuKm6AbzF0sRgFScJA3laWKqGiEakheqj0G7xgcCbn8EGSxII88WsBeL7urgisO8
	nEDioiX/K3wtKrXrs/vZEpvPXhKueI7VP6OcmaMZD
X-Gm-Gg: ASbGnctV8KpErq5YEHibTlUzfZ+S1daMPe1EjR/3GHjUKHS9bmW6lYEDKDuOC3Dxg7v
	Vnm3CJUBSpF6BIi/E/RqaRd276n9jIotlWEu+RjaaksssNRm5s8zHY5dQM4A9WSgop1CgXfDlO8
	VMeFwC6lgl7HfIw7b98UKv8JQP/0zwW0o1Ac6PlJRlFiOjBzGFjeba21sc3LLbkMczAIy/PUgHu
	W7c
X-Google-Smtp-Source: AGHT+IEY/aU0Se3+UYnj+WojsdQuNKOtyTP6W5LG+7i31rI/DUUVlsgJfuulY/SHNY57G65ZfdkmmtcznbVPvG7egDY=
X-Received: by 2002:a17:903:124b:b0:234:b2bf:e676 with SMTP id
 d9443c01a7336-237e57540d5mr628775ad.11.1750474815932; Fri, 20 Jun 2025
 20:00:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <20250611095158.19398-2-adrian.hunter@intel.com> <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com> <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
 <0df27aaf-51be-4003-b8a7-8e623075709e@intel.com> <aFNa7L74tjztduT-@google.com>
 <4b6918e4-adba-48b2-931c-4d428a2775fc@intel.com> <aFVvDh7tTTXhX13f@google.com>
 <1cbf706a7daa837bb755188cf42869c5424f4a18.camel@intel.com>
 <CAGtprH8+iz1GqgPhH3g8jGA3yqjJXUF7qu6W6TOhv0stsa5Ohg@mail.gmail.com> <1989278031344a14f14b2096bb018652ad6df8c2.camel@intel.com>
In-Reply-To: <1989278031344a14f14b2096bb018652ad6df8c2.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 20 Jun 2025 20:00:03 -0700
X-Gm-Features: AX0GCFvnKvhZ0bcNCqXM9xBLf2M3ohY0YJGRJxihyIJVNMUt217beDUhPiQye7M
Message-ID: <CAGtprH9RXM8RGj_GtxjHMQcWcvUPa_FJWXOu7LTQ00C7N5pxiQ@mail.gmail.com>
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Gao, Chao" <chao.gao@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Huang, Kai" <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2025 at 4:34=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Fri, 2025-06-20 at 14:21 -0700, Vishal Annapurve wrote:
> > > Sorry if I'm being dumb, but why does it do this? It saves
> > > freeing/allocating
> > > the guestmemfd pages? Or the in-place data gets reused somehow?
> >
> > The goal is just to be able to reuse the same physical memory for the
> > next boot of the guest. Freeing and faulting-in the same amount of
> > memory is redundant and time-consuming for large VM sizes.
>
> Can you provide enough information to evaluate how the whole problem is b=
eing
> solved? (it sounds like you have the full solution implemented?)
>
> The problem seems to be that rebuilding a whole TD for reboot is too slow=
. Does
> the S-EPT survive if the VM is destroyed? If not, how does keeping the pa=
ges in
> guestmemfd help with re-faulting? If the S-EPT is preserved, then what ha=
ppens
> when the new guest re-accepts it?

SEPT entries don't survive reboots.

The faulting-in I was referring to is just allocation of memory pages
for guest_memfd offsets.

>
> >
> > >
> > > The series Vishal linked has some kind of SEV state transfer thing. H=
ow is
> > > it
> > > intended to work for TDX?
> >
> > The series[1] unblocks intrahost-migration [2] and reboot usecases.
> >
> > [1] https://lore.kernel.org/lkml/cover.1747368092.git.afranji@google.co=
m/#t
> > [2] https://lore.kernel.org/lkml/cover.1749672978.git.afranji@google.co=
m/#t
>
> The question was: how was this reboot optimization intended to work for T=
DX? Are
> you saying that it works via intra-host migration? Like some state is mig=
rated
> to the new TD to start it up?

Reboot optimization is not specific to TDX, it's basically just about
trying to reuse the same physical memory for the next boot. No state
is preserved here except the mapping of guest_memfd offsets to
physical memory pages.

