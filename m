Return-Path: <kvm+bounces-53615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E691DB14AD3
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 11:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D4797A7F36
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 09:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67826287500;
	Tue, 29 Jul 2025 09:10:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACA928504B;
	Tue, 29 Jul 2025 09:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753780236; cv=none; b=CCKwQAIZGWwIqzxf6MIbI4MwDch0zy8rDAopQH4EiFCJRXg47AHFdekuThDHPM9M76V2TBxuShFVyftsqPcEhQFc8QoFNjFtkv7rgOtAoPVyYptJI+VkQ5P/kD0sg3et7yRM86Vt5wlPR3M0Zb8K2WhdZXs3D8aEmUwpDqVhNeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753780236; c=relaxed/simple;
	bh=ma7vAg3v4wscRHiIGqBMBTHeYMDJcwp3keDePdsuOdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=inMPzEFmar/xZQhWAVZ7Kyz3Palhn5G76ZZkA1J3Hxv8TRqfwCyApn5Lq1Me8KJN0lNX6D3h4DIL4QCMrdpeexFr3GmF1+P9HmYa6GGvOxHOgYm89M9uyI61TahgJpD5gFc3eEcM4faERwZSTsJkomM7tLEdpvKI3x9EfP2flgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-61571192ba5so509962a12.2;
        Tue, 29 Jul 2025 02:10:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753780233; x=1754385033;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ih2qmbw0kIlUrbc6K54EF8TQLIe280fNI5rV3oonE98=;
        b=ucgN3vbSIY8+xUBjpIwmDNo8iba6xDG4SURCo2Yqn9UFOSJDKTZMzSKCDGusqNFtOY
         19s5FTQis3a4O9UMcesFcpJ7qoON/imeIfmgjM7Xbo/DrlfRZfphdaS7ET3/wXHOuWq4
         7EL6OZ/4rvvnfFo3LN3trUUQ6eVcPKkPIu9Tn8VdDlVbr1BQvKYdIDvlJNbwoA2khGUA
         XuAghFgIilYISGycfALJGF626Z1UugV94YasmD4uQzYIgA34vL5i/YDGxeBVo7Vzr4YZ
         TIOV5JuQ/8vVT0zY5DkPon9RPbiNW71PE8kuCR6ezVzLFsIhbw26+R33vciS2MFGNKLG
         vj1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXT0kvv7QyCcLVfXaix6Jo/wbsRsPR00g1B8B4F8rXHodd3Q7iWnbDsqG1fdjnaSBXyQYw=@vger.kernel.org, AJvYcCXj9PDJ+3/6E7O8Dz1jrCo4zNS5SPCsR9mV8uhhFd0Jvc4qeI2CFenxwOo4wiYC/rKLzbk6Yvld@vger.kernel.org
X-Gm-Message-State: AOJu0YwWGnmhQweGnuOeXFgViu97GV13+9h3tex7xI6dNJXYfRGqoM9m
	aOXIFta+pZKKkcQ+2lNK7IGKJisiSequKO1AFk4Qo3o+Nau4xgIxQFmE+rZzJw==
X-Gm-Gg: ASbGncsdbgFYDseZbdOOCCdd5u+9YNbKYOdHTHnS3x21lOk1CJO58zwEg2p2zjKB8Kp
	67opTT7lMLhkG+4zVmF5GWVvgRPdSuxqFSBU6r3trnRZGIntuP6Y9XX9NAzuwcJq1k5JpCDO9st
	KkeNJAdACWPYQ6GJ8g7GvHLd8zUPSJsG+MyMcq6x/rTQ/nQvhEla9PeYY9hTXu7IzTKJoipADBO
	X0s9ImTMJfaW0J5dKILnlEfkAFrD/6548nWAxwUEPR+/PhMCzHxRfRNIUSOv9kZHt5uUpxdRiR+
	dgEPtUTAPKpRFxsO9cUqOI+9sENPfHinPhocfBWkuotK/VKTJd4WXpUZOr31k8ZDgbUoSKB8MKo
	ekCz2zHyVL3inMC+VXSRSPpJZ
X-Google-Smtp-Source: AGHT+IGl6n+ifSL/KMMTqTxzwuB1z4pRgpR79rQhN5RUlYpPobdpUuW/5vOu1d899LsLXtkRT0+q+Q==
X-Received: by 2002:a05:6402:27c6:b0:607:f63b:aa31 with SMTP id 4fb4d7f45d1cf-614f1d19bc4mr14119485a12.6.1753780233258;
        Tue, 29 Jul 2025 02:10:33 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:72::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615285de7casm3178237a12.46.2025.07.29.02.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 02:10:32 -0700 (PDT)
Date: Tue, 29 Jul 2025 02:10:30 -0700
From: Breno Leitao <leitao@debian.org>
To: Jason Wang <jasowang@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, 
	Will Deacon <will@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>, 
	netdev@vger.kernel.org
Subject: Re: vhost: linux-next: crash at vhost_dev_cleanup()
Message-ID: <ppjmgrtdfepjqvrnqo6xuuxipgu2s6edfboy3ymoe4h7cxr3qw@qtjxjnd7ocfr>
References: <vosten2rykookljp6u6qc4hqhsqb6uhdy2iuhpl54plbq2tkr4@kphfpgst3e7c>
 <20250724034659-mutt-send-email-mst@kernel.org>
 <CAGxU2F76ueKm3H30vXL+jxMVsiQBuRkDN9NRfVU8VeTXzTVAWg@mail.gmail.com>
 <20250724042100-mutt-send-email-mst@kernel.org>
 <aIHydjBEnmkTt-P-@willie-the-truck>
 <fv6uhq6lcgjwrdp7fcxmokczjmavbc37ikrqz7zpd7puvrbsml@zkt2lidjrqm6>
 <CAGxU2F5Qy=vMD0z9_HTN2K9wyt+6EH-Yr0N9VqR4OT4O1asqZg@mail.gmail.com>
 <bvjomrplpsjklglped5pmwttzmljigasdafjiizt2sfmytc5rr@ljpu455kx52j>
 <CACGkMEt0ZBtcAUgc1RBU7Gd3JGvC-eszEOexee-kx7TgoiMGtA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEt0ZBtcAUgc1RBU7Gd3JGvC-eszEOexee-kx7TgoiMGtA@mail.gmail.com>

Hello Jason,

On Tue, Jul 29, 2025 at 03:44:49PM +0800, Jason Wang wrote:
> On Thu, Jul 24, 2025 at 9:50 PM Breno Leitao <leitao@debian.org> wrote:
> > > The initial report contained only vhost_vsock traces IIUC, so I'm
> > > suspecting something in the vhost core.
> >
> > Right, it seems we are hitting the same code path, on on both
> > vhost_vsock and vhost_net.
> >
> 
> I've posted a fix here:
> 
> https://lore.kernel.org/virtualization/20250729073916.80647-1-jasowang@redhat.com/T/#u
> 
> I think it should address this issue.

yes, it does. I've tested the fix on my machine and I was not able to
reproduce the error at all.

Thanks for the fix,
--breno

