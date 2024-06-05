Return-Path: <kvm+bounces-18941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51CF08FD2D9
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C42A6B2295A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6062215EFA8;
	Wed,  5 Jun 2024 16:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="gUDJJQEm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B13B10A0C
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 16:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717604573; cv=none; b=WfcS513N0jkS/EX7R1lahmB5EOV07JC5+jky41i/AaGDN6J2ldrdI5dQiFy2QrVur4nEu6SyRWM2+++HdC9K+p8v5GlsqTAcFQd8w+4uIoDkrqVpRVhMlCf/xRTjwWd1YkLf0AmPvbgBhY0M+pFQemm64MdOWvSP+WSr3QXtQXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717604573; c=relaxed/simple;
	bh=UNK6lxbGj/I4OE8GnjlKxvJzAlzQa9SOSY7DOmujm8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SEnbKeR5IT2zDeygN5arQSdcmzSOah35MZDOx9ZTplFnuVfhmBA+OmJYzsOaDUCMGJqhCmneXxmgAL6dBTnkyyZZ2UwNQm/LUaOQxK7SuRaZ56igLZWrCARJUYzWgBiGop2EAaf1K6KQOwjVpcy6VlNCvM3jpQsmL7B1vEGyh38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=gUDJJQEm; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6f9377d9756so1527970a34.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 09:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1717604571; x=1718209371; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UNK6lxbGj/I4OE8GnjlKxvJzAlzQa9SOSY7DOmujm8k=;
        b=gUDJJQEm7EQHxD0PM2KqpZnAKRMn5bh9byp70cgMSrDblAlLPrGkrUFZ1b06OVmSnU
         GkBnlg3rGm5ZWAPRsL0ebPIm0MzsMGVRziGzdKs/lY4eGxXcd1iSaFtelRUB+0jZq77F
         AoF9K8FOKfaq9M+wdtOgK9RrqYSeUoSjKxlXoLJw+RvPLHAZhN6G/5zOEQI6l1VS2oIe
         N5JygUiHdPvbyRWJMcrmV+xHTDue0E8S3IaawbTwQCVr4rrRT5Yi0CndhLlX9hSKZ56S
         4BOIsJCi+9JPndEMMyJNjhqFkZs36ojmSffcpDblrR4JzVpo7Q2pUYz/hZMDVV0VMPrF
         sg/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717604571; x=1718209371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNK6lxbGj/I4OE8GnjlKxvJzAlzQa9SOSY7DOmujm8k=;
        b=INcw4O1/yCeiBufdwFWsGrJM2GDAhDxifg9gw2DO+bkHs0oJv1vCR8gA6aeEsPekGT
         IWeivBe7YVdGIe4lIX+d3N5BCza9SS3ky3mx575d57Ob2q9c5Z619V28pQ2V+U0EFMLD
         dMabqWPS6bDXwZt4vqUbMAPUpB3Eufa8Ol7xoH9WXQUozWirhvfdzEwzi6IyCuCXZwso
         8R/TW8FoE0US3gih/kZCnUj4KbMHoWT+9LRvmwwHKKz4Dy0ApS+WgS2i9DJ3m61froi9
         1lvodgjJZ/sYcNnKOX2T43ouBLPMxOJYSo1ydEzmOIejcH6cXw07vfBKuKVvxM8/BdE+
         rNCA==
X-Forwarded-Encrypted: i=1; AJvYcCUaKHffbEmYjSB4QdnZUT/eDAryOqPVLGstIHlgNRZoZFECIgx1aN624rQ8OfRrv+j+O9rwjaKozux5h+zTK74yMv88
X-Gm-Message-State: AOJu0YzHPCd73kQnc2OEMkQPA4+0kz91oMC1LAxx63OVj2MzbremAW6j
	xAzlgLjzf8Npen/C7VJeQQqw+OQJENb9Tz0Du7DgbJ6tAil/b0M64PvU3Z4VqLw=
X-Google-Smtp-Source: AGHT+IHVCP9mGNwHWasTmq5z3kZUHSugwMMhnZD4b9AGFgdXW7kK8sC/F2IY2rrnoa0hU7TlmOZk7Q==
X-Received: by 2002:a05:6870:45a4:b0:250:7353:c8f2 with SMTP id 586e51a60fabf-25121ffe4c4mr3403554fac.43.1717604570789;
        Wed, 05 Jun 2024 09:22:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-795015bed64sm346687985a.8.2024.06.05.09.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 09:22:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sEtPV-007TNB-Pb;
	Wed, 05 Jun 2024 13:22:49 -0300
Date: Wed, 5 Jun 2024 13:22:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Fred Griffoul <fgriffo@amazon.co.uk>
Cc: griffoul@gmail.com, Alex Williamson <alex.williamson@redhat.com>,
	Yi Liu <yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Ye Bin <yebin10@huawei.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio/pci: add msi interrupt affinity support
Message-ID: <20240605162249.GE791043@ziepe.ca>
References: <20240605155509.53536-1-fgriffo@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605155509.53536-1-fgriffo@amazon.co.uk>

On Wed, Jun 05, 2024 at 03:55:05PM +0000, Fred Griffoul wrote:
> The usual way to configure a device interrupt from userland is to write
> the /proc/irq/<irq>/smp_affinity or smp_affinity_list files. When using
> vfio to implement a device driver or a virtual machine monitor, this may
> not be ideal: the process managing the vfio device interrupts may not be
> granted root privilege, for security reasons. Thus it cannot directly
> control the interrupt affinity and has to rely on an external command.

For a long time I've been beating a drum that people need to stop
using /proc/irq/../smp_affinity, so I like this idea :)

Jason

