Return-Path: <kvm+bounces-19750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3397690A1FD
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 03:49:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFDE91F22251
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 01:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F97E17F397;
	Mon, 17 Jun 2024 01:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V/QIDRBN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D044B15FA7A
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 01:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718588914; cv=none; b=U3eGOgVUaoTUxUWXcBzYm5WsUKyW7vD/ErYca0MmwRXbRllvhwY8A0KViJsSFH3dRBkQba5ir2z6MMvZhHn5zfdgJka274RHk0wJZsonlYXE89CcorKj7TLkA4sik57hRQdVgMNKLLmBpxG6apk0/VqArzzUlX043r3IVghAJuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718588914; c=relaxed/simple;
	bh=qwH5sb3vw4u2639u+bU4F9qqkIWaZ2UhByObXQ3U8j0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fhYw5oykwxIQrCAt3nVzDyzsjTZGhqQetNgDja5C0ALNYBtwAoJteItbYqixFs9yADAcdQusuDTB34hoX/1Xj8dJgjouFVwPjz2Ypy8+B1P6f/f/J0YEnAK4mEVNsg9Kcgr5NL0TxhJ9XEfNOSzQ+Ufh/xlB6dGGNRhkLLAP4kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V/QIDRBN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718588911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qwH5sb3vw4u2639u+bU4F9qqkIWaZ2UhByObXQ3U8j0=;
	b=V/QIDRBNsLx6I2WAzihOU+nyOUvWEbtteLLK8oSJMXop9jM7XI2oB6ehPApZgjtScOkPLp
	Z76YUhF7JrR+yxkyUPmnXJAR1NLl8V17nywr2RInsj5SxP66ZvHZK5cy7hwDfyQc6lJqoK
	c2Sm4kK/9Af5kRafQ2/9H2XuRpFhHQs=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-tC3gFhU9Ok2_x8GSDFkwvQ-1; Sun, 16 Jun 2024 21:48:30 -0400
X-MC-Unique: tC3gFhU9Ok2_x8GSDFkwvQ-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2c2dd7fb263so4207467a91.0
        for <kvm@vger.kernel.org>; Sun, 16 Jun 2024 18:48:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718588909; x=1719193709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qwH5sb3vw4u2639u+bU4F9qqkIWaZ2UhByObXQ3U8j0=;
        b=UUmrpSHADa/0oK7+x/fPgH2AeO3g4GyWLwmgT2LnPmM8CbVtyG0zb2CJEbnGf59c3Q
         yciUAQwkyx6Im6Jz8g/Z5RVUFqvoUh6Y06UPZkbYyJw8lf8pfAE9+v1HaLZf5mlk7Ili
         /ORbnZvR+6go7OC2khCVcs6yBKkv6TgWCE9+gCi+ad682eP3ZYlG4/3ld+pTJSPpYDzC
         RKGGt7S3TED5LYXhZto9JWxpRnILQfGKIsYz87DzgHubEFn9LKcKkDytSGjfCGerjmdD
         YXO1poAWqARZiDoPovVQbeQgKdmfO7mdPKxkyyeZXRgOfK9/qnuEDQsz21j+h6VXT9FT
         ikXw==
X-Forwarded-Encrypted: i=1; AJvYcCXVnqbC4ayyXS2WguAROU+JR8iHrNYG0d1g0UuEUez/T62RjeOrTdQDoxTnXkTBEJieCvAQaMXAXl1bv0DnrUC6qGPj
X-Gm-Message-State: AOJu0Yyw88BzQ0hI3xv/9DAAJm4hcaLtWT/svGKNQFSOvWmfNOUu4Fm4
	F3t4E+A+YMhnoamM+rm14JsyXADnuoi/f9g73eaIbyjJfQR71ykuDUrvpQ1zy/cK86f9EyWQegd
	VJ7hVAZBpkBkg1sWDW89L+++GbY2X2aQrRPZFflBPJO7q6xzepSQi39iGKI2Rdgf/dc3n5dOkAd
	Ia9LqaUeur0sRTXo1TFQ2AKVpW
X-Received: by 2002:a17:90b:803:b0:2c4:fc64:6b81 with SMTP id 98e67ed59e1d1-2c4fc646c13mr5027227a91.31.1718588909235;
        Sun, 16 Jun 2024 18:48:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFj+RTz1EYy7hweDAE1ICq45L/lGIK63DQpX9VOBUb8HY2SxFjoa3c8mAZlpi5oGyIBYrcUXdO1Y9miqAIgA9g=
X-Received: by 2002:a17:90b:803:b0:2c4:fc64:6b81 with SMTP id
 98e67ed59e1d1-2c4fc646c13mr5027209a91.31.1718588908759; Sun, 16 Jun 2024
 18:48:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611053239.516996-1-lulu@redhat.com> <20240611185810.14b63d7d@kernel.org>
 <ZmlAYcRHMqCgYBJD@nanopsycho.orion>
In-Reply-To: <ZmlAYcRHMqCgYBJD@nanopsycho.orion>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 17 Jun 2024 09:48:17 +0800
Message-ID: <CACGkMEtKFZwPpzjNBv2j6Y5L=jYTrW4B8FnSLRMWb_AtqqSSDQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] vdpa: support set mac address from vdpa tool
To: Jiri Pirko <jiri@resnulli.us>
Cc: Jakub Kicinski <kuba@kernel.org>, Cindy Lu <lulu@redhat.com>, dtatulea@nvidia.com, 
	mst@redhat.com, virtualization@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2024 at 2:30=E2=80=AFPM Jiri Pirko <jiri@resnulli.us> wrote=
:
>
> Wed, Jun 12, 2024 at 03:58:10AM CEST, kuba@kernel.org wrote:
> >On Tue, 11 Jun 2024 13:32:32 +0800 Cindy Lu wrote:
> >> Add new UAPI to support the mac address from vdpa tool
> >> Function vdpa_nl_cmd_dev_config_set_doit() will get the
> >> MAC address from the vdpa tool and then set it to the device.
> >>
> >> The usage is: vdpa dev set name vdpa_name mac **:**:**:**:**:**
> >
> >Why don't you use devlink?
>
> Fair question. Why does vdpa-specific uapi even exist? To have
> driver-specific uapi Does not make any sense to me :/

It came with devlink first actually, but switched to a dedicated uAPI.

Parav(cced) may explain more here.

Thanks
>


