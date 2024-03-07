Return-Path: <kvm+bounces-11328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D5E9187582E
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 21:22:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD3DEB27174
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 20:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B9D139586;
	Thu,  7 Mar 2024 20:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CGau/35N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB99F1386AF
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 20:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709842896; cv=none; b=MnNthaS8SjYEDUnL9m6f3F1N7WTsBdlRI7WMau02FO/UfoiP2VXuOH73lLD1X6qc1fo0IWRxGlBvS29plo8bSL2gLmCvJAgl0K8QNZiMBs/ytKeBM0Q9Fi7+JyoJMXX+0HuPmoW3J5m+Xqxn1GP4NAcqXasNcwaPWzOL6CHR1m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709842896; c=relaxed/simple;
	bh=qkAuaeGOA+K/jn50xyZamYK85gjUO7jxoiUIRTBCyro=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ipt/hW7eNXExFgDs9IG208xCVDcKteqx4kA0/UGFV3w0lXXsdhTL0VsRCnVs4fL74eoj+2N0qbvao5KlwleB3DrLu61sSxaXEO2i2xEsjhEeDaVN+4CYps8K5PVEmdGBqYTPvqJ2GYcrDNFCMntjP59zfG8hhD+56EPpFyBRNOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CGau/35N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709842893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TabbR6fhpYCD09TE4BJb10XCjbbbQlcJP70V/fpmxt8=;
	b=CGau/35NpYFx0tNPkjqsXIfxjYC+mMoyzkJ4PNWqavAiW7mmGNJBCycF/5ihkgT4xNHE1Z
	nOaEuTdwzVTl2c3zpfASn94wdrIFaSUEnfPlS5DIlPttw6gfsOZ8whIzMNjn3//n/3lJrq
	g4PY3KkD/sUMeBQlNkE/tPD8RpDAdaA=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-SmkMahyJNKOdbskO_42vIw-1; Thu, 07 Mar 2024 15:21:32 -0500
X-MC-Unique: SmkMahyJNKOdbskO_42vIw-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-363c88eff5aso10075685ab.1
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 12:21:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709842891; x=1710447691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TabbR6fhpYCD09TE4BJb10XCjbbbQlcJP70V/fpmxt8=;
        b=r27Vd1NnbP+ujE1VhVxZlg+YQd5ALiG3tjxoPsbJPLGpf2EBhEiWvzGml5tXMzkE5f
         zvitpuHgQBlZVShJUo2HhjYQWPPdFJ6lfyo5wKsyGQrRbrOwZe6jQEKv5VwMbn0COMkP
         9H47mDVySzRv9JFkpv9wABmDUPJxPy+Dz4I3ysStSNnMSJ78taAn/vku7svcB4tYlfHl
         L5NObvdEctpPx3sl3fwjI7OOKba9hLWkSU+AaBZvlqt3OhM+fPXMiB/p1itfV/SRqVpn
         w2C9aYF3bTGW0Om8YtgIiMgYqInOaYXp7egWwTT2RKjNcFlkWTSrOHcA0F5TZyxUxTed
         LJXQ==
X-Gm-Message-State: AOJu0Ywix2l/5ey5ZrD5BsAH4xQqniaBHj9HhBmKK5EQw8F8a9UA5N7b
	QTtK5AdxoTn5mDy5eqnxVqgZZZZ8HeXsKLF3wrVfCffSHpwgg53VAvqeekIuw7Tc3rEE2jmoGzM
	KJmqkmsyBqEy/mYP3n/ZcP1SnGu2HQ0XOgDNE47Uw29+ycf6W0Q==
X-Received: by 2002:a05:6e02:1645:b0:365:2f3f:846 with SMTP id v5-20020a056e02164500b003652f3f0846mr24255069ilu.23.1709842891275;
        Thu, 07 Mar 2024 12:21:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE50enID048wjvbDz9xqfEa+NeCDjE9VDwD/TjlF+C4uQc2/Dhn/c7varbQGAEJDxLImxwNIA==
X-Received: by 2002:a05:6e02:1645:b0:365:2f3f:846 with SMTP id v5-20020a056e02164500b003652f3f0846mr24255048ilu.23.1709842891027;
        Thu, 07 Mar 2024 12:21:31 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id i2-20020a056e02054200b00363a4b2a0ccsm4370000ils.7.2024.03.07.12.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 12:21:30 -0800 (PST)
Date: Thu, 7 Mar 2024 13:21:29 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
 <eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] vfio/pci: Lock external INTx masking ops
Message-ID: <20240307132129.0585a4aa.alex.williamson@redhat.com>
In-Reply-To: <BL1PR11MB52713E13EB82604A2599616A8C202@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
	<20240306211445.1856768-3-alex.williamson@redhat.com>
	<BL1PR11MB52713E13EB82604A2599616A8C202@BL1PR11MB5271.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 7 Mar 2024 08:37:53 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, March 7, 2024 5:15 AM
> > 
> > Mask operations through config space changes to DisINTx may race INTx
> > configuration changes via ioctl.  Create wrappers that add locking for
> > paths outside of the core interrupt code.
> > 
> > In particular, irq_type is updated holding igate, therefore testing
> > is_intx() requires holding igate.  For example clearing DisINTx from
> > config space can otherwise race changes of the interrupt configuration.
> >   
> 
> Looks the suspend path still checks irq_type w/o holding igate:
> 
> 	vdev->pm_intx_masked = ((vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX) &&
> 				 vfio_pci_intx_mask(vdev));
> 
> Is it with assumption that no change of configuration is possible at
> that point?

Yes, I believe this is relatively safe because userspace is frozen at
this point.  That's not however to claim that irq_type is absolutely
used consistently after this series.  I just didn't see the other
violations rise to the same level as the fixes in this series and
wanted to avoid the distraction.  I've stashed a number of patches that
I'd eventually like to post as follow-ups to this series.  Thanks,

Alex


