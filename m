Return-Path: <kvm+bounces-36028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FC43A16FF5
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:18:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 512FE1887C86
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF3EB1E9B1B;
	Mon, 20 Jan 2025 16:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WapR7sdT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CC51BA89C
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 16:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737389885; cv=none; b=hUGAXet8OzBnIO4lmn7D7uHC50y8CdIfzOTIcR9y+Oibo1bv3qwAgJNXIvoo5zjOYMdhZQKlkvYjITEXCVeEUQgl6blNrZhBAHIuxdqLaAZ/OCUd9ZIt+aOcIVUXtg7vOpwVRF0dcsyUgIrEB0RXUuykBSOhj7eZIaqgk+kTcHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737389885; c=relaxed/simple;
	bh=j/jD5tJCcA/WovNVo2p6dab+dCcttldVNM8vlz51jkc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZlYI5D8ma6FV1juNbqM/uCIcU1nBCVbAjJVnHNyvrbWkSJk2GHmrm9UxaJH+A05NsURym/oeNqh90h69F4j7LNLr0GPgs4r9lw0QT+7vfNmhiv4+c1V7laqo2mk1FSe25ZC524/vMSDItCxuKE9FwfBzdUqVTpALXSnL6554STA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WapR7sdT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737389882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Y9L5XYBnMW0BiFxPzq7quszMYy5qgR0Mg0kvwElYMk=;
	b=WapR7sdTwfzDjAQ7cRepHcVH6xgHisTKkNxgazM/ljvygCI971xpL7/abJgmxGf47kGiNO
	LOpN/REDEfyh6Mfyb5xmAi3ek/msl742vxYpFjF5s9DxUGnZUHAA7iUC4zUPATl81DCcsl
	ocKkMgpyKHqTDnwKX4K9bZVUUa+W5j8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-joY_ryUSOROscWf4-d6B_A-1; Mon, 20 Jan 2025 11:18:00 -0500
X-MC-Unique: joY_ryUSOROscWf4-d6B_A-1
X-Mimecast-MFC-AGG-ID: joY_ryUSOROscWf4-d6B_A
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4359eb032c9so36514135e9.2
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 08:18:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737389879; x=1737994679;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Y9L5XYBnMW0BiFxPzq7quszMYy5qgR0Mg0kvwElYMk=;
        b=HVDAsOx8UZIf5TpSIu6X8HVYMxRJXEyPhgCKs28S4QA7TDyyECCWsFTeerYm4CXwD4
         31xQt5kRT+BS2sMhke2+n58UM5LeST1axTkNNMwU4ls5KEN6stuUoPXInqSVHMiq/E0Y
         K1jo21BjDk1bB7J9BMBOb/mP9M8hVGs6l5MAks4ewV5cEt1AlrWqChj7mm6DSv3Glov6
         7qmBem4rWrDUenBPpvcw0ML0yQsWyN1bM45JwTtnDObYy/DfA864IldMUFzZIaFhn3JZ
         gyUukdxtEy6T48tHrcEkeS2qjVBefu1327XgHVI9caVkSuReukNpIqIw+xDehGPnG7nk
         pJ/A==
X-Gm-Message-State: AOJu0Yy6yyIG2LPM55M1+w8zDs8/xHc/N5rYTddxoFB5oAGYjrfqfmYR
	JEEEYeph1Ym02VLRIJ6wC0AE0WoM+2vYIPkhGd6ajOKoFYpZ1FIQlOBynshB803t5hPI2nTHGMF
	WZJtl5DH+2ek/w9xSvchzG1TEiL6/+/7ZI3Fvem1uM/WpQzS8zvMlBMKsCVV2wVBE09oIMGO4SK
	LHZAEnUNlecgkvvxUzFfLzpUqK
X-Gm-Gg: ASbGnctNbynYTynAAu5pc1+rNoV38EXI1KB/QB+xm7O3L+YDKV4/7XOySURDDRtttQx
	lveHuo5Dq8z7qeUDdNKexvUnRaqUhGaYSIVwuAcfbGqtPdlXHeoS4
X-Received: by 2002:a05:600c:5027:b0:434:f5c0:3288 with SMTP id 5b1f17b1804b1-43891430ed1mr127533065e9.29.1737389879073;
        Mon, 20 Jan 2025 08:17:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG41UaIugodqF8tPVdy6V7vqT2VWy8jNvgJVaNwc5uhbjMEpFrrGtAO8bad3WRQCF8bVG1B16YU1xrblmZfBH8=
X-Received: by 2002:a05:600c:5027:b0:434:f5c0:3288 with SMTP id
 5b1f17b1804b1-43891430ed1mr127532795e9.29.1737389878793; Mon, 20 Jan 2025
 08:17:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117234204.2600624-1-seanjc@google.com>
In-Reply-To: <20250117234204.2600624-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 20 Jan 2025 17:17:47 +0100
X-Gm-Features: AbW1kvb0lQBQXdsPCJbDUTcmgwaAaB8_cn5S4CSJKthyWQKGMSYzcq8Rdbto_0M
Message-ID: <CABgObfYuSn225d+Voc=T9am8zUK63v+s3GamohPU2+k0KwERkw@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: selftests: Fix PMC checks in PMU counters test
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 18, 2025 at 12:42=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Fix a flaw in the Intel PMU counters test where it asserts that an event =
is
> counting correctly without actually knowing what the event counts given t=
he
> underlying hardware.
>
> The bug manifests as failures with the Top-Down Slots architectural event
> when running CPUs that doesn't actually support that arch event (pre-ICX)=
.
> The arch event encoding still counts _something_, just not Top-Down Slots
> (I haven't bothered to look up what it was counting).  The passed by shee=
r
> dumb luck until an unrelated change caused the count of the unknown event
> to drop.

Queued for 6.14-rc1, thanks.

Paolo


