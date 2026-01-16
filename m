Return-Path: <kvm+bounces-68394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB06D3873C
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 21:21:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B17F305D8B5
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 20:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9108E2C032C;
	Fri, 16 Jan 2026 20:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fgRSsTK8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TqfWysMf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643C82222D0
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 20:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768594892; cv=none; b=pXDpQ9yfzfgfHDmUMt6+rlP0ZihLaBvEtjg4ijEsj7WSLuMv8LbFTQBEyjTD1ppOlFQ6axbX5o0It9bZvNBwl6x6LPeyX4BRjRo8AlO+kh1lOKVMu5i/pOi9T8vrnRUPLmt2maEM/H5VpQuuOMuTJGjAqYT0ipcGQF02MHOILwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768594892; c=relaxed/simple;
	bh=yCSdMD4ToLGgmxhqQUtjj3m1ZlUrBUAba/VP+IyFmpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jq5kNK6kQS2JWbwHOCmlJO1UudrZyUODfeenXbrD3F0ANJv7QCmfS1xKbz1wiom1/JpZ9xva3tHBPLdVpqd1/BKNSKrNrPKiFAcZPqysStK97R7tO2O7Ak0nmXRbOwUEVoOCo8+okgjS2Ub40I9C98oaf5rfkzFDMxn8SMJwf+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fgRSsTK8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TqfWysMf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768594890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TM7qIG6S/L7S3GUslC1W7AHVB3tEGDHeSbLotnEOSBU=;
	b=fgRSsTK8aWMD2jvmGcFIt9MuUnGICRVLU5aS08eM7o5rSgV07MCWSIOje2+/py95dZNrzj
	+YXosXOOGBnYIRomiHAzx9o7fqC+Ck1Vi7TLsvaB7hcoTITMws737eP3k/Fyqa58UK519P
	L0ifV5GIS4rh86G3/rOkcQNe8f+E0ps=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-5JpuriBCOEWX95cvRCBWgQ-1; Fri, 16 Jan 2026 15:21:28 -0500
X-MC-Unique: 5JpuriBCOEWX95cvRCBWgQ-1
X-Mimecast-MFC-AGG-ID: 5JpuriBCOEWX95cvRCBWgQ_1768594887
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47edf8ba319so23920545e9.2
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 12:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768594887; x=1769199687; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TM7qIG6S/L7S3GUslC1W7AHVB3tEGDHeSbLotnEOSBU=;
        b=TqfWysMf5/Sm44U77BSspMLayV7elnkjJoWwstzfZ18Ctl1LMQWUVoFEjxzilvSjrR
         ezhN06IKrJDl7ihqZUedxzcXhduXtGua4bdIBaoKSwkY54bePPn/3EHdBdRzL5j8XENN
         1e9d6L1ElzHrlK8xKxnGV1Qixn4wuthc/q232ZZcWFhkBR1dpRe80o0ZqCEAcCejo6Bb
         GSSFv8HzRRAHQtwZsBpFftU1MZl8ocaBcMYGswgFMYtm+cG1sS0dEOzoPgWB9pbdRAsz
         rcy7eUsLnTpPJsw+qnA2DgDYGJvsgtRLvJC2jMjWGcqwIocwRX0WcTS9Xe1i2pVMWpAJ
         7akQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768594887; x=1769199687;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TM7qIG6S/L7S3GUslC1W7AHVB3tEGDHeSbLotnEOSBU=;
        b=aVfBOapLS1rGtf6mNgZt1KAhy4HJNqd6SKoDIQOBAWws8kFlOnMKRzmxKL7fk1RLdH
         8VwHX9Hh+Zy02KyNzPKVowzlBoT5kjEvpa1Cyms3QnPgmk2hb/A2HOXe4n6R4GJr66WW
         j5a0yj13G8fOlkDqdeqfby/FyS9tuCZsXmuyEOlqqFSTkU1N2EtH9VdmljPdKkm+rIkc
         xa/IrV+dfP8HYEVIqSMJuv6r9JaiFrEfao7MuQgSUXqmihqqWn9QiS4KBxjG7UDX5JCu
         /ATSa8aUzY9FaU1/idPQYkeVL05uiUIRenpiIcUSbHJLUUpEMu3dh+eJD4C11B+qZbdN
         4MWA==
X-Forwarded-Encrypted: i=1; AJvYcCUQYScv9xDjoJrTPSlZrfPnWQ8e89IoHS06745uZN8jgFU41rjx2EvFH7gknMcplTzIHfs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUYTUhMEBD47767P/SenpEvOlQO78wpOvDg7sAhbHNQ6YpqSTL
	5wil6jAd5oOgYczXF8GPJI0zox1k+grNdpmB0cDGG7pV7u3V+cHHZ6vcXdTX2MatkAuGnbDMHf3
	YeUU74elSno0v1AjnTcXO/6swtQTCn0dSsl6xq1myGZ2bNMC4rcPRPw==
X-Gm-Gg: AY/fxX5GNtVV5KKDKmZ1ykiDOuVSI6FNoudQSl7YMHsxDvEMA2+1OZFgU0uIOfKEawM
	YUkIHQ4DTuzCmrkzkoG4Oz/h2HAKgUzH3pQCB5IweIO/u8hRe/mK316sY4vzKw1Q9j2s0pqfPK6
	uKsC5/OxBbn4rYfQGb71ZLfGjj9sagJgriOL5vwCbfGuGxT0gzSKRRvABEKYaclqpAJXDb83KNR
	VWqdcyTGeMAVUYMIEOcWVNqO2aAlWeuRgI/ZsLA3gHptVy800gld2RvkzSZ/UNXJ/0cm1viN6Xl
	STNoOCWpy5cmudJibI1RZBctotQliDGuPjxSvcG/nScXpdLO1YMxc1DSSOErPM/oN533vfyo/xl
	+kND0p73ztGVCCe9jxozOxaSPVtQJibANJqQ4W6Nl2iV2FzBGb4UVKzSpZRw=
X-Received: by 2002:a05:600c:1d16:b0:47d:2093:649f with SMTP id 5b1f17b1804b1-4801e2f912amr62205885e9.8.1768594887002;
        Fri, 16 Jan 2026 12:21:27 -0800 (PST)
X-Received: by 2002:a05:600c:1d16:b0:47d:2093:649f with SMTP id 5b1f17b1804b1-4801e2f912amr62205655e9.8.1768594886479;
        Fri, 16 Jan 2026 12:21:26 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4b2755absm144369235e9.15.2026.01.16.12.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 12:21:25 -0800 (PST)
Date: Fri, 16 Jan 2026 21:21:21 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: stefanha@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, mst@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org
Subject: Re: [PATCH net v4 0/4] vsock/virtio: fix TX credit handling
Message-ID: <aWqdjSUeEWMf53g9@sgarzare-redhat>
References: <20251217181206.3681159-1-mlbnkm1@gmail.com>
 <xwnhhms5divyalikrekxxfkz7xaeqwuyfzvro72v5b4davo6hc@kii7js242jbc>
 <aV-UZ9IhrXW2hsOn@sgarzare-redhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aV-UZ9IhrXW2hsOn@sgarzare-redhat>

On Thu, Jan 08, 2026 at 12:27:41PM +0100, Stefano Garzarella wrote:
>Hi Melbin and happy new year!
>
>On Thu, Dec 18, 2025 at 10:18:03AM +0100, Stefano Garzarella wrote:
>>On Wed, Dec 17, 2025 at 07:12:02PM +0100, Melbin K Mathew wrote:
>>>This series fixes TX credit handling in virtio-vsock:
>>>
>>>Patch 1: Fix potential underflow in get_credit() using s64 arithmetic
>>>Patch 2: Cap TX credit to local buffer size (security hardening)
>>>Patch 3: Fix vsock_test seqpacket bounds test
>>>Patch 4: Add stream TX credit bounds regression test
>>
>>Again, this series doesn't apply both on my local env but also on 
>>patchwork:
>>https://patchwork.kernel.org/project/netdevbpf/list/?series=1034314
>>
>>Please, can you fix your env?
>>
>>Let me know if you need any help.
>
>Any update on this?
>If you have trouble, please let me know.
>I can repost fixing the latest stuff.

Since it's almost a month without any reply, I fixed the latest stuff 
and sent a v5 here: 
https://lore.kernel.org/netdev/20260116201517.273302-1-sgarzare@redhat.com/

Thanks,
Stefano


