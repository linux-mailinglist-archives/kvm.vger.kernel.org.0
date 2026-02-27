Return-Path: <kvm+bounces-72118-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kAxlA5PqoGkBoAQAu9opvQ
	(envelope-from <kvm+bounces-72118-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 01:51:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD4491B151F
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 01:51:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 93FD4304E7E3
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942F3286425;
	Fri, 27 Feb 2026 00:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KV+yYfL3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C6413B5AE
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 00:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772153485; cv=none; b=kMw9cqwG+2jcd84xk6JcZeZBXa9u1gdMjs+5iedM4zJwKrjMi7ZbRYG5SWVVd1MsE3NZ/RvpDhFHqMuZd4bao7GpBD1397GMn920OZ/fBCv9c5P9iFJvoY+u9EKSsat2CjWWbPrkRlYRmRPbAcf3md7FvqUFDFqDxuvOlcOCAh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772153485; c=relaxed/simple;
	bh=RyZXx/G7qCicaZId45D0cNgeQ8TX0mKD9axtH69slQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bCjqzEd+OsgD0WfYe0Ybyi+mFgYGwXV2SVHpRS2s1anLKO95XTPmZcjrskSS3ZdUH4NfImsd7N+HjI8tRO1FLmLxNfUe8tTtCfh1qzQ10ciN5IworFTvpcpjjDv7Vi3eSleCzMQHwKu+4E9gu/6oFh2Gbq5vPS8MlCVmBiv8sSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KV+yYfL3; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ab39b111b9so7325405ad.1
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772153484; x=1772758284; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MbrSIpDE3Y8TNhyTW+6lYUs18ku3UAynLvTznEtk/Vk=;
        b=KV+yYfL3RSTVSGk8zPgiMYi1QxoJ4iyFJaBlfRxKrxMv2CCbZKiRK/6BH23MWBqsZS
         rF+F0m+o/yWe1FkKbp7TFSVIO6HG6elJYI6oXqrqx3juZ51qFzIswmQIAB4zgwZbKaEN
         /9B5wVem+oXu9Clr+wFdvqzS+s9aMNZ7XOy+5u0PMl9GXMvX4YwZxxzWRpxce/ygotv5
         GHKd+TfodlrNdiOKX9RhHGqNHFTr3CIKkYcd3SXTE9Yrv3Sgp4YKcoGDY+1/A9oXu3wi
         aZ2AtafAcT3gU2/tugcMopjO6eJgXysOzMHswmwzfqhzXh1LPwCtbxmZmWF0LTT1NQaF
         vqXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772153484; x=1772758284;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MbrSIpDE3Y8TNhyTW+6lYUs18ku3UAynLvTznEtk/Vk=;
        b=NS93NO9VmPm1BL8tEYfNU+6Fnc2evNA+5N3c2teoYal9iSab3HnKnj5vQkdbxvKAsx
         9wZ6NXGDBw7KqXbBkue+u1CSXHypW3jDNLbSUGef6CHc1U/8NyK9HnFfA5lIm3L/2EaS
         Y6rBLJ6N0w2eBCaRxVtlOO1CXF20yiDkN86V19HuEfZoGbA6c+bmnnZk5IwL1+K62Wnu
         7QvwtT2+OORlcw243pm2cx/5hgpXo8We0mUIf58QQuJD383kZp0E5gSx16KhwxGvyqJI
         CtV+coX6T1qgpXFHo8idZipBPvNDSYnFaOnAdMVhBIJe7xP+qOZxPUI8RxZKfgAqLzA9
         3V0w==
X-Forwarded-Encrypted: i=1; AJvYcCU88MkB6wBmpVeGvPS5QFE59Uzio7HnRlFVHwuF/z2vJVJfhgyQWEoqAdZS8U7sXu7g1So=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxagp2iQisMppeS2wdi16A0wjpTV9okSw5RJB1GoRs8zafDKLud
	h1UThlua5GRHbTw0eq8kPt+MlzhQB2a9P/E8/5e54sKGieJSTuqp3ZvkTNySPfjFyA==
X-Gm-Gg: ATEYQzyH2OyuQ7TRefNf4DaMjfFr3dvogV3Pp4trkTzFsJV+BsNJxQjTeUtxEhB9CI8
	KcGEBGcefTOvvRbSMpVNtS/v1v85l75J7TsyHt07TslcIyajptpOevVUSMSRrnU1RwHM4fSqig2
	9ponYeeAxpF9EoK4ECUTrg6ilFSULRQ7xvPWkbiFPbhkGuQGZWD5y+zFxraCl5nGBKOHdyi9ROW
	eJB+pwuMlgOMx6Kitnc9+n7a6RBF2PVyuutB5A9IMc+ud6ycWuAMrajKxi6wiFqyAgyVuQ6Xskz
	LVpn/fC0c/yDSiexur8vCJUYho2R9wL9zQqL2JtKVku2lm0/yFZ0P7PuDUWqobmmAjP1UnbivfY
	k5siGBcqtn1b897a1Jw5esxSxHB+WlxyCidsWQJGSqAb/ibL7V9Z9ZikD35EPEokTLNwzGbOLXs
	HHVOqZ3cFI4/rH8Sh4yR1OS0mS3aWCn9hKOWFL4oLeFApl1aqLJh4wmRRCOd0h1g==
X-Received: by 2002:a17:903:41cb:b0:2ad:ba04:40ca with SMTP id d9443c01a7336-2ae2e419430mr8325415ad.25.1772153483265;
        Thu, 26 Feb 2026 16:51:23 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6b974csm34254135ad.65.2026.02.26.16.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 16:51:22 -0800 (PST)
Date: Fri, 27 Feb 2026 00:51:18 +0000
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
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <aaDqhjdLyf1qSTSh@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-11-dmatlack@google.com>
 <20260226170030.5a938c74@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226170030.5a938c74@shazbot.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-72118-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BD4491B151F
X-Rspamd-Action: no action

On 2026-02-26 05:00 PM, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:57 +0000
> David Matlack <dmatlack@google.com> wrote:

> > -	/* If reset fails because of the device lock, fail this path entirely */
> > -	ret = pci_try_reset_function(pdev);
> > -	if (ret == -EAGAIN)
> > -		goto out_disable_device;
> > +	if (vdev->liveupdate_incoming_state) {
> > +		/*
> > +		 * This device was preserved by the previous kernel across a
> > +		 * Live Update, so it does not need to be reset.
> > +		 */
> > +		vdev->reset_works = vdev->liveupdate_incoming_state->reset_works;
> > +	} else {
> > +		/*
> > +		 * If reset fails because of the device lock, fail this path
> > +		 * entirely.
> > +		 */
> > +		ret = pci_try_reset_function(pdev);
> > +		if (ret == -EAGAIN)
> > +			goto out_disable_device;
> > +
> > +		vdev->reset_works = !ret;
> > +	}
> 
> This could maybe be incrementally cleaner in a
> int vfio_pci_core_probe_reset(struct vfio_pci_core_device *vdev)
> helper.

Will do.

> >  
> > -	vdev->reset_works = !ret;
> >  	pci_save_state(pdev);
> >  	vdev->pci_saved_state = pci_store_saved_state(pdev);
> 
> Isn't this a problem too?  In the first kernel we store the initial,
> post reset state of the device, now we're storing some arbitrary state.
> This is the state we're restore when the device is closed.

The previous kernel resets the device and restores it back to its
post reset state in vfio_pci_liveupdate_freeze() before handing off
control to the next kernel. So my intention here is that VFIO will
receive the device in that state, allowing it to call
pci_store_saved_state() here to capture the post reset state of the
device again.

Eventually we want to drop the reset in vfio_pci_liveupdate_freeze() and
preserve vdev->pci_saved_state across the Live Update. But I was hoping
to add that in a follow up series to avoid this one getting too long.

> > diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> > index 350c30f84a13..95835298e29e 100644
> > --- a/include/linux/vfio_pci_core.h
> > +++ b/include/linux/vfio_pci_core.h
> > @@ -16,6 +16,7 @@
> >  #include <linux/types.h>
> >  #include <linux/uuid.h>
> >  #include <linux/notifier.h>
> > +#include <linux/kho/abi/vfio_pci.h>
> >  
> >  #ifndef VFIO_PCI_CORE_H
> >  #define VFIO_PCI_CORE_H
> 
> Wouldn't a forward declaration do, and the kho/abi include can be kept
> out of the public header?  Also should be in the previous patch?

Will do.

