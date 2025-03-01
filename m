Return-Path: <kvm+bounces-39781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF46A4A710
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 01:37:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3A193B373E
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 00:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA1481CA84;
	Sat,  1 Mar 2025 00:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Z8vaSmji"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDE412B73
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 00:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740789435; cv=none; b=iDuF+85rXkB8nYLOHasEmu7uXDF19rPZOVVe3RtySbfC89MEBQVNO0q+DL+/GQVhJkaMeVUk66tOpVAMYlv5GM5q3h7dwso7hidShuc/EDmzr0FZ1WRGjWJ7mILAWvED5p+wE6bQlDwYkctIBz+4EE9n4vL14gNAiuI2dDYoQ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740789435; c=relaxed/simple;
	bh=KWp+JkEQ384C2ZZM2vnmvijKALezyZ2yoZO4XWGrnII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNF+nkkJx0bg7mlSZNgZ8cGrRwlJFanu0g8rHMJiJ4AvBNElC6F7TbG2yGJKcBuv5I6UJaQfIPIWq6aC9pgdlqF/NwSxvqnfygUCATBCM8h4HDWZSFR9myiWBZK+mH4J6RV4Y8QqkpIL+eUDYm7Uj5DjAeXkKX8gc262x2EzIwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Z8vaSmji; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7c24ae82de4so261269985a.1
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 16:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1740789432; x=1741394232; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Td3ECwr3BYX3Fk7gFnUV4jIGzq67kra6+CNEYMgu4U=;
        b=Z8vaSmjiEs+nPorZdfUrAjkI1nEevckyK9Dh0B6Eq0ipato35eeCQa5LdGx3pwfRj0
         oHw5Z/HV64Z6ebo2cDFx2aJiu+12an0VTAwKlta62BwuP1Xt/rXOogyne1kCkwFon4fD
         OdyRkws1GJPN8HkEAc4rUylqjiKZts2fNC/Pnc9Aa6PUvYEWOcR8YxOg5nZ+roDZFuVg
         HkkWbUSMKmhusUHsKo1fLm3AGkT8mgStDoqea3zdc8aM0Nuj29X9MTfH0lHAjFLCE0Hx
         6uAKoPwQJoAjVepzI4fhcsqRsXYRTZDS6wZ8haCsLuYDzxWUe1ufMnTZlLPqmQ2LmJzD
         /l3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740789432; x=1741394232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Td3ECwr3BYX3Fk7gFnUV4jIGzq67kra6+CNEYMgu4U=;
        b=MvPJ7Z38BO2GysTzvyAWeLa5EoFIssDhbnN9Y3SXNhVYE9QtjcsejGMCO+iupRIASm
         3G/9IqK1Vm/4fPGBqPWzYh1lbP5eZQupJafRVjXnbroZwJEHJtLejF/avhYtHGh4mr+9
         f00LLxJfG21tYYpIjAySKzYtTn4LhDwEKrG/IwzfjbNi434RUleEMlpVZ9F8mZbZjJG2
         7jBbsyR2jheE+72tJAUDfHQ4cXvWLnPKY10KMwWzKqXThZeUKz2ww/dEfDN9yU6zinyG
         13zpFADkKzflO5zidiK812rOZhlerrhgJCYCjcE2a5ZmaIqommHCqo0VakUahwGFh1ND
         g+SA==
X-Forwarded-Encrypted: i=1; AJvYcCXQwPfPgi+3kxGxaJsjxQa8w57ZxKgpdcGp5Dqu1KTrMV60tl5vt5scUhQACVkcc2FwkRw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuDM0DJ5OMLRhQQA6564ZW2ZJ6VPdOE2nyaAvolsZY2S1onRfL
	nhmlNAy3rKuX+xbHuopnql9IDsS0F1cEKbSFs0L9hhUy17Ofqmyz7lf8aFtPpmc=
X-Gm-Gg: ASbGncuq5porR3FPyt3FWSJfZuVW3970k0lXNs471MF4Xr0aoK692KBRhNjg5WtWgGp
	EaviIDHC1Yr1F0vRetbFB2qEVUcOgY9wpDHUazaGCeAbrFzSnacYWh0jwms4u4pu7EthZ9jOG4s
	hiejDj9bu07uRPZ3JOCTEg2jaszCrR1DtTj8Q7/QjkXXP2jKTFsNEhW0hxVxrdBDPMAJasDOnaZ
	bRswbrfrak/ygvt5RwZvF8Q39WIGTK91ir3turn8i4ZqAfNYdNd9ym5tWimIftzW/cwXMt81Odz
	Ya+Wo1Ds/yteKzciM6TY5hIU9oikTFGbfVvktOr0j+46eEEqM+2tnvfMeeosFI2NIISvMcuQ534
	bk8OW3HRoi6hRxM13xw==
X-Google-Smtp-Source: AGHT+IFOn/ksSHuws3wokBJvJa6/sj/LoYkAsoS+wBwh3GzDwSM7WHVrzGwS02MkZWU6Ex8ojjGm5Q==
X-Received: by 2002:a05:620a:4051:b0:7c0:9ac5:7f9e with SMTP id af79cd13be357-7c39c6691eamr774480385a.50.1740789432305;
        Fri, 28 Feb 2025 16:37:12 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c378dac6d3sm310478485a.97.2025.02.28.16.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 16:37:11 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1toAqt-00000000VRk-15Wo;
	Fri, 28 Feb 2025 20:37:11 -0400
Date: Fri, 28 Feb 2025 20:37:11 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, x86@kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-arch@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Christoph Hellwig <hch@lst.de>, Nikunj A Dadhania <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Steve Sistare <steven.sistare@oracle.com>,
	Lukas Wunner <lukas@wunner.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Dionna Glaze <dionnaglaze@google.com>, Yi Liu <yi.l.liu@intel.com>,
	iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	Zhi Wang <zhiw@nvidia.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [RFC PATCH v2 14/22] iommufd: Add TIO calls
Message-ID: <20250301003711.GR5011@ziepe.ca>
References: <20250218111017.491719-1-aik@amd.com>
 <20250218111017.491719-15-aik@amd.com>
 <Z72GmixR6NkzXAl7@yilunxu-OptiPlex-7050>
 <2fe6b3c6-3eed-424d-87f0-34c4e7e1c906@amd.com>
 <Z77xrqLtJfB84dJF@yilunxu-OptiPlex-7050>
 <20250226131202.GH5011@ziepe.ca>
 <Z7/jFhlsBrbrloia@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7/jFhlsBrbrloia@yilunxu-OptiPlex-7050>

On Thu, Feb 27, 2025 at 11:59:18AM +0800, Xu Yilun wrote:
> On Wed, Feb 26, 2025 at 09:12:02AM -0400, Jason Gunthorpe wrote:
> > On Wed, Feb 26, 2025 at 06:49:18PM +0800, Xu Yilun wrote:
> > 
> > > E.g. I don't think VFIO driver would expect its MMIO access suddenly
> > > failed without knowing what happened.
> > 
> > What do people expect to happen here anyhow? Do you still intend to
> > mmap any of the MMIO into the hypervisor? No, right? It is all locked
> 
> Not expecting mmap the MMIO, but I switched to another way. VFIO doesn't
> disallow mmap until bind, and if there is mmap on bind, bind failed.
> That's my understanding of your comments.

That seems reasonable

> Another concern is about dma-buf importer (e.g. KVM) mapping the MMIO.
> Recall we are working on the VFIO dma-buf solution, on bind/unbind the
> MMIO accessibility is being changed and importers should be notified to
> remove their mapping beforehand, and rebuild later if possible.
> An immediate requirement for Intel TDX is, KVM should remove secure EPT
> mapping for MMIO before unbind.

dmabuf can do that..

> > > The implementation is basically no difference from:
> > > 
> > > +       vdev = container_of(iommufd_get_object(ucmd->ictx, cmd->vdevice_id,
> > > +                                              IOMMUFD_OBJ_VDEVICE),
> > > 
> > > The real concern is the device owner, VFIO, should initiate the bind.
> > 
> > There is a big different, the above has correct locking, the other
> > does not :)
> 
> Could you elaborate more on that? Any locking problem if we implement
> bind/unbind outside iommufd. Thanks in advance.

You will be unable to access any information iommufd has in the viommu
and vdevice objects. So you will not be able to pass a viommu ID or
vBDF to the secure world unless you enter through an iommufd path, and
use iommufd_get_object() to obtain the required locks.
 
I don't know what the API signatures are for all three platforms to
tell if this is a problem or not.

Jason

