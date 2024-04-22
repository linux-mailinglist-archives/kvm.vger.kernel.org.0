Return-Path: <kvm+bounces-15580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D107C8AD783
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 00:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28438287FE3
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE8B1401C;
	Mon, 22 Apr 2024 22:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MoFBFfm5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A84626AC3
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 22:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713826091; cv=none; b=XvKUMVgel8+LjUN0cgTHnY9jeTqS87AQiWOAQYprI5SANDMgSshdoxztrbm2j9QD1+4xJIy6X47p5ztGgI1mJTm2CA3OIIiS+3lCtf+pB6VefqRF7ulc7XP0/E/WdFRFdkP2uRikJW+fvRgbJL3xRmCkPZJv4js7/lpg3yaIiiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713826091; c=relaxed/simple;
	bh=gR5NJTY/l9WIhK6wCAFG6E7h3S5AmLnU+CncLwrKTdY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BtLrSSGsPcNZX5qFRFOxBcviofR5NxdQ46BQAafnbXLHGXwkmbBtkdFFFJfpWtolzWdFYdBVUovOAUB8loVp4KCD6B7LLr5ZaU7gA1IV32VzLoTkfddcyYQkK0ydWGqHaeQeTufLZqvbwMznO/ObD8mAqNbnvRb+Pxso21QlWmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MoFBFfm5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713826088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eknADUBQ3WBf5n83F401aG1TXkZvM6I2gRt6GxCcJZ4=;
	b=MoFBFfm5N5j3afAseXpH7YLLsGclOsPuXu7NCbd2D8NptD1hN1PcGz3IJhaCcT1pGOR6Tr
	aYhC+NiaVYiov6hkuTQzIxvhHPjp9Cg3HJ/0p8j1x9LleBOF/+qy1uUtg5Rf5xvjrWF2Cz
	IO5hh579WRXhoSGX53yXqSUzMKQMIcQ=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68--OrXUB0FNiCiTCXXdJYSCA-1; Mon, 22 Apr 2024 18:48:06 -0400
X-MC-Unique: -OrXUB0FNiCiTCXXdJYSCA-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7ddf08e17e4so28504039f.0
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 15:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713826086; x=1714430886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eknADUBQ3WBf5n83F401aG1TXkZvM6I2gRt6GxCcJZ4=;
        b=Z5FmYMSwzgkpUwkzzaYil2O6JgFNA4gRIhW0++1lWD/2UIcPPbBBJ7efjlGybxeM5a
         qBMlTiQxxcO9IOKxd92rCFpQB3Hfuk4BvAE0x5ncoLlJKfKT8L30JBOpyJP5mycdFwEk
         +XtA1Ftx4la8PAd2I4+fzdSiUSepgZXoZNEBeAGHs+zjcX55Fzk4xL43vIXndP3qA6+/
         5Kvnt4RKPjGk3KFXL0uPbV3d2oJ9FuB8p4IK8tn+Omm+CVaum+6KZfqqvTcpuBexSmMw
         mhacVIwkBxxvVRjb9aT4ERanlE0+Ae3ZnS1vxTmf8P59Onw1vaalYy0A6IGImrc32p8B
         Q5mw==
X-Forwarded-Encrypted: i=1; AJvYcCUefwZ8dIaXUBNkZPSEhH3/xlFn7JuyDBTXEBr6IGMvu3XPly5aoW7FnOYQa4SbXZAvrEeuH192CIM++NE70ZINCmkv
X-Gm-Message-State: AOJu0YwdtJJmYMLpXoeZ8bbKjQkKWjO1cwCizIyk+zXu6CjWbd4zvObU
	x2XGlKkL2Pvl1Ie/NONcoVb/IGXxO+69d8P+INd+c44qVKRsVifEwkaq6YfZuErDLZuApMobuEi
	Y41D9/rZ30DPVQ0aydihUmfBX23NVQjuosTWYifBJ2HJnycF31A==
X-Received: by 2002:a05:6602:14c5:b0:7da:996f:b54a with SMTP id b5-20020a05660214c500b007da996fb54amr1099930iow.8.1713826085827;
        Mon, 22 Apr 2024 15:48:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlz0VOgCdzXBEzoEr5ynN7VRhX30cpJMjqjZrke00cdIAk570djkpbzyhQ9VWBDgXBYxE8Ww==
X-Received: by 2002:a05:6602:14c5:b0:7da:996f:b54a with SMTP id b5-20020a05660214c500b007da996fb54amr1099922iow.8.1713826085536;
        Mon, 22 Apr 2024 15:48:05 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id is36-20020a056638852400b00485432e15efsm866451jab.97.2024.04.22.15.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 15:48:05 -0700 (PDT)
Date: Mon, 22 Apr 2024 16:48:04 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Gerd Bayer <gbayer@linux.ibm.com>, Niklas Schnelle
 <schnelle@linux.ibm.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil
 Pasic <pasic@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>, Ben
 Segal <bpsegal@us.ibm.com>
Subject: Re: [PATCH v2] vfio/pci: Support 8-byte PCI loads and stores
Message-ID: <20240422164804.7598735f.alex.williamson@redhat.com>
In-Reply-To: <20240422163353.24f937ce.alex.williamson@redhat.com>
References: <20240422153508.2355844-1-gbayer@linux.ibm.com>
	<20240422174305.GB231144@ziepe.ca>
	<20240422163353.24f937ce.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Apr 2024 16:33:53 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:
> [2]
..
> @@ -114,72 +155,33 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>  		else
>  			fillable = 0;
>  
> +#if defined(ioread64) && defined(iowrite64)
> +		if (fillable >= 8 && !(off % 8)) {
> +			ret = vfio_pci_core_iordwr64(vdev, iswrite, test_mem,
> +						     io, buf, off, &filled);
> +			if (ret)
> +				return ret;
> +
> +		} else
> +#endif

This could also just be:

#ifdef vfio_pci_core_iordwr64

at this point.  BTW, all this is only compile tested.  Thanks,

Alex


