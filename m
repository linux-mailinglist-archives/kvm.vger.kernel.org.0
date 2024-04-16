Return-Path: <kvm+bounces-14900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5C4A8A776D
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 00:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FF0C1F21873
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 22:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A8767FBAA;
	Tue, 16 Apr 2024 22:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SXN50O1Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E032317736
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 22:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713305019; cv=none; b=t12/lsIqqfKyRz3v8tvpQ+wdsEHWh77SGpftXHM6e/uBJapV+4OZm4nXqA9WfWYmwna1wwqLfQMu135sqyOjH0sQUNC0UEy8q1m+1yipQPYTGC1js6tP8waCN0hiF3mP/KgnArLQkRkztVmOSu88lHUHTIMHsDumg7UdJ/cwk6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713305019; c=relaxed/simple;
	bh=pgVBszKn+oJK1a+kEuPlUNLOHqXoa11Qlz/3X1dd+Pk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UZBDfjjg7DeJlJlzydtZ1ZDQJ1K0YbJRPLos60dG2CvIG06CGT8vXooQBNpGOrgU8oI6s65bzFnPECRWgM9OZPXgPvJdlzN+FZM45AZE9mlSQRgBDJ/XFlpUPwfhXLI3tl7BKWYchbVuOfzp8PPkx9JgvoLrgY7JoWbyqE1bt1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SXN50O1Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713305016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0mXC6erWL5zoj0Mw8kxXnTBZ+XFTfEZhlYEfC3KPt4Q=;
	b=SXN50O1QT6imDSoCo7YYLXqsbqF2PMERCAsVMOvW+qM/vzxD7dwe5m7hVNAbynExAjNGRQ
	F1QqC/mGez6SflgYyDVAnjIYachiAX3oSnVjkRq8bMbTjdEkTG7wcsgP16t6CAGdPCezHO
	jTQ4d1aluvp/KCXEM2kC66QzAOie4cg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-2CO9qpxvO56q6Xs0oXIAPA-1; Tue, 16 Apr 2024 18:03:35 -0400
X-MC-Unique: 2CO9qpxvO56q6Xs0oXIAPA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-343bb240f70so77994f8f.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 15:03:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713305014; x=1713909814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0mXC6erWL5zoj0Mw8kxXnTBZ+XFTfEZhlYEfC3KPt4Q=;
        b=jS2D36xkUekUmOlnZh/EiNqBPrsioAQ5qJHmoSLV97WGl1On7mTX0wXsGpvC+wppN1
         IiMbEvJXfBXE9+2x/TD7p1xkBeY8/4PP3pbQm8vVTgzBr08ZF5CSrThG4pCa4T2crMr+
         vT1Zq9sfWcN6BDwhx+tvBoD2tw2sI4RyTZb6qKCwc+Gdtfi2l3AUAXXFz/Oqimd93ngm
         0y4kToyrOE9QExHoSZLvOm/4q09nox33r69QvuvY1gMV/nypf2KMV8ZTMRoWM6UUVTAz
         D9WLrm8luw3kbSYG2H2nMFSGVFmJhh3pw4ZHn+mZ7QHuvhxsmhtcdn3EIj6lmtvr8n3+
         6CGw==
X-Gm-Message-State: AOJu0Ywxt0PZZ1K/BvF1Z+vfyDEXOSaQ1BKp1CGxQsEF8A/fDTi+bXRY
	NoTt/PKiuppo3neRmf4Af81R/rUi/3B3XH2s1K0xKsXt+ItiwZHQonzdP3xEyXHLsCqc7TR0kjk
	xp0dbjcNtKO3FabEsa0JTGJtDCU82vTBjtKsHz8Jgw22JdmLFzy7u4o/l67wXsA4VvAeUYOayms
	0oVlTO4d87aPijpE5bUrECGKa+
X-Received: by 2002:adf:f304:0:b0:346:ac24:ee89 with SMTP id i4-20020adff304000000b00346ac24ee89mr416661wro.9.1713305014182;
        Tue, 16 Apr 2024 15:03:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfLfv5BpK9ErpOI8WTzMNuyWQvSg/gXs7odOI6qSNYdgMaRlG33KUK38HzJrw4XLe3Ak9IZUgnLRZyeVrbVfk=
X-Received: by 2002:adf:f304:0:b0:346:ac24:ee89 with SMTP id
 i4-20020adff304000000b00346ac24ee89mr416651wro.9.1713305013875; Tue, 16 Apr
 2024 15:03:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
 <c7091688-8af5-4e70-b2d7-6d0a7134dbbe@redhat.com> <66cc2113-3417-42d0-bf47-d707816cbb53@oracle.com>
In-Reply-To: <66cc2113-3417-42d0-bf47-d707816cbb53@oracle.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 17 Apr 2024 00:03:21 +0200
Message-ID: <CABgObfZ-dFnWK46pyvuaO8TKEKC5pntqa1nXm-7Cwr0rpg5a3w@mail.gmail.com>
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
To: boris.ostrovsky@oracle.com
Cc: kvm@vger.kernel.org, seanjc@google.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024 at 10:57=E2=80=AFPM <boris.ostrovsky@oracle.com> wrote=
:
> On 4/16/24 4:53 PM, Paolo Bonzini wrote:
> > On 4/16/24 22:47, Boris Ostrovsky wrote:
> >> Keeping the SIPI pending avoids this scenario.
> >
> > This is incorrect - it's yet another ugly legacy facet of x86, but we
> > have to live with it.  SIPI is discarded because the code is supposed
> > to retry it if needed ("INIT-SIPI-SIPI").
>
> I couldn't find in the SDM/APM a definitive statement about whether SIPI
> is supposed to be dropped.

I think the manual is pretty consistent that SIPIs are never latched,
they're only ever used in wait-for-SIPI state.

> > The sender should set a flag as early as possible in the SIPI code so
> > that it's clear that it was not received; and an extra SIPI is not a
> > problem, it will be ignored anyway and will not cause trouble if
> > there's a race.
> >
> > What is the reproducer for this?
>
> Hotplugging/unplugging cpus in a loop, especially if you oversubscribe
> the guest, will get you there in 10-15 minutes.
>
> Typically (although I think not always) this is happening when OVMF if
> trying to rendezvous and a processor is missing and is sent an extra SMI.

Can you go into more detail? I wasn't even aware that OVMF's SMM
supported hotplug - on real hardware I think there's extra work from
the BMC to coordinate all SMIs across both existing and hotplugged
packages(*)

What should happen is that SMIs are blocked on the new CPUs, so that
only existing CPUs answer. These restore the 0x30000 segment to
prepare for the SMI on the new CPUs, and send an INIT-SIPI to start
the SMI on the new CPUs. Does OVMF do anything like that?

Paolo


