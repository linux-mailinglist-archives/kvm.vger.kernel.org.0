Return-Path: <kvm+bounces-68701-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GCYEE0SlcGlyYgAAu9opvQ
	(envelope-from <kvm+bounces-68701-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 11:07:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CE1D354ED5
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 11:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 860D06CB08F
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E3A048035D;
	Wed, 21 Jan 2026 09:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fIoVYjaW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RvnCo1CH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C0A3502B6
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 09:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768988893; cv=none; b=qCVKEvhf6Muh48C3+KNBalEcl79g6hR39tbphUAa60kELOgtyw0GkEvhStDVit/5H0Gh1W75oVu8kZe6hpKjqvMeRXkob+bKBhfS7hM91LX7dpyoJtAk94Cqb8IoaWcxhuMKFdXFgbj/4iITyN5QbDX9ZFj/sSOeAkBloMghEp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768988893; c=relaxed/simple;
	bh=hepF0A2LSGlCyRDBXglqMBeLZzFYJb45MCxfhvn7i1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YVSQPUAbKvMXKm55HwEiQfsHF67GSwLVjUSgB8+K+TBETH7PyzyxXAej7CA20FNsTAerPobk5GBedcZegkdxbzNqXbaISQ4Lq4Lu9uQiQTQm29txy/wlaN5ZT8yB72u7ZMmvxJ+ytg8NPjzYbT7acTIjpG1L4F+rtXFrzXy8sMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fIoVYjaW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RvnCo1CH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768988889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hepF0A2LSGlCyRDBXglqMBeLZzFYJb45MCxfhvn7i1s=;
	b=fIoVYjaW9NDxX2C9etPe+QYGTiYKIjW3AQlDN9QRm2p+ziIiH1gD38PUO0Y5Gbfjsfxzhh
	27CHujhAchMM6Z6v8RXLT8iFc8Lh/KAgkj3np5Zpkx2lNsJaMJiPfcgnTjZ/58MPw5m7Qr
	RY5L8Vb2aeiVGfq3LLr/5SumkfTd9I4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-xLtRgQbQN4Sn49IRhIVZRw-1; Wed, 21 Jan 2026 04:48:08 -0500
X-MC-Unique: xLtRgQbQN4Sn49IRhIVZRw-1
X-Mimecast-MFC-AGG-ID: xLtRgQbQN4Sn49IRhIVZRw_1768988887
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-435991d4a3aso389233f8f.1
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 01:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768988887; x=1769593687; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hepF0A2LSGlCyRDBXglqMBeLZzFYJb45MCxfhvn7i1s=;
        b=RvnCo1CHPHWC79XusV5QMPyaJMq0lJYYvGj7LqN+pTJiiBffS0IkwPeo5uCEw8zSBO
         ky+3P+PQDaqWrc+V0E+n5fiXezqqMMidCF7MukFHpCwBkj1Hl7kjAdP1IquPx3HyCOS1
         llTc7c8QNVEb9dTVm4aE74zXlrxrMq+pOk2pynsLMjNa7afRoBLIKmqwRiD/915ewpfw
         9102loytTt9syabHY18/VXIJaSKwuZ/8NEFtpcVhaDV5OyCm1j/Q70bD6NJuJl8MWzQk
         cUc6BsEYMvMf5oKrha8kwphNT2zuf83xuVRHi/iX/2/jVCVuryK+PpNhdwDGRhvDCGH2
         TNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768988887; x=1769593687;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hepF0A2LSGlCyRDBXglqMBeLZzFYJb45MCxfhvn7i1s=;
        b=ZZjsh5oXptSqnPAEgSY0k6VrrYjSIaboGtXOOQRAUzIm3C8oaiH9LCdUY7OoG4KWyD
         W3M1F+7RLDuPZTDkXBq2zCr/YjDmzJpTY4LVDUyXu/oAsl6jESnhVQlGZrq3YG4/gDaT
         4qJkfCLDj+Uj7WxdHb+sK3Kj7YBXzNfMT1UYH/64VrApfaDaukBWgmLZTSfNOg8eBaNt
         9q2b1Xn21sNhHj/JwMCDF5LGf3f88D1WmdEfqjgATjNUw0v4+bsruNd/rdJMdoyiuTzd
         fMMxIYVQ9zm6FC7dGk/MXgtZAuT1sipgI2/jY9iJmke+fPI9bQq5J88nMG4WGckdODXn
         ua/Q==
X-Forwarded-Encrypted: i=1; AJvYcCX6nVvqdBr13DeQXInpsRYRCdIlNaeD/ZE2UGq1Ie61RWMVyLUUAapbmwhHAm8CYBUL8iA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6QBJwsqFYgXEOU+TddkejKTF/8IDhtGKt82GJGRwCktJ5IIHV
	UO4XZ+8ra2GF6xgqJANHncrQ3W93BHOXqB7ezzOoYZeBCiNsRU9+E9sKJG+NV41J/JghVzZAtpf
	cy+bb/ll01hmvUokHvibZjV9yFKemSE+apNMe7Ahu2JrqLNxD2BM0Yw==
X-Gm-Gg: AZuq6aIVL9eZda9HDdkDKUXlSPWJ5IP0UUsjsGrV+Nup5zXVuF7ZAloSqiQwh3dgrni
	ITTaleq23/o0sGoaURQzenZQpaSoAsBA8B+Z8Gx6kDDR8yOQS1wyAIqD2UEmULZ3M1/lqW9146s
	TDz34OmO4D5ZDJl4Y0SXVnFK7jerAQSHhV2M0UTCXnac982vNYycV07rzxvitKbIctVyoEVzkc2
	qXfcI0W56CJXxpSV1iB54XXBYHeAwYrMMAme6WgVLa3pzbzkBcCAcKdasGQrWUOwzRnYcQ9l/Q8
	xkNJomadM1eVGZXM+Zq49ka1kfdHH2RIwFM+ya1bNT3Gr71Xlldyf3qk0CZBtdp7Vgsks1pjxc6
	0ejywsWUqziKbTaSw1NeUuXsWdm+pKXhXzEI5dmNoo+QvpeSkUEk+s5oe5gA=
X-Received: by 2002:a05:600c:8b78:b0:47e:e8c2:905f with SMTP id 5b1f17b1804b1-4801e30a790mr252559085e9.8.1768988887157;
        Wed, 21 Jan 2026 01:48:07 -0800 (PST)
X-Received: by 2002:a05:600c:8b78:b0:47e:e8c2:905f with SMTP id 5b1f17b1804b1-4801e30a790mr252558715e9.8.1768988886678;
        Wed, 21 Jan 2026 01:48:06 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f429071besm351751895e9.10.2026.01.21.01.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 01:48:05 -0800 (PST)
Date: Wed, 21 Jan 2026 10:45:50 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, virtualization@lists.linux.dev, 
	"Michael S. Tsirkin" <mst@redhat.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>, 
	Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>, Simon Horman <horms@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Arseniy Krasnov <AVKrasnov@sberdevices.ru>, 
	Asias He <asias@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH RESEND net v5 0/4] vsock/virtio: fix TX credit handling
Message-ID: <aXCfnIFT6_HqC8v9@sgarzare-redhat>
References: <20260116201517.273302-1-sgarzare@redhat.com>
 <20260119101734.01cbe934@kernel.org>
 <aW9L0xiwotBnRMw2@sgarzare-redhat>
 <20260120151848.3b145279@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260120151848.3b145279@kernel.org>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68701-lists,kvm=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: CE1D354ED5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 03:18:48PM -0800, Jakub Kicinski wrote:
>On Tue, 20 Jan 2026 10:37:12 +0100 Stefano Garzarella wrote:
>> If you prefer I can send a v6.
>
>We'll need a v6, patchwork can't do its thing if the series doesn't
>apply and last time I applied something without patchwork checks it
>broke selftest build:
>https://lore.kernel.org/all/20260120180319.1673271-1-kuba@kernel.org/
>:(
>

Sure, not a problem at all, v6 is out now:
https://lore.kernel.org/netdev/20260121093628.9941-1-sgarzare@redhat.com/

Thanks for the help!
Stefano


