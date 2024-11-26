Return-Path: <kvm+bounces-32538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ADC99D9CAA
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 18:37:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 863ABB25C4C
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 17:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744771DB95E;
	Tue, 26 Nov 2024 17:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gcW+Xt6s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33CC1DB37A
	for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 17:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732642476; cv=none; b=X5CO83nN+J34/OyVPIgB9KyHlTVft4Ot8QhMdmiqZbfmD+68RPblwZAMmrxQWv0kkbT68oXMJ5B5Ar+aGzjB2LhD0YlIF1990IwHtZry8TKcFtggWQ4ZbkYT4WrsdipBZi+yefWi8HqcgGkTuSJOHEQlArClzNkkaHNZRNQByNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732642476; c=relaxed/simple;
	bh=q0ByMNEhaDTQ+lVxcgSDW/TcfhsWETINpjBWwEnqHpc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZRRLkCgV75S+ZIhU3MdjM/AbaIis2BV1e+nsXubd5In16Ju/wlM2J9/C7BcjNeH3gXwN9Mu2D5ZV+ElYHKHD1DWBp/47EnVdFcAAP3ssuKGSWihIN0PHHwK97hjYG0Y31TP+PHYRtyAqoGTlWN41eg/RbSZVGYgD4LScToqVUFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gcW+Xt6s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732642473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EUxCmRnLlbMlBvYmauG+9LwobFkOeocCMONjDJD4aRM=;
	b=gcW+Xt6sirbkynGRHpaNF6Xn1Z4eylbkX71l4lseiO+0iQwdBl14ev64iXqCuz7QF9dFBH
	5IhsIGXB1nFAZX+4e/xheB5BcejYr7da/3rJnsonV1Hk1+cg+A7A9dMemMDa7WTQQT161p
	BSZSNaRBKAMl1+r06h5FfTsVxx5Gv7M=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-5UfzMG0VPESB7Kg_TXnv3Q-1; Tue, 26 Nov 2024 12:34:32 -0500
X-MC-Unique: 5UfzMG0VPESB7Kg_TXnv3Q-1
X-Mimecast-MFC-AGG-ID: 5UfzMG0VPESB7Kg_TXnv3Q
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-841953497e2so6575939f.1
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 09:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732642472; x=1733247272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EUxCmRnLlbMlBvYmauG+9LwobFkOeocCMONjDJD4aRM=;
        b=ebkHiTVnfyjIiyNoClAOGypdjjaGRDu79DgRbwx0MBBTYAD58G135eCZt5PEVpBaDg
         1Aj8/mVRidUWT27Tjp2+iJqIuersKkn5VxCDdYkMwOqOrHD0Odn9dQwDMUJKFJqAiLBc
         9YT7mmYE9rKwLftGM/y+tYdJv8T4+1oKYxBcRJxCxDVVeY2xKKaJ2811Obsyqfoup3XV
         4/D1upyse9VinSKEKofT7TgEl0tbxc0x/XquoJw7eOuauWlLsLAewC6fBB92u1kCFLS8
         otxZCNHM0mYBqPNGuLDHKhLtfjhjNI2fcLcozw25xLCJRn+LFgAjSLV6H5xWj+0M+eMU
         9ezw==
X-Forwarded-Encrypted: i=1; AJvYcCV5vNsmUTApZgAnp/l0WlmnvpO6AaZHLLrrpeShbLw5C7KGd/zLPihJpAon9mQhKN5d6jI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxEyAL7QD667m+Ad0fJ1u9x2oYcJf9lC/blk0u74DtTrkVVQe4
	9RqhQ22itKVPOesG5tQLKWQunivGbG/eXhEQf3fpykaD2m80jFf3TNmAkemS8bZlBKrd3zwBs3A
	Vf1mTtnLIFnnAJCBEJstPL/Kr4Dg98qlB26uQN6Dr+JTf/FwKLQ==
X-Gm-Gg: ASbGncs3lftGqz4R9S3Bf63T6mzDnkP9whGsm/Sgd/Wfl4KQeHougOCSNqvTyYK2AcH
	tSWkCS9JTzJOnYcnWbBvSc6x6AeeNST4SY5PbZvLArKcy+EbyyA/BiLBASFfSrM8kOiqJFdyeG7
	0CPuVW5bEmcqtWy7qcym4PTJlYRMYB7CqeI37r14kLfl3mOs96CZSJOPAv3giox0cGKUmHXnFxc
	qlXJE8gu51d3LCox6cCV/aWD0v7tBAigo21FxR/sRlqT6l1er0uPQ==
X-Received: by 2002:a92:cda4:0:b0:3a7:bc95:bbd6 with SMTP id e9e14a558f8ab-3a7bc95bcb8mr10966955ab.6.1732642471735;
        Tue, 26 Nov 2024 09:34:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHlDEOpooeRabFqJWdYwePFt6/rb7FbwwqP2DVATOmqA2U8r9tTin22BuAaFzu1Ts7X6p4YgQ==
X-Received: by 2002:a92:cda4:0:b0:3a7:bc95:bbd6 with SMTP id e9e14a558f8ab-3a7bc95bcb8mr10966885ab.6.1732642471290;
        Tue, 26 Nov 2024 09:34:31 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a79ab86c77sm22706925ab.4.2024.11.26.09.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2024 09:34:30 -0800 (PST)
Date: Tue, 26 Nov 2024 10:34:27 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Mitchell Augustin <mitchell.augustin@canonical.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, Bjorn Helgaas
 <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Subject: Re: drivers/pci: (and/or KVM): Slow PCI initialization during VM
 boot with passthrough of large BAR Nvidia GPUs on DGX H100
Message-ID: <20241126103427.42d21193.alex.williamson@redhat.com>
In-Reply-To: <CAHTA-uYp07FgM6T1OZQKqAdSA5JrZo0ReNEyZgQZub4mDRrV5w@mail.gmail.com>
References: <CAHTA-uYp07FgM6T1OZQKqAdSA5JrZo0ReNEyZgQZub4mDRrV5w@mail.gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 Nov 2024 16:46:29 -0600
Mitchell Augustin <mitchell.augustin@canonical.com> wrote:

> Hello,
> 
> I've been working on a bug regarding slow PCI initialization and BAR
> assignment times for Nvidia GPUs passed-through to VMs on our DGX H100
> that I originally believed to be an issue in OVMF, but upon further
> investigation, I'm now suspecting that it may be an issue somewhere in
> the kernel. (Here is the original edk2 mailing list thread, with extra
> context: https://edk2.groups.io/g/devel/topic/109651206) [0]
> 
> 
> When running the 6.12 kernel on a DGX H100 host with 4 GPUs passed
> through using CPU passthrough and this virt-install command[1], VMs
> using the latest OVMF version will take around 2 minutes for the guest
> kernel to boot and initialize PCI devices/BARs for the GPUs.
> Originally, I was investigating this as an issue in OVMF, because GPU
> initialization takes much less time when our host is running an OVMF
> version with this patch[2] removed (which only calculates the MMIO
> window size differently). Without that patch, the guest kernel does
> boot quickly, but we can only use the Nvidia GPUs within the guest if
> `pci=nocrs pci=realloc` are set in the guest (evidently since the MMIO
> windows advertised by OVMF to the kernel without this patch are
> incorrect). So, the OVMF patch being present does evidently result in
> correct MMIO windows and prevent us from needing those kernel options,
> but the VM boot time is much slower.
> 
> 
> In discussing this, another contributor reported slow PCIe/BAR
> initialization times for large BAR Nvidia GPUs in Linux when using VMs
> with SeaBIOS as well. This, combined with me not seeing any slowness
> when these GPUs are initialized on the host, and the fact that this
> slowness only happens when CPU passthrough is used, are leading me to
> suspect that this may actually be a problem somewhere in the KVM or
> vfio-pci stack. I did also attempt manually setting different MMIO
> window sizes using the X-PciMmio64Mb OVMF/QEMU knob, and it seems that
> any MMIO window size large enough to accommodate all GPU memory
> regions does result in this slower initialization time (but also a
> valid mapping).

The VM needs to be given enough 64-bit MMIO space for the devices, at
which point the BIOS should be able to fully assign the BARs and then
pci=nocrs,realloc should not be necessary. 
 
> I did some profiling of the guest kernel during boot, and I've
> identified that it seems like the most time is spent in this
> pci_write_config_word() call in __pci_read_base() of
> drivers/pci/probe.c.[3] Each of those pci_write_config_word() calls
> takes about 2 seconds, but it adds up to a significant chunk of the
> initialization time since __pci_read_base() is executed somewhere
> between 20-40 times in my VM boot.

A lot happens in the VMM when the memory enable bit is set in the
command register.  This is when the MMIO BARs of the device enter the
AddressSpace in QEMU and are caught by the MemoryListener to create DMA
mappings though the IOMMU.  The BAR space is walked, faulted, and
mapped.  I'm sure you're at least experiencing scaling issues of that
with 128GB BARs.

Are you seeing __pci_read_base() called 20-40 times repeatedly for a
given device or in total for the VM boot.  Minimally it needs to be
called once for every PCI device, so it's not clear to me if you're
reporting something excessive based on using pci=realloc or there are
just enough devices to justify this many calls.

> As a point of comparison, I measured the time it took to hot-unplug
> and re-plug these GPUs after the VM booted, and observed much more
> reasonable times (under 5s for each GPU to re-initialize its memory
> regions). I've also been trying to get this hotplugging working in VMs
> where the GPUs aren't initially attached at boot, but in any such
> configuration, the memory regions for the PCI slots that the GPUs get
> attached to during hotplug are too small for the full 128GB these GPUs
> require (and I have yet to figure out a way to fix that. More details
> on that in [0]).

If 5s is the measure of enabling one GPU, the VM BIOS will need to do
that at least once and the guest OS will need to do that at least once,
we're up to 4 GPUs * 5s * 2 times = 40s.  If the guest OS toggles
memory enable more than once, your 2 minute boot time isn't sounding
too far off.  Then there's also the fact that the VM appears to be
given 900+GB of RAM, which also needs to be pinned and mapped for DMA
and there's no indication I can find in virt-install command of using
hugepages.

There are essentially two things in play here, how long does it take to
map that BAR into the VM address space, and how many times is it done.
I know there's room to improve the former.  We just recently added
kernel support for pgd and pmd large page mapping for pfnmap regions
and QEMU 9.2-rc includes alignment of vfio-pci BARs to try to optimize
that towards pgd where possible.  We're still trying to pin individual
pages though, so percolating the mapping sizes up through the vfio
IOMMU backend could help.  Thanks,

Alex


