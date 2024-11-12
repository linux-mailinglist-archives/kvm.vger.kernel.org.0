Return-Path: <kvm+bounces-31677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B2969C63C8
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 22:51:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE8AC285D38
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 21:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14F621A4AD;
	Tue, 12 Nov 2024 21:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WZkNZ/2/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA1B21744D
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 21:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731448249; cv=none; b=E9XcJcvhO/DwUo2Ip7gm0hj+sE4Q2ymIZxeUe/bmp3apG34TqfYm84/ArUsw8wqfRIK6/+PuDhAFypTntbRZR2Cp7A7VyE7G45MH43DlKb+5eCjaNR0Woln9d9V+pkMJZrUodgwZlfwsVytAuaSpgau65l6NiKDozInYpt9OVlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731448249; c=relaxed/simple;
	bh=xm+Ll3JltSLMPgfmR8tv6c18m24LerQYmVmRFqesrUU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VuABaTxTbqrcB3VTeURTQwubWBUIWIoeYmZiWYIn2o3GMCkZ9IcgBvlWizmJEOei7BU0+vB47LQH0G647QxxZYpiDHNmnKD6RjLnEeE3xaiO8d8kmiPBaZtd9ORRB+s58gRB/u0nh9aQYTEtsICKLfNJZMUT6/YFX7eC3oCn4G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WZkNZ/2/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731448246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tfhiK9YYltYV+RS78G8mwLr7L+fFOTGjTFmv3VdeA1Q=;
	b=WZkNZ/2/zFHHadFOf//rh4bekfEuDHfjwsQPD0dGMEVqkw98F3qROYFQ/JPuOVz6G3hNFj
	jZpzMBDv6HKwfl1knFwMTBXVTvulGsb0HyXcFB9i7hkHDHmph16/9ed4kW8/3xFf773P/D
	En7PVUXYhTQnOLJR2yfz4Sovbov/4ko=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-31Vse5tPNhGdSzTaZ8J3AA-1; Tue, 12 Nov 2024 16:50:45 -0500
X-MC-Unique: 31Vse5tPNhGdSzTaZ8J3AA-1
X-Mimecast-MFC-AGG-ID: 31Vse5tPNhGdSzTaZ8J3AA
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-83b29a63121so8072039f.2
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 13:50:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731448245; x=1732053045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tfhiK9YYltYV+RS78G8mwLr7L+fFOTGjTFmv3VdeA1Q=;
        b=ji1USXxPw+F1QWKbCLbhhv7+7HgElOxnMXuhzdti1xAElrANK6Zbg0+ofxJ65QxxlP
         8U0w0JzgM+PcJYeORisExIiKoWbcmypv6Y/KG3ulo+nA5cwB9/8RK56xMwqf8N04sfOB
         BXNG9z4QSrqIJnhJr0O++LvqFkJjPo+y+62QLcSP7k45aSIikQhVB0F6x+ERbq7eNpSY
         1i1CQA8/WHmulvABqIkmd2ipGPtEv1HSPqPjGG7AcjkUFgF+JYUfadMsmUWfi1nKR6gE
         PDtM3Jyjc1t5eQuF6sF2vk4VcKmB80oOQ8gvP5ZW7ctGtCZnPmzAoeJ4qZWsHwtNoXXY
         dmTw==
X-Forwarded-Encrypted: i=1; AJvYcCXD/bNuhLx9u7objcsiNPbeciLlKlAvf4MheHoN6nDB0OdDCcO7pPQRrRBi3a7qHcE2ieQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTXpZPTmvkvr7bX3yebAQvaXyUpRQQs/pL8aCknyn/+7wz7rdg
	cRJe8ypox0yRl4FrvefiQPLPzJsgKdZW2Z0yM8/nrfL1H3v4c5a31auvGDEHCZS55qKqVWNuouN
	w4vcOy2bq2FtK884wF5QQttv2Ignl3YR1qAALhQRVjbUMX+qdGg==
X-Received: by 2002:a05:6602:3f85:b0:83a:9350:68b with SMTP id ca18e2360f4ac-83e030815a7mr567062339f.0.1731448244910;
        Tue, 12 Nov 2024 13:50:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG0+a/6H0ukBrJt0ZjrH3woVs+ukMVKGZsElDCb6uPoCPtT0GWW0ORzC6Ah3fQgeBjw+LAGcQ==
X-Received: by 2002:a05:6602:3f85:b0:83a:9350:68b with SMTP id ca18e2360f4ac-83e030815a7mr567061039f.0.1731448244525;
        Tue, 12 Nov 2024 13:50:44 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83e135272aasm220925839f.31.2024.11.12.13.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 13:50:43 -0800 (PST)
Date: Tue, 12 Nov 2024 14:50:43 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: liulongfang <liulongfang@huawei.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "Jonathan Cameron" <jonathan.cameron@huawei.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linuxarm@openeuler.org"
 <linuxarm@openeuler.org>
Subject: Re: [PATCH v15 3/4] hisi_acc_vfio_pci: register debugfs for
 hisilicon migration driver
Message-ID: <20241112145043.50638012.alex.williamson@redhat.com>
In-Reply-To: <1c0a2990bc6243b281d53177bc30cc92@huawei.com>
References: <20241112073322.54550-1-liulongfang@huawei.com>
	<20241112073322.54550-4-liulongfang@huawei.com>
	<1c0a2990bc6243b281d53177bc30cc92@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 12 Nov 2024 08:40:03 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> > -----Original Message-----
> > From: liulongfang <liulongfang@huawei.com>
> > Sent: Tuesday, November 12, 2024 7:33 AM
> > To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> > Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> > <jonathan.cameron@huawei.com>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> > Subject: [PATCH v15 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
> > migration driver
> > 
> > 
> > +static void hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device
> > *hisi_acc_vdev)
> > +{
> > +	struct vfio_device *vdev = &hisi_acc_vdev->core_device.vdev;
> > +	struct hisi_acc_vf_migration_file *migf = NULL;
> > +	struct dentry *vfio_dev_migration = NULL;
> > +	struct dentry *vfio_hisi_acc = NULL;  
> 
> Nit, I think we can get rid of these NULL initializations.

Yup, all three are unnecessary.

> If you have time, please consider respin (sorry, missed this in earlier reviews.)

If that's the only comment, I can fix that on commit if you want to add
an ack/review conditional on that change.  Thanks,

Alex


