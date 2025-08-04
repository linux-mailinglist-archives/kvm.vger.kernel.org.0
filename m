Return-Path: <kvm+bounces-53929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D0AB1A6DF
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 17:58:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DE3018A4297
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 15:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B417726C389;
	Mon,  4 Aug 2025 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HFYrKFof"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC51242D70
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 15:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754323076; cv=none; b=s1+XlXUE1k8aqvufZWxvV0F5bJw1MujlwgFWXIpBXq5mzxW2sl7HEzJcyI23wAYf9QxpKRN18RzxdbhT41ahyjXZo3UmDLqTCauFYpnCsKqZotbP3Gp3L1aZYuyJ5iOUKCjvCUEqOE0zSCKiNUdkQzz7lLTmTYzqBcpXliTQDxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754323076; c=relaxed/simple;
	bh=pDVC7rFBszGbUr0AQQyyEXmDE6L9VQjbDNm8JyUEdWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o1s3B36G6LQ6lcfPSkeEEjGNkWqz2wzjeEemSl/NAY0CUyNm1m9iz479/KzmbUKejEQKckws5KWNAlnCcnvjBxqjlvjsRQ0I/OUSDxHBBNP1meg3urSuYeDUg0CTmebWf+W8gW/CuuPnCa8gKbYd+7srWZZxim4qn2ddWfZSt8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HFYrKFof; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754323074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T9mUgdLRs3w5PT298F337vFTebghvsVRguazdU4qoq0=;
	b=HFYrKFofjQCOwor3NnBqL6C/AAFXn8hGBnVZtyZPqluonKVwqhUY8x0XaPhzhDVTnTebeg
	V6O6vj7f5/68Tc+b+Jc6zOw627ZyicajXPv60C6r44W+sEp6lW2aXrsUoGqyFt2XhOGpl9
	pHMGhMwuGkT4gSnI+RtmPDzirQDljg4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-6yxbU-PXMhS5dNM9jpta8g-1; Mon, 04 Aug 2025 11:57:51 -0400
X-MC-Unique: 6yxbU-PXMhS5dNM9jpta8g-1
X-Mimecast-MFC-AGG-ID: 6yxbU-PXMhS5dNM9jpta8g_1754323070
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-456267c79deso10201325e9.1
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 08:57:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754323070; x=1754927870;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T9mUgdLRs3w5PT298F337vFTebghvsVRguazdU4qoq0=;
        b=XLPSpBD2SkIkREdXgtkp1me7W3TrfaCjOp5LUR62vELuwYbHZ2oc5V98+PpUqHKipE
         5NA5U/xMQo5otgQWErIRm77eDxfB0XnYqmhroZzVWg9oz0h5efCEUwdpLPmIdGfX4kzC
         plpgtsLHEqzTHt7RFCQDubMPlJOauSkq3EecOmg9OpLbPYgdbiEjRut51kNXIG4wl90Z
         LbpCVZpdLhZ+Tcj5GquZPXNHdRGCAFIlqf+jaMLZko35V0KjrAgAihMyRzjH0nDjlJQY
         Or7CjhT1Aq69fXNveN9AEGngI0XZAo4yu+HGEk3dP6bhcDOwaScKlqjU++AB92hq23fZ
         ratA==
X-Forwarded-Encrypted: i=1; AJvYcCXQb+b6JOBQ6rDTkqVgKrI9WGo7ArRt8XmH/ZDO6ODewKvLkWZUhuHAEsMKqSqqzxTpcWk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKMgQUKItsqzshMdVZUrY7adDtVXXBH5vwbbnL7o5c9PFkXrrj
	X/0Zjh5R5MCdv0cjDo+uz8FGilXd/4ZGGXIXBcFaKEZUCpJc1h3JQU9VWPi+gpcmOt8kMIAC0lM
	R/hDI615ZQzW0sbH5zgCCIIbvdEAnJ9ZjtTLpzl3TxBuNmzryC2vHIg==
X-Gm-Gg: ASbGncunhD+dj8tUdew0rP2/XNewY44hzh8P3dIIB/M4vwcmnssmgZ+eSvB+w/roL41
	xbt7xEdcKsyQ4JUGwD+Z+NaJYkUu/jQxMZk5kK03jtqOmEZAWo76+blN2ATBp26PWteAR+dxzVh
	cIibXs22CQc10/HU4kKU67hILw0Eu0pArPXjvvMhfDU8BWHGjOeN4u6qtjWEsinDR9b81hdVN9E
	c//YFM2s/tolunTOydhg0B8qn7o++EdpnacF+Ct/Kx61oQl0Dw3nNotc/lz6XPhHjQgRa8O1Akl
	JESIXvRPEpgtaUzroqftaxNsgQkf7NJZ
X-Received: by 2002:a05:600c:19d4:b0:458:c059:7d86 with SMTP id 5b1f17b1804b1-458c0597ec7mr60423665e9.10.1754323069733;
        Mon, 04 Aug 2025 08:57:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvZfiMjphP3x3l4zUqhsolAK9PHooH9Tsp0BlG/3TnfFNZ2tCNNeobV4uf7R2ru3mb+8//yA==
X-Received: by 2002:a05:600c:19d4:b0:458:c059:7d86 with SMTP id 5b1f17b1804b1-458c0597ec7mr60423395e9.10.1754323069333;
        Mon, 04 Aug 2025 08:57:49 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1515:7300:62e6:253a:2a96:5e3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8e054036bsm6166517f8f.31.2025.08.04.08.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 08:57:48 -0700 (PDT)
Date: Mon, 4 Aug 2025 11:57:46 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eperezma@redhat.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, sgarzare@redhat.com, will@kernel.org,
	JAEHOON KIM <jhkim@linux.ibm.com>, Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH] vhost: initialize vq->nheads properly
Message-ID: <20250804115728-mutt-send-email-mst@kernel.org>
References: <20250729073916.80647-1-jasowang@redhat.com>
 <CACGkMEuNx_7Q_Jq+xcE83fwbFa2uVZkrqr0Nx=1pxcZuFkO91w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEuNx_7Q_Jq+xcE83fwbFa2uVZkrqr0Nx=1pxcZuFkO91w@mail.gmail.com>

On Mon, Aug 04, 2025 at 05:05:57PM +0800, Jason Wang wrote:
> Hi Michael:
> 
> On Tue, Jul 29, 2025 at 3:39 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> > Commit 7918bb2d19c9 ("vhost: basic in order support") introduces
> > vq->nheads to store the number of batched used buffers per used elem
> > but it forgets to initialize the vq->nheads to NULL in
> > vhost_dev_init() this will cause kfree() that would try to free it
> > without be allocated if SET_OWNER is not called.
> >
> > Reported-by: JAEHOON KIM <jhkim@linux.ibm.com>
> > Reported-by: Breno Leitao <leitao@debian.org>
> > Fixes: 7918bb2d19c9 ("vhost: basic in order support")
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> I didn't see this in your pull request.
> 
> Thanks

in next now. Will be in the next pull, thanks!

-- 
MST


