Return-Path: <kvm+bounces-33315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16EB69E97C5
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 14:50:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DD0418883DB
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 13:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14FA612CD8B;
	Mon,  9 Dec 2024 13:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="KuCxrIFL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148311A23A7
	for <kvm@vger.kernel.org>; Mon,  9 Dec 2024 13:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733752199; cv=none; b=c6iZ5NFCbpTcykPoMDHN0pW4323ngAHctjUIwRRem5wca6U1ngAVi60++YDE3eLmn9MOpN73/jW4Vhz1E7B2PYFWUhhcsEqMJtwUU0KrUik1xTATz8vbgXTWUcHEAMcDSUFY+q18UGBOpzL+ekqpQp/gcmBsDm+A+MWB5eQsH68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733752199; c=relaxed/simple;
	bh=J4YDUO69JYXmaK7rKTsj+KtVjyKbXrmdSv9J3ZPhd6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tyoo46t9pONNHQmhxZhBDlUyX+Bs8o7sQ+58k7KrOXysk+QnbUAfeh9JEDkLwLHVylLekVFbXHtG0PW+Vy572sHxiC9aLSCdEGGhizT2fpmtC8SRqFOBliDPwuoZKiEe5cEuQq5GN4XhAouzIh5GzM8MFEoh8p4taGidlpEHr+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=KuCxrIFL; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4676aad83d3so5282061cf.3
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 05:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1733752196; x=1734356996; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8yQm6NRzBKoFkTK/j8h2ksq4bd1PuJrEmkFvS72/a7c=;
        b=KuCxrIFL+QIi008aH8/RligBv9dlIVjSV7venC5Jw8Urg5wZ3ygFMHVI4iCyVbsgJV
         i2uJrFG16c157LXxMizy8OOC8RZGUhotducQ3DgZJMGBt4KPFpiYssvU3wA5BE9wswGd
         N3pMHwN7zir78rGPser+Jf2wwZgyL47daEYOl0SKPhyXFomd6ZEotJUGI6NekHQJzGkb
         q53gKjoH88GrhEQiWjhiosYCVNzgs/boRKq0yuowiKm2Yzl3/wWh6AIAXrWzLdZLjIX5
         cWWAP1FaJ1XlcrQouo4va87NcoUrWV6QTYQlKiBkhrK/l3NUN1bZH0IjTRruYe0dJ+2a
         7U6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733752196; x=1734356996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8yQm6NRzBKoFkTK/j8h2ksq4bd1PuJrEmkFvS72/a7c=;
        b=TeHiqjq55nSp81rfTbhvgSmbCM3F9BiKUkn1thG2V70/Y1Zi4tpyppYPTek4VN8L4Q
         xYCokGjSp4Wgyu187/XqmqzMdL9/U4BKYN/qaJv2ss7GAvNdQuwwoVX/T3DogBa9yzTq
         9RoeddeGyIw/7DnA6KOZfDcBxCJ3PIkHf8uH9BFCFqr+LTqLe+Zn3pIxvykkM01Y20Wn
         49R52dSnUR7etG2zxn7Mz5RQuK0bnHV/g1MglX/ZXJyLxO19A6+uS/0jZTcLDEs/tOmL
         3pEIjHa3oq5EnzauayM24E5mjEAdbXGo5urdNYc6R7nUZos+0e3IfiAAtPlfj2hK4itr
         oTNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvJTd8MGutZusrIHugQCrJj4nAwzzxhz7s+ieoeWRl+MffYMIh2zJcdUcdPsgafADkzCA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZT0Crlrbrixv0lmQ8xyFyaL4MhZmOvRPkQj1ZPAhwnM89n1EI
	X26IYZ/wP8jBakbaJjaUKffg16H+qywNdLeY87wnyytuGiuuctkyFaoMFwXFlFA=
X-Gm-Gg: ASbGncty4n3PJfMufkOh8FfOpifzz2YbWXfru7OLOdsyqjEaCetCyBdtKs1qszPtNLT
	7lmnxjX91WupT41OG0hjWFHQnw2/rFEiiW04sGh7y0YbGPMOaNOtGyPjiRO1oKJoQXhZdiJEOR7
	a5C7pK1CooROVbfAQbE9SjdYtyeXYs4Ht/AL92j1YdvbYtv6rd/b2cSubC/BitU/4xTHce4xGS2
	BhZSPbeX31+m+5mmHeyWGO2//+a1HpA+3ZHc2WgT94ve9X6Sh6Ovwewx9XOHT/M8yyoYWu62gM7
	Lp8RDXAvbosxVWG1iEwK7zE=
X-Google-Smtp-Source: AGHT+IEPGcEjlVPXl0LLEC/ecMx9oKz0ZCnq+q3yRQq+kzeZbdlnYmEto5Kklr6sYe6DPslMR8nNJg==
X-Received: by 2002:a05:622a:4a17:b0:466:ac03:a714 with SMTP id d75a77b69052e-46771ff4e3dmr8541981cf.36.1733752195027;
        Mon, 09 Dec 2024 05:49:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b6db04175bsm32715185a.52.2024.12.09.05.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 05:49:54 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tKe93-00000009rzT-3Dxo;
	Mon, 09 Dec 2024 09:49:53 -0400
Date: Mon, 9 Dec 2024 09:49:53 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Longfang Liu <liulongfang@huawei.com>
Cc: alex.williamson@redhat.com, shameerali.kolothum.thodi@huawei.com,
	jonathan.cameron@huawei.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [PATCH 4/5] hisi_acc_vfio_pci: bugfix the problem of
 uninstalling driver
Message-ID: <20241209134953.GA1888283@ziepe.ca>
References: <20241206093312.57588-1-liulongfang@huawei.com>
 <20241206093312.57588-5-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241206093312.57588-5-liulongfang@huawei.com>

On Fri, Dec 06, 2024 at 05:33:11PM +0800, Longfang Liu wrote:
> In a live migration scenario. If the number of VFs at the
> destination is greater than the source, the recovery operation
> will fail and qemu will not be able to complete the process and
> exit after shutting down the device FD.
> 
> This will cause the driver to be unable to be unloaded normally due
> to abnormal reference counting of the live migration driver caused
> by the abnormal closing operation of fd.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
>  1 file changed, 1 insertion(+)

This one needs a fixes line and probably cc stable

Jason

