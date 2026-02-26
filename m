Return-Path: <kvm+bounces-72107-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wA/RCR7XoGl0nQQAu9opvQ
	(envelope-from <kvm+bounces-72107-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:28:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 85D171B0E85
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:28:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 89B293087D27
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:27:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0191D32D0F3;
	Thu, 26 Feb 2026 23:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L0okHgCK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59F7329E76
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 23:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772148475; cv=none; b=ZBzc0hteluKWKw8P+EACdYzK+AWaRB5L2ESyHEM9koRHndXBn/asdyTt8u6n+5uwY2pYOYsQA8oihnJoPaD1jzJyZ/j7Gm0ITDH5n0LeM4SnjdgfXJjIPWDhl2MMNNK8FMLeyQ06AuI5XfNPwrSlvbieiqH7Pi08ywZG3lzCjVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772148475; c=relaxed/simple;
	bh=nN5n0R1KzYPR6gq9Cg8JAJtOp8uZMPH9g3XcUNvBoaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRTEn3d1KkrJCL3pMAYk+hxwpIdnAEJV9p7W+PBKnicZ9esGQ3c1rW/UmUSKZOpgl6l8twZ8zBfYmrFBUWnyF2xZUDsR+lX0KC/aekvJsZedZa0tdujUkHQ/EHgUkFCN177+lrcWbi3owHXysH+VoEPQXfDtEnlNqq485fkoTJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L0okHgCK; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82746ed8cb1so477491b3a.3
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772148473; x=1772753273; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uUrZ9rZ9RlW3x07tCEk7xJ4J4Vz88lZHdKC8XE8Cxsc=;
        b=L0okHgCKUCabiytMNGvBYbMHtStuJdWKE2K4KnP9ytxhmY6s0/WuKJ0p350vQwt7ST
         LimILWhdrT5WLAE4aI25ZKfBq5r+pWEhUow4F6q0Gd4UgpwN/DVmLYp0Yc9vSfiH+OYe
         SahG+vqwdwcCgjjdPrWhoRfiOBsXEOAC/LXrtxgCBLe4TKrdA98/qmBSk5fae0QtMv9N
         ioFWcgtDBYOtn7zY0thjx3jvRvB6yGGmTZuTEZOcxwM2UAdglKK/z/P+rUHQ/TACpelb
         NWgeUMP4s4dqn0WVpOE3wo/ZF5XCvqxfUcGLoJtOvpBOKm2uQSnItmcCggqofWrWX2um
         Owug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772148473; x=1772753273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uUrZ9rZ9RlW3x07tCEk7xJ4J4Vz88lZHdKC8XE8Cxsc=;
        b=Sdb1fN9b0grZiTI0b8I5SlkaREPtoIJwoZPgGTpcRWR4xfu4xMgjbGZkFqh3M5EUpn
         S8aLcQPWBUAUk/Rnf+F48rfAv0VKzQVoGPJjk1dzYyWoK2ZWvn+59IwVKmwEoi1Ogmuh
         3DQ1K5XNZBWnEPNkrw2mAFrr46/xe7REe8KBSHOswv1ik8rzefNE7UQlsOsA/V6mOLRr
         8xyqB+Ap23N+FaRFlezk/MFi0Y8zCty5zlD1xlnsd4yJctiLyfVTk8hVKTO/GGkTUJiA
         8kMF9Xo5+KxxHuiM5j6V/vhS/DdAU5DM7mTzyRPotLyzXH8KBy5+d1wiR6+GH7ogcsZy
         50ig==
X-Forwarded-Encrypted: i=1; AJvYcCX9Jyw4Bi/YKel5ixST5/UfRJVEQBDZwIyN+uSRMe/hNlNY3L3m02rU33Mhe3iuYksOnC8=@vger.kernel.org
X-Gm-Message-State: AOJu0YypmwN027TPvjF6Tq0iRb9eSbglj4MORipKQoJBklxqa9LEs14x
	F8nkRCcKIPx3KsujYfmTcUGJyFLv20nUn3uYqimAKagcDoAkeMSoXsZySdmh/gXzLw==
X-Gm-Gg: ATEYQzw2krmvd/UV37zMt+43/XHJAJkH6xDjbqsB46EXYJUsi8wjR/DF9Vd9Ir2h/NF
	MdpZ0gPc/gbjGf4hGFwl8FVgyPpaVGAqVEmjK+Bi4Z6iqxoQdWH3jwYyvcGEWRbILPfe64Qw9eO
	G1+53O7+zHrsxmlN/I8yc57F7aR0Vd7PZHReE8RrxOS7VhpRevuelooKMOpRXTvFOO/OLaKM65X
	MtX3vkTVK97e0xUV7aWuBC4GILtJwGWNX4pUC8SOWcnjN5XlK5NCcNiVbu2yDpQlCG2Pzt61YBr
	BpLeHLEnOKvWmRJ7UlzJAzKtZoTq9HFgJ7/4ROab+zbViM0tQR0fzMI9d+Ug4YtrMPTHV2f7m+p
	0OUZu0QdBBOZFFjMuZR4bKBAZUbo/OzzIx1BN20A2crcAZVajspnIKZQvxAcsYXJ8mj0Yk3c7GJ
	V972fv6S9Q3N4N8e9dYnIizMJEvqfPUBnu1jAj/cLBnVLg9D34P8Evx2zvhTlHWckyQes39epW
X-Received: by 2002:a05:6a20:1585:b0:38b:e9eb:b12b with SMTP id adf61e73a8af0-395c3ae6d18mr701611637.41.1772148472659;
        Thu, 26 Feb 2026 15:27:52 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6a03fbsm48080705ad.43.2026.02.26.15.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 15:27:51 -0800 (PST)
Date: Thu, 26 Feb 2026 23:27:47 +0000
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
Subject: Re: [PATCH v2 08/22] vfio: Enforce preserved devices are retrieved
 via LIVEUPDATE_SESSION_RETRIEVE_FD
Message-ID: <aaDW86eWuQLZ3cfP@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-9-dmatlack@google.com>
 <20260226161512.532609ec@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226161512.532609ec@shazbot.org>
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
	TAGGED_FROM(0.00)[bounces-72107-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 85D171B0E85
X-Rspamd-Action: no action

On 2026-02-26 04:15 PM, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:55 +0000 David Matlack <dmatlack@google.com> wrote:

> > +	/*
> > +	 * This device was preserved across a Live Update. Accessing it via
> > +	 * VFIO_GROUP_GET_DEVICE_FD is not allowed.
> > +	 */
> > +	if (vfio_liveupdate_incoming_is_preserved(device)) {
> > +		vfio_device_put_registration(device);
> > +		return -EBUSY;
> 
> Is this an EPERM issue then?

I was thinking EBUSY in the sense that the device is only temporarily
inaccesible through this interface due it being in a preserved state as
part of a Live Update. Once the preserved device file is retreived and
closed, the device can be accessed again through
VFIO_GROUP_GET_DEVICE_FD.

EPERM might lead to confusion that there is a filesystem permission
issue?

> > +#ifdef CONFIG_LIVEUPDATE
> > +static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
> > +{
> > +	struct device *d = device->dev;
> > +
> > +	if (dev_is_pci(d))
> > +		return to_pci_dev(d)->liveupdate_incoming;
> > +
> > +	return false;
> > +}
> > +#else
> > +static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
> > +{
> > +	return false;
> > +}
> > +#endif
> 
> Why does this need to be in the public header versus
> drivers/vfio/vfio.h?

No good reason. I'll make it private.

