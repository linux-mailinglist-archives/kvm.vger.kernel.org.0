Return-Path: <kvm+bounces-42813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C2E11A7D6D2
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86BAA7A2020
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91525225A29;
	Mon,  7 Apr 2025 07:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dEfPSiMi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A054C6D
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012366; cv=none; b=NT/N6znA7QJlJJ67hpDPdvYWdYQzfYlYDQHmp6JQqDHkJlmrjAXD3ggnbUufaLG9gvFymAodCqxb4fRriM+qfi03tPwME8fIaA/BcsPGpw9l/G/9ZLykp6GPP2e3yGiecde1MAqzlRu2zJNo1ZAqv+6proQi7NmKHeK0rjlo3iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012366; c=relaxed/simple;
	bh=rUX6kwf2jcF8ugrawlFPTy7xjQXkwZR1IvpwRwX1AmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mqw+ARvJNB8IonqtWJvFZzHHAuB4MJe4Fz+aJGLHKm5h7Pocm5xLvGhhMenXTlHLSq1zmFSx1YFvsgNLQJhEQLQ0S1ttbbkoYBxCPVIQ5gRenrwJEXGlJZY1Jt1tyXJU/xQqHKcfwEz16zg5HbK398AxR3HBFaGwpGMlrIrT8Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dEfPSiMi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744012364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SWeyxgVRp5P7mOHz2eAUtnv3gFTxLpkuE25ons4rBo4=;
	b=dEfPSiMiA2EKUviZFjwC6pQ1BjlCBHkoWLN0QiZiLBRDBtu8ODJRfqK+S0mvSzKnkkMxye
	lhMHEuU3h1i1mzRWq4vawDJUwJd/GBPdP+eMDSafijSrO/Nx7pyi9xtZB8NIcUqTNcSUFE
	vUCZv4FCoZT0NvfMVvkrvb7/Yzzj7wo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-pq4vyaziMTaiWX-UOHMJHA-1; Mon, 07 Apr 2025 03:52:43 -0400
X-MC-Unique: pq4vyaziMTaiWX-UOHMJHA-1
X-Mimecast-MFC-AGG-ID: pq4vyaziMTaiWX-UOHMJHA_1744012362
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3913f546dfdso2367513f8f.1
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 00:52:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744012362; x=1744617162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWeyxgVRp5P7mOHz2eAUtnv3gFTxLpkuE25ons4rBo4=;
        b=hYg7ydHtIcVe5zfIfx65Z1Dl21OoBN4/4VYH1ZNiRF7HEZxz0lnS8RoUVga+1jeoHy
         iAX8BflH1drVb3hOxxfED81lGpWIj1OtitAVpLISrIaZVH2lj8O9Y6oa3Vw3BkSMbreb
         nziBUqRV5AdnesAx3pNfk1VvynxsUXAQWg9Bnjkcsmu81sIf2AsbNIuxelEjGVu1AU2z
         VYkw6y9OyYtY9J/BP7jdfOuFu1CW8TstogWZjSD7x3U61gs6QnYTzKG6qBLj4mUwX3jq
         HrlXvUPulkT2Uv2YkyGvPjPJN6BlwzrTAB/KaUq9libYapwaUTB5R8eScy/qLuPLxENq
         kHxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUb6c1bW/SCsaVpLK2PxGVwFQ3BLj9j6alIzrpYBDwkfPYcZAUYwiaEoxI1MtCGIJBXwcM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4tUMHK18iY/AndJUW1vNSkD8BbcyO01wq8bb4WvsLXwFPNVMs
	n5zHbYmCb4Q2lCfSNHlwSBF8OI+OipvzT3S9iJCNxr9ixfcX6naCF3I/qcpK3tn5AXRo7rczmuW
	ySdz2gTIZix9xYzaj7zL0zAF7ijbjEPgxKriANNTv4WKrs1licA==
X-Gm-Gg: ASbGncvHI+ofGWGYfhohFXMlRuoGXfywgPcLxGmzFwiF/JyLGaj1rd32q+u5lltUsV2
	/51ksIhJK4rckMTkRsiQvRNtUTJ8TQN7Hr2pXH2nWY2QTRm/pApu/k4kpDw1nIIYPNoTPKqsPOL
	/qRr35X81MbZSELZp9tx2S4E+tR+4a/lanXbMSwzVyNfeZrla0+KL3aIGVOLE/WYVWGpHulbOSX
	/IXpsWh0wm8YRlqyJXLxYrPIfiME3bLa+xRVzoT2RUr7sjwWqjaRNcBARLEwW41OLPWA5I4KTFu
	NSZrpwlxFw==
X-Received: by 2002:a05:6000:2ca:b0:39c:30fd:ca7 with SMTP id ffacd0b85a97d-39d6fc0c02emr6572083f8f.7.1744012361837;
        Mon, 07 Apr 2025 00:52:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJsYAXUaNdpV/VhhZQQ5RxLgg/gr/bn4kaQg3vnQsXyz4+tvGKcyIi12k0f6ULNipYdQ/RcQ==
X-Received: by 2002:a05:6000:2ca:b0:39c:30fd:ca7 with SMTP id ffacd0b85a97d-39d6fc0c02emr6572064f8f.7.1744012361448;
        Mon, 07 Apr 2025 00:52:41 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39d75ac6d66sm4958408f8f.14.2025.04.07.00.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 00:52:40 -0700 (PDT)
Date: Mon, 7 Apr 2025 03:52:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Halil Pasic <pasic@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
	Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
	Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250407034901-mutt-send-email-mst@kernel.org>
References: <20250403161836.7fe9fea5.pasic@linux.ibm.com>
 <e2936e2f-022c-44ee-bb04-f07045ee2114@redhat.com>
 <20250404063619.0fa60a41.pasic@linux.ibm.com>
 <4a33daa3-7415-411e-a491-07635e3cfdc4@redhat.com>
 <d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
 <20250404153620.04d2df05.pasic@linux.ibm.com>
 <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
 <20250404160025.3ab56f60.pasic@linux.ibm.com>
 <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
 <20250404173910.6581706a.pasic@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250404173910.6581706a.pasic@linux.ibm.com>

On Fri, Apr 04, 2025 at 05:39:10PM +0200, Halil Pasic wrote:
> > 
> > Not perfect, but AFAIKS, not horrible.
> 
> It is like it is. QEMU does queue exist if the corresponding feature
> is offered by the device, and that is what we have to live with.

I don't think we can live with this properly though.
It means a guest that does not know about some features
does not know where to find things.

So now, I am inclined to add linux code to work with current qemu and
with spec compliant one, and add qemu code to work with current linux
and spec compliant one.

Document the bug in the spec, maybe, in a non conformance section.

-- 
MST


