Return-Path: <kvm+bounces-10299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E4886B7E5
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 20:07:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9D3A2888A8
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 19:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB747440A;
	Wed, 28 Feb 2024 19:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GuZPteZb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8557379B74
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 19:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709147238; cv=none; b=kvsWonpvoPabv4RGZX7oGy5jp6w/i+wj2+CXCxHanFoiUTWcD9UfRxnpu+vHygxybrA2uw8BKHJRxLpR+ITiWr+EaSgK9sDQW4JDf+vbolhlyLk1NMVRK9v1vvXmeDxhzbUnn+eObF/zvpdUyl49fOUwK73MNTuEJCeH91V2xgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709147238; c=relaxed/simple;
	bh=Qz2Vdj2rBC2mJZbNt9ILBRIAFfLJFVWy5MELjmgC5jo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iYZtJaEqDBwsZRH4hf0ioSaLIUYJSJG/xpM2ixEqdksXqGn1NcoA8hUF0oBzTGmbuIbwj4fLOehCXQ1kk4CedjhATOzrVEPMB7jVDV1mJ29OJkFVhMfJOuR6dJgrOaI8mUK4z6VrJ0M0CKwVak0mHNZc4YGrg7uwqsUpTruV/E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GuZPteZb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709147235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rYV4SrxcohGt3HtzPUZ+rdkqbt8EWPpbUaoKo3V+foI=;
	b=GuZPteZbOGq2sAOPy08pBLdJrEe5Y46adNGVphEBJovSj+KQ1TBODMJvHf40Be/ryNwo9r
	x4mTkIbXNUGpBe8gYECJ8CgYKIDBqzvT9qd8Iy5AYd51QAV8hs1cxDYEP/J9GVPh/68VQy
	rgtLaAfHUbb7CqLdd4vRegfWlJU4Cww=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-P6eWuut7NEOn4uBygoRsig-1; Wed, 28 Feb 2024 14:07:11 -0500
X-MC-Unique: P6eWuut7NEOn4uBygoRsig-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7c78573f2d0so2238639f.1
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 11:07:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709147230; x=1709752030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rYV4SrxcohGt3HtzPUZ+rdkqbt8EWPpbUaoKo3V+foI=;
        b=X0l3fC3a/Fc0tdpXoBtd3x2cIlfGERzQxHRQKD7ek+bDLO40CrWsGfsD3JWtotQ0jM
         KHGycHgdIX7E4Pvu09FO1P7ot8GnJY3uke3pNKZlgVbjE6qIiibEh7lbxIydsR5k6zJp
         Ikbj0Rc0l3PqBSR06nlACzVDlpph8SQRLKmMQSh/lZzOMDUwE20fP282ewQi4zRzAQeC
         BV2DEIrYmbV7IT6iD4TWf/f6NmY57sM6YJUe8rCvHDQICOHxiYCbxgOYlKOOPDndvxQF
         mQq3BlhXXW4YgCOY1ZcncjuGGGaJ9Z9VTZa+wpjDoJ5F7chYBAsma5v5DKhN2GHXKwzl
         EJCw==
X-Forwarded-Encrypted: i=1; AJvYcCXFNMXcV0cvfHPvGhJmztWwYQtam5ZSDueIx25UUuZFLx6+0pb5h0PPOgFlI1lMqzyW62RC0YXjkRDe0RxmLlby9VX9
X-Gm-Message-State: AOJu0Yy09b0sgyHbRwzXpH0Bv30Fu73n4B7apDMlufoxaYcCGF+qIqqp
	j2Y6+pX+RcJnZLceoypVDssa2VT8kX3/IbnsHXgJUhf9ixbYc486J1rC/FeOGEH6jq2ZRqgRL3/
	wRpQp+otkYIYWfsRCpJegOpQ+xJTozAqBgLOQgKHuCu093aXNsQ==
X-Received: by 2002:a5e:c249:0:b0:7c7:8fda:e836 with SMTP id w9-20020a5ec249000000b007c78fdae836mr120297iop.0.1709147230198;
        Wed, 28 Feb 2024 11:07:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmyZUluB62eCjXZWTg6QnIXee6qM5qrhHOGBlbNEDBmI1cB3oVfXg/I91wseTQnvRrL5Hn8g==
X-Received: by 2002:a5e:c249:0:b0:7c7:8fda:e836 with SMTP id w9-20020a5ec249000000b007c78fdae836mr120281iop.0.1709147229895;
        Wed, 28 Feb 2024 11:07:09 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id eh3-20020a056638298300b0047466fd3b1dsm2360704jab.22.2024.02.28.11.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 11:07:09 -0800 (PST)
Date: Wed, 28 Feb 2024 12:07:06 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Xin Zeng <xin.zeng@intel.com>, herbert@gondor.apana.org.au,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
 qat-linux@intel.com, Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240228120706.715bc385.alex.williamson@redhat.com>
In-Reply-To: <20240226152458.2b8a0f83.alex.williamson@redhat.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
	<20240221155008.960369-11-xin.zeng@intel.com>
	<20240226115556.3f494157.alex.williamson@redhat.com>
	<20240226191220.GM13330@nvidia.com>
	<20240226124107.4317b3c3.alex.williamson@redhat.com>
	<20240226194952.GO13330@nvidia.com>
	<20240226152458.2b8a0f83.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 26 Feb 2024 15:24:58 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 26 Feb 2024 15:49:52 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Feb 26, 2024 at 12:41:07PM -0700, Alex Williamson wrote:  
> > > On Mon, 26 Feb 2024 15:12:20 -0400
> > > libvirt recently implemented support for managed="yes" with variant
> > > drivers where it will find the best "vfio_pci" driver for a device
> > > using an algorithm like Max suggested, but in practice it's not clear
> > > how useful that will be considering devices likes CX7 require
> > > configuration before binding to the variant driver.  libvirt has no
> > > hooks to specify or perform configuration at that point.    
> > 
> > I don't think this is fully accurate (or at least not what was
> > intended), the VFIO device can be configured any time up until the VM
> > mlx5 driver reaches the device startup.
> > 
> > Is something preventing this? Did we accidentally cache the migratable
> > flag in vfio or something??  
> 
> I don't think so, I think this was just the policy we had decided
> relative to profiling VFs when they're created rather than providing a
> means to do it though a common vfio variant driver interface[1].

Turns out that yes, migration support needs to be established at probe
time.  vfio_pci_core_register_device() expects migration_flags,
mig_ops, and log_ops to all be established by this point, which for
mlx5-vfio-pci occurs when the .init function calls
mlx5vf_cmd_set_migratable().

So the VF does indeed need to be "profiled" to enabled migration prior
to binding to the mlx5-vfio-pci driver in order to report support.

That also makes me wonder what happens if migration support is disabled
via devlink after binding the VF to mlx5-vfio-pci.  Arguably this could
be considered user error, but what's the failure mode and support
implication?  Thanks,

Alex


