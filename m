Return-Path: <kvm+bounces-20902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08F6992654A
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 17:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B402A1F218D2
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 15:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86BF8181CE6;
	Wed,  3 Jul 2024 15:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kc+qeyNj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969D11DA319;
	Wed,  3 Jul 2024 15:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720021880; cv=none; b=gPZ0ZMwK9fy6sULBw1EJZJkMqBCP5SXBcZzxdV2OnbMUdo9Iw/48GTmesXZ0QsufKzuuvfjDktYKYwd2TR+So8d/bfremT3l0BNHJWhJjCz4gmKugCwHj1wTzxLmhsbGTPL1im8eNCq43AAWlLOi34c9VKTp5xmfI90gDugjrkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720021880; c=relaxed/simple;
	bh=M2TBqenJePHMkynb5A1SIOpLVmH3H7D/iXSAlQYnb5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UUm/28Twm7s/sqY77yJk1LqAvO5F4uvBi6ZK8M7z3P4tOiw9qq2oTwamY6kL0FOLj0l4CePb4rJhNkfLSDKrFYYEZf4pIjRmVbrcs+gSMQ1IQIQJRZ7y5gfoWbPbcj7K+n/D3lCzQv1dvGpUEoDlakc7MiIQ/L2ZPtrkXNQH7U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kc+qeyNj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E69C2BD10;
	Wed,  3 Jul 2024 15:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720021880;
	bh=M2TBqenJePHMkynb5A1SIOpLVmH3H7D/iXSAlQYnb5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kc+qeyNjcvMfXoLoLSYrV/OjBmRYjN560U9rM5g1KNtJfyhDmn8WFYPVUX8lcMSL6
	 khJVCU+KU0IiJB0lH+20qj4DzqeRN3kur43qZjoGlHey1qRNicXUsAjw8d2newAM5x
	 C+2La9qYNOaB19TaKRZeUR8kFkS7h1waDmf4ltPCmAiGBKFugxc54BFHXWm/8SeN1a
	 GFdr9hsxxrrrevbZ0JCLF/Lyi27Mu1ricAFJVROJUceiw5jv8XbgqQBBd0Xa8n4q+N
	 RK6NYvdVvLuJ0x0RwfmANnmb6Fu17VSB8t/0ZiSc4qAzbWALiN0J6a9hx7YlBm/nHW
	 7fUJVXY2mTrPQ==
Date: Wed, 3 Jul 2024 18:51:14 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Keith Busch <kbusch@kernel.org>,
	"Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Message-ID: <20240703155114.GB95824@unreal>
References: <cover.1719909395.git.leon@kernel.org>
 <20240703054238.GA25366@lst.de>
 <20240703105253.GA95824@unreal>
 <20240703143530.GA30857@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703143530.GA30857@lst.de>

On Wed, Jul 03, 2024 at 04:35:30PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 03, 2024 at 01:52:53PM +0300, Leon Romanovsky wrote:
> > On Wed, Jul 03, 2024 at 07:42:38AM +0200, Christoph Hellwig wrote:
> > > I just tried to boot this on my usual qemu test setup with emulated
> > > nvme devices, and it dead-loops with messages like this fairly late
> > > in the boot cycle:
> > > 
> > > [   43.826627] iommu: unaligned: iova 0xfff7e000 pa 0x000000010be33650 size 0x1000 min_pagesz 0x1000
> > > [   43.826982] dma_mapping_error -12
> > > 
> > > passing intel_iommu=off instead of intel_iommu=on (expectedly) makes
> > > it go away.
> > 
> > Can you please share your kernel command line and qemu?
> > On my and Chaitanya setups it works fine.
> 
> qemu-system-x86_64 \
>         -nographic \
> 	-enable-kvm \
> 	-m 6g \
> 	-smp 4 \
> 	-cpu host \
> 	-M q35,kernel-irqchip=split \
> 	-kernel arch/x86/boot/bzImage \
> 	-append "root=/dev/vda console=ttyS0,115200n8 intel_iommu=on" \
>         -device intel-iommu,intremap=on \
> 	-device ioh3420,multifunction=on,bus=pcie.0,id=port9-0,addr=9.0,chassis=0 \	
>         -blockdev driver=file,cache.direct=on,node-name=root,filename=/home/hch/images/bookworm.img \
> 	-blockdev driver=host_device,cache.direct=on,node-name=test,filename=/dev/nvme0n1p4 \
> 	-device virtio-blk,drive=root \
> 	-device nvme,drive=test,serial=1234

Thanks, Chaitanya will take a look.

If we put aside this issue, do you think that the proposed API is the right one?

BTW, I have more fancy command line, it is probably the root cause of working/not-working:
/opt/simx/bin/qemu-system-x86_64
        -append root=/dev/root rw ignore_loglevel rootfstype=9p
        rootflags="cache=loose,trans=virtio" earlyprintk=serial,ttyS0,115200
                console=hvc0 noibrs noibpb nopti nospectre_v2 nospectre_v1
                l1tf=off nospec_store_bypass_disable no_stf_barrier mds=off
                mitigations=off panic_on_warn=1
                intel_iommu=on iommu=nopt iommu.forcedac=true
                vfio_iommu_type1.allow_unsafe_interrupts=1
                systemd.hostname=mtl-leonro-l-vm
        -chardev stdio,id=stdio,mux=on,signal=off   
        -cpu host                                  
        -device virtio-rng-pci                    
        -device virtio-balloon-pci               
        -device isa-serial,chardev=stdio        
        -device virtio-serial-pci              
        -device virtconsole,chardev=stdio     
        -device virtio-9p-pci,fsdev=host_fs,mount_tag=/dev/root  
        -device virtio-9p-pci,fsdev=host_bind_fs0,mount_tag=bind0
        -device virtio-9p-pci,fsdev=host_bind_fs1,mount_tag=bind1
        -device virtio-9p-pci,fsdev=host_bind_fs2,mount_tag=bind2
        -device intel-iommu,intremap=on 
        -device connectx7              
        -device nvme,drive=drv0,serial=foo 
        -drive file=/home/leonro/.cache/mellanox/mkt/nvme-1g.raw,if=none,id=drv0,format=raw 
        -enable-kvm                                                                        
        -fsdev local,id=host_bind_fs1,security_model=none,path=/logs          
        -fsdev local,id=host_fs,security_model=none,path=/mnt/self           
        -fsdev local,id=host_bind_fs0,security_model=none,path=/plugins     
        -fsdev local,id=host_bind_fs2,security_model=none,path=/home/leonro
        -fw_cfg etc/sercon-port,string=2  
        -kernel /home/leonro/src/kernel/arch/x86/boot/bzImage 
        -m 5G -machine q35,kernel-irqchip=split              
        -mon chardev=stdio                                  
        -net nic,model=virtio,macaddr=52:54:01:d8:e5:f9    
        -net user,hostfwd=tcp:127.0.0.1:46645-:22  
        -no-reboot -nodefaults -nographic -smp 16 -vga none 

> 
> 

