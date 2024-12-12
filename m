Return-Path: <kvm+bounces-33647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE9689EFB47
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 19:41:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B45528AC7A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 18:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 299C52253E0;
	Thu, 12 Dec 2024 18:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dtEEDDUA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FCC223C7A
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 18:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734028789; cv=none; b=n5kdiPbw8lhr3+5q0fJUAA57rqRtzbMIQkW58FXn+ddoQWSOQa+KPgGiHNBBQXoQSoJhUivxqbwYQZpO3OAIOPZO03g+tcGyBBUf8bUqTv7F2gieDkyaYP7PT3SxfV+4baxx4Hd4VFPX00jsTep8ZBCEJS1UbJru8YpF38nCV54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734028789; c=relaxed/simple;
	bh=9pNfT7ERPIMb4LYG8uq9v+u6T2erNBm0rHd3mTzfQ5g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ipe2OtzEJvmSAv1C1YQIZZxD+oyiLhyf5QJ97oWLay1iw6OgKRfdxm36UgMaqn0Ed6/d4xLTU78na4ts4/H/C7Q1JTTmPeghSIp1mX9swxWPlzDO0L++tSftIz+W8PuqSIA8hLTDa3+IkQftmmT3JX5B7CYrt+fb1dG1hp2X2fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dtEEDDUA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734028786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TVAP1UUpl4RC3uoq0NWIkqtMfUnKlUxZw+H0trVwzz0=;
	b=dtEEDDUAbtnGFFkw62U4KIagkNP3xNyEkoUc0GZPg51YYo64Rrq+R16frSM8k63XBBluZK
	IbdQcpmD4Kfr0W52c5pC3Ms1NzhOqvnAeQgGBOKlouzSgh1tFCLUM0vgm3C1/w/R5OJrxS
	FN2jb13s9fry+R6NXuPVxKmvAJNpnn4=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-yFj362_EP62aPdzVPHQMSg-1; Thu, 12 Dec 2024 13:39:44 -0500
X-MC-Unique: yFj362_EP62aPdzVPHQMSg-1
X-Mimecast-MFC-AGG-ID: yFj362_EP62aPdzVPHQMSg
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-841a803534fso9333639f.0
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 10:39:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734028784; x=1734633584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TVAP1UUpl4RC3uoq0NWIkqtMfUnKlUxZw+H0trVwzz0=;
        b=adVX2gkYanBdGFNSA1b+15993LuDYAkISZPJBbN54QcIaiq8iEZFF+DuzsBtuEWv1C
         41ZkZZS/oNT4O3Isre7dDFVS3vdy8vuznfycbJD0WwpG0UzNT4DwoeGWA28+xBSYHPqc
         N0vTSrzbz0aCL2BMiH7avTfmAC5U2W6gXcxWh51jbgb1vNMb6DgVzA/W0/mKXzBWCdQM
         M+TNYhhLSsIbjCT/Eiw7fBP3LkxmIUWXtYFaByqs5p2OImK7ZrZ1AmN7z6pTfS6OXAYL
         0w7HbVBdJw+/sb9Fs4CQW2f5EQUirbnvpHPPyDhmHJnszzyge5qAZvJq6g2Ak2nB4WNb
         kswg==
X-Forwarded-Encrypted: i=1; AJvYcCUDFF5dooJPwjLkhiJN2yZazwN9PX7/GI76sCakMvISrmO0zZB+TlGeaXKxIYqCwYN0h14=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBu8FaByb/x/l1ANknTDa3BK9fb0yxMUIA578naE291Dhn4r8O
	ojdlevVb6TzxX6mWd0WvXOU1d2wo9EBFVT4+8oXL54R0vVYl8U3MGhf+aahLbQDS1xxPRcM4u1F
	R8GnMaONIOLtM8lxrjO6pWcJji3zQMxZXFzjg/fRPtw3qqTDmMQ==
X-Gm-Gg: ASbGncuWi8PQCpIIuTxaLTFBuEM6imYEzD1deNMHwpqA3T6P9OSLTQVAF/vM8Boq3qc
	L+tEuwhNMjK8for6VvsuMPYve/Eb3fhdx4wvnVzzBoAuxvBUKEds/HVPg8oNYm718MgJQTHldEA
	hciBUNVHNrr973m3U21UQq+k1mnVl1FefXJogQO3yPjxJkK23BD0tnaujEg+cLj8dY+kzfYmEAU
	19zW25ZkmaONOT3ooNXEFV4wRTOUzyeyB3PUTj21rfM4D6tsVGbiY32HsAT
X-Received: by 2002:a05:6602:2d8f:b0:83a:aa8c:4ebb with SMTP id ca18e2360f4ac-844e552d403mr47916639f.0.1734028784087;
        Thu, 12 Dec 2024 10:39:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHR/1Q1Cl/d5vhkH6jRLYyLPJbkqQZ9SNCeMuWPUkwesxPHmwqUXOjAKMjQJFuLYfSJwaHp9A==
X-Received: by 2002:a05:6602:2d8f:b0:83a:aa8c:4ebb with SMTP id ca18e2360f4ac-844e552d403mr47915739f.0.1734028783785;
        Thu, 12 Dec 2024 10:39:43 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-844d6e0d69dsm61683839f.33.2024.12.12.10.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 10:39:43 -0800 (PST)
Date: Thu, 12 Dec 2024 11:39:42 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Heiner Kallweit
 <hkallweit1@gmail.com>, "Rafael J. Wysocki" <rafael@kernel.org>, Kirti
 Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
Message-ID: <20241212113942.4be94e46.alex.williamson@redhat.com>
In-Reply-To: <2024121256-goon-ashamed-2339@gregkh>
References: <fb0fc57d-955f-404e-a222-e3864cce2b14@gmail.com>
	<2024120410-promoter-blandness-efa1@gregkh>
	<20241204123040.7e3483a4.alex.williamson@redhat.com>
	<9015ce52-e4f3-459c-bd74-b8707cf8fd88@gmail.com>
	<2024120617-icon-bagel-86b3@gregkh>
	<20241206093733.1d887dfc.alex.williamson@redhat.com>
	<2024120721-parasite-thespian-84e0@gregkh>
	<4b9781d5-5cbc-4254-9753-014cf5a8438d@gmail.com>
	<Z1ppnnRV4aN4mZGy@infradead.org>
	<20241212111200.79b565e1.alex.williamson@redhat.com>
	<2024121256-goon-ashamed-2339@gregkh>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 12 Dec 2024 19:21:34 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> But samples are not "real" and are not actually used.  If they were,
> then shouldn't they be in the real part of the kernel?
> 
> So what are we "breaking" here?

We'd be breaking the management of and use of Intel vGPU support on
older integrated graphics (GVT-g/KVMgt), as well as the ccw and ap
drivers on s390, which are mdev devices that expose disk and crypto
interfaces respectively, aiui.  These are drivers that exist in the
real part of the kernel[1][2][3].  Thanks,

Alex

[1] drivers/gpu/drm/i915/gvt/kvmgt.c
[2] drivers/s390/cio/vfio_ccw*
[3] drivers/s390/crypto/vfio_ap*


