Return-Path: <kvm+bounces-71902-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +PGTHaiIn2nLcgQAu9opvQ
	(envelope-from <kvm+bounces-71902-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:41:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DCE019EEB4
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:41:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7003D30713F1
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 23:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F7BD38553A;
	Wed, 25 Feb 2026 23:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ic4P6Fkf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77702C21F1
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 23:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772062871; cv=none; b=etuoGvkV0fq/lbJnrIdoS3kGRUJPUrYvBK+H+YBMdhkB9uesN2iiUe4HxUFs1/RkFeWfDI7VjAo6mOGz+AWjKuxgWNdkM5TmditqK3l+q/TOY/XPSGqb1g33tDyNAkU54LrDl1UxIGYUZXtSl0DIK71gSucWvl12gCwniNQYsuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772062871; c=relaxed/simple;
	bh=bKI2pGpfY+ZCgdQUPM1XvD0dVj7imv1jMLjUvrJ34gY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rn/owKxLCjSV1R5SDXL0aF/N+Rwpj0MhvRYrkHlw8zNjX6cGFOFjWIC5RheSeeBqEolxbwnZ4BLuPTZZRtBnqPKDI4qHfmxqf6RApLjFgQ1w7tYpI6cjssB8lz28UU4HFjgaQgLOxyZsMIffwsdFYA+5EygCKPIHWEN1CxlJU2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ic4P6Fkf; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a9296b3926so1838285ad.1
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 15:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772062870; x=1772667670; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/CK8Xw2Z8/jwhJKdKy0esOogFCKRH5zkiTBeIKoVGlM=;
        b=Ic4P6Fkf/OXgNQ7BDlUnM2oIkuJMigxtpE353Q9PHMHUy8KOdfb/1AhXq8PqsRxaSa
         m6syzRvsuaI1TgkDNs2grnAoEIj7bWPlrj4VWShTXl7iDrARPiMPoSqkpGqHNQED7SJq
         sjDbCi10DOaC+SHAoHd9Q4nCSS8RWBjp9qw6oz5NoO6dSD4QNeh2TJHWLpYw0ODvYnTn
         v+8wV7PBBRjogrV24GXaeu7V/xKAw+w/ubVwn7sNdvaxR1vkIGn3FaUkv9a/jCqto8SF
         Gpe4rhG8F06u8QkjdUIFYrSI6mk1aDROt2IVSF511yCdy54NqgTXDMOVGZ7X+hVAhKvE
         Tf1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772062870; x=1772667670;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/CK8Xw2Z8/jwhJKdKy0esOogFCKRH5zkiTBeIKoVGlM=;
        b=J3sSvO/iKaYtTR4PMsoq49Qg1/twqOJCQjSla65HXAZBkNUADR4/weTvuf6OeKvpBY
         LXhbLFF7xc4/KSG7VQdcnz4k1r8AaN1m75WGgbPktmkmPvr47wOF707S2dE99s9l6BPl
         e3jLxPqy5FrjGfh9vz9lVTUvzAJoo4CihES9dD8m6pG6M2HYZmQZen2FlM5YAT6tYNt7
         6RAWix/BGTP63ZiIwM76P+/dzWh359ygbtEXEyiL+jZ3XL3buJa7ofqezSC1uNAS6q0m
         XbZlC383WH6m1yOvCqIawGTXEiKpajywR/x8FaMXhel+2/HHjkZyXWbt3+jIz7251t3S
         v3iw==
X-Forwarded-Encrypted: i=1; AJvYcCUk/KQYheSi2pEZgIip9QR5QaZbpna3zts31S53Mi6T5+caaxYIuAzCc9opI7teDmWkuK8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3zWlzPzY17zfNG6BygJF6Q5DZbf5NPmpwwjMjyKlZw19dt/NN
	6yRt3/Ypg3BBXyBOmC+qvmtD4LxKyOCmOIH/GAmY4AVnxGMSnYLASrqNQVOz8+eGeg==
X-Gm-Gg: ATEYQzxYkQ8gac3UPJleMYTVHRvZ0UdYuKsFQaXD1IRoBjiu8erhzjwRAeMcAYV9ijY
	J42V88PopC0li5cUXJieuckWnZlZtystVqje6nrLnqWemFcQDYL7ZITQEBLOz1vI5Z+yk/G/HYV
	RiR+F/WugXdTPH7PZGkBNUfgxloxtD3hl7SEZWPQ1d7jBTOMJJ7o4h6MExFJxmoEaiclmAG1NZW
	nWKsXjBsXK07ywH/4MtJ1zqtLoetpQ9gY5lRypBqKeSIr58OBJ2ZjC9UZkk4mJofWCcSNFJffke
	Oio5UUX4bOe3c4vhljih1NPorojTsydbiZSYxAlN8dG/QTjVC6j8zTvHdbEKWlNUBnoDEa3mJ+l
	mhkfvPZI4Gs9NL28u/UetRwhb2Xjvl7HW7OaP53ALrj2PoG6rrlgytkmgHIhi2ffsD0nKpyogRt
	qmndI+7Ozq/1jyusvogrDTLojRK1W70HnWvL3OovzknCftSYcUq9LxHCPvI7FXGg==
X-Received: by 2002:a17:902:cccf:b0:2a1:e19:ff0 with SMTP id d9443c01a7336-2ae035d235dmr1928845ad.39.1772062869584;
        Wed, 25 Feb 2026 15:41:09 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6b5813sm3778175ad.63.2026.02.25.15.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:41:08 -0800 (PST)
Date: Wed, 25 Feb 2026 23:41:04 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
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
Subject: Re: [PATCH v2 05/22] vfio/pci: Preserve vfio-pci device files across
 Live Update
Message-ID: <aZ-IkNFOLJUff1hC@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-6-dmatlack@google.com>
 <20260225154124.78e18fa4@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225154124.78e18fa4@shazbot.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-71902-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
X-Rspamd-Queue-Id: 0DCE019EEB4
X-Rspamd-Action: no action

On 2026-02-25 03:41 PM, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:52 +0000 David Matlack <dmatlack@google.com> wrote:

> >  static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
> >  					     struct file *file)
> >  {
> > -	return false;
> > +	struct vfio_device_file *df = to_vfio_device_file(file);
> > +
> > +	if (!df)
> > +		return false;
> > +
> > +	/* Live Update support is limited to cdev files. */
> > +	if (df->group)
> > +		return false;
> > +
> > +	return df->device->ops == &vfio_pci_ops;
> >  }
> 
> Why can't we use vfio_device_cdev_opened() here and avoid all the new
> exposure in public headers?

I thought I explored using vfio_device_cdev_opened() but I can't
remember now why I went with df->group. Maybe there wasn't a good
reason. I'll switch to vfio_device_cdev_opened() in the next version.

> >  
> >  static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
> >  {
> > -	return -EOPNOTSUPP;
> > +	struct vfio_device *device = vfio_device_from_file(args->file);
> > +	struct vfio_pci_core_device_ser *ser;
> > +	struct vfio_pci_core_device *vdev;
> > +	struct pci_dev *pdev;
> > +
> > +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> > +	pdev = vdev->pdev;
> > +
> > +	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
> > +		return -EINVAL;
> > +
> > +	if (vfio_pci_is_intel_display(pdev))
> > +		return -EINVAL;
> 
> Some comments describing what's missing, if these are TODO or DONTCARE
> would be useful.

Will do.

> > +static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
> > +{
> > +	struct vfio_device *device = vfio_device_from_file(args->file);
> > +	struct vfio_pci_core_device *vdev;
> > +	struct pci_dev *pdev;
> > +	int ret;
> > +
> > +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> > +	pdev = vdev->pdev;
> > +
> > +	guard(mutex)(&device->dev_set->lock);
> > +
> > +	/*
> > +	 * Userspace must disable interrupts on the device prior to freeze so
> > +	 * that the device does not send any interrupts until new interrupt
> > +	 * handlers have been established by the next kernel.
> > +	 */
> > +	if (vdev->irq_type != VFIO_PCI_NUM_IRQS) {
> > +		pci_err(pdev, "Freeze failed! Interrupts are still enabled.\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	pci_dev_lock(pdev);
> 
> device_lock() is a dangerous source of deadlocks, for instance how can
> we know the freeze isn't occurring with an outstanding driver unbind?

I can change this to a try-lock and return an error if taking the lock
fails. The freeze() callbacks are triggered by liveupdate_reboot() which
is called from kernel_kexec(). So returning an error to userspace is
possible.

My only concern is whether using try-lock would make kexec flaky, or if
it would only fail if userspace is misbehavior (e.g. unbinding drivers
while kexecing).

> > -static struct vfio_device *vfio_device_from_file(struct file *file)
> > -{
> > -	struct vfio_device_file *df = file->private_data;
> > -
> > -	if (file->f_op != &vfio_device_fops)
> > -		return NULL;
> > -	return df->device;
> > -}
> > +EXPORT_SYMBOL_GPL(vfio_device_fops);
> 
> Seems we just need to export vfio_device_from_file().  Thanks,

Will do.

