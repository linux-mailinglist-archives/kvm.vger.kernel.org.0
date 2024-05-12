Return-Path: <kvm+bounces-17268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4517C8C3544
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 09:16:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75A431C20A56
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 07:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A9111CA9;
	Sun, 12 May 2024 07:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DXPRjI1f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E932E3D6A
	for <kvm@vger.kernel.org>; Sun, 12 May 2024 07:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715498208; cv=none; b=pn7mGtUfOr3LsqBUZgTttYmIDVRCDUe0zkD8tm4pu6tCOCSUGpn6vnXg6QSImp3p4MdsApG+z8RRBulwpgsATts8dTvOQYy9D7QmTGiapHukHU3yDAxKPJpvganymxBbB3xaKLdEqAbvtcjJZ2KNGSAml63Vj8kbKOFXhmNhRnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715498208; c=relaxed/simple;
	bh=llPJis9jHxYgJNuKqOaYb6WM18KDn6Zthld3LXdW+rw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QT7oQJX3ECT1tirWt0efES32f6kDtVATrgQF7dolCUcXh/o1OwtCSfxv/3nA+V3/0WqckcK1G3NfpAyP4wWQk6+W84t/V3xktjPXlgW7NotFZnTdBE2Q+7T8lWZTpApCLPljI0LKDtYycGTjsuJ1Vw3uHaBz0u8lX1e2VLC3wH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DXPRjI1f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715498205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=llPJis9jHxYgJNuKqOaYb6WM18KDn6Zthld3LXdW+rw=;
	b=DXPRjI1fALMGPJhT3gseRUqwO/UVSxxxELurVDYXCrVKodaaqHAYzkrRrveemCKEcAS33m
	9DVvTSOJKLEIiTvOJPPn9k7I9/v2pqpJKLR+i4mN/YlsY/xXvSIul1L5ASl2M7iAGLNYZp
	r+1kZ5phz1VL3WCMtNcfali3N10jzG0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-x3uIsCeWOYSPu5P3kjb9nA-1; Sun, 12 May 2024 03:16:43 -0400
X-MC-Unique: x3uIsCeWOYSPu5P3kjb9nA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-34c93732095so1457416f8f.0
        for <kvm@vger.kernel.org>; Sun, 12 May 2024 00:16:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715498202; x=1716103002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=llPJis9jHxYgJNuKqOaYb6WM18KDn6Zthld3LXdW+rw=;
        b=KDvLmZhT02NEN9dD8pbR/1U7Bk82KgeJ8IKBr8WCHG6LOWPxC5+yrrSVAA2D7hxtKN
         AzScb9nSuQR10TdpkfY4f1n7omYidRBTc/VdIjBpzrk6kbINqAzk4vXUJzvEvEr3/ys5
         pfAB0MTo/Nan3TZnwvvdX0kUE9zCy/rNSSViH1qcmlYn50P0XhEOjBTnT9HiOx3PUWo+
         A/ZDUdhZqAcIfc6au/KURr17LWEIqPX27b3WYUjo5/JxJyKxHLGCR+WUN0+YnhGWxRlm
         yeHoW80hSStiIwv/ai3dGSF083K1wRtfZnTJk0mNWgi6wqWnTgcOndZePMhPm245LmG7
         0F2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWSVvRC6cH7CN40TOUVJP+3wXuKqobKt3CkyQ1TAp/J73DiNtM6YfasTzWVS4xowh9BclG3MC1JI2wX7RKVMMn7L/KM
X-Gm-Message-State: AOJu0YxtiP2EXpLKym1B/eVzX5js/m+9RsTixyKlOuKO5/qS0T5Z89MW
	shLa3CCVgL0P1yOmcUi3pa65+0VZ31TTO/bw2sA34ASD8qYZWynXq/n5Enuy0FxE/zzUAY7Nuh/
	qecUinDYw1pzhmdby79MIY2ywC49FSuzZ1zR/TrcICzFyYTHP4+5jTDMB5aRdnmSM4jbGIZEfKS
	DODSy3VLvd+H+5zw/qHqFCAemE
X-Received: by 2002:a5d:4d43:0:b0:346:92d2:a496 with SMTP id ffacd0b85a97d-3504a7388demr4503669f8f.29.1715498202234;
        Sun, 12 May 2024 00:16:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6BcSwq6X8dx97vsGDZlMoQs6520j3e4edXNcZL3E4BuTPppqRk6MNDV9SpKfoH0O7ZE891G+pNO3dvQPK+1Q=
X-Received: by 2002:a5d:4d43:0:b0:346:92d2:a496 with SMTP id
 ffacd0b85a97d-3504a7388demr4503646f8f.29.1715498201833; Sun, 12 May 2024
 00:16:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240511095237.3993387-1-maz@kernel.org>
In-Reply-To: <20240511095237.3993387-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 12 May 2024 09:16:30 +0200
Message-ID: <CABgObfaMMb4f75nitSiCgYZvOU=dMoPh0Lrs-fz8WVxyxnOw5A@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.10
To: Marc Zyngier <maz@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Colton Lewis <coltonlewis@google.com>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Mark Brown <broonie@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Quentin Perret <qperret@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Russell King <rmk+kernel@armlinux.org.uk>, Sean Christopherson <seanjc@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <zenghui.yu@linux.dev>, 
	James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 11, 2024 at 11:52=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here's the set of KVM/arm64 updates for 6.10. No new feature exactly,
> but a lot of internal rework, improvements and bug fixes, However, it
> is pretty good to see that the Android folks are resuming the
> upstreaming effort after a long period of silence.
>
> As usual, details in the tag below.

Pulled, thanks.

Paolo


