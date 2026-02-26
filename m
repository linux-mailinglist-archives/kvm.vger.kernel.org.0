Return-Path: <kvm+bounces-72108-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iMYaDxHYoGl0nQQAu9opvQ
	(envelope-from <kvm+bounces-72108-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:32:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A941B0EE1
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:32:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 42A89307E868
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45985330D32;
	Thu, 26 Feb 2026 23:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fdeHi2ng"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E163161B1
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 23:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772148710; cv=none; b=BtXKGhoGOkI9ATL6WoOk4xRfN84mwZfRcD7Nsq/dkfTmE1Kej6XLSxhZKHmu3BLQRD4Oe+OqSElwTbVHHZPM8vpYzSDdkp3CANQdjUjSueIVHzj0LyZLZe3iB8R7yt0nDo82Yf5WHodKIzS8DSfMY23Fak+H+r0Ke5fcodiz6Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772148710; c=relaxed/simple;
	bh=AAF7fByBTFvHIdoynRYlkawoyRHswdrvQIY2msLKBYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h3M5Iv9P6jDG6QyjUHDCPo/wYDe5L/VRLDakRokk9A/pENIxjX7NJHsGgTCxxS+0Lzcf09Hy0Vt/rjJYtXp/gvnZKqbEXet6AbKgn93TlRpmLDfTvFOp/ggzC6hSrTQMVAya7T3MurTDKOEI2PZcVqi7UmyZNwZTUiHNr5e9ex8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fdeHi2ng; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ad9f2ee29aso8851625ad.1
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772148708; x=1772753508; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UQ19nP7LWyVtbwlYCJ4KZaeb2FLacueUWULaQoURJXE=;
        b=fdeHi2ngbLtudCw29sk0ANC/rvY74LDswMpIo85pe4L3DkXLDhoUtfu8d+zS8xmVaE
         oRn+nKfDrOM3MM2ecdwfWBeSB6fMIevw/Q7E9Fx8bMXF87+Z9BT6bi+VFc7uxKsao7kU
         lXcbvqou7XO441ypiWEiPy/vA9UUU8lnXEaFDQUAXIxAkRUl0MaNOrr5/c0A8HAezZVi
         G+lFe5WWH9dSPNva19h3f5d1xpGnEy2QvV/3sUK1b5Wteov/d1Kw8QfEz45XEjcFv/64
         Is6AsNwWAXfLHYr/rVy4zp5U0hvwu2bk6MxXt2B9lIaPCfGz7PeJ+dzb1npIRYp9tSrU
         6q7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772148708; x=1772753508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UQ19nP7LWyVtbwlYCJ4KZaeb2FLacueUWULaQoURJXE=;
        b=M4gfFDwUq4K20cTAPsTTGIaZ9XRRz8wWC07WcXcZOhFoRO4ytCE5gOeNsjL7LZ9Y7I
         kyf1Ow4JBUEUTO1QcVVygp62Kp2eix1ycpGY4+9j7A5uHgL/rWAJ+pwaQaOAEFO7pV5G
         qYu521sm2vikO5R2Sx3v9agMCziIPoiGuUrG7fRJ+a+DGuMS6p6yqPSakuEZDqyZENdG
         vSWSsiMmPNICGHb9QDdGYtfPEEPsoLz0OkwBxF4NrXTVbNhum9tt1PmCaVLqYhNGLDvb
         GDXarwR2bMOJZ/X4CqgcN6YDCB/pUDVBVnY1gDUCtmGZnsEauolnwvY+/5GBK7M4mwWZ
         KWDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKT8O7YiCYs2J2emXe912Lf+WQEJ3tUZH++3AMHEHECaZuPMNiF158woXTnMfcjTeI2u8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbgG21cXt9InEPBhxmta6nSpr9sFT8eLiJZKBlEJd83uWAkGxW
	R8/k2edoD2B9gY+zblrT0ofr5DKQdfvChnt15e2d5ra4PINOjHXh+BmC2IYZCIkYsg==
X-Gm-Gg: ATEYQzwliDIR/qEvN/1VxwlsO4g1f4rzyXQIxsWfKTCQaqaEIe1J3n8qXVfSgIJQuq9
	qVlPnHHNYHbkKulEPn70DDLWJtGWWD5/Vo5U2ZoOdovxOyN/EaE7xhhjh1k6KOZgjak9lRN2sik
	PdFuJYy9Yby2xQsAopRd5V4uxw1gy43wZkTet0qPFT6nRYqmNRWk4lgEZbCVHCaDIuPrlkkBrub
	DGUF5bekzt5PAitT7w/O6l2HKmtW0vcXKn0lotgAop0mIhO5gMVDSaARB1fVpq3WnyziTFVQDIZ
	DmR6Dakpt8PAZgYKGqg6u+TWJTdZDOvhHMzsdfa1XjQiuWYpsw/RAP2L68UEO+iFtp5YSwB9K/r
	5bF0KH8LE4rOB5V2epajVNb3Ax6TrT2weB+J2mdJw2AkL2fiYiRiPigkC2Zxfa6rykAFbx4cnbB
	CfVXQ1dv3J9NaOe4X5dzBugH0mp73UvURcVCc65q25FFn5JIALXtl5rls12aLnYw==
X-Received: by 2002:a17:902:dacb:b0:2a7:919c:34c6 with SMTP id d9443c01a7336-2ae2e4cd74bmr5371545ad.38.1772148707814;
        Thu, 26 Feb 2026 15:31:47 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6a0432sm53850525ad.52.2026.02.26.15.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 15:31:46 -0800 (PST)
Date: Thu, 26 Feb 2026 23:31:43 +0000
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
Subject: Re: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
Message-ID: <aaDX34yT_3dwUi4I@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-8-dmatlack@google.com>
 <20260226160353.6f3371bc@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226160353.6f3371bc@shazbot.org>
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
	TAGGED_FROM(0.00)[bounces-72108-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: C1A941B0EE1
X-Rspamd-Action: no action

On 2026-02-26 04:03 PM, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:54 +0000 David Matlack <dmatlack@google.com> wrote:

> > diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> > index 7f4117181fd0..ad915352303f 100644
> > --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> > +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> > @@ -53,6 +53,8 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
> >  	if (IS_ERR(ser))
> >  		return PTR_ERR(ser);
> >  
> > +	pci_liveupdate_outgoing_preserve(pdev);
> 
> Why do we get to ignore the return value here?

Ugh, we do not. This is a bug, thanks for catching.

> > @@ -203,5 +225,6 @@ void vfio_pci_liveupdate_cleanup(void)
> >  	if (!liveupdate_enabled())
> >  		return;
> >  
> > +	WARN_ON_ONCE(pci_liveupdate_unregister_fh(&vfio_pci_liveupdate_fh));
> 
> This is propagation of a poor API choice in liveupdate, the unregister
> should return void, it shouldn't be allowed to fail, IMO.  Thanks,

Ack. I'll make pci_liveupdate_unregister_fh() unable to fail and follow
up with the maintainers of LUO about liveupdate_unregister_flb().

