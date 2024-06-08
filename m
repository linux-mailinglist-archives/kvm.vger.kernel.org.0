Return-Path: <kvm+bounces-19117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD96890110E
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 11:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EECC282FAC
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 09:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1542C176FAC;
	Sat,  8 Jun 2024 09:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BY5QWEyu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADCED520
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 09:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717838131; cv=none; b=gv9H04EIMPSl571eMmkNj1Pc9mSje6OjwWoIlf0vcpQvsAArH8Tdv8xbX5GFQDUbBPXHd+CziDBLthaznTF1cpvwJR9TmnKAkUcUcnjtvCYOSrBO19BbPa8zyUp7H0NlJRHTUoct3ovUY8RBr2BZVwkJVjQLL6zpvTR8qibsOms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717838131; c=relaxed/simple;
	bh=p1lVojpqUKAdDBstIeirg/K6IVpXenpLR3phWqrqEP4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VOfPdF7VukoJPJHHw1Fy5d6D/B9fUa/Fsg83UJhAGkKMyozHPzNNz1pRQKTawUtGpbPJ0eir2PORWu02bSkFpxM5h2JMvFM5Aroc4R7PAP6MWKU42Sy+080QuOJ6HNsStB5CjKpg8V37wPZd19+vTiLjN3vHVOjVme12fB0HiS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BY5QWEyu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717838128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zziJ4IeetUOiQfnpE39MoHanWxp7ORqm+/oyO5SdbY4=;
	b=BY5QWEyu7qkr72fw2MjwRvfYM6f7uiPvs7fbYZCVScWf3lumVC/PLAL3ZUUVHPpnMqP2uG
	dkfT+AyEgkt6DFAFbeD5m6MMPVU4VZsE0LWXQlWwBmWYvAxxNNH/9umjS4fRs68+HFKM1b
	b+sdzdQaYH1wq5rZS03OyOiaigxyUy4=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-PbH6gsFHOhWp7NQaF6F4Hw-1; Sat, 08 Jun 2024 05:15:27 -0400
X-MC-Unique: PbH6gsFHOhWp7NQaF6F4Hw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2c1aa8d19bbso2678312a91.2
        for <kvm@vger.kernel.org>; Sat, 08 Jun 2024 02:15:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717838126; x=1718442926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zziJ4IeetUOiQfnpE39MoHanWxp7ORqm+/oyO5SdbY4=;
        b=IC75DAIlFXr1ZBbvg8oNLE0ECbhtDeNYmYi12nzi1EfWDoTnzL83B9q3E9Q6p/25ls
         SDFYBx3BpAPQfSRRZzFAQ7THWc1WKlkZn2CvDo429LjP9JNCMpFVFgDYiefcwUH1S28l
         9eRQFewbpUccx6osb7BTkPp9962R+v/eQI7D8TsSmCj2g5FX9ESSuHkJbnX/nl+Lri95
         U2Jvg1VyoIu4rYMiIOO28FwEuD1sQTNdGLyYH3fEFtoNsb4CwXENf9U/vj4LWT/cvkmI
         Hp97/LibaX0D/B+Fmz+ETgPwz63gYyxwRiuhXKSetqPT/OPP5cHB+OXpKOBlFZmDdvyb
         VdxA==
X-Forwarded-Encrypted: i=1; AJvYcCVY3MrPMehaWo9nPEOJ7f7taqC4GgqHPNkXfrjS5GX8sbmm9fiGdMEZxcRwbii1vhe1Z77H4q3io+LzGBWS3S2cwlOj
X-Gm-Message-State: AOJu0YzqGeuNs8uYkTlbkQNsk/TVQjoAgG3Y6ARXbh2KrjngDLQ9hvgj
	AehfxOZ67UZa0UEGvYcQNB2xg5wCb8AU1UtJIA6zo8a7y4WxKZethgcxEz32G4hXyVMDf5eEqtP
	CC52wrJQDZ7vG5V1DOgMWhFajrtf7YZTkixgW/ZM+e3BFxy8PD9fDKLf8nrmn38qi9uHIYOIsvv
	au1y+bz+BE7f1QICq0XcRPH67g
X-Received: by 2002:a17:90b:228a:b0:2c2:c69c:162b with SMTP id 98e67ed59e1d1-2c2c69c1a81mr2888229a91.44.1717838126089;
        Sat, 08 Jun 2024 02:15:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHH/yHFJSBKTcWd4UnM/3SiMDitX9wVnRnyWlygr70kLaYTyzwKpmXlv7Am86W2aT9ZBzLbDvmacXOrl8VH3EM=
X-Received: by 2002:a17:90b:228a:b0:2c2:c69c:162b with SMTP id
 98e67ed59e1d1-2c2c69c1a81mr2888222a91.44.1717838125756; Sat, 08 Jun 2024
 02:15:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
 <20240530210714.364118-14-rick.p.edgecombe@intel.com> <CABgObfanTZADEEsWwvc5vNHxHSqjazh33DBr2tgu1ywAS6c1Sw@mail.gmail.com>
 <ffddbc64ddfbf1256b79336864c2203d81df4448.camel@intel.com>
In-Reply-To: <ffddbc64ddfbf1256b79336864c2203d81df4448.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 8 Jun 2024 11:15:12 +0200
Message-ID: <CABgObfbySgLD5V2Si9gURoPfzYrR8n1DSDB16o24MfBwSsusTQ@mail.gmail.com>
Subject: Re: [PATCH v2 13/15] KVM: x86/tdp_mmu: Make mmu notifier callbacks to
 check kvm_process
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 8, 2024 at 12:12=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Fri, 2024-06-07 at 10:56 +0200, Paolo Bonzini wrote:
> > Subject: propagate enum kvm_process to MMU notifier callbacks
> >
> > But again, the naming... I don't like kvm_process - in an OS process
> > is a word with a clear meaning. Yes, that is a noun and this is a
> > verb, but then naming an enum with a verb is also awkward.
> >
> > Perhaps kvm_gfn_range_filter and range->attr_filter? A bit wordy but ve=
ry
> > clear:
> >
> > enum kvm_tdp_mmu_root_types types =3D
> >     kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter)
> >
> > I think I like it.
>
> Agree 'process' sticks out. Somehow having attr_filter and args.attribute=
s in
> the same struct feels a bit wrong. Not that process was a lot better.
>
> I guess attr_filter is more about alias ranges, and args.attribute is mor=
e about
> conversion to various types of memory (private, shared and ideas of other=
 types
> I guess). But since today we only have private and shared, I wonder if th=
ere is
> some way to combine them within struct kvm_gfn_range? I've not thought th=
is all
> the way through.

I think it's better that they stay separate. One is an argument
(args.attribute), the other is not, it should be clear enough.

Paolo


