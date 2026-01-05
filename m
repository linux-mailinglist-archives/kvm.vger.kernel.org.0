Return-Path: <kvm+bounces-67018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 64861CF271D
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 09:34:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E0FAE301103D
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 08:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A177F322539;
	Mon,  5 Jan 2026 08:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fhwpRoog";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FzAXECaK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72E23148A3
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 08:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601397; cv=none; b=Zqa3/dyz1aTVnJvkWDbBXim/UfjIV9WQMbi4ot+fiFfCHcXvUd+U644G96IavaIqLMS02o1wM88uWHZMcjO/lFB16VD046WKdIrQ8hDj3bmCLuoOs7Qpa1W8/7ChASBZGgGs9J2Ga+/lLP9Fu5IYPKx4BfP8mBCtblLmYKDvtj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601397; c=relaxed/simple;
	bh=3EF4beueqssYSrJr7jAiyWtRxi/ynmIi31SbgxtAbxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GUJi7xOyKnmmb+9/TjcOfqtJqpwNwcEvdxo8Z+GPed22R08tm47poSEXj6rmcnGrf6lVV1RSPiTYIVVbZeJJmkH5b4TgaJdhpYSFoV0CbcISWQPKJmdtoYrjDs11ASWwKH2lqBF/K8GihlbcZQ6V+4jqV+PG/HHeIVgnocxzFJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fhwpRoog; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FzAXECaK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
	b=fhwpRoogQuWSFbaBh0s8ODmeCly1d8UTg61ZuQq7OyOTmcTSJD6ZFtnsXDmPvd+XhdHCO/
	UKZLrHTnXU9ulOjVahixSqY4GOZvWpV/Ym1gZ7rQwiBfdzqIaKQTI6TfQfPFSXXhEo3/rM
	hDbUSuy6j10aykuRFAXhLkga0ugWaTI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-r5UXS82BPkOvSpUSIRwycw-1; Mon, 05 Jan 2026 03:23:12 -0500
X-MC-Unique: r5UXS82BPkOvSpUSIRwycw-1
X-Mimecast-MFC-AGG-ID: r5UXS82BPkOvSpUSIRwycw_1767601391
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-430ffa9fccaso10786600f8f.1
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 00:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601391; x=1768206191; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
        b=FzAXECaK9cpyvzSFZy2EhuHAzlJYHYh1Ucgh0W27TOzjOUZxhoOG8f84Akx1O9zwx4
         CC0i5zi+JAF8JUzNa7jRnGOZgifzp6xP185MLdaxTMhpb3BVub6wsldVxzkRMP7sKCTF
         Wh/9qnZIFH/gtILXIgimM1Q5mF9HE/JX85wGVPpWlctAAhY18PWOK37gvJbETMTa+Spt
         42RiCPItEDLPj+tnu4dl2DVDx41dLyN2aEcuuR2R8kpPrI9Bdk9r7F9OUYvygjmLA4ap
         M0wbuEybZHozcmrIpXIOxIo5REsr3F6Y+qMZG2Jrxljck8M9b1jbMaSbfzVjBHILnQ7A
         q+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601391; x=1768206191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
        b=K4Muf0+he7q8pWk5fjnWwoFtYvn8Cxf/pUa47KbuYfNe+HOz432Bjm7pIzG/aOA3AX
         Ynlno+mpED2kC0U8y/n7r6q1YrfwdZeZhgIYgBW1BQJcEYkyu6FcuLwoJrCmBgAgBgnf
         UGzdx7PtAfc1ehwBqceDEg1FtTygdGTylWYkBTiUrWflXqlrJU1HLJTCSnwx8hQD0mbP
         WTghWMUsn0Cff6hWtbAq4caFUSOLqZsRM+3XC0U2eiMwSj/am9a0YXdHxd2udrbxsQj1
         Qx2HmwIoQC1Rj0td+58Pe3Y9h4lp0EheGY7pQjqWKRb8p7GuWO3h6yngySkLTgTtF5Cv
         2lqg==
X-Forwarded-Encrypted: i=1; AJvYcCVaw7nSIvYqOguNoNW3U7lS7t/pNSmcLwTBy2t8dOdQs0TXdqHJfJYY7/invkIyLKFTV8U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx879wsv+nfPb3Ymx1TPtYgBLH9rgSl2r3kl/fnOQKQk3M1bzuZ
	VrmlNUpKOdnyJoR5/seDnUGEqTENmsSQjINoINtig1uTkiJvE+4k74+2ThHGQMhmJSmsg2r35qW
	AOpQEBfDKk1xzfTH49ZIlQjkv7EpvmExgSmePbKXs+wkRHfWElfodOg==
X-Gm-Gg: AY/fxX7tFhEsrX14leUYVCNDxyEU20SDyNrbeK9BuHAOwiUnrEunv73qp0jw+Kprw7f
	q/Kt4hSxVvxi5KbNrJbyTEadhHNmXU+nhcN1L2HcYPuAzOuKtn1AeNStRhM5H5lHmDt1oM6a+ms
	UnxbkanoJUrkS42grLUEFkGtDQgrEMWyiXBtDhnUb+Sq2DsIfYBFDgvi02cDF0svF75ylcyLj96
	5acpK9bq9UdJFC9b7AMnkGexZkYl0YuoDQ4wDktF8elEq+koRGKJDg3cg5Eo3Elo88bgKw8HfIY
	N1oXKdICeohYMp/1kih16kK/iVRm69enX8J3mTvo5V/cYAPeuYX4EDMFnsbcjT/DqgIwdm76NLJ
	xHRNHlH78FTox4AJ4HUrZJE7phCZ7MHQJMQ==
X-Received: by 2002:a05:6000:2c03:b0:42f:bbc6:edc1 with SMTP id ffacd0b85a97d-4324e4c1230mr54966698f8f.1.1767601390658;
        Mon, 05 Jan 2026 00:23:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwk1Ttr1N2m9x2GBHG1pWtih6zeyM7Sr9HAGjGkjK9L3/ihsrFeD/P27Wy0cj6YonFT6KolQ==
X-Received: by 2002:a05:6000:2c03:b0:42f:bbc6:edc1 with SMTP id ffacd0b85a97d-4324e4c1230mr54966659f8f.1.1767601390077;
        Mon, 05 Jan 2026 00:23:10 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa64cesm99604028f8f.35.2026.01.05.00.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:09 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:05 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 04/15] docs: dma-api: document DMA_ATTR_CPU_CACHE_CLEAN
Message-ID: <0720b4be31c1b7a38edca67fd0c97983d2a56936.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767601130.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

Document DMA_ATTR_CPU_CACHE_CLEAN as implemented in the
previous patch.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 Documentation/core-api/dma-attributes.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 0bdc2be65e57..1d7bfad73b1c 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -148,3 +148,12 @@ DMA_ATTR_MMIO is appropriate.
 For architectures that require cache flushing for DMA coherence
 DMA_ATTR_MMIO will not perform any cache flushing. The address
 provided must never be mapped cacheable into the CPU.
+
+DMA_ATTR_CPU_CACHE_CLEAN
+------------------------
+
+This attribute indicates the CPU will not dirty any cacheline overlapping this
+DMA_FROM_DEVICE/DMA_BIDIRECTIONAL buffer while it is mapped. This allows
+multiple small buffers to safely share a cacheline without risk of data
+corruption, suppressing DMA debug warnings about overlapping mappings.
+All mappings sharing a cacheline should have this attribute.
-- 
MST


