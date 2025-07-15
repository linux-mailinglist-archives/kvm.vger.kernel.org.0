Return-Path: <kvm+bounces-52531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF23FB06624
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 20:42:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 301C01898FBD
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 18:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADEF22BE635;
	Tue, 15 Jul 2025 18:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XmU2ZhNn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1487242D9B
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 18:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752604955; cv=none; b=LeoH6F6cvVUtnvWFuVz18SKHYulsko/jk7T8xQI8RJjv1t7GcbzvHiZPKvBHb0kW1QcVduS0e5lefnZU7J97lVSZisGLXg8w68qRupH2EIG4bo3T+F0WPRTHy9ZtLvIu5Sd0qLdlbVmbHtUDOBlNoXPz2KJNHj1BzGt1ulVDdAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752604955; c=relaxed/simple;
	bh=s5ZR8Cnl70aU3op1u1952EDYPeq92Rsw7PQKDi50J6w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=npgAQSHfRgd5WdSKoqupMtaVPaBCNZvAHjqc/2CCAH/msgfgid+kTAtFt8E/FXQUn9HxbymJcYOcXjbMCSvI+s42zLgCuSXVgG7K1LUeGckSbJ7+75/TAGgzRTkWRw+HtVhUyf+KFS18u3kc55DNMQf0lVJi2QUV5SgjARRiFPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XmU2ZhNn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752604952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FHWKVcj3+I/wvWqZ4ODBBP3h54lJrQD+89h8230/I98=;
	b=XmU2ZhNnAMsHgnMUI1FzYI2oJfPsU91ENR6ccxhdW4p9SXgpPQtR30DCe9iNOmNP/rDX/q
	ZTti8uXmyG/OaT8zQ0FTQbD5PilXvcbAmOQdCgmiK1V8G8GPQStUMrzX8IB0JG0Q+aFgOj
	cRUOpStl26q5usq4xxjsIDtl9skt5uE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-CWFhg2BaPcqvj6r8SPlbMw-1; Tue, 15 Jul 2025 14:42:31 -0400
X-MC-Unique: CWFhg2BaPcqvj6r8SPlbMw-1
X-Mimecast-MFC-AGG-ID: CWFhg2BaPcqvj6r8SPlbMw_1752604947
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-86cf14fd106so102687739f.2
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 11:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752604947; x=1753209747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FHWKVcj3+I/wvWqZ4ODBBP3h54lJrQD+89h8230/I98=;
        b=wiLZaqtqE/4K9YgPqPRZ58OhBJVGb+jSF4/18PVmWt/TSbbKv89ijE8gBZWJ9sxAeK
         kAcSBtS1qYpiwFKyiwc9vbqq9JScCilufvhf4P5k9f3KrnGNgxVkQSZ5zGeqtzXAwGhe
         xACVkP7a7XnCmL0QbenBScQNRgJZwOd7EmPrVKI1D+nmmxXcebs79sc9D1GrV+odwKus
         H14XcE9Fv9YLFxq+xSymZX5uMrnuokZ0ag7+zC8lt1sEKD5pgQy3JxBjZA6Bm+LXT5a/
         YZJdDRId08LwyJinQcECBhxPIVDnRC/R+HI43uC6MBRrUUdb0ivTn7n+b6Oi/uI8gQ+c
         2DaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVc1eMIFObajMtNpJvzmu4h6Iyf692MGUcF7lPJQinewMYNZNb+MtPWL7SYHtDZuezL94w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKu9zoBTR1qVCV3aTxnXUQG0Fg8ASZUPuTbS1V+xHJ2nIDCtnz
	I3BH60/wLBi6ydZe5moR7sREzwjt+mS59FAEtt4JrZ68A9CHU/hFSD442Bm7LMZV4pCignnAaCB
	pUjLUNRAY9YZODjLUrsU3e8yPb0JPWzoy5JhduFo54bF9ioPAVnZpMw==
X-Gm-Gg: ASbGncsjkq/MRPxsJFR3HYakAE5quucKmh1ujFOkNcnvpsjgIJZ8ekGo4xG4nt/o6jm
	MW7vMnsjOJKCSCfb+IOCHg//v0wtUFfFBlTqtTSsrkQmHqRyld2wlgXhzJ66uA7JjsBU+QHF5nN
	OuJNCAIb/aHGSnB1IpgvfMUOVsmILzF49pUk6oNP5bQVoGwZe6Lg000ZFAfBy6IJusDRTWRUceL
	zRWUrTt0bqmbgXu54GWQfhhCP8WwuxmKBgsaUeB4b3s96ARGd4oMCIFLeVfce+PxOgKQAxUGMiK
	U8GKM0o2GLEGEL/tebPAY4024t4n7dZmc45FElMB+2o=
X-Received: by 2002:a05:6602:619c:b0:85a:fe80:cdd1 with SMTP id ca18e2360f4ac-879c0580553mr19252439f.0.1752604947392;
        Tue, 15 Jul 2025 11:42:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKy4ntzavpoglgjJNIISnwjoGcjFj1v0plW/t4NW2RQRcmCmInuGMexiG1Oj3xr2ay5HFnKA==
X-Received: by 2002:a05:6602:619c:b0:85a:fe80:cdd1 with SMTP id ca18e2360f4ac-879c0580553mr19251639f.0.1752604946858;
        Tue, 15 Jul 2025 11:42:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796bc5a706sm322376939f.45.2025.07.15.11.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jul 2025 11:42:25 -0700 (PDT)
Date: Tue, 15 Jul 2025 12:42:23 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "aaronlewis@google.com" <aaronlewis@google.com>,
 "bhelgaas@google.com" <bhelgaas@google.com>, "dmatlack@google.com"
 <dmatlack@google.com>, "vipinsh@google.com" <vipinsh@google.com>,
 "seanjc@google.com" <seanjc@google.com>, "jrhilke@google.com"
 <jrhilke@google.com>
Subject: Re: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Message-ID: <20250715124223.67a36d2a.alex.williamson@redhat.com>
In-Reply-To: <20250703233533.GI1209783@nvidia.com>
References: <20250626225623.1180952-1-alex.williamson@redhat.com>
	<20250702160031.GB1139770@nvidia.com>
	<20250702115032.243d194a.alex.williamson@redhat.com>
	<20250702175556.GC1139770@nvidia.com>
	<BN9PR11MB52760707F9A737186D818D1F8C43A@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20250703132350.GC1209783@nvidia.com>
	<20250703142904.56924edf.alex.williamson@redhat.com>
	<20250703233533.GI1209783@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 3 Jul 2025 20:35:33 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Jul 03, 2025 at 02:29:04PM -0600, Alex Williamson wrote:
> 
> > > > Is there any reset which doesn't disable SRIOV? According to PCIe
> > > > spec both conventional reset and FLR targeting a PF clears the
> > > > VF enable bit.    
> > > 
> > > This is my understanding, I think there might be a little hole here in
> > > the vfio SRIOV support?  
> > 
> > I wrote a test case and we don't prevent a vfio-pci userspace driver
> > from resetting the PF while also having open a VF, but I'm also not
> > sure what problem that causes.
> > 
> > pci_restore_state() calls pci_restore_iov_state(), so VF Enable does get
> > cleared by the reset (we don't actively tear down SR-IOV before reset),
> > but it's restored.   
> 
> Oh interesting, I did not know that happened. Makes sense.
> 
> > Also, PF->bus != VF->bus,   
> 
> Unrelated, but I've been looking at this and I haven't tried it yet,
> but it looked to me like:
> 
> 	bus = virtfn_add_bus(dev->bus, pci_iov_virtfn_bus(dev, id));
>  [.. inside virtfn_add_bus ]
> 	child = pci_find_bus(pci_domain_nr(bus), busnr);
> 	if (child)
> 		return child;
> 
> Will re-use the bus of the PF if they happen to have the same bus
> numbers. I thought the virtual busses come up if the VF RID calculation:
> 
> 	return dev->bus->number + ((dev->devfn + dev->sriov->offset +
> 				    dev->sriov->stride * vf_id) >> 8);
> 
> Exceeds the primary bus?

I tried it, I've got 82576 NICs in both a system with and without ARI
hierarchy.  Without:

 VF offset: 384, stride: 2

With:

 VF offset: 128, stride: 2

So the former places VFs on the N+1 bus (new struct pci_bus) from the PF
while the latter use the same bus number and struct.  Therefore my
previous inequality is not necessarily correct, the VF and PF could use
the same struct pci_bus.

In the ARI case, I believe you were right that the PF and VFs would have
then been sharing a dev_set.

So that does seem to be a visible difference as a result of this
change, in an ARI hierarchy, it would have previously been necessary to
supply the VF group FDs as proof of ownership of affected devices for a
hot-reset of the PF.  A non-ARI hierarchy would not have required that.
With this, neither require that.

Technically the VFs are affected by a PF bus reset, but unlike other
devices the VFs are also potentially affected by lots of things that
might happen to the VF and that's why we have the VF-token concept.  So
I kind of have a hard time getting bent out of shape by this.

I went ahead and added this to my next branch because I think your
impression is that this is generally ok based on the vf-token, but if
this raises new concerns I can drop it and we can discuss further.
Thanks,

Alex


