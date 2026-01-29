Return-Path: <kvm+bounces-69636-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AKEnNxvhe2lyJAIAu9opvQ
	(envelope-from <kvm+bounces-69636-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:37:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FABEB56CE
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC5293057487
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB0836B042;
	Thu, 29 Jan 2026 22:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ByDLftJw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC2836683F
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 22:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769726002; cv=none; b=X3ZVE25xng/qP/zNvzUnzrki7C0r+xZgTtq1KvrhWFEwsbUXQGGdhR1XWtGyYh4cfl+pgDs5MsTsEKagpZhgKQL2PH8qGASFX1qFMAHWrv88ABLkRjqZ1EdL4ETopTQv3gq+7j3Va/uRhr/L1IMbP836rTsgv+a5+EqnPPiPdkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769726002; c=relaxed/simple;
	bh=v63/Q89R1FZp3eIace6yEluQWPmCvUnvUR/7uDkLuXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ASTEl6m6ZuRswvv195LtduE8dsoKKpWkjsyVRKjON50bjkcsrRqK603h5NzrgGBNVsxUeqzMUVU5RRbNtX52BIR5y1sWhoBmH8vsALmwVYY9VTFiXLzLt6oFPOMgvGVJgtdBkaCQdMIAs0sQ/aWrX3CDbwAgdZU/YKcycSy32IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ByDLftJw; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-81f47610542so876054b3a.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 14:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769726000; x=1770330800; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dBZ3PFz9KqTT7KdM5e4cMtXwD446xZIZixlzxugjwak=;
        b=ByDLftJwm+ggKAtpqCU9sPZffMWsEUrPGlXYxLmcxXvEW2byFmmvqfi2d01fyEQEMb
         MwhFVh3cp4Y5o0bKokJMPdnGLYqEXcrActt5hjA6Zte2xnVh0jf/E3MPQ2Z6fRih8t1m
         lxR4LUyDfzoBoC5OH0lWEf6RuUHQpGHPtiHoOiZpgaWlOfdFQZ3hiJoXZ0VsorP7VNwt
         zbXj9JvDROjUvSKfSMLwr9R0sIDSR1JipmmZRm5xbVwZnNbvyQYg9vZt4NRHkezN3bEs
         qm9OC7jqRQeTcAdtpZgNSTOUzwAwWzJgmACaT4toFUT5eFZrRiThC4MtKcUDKYWSt7we
         VK/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769726000; x=1770330800;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dBZ3PFz9KqTT7KdM5e4cMtXwD446xZIZixlzxugjwak=;
        b=D2g9IPQOgvbUnnTRfdWU5VQzRONcotMSjflce7rionMVi45pUYzBC+bM+fzlHw7zEk
         4RkKtQszBl1VIJu5+7XxGnCqHRSZcEOnPktgQCzQboYMQ8WExUwRsy4aQisejhD0+kWJ
         WsU1H68rvKuu7Wfa3fmN+FQ8lStP9Wxm3JKttn3HcMup16l3IeDk8Il87368jqpeUK6m
         VGXLaBCPfqNlZyi6HXuYwHV6sWruXnKFnqa7ie1p/Y39lQzfvK/0t7up5DYZDO2w2dAw
         POwnLasjxq+cDAk+F3TMTmsnJcO+9BgE5FoIAtr8rQPuV0hrVxVZ4Lo27MhTLxSzSsGu
         oE6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXnt7GxV5pu+8uQD0qcD+hZQtdfm+bKiBHaNW2fCnBvyHCWJvsGnu9vwsI/vxM+fudAQjQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf2iWD6Ti37DS+PipZPJGr5jLv5D89ar0hZPcvifYThigovEwH
	M+vZvSeXLIdI+gRUsV18i85kDG2DTV4JyxxRfhtEda4V5xldj9WZE6Hs+7q9JSA/5Q==
X-Gm-Gg: AZuq6aLWij/eWQInoeYvvCpxYU+/pLy+yqiwRwsEyd8SJ7/vh+3cngaXrbwwI2oFF2K
	myWTPkA3PbiFPil1wbhED8oDT1SxHPMQNsin5pWJWhM3fWCnHcdaeUGP6xxr5r7yUChwApcbE09
	+mlYC4e0k4nyW8+v+jUylccjErO/6vepn2rImagCcL4F0sTv94M0d2zXsn9eKnlMkXrXiMV+7kh
	8/TawCm11lfQBXe06Vh6xlTnKDvc9+LuB+aNTxBQzwjynKUXMZes0yLCi4X6iFWaS2nW+v+A/gM
	b29KoQ2xelUrLQ2J3WqUN0tH3C66efyFHTBYg3qlshuC08XbAv4T3OC2LRGerHffTIoraesiQVe
	s1NaWMIt6mH8znRiJwWx7lLcIyhltvtSvPSVK6/DF1CmY9Ea8Y/8XvwRL0snxX9XpX0dc3noT0L
	NN2Do5jWEWvPn4wQ1D4P9qmC6Z4OSQBCfIiY94i3iDcbspBvY0Yg==
X-Received: by 2002:a05:6a00:1f0d:b0:81f:5ec1:8bcd with SMTP id d2e1a72fcca58-823ab684bffmr621422b3a.20.1769726000049;
        Thu, 29 Jan 2026 14:33:20 -0800 (PST)
Received: from google.com (79.217.168.34.bc.googleusercontent.com. [34.168.217.79])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379bfd797sm6165100b3a.43.2026.01.29.14.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 14:33:17 -0800 (PST)
Date: Thu, 29 Jan 2026 22:33:13 +0000
From: David Matlack <dmatlack@google.com>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <aXvgKRrbfymW5NKb@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-11-dmatlack@google.com>
 <20260129142158.00004cdc@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260129142158.00004cdc@linux.microsoft.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-69636-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7FABEB56CE
X-Rspamd-Action: no action

On 2026-01-29 02:21 PM, Jacob Pan wrote:
> On Thu, 29 Jan 2026 21:24:57 +0000 David Matlack <dmatlack@google.com> wrote:

> > diff --git a/drivers/vfio/pci/vfio_pci_core.c
> > b/drivers/vfio/pci/vfio_pci_core.c index b01b94d81e28..c9f73f597797
> > 100644 --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -515,12 +515,24 @@ int vfio_pci_core_enable(struct
> > vfio_pci_core_device *vdev) if (ret)
> >  		goto out_power;
> >  
> > -	/* If reset fails because of the device lock, fail this path
> > entirely */
> > -	ret = pci_try_reset_function(pdev);
> > -	if (ret == -EAGAIN)
> > -		goto out_disable_device;
> > +	if (vdev->liveupdate_incoming_state) {
> > +		/*
> > +		 * This device was preserved by the previous kernel
> > across a
> > +		 * Live Update, so it does not need to be reset.
> > +		 */
> > +		vdev->reset_works =
> > vdev->liveupdate_incoming_state->reset_works;
>
> Just wondering what happened to skipping the bus master clearing. I
> understand this version does not preserve the device itself yet; I’m
> just curious whether there were specific difficulties that led to
> dropping the earlier patch which skipped clearing bus master.

Hi Jacob,

There's several places where bus master gets cleared that we need to
eventually eliminate to fully preserve the device.

 1. vfio_pci_liveupdate_freeze() clears it during shutdown when it
    restores vdev->pci_saved_state.
 2. pci_device_shutdown() clears it during shutdown.
 3. vfio_pci_core_enable() clears it when the preserved device file
    is bound to an iommufd after the Live Update (in
    vfio_pci_core_enable()).

I think it would be safe to skip (3) in this series, since that's very
similar to how this series skips resets during vfio_pci_core_enable()
for preserved devices.

But I don't think it would be safe to skip (1) or (2) until the attached
iommufd is fully preserved.

If you are just asking about (3) then I agree it could be skipped and I
can include that in the next version.

