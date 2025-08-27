Return-Path: <kvm+bounces-55926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6685CB389EF
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 20:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 311E5165724
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842C42F1FE7;
	Wed, 27 Aug 2025 18:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aUTN97vw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD1E2E5B11
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 18:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756320965; cv=none; b=GMV83wmqmSblPBlYMl8Im7fFi5kwJSBXyi77PuOSIuSJOA7fP8IQ4G7dNPIABS7ZLE8epp2yVPNjsAdA5xGVcI09DrHNUmDHSr8mdA4c/BlgnMzNPE2e93aNHTNHJdE5XZ0sQRz1pmHJDIJq+mWC+qZdofajnEePRdKHFSkw5+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756320965; c=relaxed/simple;
	bh=8ok7WAgHWHzIb67w4OKsGxYVKHOMk/whxVn9yr022jA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CfyB20aOLJQTSgcuOCnN6MGs+Eg4hLLSPgBdmxpZMgGpXzEnrcBT28muzFVT3nVhVy/JHFl2OmtWuRU1XJTKdU2Fl8Z4R7tTcfxHJHMuLNpli9BZhTpms+GYsk1odKjTkyTeU0pb0cCijGM99e8x3wh35yISDyMdJVY2VrEiVxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aUTN97vw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756320962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LaJTrQIELffdqMUepm7rFcVjoX613nWdx1blyGA6qhk=;
	b=aUTN97vwL9BL4hxJI34Ko0hvlxejVXgi994aWCHyygpp4Xm8lkb41ajbaUk0uP0s8+Npad
	gt4HcoV9srBB+n2YYyIq37hHkUO8H7qROCn0ebWZZ7yonY7aPEQPn13PtQ1iscpzSQsSkI
	qbxx3Vb8slFve9kDZECrWw99sNEGsrI=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-mwDki3eSPXqlWkQL_FKKPQ-1; Wed, 27 Aug 2025 14:56:01 -0400
X-MC-Unique: mwDki3eSPXqlWkQL_FKKPQ-1
X-Mimecast-MFC-AGG-ID: mwDki3eSPXqlWkQL_FKKPQ_1756320961
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ee5c3c9938so298855ab.2
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 11:56:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756320960; x=1756925760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LaJTrQIELffdqMUepm7rFcVjoX613nWdx1blyGA6qhk=;
        b=OdgQ2IDXc9lfTUZDtX220Mgt/rbLKvu5OvlVxzoSkcuV7dRgWKCiBWilEusZw4kgAR
         k8ODfPuX2sOJetBAeKayrHQP5vTkeGwMrhRcNoFk01lfGKE/1r+tVALW+3HmSYMCqIPG
         D8/2mgULyeRDSgtixiHFSg79ZAlAASqmRMS4oU+gFK1iywkSdx0F3HZCgX6XPaI945mF
         3XM2JCYeaSP2zAMgBC/lRgLA5Y4yw2VDmizzc0T1tY09YIkzGyq5m2fbK6q8B/qPOlqa
         pWafLcipNkuXpq0pBF8WjVXH0lQk0ffyMqe04Gadu1YVG1qHlD9qvMPRGIjiyX3dh3Em
         OQMw==
X-Forwarded-Encrypted: i=1; AJvYcCVvzP9y5MRS4Zvkco2D3Tzi+iVweVU+XiROmK7lsPy6hqU2Tsw11y/T4g7NY6y9qHOzh3U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVPZwSsXjEFNacl5jEihbftHR0R3+3AmTo/yj9ZWze1OzfnXt1
	A0CeerBUAZjPvihXigJkXV0BGt9SmYgPYoL+Ui/juRRe2xnMb84ufq2C6Xs0jkmxtO/NuWj2tT4
	EnC6dvp/Jfnj4xkhdMd5NzqahAp1CuZzvZq+30OdEKrEGid6yRwywlOnYZcL/vQ==
X-Gm-Gg: ASbGnct0ObcczEnyhfCbYDDyaxS922pfgTk2KTRXixDukHXdxYFJFp3war9jaKW/A0f
	zrhDw/uo347kBzXIYb2cv+iLEAqiYJeC66eWB6ooM2Ex2latzfgiibRkQxFrCwG3w4AYyjci9or
	XbvGEMHhCDSfkTxw5ZiWeGsWOKfyTibFS1mWpLqYKTk3PYFlcAifEKz348UETR2dZAWar33IEdg
	dIbG2s4Bp/+6DbmVB5YD4jKcWGzPJY69AflgqdFN8UxYNtFzRbTsSiTZAd+0v8eN9iD7W/LuEF/
	s15YHC1yKCYGyuAJEJvYjDlkfFgbNEqLLZGYCVc0pNY=
X-Received: by 2002:a05:6e02:1c0b:b0:3ec:173e:8b6c with SMTP id e9e14a558f8ab-3ec173e8e6emr65344355ab.4.1756320960268;
        Wed, 27 Aug 2025 11:56:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPb2pJYAkguncuQSx6IZaNOZrvdB1Zk3MUKrevEct/LLAhqT63GRfQVhKzRAZJNEzz7BkGLQ==
X-Received: by 2002:a05:6e02:1c0b:b0:3ec:173e:8b6c with SMTP id e9e14a558f8ab-3ec173e8e6emr65344105ab.4.1756320959727;
        Wed, 27 Aug 2025 11:55:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3f0a3a1ae9esm10463375ab.3.2025.08.27.11.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:55:59 -0700 (PDT)
Date: Wed, 27 Aug 2025 12:55:57 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: "Gupta, Nipun" <Nipun.Gupta@amd.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>, "gregkh@linuxfoundation.org"
 <gregkh@linuxfoundation.org>, "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "llvm@lists.linux.dev"
 <llvm@lists.linux.dev>, "oe-kbuild-all@lists.linux.dev"
 <oe-kbuild-all@lists.linux.dev>, "robin.murphy@arm.com"
 <robin.murphy@arm.com>, "krzk@kernel.org" <krzk@kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "maz@kernel.org"
 <maz@kernel.org>, "linux@weissschuh.net" <linux@weissschuh.net>,
 "chenqiuji666@gmail.com" <chenqiuji666@gmail.com>, "peterz@infradead.org"
 <peterz@infradead.org>, "robh@kernel.org" <robh@kernel.org>, "Gangurde,
 Abhijit" <abhijit.gangurde@amd.com>, "nathan@kernel.org"
 <nathan@kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v4 2/2] vfio/cdx: update driver to build without
 CONFIG_GENERIC_MSI_IRQ
Message-ID: <20250827125557.6340d8d3.alex.williamson@redhat.com>
In-Reply-To: <CH3PR12MB91935A30AE6BFFA18A5D4B32E838A@CH3PR12MB9193.namprd12.prod.outlook.com>
References: <20250826043852.2206008-1-nipun.gupta@amd.com>
	<20250826043852.2206008-2-nipun.gupta@amd.com>
	<20250826102416.68ed8fc6.alex.williamson@redhat.com>
	<CH3PR12MB91935A30AE6BFFA18A5D4B32E838A@CH3PR12MB9193.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 27 Aug 2025 11:04:12 +0000
"Gupta, Nipun" <Nipun.Gupta@amd.com> wrote:

> [AMD Official Use Only - AMD Internal Distribution Only]
> 
> > -----Original Message-----
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, August 26, 2025 9:54 PM
> > To: Gupta, Nipun <Nipun.Gupta@amd.com>
> > Cc: arnd@arndb.de; gregkh@linuxfoundation.org; Agarwal, Nikhil
> > <nikhil.agarwal@amd.com>; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > llvm@lists.linux.dev; oe-kbuild-all@lists.linux.dev; robin.murphy@arm.com;
> > krzk@kernel.org; tglx@linutronix.de; maz@kernel.org; linux@weissschuh.net;
> > chenqiuji666@gmail.com; peterz@infradead.org; robh@kernel.org; Gangurde,
> > Abhijit <abhijit.gangurde@amd.com>; nathan@kernel.org; kernel test robot
> > <lkp@intel.com>
> > Subject: Re: [PATCH v4 2/2] vfio/cdx: update driver to build without
> > CONFIG_GENERIC_MSI_IRQ
> >
> > On Tue, 26 Aug 2025 10:08:52 +0530
> > Nipun Gupta <nipun.gupta@amd.com> wrote:
> >  
> > > Define dummy MSI related APIs in VFIO CDX driver to build the
> > > driver without enabling CONFIG_GENERIC_MSI_IRQ flag.
> > >
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Closes: https://lore.kernel.org/oe-kbuild-all/202508070308.opy5dIFX-  
> > lkp@intel.com/  
> > > Reviewed-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
> > > Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> > > Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> > > ---
> > >
> > > Changes v1->v2:
> > > - fix linking intr.c file in Makefile
> > > Changes v2->v3:
> > > - return error from vfio_cdx_set_irqs_ioctl() when CONFIG_GENERIC_MSI_IRQ
> > >   is disabled
> > > Changes v3->v4:
> > > - changed the return value to -EINVAL from -ENODEV  
> >
> > What are your intentions for merging this series, char-misc or vfio?  
> 
> Yes please, this can be taken via vfio.

Series applied to vfio next branch for v6.18.  Thanks,

Alex


