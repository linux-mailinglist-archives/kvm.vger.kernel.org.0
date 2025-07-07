Return-Path: <kvm+bounces-51637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75DF2AFAA51
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 05:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B14B189A842
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 03:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24962259CBD;
	Mon,  7 Jul 2025 03:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F+hz+iNq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94351258CC8
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 03:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751859544; cv=none; b=MQwCIB2H30TBK3hNYpUfrEnQnAGsM+CqLUFuFvbapt11O7e17ksR1ZtinIVz8t3L+RbRd6ez8uZ4xOGT4H5tw3UeG7A7pIprE45NQedVByxDdYFA6lpM4QaHgIr4RUItwkzhSyvrifKSCT7MB975jiltrv9WgxxPZYBy54bOp2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751859544; c=relaxed/simple;
	bh=cToKybjXtrPshKXsvriTLIFQT34mAn7DrvDWsf8sYmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Coo+OrZHJ8PQtK+NfUa8DPDWKTL9lEk6pooLr8cP50J0rvqy3mrnY/09JkdurM3sHVHIvEBkE98gHIEti8mWP8ZFhK71/umIuu8HRLnljvEijpl5VmTqDLkYEy+Ag5U1PXV2uchW6pkXylPGR9D1VHq4Pe/2OcsGzLQ2BErRhCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F+hz+iNq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751859541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cToKybjXtrPshKXsvriTLIFQT34mAn7DrvDWsf8sYmc=;
	b=F+hz+iNqpFR5zX+hdW73Rq2Gwj3fxSQZJQZJvCrL+isfNclNnQZzXwWy3FNURADIUE+EsY
	UefGbU0+1OJml6CGotDFumULj6ImhDiUapE5VbndRmlwWycbpL7JGth53xhb+NIdAguV7t
	4Kp2YW/xOzKDcoZY/13LpZjbuj9R64c=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-aoqwTsIGOtulhx-vray_hA-1; Sun, 06 Jul 2025 23:39:00 -0400
X-MC-Unique: aoqwTsIGOtulhx-vray_hA-1
X-Mimecast-MFC-AGG-ID: aoqwTsIGOtulhx-vray_hA_1751859539
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3132e7266d3so2626503a91.2
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 20:38:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751859539; x=1752464339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cToKybjXtrPshKXsvriTLIFQT34mAn7DrvDWsf8sYmc=;
        b=QKE30VL6oUipCgbMdUPftoFiRCmWow3hdfcVeZoomToV6RRCmA4Hf81Nf67tUoJ+7I
         M5PvlVc5YdZhvwa0toZA9TOXA+U3T1eekjYduLW8eD1n1rtBQL4fQgSyrS/B2FH9mxyS
         wNlnGP/ps25VYLPc/srS0a//Mzc8iksAegMFoDy+ydKxccP8VwqqIEahNxs4d6vp6mL+
         T/Y/VxbsNCbzBHBRh8StoPvBTqPaP+IYh+mWaEwap7iAPusitAqcVZy33F2JIZznNJpz
         yOR2ygMWonmZhod13hCCloxNISe2M3qvO4rSTqD1lZlDU5QCNOXAuChyg+kUveH6WcwV
         /r9w==
X-Forwarded-Encrypted: i=1; AJvYcCU9Rwu0Xw89lxq7dNscVlRfFzDn/bkVYeV+Y9ezYV8jrZX+yLD+8SkYuZznCY2Ds08o5BM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXNo3StOLixG6EI28E3l4XTFYPKBLzdizpT7G5/bNJk0LaV1KK
	sEJ2X9WT6oukqP3l/CS/u/QH9W0JNmhnxvDvfVLeMTpwmW9wqSDLEauqVh8t5ql+59qCVbo5Yu9
	CUU6N6TNaH2xcMUPVBs00jhH97R7P8FfUdknjyqnJAYCVH4FUQQOlVAq8MHXWCeSVUPsDfli+qn
	JGxQv7kk67LAFJsOK3PxDr8kVZriaFVM9PF5i2wOE=
X-Gm-Gg: ASbGncsPimN5J6C+xHtPFLwJ7BXqhEyfTth02aQ6aU9GPBIJ8/REBswTo0cBq/NjVT7
	lZRGJW7DEvqonsvzQL2P+d31L+Q2r1yGDBCCjFHicN+GPg/wtWGAzGhfm0N82eb86TyyD28mepr
	SxwNYH
X-Received: by 2002:a17:90b:55cb:b0:31c:15da:2175 with SMTP id 98e67ed59e1d1-31c15da23cemr1276678a91.9.1751859538656;
        Sun, 06 Jul 2025 20:38:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/OScOfzxvN6ffL+e+JM/H+J3/JdD4csUZUpOcHgC06UuyYVCjZh3kPiyRl4cX84Tq+BwKAeQqS9ePIWOt/tw=
X-Received: by 2002:a17:90b:55cb:b0:31c:15da:2175 with SMTP id
 98e67ed59e1d1-31c15da23cemr1276643a91.9.1751859538244; Sun, 06 Jul 2025
 20:38:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250702014139.721-1-liming.wu@jaguarmicro.com>
In-Reply-To: <20250702014139.721-1-liming.wu@jaguarmicro.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 7 Jul 2025 11:38:46 +0800
X-Gm-Features: Ac12FXzRSQJDauDNVYKvCZUnjp7a1__tIs86dizLjOKq_h5WbWMweaIbaRJmiis
Message-ID: <CACGkMEuxSsJVkvNnGGZtrK=MOyzc1ajW+SNR-xP_XzO5=R25jA@mail.gmail.com>
Subject: Re: [PATCH] virtio_net: simplify tx queue wake condition check
To: liming.wu@jaguarmicro.com
Cc: "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, angus.chen@jaguarmicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 2, 2025 at 9:41=E2=80=AFAM <liming.wu@jaguarmicro.com> wrote:
>
> From: Liming Wu <liming.wu@jaguarmicro.com>
>
> Consolidate the two nested if conditions for checking tx queue wake
> conditions into a single combined condition. This improves code
> readability without changing functionality. And move netif_tx_wake_queue
> into if condition to reduce unnecessary checks for queue stops.
>
> Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


