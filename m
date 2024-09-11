Return-Path: <kvm+bounces-26493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F241974FD9
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 12:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60E591C228BE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 10:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B088185B7F;
	Wed, 11 Sep 2024 10:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EmZcWpyX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19A7187543
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 10:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726051169; cv=none; b=PFrz/vqO2o97q3D01R+3UkVNUHc3eCubMbcLdJseA4PR/c2ddwmGssEEi4kzcWPzSoer4xlYT0nDHAF6/mDnxHHyVm5+R2UPQV5M3284HX51EFzeP6yV5w6jwaBWbTInT0gsLXVbzEY6gpsOXQUHqIB2XXHGdY2/tlE8zMhTtTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726051169; c=relaxed/simple;
	bh=UJ8q0kTm4tCbpogVJ3elIuVisVpgJWMaWJ0s442CPXQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tkt4uU//sguAhfZHPzNaUfZOfsUn42gNQHUjX84W/mXlr3BMHnXh/6yIPOlE/7jaaAXqKvY6VPCieTbdhgh+Z1Buhbc3mkpXoLH8l89F5V4eVqv0KRTwnAauCSvFtyWqWrzqCGnj/h4vw6lVA0jerBE+iiQHQiqBe98Iv0RveJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EmZcWpyX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726051166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UJ8q0kTm4tCbpogVJ3elIuVisVpgJWMaWJ0s442CPXQ=;
	b=EmZcWpyXHBd+0SYhYb1xx40nziVDewd8d7o5K4bGfP7Abu39kRndLsjgutbmLzSsr2KTRR
	ibpKwg9GOMVKNNHbR3aaIP7XDU90wf6RI6vxXudOwgAPVJCovhlYxNcAe888LybleHQDk6
	jgA7TzrEjbEb7aQguq2G6dKSggFzEao=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-1tXLuR1mMAOMu1ibeRgeCg-1; Wed, 11 Sep 2024 06:39:25 -0400
X-MC-Unique: 1tXLuR1mMAOMu1ibeRgeCg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42cae209243so30107595e9.1
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 03:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726051164; x=1726655964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UJ8q0kTm4tCbpogVJ3elIuVisVpgJWMaWJ0s442CPXQ=;
        b=oLuhMBW//0XqSZLd2IJ1R4O8tYLeuOjK/LjXHie/AnBxC7FC+M23WshF4IpaspSs1n
         6u0jPEFSuXAwTtz9k7c0J6inobCRvcmYQ88Yb74sbrbzzzYZBSC1QWUstV3TfdtRzhdH
         zlhtBo9NI1e6e9GMvFIjNqOWNYI0R6hD6bXf/7m0mzSXjV3EUiagv7KbpluXJtMFuOcV
         E1H8a0T2EMeAsGJOubRDpdEXM0lNT8E2FodTyhzLlHEYmtLoL6q9kGjdmHMltc78qscp
         gBZg01aM8FFZbjZXIH+EAC1IqdAGd6OJgENHYKzPnL2VaHi3jseR5VtCc/6y7PkwPDt9
         HrjQ==
X-Gm-Message-State: AOJu0YyNZrsWNgUJUk2KqTlfexu9DCVVpNy7x2J4uAvPq36NTSFy0MXY
	nQ4s4RlwX+W0wH2FQ6WYuO7RRQwikQUnMEbU7dQIY5WtAPOuktJsQqGh/ODMzi7iJ+CvRL0eUzB
	76e041iGf5j9b04f9mLp4oxLwSS6rwheQCJpg2cFpZJIP8OPy3wsz8xNvwP4x8LLsbkn4RhEHki
	MZ6VP2EMIrtdzusxzi/G/rWheO
X-Received: by 2002:a5d:47ab:0:b0:374:c122:e8b8 with SMTP id ffacd0b85a97d-378949ef675mr9997546f8f.11.1726051164173;
        Wed, 11 Sep 2024 03:39:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3Gb/2HI49PjllPj8NU1cxqsZ2QD298EaN2kurZK5VW5FJwIMKpjSqMMZjF+qdADR0VC1HUbkbMjjhTqnVqvI=
X-Received: by 2002:a5d:47ab:0:b0:374:c122:e8b8 with SMTP id
 ffacd0b85a97d-378949ef675mr9997525f8f.11.1726051163746; Wed, 11 Sep 2024
 03:39:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-17-rick.p.edgecombe@intel.com> <09df9848-b425-4f8b-8fb5-dcd6929478de@redhat.com>
 <2f311f763092f6e462061f6cd55b8633379486bc.camel@intel.com>
In-Reply-To: <2f311f763092f6e462061f6cd55b8633379486bc.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 11 Sep 2024 12:39:11 +0200
Message-ID: <CABgObfYiMWrq2GgxO4vvcPzhJFKFGsgR11V52nokdbcHCknzNw@mail.gmail.com>
Subject: Re: [PATCH 16/21] KVM: TDX: Premap initial guest memory
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 2:30=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
> Arh, yes this has details that are not relevant to the patch.
>
> Squashing it seems fine, but I wasn't sure about whether we actually need=
ed this
> nr_premapped. It was one of the things we decided to punt a decision on i=
n order
> to continue our debates on the list. So we need to pick up the debate aga=
in.

I think keeping nr_premapped is safer.

Paolo


