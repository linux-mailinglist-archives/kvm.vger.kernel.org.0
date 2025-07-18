Return-Path: <kvm+bounces-52911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C91F1B0A807
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B69EC3B6B1F
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:57:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75752E5B1F;
	Fri, 18 Jul 2025 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N8jsL1WH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8485D2E06ED
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752854244; cv=none; b=U/p8kl0QK9SftisV6Zte1T5lwhssIYWuHCj4YQAbVrKdW4hiX2XEpTIjqxMb1I2Yn25lk5Kvz5cPGk460c3gFxFtlBrskVX7fw9MVACu7KZL4Ov7RDHRM1KQIFpsgOnrIvTFQd/QlN+ZYX4i1KXl5lXrD1q4shzrgp3I9XZPz68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752854244; c=relaxed/simple;
	bh=gHGhnpTIs0SlK/0a8FDgsCBiZAOqX7pM8mcEaSxC8dY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BtetbprSfDyrNWoRIcsH2rnUOLxX4Yv9yn0caGBwbKV5ADyC3a+mhT0rdb2JuhE5EipjHuaoyVJ4jFmXeJrfz656W7bCSm99wAMGsxg7C2mmm0/exByKDkHwMtc3EAMAeUbI/ADZnlrE3hRr+NV6QeXPde13jtnjVQxzKUe+AcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N8jsL1WH; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-235e389599fso260345ad.0
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 08:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752854243; x=1753459043; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h8OwoX5mxh6UvTDR1Yv1NAz1aJQ0CYYYwNtDjaEd3rs=;
        b=N8jsL1WHZBxFJbQrjjFMXLJg9u1hpdAaHO+l1ztZHn27fp5C4OsW5Fa5EyQlzXA1YT
         z6JaraXg2VkZajf8pVHuUCKNb754dJpttjFbUlRAUN8/0GIE1kmcX9czrEi7PrYunnK8
         oZ+Hi33NYKyTgFc4XxSL4ePF7HkLyKiER5yOXDdlsOyXvYm2R2ZikIcusAU8G89Ry8+T
         JjoE41SUcj1NRQtKhzj/h/GuZT2qaatusf9MDPf3SFa2QqCdBPbZygsH0J0wjIzRTWvD
         Iv2wQu6RjzYjIbAECIaIVoPN6WA48jbanHpcPvWgZvuijyvrPlFzjMccxN+Xy8892MWy
         RqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752854243; x=1753459043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h8OwoX5mxh6UvTDR1Yv1NAz1aJQ0CYYYwNtDjaEd3rs=;
        b=QPRoyQZtiNX4rGPZSstwyImgR4ipB0Sp/mDCX2PBQgo2jRapm4fyzUxcZYdsEuvg/s
         45PmYZA1PIQorX6AJd4U3U9EL9igyPQuq2wjttf+iuSCWx9ERoAoUiqAIyN4ZZPn6Yur
         CG+tcTgHhN8NgBmVP8FFAgN1hkdYSs1CNlevRfF8Iv2V3OXay+TZjpRKzyRGJ9GHi2QA
         Hn8hZ8qyZQgJ49yBzYc5hrk6+5DC4jxQe2NspGhx7SS8EZ9Uih7om/SwARWAVtG0ibq5
         vLY5hEYPD4mgsb9D7LEMK76cCYA7frTH43z7REObzatrKV1ibMXOziBrGUYpAChEF3pe
         1eWg==
X-Forwarded-Encrypted: i=1; AJvYcCXoQd7OfxAaOurzP3eIXTa0U4mva5X+V+QzX8kzjIGPP5kkOFe4wFrCNfxvy9OoEXOhlB4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnaZPz8ndB9c2TXavNU4aYuw8zET/9t1sWdLK70mHD6XGvKvaz
	g011SyRUrcxw/zKul6dB5P6gdCWYpR71wFgFtDq2m3WeQF/B84x1wJpifa+aHyaPjbIKe1FKiUr
	bN53P565SsxuW4K7p3g/+42J2oolflNTn7UL6w5ap
X-Gm-Gg: ASbGncv8KEvRo1JAbFWZwMdw8+hYcq+m6pC0pXvXK/Bsw6rfynig+GiOHpgS6QqhjjB
	3AUYlprIpyxcvF5YBh3wdzm5sqmemX0gqW5I1fycHRhFiCl+LPT8XmvoNcfhKOOOHLDSFTNb48Q
	B8VY7OqMru3YXlU1Jh5qs1+gUHFUKqkpvJ4l6iVlBH89qtRAFRXAsn4KUMABBSqvEKDMnqdia5q
	1Iaby/cHc06WSWQgY0bcEOg6HQ6ziPDtrMsUnrJSc6v4GZsaE8=
X-Google-Smtp-Source: AGHT+IFgi72u+XAyFB7UNUnQ78KCwwZ31ziMPnV0eIv4PjDoKng8evgPNW6wi8hbBTzsrhbCEYntoxga6S5rFlzzpxo=
X-Received: by 2002:a17:903:1986:b0:234:afcf:d9e8 with SMTP id
 d9443c01a7336-23e39284266mr4452875ad.7.1752854242330; Fri, 18 Jul 2025
 08:57:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250703062641.3247-1-yan.y.zhao@intel.com> <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com> <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com> <aHEwT4X0RcfZzHlt@google.com>
 <aHSgdEJpY/JF+a1f@yzhao56-desk> <aHUmcxuh0a6WfiVr@google.com>
 <aHWqkodwIDZZOtX8@yzhao56-desk> <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com>
In-Reply-To: <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 18 Jul 2025 08:57:10 -0700
X-Gm-Features: Ac12FXzIuH1z9pcRagA9yRiVXAqCitoCmPwRxtP18wjCrYHSx6XUN_jtcMtJrnI
Message-ID: <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Michael Roth <michael.roth@amd.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@intel.com, binbin.wu@linux.intel.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, ira.weiny@intel.com, 
	david@redhat.com, ackerleytng@google.com, tabba@google.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2025 at 2:15=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Tue, Jul 15, 2025 at 09:10:42AM +0800, Yan Zhao wrote:
> > On Mon, Jul 14, 2025 at 08:46:59AM -0700, Sean Christopherson wrote:
> > > > >         folio =3D __kvm_gmem_get_pfn(file, slot, index, &pfn, &is=
_prepared, &max_order);
> > > > If max_order > 0 is returned, the next invocation of __kvm_gmem_pop=
ulate() for
> > > > GFN+1 will return is_prepared =3D=3D true.
> > >
> > > I don't see any reason to try and make the current code truly work wi=
th hugepages.
> > > Unless I've misundertood where we stand, the correctness of hugepage =
support is
> > Hmm. I thought your stand was to address the AB-BA lock issue which wil=
l be
> > introduced by huge pages, so you moved the get_user_pages() from vendor=
 code to
> > the common code in guest_memfd :)
> >
> > > going to depend heavily on the implementation for preparedness.  I.e.=
 trying to
> > > make this all work with per-folio granulartiy just isn't possible, no=
?
> > Ah. I understand now. You mean the right implementation of __kvm_gmem_g=
et_pfn()
> > should return is_prepared at 4KB granularity rather than per-folio gran=
ularity.
> >
> > So, huge pages still has dependency on the implementation for preparedn=
ess.
> Looks with [3], is_prepared will not be checked in kvm_gmem_populate().
>
> > Will you post code [1][2] to fix non-hugepages first? Or can I pull the=
m to use
> > as prerequisites for TDX huge page v2?
> So, maybe I can use [1][2][3] as the base.
>
> > [1] https://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com/
> > [2] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/

IMO, unless there is any objection to [1], it's un-necessary to
maintain kvm_gmem_populate for any arch (even for SNP). All the
initial memory population logic needs is the stable pfn for a given
gfn, which ideally should be available using the standard mechanisms
such as EPT/NPT page table walk within a read KVM mmu lock (This patch
already demonstrates it to be working).

It will be hard to clean-up this logic once we have all the
architectures using this path.

[1] https://lore.kernel.org/lkml/CAGtprH8+x5Z=3DtPz=3DNcrQM6Dor2AYBu3jiZdo+=
Lg4NqAk0pUJ3w@mail.gmail.com/

> [3] https://lore.kernel.org/lkml/20250613005400.3694904-2-michael.roth@am=
d.com,

