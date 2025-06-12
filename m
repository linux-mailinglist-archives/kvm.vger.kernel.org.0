Return-Path: <kvm+bounces-49228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A34D9AD6810
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DC813AE109
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 06:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76EEC1F473A;
	Thu, 12 Jun 2025 06:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FG1YAw4d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FE31F153A
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 06:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749710039; cv=none; b=FcBpeWAZ3LTASqNcpqtc815ajssWwpJ90UyLtIwNme3XkkeyvuUU51aNICR63JW4b2xiRK7ke5bTMdEHsKS+nnjp5CWpB2juIayw8Ff5M7gTF5gn6P7E9siqosVmEGInOzDZU5fsamD4Q20VvbXDKuMWn53G0HV10Ntz0z+ffNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749710039; c=relaxed/simple;
	bh=0RFsYK4/bVTOu8PeXbzz5JHWzOqZR66/rgr6E+bl00g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dIoZ01UYLhMBN32nKITJBiS0+NRpno4tCJcZtjFVaFtvgZzwDQKFneNIFIJ2OT5pSbOASJCnDe/1dKiwS/7Sty3/UQUjtvM5FgTSBiJcdQLW5cO6a5zphtfaOmuheTIEc57KBcL1sTuL7FGsQx3C6lzA5su40f9EUN9MafDSF38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FG1YAw4d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749710037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nm9TV6R7Y41QOfPJ6MP5oIIesRRVBP6gVfG7mX/j6mc=;
	b=FG1YAw4d5dkWe3aoJEA7k7DHsnFyilE+sHssLrobtcImsqeN8yXlGpYSL8GTHTbqZVtcwp
	0O8z1LOLDlxi4boGFzxM6Sg8g2H99Y5m5Z96AEz9AP7sJD87Riht5JMfic4YiS4c6F7AQ0
	OepoAyps9JWEDcVbG9IWYoz5EiZXFxQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-Sym5lvlhMEymcj65m_zV1w-1; Thu, 12 Jun 2025 02:33:54 -0400
X-MC-Unique: Sym5lvlhMEymcj65m_zV1w-1
X-Mimecast-MFC-AGG-ID: Sym5lvlhMEymcj65m_zV1w_1749710034
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-450787c8626so2827185e9.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 23:33:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749710033; x=1750314833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nm9TV6R7Y41QOfPJ6MP5oIIesRRVBP6gVfG7mX/j6mc=;
        b=P7BzTm+P/lGe44IWum3vFQLU/gru9wF2JrrMxqIhhwS0a5iWcxmLuMTlHxwaY1oY5E
         uLm550QT2bTY0Glw8hMOqHWmR5OShG+DeVh2DENxQqUVF9Ev37mBhAGlR646R9GNT0hw
         Tu6FSwwZ6W5s7c5CmJpJYyNh7eMcAszMn423+Obs5UiuySUs5dhK7DXyQaRnycZi2hHh
         fk+c8WcTl+NxcbsdOdhelNhHxyDwi+irONdcVs//vvCHjzIsiKajcbL6x7Dezkgl9Q9u
         PMrYW5ibFPi1iN1QelC/JNiyg6oPn6yZQ6Q9EYXPYg1L7LdR4HX6bJZekzlgh13a4xbU
         9mxA==
X-Forwarded-Encrypted: i=1; AJvYcCU0qFf/nHKiZY8VWXQD+t4q0UbgzRVHY+YkvxZDSFux7PLDbVV57T1CUSXXuuesUDxKHgM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yys0/MivjTIbBIjI/6kuFbDmW+1T2WhjQY31D+rM9+fQXifU3iD
	zu3w6ys6duBKsY/OPL2F8DqM8mSuHuRF7+dpU80O0wE97VcHmsI1X/SI4L0t7YfIFGeVTUV1dBf
	Vy0ZG0hVk/7S8cTQCsMU6+ys2jNS7uH09k4u5/qwozu9e1J3wJzYhzQ==
X-Gm-Gg: ASbGncvbecLrDal9ZgFCZHxKP6WYUZJWcnL84h1CsWxXl5J7RIscxDY8wrNHC9TArY7
	FawCV12XtgiwxXaQwTq1EfsLSHOEUfr+D2qV/CdYpDtcSiTHm92qP2O2M9Xur+PApoEBtX/o/pV
	KZxeIc0yk6KrRm0AkMC+lqcjoUptqYpB6dKlFg/rG1qUANEQAqH8ld1EfQWa4sHOikGM777aIsj
	6KuouBlla/Y2/T2l2HcBteRcQvHM3SW21/84ucHZ1tnWAmf6y6x0LntbKKiuIAFyUL40Vv5/Vf9
	1ukRQndFwuyi4aSe
X-Received: by 2002:a05:600c:c162:b0:43c:fffc:786c with SMTP id 5b1f17b1804b1-4532d2f7108mr14039565e9.19.1749710033352;
        Wed, 11 Jun 2025 23:33:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUPXH7B83FgsgIbWOCFa8wLAry7d4eNcJALWMalXCx0ZQ4ODVUAv9DRXGbLvxZDae4zuYiyw==
X-Received: by 2002:a05:600c:c162:b0:43c:fffc:786c with SMTP id 5b1f17b1804b1-4532d2f7108mr14039215e9.19.1749710032990;
        Wed, 11 Jun 2025 23:33:52 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4531fe8526bsm43377245e9.0.2025.06.11.23.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 23:33:51 -0700 (PDT)
Date: Thu, 12 Jun 2025 02:33:48 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: sgarzare@redhat.com, Oxffffaa@gmail.com, avkrasnov@salutedevices.com,
	davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
	horms@kernel.org, jasowang@redhat.com, kuba@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, pabeni@redhat.com, stefanha@redhat.com,
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [PATCH net] vsock/virtio: fix `rx_bytes` accounting for stream
 sockets
Message-ID: <20250612023334-mutt-send-email-mst@kernel.org>
References: <20250521121705.196379-1-sgarzare@redhat.com>
 <20250612053201.959017-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612053201.959017-1-niuxuewei.nxw@antgroup.com>

On Thu, Jun 12, 2025 at 01:32:01PM +0800, Xuewei Niu wrote:
> No comments since last month.
> 
> The patch [1], which adds SIOCINQ ioctl support for vsock, depends on this
> patch. Could I get more eyes on this one?
> 
> [1]: https://lore.kernel.org/lkml/bbn4lvdwh42m2zvi3rdyws66y5ulew32rchtz3kxirqlllkr63@7toa4tcepax3/#t
> 
> Thanks,
> Xuewei

it's been in net for two weeks now, no?


