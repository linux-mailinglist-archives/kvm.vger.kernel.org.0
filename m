Return-Path: <kvm+bounces-29863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69CCA9B3638
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B2CD1C2522A
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 16:16:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9AE21DF253;
	Mon, 28 Oct 2024 16:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJkdZIrp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E898A1DF24F
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 16:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730132037; cv=none; b=pz6fVojYg5BHuFZsAme1B6HCrNZCIGp9aAtxN5iKslnr/g1X09DdXyhMD7bCcCwdluNYPVWz2pfpP0JiRm4ZbD1np5yHOhWfjAdZU6UIdhwzGra02u9WUHdu9DB1JQ/RaVU8ah5Hh6qksmzfpgGHC11uURo3tAAz8xdxEQoSOkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730132037; c=relaxed/simple;
	bh=dK8AQpVKB21DbhsoIQW9s6DlG17ZojcnqNzJw+AtTTk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B1XGQaVjI7iWisMMWT6fFm2Pg41Tl3Kr9ps5NLZy90MCmJjgMKYo3ZkV7Y/6wudfDjpMQzCSl1ddSYSpoOkB63QBMek3wfWM/3Q2RNrI2qBJBpi1+P/9oxU6GtX05CSLkdG9uHbhS42/e7JJeTlzGPcBYyrNthFEsJP2q5kSRfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gJkdZIrp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730132033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MtWJL992p0JNzFg6tkj4TLPGZxbfATTHqwcgArlMt9E=;
	b=gJkdZIrpBpCGZZNgl1AE+H4jILQlGZ6EhAFGbmazTVcfTHrNjIzfir1t7X1Z3w3HQ/4+85
	CYsAp7uP9sLcc/GCR1rUPN1iLZQCcz+jX9NItmR0O27DXk2xMh6EfZ4CsIrhIO2S4t/5cN
	wsbfFX/1HAV2nH51Sz7+mDx/kxwvzXU=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-QrEPtQ_nN6iGo3NcRGONsw-1; Mon, 28 Oct 2024 12:13:52 -0400
X-MC-Unique: QrEPtQ_nN6iGo3NcRGONsw-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-83aaad1b050so47513239f.1
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 09:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730132031; x=1730736831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MtWJL992p0JNzFg6tkj4TLPGZxbfATTHqwcgArlMt9E=;
        b=Hh0wcggXxJlvi8+EHTERBeCcoTfJxLvvc8dHIN6IZvQvJeT3VsiYYXGbiS5lE0Qd7I
         Ebu+BH+09RGE33vlAgf8X0QzhFQc4x0dF6VeUb5loNLORWmCTOBV/FiRSEc/kmtbP0zV
         JoRqEwX808Une5HGKl2CJP2ePxHmA8w46jpsKhKPSqsd0n/2nHkjjFW2oBwMI7fPy5So
         7WQpTGsS8XQKX8Pne3c9CoCoxMhuTcaRrLQR8wZdjjZqSCEhwzvit60p4VBjRbD7z1wa
         3o2GwqAcBp1aReMpWD8xvziQqIseARYklSz4bbBFv/scvyjKA/G95PkuAlHQD9A88kj4
         TXqw==
X-Forwarded-Encrypted: i=1; AJvYcCUtZebE0+/Q7SCydtFy1Ir+0TZuoeaYsJT25+L8yzG4WKNrgpDR66JiHSpQ8ngUMIG0Wr4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOCK11MCW1YF281K78qGWIJGBejpc9Wy55MyVC4ibPFjGzSPgX
	NCz8QODsroaYCJtK77NOaCR5SIhmeEVj74fMFjBecdd4rYvRovbftMHuXe793YKoTc2IMX94bgp
	U3X47j11V5eh1/Xhc8gn5GNpdJaiOiOcrKq0pvqF/kNJB4wcFXQ==
X-Received: by 2002:a05:6e02:1fc1:b0:39a:f126:9d86 with SMTP id e9e14a558f8ab-3a4ed1c7c60mr17996435ab.0.1730132030977;
        Mon, 28 Oct 2024 09:13:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEa5XaZPju6ifo8jMYf5zEpUlSd3TWgjqJVomkmU2miBGhP7PkMhDxDpdF+6n2OQvmwdKH1TQ==
X-Received: by 2002:a05:6e02:1fc1:b0:39a:f126:9d86 with SMTP id e9e14a558f8ab-3a4ed1c7c60mr17996335ab.0.1730132030568;
        Mon, 28 Oct 2024 09:13:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc72784e31sm1757568173.152.2024.10.28.09.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 09:13:50 -0700 (PDT)
Date: Mon, 28 Oct 2024 10:13:48 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support
 live migration
Message-ID: <20241028101348.37727579.alex.williamson@redhat.com>
In-Reply-To: <20241027100751.219214-1-yishaih@nvidia.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 27 Oct 2024 12:07:44 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> - According to the Virtio specification, a device has only two states:
>   RUNNING and STOPPED. Consequently, certain VFIO transitions (e.g.,
>   RUNNING_P2P->STOP, STOP->RUNNING_P2P) are treated as no-ops. When
>   transitioning to RUNNING_P2P, the device state is set to STOP and
>   remains STOPPED until it transitions back from RUNNING_P2P->RUNNING, at
>   which point it resumes its RUNNING state.

Does this assume the virtio device is not a DMA target for another
device?  If so, how can we make such an assumption?  Otherwise, what
happens on a DMA write to the stopped virtio device?

> - Furthermore, the Virtio specification does not support reading partial
>   or incremental device contexts. This means that during the PRE_COPY
>   state, the vfio-virtio driver reads the full device state. This step is
>   beneficial because it allows the device to send some "initial data"
>   before moving to the STOP_COPY state, thus reducing downtime by
>   preparing early. To avoid an infinite number of device calls during
>   PRE_COPY, the vfio-virtio driver limits this flow to a maximum of 128
>   calls. After reaching this limit, the driver will report zero bytes
>   remaining in PRE_COPY, signaling to QEMU to transition to STOP_COPY.

If the virtio spec doesn't support partial contexts, what makes it
beneficial here?  Can you qualify to what extent this initial data
improves the overall migration performance?

If it is beneficial, why is it beneficial to send initial data more than
once?  In particular, what heuristic supports capping iterations at 128?
The code also only indicates this is to prevent infinite iterations.
Would it be better to rate-limit calls, by reporting no data available
for some time interval after the previous call?  Thanks,

Alex


