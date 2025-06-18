Return-Path: <kvm+bounces-49808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDB1AADE292
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:30:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE58C3A30E0
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 007371F09BF;
	Wed, 18 Jun 2025 04:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i9DmlquM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06BE1EB9E1
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750221008; cv=none; b=KyB5fJ3XE2buf8X8iLpHwBHJzfU8W5Bbs+9J3qZiZx88DNt06uO2YapiXGAW75z18oeKJDYlbDhda8kzIYzncPBB3ots3sijIRWoG03eYBKIOfQFIwJlM1+8TXL9LrcVjhmm7hwVqeZTS5uKZwYoG+jvV7zKpr9IGFEocbilJGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750221008; c=relaxed/simple;
	bh=cnv5GjxdyHGoyq43lEWSP0hI3toA2+qDDGt22eNajzA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rZXTSW/TlK6MNO9RQ8FMdwapY3r02891ShzWmRO1xsQX8Thx6VWDDX57LRb0V0HwAQoEQ+fiqLXEndmkvzgC/FgoiQ83NhhAK4OTT/NuUkw6jGVQWQ5Z64dB3SIDCSF9pMpAdkYDiJUtrTPB0yZJAThitGMJYAFfZbghNV2FsQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i9DmlquM; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2357c61cda7so53995ad.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750221006; x=1750825806; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cnv5GjxdyHGoyq43lEWSP0hI3toA2+qDDGt22eNajzA=;
        b=i9DmlquMZgx1pcgbefFkrNwNb4RXUM+NrdsokD6UU2LEn2eopLIxeVrskqV2t/oFRt
         Fl47ibafkotwZLXWSVAtqJ8o41CFbZe8VlymQfjShDuCD+8WPYdNGj5ia4iam3vF5Bt+
         unTbz8bDNXmBsT4DscKcRsd/rZ34ag3fbaJGhohtWXLamV6hh7RfZjA9JqEsmumrAI26
         FoNHipjGH7KD0Rd1ed2U8gUVblGSNChhORekUIacuAS5FiADVm2zgR8ROQ5q5qu8DTZ6
         EIZrX1LyA/Oe/V6jdNHQ67XFOaKaABi/ZU9C3tr19TM+D1xTfapEO2MR6OxnhvFZK3PZ
         T70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750221006; x=1750825806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cnv5GjxdyHGoyq43lEWSP0hI3toA2+qDDGt22eNajzA=;
        b=LS8z6HqoppKTTpn272GkoBCz0PVc1fawnf2raptUe38BoyQ7/cA2C5R+bK9sXqxitj
         +L7X5662oN02obFJ4EXpzXPKCmvQnWLVH4eO+AqDDI+pOTlsReJ5rENnd+rxoJ6kjLSC
         Hq1x/wi99uyVkule8r5v55gKjLboXMD9KdFqz4+Q4eohFhkF5ydXk/uvLZAqq7IoXL/V
         V0/K2EtrYcvwLCTMqB7fC+d2KizCxnc7XnxsXrY7c5u7mbN5Dx434wp8l/PCwpPmsa5O
         GRUyN7crIUZBz4N7CZ2OKevuZmqxHahKOW1N73z1QqQ6Qqiyb/7JHfQO/x9utTBOf2lt
         fmZg==
X-Forwarded-Encrypted: i=1; AJvYcCXiE8Y9Kjn6LDZF/67P2j+ndQ5TpFnbqSHBKcP2RYuIxOaqGqLZOa+SvMsmxzmq/nKnjTs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpWkfzKRM00PQWrJEbdchINxTaNmi2RNgUg6g2nzpalK12zdtX
	b1hMeRUfGhjnlEWPDEjcS0dJLpnof2TsDy/s583PseOjYnSaDNXSn5kc2+n11J1gyAkU/Q40dkq
	EMcJaR1PhgkhGESG+16XQw7RIzLNAFiYnxXVh0tvQ
X-Gm-Gg: ASbGncusB5xx3PI/YIlSeaTZWSuKQxq5eNeKMBU+azZbU+eVWXR94MhC01AXJDrprJh
	Y+hVf4y54qK2Rmtig+6QMeLR7dpyHm89ZMoUeVrIXAOgsyfHqpYFjkPg7UhfffGK7XNAUJ3AjXw
	rvQ/yLmobI5acIvZZBjsMRUoXwHU+Ixv0G03SYRKeMbA==
X-Google-Smtp-Source: AGHT+IENELLSP/KcmKf1YptjAsIx1HMJDAYb2Ftt72/p7SVdYp9EhZgkn3LCbd5fFy0ZwqhHKjnrwVeMBk5uqkAQewc=
X-Received: by 2002:a17:902:e851:b0:234:bfa1:da3e with SMTP id
 d9443c01a7336-2366eda3120mr9916775ad.5.1750221005430; Tue, 17 Jun 2025
 21:30:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com> <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com> <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com> <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
 <aFEQy4g4Y2Rod5GV@yzhao56-desk.sh.intel.com> <CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com>
 <8f686932b23ccdf34888db3dc5a8874666f1f89f.camel@intel.com>
In-Reply-To: <8f686932b23ccdf34888db3dc5a8874666f1f89f.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 17 Jun 2025 21:29:52 -0700
X-Gm-Features: AX0GCFu4yfcPomAipNAsT3_NOzA6y8clKhCXIj9a5E78JCdL6Xy_5HOXIDslwKM
Message-ID: <CAGtprH_RaZ9aTB-da1rzjXYZhLvLViAWfALJz3dojqjH2eSgmA@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan" <fan.du@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "jroedel@suse.de" <jroedel@suse.de>, 
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 5:34=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Tue, 2025-06-17 at 01:09 -0700, Vishal Annapurve wrote:
> > Sorry I quoted Ackerley's response wrongly. Here is the correct referen=
ce [1].
>
> I'm confused...
>
> >
> > Speculative/transient refcounts came up a few times In the context of
> > guest_memfd discussions, some examples include: pagetable walkers,
> > page migration, speculative pagecache lookups, GUP-fast etc. David H
> > can provide more context here as needed.
> >
> > Effectively some core-mm features that are present today or might land
> > in the future can cause folio refcounts to be grabbed for short
> > durations without actual access to underlying physical memory. These
> > scenarios are unlikely to happen for private memory but can't be
> > discounted completely.
>
> This means the refcount could be increased for other reasons, and so gues=
tmemfd
> shouldn't rely on refcounts for it's purposes? So, it is not a problem fo=
r other
> components handling the page elevate the refcount?

It's simpler to handle the transient refcounts as there are following optio=
ns:
1) Wait for a small amount of time
2) Keep the folio refcounts frozen to zero at all times, which will
effectively eliminate the scenario of transient refcounts.
3) Use raw memory without page structs - unmanaged by kernel.

>
> >
> > Another reason to avoid relying on refcounts is to not block usage of
> > raw physical memory unmanaged by kernel (without page structs) to back
> > guest private memory as we had discussed previously. This will help
> > simplify merge/split operations during conversions and help usecases
> > like guest memory persistence [2] and non-confidential VMs.
>
> If this becomes a thing for private memory (which it isn't yet), then cou=
ldn't
> we just change things at that point?

It would be great to avoid having to go through discussion again, if
we have good reasons to handle it now.

>
> Is the only issue with TDX taking refcounts that it won't work with futur=
e code
> changes?
>
> >
> > [1] https://lore.kernel.org/lkml/diqz7c2lr6wg.fsf@ackerleytng-ctop.c.go=
oglers.com/
> > [2] https://lore.kernel.org/lkml/20240805093245.889357-1-jgowans@amazon=
.com/
>

