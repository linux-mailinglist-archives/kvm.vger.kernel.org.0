Return-Path: <kvm+bounces-63248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 07361C5F028
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:17:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8DA1C357344
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 19:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8421C2ED164;
	Fri, 14 Nov 2025 19:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fHb6/0T/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0170C2E1C56
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 19:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763147343; cv=none; b=VlvVhh4y65RW+vcE6qDrnKkELGeVFEC6SZ0crkQpndFUDF238AoMuy3HoEG9yXs6q+XPsXIQcwi2hTxGAVWFzwHrh4GiQPOFodH0tj59v8yx7lsoN3ndAAM51iG/6ZDTFHfpNoBF+GmvX30rdWO0+B1rNcSAOKfNCTYjObQwHQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763147343; c=relaxed/simple;
	bh=Nfxgm75Jhb2I/JUAINHfI4c962h33wDu9+inj+NnIc4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jtJXHffv5dCiGPUEkIjMwREdP1l4YS9FGi6zP1CFWO63QtTYGOA//xQc9Croy7iMNXVcUbySxDWAo2Kf8tnTmOArJOy25yH74X60K8d2KYXq20twmrzkW4Cok29k62Slve95wZg1/h3vyI0LzFy5Oo6fKrPqeSvRuZbgXZ2zdgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fHb6/0T/; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477442b1de0so16257915e9.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 11:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763147339; x=1763752139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/kduuOxJm1uiHOQpqpaE+0Irtr18Sdz3O5vUWzH6wpM=;
        b=fHb6/0T/UAhSE5wcCP+7RD3ngi1eXkslSyTAzfQmGdaDtPyU/dplUDuPHUd6KUMGbv
         P7OYQEyhTBHQUUq7kgWw4FPAEouV9zk3pYeYAkVPHwh3q8bcWksNDIVryB9xYGnwdmBe
         DDKSHYLg6PGGmjU/pfdHqghmToD6Y4CgYiQt3+5heP1xLizekn/nmlOxHldxzzf26YpP
         rLQNVVL3e/rlrWz3hts3cHVaZklPzHFEFBMfaA/T6iU7/MAuUjNGckD+M3/5SGQ7/7OK
         t1xhupHqpEECojOsf/9I/pGjr8F5+EhP5xhXRRR01ZWKzM1wubutAay9DJ+Y8JXr4c6Q
         FeYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763147339; x=1763752139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/kduuOxJm1uiHOQpqpaE+0Irtr18Sdz3O5vUWzH6wpM=;
        b=nx8AfnBuMsEJSoNzoMxqlbsGKplA3J45B6aD1aqSwNXHOM2feDRsjKCyjm3y3gDnGM
         zGzdPZAb5QXKgS1b/+SnYyEMCdTtuIXber8TzBb9VCBMIcJ8WX8qNPSEMC4SmIT/gQHl
         M4UWAixl149Nir5yhOwgn7NZ671y3V6lHaaENUZ7hXlfzqceJlex6sCp1mPqee9TFXcs
         6tnn7UF2KlmOECjiTDqsPVxGN/+8DSxDRCPFDodbqAG6Px4jyqSeGE0fXZoLj2P38F3s
         3Kap231AY3dDUYVhnhHCcOqwXJuZtnWyDG68ztR2I1PKZWU29YbLoceJRWVlsMbp+Ce9
         9irw==
X-Forwarded-Encrypted: i=1; AJvYcCWU/nJlgctEZXuA1LB5LyzaidlKxsLVeqrWx9NxEt6iyRYDERB9IuRxykDvLWk5vftUADE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG5jDLDUPMAtnszSJYAV51cu9RAfSagJ9WYpf5uBk1ywepj7pY
	2Rw5WpIqmgegcAIRw0kKmL4xrvj+eE+TWUO3gghj/6XXO3uhK0vu6Df8
X-Gm-Gg: ASbGnctp6tdZC+gtBnTEctDsELh+d52cFflK4UfeWzpIaYNjvrdzaIAPIubldLHEk/1
	3U1sIZK9tGyceQpFKozXf9HA8IxdATVyUpIbuFAy5MQ86XiJIROEO2QCgwc+OYS4nXkxOlBCkd1
	rsbzRhEg951ZrsGoCJ5gHNvLIU3Ukmy6vUtD8d2sa922OMSI+zGQVkW/78Zg84Iug+TXsib67gH
	V0JLUjHxQZwI/6JEt9pJ4CpxL10Z8eBzAsYBJXNLIY6IBosHD3mw0Me6jQfMoJvLNP4EDBT0sQN
	E/vmLP4CjU3Kp3L9KH2J/r3/kTqJ0PNoqMwvgIpWrs5YQTWyaFnb+kDeLqF8/qNvA7kXHTIdUZ4
	BhXbh5VWTk4JPoYyu2l9iIyzyVUJbygXqB2f8kP8j3Yz1f/cPy0vxR/nOMNoci2LRF295hSE8Xn
	WVpP/5vgdxaLjwg9P2FydBN36W1IHfDihCtKLrdYNkuELYImsIartDLiblh3Mo744=
X-Google-Smtp-Source: AGHT+IFWHe5vo4aCmUnfRTE8bLs+NNaWOHslfnze7qRX+02RlEOWeu0jyoeKkQbA3EZNRkKxFnbT8Q==
X-Received: by 2002:a05:600c:1f87:b0:471:1435:b0ea with SMTP id 5b1f17b1804b1-4778fe795b0mr39564935e9.24.1763147338776;
        Fri, 14 Nov 2025 11:08:58 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477952823d3sm23335595e9.11.2025.11.14.11.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:08:58 -0800 (PST)
Date: Fri, 14 Nov 2025 19:08:56 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jon Kohler <jon@nutanix.com>, Jason Wang <jasowang@redhat.com>, "Michael
 S. Tsirkin" <mst@redhat.com>, Eugenio =?UTF-8?B?UMOpcmV6?=
 <eperezma@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Borislav
 Petkov <bp@alien8.de>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user()
 and put_user()
Message-ID: <20251114190856.7e438d9d@pumpkin>
In-Reply-To: <CAHk-=whkVPGpfNFLnBv7YG__P4uGYWtG6AXLS5xGpjXGn8=orA@mail.gmail.com>
References: <20251113005529.2494066-1-jon@nutanix.com>
	<CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
	<E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
	<CAHk-=whkVPGpfNFLnBv7YG__P4uGYWtG6AXLS5xGpjXGn8=orA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Nov 2025 09:48:02 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

...
> But then get_user() gets optimized to do the address space check using
> a data dependency instead of the "access_ok()" control dependency, and
> so get_user() doesn't need LFENCE at all, and now get_user() is
> *faster* than __get_user().

I think that is currently only x86-64?
There are patches in the pipeline for ppc.
I don't think I've seen anything for arm32 or arm64.

arm64 has the issue that the hardware looks at the wrong address bit,
so might need an explicit guard page at the end of user addresses.

Changing x86-32 to have a guard page ought to be straightforward.
But I think the user stack ends right at 0xc000000 (with argv[] and env[])
so it might be safer to also reduce the stack size by 4k (pretending
env[] is larger) to avoid problems with code that is trying to map
things at fixed addresses just below the stack (or do we care about that?).

I'm sure I should be able to build and test the x86-32 code.
I guess there are instruction for doing that under qemu somewhere?
Might be time to drop support for cpu that don't support cmov?

	David

