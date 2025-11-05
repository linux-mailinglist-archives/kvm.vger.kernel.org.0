Return-Path: <kvm+bounces-62090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DB954C37150
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 18:29:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 93DBE4F74FC
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 17:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85A8225D6;
	Wed,  5 Nov 2025 17:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="fBUZmXyf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADCF2C15B0
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 17:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762362952; cv=none; b=nMVImAwhMgoFhheC2GY3n8+GgKOm0UFW3fv6zZ2nWM4pA62JtyPC6hCNjh188ffgtUUb91iVW0u//jyr50wKh0xbee7bjRdUaylhpcvT2H+x/uZ16xmpkTG7EINOHUXtYLZiL4faxhv0KRy5Cx3MW309v4W7towdUw5A0ih929g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762362952; c=relaxed/simple;
	bh=eVKD3bsjyZ0uo5KJ9oROutwHux5K45xSldhubqIwOuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pNhRatR/lmachdHH/krXw1Rj5Lv0T7sv1lCShvpwManknLGR6iR7e6QhQe065ZlL0KqkyOYMrEjptAPQSiNhiaRdJorvX+1aPfQSoM3VpUsKB0Z2UQN1PFIiEAo5wIMOXZ04SCz0R4tV8EbNY+wL8Yre8JAd+zCSphCF1kQGGjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=fBUZmXyf; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8802b66c811so1435526d6.1
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 09:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1762362950; x=1762967750; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=waenEKCMjn97yqJgR3j8p8YSw3a8sLLocbZT7haat5A=;
        b=fBUZmXyfecAmBE4EaSf7lOvc4JxFDSMxcSK6xyOcwofdwMQFA6DJ0rUmGqP+jAcFXZ
         ePGPzzSvttGBkBNk701xIQSiLotElDnYnuTSwb7SpKcOnbhTuPpfbJ+l3k3sPNIkvJqI
         DImS9qbxwcysAZJVbSU9nLREyiNZiIi/eVkQkKrEJHAKsT1Mb7XHX6L0eEgCKtGcoRca
         PFHMr7ZGixym5pQJSF776hGVIV9PBKiOh2sHLiLkHZu63VZoMIzYrCG05KiILPTmBeAb
         QuwUqDTIvI59hHkP4v3/ao1Vt09QRsnp9xKsivRtAhu0Rm6Qe+Y0rR90RZpvrt+FdDkm
         3gUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762362950; x=1762967750;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=waenEKCMjn97yqJgR3j8p8YSw3a8sLLocbZT7haat5A=;
        b=ekQP3rTlXauPOlfoldhT/zaP4IvQ8iD9sy8kGHjYW20z99oVf57fqiGMrWns5+2BOo
         SOrkOTM5gx45w7B6rsqd7OcZ+nmG2TPyC0gwqEqN0lpL4Fm1U11Co2dnpgkcM7OShp9i
         5hrBhp5bvpMLOprKbovBJzBki4KJXkUYcSDT3d3DeacwtxhtIZm1+gDIsmV5ZzwALOtD
         nw+nw7L7JOzNTGclId/U3sWRD8tOPxKm3ebRSc2rj8JOvqR54O9d6TYCQnlg9cIyiPmM
         09EAz0KrqdwMzFSQVje9FCo24wH8mtk5VU1NIwVLvHI2aw8p4RqaooULAgSxIVkIBKG3
         4yIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzosHTEyDt2kK0caU7S1HnDu3KqP1+LZItlqCkakQmxAuyo8/SMEDa80SNhuovQD11GJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWcipgaYJJaEHjFF1hFtTHiMo1CE5MTVHT8XpH6XbPUI53qpW4
	gmG9l/bmHpCETOcc1jO3BmL0K6KRI3Yjhd6FRLkzKPbCxX50FWNsXEff28aqp2EvHW4=
X-Gm-Gg: ASbGncssnQNqh9pwks6LCRjbLbN3Bjywxp+ECxbCBtHWtLfbFNeAiepQrUs3AZEKXsd
	iis4KY24ZDyXJcnO8sxNmuFlseZ29XD9pLrILtR8fd8kpjibhQCmzq1cwixwpeg5C1AXWYtnLQc
	DSO+a6wQ00v4Mjukbmq7HSsP7WBFRcVXC1ecgy1Mz+FkKJKsVVnDexTCoBQvfk1JsTGKtWhIl34
	Cp7fQylnigroy1n80mGvFiN6gnXbNkTcKKS7vhoYlrP7KOf4EATbsngpLM9UM/ZumnAsuIwZf10
	539RsQidf92qVum1JJLdGcA7oclkcc9Pgi0GP031n8h1kR9HflJLmTuFZ+r9e3ckaOoZFUfZ/KY
	LRUS9tl88DScMETGJa3WHECFBUowIp2GIe1jKR1+/6GnIk3m4qoGK/eD2sfYoB4CHArS8RlBvOI
	j5eKumwH2OZo21BqmteXPxXij3jQQLcpeDh11mcChgDfEMLg==
X-Google-Smtp-Source: AGHT+IHujecuHKAp19SOjD1ziznvYD8tAwFGOLS3T8YEf0KUSZ8DObLM9JfUqnSghUiTTZ/sscfDOQ==
X-Received: by 2002:a05:6214:2262:b0:880:4690:3bb8 with SMTP id 6a1803df08f44-880710ba284mr52063816d6.18.1762362949784;
        Wed, 05 Nov 2025 09:15:49 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88082a3ac4fsm551996d6.57.2025.11.05.09.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 09:15:49 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vGh6p-00000007BtB-1oaJ;
	Wed, 05 Nov 2025 13:15:47 -0400
Date: Wed, 5 Nov 2025 13:15:47 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	dri-devel@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukasz Laguna <lukasz.laguna@intel.com>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 27/28] drm/intel/pciids: Add match with VFIO override
Message-ID: <20251105171547.GP1204670@ziepe.ca>
References: <20251030203135.337696-1-michal.winiarski@intel.com>
 <20251030203135.337696-28-michal.winiarski@intel.com>
 <cj3ohepcobrqmam5upr5nc6jbvb6wuhkv4akw2lm5g3rms7foo@4snkr5sui32w>
 <xewec63623hktutmcnmrvuuq4wsmd5nvih5ptm7ovdlcjcgii2@lruzhh5raltm>
 <3y2rsj2r27htdisspmulaoufy74w3rs7eramz4fezwcs6j5xuh@jzjrjasasryz>
 <20251104192714.GK1204670@ziepe.ca>
 <r5c2d7zcz2xemyo4mlwpzwhiix7vysznp335dqzhx3zumafrs4@62tmcvj4ccao>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <r5c2d7zcz2xemyo4mlwpzwhiix7vysznp335dqzhx3zumafrs4@62tmcvj4ccao>

On Wed, Nov 05, 2025 at 04:20:33PM +0100, Michał Winiarski wrote:
> On Tue, Nov 04, 2025 at 03:27:14PM -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 04, 2025 at 11:41:53AM -0600, Lucas De Marchi wrote:
> > 
> > > > > > +#define INTEL_VGA_VFIO_DEVICE(_id, _info) { \
> > > > > > +	PCI_DEVICE(PCI_VENDOR_ID_INTEL, (_id)), \
> > > > > > +	.class = PCI_BASE_CLASS_DISPLAY << 16, .class_mask = 0xff << 16, \
> > > > > > +	.driver_data = (kernel_ulong_t)(_info), \
> > > > > > +	.override_only = PCI_ID_F_VFIO_DRIVER_OVERRIDE, \
> > > > > 
> > > > > why do we need this and can't use PCI_DRIVER_OVERRIDE_DEVICE_VFIO()
> > > > > directly? Note that there are GPUs that wouldn't match the display class
> > > > > above.
> > > > > 
> > > > > 	edb660ad79ff ("drm/intel/pciids: Add match on vendor/id only")
> > > > > 	5e0de2dfbc1b ("drm/xe/cri: Add CRI platform definition")
> > > > > 
> > > > > Lucas De Marchi
> > > > > 
> > > > 
> > > > I'll define it on xe-vfio-pci side and use
> > > 
> > > but no matter where it's defined, why do you need it to match on the
> > > class? The vid/devid should be sufficient.
> > 
> > +1
> > 
> > Jason
> 
> I don't need to match on class.
> 
> With PCI_DRIVER_OVERRIDE_DEVICE_VFIO it just becomes:
> #define INTEL_PCI_VFIO_DEVICE(_id) { \
> 	PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, (_id)) \
> }
> 
> static const struct pci_device_id xe_vfio_pci_table[] = {
> 	INTEL_PTL_IDS(INTEL_PCI_VFIO_DEVICE),
> 	INTEL_WCL_IDS(INTEL_PCI_VFIO_DEVICE),
> 	INTEL_BMG_IDS(INTEL_PCI_VFIO_DEVICE),
> 	{}
> };
> 
> So, no matching on class, but I still do need a helper macro.

Yes, that looks right to me.

Jason

