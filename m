Return-Path: <kvm+bounces-36170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA27DA182EC
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A15316A55B
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F32131F63E2;
	Tue, 21 Jan 2025 17:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M0FcVJz6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7832D1F543F
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737480628; cv=none; b=IUVX2fMtEvi6/5JkefSIdEqXL8LtBdC3dXZ/AgWyc8ZTyH9fGmByNWgdVYTD6ko44c30pyxuFTjREYBB5tyhqEuz6BZ4s+zV1k/plS1hOKj9LbjhRkA8Op2THalP0yGMKb88VBfUS2UvZ4KvKc8269y5YZWM9ZIr54zPZ3jVsYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737480628; c=relaxed/simple;
	bh=+XqZ2mIVewpWYnLioiQaGxFPazonOEuVdIMJXoMPQ2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WkSFdYeJQTlgTV8uGOYekJpCj7yOQqNxTdgUk3h7P1uABsd51O8S2EyhkEDbQNgVVfDv/lXF4i2uoBtTgCQbJN1arLsizxLt+Dvclb0S3yg/Gr4UMFJSsAyItpEmv/D5JjWR69/B6JXEpMEmBTEeRhpWlcnCNnKe4GyhVsz/Kfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M0FcVJz6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737480625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Ohl61oQvrjRs6MMIBMI/1E+/f+GFIL7csbNfKFkQbk=;
	b=M0FcVJz6XTC0/RXi48r0DJX0aWTxYzAxXp+4iTluzZG1u8ErryjuBkds2ibEL2SPU3mQK+
	aSzmxJcTnSOJ1MbHrDvKNCrEy/YzLsE1UuROgVZNr7st3jrr0zyWg20W6Sk+G5tGs0JZYO
	ePX1BJfv+5BI9K1zmlw6YYxMOTvsANk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-adXE4IOMMz2E1f62R1hNCA-1; Tue, 21 Jan 2025 12:30:23 -0500
X-MC-Unique: adXE4IOMMz2E1f62R1hNCA-1
X-Mimecast-MFC-AGG-ID: adXE4IOMMz2E1f62R1hNCA
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43631d8d9c7so29991895e9.1
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 09:30:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737480622; x=1738085422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Ohl61oQvrjRs6MMIBMI/1E+/f+GFIL7csbNfKFkQbk=;
        b=r36vOZL/ocUuCZtA0X3m+23Y/VYSoX5eX8kZCUwVWa/T//gUAaB2sk0PlktUhExPYJ
         0kB0/FVHlsXwBuoyJfo8MdQtmu2MC/uXTkeQ2M0vrL4m/sDftVcyLzEjO43R2gEt7zXZ
         4x1ZRAq9BSY25wqcLwf2vThwwz4wr1TNL8GHXXhbNRdcEJOXXDk7dQzh6dAz+qHAG2hw
         Ob63Qjm4WmeGzUopmeUrpydm32SiEe9Wk19ukgbgn2Q1GAlgB0ZAzR8jx2hJSd3Qqarh
         AgnNXlc7DSmAf8UVY4fxMa7CV49gjPgHH0NxVZ/5xDpamh+7K40CN+1VIh/MVt5/aWJT
         u15Q==
X-Forwarded-Encrypted: i=1; AJvYcCUcqvTWionJWKcwHPSQAHzyDNMPXRBNMYnMrGmhoqDBMbpyRh7IhAldZnM9ajRdIixxWnI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHlD7u1GOtq9DlVCtc63D+kKGfqqolloJ07wwfxYgZHx07buyz
	SOoY1fS7GMXWsIcn7ab1G3WqrjORPO0UfWY5vd7zLEmpeLqS8K5cjUQms3yhTYAgo9QzM1fhzox
	gNaLMWI3xKQlAeB5alzakHw9XhdhbWYCqITfLfHWm5Q/iC77tyg==
X-Gm-Gg: ASbGncu1WJrYv3TP4P5c2HtQCZ1Rq4AiIkiP9bMjLvrEmOrDv9m6GepXYpbeeWkFGtI
	4vPIXT0f0C0IF8FsWeaTToJsGccO0vM2r05857k/sTccu1VulNH0DD0i5hYogZLIYAon8Kc9oEs
	z0OcfyI6118Q3DlIMCktX2i8iITQWDuKeInR9w01y5TAN7Oxyp9cjaJEq0/8W+3MknCLWgdcFja
	46vn403GE87WYCK7WPWrCcLGPmGJa3/XD2mvFL5t3kt1MNtVQ19KHvi05pIztEKfmxBBBJe/A==
X-Received: by 2002:a05:600c:3d89:b0:438:9280:61d5 with SMTP id 5b1f17b1804b1-43892806237mr136001135e9.5.1737480622511;
        Tue, 21 Jan 2025 09:30:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHOXs9Ya5kOuP/W2rM4xk+vm5PSiTxIW1zce/YaupUUzohswvYEtJM6u59IjkgPls10nttGDQ==
X-Received: by 2002:a05:600c:3d89:b0:438:9280:61d5 with SMTP id 5b1f17b1804b1-43892806237mr136000975e9.5.1737480622163;
        Tue, 21 Jan 2025 09:30:22 -0800 (PST)
Received: from leonardi-redhat ([176.206.32.19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43890408a66sm190273065e9.5.2025.01.21.09.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 09:30:21 -0800 (PST)
Date: Tue, 21 Jan 2025 18:30:19 +0100
From: Luigi Leonardi <leonardi@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Stefano Garzarella <sgarzare@redhat.com>, netdev@vger.kernel.org, 
	Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
	linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Wongi Lee <qwerty@theori.io>, 
	"David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>, 
	virtualization@lists.linux.dev, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	bpf@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Hyunwoo Kim <v4bel@theori.io>, kvm@vger.kernel.org
Subject: Re: [PATCH net 1/2] vsock/virtio: discard packets if the transport
 changes
Message-ID: <blvbtr3c7uxtbspbfwrobfk7qdukz6nst2bnomoxbltst2yhkm@47k6evsdceeg>
References: <20250108180617.154053-1-sgarzare@redhat.com>
 <20250108180617.154053-2-sgarzare@redhat.com>
 <2b3062e3-bdaa-4c94-a3c0-2930595b9670@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2b3062e3-bdaa-4c94-a3c0-2930595b9670@rbox.co>

On Thu, Jan 09, 2025 at 02:34:28PM +0100, Michal Luczaj wrote:
>FWIW, I've tried simplifying Hyunwoo's repro to toy with some tests. 
>Ended
>up with
>
>```
>from threading import *
>from socket import *
>from signal import *
>
>def listener(tid):
>	while True:
>		s = socket(AF_VSOCK, SOCK_SEQPACKET)
>		s.bind((1, 1234))
>		s.listen()
>		pthread_kill(tid, SIGUSR1)
>
>signal(SIGUSR1, lambda *args: None)
>Thread(target=listener, args=[get_ident()]).start()
>
>while True:
>	c = socket(AF_VSOCK, SOCK_SEQPACKET)
>	c.connect_ex((1, 1234))
>	c.connect_ex((42, 1234))
>```
>
>which gives me splats with or without this patch.
>
>That said, when I apply this patch, but drop the `sk->sk_state !=
>TCP_LISTEN &&`: no more splats.
>
Hi Michal,

I think it would be nice to have this test in the vsock test suite.  
WDYT? If you don't have any plans to port this to C, I can take care of 
it :)

Cheers,
Luigi


