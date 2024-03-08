Return-Path: <kvm+bounces-11385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81898876A8B
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 19:09:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2B9A1C2174E
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 18:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8937D57867;
	Fri,  8 Mar 2024 18:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QjvarfKt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB30B55E65
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 18:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709921386; cv=none; b=pzwepLspxtx3n5ck1nImK4NS7mXwLePyC26iklR7IgPzMbksPSde1TNqjWwAWeUiDXA4tilHKkNyVJ5QNln/D+4QfHZ9N0ATcOiz2TJ+NYTg565JblbnuuNNYTQPiqW+8PFmkJSqvPFUecfS/RRobnHrY0KlRgTIRslSHrmd34c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709921386; c=relaxed/simple;
	bh=LikYyzCecy2Q4f2KC79AVP0DWAPyW0dRwSVNlJmxM1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LeLox5gWgB0wJK/2zbnA1De6+5HIYnzxmdFUAMFrHwZDMgKGl7lUL/Muidz4twl4olvj9ivdGEJPU8dieyM1AEWHUaA1ppFlPUVCt8LYO6K8ws4Eaxgtvmw5raLkxXhuJz4CAun1zqUSYVeEGAIe0xMJw21DAwPP0Tm9d9jmuWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QjvarfKt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709921383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xz/YxiA/VGUbQYXY3ND1aG0ujsEUkM8N72A3ZL6M5NI=;
	b=QjvarfKtkRdiC8y2z6WvEWwFtwQSqSl9eokhg5QzsjSCLC+A22iXwAWsmietT6PFfqLM2j
	LIvcaMR4+9iXsMg31A9sCr6BDR+lXgDK4QDV9CF8UUXIgXvsJtCpRrxt+0G5xZ3ZbZpP6y
	WiwZkjBh3pHECoi9Yd95FOV6j15uxxM=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-Wv4SbF6qNtOkP7X1E644cw-1; Fri, 08 Mar 2024 13:09:42 -0500
X-MC-Unique: Wv4SbF6qNtOkP7X1E644cw-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3662fd7ae59so5697625ab.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 10:09:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709921381; x=1710526181;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xz/YxiA/VGUbQYXY3ND1aG0ujsEUkM8N72A3ZL6M5NI=;
        b=g5QXM8kXq8DYGPJ1+g8JC0/bHumHgJYrKGkni0tuCHDGRcaxfdMqMWLFuWsOaDWbC7
         PUILPVjbd13/AMKZNE+imhwsMzeu65lVEa8VdGexsOHDuYM7rGXQxPHRUDap421pChTD
         g8ON8cZ22OHkNqrzE4jKyPML0vKd1zC9dv1eBERkxra+lcIjuMuWT12fOgdBhzWw0lvU
         HyuBSE9oQCcREfGbWTIpUbK8qKkh6eGUC5BboaZsI918lhLfXqzqp8vnWGxZ7bA5uzkk
         wmLxBJwZkMVMgWGS24eREpKK3Ty1tc1Pde/AN+vD+DxFOi/9HeQfC+lyn2bsjGjrCFjQ
         t84A==
X-Gm-Message-State: AOJu0YxnrgJsyawI3iiW3udoeZXFwXGy9mBx6ywK5bSffooZrWCLZ1BC
	Yxy4NVphRmehWyQBlG6C6a9AYdaSMKhUdNo7U8upRZ8PvhbKvt1mACbhYIflWnhLsSmIe4MfUUF
	9TX1PxJ53vkxYnGrgroJU1stzD7S+AQ0POwoIpnV0ib78z4i/ow==
X-Received: by 2002:a05:6e02:218c:b0:365:1749:cae5 with SMTP id j12-20020a056e02218c00b003651749cae5mr26162578ila.19.1709921381782;
        Fri, 08 Mar 2024 10:09:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH1gQYxWu4+4Cc/UIrD66Vitl3FDWB+wq5vJpfnJ7XfX/xSfWuW2ihD+P4DW6Rr6XiJ+ynUKw==
X-Received: by 2002:a05:6e02:218c:b0:365:1749:cae5 with SMTP id j12-20020a056e02218c00b003651749cae5mr26162558ila.19.1709921381520;
        Fri, 08 Mar 2024 10:09:41 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id j8-20020a05663822c800b00476c165e60csm646730jat.30.2024.03.08.10.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 10:09:40 -0800 (PST)
Date: Fri, 8 Mar 2024 11:09:37 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
 <eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] vfio/platform: Disable virqfds on cleanup
Message-ID: <20240308110937.2f2d934e.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB52766BAB438D1D1B782243038C272@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
	<20240306211445.1856768-6-alex.williamson@redhat.com>
	<BN9PR11MB52766BAB438D1D1B782243038C272@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 8 Mar 2024 07:16:02 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, March 7, 2024 5:15 AM
> > 
> > @@ -321,8 +321,13 @@ void vfio_platform_irq_cleanup(struct
> > vfio_platform_device *vdev)
> >  {
> >  	int i;
> > 
> > -	for (i = 0; i < vdev->num_irqs; i++)
> > +	for (i = 0; i < vdev->num_irqs; i++) {
> > +		int hwirq = vdev->get_irq(vdev, i);  
> 
> hwirq is unused.

Yep, poor split with the next patch.  I'll update the next patch to use
vdev->irqs[i].hwirq here and in the unwind on init to avoid this.  Thanks,

Alex

> > +
> > +		vfio_virqfd_disable(&vdev->irqs[i].mask);
> > +		vfio_virqfd_disable(&vdev->irqs[i].unmask);
> >  		vfio_set_trigger(vdev, i, -1, NULL);
> > +	}
> > 
> >  	vdev->num_irqs = 0;
> >  	kfree(vdev->irqs);
> > --
> > 2.43.2  
> 


