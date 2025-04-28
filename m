Return-Path: <kvm+bounces-44603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF1B7A9FA88
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 22:27:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEEFA466894
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 20:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEDE3204F81;
	Mon, 28 Apr 2025 20:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YUaNK8Dw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3073C1D6DAA
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 20:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745871967; cv=none; b=SUeBFplVl1DxAiaciv1/QKiMGw+3VQbgBMKmUhRSE1GosqB22fCCXCTvYMxWy6X/LRmp72n2F475TawFuiqyrlgaTptf+c16lRZmbfD9I2uP9XA7O8uxUsiYAzqI4wiowqkTmUM8l/X4uZIig/zoNEvIQXI0CRwew8eJ2qsVcpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745871967; c=relaxed/simple;
	bh=VGf/QmZis3k8gsBX6t/gMBCbXXMSQRWv4SjNTZpDaCA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iJHddQnA3pkPndRWHmDJfW3t+Dgv6b0AwrF7pM4uklQ+y2lpuhZNVnXNb/Lhi+VwcRNN0ENCpfUuhmVaXXW2nS8iDiJ0Iht95LmhpNXuI1oKXyRResMSNsGQn88+Hp6AtK1gKTW8Hgj9sCrJLosPFoOaDrRSUUKGlkM3ELTi0Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YUaNK8Dw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745871965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4oRenlf6ZXkOZ4M4A7BEPthPXLL9wn8/E4rBWOdjTQ=;
	b=YUaNK8Dwb8qwUFRh2jySmGG0TSro//9+WZzSlcAjglX1qbMImCaoYJNZaagbLykzZgauc3
	2aAwYtPNYPY51ErwOIkoqwcDbwFslE0swdSLSVH8LpOyJaTBJUpFQ9H6IEk96XXU+/2RjJ
	J+UQ5UB28E+QpOEYzCE/keaxSUSk38E=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-FoNyr4YQPqu9rNNBVO8MFg-1; Mon, 28 Apr 2025 16:26:03 -0400
X-MC-Unique: FoNyr4YQPqu9rNNBVO8MFg-1
X-Mimecast-MFC-AGG-ID: FoNyr4YQPqu9rNNBVO8MFg_1745871962
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-85b5c68c390so39384239f.0
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 13:26:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745871962; x=1746476762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C4oRenlf6ZXkOZ4M4A7BEPthPXLL9wn8/E4rBWOdjTQ=;
        b=jnvevWb2JGRHtO613Af4TyAvn7fHlmwCBW/9449NjU0VlLDvdlvz7l+GybnPH0OgXB
         3ZvTVFtjzGQhAmJ+VdBM+rNTCh1rxg/3JvOxoDlLhZCCPXf9uNf06lqFNp94y6b0Nv8y
         NoFd8sOXUFpN/qG5onCp+jWWLZ1LuYEmu4lxP8zU1mmQk05c7wMJlNn6TVF4684JAA5q
         9keko072R0B4CiR6e0J95odzKT6gkPHXkM5YFZBzzuYPIMsM89oBgapIxMBBIzBTV6+p
         nE4Rx1IMw6+8tCEWawGyo9A5a2fwGjepdRjOlHKu1v8xSiXP7/nn2HB2RP8AcEsKJUwC
         zrVw==
X-Forwarded-Encrypted: i=1; AJvYcCVGWEjkeYUcxZs7LJt6Dq+q8sBJaFegFeA9Szkrhl/YP9j15SeymiciC2wpuEFf9Xr+2WM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6uBkBX5wPVm37pDOTpNcmqalVM3TtvREFVNzExknjxKniJe4U
	j4vTn6V2BicJGhkGoAl3+CvfH9Oms5H3UjD3zFtZvSx400ugCxn1Nbl3vRmQTVcIjt6Qsjf04MT
	Rx0eL6V+IrjpVMTlOBUuxHHKG3e0JWd2zgPGw0Oo0slLccrPdEw==
X-Gm-Gg: ASbGncvi5QLADBe5f00pKzuQpYAeC+oyJ2RiFA038ffWmXd4AaGbrQLsZ0iXLefwwOS
	VzsCdLxbozqKYblEFJlOukCw3VsrGgBpd/SpZXyNt1Krhes5HaYrH4vG7pHZZ3jjosJoxm+4AiF
	eQA6tT2gsWJ3H3JIwSa3QoVTT4U6+h9FrIRqafBb38MtB/RHqc/eCNF+fhdtO2j+3vRO/Kzysix
	Zb8fK9WAfi1WGwpBPNNbHCG6KQ0U1PXryQmIRDmmZ8yUu4m4/l6Kgy2iVPPGdgAY53C8o6TgpF9
	rR5hmcC6asrDOoQ=
X-Received: by 2002:a05:6e02:380e:b0:3d4:6d6f:6e1f with SMTP id e9e14a558f8ab-3d93b63506dmr34582145ab.6.1745871962559;
        Mon, 28 Apr 2025 13:26:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQ6RktMQ/g1jxZuRwgjhMKbfgCiAeUAio6yQ0WrdLPoqp16TVDnE3inrH72mfRdzeBq2m+wQ==
X-Received: by 2002:a05:6e02:380e:b0:3d4:6d6f:6e1f with SMTP id e9e14a558f8ab-3d93b63506dmr34582015ab.6.1745871962207;
        Mon, 28 Apr 2025 13:26:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d9314f5772sm21529085ab.41.2025.04.28.13.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 13:26:01 -0700 (PDT)
Date: Mon, 28 Apr 2025 14:25:58 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>,
 kvm@vger.kernel.org, Chathura Rajapaksha <chath@bu.edu>, Paul Moore
 <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Giovanni Cabiddu
 <giovanni.cabiddu@intel.com>, Xin Zeng <xin.zeng@intel.com>, Yahui Cao
 <yahui.cao@intel.com>, Bjorn Helgaas <bhelgaas@google.com>, Kevin Tian
 <kevin.tian@intel.com>, Niklas Schnelle <schnelle@linux.ibm.com>, Yunxiang
 Li <Yunxiang.Li@amd.com>, Dongdong Zhang
 <zhangdongdong@eswincomputing.com>, Avihai Horon <avihaih@nvidia.com>,
 linux-kernel@vger.kernel.org, audit@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] vfio/pci: Block and audit accesses to
 unassigned config regions
Message-ID: <20250428142558.263c5db1.alex.williamson@redhat.com>
In-Reply-To: <20250428132455.GC1213339@ziepe.ca>
References: <20250426212253.40473-1-chath@bu.edu>
	<20250428132455.GC1213339@ziepe.ca>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Apr 2025 10:24:55 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Sat, Apr 26, 2025 at 09:22:47PM +0000, Chathura Rajapaksha wrote:
> > Some PCIe devices trigger PCI bus errors when accesses are made to
> > unassigned regions within their PCI configuration space. On certain
> > platforms, this can lead to host system hangs or reboots.  
> 
> Do you have an example of this? What do you mean by bus error?
> 
> I would expect the device to return some constant like 0, or to return
> an error TLP. The host bridge should convert the error TLP to
> 0XFFFFFFF like all other read error conversions.
> 
> Is it a device problem or host bridge problem you are facing?

Or system problem.  Is it the access itself that generates a problem or
is it what the device does as a result of the access?  If the latter,
does this only remove a config space fuzzing attack vector against that
behavior or do we expect the device cannot generate the same behavior
via MMIO or IO register accesses?

We've previously leaned in the direction that we depend on hardware to
contain errors.  We cannot trap every access to the device or else we'd
severely limit the devices available to use and the performance of
those devices to the point that device assignment isn't worthwhile.

PCI config space is a slow path, it's already trapped, and it's
theoretically architected that we could restrict and audit much of it,
though some devices do rely on access to unarchitected config space.
But even within the architected space there are device specific
capabilities with undocumented protocols, exposing unknown features of
devices.  Does this incrementally make things better in general, or is
this largely masking a poorly behaved device/system?

> > 1. Support for blocking guest accesses to unassigned
> >    PCI configuration space, and the ability to bypass this access control
> >    for specific devices. The patch introduces three module parameters:
> > 
> >    block_pci_unassigned_write:
> >    Blocks write accesses to unassigned config space regions.
> > 
> >    block_pci_unassigned_read:
> >    Blocks read accesses to unassigned config space regions.
> > 
> >    uaccess_allow_ids:
> >    Specifies the devices for which the above access control is bypassed.
> >    The value is a comma-separated list of device IDs in
> >    <vendor_id>:<device_id> format.
> > 
> >    Example usage:
> >    To block guest write accesses to unassigned config regions for all
> >    passed through devices except for the device with vendor ID 0x1234 and
> >    device ID 0x5678:
> > 
> >    block_pci_unassigned_write=1 uaccess_allow_ids=1234:5678  
> 
> No module parameters please.
> 
> At worst the kernel should maintain a quirks list to control this,
> maybe with a sysfs to update it.

No module parameters might be difficult if we end up managing this as a
default policy selection, but certainly agree that if we get into
device specific behaviors we probably want those quirks automatically
deployed by the kernel.  Thanks,

Alex


