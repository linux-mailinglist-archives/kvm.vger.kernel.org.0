Return-Path: <kvm+bounces-7555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD06D843B5A
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3B0EB28A74
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 09:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D9069961;
	Wed, 31 Jan 2024 09:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mfbg61qF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0307569940
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 09:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706694200; cv=none; b=srcbhKkO8YjBjgDsBiTcfzVQd3+AYagEkQNhVOMM7DJroZwi6Mivn7DqdCZjjlyGNH/DA4jcjJLuWxCwdOtA9CYzlbq2xXi78BofpxVmtcXfaNxUY3+Gvr3K5Og4uhPD8FMLpAmwFGTRs7Wyn6nl/HyGZDnUPxfv7Sb4vnALtqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706694200; c=relaxed/simple;
	bh=gkIae8l+H2+F/jXvpvISUQcIXBcbsucEp1aonIBdbjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdcAl+XJ+bOn5VkGqTA39W2pNOVTgmUEvCUQnjNmBkvQ8zNgDO/dBUPRHatXzMxJgkr2D+XhuHTNiDf8nXHLEi6bUWku9jy9L08TyunVGq4DFtTUtqX4jcSyeVDq0cKW91zsAZ77g7h9jTdraKIRPXxe58E3EhQ6AFt/TykE108=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mfbg61qF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706694197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oza1LRHp/M5RIj8Nm47urKrF572FUv22z3v7KOgdQu8=;
	b=Mfbg61qFWt1VvUY2F/LVrmcHt8zQYr+DTEY1z680RMKT/LNN8jrepdCIKKAEofLA/3xKDZ
	iVjbrfRzbLngJBhJuECc5iQvfXS6D/rG/NwtKnF6ktMC92njsyLAT5j4miNv1AszNFlAJ6
	KOgeHkRKR0RspE7qcgzbkj1Ub8aLJHU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-ynQbvqDXO7yIIBPumKUtyw-1; Wed, 31 Jan 2024 04:43:14 -0500
X-MC-Unique: ynQbvqDXO7yIIBPumKUtyw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33ae7046cd0so1630567f8f.0
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 01:43:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706694193; x=1707298993;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oza1LRHp/M5RIj8Nm47urKrF572FUv22z3v7KOgdQu8=;
        b=LElw4OkxeD37PCed70DKk1VoXQEaO4fxlWAY7WLUC9rBvj2TUGPg4uuDqKfD5X5oif
         5qO/l+c7o5Qlevr6+adOSPjr1Hw42tBNon/naPVfS08fuJBmWBGf525354RgxM0fKIKd
         wUVml5measwgqqYKShA90cFgjJ6l5zvumIEJqcZgzDKNgBO3HHJkjWFjwbdqS+bVWA10
         hZyBu5Eh2rsUqaP7bf82iG1r6sjl71TGL+P5NrkDEnB/gjNHPyBPMxCCROWo/PMArPX4
         WbtgF71bmBI/lr1t0Aj5RR2rzc4QMQ3D1rN0yPbbE50BtXvBkqIoNRslMQQREJk1psRM
         ukOg==
X-Gm-Message-State: AOJu0YwcqQGX2oMy7ZcxMoQS8S/2VDlI4I0kkltuPiKye9i5WY6b08V2
	cjr4B8UzUDf9dMJw6KzvwgpFoCgtg+P7s7GBKv+dSbQL25VcwFwk49LF/ogtKPujR02FK9pCTn/
	75XSuaOb4yI1K3XaU2AKCGKS9Xz4nqylOlDq0y+x/tjQPzexwpA==
X-Received: by 2002:adf:fa05:0:b0:33a:e919:f406 with SMTP id m5-20020adffa05000000b0033ae919f406mr679900wrr.52.1706694193234;
        Wed, 31 Jan 2024 01:43:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE3NLeG1aMawKGEQVu/0aqBjSNNGqzZmjOJyBzgiQ4QC6+fT4S4tC5TcuNgzowV5ynPiQEAwQ==
X-Received: by 2002:adf:fa05:0:b0:33a:e919:f406 with SMTP id m5-20020adffa05000000b0033ae919f406mr679860wrr.52.1706694192871;
        Wed, 31 Jan 2024 01:43:12 -0800 (PST)
Received: from redhat.com ([2a02:14f:1fb:b2de:3c63:2a5e:5605:4150])
        by smtp.gmail.com with ESMTPSA id cx18-20020a056000093200b0033935779a23sm12937651wrb.89.2024.01.31.01.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 01:43:12 -0800 (PST)
Date: Wed, 31 Jan 2024 04:43:03 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, virtualization@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Yang Li <yang.lee@linux.alibaba.com>, linux-um@lists.infradead.org,
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH vhost 04/17] virtio_ring: split: remove double check of
 the unmap ops
Message-ID: <20240131044244-mutt-send-email-mst@kernel.org>
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
 <20240130114224.86536-5-xuanzhuo@linux.alibaba.com>
 <CACGkMEs-wUa_z_tGYEwBf7EVJAtuJdkX4HAdjqMXHEM1ys-gKQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEs-wUa_z_tGYEwBf7EVJAtuJdkX4HAdjqMXHEM1ys-gKQ@mail.gmail.com>

On Wed, Jan 31, 2024 at 05:12:22PM +0800, Jason Wang wrote:
> I post a patch to store flags unconditionally at:
> 
> https://lore.kernel.org/all/20220224122655-mutt-send-email-mst@kernel.org/

what happened to it btw?

-- 
MST


