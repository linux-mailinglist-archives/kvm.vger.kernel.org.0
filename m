Return-Path: <kvm+bounces-60756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F6E7BF941E
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:38:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1C7914E9E01
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15AD12C11FE;
	Tue, 21 Oct 2025 23:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="NDlvo7Cv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655B326CE0F
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 23:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761089896; cv=none; b=pqoq8aOrHdAUKOqy5KGqKoqbdKTGy8+kBxWoC21LCVxr37YduigLn+CtlAueXyBaSwqRDmCkg3/fj/KCsJVlBjmYqk8+xoOcYliam6fqMvoZyjiZdS7z2QfJRMjO4Cu4fpim/7Aph9BBRJ97eAcW6dsCjmmy3kNaUI1ogFzekaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761089896; c=relaxed/simple;
	bh=V+u2TYehBCwVH8vLJaq4e/OoHFBT+xogbeFOuIIuxAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KfKBG32yoDPAh6z/XwvYbmXd0luZePEs8C9h5F3FM4yhz4gBfUahwp7QDVZFqTizrctOLnSrHOouRW/pF5an2TOQ7UDNjWdOl+l+MVHNXZGlnZXbHMuES+cA+fo+aBZed2Xjk0TlZIU7bwWPHyosy/nzkOCahPXJTrXtC+7viGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=NDlvo7Cv; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-893c373500cso46152485a.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761089893; x=1761694693; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l0T6gaWR8wRqUaz48FqGAKEBOYEGIQ3pcXRlgXnhgn0=;
        b=NDlvo7CvjiZpIxPgybTZ2QAfqVZRpFbU7W2AjJ+S3EAlu7EZ2lwrt+5ai9lOo7DTac
         C/jTjGr20OGptUxkLt0IHS8Fw54acZwPnp5Ea0KSLjEOYPaJsqf4BYqj+XpX+ul0igAr
         /hNeBpVapL1Rf/AODWncFNO+gcifUvyZ8yTZehRNPllevDkrpis+NcGMpo2+AWVEOJ+8
         XH1EdbTQ+nfhyduLpnZyfnBjB82906JSRPynA1IqgFrBgFKa9HfzR7jRykPCMBFGnPOM
         8G2BGyPf2wE6F8sHqDfDJBD5cRoS+2AeLNJv4jC+xZ2ZZURVr471+xmBlGeMEEpQKkJs
         gHoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761089893; x=1761694693;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l0T6gaWR8wRqUaz48FqGAKEBOYEGIQ3pcXRlgXnhgn0=;
        b=kpBxMoiH0xHlULnvPwRiy3yLNDELpOa8RCUXsBHvjh6ddxX/s2F9o7mlw4EHJqZhFZ
         4+BlyqgOR9bXIvAwmw+FYGrvNRtQeFofZgRMJoXxcoHEAr3ZR8+d4OH32+Cp8pkm9812
         pK3BEEUrJa1q30jRxSGSyVVX67aQHBEjKGM+q/B/yrfrD2QDUK3S+lsL2ibgF3Yy/KSO
         E5/pMN1NBb+CqizAZldBKcT7UDW4JnTHz7JJ4hPHJgP0uu8uBsMA3r5kboiiJzzxvRYO
         yOWM7oJhcG0icmnPVCrN7CLxdX5H1/w5IowHDL5Hiw/B1j6laPvx2Oy6PhPx1IXYKxEC
         PZkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtHBDVAWKwnlDsm4C019i3aTCXPudz/cR9jaIfWVC9tZUooxUlzK2h9tpfFpros+9ZTIM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw73qX0UCLhuFfq94tEBIxI7VFLrj2dU3pGKFJjoc+utg2vesE1
	+Vx+rVmJy+Ch2wkBfPSSl51fZLXjn2o2Hck8aCrZKznDTbmKW0l7BLbTTwLR8mzP0go=
X-Gm-Gg: ASbGncswAaDZ8z29yI2aw63KeQXgZU1GpPezEJDDjbwwE8ZzUa5aZ0FUhg3IV/x48DN
	2OSmvwO1nY/59wYQ9olWAQAGXU2m3/bGaM9WI13svN7UMYYyf7gumVCYsQWFrLyCTlFxC/wFope
	ezQn1gpgOvZpQxApBeI2Xce0Gw4LxOxxywK7HBb0VuErEHEymI3Xb8ud/Yaffcs9k/aGK85gn7C
	jdTdjr4GwnOYhBkZi6XiZQe5VIKu692UwoLtn8LhFFVb8inhaZAhrjQPsbQ3YdrQqx0aqEJwMdq
	x4TwcB2Sks7HdL1sXhuMyof4a55EGIvzkPNumnEslUH1UQV+jWgMqYDd9zLyBfgiZ17kQj7iv6r
	GJP/d7Nr13CBHSIeV4I2X/Bsl+Q+2koEU2UcDkICpAQPpxueZmepzdeEzX0sMDh+VKIo4U8W2aG
	NUlhJuoK6j2wPR7SMRXc6VkUmWit6pRQM9sLSafe34Wsgngw==
X-Google-Smtp-Source: AGHT+IESZxgXwvIqIMj9dzYjccElH5tAxo9dER4LfWd2lD11GISceznOVY3S2mBydzghuiBWXmdJvQ==
X-Received: by 2002:a05:620a:700c:b0:892:a71a:bff with SMTP id af79cd13be357-899ea1350d1mr183689785a.44.1761089893141;
        Tue, 21 Oct 2025 16:38:13 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8ab0c8c1csm83229571cf.20.2025.10.21.16.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:38:12 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vBLvf-00000000cBo-0n5B;
	Tue, 21 Oct 2025 20:38:11 -0300
Date: Tue, 21 Oct 2025 20:38:11 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Matthew Brost <matthew.brost@intel.com>
Cc: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukasz Laguna <lukasz.laguna@intel.com>
Subject: Re: [PATCH 26/26] vfio/xe: Add vendor-specific vfio_pci driver for
 Intel graphics
Message-ID: <20251021233811.GB21554@ziepe.ca>
References: <20251011193847.1836454-1-michal.winiarski@intel.com>
 <20251011193847.1836454-27-michal.winiarski@intel.com>
 <20251021230328.GA21554@ziepe.ca>
 <aPgT1u1YO3C3YozC@lstrano-desk.jf.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aPgT1u1YO3C3YozC@lstrano-desk.jf.intel.com>

On Tue, Oct 21, 2025 at 04:14:30PM -0700, Matthew Brost wrote:
> On Tue, Oct 21, 2025 at 08:03:28PM -0300, Jason Gunthorpe wrote:
> > On Sat, Oct 11, 2025 at 09:38:47PM +0200, Michał Winiarski wrote:
> > > +	/*
> > > +	 * "STOP" handling is reused for "RUNNING_P2P", as the device doesn't have the capability to
> > > +	 * selectively block p2p DMA transfers.
> > > +	 * The device is not processing new workload requests when the VF is stopped, and both
> > > +	 * memory and MMIO communication channels are transferred to destination (where processing
> > > +	 * will be resumed).
> > > +	 */
> > > +	if ((cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_STOP) ||
> > > +	    (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
> > > +		ret = xe_sriov_vfio_stop(xe_vdev->pf, xe_vdev->vfid);
> > 
> > This comment is not right, RUNNING_P2P means the device can still
> > receive P2P activity on it's BAR. Eg a GPU will still allow read/write
> > to its framebuffer.
> > 
> > But it is not initiating any new transactions.
> > 
> > > +static void xe_vfio_pci_migration_init(struct vfio_device *core_vdev)
> > > +{
> > > +	struct xe_vfio_pci_core_device *xe_vdev =
> > > +		container_of(core_vdev, struct xe_vfio_pci_core_device, core_device.vdev);
> > > +	struct pci_dev *pdev = to_pci_dev(core_vdev->dev);
> > > +
> > > +	if (!xe_sriov_vfio_migration_supported(pdev->physfn))
> > > +		return;
> > > +
> > > +	/* vfid starts from 1 for xe */
> > > +	xe_vdev->vfid = pci_iov_vf_id(pdev) + 1;
> > > +	xe_vdev->pf = pdev->physfn;
> > 
> > No, this has to use pci_iov_get_pf_drvdata, and this driver should
> > never have a naked pf pointer flowing around.
> > 
> > The entire exported interface is wrongly formed:
> > 
> > +bool xe_sriov_vfio_migration_supported(struct pci_dev *pdev);
> > +int xe_sriov_vfio_wait_flr_done(struct pci_dev *pdev, unsigned int vfid);
> > +int xe_sriov_vfio_stop(struct pci_dev *pdev, unsigned int vfid);
> > +int xe_sriov_vfio_run(struct pci_dev *pdev, unsigned int vfid);
> > +int xe_sriov_vfio_stop_copy_enter(struct pci_dev *pdev, unsigned int vfid);
> > 
> > None of these should be taking in a naked pci_dev, it should all work
> > on whatever type the drvdata is.
> 
> This seems entirely backwards. Why would the Xe module export its driver
> structure to the VFIO module? 

Because that is how we designed this to work. You've completely
ignored the safety protocols built into this method.

> That opens up potential vectors for abuse—for example, the VFIO
> module accessing internal Xe device structures.

It does not, just use an opaque struct type.

> much cleaner to keep interfaces between modules as opaque / generic
> as possible.

Nope, don't do that. They should be limited and locked down. Passing
random pci_devs into these API is going to be bad.

Jason

