Return-Path: <kvm+bounces-36238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06C66A190B3
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 12:35:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AE5E3A3ECE
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 11:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7755A211A33;
	Wed, 22 Jan 2025 11:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lh1TCTUW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05216211A15
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 11:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737545713; cv=none; b=n23S5MPk4tTDWvaMIOnWDG9YrjksTLMrDvgGMoFnyBKveIU0l3S0Gyyk9Xa3yWobmjHolFsZnQu0SmltQ3yXpc8XJRWIipg12G8ynsUVa4tdp4G7za/IqN3V0tzUzhvkqIp4/IdNFv3CYPicrkRY/fot0nNAGTikRMwovd2M8N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737545713; c=relaxed/simple;
	bh=kUnZi53CxLhELZQ4CKnK/GrzEfzp798petRIlYLogQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I5aYU44tqPCbJZviTIiVIbwpSpLmJlnlmn0KGlekRCwzcl+EOK+Uq7UxBgB9goGGEl7vhQcAU5WBYRdJuFDTgIOgXuYfYZiRQ5NY+O7N5kgWzxwY1pc2AyX6UOiW5i626PVBqV14zUK6Ild4LF6vjEI8W4XGIxghpOt7QEygYIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lh1TCTUW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737545710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LIW2RrpZb08kwEsM3N55cp439NM0TAOF6bYvV2mcLz4=;
	b=Lh1TCTUWbBDafcCio7NEryqjiChRjHJ7yjfqygYu0odg6KV1k/G1eM84R9URvD5TZoLNTo
	W34UYyqOELoJ4SmHRpqKrcTJHLH+hNsXIWwMWJdTaYPpaSn7zwuMyFrh3A9RfqkZ4YKc8c
	Pr5krqU0zu7/OK+WXSfXTUky1C+4Dsc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-HyTcByckMlWjfYa7SvcHDw-1; Wed, 22 Jan 2025 06:35:09 -0500
X-MC-Unique: HyTcByckMlWjfYa7SvcHDw-1
X-Mimecast-MFC-AGG-ID: HyTcByckMlWjfYa7SvcHDw
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361b090d23so35523875e9.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 03:35:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737545708; x=1738150508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LIW2RrpZb08kwEsM3N55cp439NM0TAOF6bYvV2mcLz4=;
        b=Kbu76KGKlYkj6eB8mv6P1s99prP5h54hKO12x1cxPglrdMMRGXZCt+8Tf9qVDIsUAu
         7IsXIAFybWArGbctPb4dlJeJvQ4Rsgh7U3wk71a/BwBeZxFwQHnbgQQqmfLYcoWKIPLL
         TPNtxddMNMGC7eN7A5OpsiK1EcOGxGxhJEPu90nNcrtAdgkSKT+54BYnOuS0vwfM6T0h
         uTSSlygnjy4QKRNGpL8aCExKujXqVNOskKQ3s75PJtQuLUTakqGOJ2OlP5UxR0cF/u2P
         lWtsa3LU7AsLRhhAC/r156cnaH86grHye/yZqhY2N6v9MveOho27Ag/t2AT3uu9AT5Gy
         O68w==
X-Forwarded-Encrypted: i=1; AJvYcCW8a2foWFMzlj3l8EsDVKOBX/vndZJasq9mB5UpqkBCl7BQrEIDO5OZzXFHCakCbVd3eMI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMcWuOqAtNzP1v0iuF3kHbhEwQOvot1zz+Hd3UgkScUKDUtxRK
	5Q2oXIGy9KHQC8Q4R4sBUseo9G4J12HUgavQoWph6UA7aUk+xMwIuKxKoDGnLyURUL6i4pfkh4Z
	rG8qoN/O19X+Z+T+ZNnZsDk5eoJ4mwPrRet42HVTt+k0yzxjA2FfINug6nQy8xpP0myA+IZkX+m
	nv0Qee8VXk6L/+5/nljNq86L+h
X-Gm-Gg: ASbGncuavsGPBOgo2ukZSvR1wxIE4qVZ3G7Wh7GQAT65rVOflsg2qggRmhGKTkvm13d
	yFCWnuTuTboARoMv1pCLkMyb6/3N0pU52/0KaVpHaQH1BMAbpd51B
X-Received: by 2002:a5d:59ad:0:b0:38b:ed7b:f78c with SMTP id ffacd0b85a97d-38bf566f41cmr18078511f8f.6.1737545708294;
        Wed, 22 Jan 2025 03:35:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGBEDi9vf8dkyhNozAmsi+wbLlIhneovVljfCcbgIwZ4a7c3sWHlocanWluG2OEmdh7ejryg8Td+68lBy3agzk=
X-Received: by 2002:a5d:59ad:0:b0:38b:ed7b:f78c with SMTP id
 ffacd0b85a97d-38bf566f41cmr18078480f8f.6.1737545707982; Wed, 22 Jan 2025
 03:35:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com> <20241209010734.3543481-14-binbin.wu@linux.intel.com>
In-Reply-To: <20241209010734.3543481-14-binbin.wu@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 22 Jan 2025 12:34:56 +0100
X-Gm-Features: AbW1kvbxdoAqejv6wQeII0iNJrMFwYwd6zslL8i6npziPMNoeouDZUvWRi5h00Q
Message-ID: <CABgObfbFX+3rCcB2teTEMO=EPiuOnaXjMW+tR3UF5t7gWwiNwQ@mail.gmail.com>
Subject: Re: [PATCH 13/16] KVM: TDX: Add methods to ignore virtual apic
 related operation
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@linux.intel.com, isaku.yamahata@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 9, 2024 at 2:06=E2=80=AFAM Binbin Wu <binbin.wu@linux.intel.com=
> wrote:
> -       .hwapic_irr_update =3D vmx_hwapic_irr_update,
> -       .hwapic_isr_update =3D vmx_hwapic_isr_update,
> +       .hwapic_irr_update =3D vt_hwapic_irr_update,
> +       .hwapic_isr_update =3D vt_hwapic_isr_update,

Just a note, hwapic_irr_update is gone in 6.14 and thus in kvm-coco-queue.

Paolo


