Return-Path: <kvm+bounces-24062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2846950E47
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 23:03:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 065F21C211F4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 21:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16EAE1A7061;
	Tue, 13 Aug 2024 21:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HzZPKLdm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0C64F881
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 21:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723583008; cv=none; b=k8AOr62mKr4SzYPXZqU9XomcmZp2LMryUkMkh+d2LC3Hah2G2ML1hRRRF1shm9c9Wr9+15yndMyRw8697sQ0rFSxHtFrMUOwD90zKwppHJ07neujIiwt1mYe3dHpm5G74kPLrDCCgNxoWVeTqdUqg0UBTjemjXYW976VnzirA3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723583008; c=relaxed/simple;
	bh=S1wGFKTAEjSQsbf68k5RXdglIXflEszFnfO6eF1HbfI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IWCX/mO9r1Om5aQY9vZjIibWP81WdchULTNpvQn4j8GOM5YAw8kFNR+orT6axqMRrQsoIFUf996rU40HN5MnrB4LOMOeOAN5cBmp0Xfux8HN5nKIaRqUm9hHsWLbqvjD1e87B+6AGQmNTV+gOqyUedD2FZT1MIh0vjmadwZGbkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HzZPKLdm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723583005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1UOf/e3HcQ+l94OWXrCwdSK3TbHtvFPHwqfrVahjAnI=;
	b=HzZPKLdmzl9SfUMMYWJITFd9JXtrdorv7WolYXcogxGZTwKSAKv1H2cpdHiss7rLBprePA
	1JTkHWGsRIi5aHPMmcZjtdmIqmRHxcf2q85Eq7cXSu8UktEGheGfJtU92WgydJzbp6OTWc
	vtTpEUgoVarlN/HBi/pu73aIU06I6yU=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-DmHD1-3DN0-I1S4qUIENfA-1; Tue, 13 Aug 2024 17:03:24 -0400
X-MC-Unique: DmHD1-3DN0-I1S4qUIENfA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-81f8c78cc66so773885339f.2
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 14:03:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723583004; x=1724187804;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1UOf/e3HcQ+l94OWXrCwdSK3TbHtvFPHwqfrVahjAnI=;
        b=T03uxVs41ks1ayYDfF8vuzL6EiIe/le5P2pwP4tuuSaebbfkCansjgl2Fgyxuxvi7Z
         yiQL7F/w26KGuWTPRQ7Ct5roQ5uqMmYFRBxirXPUrDziRGitMtW/WfsO0Wvvmg7J7TS3
         6pEawyCTLSK6d9KUwqThjQBeBMC7rBvzC1HdFQBkyDTjPsQ5GU0rOdrJUt17fP/OSYUP
         TV6Tl+bJiOwkMtOabCHSgYW5dsMzmgJdAeJnA5skYGJVWQrRuABJAQbIEwwzl/enbZ0w
         QO6Mfo3FP33NJ/RDZzw8urM9xS/68yErhs07MTxwAhX3r2Ex7CzTAUICy+VXzw+1CYY5
         rRgw==
X-Forwarded-Encrypted: i=1; AJvYcCWpt9dCWBuVljKCkaa1GZ3HrjmExMDV7l2r85NS/SlZCOdeOewmTIgQHd5ZERzExbLphJtehh1yIF5ejXVhz7UAxIly
X-Gm-Message-State: AOJu0Yxb/Bxbj1K7IKAOx7iOIn1liR1V6XXOP3/KG3fGN4z9cz1W49BV
	Mx1aNtyYwI5nwvZJcrbF5E3H08YdvZ8AatRHpRi/goRp01dYtio5N0X/H4z5tSbHopd3aeaQDP2
	GPVEF+D8SEiIcp7DOWY5b1ilY9xx+MMQE5ct8qdP6PjIL/9ZDFg==
X-Received: by 2002:a05:6602:14d2:b0:804:9972:2f8c with SMTP id ca18e2360f4ac-824dad04265mr122543439f.8.1723583003652;
        Tue, 13 Aug 2024 14:03:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUG+Ra/4MLDKrpbcdWTsiFMgCKM25UlSCbFVfALG5nTggblaB3Mjb05rv1rYcf1nGj/+3LVA==
X-Received: by 2002:a05:6602:14d2:b0:804:9972:2f8c with SMTP id ca18e2360f4ac-824dad04265mr122539339f.8.1723583003274;
        Tue, 13 Aug 2024 14:03:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ca76910393sm2733107173.7.2024.08.13.14.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 14:03:22 -0700 (PDT)
Date: Tue, 13 Aug 2024 15:03:20 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, quic_bqiang@quicinc.com,
 kvalo@kernel.org, prestwoj@gmail.com, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, dwmw2@infradead.org, iommu@lists.linux.dev,
 kernel@quicinc.com, johannes@sipsolutions.net, jtornosm@redhat.com
Subject: Re: [PATCH RFC/RFT] vfio/pci-quirks: Quirk for ath wireless
Message-ID: <20240813150320.73df43d7.alex.williamson@redhat.com>
In-Reply-To: <20240813164341.GL1985367@ziepe.ca>
References: <adcb785e-4dc7-4c4a-b341-d53b72e13467@gmail.com>
	<20240812170045.1584000-1-alex.williamson@redhat.com>
	<20240813164341.GL1985367@ziepe.ca>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Aug 2024 13:43:41 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Mon, Aug 12, 2024 at 11:00:40AM -0600, Alex Williamson wrote:
> > These devices have an embedded interrupt controller which is programmed
> > with guest physical MSI address/data, which doesn't work.  We need
> > vfio-pci kernel support to provide a device feature which disables
> > virtualization of the MSI capability registers.  Then we can do brute
> > force testing for writes matching the MSI address, from which we can
> > infer writes of the MSI data, replacing each with host physical values.
> > 
> > This has only been tested on ath11k (0x1103), ath12k support is
> > speculative and requires testing.  Note that Windows guest drivers make
> > use of multi-vector MSI which requires interrupt remapping support in
> > the host.  
> 
> The way it is really supposed to work, is that the guest itself
> controls/knows the MSI addr/data pairs and the interrupt remapping HW
> makes that delegation safe since all the interrupt processing will be
> qualified by the RID.
> 
> Then the guest can make up the unique interrupts for MSI and any
> internal "IMS" sources and we just let the guest directly write the
> MSI/MSI-X and any IMS values however it wants.
> 
> This hackery to capture and substitute the IMS programming is neat and
> will solve this one device, but there are more IMS style devices in
> the pipeline than will really need a full solution.

How does the guest know to write a remappable vector format?  How does
the guest know the host interrupt architecture?  For example why would
an aarch64 guest program an MSI vector of 0xfee... if the host is x86?

The idea of guest owning the physical MSI address space sounds great,
but is it practical?  Is it something that would be accomplished while
this device is still relevant?

> > + * The Windows driver makes use of multi-vector MSI, where our sanity test
> > + * of the MSI data value must then mask off the vector offset for comparison
> > + * and add it back to the host base data value on write.  
> 
> But is that really enough? If the vector offset is newly created then
> that means the VM built a new interrupt that needs setup to be routed
> into the VM?? Is that why you say it "requires interrupt remapping
> support" because that setup is happening implicitly on x86?
> 
> It looks like Windows is acting as I said Linux should, with a
> "irq_chip" and so on to get the unique interrupt source a proper
> unique addr/data pair...

The Windows driver is just programming the MSI capability to use 16
vectors.  We configure those vectors on the host at the time the
capability is written.  Whereas the Linux driver is only using a single
vector and therefore writing the same MSI address and data at the
locations noted in the trace, the Windows driver is writing different
data values at different locations to make use of those vectors.  This
note is simply describing that we can't directly write the physical
data value into the device, we need to determine which vector offset
the guest is using and provide the same offset from the host data
register value.

I don't know that interrupt remapping is specifically required, but the
MSI domain needs to support MSI_FLAG_MULTI_PCI_MSI and AFAIK that's
only available with interrupt remapping on x86, ie.
pci_alloc_irq_vectors() with max_vecs >1 and PCI_IRQ_MSI flags needs to
work on the host to mirror the guest MSI configuration.  Thanks,

Alex


