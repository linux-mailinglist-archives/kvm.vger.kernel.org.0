Return-Path: <kvm+bounces-44572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45BE6A9F247
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 15:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC21B5A03CA
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 13:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD0626B0BF;
	Mon, 28 Apr 2025 13:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="a8/rmBUs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3632126A1AF
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 13:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745846700; cv=none; b=Uk956dEJ0jY3TE3Xzk4JvLqaBGodKHIvcMcPuzPLgAjLqGXnPESerRtmRmN+jvCWzPgRZc1ZPt6EY/p5Yjl9Gvyq7VWqe8dHvtAoPcjTKgATQeokx9SttPjXcudlvDf1WK4PoBogUp4Kmy0I2Dn8adGpyQdQwnPlXIoM3FIUrY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745846700; c=relaxed/simple;
	bh=WMDF+xF8cv9egZiq3dKhKzV9V89Oqq0Xru+OujRAu9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WT6g85Zv3uWK/q1kfAGIVVzFNdelVmz9oJLts6hvOfVjNMli17QHFSiD/T/YvmuMuD6IxaGX+NcEffSrns8Y0TUn+CdRa1JHewbEkezJnaI3Vmq+HarViPV0zKyTn4xrhHZXeXHPQLHGyrh2mDjeq9y3BqAMpCgcLqeI5Mdccyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=a8/rmBUs; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6ed16ce246bso25638756d6.3
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 06:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1745846697; x=1746451497; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TghuZvI1NqWY2rKkKrKVWO9Hy4Hhr0amNahvHhrH2wo=;
        b=a8/rmBUst1R9TjBHzyC3Rl7He+DPBljFvXOcSbBhR/iXiGfg8dhPtUruErD1PurwRF
         4iIwOaP5OEoCakNzjmeJrvaTZi9rKQw8WWQOzq+RLwEU44e6S/zd6vaZKKYRvDLRFUjr
         pvR/iim0F6OwB1KDOxLWgXP/kpivOnv1Rk4OXflqTxOB6tuOwQG731NTd4W1nJozoNZg
         2KOHnJRBLn2XPFftZMmZnSTSop5FBFFrARRX8XTgI4OSNdISm2YRr5l9HaOi6HoMUqgH
         /FAu8Cz46qvmwCc42MtXg2LBI7o+UDjBcMbBCmay0+Efgt/eItjoiv4MpYat6yJUj8wK
         wNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745846697; x=1746451497;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TghuZvI1NqWY2rKkKrKVWO9Hy4Hhr0amNahvHhrH2wo=;
        b=pIwnjNSNclleki7aVJYv6YojlDrBWEAdrfEPGQILZmWhz+Esu9863Af0xYDCmpyx80
         95ORha4nTPliUrTK7nSW6qPfVV0DbK5cImo/zXGjtXbjlKhGBOCmHD5AlNWXgoalyhqx
         HnOuhsF+kp2BpHnH2zaRGM8ml2kcum1lOW+Z5awn8WcLQn+EIXkAlURE8xEqTvuN2AQU
         /5rNjP2J3C8ksp33bm7TU2LZsZff9eG8XFM5X94y6GCJX5m7wAs5lZWS8CZXywbHiuOU
         FJoVILA/98vwKjtCxhMRzsF2J5LtE3nx87qUtW//05XkDbj4kOIS25aBiRX0lfremtBE
         R4pA==
X-Gm-Message-State: AOJu0Yx2NLxgjPltJe6xOTmKeueMpszKNHHfRd0dx17kyajoNTQdTPUj
	g8AUtL+vPnzwTBUgYWPbbcBgKUcjLG5RtogbsviTQ1kM7IwD8xHF7Mk075a/vdKJNVQD7Fj38s2
	Q
X-Gm-Gg: ASbGncvwApL9L2sNc15qQljM2h3ae041Mxv8todJjez2t46bFmG6Ujn75bLZAuStzDO
	sZqWhE6F/V+uP+VN8CRD5aHvFgqsI5rGGAPpJeeG8zse2555Na3ibCWpvnZS8cGm16JorEKQCvf
	Xg+1yE22C/ExQsVkxFUZzfu9iR1diRrr5F/svpTKN2UJgT8Qv/laz51QUUZRmoS58+kuGrTuH0D
	KrmF3jd2f1o0m4xDXp7VnZ7dQRGNPkvpS5X6cJZOpjyB3IySotceILY1WUYT5zl3StzQyHVpCcQ
	pzcBK/CXG2Vd9tJUN1xUVXkK1Gi3GlJSsEVAbaBOkjICkweR8B1KNZda/74ybzcdb1tCuzv3EFD
	1pUXUonPytCqYF0jCmsM=
X-Google-Smtp-Source: AGHT+IHS+LiKPwUgJdOq9cWDDSpsQLmT0n1tW9M/V5tmDv3MAmBTgvwZIZ3Uzue2gsWFtJHsf7k49Q==
X-Received: by 2002:ad4:5746:0:b0:6eb:1e80:19fa with SMTP id 6a1803df08f44-6f4cb99d537mr193763226d6.1.1745846696983;
        Mon, 28 Apr 2025 06:24:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f4c0968a44sm61218186d6.60.2025.04.28.06.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 06:24:56 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1u9OTf-00000009Tsv-49gX;
	Mon, 28 Apr 2025 10:24:56 -0300
Date: Mon, 28 Apr 2025 10:24:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>
Cc: kvm@vger.kernel.org, Chathura Rajapaksha <chath@bu.edu>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Xin Zeng <xin.zeng@intel.com>, Yahui Cao <yahui.cao@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Dongdong Zhang <zhangdongdong@eswincomputing.com>,
	Avihai Horon <avihaih@nvidia.com>, linux-kernel@vger.kernel.org,
	audit@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] vfio/pci: Block and audit accesses to unassigned
 config regions
Message-ID: <20250428132455.GC1213339@ziepe.ca>
References: <20250426212253.40473-1-chath@bu.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426212253.40473-1-chath@bu.edu>

On Sat, Apr 26, 2025 at 09:22:47PM +0000, Chathura Rajapaksha wrote:
> Some PCIe devices trigger PCI bus errors when accesses are made to
> unassigned regions within their PCI configuration space. On certain
> platforms, this can lead to host system hangs or reboots.

Do you have an example of this? What do you mean by bus error?

I would expect the device to return some constant like 0, or to return
an error TLP. The host bridge should convert the error TLP to
0XFFFFFFF like all other read error conversions.

Is it a device problem or host bridge problem you are facing?

> 1. Support for blocking guest accesses to unassigned
>    PCI configuration space, and the ability to bypass this access control
>    for specific devices. The patch introduces three module parameters:
> 
>    block_pci_unassigned_write:
>    Blocks write accesses to unassigned config space regions.
> 
>    block_pci_unassigned_read:
>    Blocks read accesses to unassigned config space regions.
> 
>    uaccess_allow_ids:
>    Specifies the devices for which the above access control is bypassed.
>    The value is a comma-separated list of device IDs in
>    <vendor_id>:<device_id> format.
> 
>    Example usage:
>    To block guest write accesses to unassigned config regions for all
>    passed through devices except for the device with vendor ID 0x1234 and
>    device ID 0x5678:
> 
>    block_pci_unassigned_write=1 uaccess_allow_ids=1234:5678

No module parameters please.

At worst the kernel should maintain a quirks list to control this,
maybe with a sysfs to update it.

Jason

