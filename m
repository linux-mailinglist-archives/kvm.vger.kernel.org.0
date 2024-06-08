Return-Path: <kvm+bounces-19119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87010901120
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 11:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 646B71C213B7
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 09:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77FF2176AC5;
	Sat,  8 Jun 2024 09:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N26kKGXg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6ACC25761
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 09:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717838762; cv=none; b=O/SKr7Gaimeuhu26fNXMBlz57MbR9Sx/0UeGoP99t5fELPTHvO6jySJqprlTbEvcUgHURlUUMuSzJsLeNe5PCO+CcIL3iTZXPE5JLUe5b0R1thXGHTfJ+y8p0vCG/t6dP+UqVjQhrO82JtAyiSXPWZNkRUzj2LVrSiY28TjX7LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717838762; c=relaxed/simple;
	bh=IytfdB5VJ0hTZVIZ58WgO+XxvdZCWiQDHH+30k+/zGc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fj47BCJNsPF2awRKPLK7jIM9IeGwVFJBvf7pR1g547TKBDidPWerEyB3bMGDFhguq3e4zz8kv5CUN5k5+yjHxN3TVSB+XN4wSSDF8AbLeilYCZ7YrWeqy+zLOohueNEHHpZqPcJ5sf0WClp95ha2IkH6TwIELumcy8CupfHVPck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N26kKGXg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717838759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kNnj0sYqfR+gPARY56d6Q9vYuZ/hYLYTEqKn/JW0FmA=;
	b=N26kKGXgNfexOq+CtL80WUizMruoc25uvy+x0UmDYZjsOmXHGQMnGyrl4u+rTSr6hbqI2N
	Gvp94pBs+o5i4/70slA81yBtdVHMEw36QPu8SXSJ3VmPVSGIWvZcK8RRiMBmIbzhwioLew
	zMc5819aAYOaur2e/Ytesdi7BF/8XQ8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-fQwJfkoxNhe40rCeaDOprQ-1; Sat, 08 Jun 2024 05:25:58 -0400
X-MC-Unique: fQwJfkoxNhe40rCeaDOprQ-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-6507e2f0615so2888748a12.1
        for <kvm@vger.kernel.org>; Sat, 08 Jun 2024 02:25:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717838757; x=1718443557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kNnj0sYqfR+gPARY56d6Q9vYuZ/hYLYTEqKn/JW0FmA=;
        b=TGGrqek5AkdMqXI9dTqbyiRiXZn7t1KdlwTOSTFu6/98Ync9R855PFZgBqlgKJ+6lP
         VhYflyDv6/92cxM5cC5y67vTqdoFy0LsIpi2AgfWjS1wzM0E+toM0T9PVZE4DMmag3Xt
         yrtMANPqBB9jO8Uxgo53KryCfsNtuaQkRQeuPBfAFEJJ+RP+YhCrSA93NLqp60isUzWr
         V4GZBTpCq6iBvV98sYa8usthj5D6M0GV7ZlPUyRBNwlrChWPwPQfRIgu7M8koL2JPraQ
         1EJqknRK0iXSBKbdGGgOCfM0CJ/IcyYP1hvSAqaEd7rx9ekuEzLLQ0L747GX13y51A1g
         07hg==
X-Forwarded-Encrypted: i=1; AJvYcCXGHn8WODlI4tTxtRevOr4VWQZazBls9FoJW2G+TYhJDFRO2oU/NmEE8L7I4mGJ5sOZJvG8xoADYoIQtcO3/QiQOwhB
X-Gm-Message-State: AOJu0YzuNQdk9SRPaoqxFCKICC88+AoNajeKWMPDyxUBo6cJqLInLmMD
	BaQbdrgAmcqKXUvMfXxh9u73By4/rOMGiEE7VLD/MXPEzWiM0xZP/S0KrWjWuob5VGRobywH7jL
	pIJmLdTbdpTOubEUfYTpSmf3mjnAkI9CdAXnEhMS87wKfO4zXze9Pvyf5TKUnQ/r874QM8iUYZZ
	Z1rWkfQRvvkySxxLiF6tpWxTkD
X-Received: by 2002:a05:6a20:7fa8:b0:1b0:25b6:a749 with SMTP id adf61e73a8af0-1b2f9c6dademr4561005637.48.1717838757076;
        Sat, 08 Jun 2024 02:25:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWqRg3bRs7PxBEQj4rFgxhnnwuylpf3QVlbI5p6oRpjnrs47tzSwHWFfWFxedIavseDuEL286Yab0DfhePYmA=
X-Received: by 2002:a05:6a20:7fa8:b0:1b0:25b6:a749 with SMTP id
 adf61e73a8af0-1b2f9c6dademr4560990637.48.1717838756694; Sat, 08 Jun 2024
 02:25:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
 <20240530210714.364118-12-rick.p.edgecombe@intel.com> <CABgObfbA1oBc-D++DyoQ-o6uO0vEpp6R9bMo8UjvmRJ73AZzKQ@mail.gmail.com>
 <c2bab3f7157e6f3b71723cebc0533ef0a908a3b5.camel@intel.com>
In-Reply-To: <c2bab3f7157e6f3b71723cebc0533ef0a908a3b5.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 8 Jun 2024 11:25:43 +0200
Message-ID: <CABgObfYwdaMsL0FBS+3RH-sYmXBoU9g_1zCgrnD=zZ5oYoYcmw@mail.gmail.com>
Subject: Re: [PATCH v2 11/15] KVM: x86/tdp_mmu: Reflect tearing down mirror
 page tables
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 11:46=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
> > Also, please rename the last argument to pfn_for_gfn. I'm not proud of
> > it, but it took me over 10 minutes to understand if the pfn referred
> > to the gfn itself, or to the external SP that holds the spte...
> > There's a possibility that it isn't just me. :)
>
> Ah, I see how that could be confusing.
>
> > (In general, this patch took me a _lot_ to review... there were a
> > couple of places that left me incomprehensibly puzzled, more on this
> > below).
>
> Sorry for that. Thanks for taking the time to weed through it anyway.

Oh, don't worry, I have no idea what made this patch stick out as the
hardest one... Maybe it's really that there is such a thing as too
many comments in some cases, and also the mutual recursion between
handle_removed_pt() and handle_changed_spte(). Nothing that can't be
fixed.

> > > +       kvm_pfn_t old_pfn =3D spte_to_pfn(old_spte);
> > > +       int ret;
> > > +
> > > +       /*
> > > +        * Allow only leaf page to be zapped. Reclaim non-leaf page t=
ables
> > > page
> >
> > This comment left me confused, so I'll try to rephrase and see if I
> > can explain what happens. Correct me if I'm wrong.
> >
> > The only paths to handle_removed_pt() are:
> > - kvm_tdp_mmu_zap_leafs()
> > - kvm_tdp_mmu_zap_invalidated_roots()
> >
> > but because kvm_mmu_zap_all_fast() does not operate on mirror roots,
> > the latter can only happen at VM destruction time.
> >
> > But it's not clear why it's worth mentioning it here, or even why it
> > is special at all. Isn't that just what handle_removed_pt() does at
> > the end? Why does it matter that it's only done at VM destruction
> > time?
> >
> > In other words, it seems to me that this comment is TMI. And if I am
> > wrong (which may well be), the extra information should explain the
> > "why" in more detail, and it should be around the call to
> > reflect_free_spt, not here.
>
> TDX of course has the limitation around the ordering of the zapping S-EPT=
. So I
> read the comment to be referring to how the implementation avoids zapping=
 any
> non-leaf PTEs during TD runtime.

Ok, I think then you can just replace it with a comment that explains
why TDX needs it, as it's one of those places where we let TDX
assumptions creep into common code - which is not a big deal per se,
it's just worth mentioning it in a comment. Unlike the
tdp_mmu_get_root_for_fault() remark I have just sent for patch 9/15,
here the assumption is more algorithmic and less about a specific line
of code, and I think that makes it okay.

Paolo

> > > -       /* Don't support setting for the non-atomic case */
> > > -       if (is_mirror_sptep(sptep))
> > > +       if (is_mirror_sptep(sptep)) {
> > > +               /* Only support zapping for the non-atomic case */
> >
> > Like for patch 10, this comment should point out why we never get here
> > for mirror SPs.
>
> Ok.


