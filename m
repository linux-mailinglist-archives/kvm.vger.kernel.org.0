Return-Path: <kvm+bounces-40031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 04373A4E06C
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 15:16:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F71F1888107
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 14:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4656204F7F;
	Tue,  4 Mar 2025 14:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Ns4tJAbo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DADD2045B2
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 14:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741097691; cv=none; b=BnyGj4p0Xq3Qf1HEkWcNQWwrDUn5t2Cr96CJwHKdFGOFfL5jroO5U8cT9aDC6gsDmpSP4RK7NAfwrAuA6u5RucwZElADnAL+k9RTIwqaybVVOcuUl8IdOBcxoD0VJTZlaIRH36zy8G/VdtlEOk8b1ankl7I3C0tIH2pu6KoIdkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741097691; c=relaxed/simple;
	bh=OiLrp8ci87DZb70VaYtR9ZQenfr3MThO06nklmGO+rQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ji9Mwmf+cvXCiXzNIpyXlV8PrTM1xZhypT5wWrF7s/cp+qWh63utDhSUfgY9h2WNYT9df30hOFbOXL+FLtlz3tBiX14qyx5Jz8PxXrW5haWDdY6AK4B2LN72jwtkVoG6SI7YVSdF2VF7F/ICZZw8gK4jQE+o6hddy4nwhRq2qe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Ns4tJAbo; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7c3cb761402so203563385a.0
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 06:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1741097688; x=1741702488; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P5l2R6iUh6JQQNif8SJbj7EwSVWvxpPGSGu0suY4qtA=;
        b=Ns4tJAbon78WLM0BWe1cYtHrWzeIY7dg/m6qUDjw3lTlH6tdfhXRPxHWvowmmFh6hD
         S4gblloIkr+mOzlueGePRIn/NbKUONTw3MlKNLFB0osHr05zQN7nSux+COgcweTE7KXw
         lQ0CjB4Q3KlFTkP4kRoOYv8Iin3XNFw0eXZ4pOTLjC49vX3dzaT9jtKh3HsrWW+pB0NZ
         /2r6PRnQUvbDQaPZHnarOll9PHAzQhjX/yhidh3MXsW1a3Yqe5Qlz2J7Y4qz6vby9Xbh
         /bAnj+9HqL8+jNs97eiMZRJLpthQXNwQrrDdnBbf0P/oOZJRUSq/ocUzhCqNLQnGL9eL
         T/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741097688; x=1741702488;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P5l2R6iUh6JQQNif8SJbj7EwSVWvxpPGSGu0suY4qtA=;
        b=WAeCVywyMfaveSpyRosHlJLsv1YOzUtZ9q6Xub5p/0zOUe/JFCijPe/AbHRx+8blaV
         PjhMA/XLDydjNk2qQWP0mfWSxrUVB+KjHHWs+/mqflrXre9/PXKnHpOGGqtQDMaxZysQ
         eAL0dbeAsWaZOR/1SZUcLNQ6DbzkK4pY0E6+OgNCzhBX+m0vs/ZhhfYMWP+4gslRM3gD
         Da5J1luXIruIziwCoxM+SlkjBzdUwPLQYv6elsuxPJI7p7ZN7C4diyJXBnl54qSXmwS8
         ukyHiMkfGmcXtESiRjlkfXLQKo/hQFTlaka9TheEm3/rJdBg6co+LXZ6x5RQ5wQZeEgq
         Qn1w==
X-Forwarded-Encrypted: i=1; AJvYcCXT+1y+fSXe03AwPWiFeQra1LkCijXGNq+lS+fLXVypxaR5Rnj8pudTyyUiLbiJMUFWFco=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcvmzf03AYHCei6AgJQAF3WzqOS3ymkkwCW3qDEdc04kiByPNi
	HeL5hv89fXlH3kJqRLuAUdSggPTpUbCzFTASVFeOOMRefzFr/Vh/5o223v5GCsY=
X-Gm-Gg: ASbGncsq2tqfBoK5RnLqvhgC18fNnO26UYVd/aaiitXN1W+fb6Gz1VIJWH5eB5/3NcN
	pNtgg3kPcACOLfgsPZ5ONzJxu4bS+HWK2LhB6coy5zBDekbCmK1I28RdZBVrv+CmwF/Tk52ssGQ
	FLXQB3kiFVGjidgfITrIl1StBSWSlUvamlHHmhfIpliOJ+nYGxQYDnLCXF5hT+dmXn5k0EhGet2
	FMu1VNwCd6as/3iaY90P2BjC2BqE0h1A4Fyuqi2CXRX0DGsysEss1VNZrk1MzTDjDKTk2CUU6yy
	teY21+PST1RMnf3hTIITfCHBzzVJY5vQdl+LLhvMEt/eMpFkd8m6rdnXtsAAR9MViUo5yEYRLYV
	kyIuFZ7laIyetPJZ4DA==
X-Google-Smtp-Source: AGHT+IHAijVgZIvuG3Mmw5/e25haZvsnd9blawxKL03iQ7Rih/OP9LzbPftPTxU6t1xcj3zZe1e/Rw==
X-Received: by 2002:a05:620a:1a9e:b0:7c0:c5b8:e3bb with SMTP id af79cd13be357-7c39c4af6e5mr2166272385a.19.1741097688249;
        Tue, 04 Mar 2025 06:14:48 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c3d657a95fsm16381885a.17.2025.03.04.06.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 06:14:47 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tpT2l-0000000172s-0kT4;
	Tue, 04 Mar 2025 10:14:47 -0400
Date: Tue, 4 Mar 2025 10:14:47 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Wathsala Vithanage <wathsala.vithanage@arm.com>
Cc: linux-kernel@vger.kernel.org, nd@arm.com,
	Alex Williamson <alex.williamson@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	"open list:VFIO DRIVER" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Message-ID: <20250304141447.GY5011@ziepe.ca>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221224638.1836909-1-wathsala.vithanage@arm.com>

On Fri, Feb 21, 2025 at 10:46:33PM +0000, Wathsala Vithanage wrote:
> Linux v6.13 introduced the PCIe TLP Processing Hints (TPH) feature for
> direct cache injection. As described in the relevant patch set [1],
> direct cache injection in supported hardware allows optimal platform
> resource utilization for specific requests on the PCIe bus. This feature
> is currently available only for kernel device drivers. However,
> user space applications, especially those whose performance is sensitive
> to the latency of inbound writes as seen by a CPU core, may benefit from
> using this information (E.g., DPDK cache stashing RFC [2] or an HPC
> application running in a VM).
> 
> This patch enables configuring of TPH from the user space via
> VFIO_DEVICE_FEATURE IOCLT. It provides an interface to user space
> drivers and VMMs to enable/disable the TPH feature on PCIe devices and
> set steering tags in MSI-X or steering-tag table entries using
> VFIO_DEVICE_FEATURE_SET flag or read steering tags from the kernel using
> VFIO_DEVICE_FEATURE_GET to operate in device-specific mode.

What level of protection do we expect to have here? Is it OK for
userspace to make up any old tag value or is there some security
concern with that?

Jason

