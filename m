Return-Path: <kvm+bounces-8361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 019A884E6D7
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 18:32:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79D2AB2AD84
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 17:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3841D823C2;
	Thu,  8 Feb 2024 17:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QuUHc34f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEC07E594
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 17:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707413546; cv=none; b=q90aI4xd1XuXhv5dg8qdidf96aNoT9e1QX0aIYqA34b/mYojdNzMMpIaM5hXat7S21Eh/HQZE2BJrpeOTLihRuJ1lsOVTmM34F5gpSJCSnKUMuv3kAAkg8/yio/djt9k7GV+b2Hm25340EL4TCNoL6aVX744nVKnTqrYuvtLEvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707413546; c=relaxed/simple;
	bh=7NexPi4ZvLHEuMjPlTUsE8U/UuJJ7UuIYjbZcLB5JLM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j0XY5p7m+D7Gr2VI1IZ5lUrUEFF1sxIwhqDz3OCea9I2hPSSa1J8R4G8bOTRTnXYHbhNE4+qJlZ5ftdVgji8EX4hJ+5hXHjjC87IS5TQ+yFU5a9uo6HB0CxLKz1n6sTTQa4jeFNujgNLkRz5yPq+vVLD7Kt85o6W5j5mUHo1yrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QuUHc34f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707413543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7NexPi4ZvLHEuMjPlTUsE8U/UuJJ7UuIYjbZcLB5JLM=;
	b=QuUHc34f0WYaLegcwMMyWkO8RhPQrx5zDxB/tHA7kKgXG19LAlMN2JwpQ4HgGGVQi9bJG4
	yeUtfz2TVNRrpFQnIjeQDOi1vctxBwQ2Js/0hCKhURixHP36OkMctPJPT90LLe/PGvsHxE
	sDIAWIllYLEn5XPYoqJrXdMsRwn5Sww=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-FuXQUYwSMPKl0PV-U5-4eQ-1; Thu, 08 Feb 2024 12:32:22 -0500
X-MC-Unique: FuXQUYwSMPKl0PV-U5-4eQ-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3bfef09935dso1623750b6e.3
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 09:32:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707413541; x=1708018341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7NexPi4ZvLHEuMjPlTUsE8U/UuJJ7UuIYjbZcLB5JLM=;
        b=JooOkgXAJxyHCbGHRYQRlEPX/wKUMf7Dvpe7T2rRO1hVGrjHhhXOLonHyk5IQH8oTb
         WdC0ABrTr/8WAoh1dQEIc9VqDgc9r427D4mtt1SFvnvA4BLtmbu+9ECh23r0ZOJXXXR6
         7Z12MeaHgdM/BIPWHrVni+Tk1e10nRhV7FOHzfsuCV+faz1m6CDptln9u3gv0RJxm2pv
         w8pAYh6pJMc0XblAkZoH/JJS/vORLi3mFVtqmNIAF2F6Jtk9HSEhMSZaNDJmy+w2r6gZ
         CZO6H8uWLL9fmgY1SdzOfovNADwtp/k9WCWlK26pbY+la+4uZe0GaiOx1TxFwUNgCV/K
         IAZA==
X-Forwarded-Encrypted: i=1; AJvYcCU65TnjyxsNw0bE7lzH+KVZH3ruD9BmxiCWKKMppaWNrZuauzYFQIamgWG/GXq8e2ttfZbXAjqACAXz9jDDwVEZjFPH
X-Gm-Message-State: AOJu0YxbMMY5+YB0/Oda8RMnsd1OzOg5Rc0gZeyezY1/rJS5+2Id4/3h
	8pR7Q1jo5R5AgLaSAhqHefp/Nb0TvI4evzj06E6RfICDHzCfc7jdfNYWiVDPgUiHSqQGutA5f47
	txF2N0uRew3bzcTo04IpPQ4CbHQPi4oI+zsXm8vUKoKvHb1jfkZCPmcfGRsgew5Q24rfbffmwvq
	x4jDXVO7JECTpgdAsKk34T6QL8
X-Received: by 2002:a05:6808:1709:b0:3bf:d152:fb35 with SMTP id bc9-20020a056808170900b003bfd152fb35mr9469664oib.49.1707413541697;
        Thu, 08 Feb 2024 09:32:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFui1Jt+JpattIFcP1GZrYXY3zqSnk0oSHo/XW0zG1YLW12bXE2A85gSdzo7ME4SCqYMpnjXLxH4HbAyhaQans=
X-Received: by 2002:a05:6808:1709:b0:3bf:d152:fb35 with SMTP id
 bc9-20020a056808170900b003bfd152fb35mr9469648oib.49.1707413541467; Thu, 08
 Feb 2024 09:32:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240131233056.10845-1-pbonzini@redhat.com> <ZcOWwYRUxZmpH304@google.com>
 <CABgObfa1SmH0HDq5B5OQxpueej=bdivMTkVrO=cXNfOi09HhUw@mail.gmail.com> <ZcULFqXM_sA3dSY7@google.com>
In-Reply-To: <ZcULFqXM_sA3dSY7@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 8 Feb 2024 18:32:09 +0100
Message-ID: <CABgObfYMg_7b4U=RXSz0c8ouo5UKqpP2Ra48jkq9Gur7fFKs4g@mail.gmail.com>
Subject: Re: [PATCH 0/8] KVM: cleanup linux/kvm.h
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 8, 2024 at 6:10=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> > I can do both, a topic branch is free. But if you think this is in the
> > "if it compiles, apply it", then I can take that as Acked-by and apply
> > it today or tomorrow.
>
> Looks like you already created and merged a topic branch, but for giggles=
:

Only to kvm/queue to show myself how it would look like...

> Acked-by: Sean Christopherson <seanjc@google.com>

Thanks!

Paolo


