Return-Path: <kvm+bounces-18225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D908D221E
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 19:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8930FB221E8
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07147173338;
	Tue, 28 May 2024 17:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fw+LQHLg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFF118E29
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 17:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716915682; cv=none; b=tfnz5/KWqLs3Z1PPryHOdNPnjBYWtMw3paSp70k200GUCsXR3OVzFyRrh9YniCd/0yqGLN7ki9Hxa/aE8Gv5U0D6Jv4MGMCwK6TP8J0sKMB7yOC5ZwAk9EMWBSCzeeOihgS23pSnNobEk5Y5WqNyYtq6sVJ4LB0HwkB79gt/Kik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716915682; c=relaxed/simple;
	bh=aKqxiLnJn6Gis+JFsRxwOmnGd7SWBjOA7+Tkb7ACtA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e6STagmzLkl6iMLmlFTObDualnOmN1OIZV+KbjSkWjlrhi2xpTgP+K2uxMf6wCEDBTzdm6EoEEfzWTPSiScxORnREGqwyz2eYbpgJg+CAjMjY1TcFBzi6DqFOlNaktnVvirAtbutmljR8nOtkwEgOgYc5Tz/jvofwmMXzTUF2yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fw+LQHLg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716915679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UJwNJ7Iz4hN26y4XjDoNm7RTYYMRCtwNho8/txcFc8s=;
	b=fw+LQHLgJb59rUYs4rs2LWPhTfF5/0hCXk0mrFlvbLFJFWqCKsIfsUW+WVSV2L3Ppohd8x
	BQ+uH/DtfAURwP1h+N8l7gbUURgEGfCksFZFvO6uH6boSlaCQ2jjAztHx45fORZzc9zEmU
	IXZXD+25Ng/h86lpjZbbXpPeFjAR5XE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-TvRgLpacOXipd1GwsBnGow-1; Tue, 28 May 2024 12:59:46 -0400
X-MC-Unique: TvRgLpacOXipd1GwsBnGow-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42111702b3bso7158145e9.2
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 09:59:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716915584; x=1717520384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UJwNJ7Iz4hN26y4XjDoNm7RTYYMRCtwNho8/txcFc8s=;
        b=lL4Ira/3lkK/eWzFLYBrSPeJ32wYcBs+usOk1r71NGCpBgNVyjSD78D+QtQ3/WPPzH
         01uaBCeC7ffd8f8biVGy/sZZdofnGzG6vDU1Q+5A3OZWWLBvXLxweBT6+v0Y0Gycj4qP
         2DU1aGOec/mlBdZ//OvR+8gj92OHeRM6kbkY+0vBqqK7l3MfRJDubdvRJAGK/JYxXiGp
         GRKPhFf7YS7NSiKnK+fqAyKN825ee2U15Ho2WON6UDnYn8Wm56z/kdo1T5SKzhafPsSz
         XRr5r/l7yAaDorNGJQg0slMmNPEK2RrCOFcU/TFZdQ9LSOM9BYbUq6eAofXqU0PuGR+m
         uNvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWoSMCRbZHVeZVF2HC30Ahg+NYlimIKzLdyJj6Cv7hTAYCt4RTbe+HwxEAEOitMGysAZgb/XDS71O3/CcVh+lTMmkx
X-Gm-Message-State: AOJu0YwLVekVhT0F5SV/o7g5bZjc6+tQO53gZuGYLvnHLZtwNdzwDdyc
	fBew3vNq2WmCGU5k6o93LFD9jNJQNdBg/p2Ucd+meVnXUDY//1VmUntC+/XB9RRNhd7o+tObEGu
	VHc/rNqOTTYEQ7Sh2Iu0D+Gzz5cuHkDF0Kt9UtV6EWOq0T1xxmcaSnQXbKccOJfHa9c5rJu8wFW
	uRgL7C5E6SXOxBMjHlehkq5uQd
X-Received: by 2002:a05:600c:56d6:b0:41f:f144:5623 with SMTP id 5b1f17b1804b1-421089cd2a7mr87129045e9.14.1716915584442;
        Tue, 28 May 2024 09:59:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENDkUt7a9n5FDj0leqZ1a4dve3iLZ9ui1mbXwQB/hi6rgdH3IEVR3zfNxFeYH9jdtjpkKEg2SNdQe6F4yTyQE=
X-Received: by 2002:a05:600c:56d6:b0:41f:f144:5623 with SMTP id
 5b1f17b1804b1-421089cd2a7mr87128885e9.14.1716915584113; Tue, 28 May 2024
 09:59:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com> <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
 <20240516014803.GI168153@ls.amr.corp.intel.com> <c8fe14f6c3b4a7330c3dc26f82c679334cf70994.camel@intel.com>
 <b6e8f705-e4ab-4709-bf18-c8767f63f92e@intel.com>
In-Reply-To: <b6e8f705-e4ab-4709-bf18-c8767f63f92e@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 28 May 2024 18:59:32 +0200
Message-ID: <CABgObfacywzF45FMM+ei=ei36CJDmfFvhWR-bzpqtqjjPWeF+Q@mail.gmail.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"seanjc@google.com" <seanjc@google.com>, "sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"Aktas, Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2024 at 4:11=E2=80=AFAM Huang, Kai <kai.huang@intel.com> wr=
ote:
>
>
> >>>> +       gfn_t raw_gfn;
> >>>> +       bool is_private =3D fault->is_private && kvm_gfn_shared_mask=
(kvm);
> >>>
> >>> Ditto.  I wish we can have 'has_mirrored_private_pt'.
> >>
> >> Which name do you prefer? has_mirrored_pt or has_mirrored_private_pt?
> >
> > Why not helpers that wrap vm_type like:
> > https://lore.kernel.org/kvm/d4c96caffd2633a70a140861d91794cdb54c7655.ca=
mel@intel.com/
>
> I am fine with any of them -- boolean (with either name) or helper.

Helpers are fine.

Paolo


