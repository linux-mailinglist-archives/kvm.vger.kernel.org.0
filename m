Return-Path: <kvm+bounces-8573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 251CA851E70
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 21:08:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 911BEB261DD
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 20:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7D8481AD;
	Mon, 12 Feb 2024 20:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N3T+hmLS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2AD47A73;
	Mon, 12 Feb 2024 20:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707768503; cv=none; b=t780HZL7eG41UfVKSb2A6qO1wjIN57UBeOlEyurve/tnta8C6kXW5PQ1JhqntaI6nAat3PS0j7i8X3YhrlLr56QpJC1ShAKRQsVRa58adsPFg9CGDXAaVRBexrxSCsKwdMo9gObMgad5cuDC2+LhvNk4oa9gv99GN9CYSUqLDjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707768503; c=relaxed/simple;
	bh=2K9Jkx7Dbx+wU3PTYaguUrfmvf8b4+S7YQdNN1Rasms=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KBJzlbc8iAwFtTsMfzjA5re0H80XvVOy8hpTQnFoiEVJ3PnYoS5xeLrLhRD7tBHYsUBNreYOHiPoPlRTBdEENKGbJbC30qi76KvIgnBLW1L9I1AEcBsTJxsL3HKi9YrG5IfelammhbfShvsbIe9Djxz69gDAoIXAqu1uquVwzVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N3T+hmLS; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707768502; x=1739304502;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2K9Jkx7Dbx+wU3PTYaguUrfmvf8b4+S7YQdNN1Rasms=;
  b=N3T+hmLSoWp93KuiX7S6l018QIDfjp6G+kogirbqBIQUaay677JWlQ7T
   Y/TJEuTBjM3xxfxdeZWfJUsxJVpVvbj3jWAjBR2wNrNbdErrtJI80zThu
   jBPejs7hnbVdQgcEehQew9doGuUbjqLQjghJ5jJOHUk9cVDSRqPSGszt3
   iCv2fHB9RdWl3gscqYVS+q2Ow+5WTt88MB7i34/JTH1bomQrNvmdC5tcg
   e42vDvRHJaBZzVtP3j0s3s6LomdwJNv3GGpO40l86hDtBg+AwHu31KMLc
   ydtZf9XKXGy+j8ilqRJuPc/7Vetz/+aiWK710QefrF3sHGgXK+V6Elyhs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="1909065"
X-IronPort-AV: E=Sophos;i="6.06,155,1705392000"; 
   d="scan'208";a="1909065"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 12:08:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,155,1705392000"; 
   d="scan'208";a="7314343"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 12:08:19 -0800
Date: Mon, 12 Feb 2024 12:13:46 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Thomas Gleixner
 <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Paul Luse
 <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>,
 jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH 00/15] Coalesced Interrupt Delivery with posted MSI
Message-ID: <20240212121346.0f8870a7@jacob-builder>
In-Reply-To: <2aa290eb-ec4b-43b1-87db-4df8ccbeaa37@kernel.dk>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
	<051cf099-9ecf-4f5a-a3ac-ee2d63a62fa6@kernel.dk>
	<20240209094307.4e7eacd0@jacob-builder>
	<9285b29c-6556-46db-b0bb-7a85ad40d725@kernel.dk>
	<20240212102742.34e1e2c2@jacob-builder>
	<2aa290eb-ec4b-43b1-87db-4df8ccbeaa37@kernel.dk>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Jens,

On Mon, 12 Feb 2024 11:36:42 -0700, Jens Axboe <axboe@kernel.dk> wrote:

> On 2/12/24 11:27 AM, Jacob Pan wrote:
> > Hi Jens,
> > 
> > On Fri, 9 Feb 2024 13:31:17 -0700, Jens Axboe <axboe@kernel.dk> wrote:
> >   
> >> On 2/9/24 10:43 AM, Jacob Pan wrote:  
> >>> Hi Jens,
> >>>
> >>> On Thu, 8 Feb 2024 08:34:55 -0700, Jens Axboe <axboe@kernel.dk> wrote:
> >>>     
> >>>> Hi Jacob,
> >>>>
> >>>> I gave this a quick spin, using 4 gen2 optane drives. Basic test,
> >>>> just IOPS bound on the drive, and using 1 thread per drive for IO.
> >>>> Random reads, using io_uring.
> >>>>
> >>>> For reference, using polled IO:
> >>>>
> >>>> IOPS=20.36M, BW=9.94GiB/s, IOS/call=31/31
> >>>> IOPS=20.36M, BW=9.94GiB/s, IOS/call=31/31
> >>>> IOPS=20.37M, BW=9.95GiB/s, IOS/call=31/31
> >>>>
> >>>> which is abount 5.1M/drive, which is what they can deliver.
> >>>>
> >>>> Before your patches, I see:
> >>>>
> >>>> IOPS=14.37M, BW=7.02GiB/s, IOS/call=32/32
> >>>> IOPS=14.38M, BW=7.02GiB/s, IOS/call=32/31
> >>>> IOPS=14.38M, BW=7.02GiB/s, IOS/call=32/31
> >>>> IOPS=14.37M, BW=7.02GiB/s, IOS/call=32/32
> >>>>
> >>>> at 2.82M ints/sec. With the patches, I see:
> >>>>
> >>>> IOPS=14.73M, BW=7.19GiB/s, IOS/call=32/31
> >>>> IOPS=14.90M, BW=7.27GiB/s, IOS/call=32/31
> >>>> IOPS=14.90M, BW=7.27GiB/s, IOS/call=31/32
> >>>>
> >>>> at 2.34M ints/sec. So a nice reduction in interrupt rate, though not
> >>>> quite at the extent I expected. Booted with 'posted_msi' and I do see
> >>>> posted interrupts increasing in the PMN in /proc/interrupts, 
> >>>>    
> >>> The ints/sec reduction is not as high as I expected either, especially
> >>> at this high rate. Which means not enough coalescing going on to get
> >>> the performance benefits.    
> >>
> >> Right, it means that we're getting pretty decent commands-per-int
> >> coalescing already. I added another drive and repeated, here's that
> >> one:
> >>
> >> IOPS w/polled: 25.7M IOPS
> >>
> >> Stock kernel:
> >>
> >> IOPS=21.41M, BW=10.45GiB/s, IOS/call=32/32
> >> IOPS=21.44M, BW=10.47GiB/s, IOS/call=32/32
> >> IOPS=21.41M, BW=10.45GiB/s, IOS/call=32/32
> >>
> >> at ~3.7M ints/sec, or about 5.8 IOPS / int on average.
> >>
> >> Patched kernel:
> >>
> >> IOPS=21.90M, BW=10.69GiB/s, IOS/call=31/32
> >> IOPS=21.89M, BW=10.69GiB/s, IOS/call=32/31
> >> IOPS=21.89M, BW=10.69GiB/s, IOS/call=32/32
> >>
> >> at the same interrupt rate. So not a reduction, but slighter higher
> >> perf. Maybe we're reaping more commands on average per interrupt.
> >>
> >> Anyway, not a lot of interesting data there, just figured I'd re-run it
> >> with the added drive.
> >>  
> >>> The opportunity of IRQ coalescing is also dependent on how long the
> >>> driver's hardirq handler executes. In the posted MSI demux loop, it
> >>> does not wait for more MSIs to come before existing the pending IRQ
> >>> polling loop. So if the hardirq handler finishes very quickly, it may
> >>> not coalesce as much. Perhaps, we need to find more "useful" work to
> >>> do to maximize the window for coalescing.
> >>>
> >>> I am not familiar with optane driver, need to look into how its
> >>> hardirq handler work. I have only tested NVMe gen5 in terms of
> >>> storage IO, i saw 30-50% ints/sec reduction at even lower IRQ rate
> >>> (200k/sec).    
> >>
> >> It's just an nvme device, so it's the nvme driver. The IRQ side is very
> >> cheap - for as long as there are CQEs in the completion ring, it'll
> >> reap them and complete them. That does mean that if we get an IRQ and
> >> there's more than one entry to complete, we will do all of them. No IRQ
> >> coalescing is configured (nvme kind of sucks for that...), but optane
> >> media is much faster than flash, so that may be a difference.
> >>  
> > Yeah, I also check the the driver code it seems just wake up the
> > threaded handler.  
> 
> That only happens if you're using threaded interrupts, which is not the
> default as it's much slower. What happens for the normal case is that we
> init a batch, and then poll the CQ ring for completions, and then add
> them to the completion batch. Once no more are found, we complete the
> batch.
> 
thanks for the explanation.

> You're not using threaded interrupts, are you?
No. I didn't add module parameter "use_threaded_interrupts"

> 
> > For the record, here is my set up and performance data for 4 Samsung
> > disks. IOPS increased from 1.6M per disk to 2.1M. One difference I
> > noticed is that IRQ throughput is improved instead of reduction with
> > this patch on my setup. e.g. BEFORE: 185545/sec/vector 
> >      AFTER:  220128  
> 
> I'm surprised at the rates being that low, and if so, why the posted MSI
> makes a difference? Usually what I've seen for IRQ being slower than
> poll is if interrupt delivery is unreasonably slow on that architecture
> of machine. But ~200k/sec isn't that high at all.
> 


> > [global]                      
> > bs=4k                         
> > direct=1                      
> > norandommap                   
> > ioengine=libaio               
> > randrepeat=0                  
> > readwrite=randread            
> > group_reporting               
> > time_based                    
> > iodepth=64                    
> > exitall                       
> > random_generator=tausworthe64 
> > runtime=30                    
> > ramp_time=3                   
> > numjobs=8                     
> > group_reporting=1             
> >                               
> > #cpus_allowed_policy=shared   
> > cpus_allowed_policy=split     
> > [disk_nvme6n1_thread_1]       
> > filename=/dev/nvme6n1         
> > cpus_allowed=0-7       
> > [disk_nvme6n1_thread_1]
> > filename=/dev/nvme5n1  
> > cpus_allowed=8-15      
> > [disk_nvme5n1_thread_2]
> > filename=/dev/nvme4n1  
> > cpus_allowed=16-23     
> > [disk_nvme5n1_thread_3]
> > filename=/dev/nvme3n1  
> > cpus_allowed=24-31       
> 
> For better performance, I'd change that engine=libaio to:
> 
> ioengine=io_uring
> fixedbufs=1
> registerfiles=1
> 
> Particularly fixedbufs makes a big difference, as a big cycle consumer
> is mapping/unmapping pages from the application space into the kernel
> for O_DIRECT. With fixedbufs=1, this is done once and we just reuse the
> buffers. At least for my runs, this is ~15% of the systime for doing IO.
> It also removes the page referencing, which isn't as big a consumer, but
> still noticeable.
> 
Indeed, the CPU utilization system time goes down significantly. I got the
following with posted MSI patch applied:
Before (aio):
  read: IOPS=8925k, BW=34.0GiB/s (36.6GB/s)(1021GiB/30001msec)
	user    3m25.156s                                                                                                           	
	sys     11m16.785s                                                                                                          	
						
After (fixedbufs, iouring engine):
  read: IOPS=8811k, BW=33.6GiB/s (36.1GB/s)(1008GiB/30002msec)
  	user    2m56.255s                                                                                                  	
	sys     8m56.378s                                                                                                  	
				
It seems to have no gain in IOPS, just CPU utilization reduction.

Both have improvement over libaio w/o posted MSI patch. 

> Anyway, side quest, but I think you'll find this considerably reduces
> overhead / improves performance. Also makes it so that you can compare
> with polled IO on nvme, which aio can't do. You'd just add hipri=1 as an
> option for that (with a side note that you need to configure nvme poll
> queues, see the poll_queues parameter).
> 
> On my box, all the NVMe devices seem to be on node1, not node0 which
> looks like it's the CPUs you are using. Might be worth checking and
> adjusting your CPU domains for each drive? I also tend to get better
> performance by removing the CPU scheduler, eg just pin each job to a
> single CPU rather than many. It's just one process/thread anyway, so
> really no point in giving it options here. It'll help reduce variability
> too, which can be a pain in the butt to deal with.
> 
Much faster with poll_queues=32 (32jobs)
  read: IOPS=13.0M, BW=49.6GiB/s (53.3GB/s)(1489GiB/30001msec)
     	user    2m29.177s
	sys     15m7.022s
				
Observed no IRQ counts from NVME.

Thanks,

Jacob

