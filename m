Return-Path: <kvm+bounces-25311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 804039636B1
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 02:09:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0753E1F229FC
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 00:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B8F04C70;
	Thu, 29 Aug 2024 00:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="IVourlPv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8646A4A18
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 00:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724890154; cv=none; b=IY1b+K8Wd1JBrYHmPdfWbxQ5ISY2gZetWokkm8JC5YBvWHAEPxrwxnxJv3byKoHRASbf2p2Ln/j2CmkyU2zA5hrLVsdmDE//0yZsnzwbzB3YNE3tEVjTlK58ym3k5rViE8IJ7FBXFnkKeVBhmbZqS9tZKiFdOEhaQ2gzi89DrV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724890154; c=relaxed/simple;
	bh=pxYzwyTErxav4kVlQNYYa4Y6+SVLoPp+wWMf8HlP1cw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czYgqPt7n6o/NLPiFG0S9bF8Z02caSPABUn0FWYCv1C6hrCbimRQ6L9nIKIN39hOp3H91FBQREb9NvR3e0C+NVY5NAf7MS7b5mZ74NBYDGGwv7KsDqCKv9vxKxjPydE272QU4qGou0KyW0Ft+1uduq2MegOTeQZQYaiOuRshYXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=IVourlPv; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6bf775d1bdfso461636d6.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 17:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1724890151; x=1725494951; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FV7jma2FtOFkk+MQPyy4nsPLobzuy3OnZDyRuJH5ziE=;
        b=IVourlPvk/rZ5V8WDbenMVGtfvgHr77JPxxFTPS8j81k6L6pdeiNFcKCZHcrkOoxqS
         HHn8s4AOHfT3lD/x0/Vw5gupFv7FRWhjS0/HmJjWsy9dOr8rses4j5mVr+0OsdU0l5K/
         MYBaAXxMdWBD5H0MiV7ChjYfXy/PRkcYkSFrXoW+315KFnLpGMTPRgXUxgw9pW3Pxrls
         1ideEursUAhuKdvbjfl1pRdYFRbZ91IKiwRiLGIlxXzBzhOUx98AnqrUpt3Hzyh9ADDA
         5tRrx/QRCZjAr8/lHfzUgexrUo6+HQ7DNfuo2Zc7oT+oL4+ouZrxT2Jrox8wI5QUdf20
         8jqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724890151; x=1725494951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FV7jma2FtOFkk+MQPyy4nsPLobzuy3OnZDyRuJH5ziE=;
        b=Uv/F56iWurX7U4kjSH1M79b2VrjIB0nVL8zdy2/aWhTS+ORkrom1sc6g0QMRYIfDu7
         fQOWBbxlIsEiZRCk53je2M1GpsIJ3pZGmJlg2xak33U0VazQ/LFo4MN/JKQ0Y9sjMFp1
         UC+ELdY0bTo+qy5ur04ZTNOWc/Vq2yX7UoZXcpcjatABGcnnkrTmMb8O7a4xAza5Cryn
         JQSjVlpWcZNn6SHCruk084tgX+mK1h+08bgSrni9tmVlrEDn8CGWzSMIUEGeqsmOigUj
         I+0hUxsFjxwQe+IExb3ZUjmMhYH+OIa/fBHVW1VTj97UlawwKC16svDrJ8OZ5RTkGQel
         y6dw==
X-Forwarded-Encrypted: i=1; AJvYcCUFHizEmxn8smetyR2rXl02iyRPrWNk/73ed4FP28JRLHl4dsix1DAvc/re+K/7A6E787c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKbInayf6+YT7m9De+NtmEWr1xcsxKuWYZ5Ydf+MrRI9byd22M
	E3RCsTxNLM/0wvvVITG5GB0EXns7+PsG6U29fD6jwXAJf1YRZQyNJ6EDFslM3SY=
X-Google-Smtp-Source: AGHT+IHqw/vGpYZD+OWelu8nPkB2MgoCednN65b5E9RauNOWKDpklZXRAeEUm7fYZsAKjN6LMvW72A==
X-Received: by 2002:a05:6214:3d10:b0:6b2:b9c7:da6a with SMTP id 6a1803df08f44-6c33e671571mr15520156d6.41.1724890151363;
        Wed, 28 Aug 2024 17:09:11 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c340bfa74esm648816d6.6.2024.08.28.17.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 17:09:10 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sjSis-006P2S-3t;
	Wed, 28 Aug 2024 21:09:10 -0300
Date: Wed, 28 Aug 2024 21:09:10 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
	iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	pratikrajesh.sampat@amd.com, michael.day@amd.com,
	david.kaplan@amd.com, dhaval.giani@amd.com,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Message-ID: <20240829000910.GS3468552@ziepe.ca>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com>
 <20240827123242.GM3468552@ziepe.ca>
 <6e9e4945-8508-4f48-874e-9150fd2e38f3@amd.com>
 <20240828234240.GR3468552@ziepe.ca>
 <66cfba391a779_31daf294a5@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66cfba391a779_31daf294a5@dwillia2-xfh.jf.intel.com.notmuch>

On Wed, Aug 28, 2024 at 05:00:57PM -0700, Dan Williams wrote:
> Jason Gunthorpe wrote:
> [..]
> > So when I look at the spec I think that probably TIO_DEV_* should be
> > connected to VFIO, somewhere as vfio/kvm/iommufd ioctls. This needs to
> > be coordinated with everyone else because everyone has *some kind* of
> > "trusted world create for me a vPCI device in the secure VM" set of
> > verbs.
> > 
> > TIO_TDI is presumably the device authentication stuff?
> 
> I would expect no, because device authentication is purely a
> physical-device concept, and a TDI is some subset of that device (up to
> and including full physical-function passthrough) that becomes VM
> private-world assignable.

So I got it backwards then? The TDI is the vPCI and DEV is the way to
operate TDISP/IDE/SPDM/etc? Spec says:

 To use a TDISP capable device with SEV-TIO, host software must first
 arrange for the SEV firmware to establish a connection with the device
 by invoking the TIO_DEV_CONNECT
 command. The TIO_DEV_CONNECT command performs the following:

 * Establishes a secure SPDM session using Secured Messages for SPDM.
 * Constructs IDE selective streams between the root complex and the device.
 * Checks the TDISP capabilities of the device.

Too many TLAs :O

> I agree with this. There is a definite PCI only / VFIO-independent
> portion of this that is before any consideration of TDISP LOCKED and RUN
> states. It only deals with PCI device-authentication, link encryption
> management, and is independent of any confidential VM. Then there is the
> whole "assignable device" piece that is squarely KVM/VFIO territory.

Yes
 
> Theoretically one could stop at link encryption setup and never proceed
> with the rest. That is, assuming the platform allows for IDE protected
> traffic to flow in the "T=0" (shared world device) case.

Yes. I keep hearing PCI people talking about interesting use cases for
IDE streams independent of any of the confidential compute stuff. I
think they should not be tied together.

Jason

