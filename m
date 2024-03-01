Return-Path: <kvm+bounces-10694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A056686ECB0
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 00:09:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B92041C21F09
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 23:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2825EE84;
	Fri,  1 Mar 2024 23:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Twh2iKlL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0DC5EE6A
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 23:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709334552; cv=none; b=Sn6/Xfy5AvHS+qnPkZZcWhLUmmkju9Q8WGd2EcnHewD573cUZvMnkXfalcLnkO3lH4zdFQVeBWDuuOFTX112Mp8P5QxTQnSfE33htPhofDBpVEos2OxV/pTWj4bCIhgyGe0P2sxp7zKkLfgSg1X1od+bmIFU6067rAwoNNvOyDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709334552; c=relaxed/simple;
	bh=DxMwVVZpPHAjU+eOYaGF1/2G85jDOCsgnZ2MK7ig95M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KULiZfg/v2c2oNz6kfNT31pApHNDAtNeu1YiqX2L4HPKrCq7Kc1D2cJxLNvEOaYdKvyZOc3uQZs6inpEuUL5wq5cr0HrGFueWsV1290pd8WxsrLwyiNh8cDfG81IGMFblBqbvdOzbUMt30c5UQB3Bxv6I5P2wrxLI3ynB9U7hhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Twh2iKlL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709334549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=34L2ffpp68JRHN28OPMs2fL29bGErHKbRkDZnmh3sOE=;
	b=Twh2iKlL89REEhFKU6KsmnGNOSqTZIPpmwYpdKemG5Lujsi+dVhXz3vy5hVRZORKhvOI45
	QTKYVVXP3Phc11cDoRhCMHanteufynNZOdIDWGYcsl91rfewpYyR1DE77BqVANTWBn3HIB
	2DGGMrnDNWZ8qBgzEaxYj2SHieXthzg=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-mJgdQmU5NnqZmoD-kJ1Bjg-1; Fri, 01 Mar 2024 18:09:08 -0500
X-MC-Unique: mJgdQmU5NnqZmoD-kJ1Bjg-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7c7ba82fd11so227849539f.2
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 15:09:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709334547; x=1709939347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=34L2ffpp68JRHN28OPMs2fL29bGErHKbRkDZnmh3sOE=;
        b=I+aMOS+cHVwqyaGRv+3sp+MHeyMy29EEW1+XssFv1GM5483JIInoGVbgQqw9wz95uB
         zzoV+OfnBrCBftHWL4g47oKdb6IcgsJzklnzAcf29R01z2+NfdWJQGfeAuS9UGbkE7Mp
         5GNR4EKPQQaLMvs72HTQ/Hc7CVyovOyXCMzFlR1gAf3YXPrbb/iEpGDkP3cv8q469IJP
         TBW1VH0RtWD9UIYpUoZS72jLP+qtivAc8zrjR6HjR3U/12vvIT/P1Gej02qT/n9M3cHQ
         LK3+suVN6j5grV1njJFRdy/ijqp3LQfTgiFhBHdYu351bcDiwuhRK3rpVPpgvYVysMHx
         Ezaw==
X-Forwarded-Encrypted: i=1; AJvYcCV9F1ZElMyohyoV18b/gKe1jfcVK2I1VHQ+kyJBTac4yePZYr/oQZzssnidBqOPYx3hXy9xn2fMP5CGFq5ONlrEu3PK
X-Gm-Message-State: AOJu0YydGdHcK5z+7P8AA9ixvuzbT93xAQYaFJDYLWGng3AF/JPfBI9I
	c18823bhnwyIFZ7q1RdSipTp4Sbcl58MXHTgG4s9DIGWG4QnoS4gZhpMWa3K3TTY3mMYlhZIe6Y
	R0ZIjfoK20Ia0LDqPdJp7ZoRsT4FZQUmglrIWhSts802hCZ9A+w==
X-Received: by 2002:a5d:9bca:0:b0:7c7:90e8:c2e7 with SMTP id d10-20020a5d9bca000000b007c790e8c2e7mr2907125ion.9.1709334547599;
        Fri, 01 Mar 2024 15:09:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFf1dcCYWpkeVxj2OJs6FxuqhJjw0aL0rNKwpyTFd/MFzG9kEj+sgvi7zMB3hgGZvWhMQl6NQ==
X-Received: by 2002:a5d:9bca:0:b0:7c7:90e8:c2e7 with SMTP id d10-20020a5d9bca000000b007c790e8c2e7mr2907112ion.9.1709334547277;
        Fri, 01 Mar 2024 15:09:07 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id z24-20020a02ceb8000000b00474cb5264c2sm544127jaq.156.2024.03.01.15.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 15:09:06 -0800 (PST)
Date: Fri, 1 Mar 2024 16:09:04 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <shannon.nelson@amd.com>
Subject: Re: [PATCH v2 vfio 0/2] vfio/pds: Fix and simplify resets
Message-ID: <20240301160904.41162583.alex.williamson@redhat.com>
In-Reply-To: <20240228003205.47311-1-brett.creeley@amd.com>
References: <20240228003205.47311-1-brett.creeley@amd.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 27 Feb 2024 16:32:03 -0800
Brett Creeley <brett.creeley@amd.com> wrote:

> This small series contains a fix and readability improvements for
> resets.
> 
> v2:
> - Split single patch into 2 patches
> - Improve commit messages
> 
> v1:
> https://lore.kernel.org/kvm/20240126183225.19193-1-brett.creeley@amd.com/
> 
> Brett Creeley (2):
>   vfio/pds: Always clear the save/restore FDs on reset
>   vfio/pds: Refactor/simplify reset logic
> 
>  drivers/vfio/pci/pds/pci_drv.c  |  2 +-
>  drivers/vfio/pci/pds/vfio_dev.c | 14 +++++++-------
>  drivers/vfio/pci/pds/vfio_dev.h |  7 ++++++-
>  3 files changed, 14 insertions(+), 9 deletions(-)
> 

Applied to vfio next branch for v6.9.  Thanks,

Alex


