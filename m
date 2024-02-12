Return-Path: <kvm+bounces-8571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BA8A851CA1
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 19:22:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02005B23EA5
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 18:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793B73FE2B;
	Mon, 12 Feb 2024 18:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bQZ9Z6lM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DA03FB1D;
	Mon, 12 Feb 2024 18:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707762140; cv=none; b=MF9khkEG43nv/R2ePKiA6GwwdF8w7NQ1QCTBz+2Cd340VRqDGtYp9penQiiryy/o6l6BvWuV4sM9RLzpzpjUUZsdqSZJw5TAGC9d/EQDHaHIDzOlO1/dLx/Fl/TVR/9HB3GjH2fsdVRpIhZYcbo+X8H7Q6pAqX7/BjrpbR086Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707762140; c=relaxed/simple;
	bh=bnIy5aoiSZyzvqbe1ybrRJcH80Bf+teVdhWsqR+/nMo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AiaaAuy7FWeoNgM2Ui0H16QDNwnHBnFiNhzatWM7hb1rascQ6JutLUdqrsdH0MRocaHayOFM7nfzy2wP63sPTfHsMNkIao2hMku0iAOZ/dPWD3kGre+jvZCYhGnmog3YJVgQHwNh8IjKOVx0bEIm4d93cZuHOk9jGjXjl201x5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bQZ9Z6lM; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707762139; x=1739298139;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bnIy5aoiSZyzvqbe1ybrRJcH80Bf+teVdhWsqR+/nMo=;
  b=bQZ9Z6lMAvRmWg0KTz9WYf3zbg6YxXAwHA0WNeUQPbiOwhGqqRFqBu9Y
   hFqIF1mBylSskB7nGUWg63q6vLOFrnauSksk67LYpw8dX+i3geZMvjxGE
   leJJb+Z7bKNC0CC4x0UC3NXAM0mMB6THPdQ/UTgGnhuAUBTn10teCqs2f
   HSlx6YUU9/V4A6m1KqBqNp9c7suFgp6nA/J5xWOgkkUI2mt9RFK66DfOr
   leb/KMckGSr5ZfGFDieuzwxrIAZ3IJxpSSEIJxsvQxwz+Qzo54RiKumZQ
   RMwrWiNogfB6lJjv7uTZRu7MoOzZbkrVFAotUBm5mmg5v2ULJpsCd+V59
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="1904977"
X-IronPort-AV: E=Sophos;i="6.06,155,1705392000"; 
   d="scan'208";a="1904977"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 10:22:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,155,1705392000"; 
   d="scan'208";a="7409650"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 10:22:15 -0800
Date: Mon, 12 Feb 2024 10:27:42 -0800
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
Message-ID: <20240212102742.34e1e2c2@jacob-builder>
In-Reply-To: <9285b29c-6556-46db-b0bb-7a85ad40d725@kernel.dk>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
	<051cf099-9ecf-4f5a-a3ac-ee2d63a62fa6@kernel.dk>
	<20240209094307.4e7eacd0@jacob-builder>
	<9285b29c-6556-46db-b0bb-7a85ad40d725@kernel.dk>
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

On Fri, 9 Feb 2024 13:31:17 -0700, Jens Axboe <axboe@kernel.dk> wrote:

> On 2/9/24 10:43 AM, Jacob Pan wrote:
> > Hi Jens,
> > 
> > On Thu, 8 Feb 2024 08:34:55 -0700, Jens Axboe <axboe@kernel.dk> wrote:
> >   
> >> Hi Jacob,
> >>
> >> I gave this a quick spin, using 4 gen2 optane drives. Basic test, just
> >> IOPS bound on the drive, and using 1 thread per drive for IO. Random
> >> reads, using io_uring.
> >>
> >> For reference, using polled IO:
> >>
> >> IOPS=20.36M, BW=9.94GiB/s, IOS/call=31/31
> >> IOPS=20.36M, BW=9.94GiB/s, IOS/call=31/31
> >> IOPS=20.37M, BW=9.95GiB/s, IOS/call=31/31
> >>
> >> which is abount 5.1M/drive, which is what they can deliver.
> >>
> >> Before your patches, I see:
> >>
> >> IOPS=14.37M, BW=7.02GiB/s, IOS/call=32/32
> >> IOPS=14.38M, BW=7.02GiB/s, IOS/call=32/31
> >> IOPS=14.38M, BW=7.02GiB/s, IOS/call=32/31
> >> IOPS=14.37M, BW=7.02GiB/s, IOS/call=32/32
> >>
> >> at 2.82M ints/sec. With the patches, I see:
> >>
> >> IOPS=14.73M, BW=7.19GiB/s, IOS/call=32/31
> >> IOPS=14.90M, BW=7.27GiB/s, IOS/call=32/31
> >> IOPS=14.90M, BW=7.27GiB/s, IOS/call=31/32
> >>
> >> at 2.34M ints/sec. So a nice reduction in interrupt rate, though not
> >> quite at the extent I expected. Booted with 'posted_msi' and I do see
> >> posted interrupts increasing in the PMN in /proc/interrupts, 
> >>  
> > The ints/sec reduction is not as high as I expected either, especially
> > at this high rate. Which means not enough coalescing going on to get the
> > performance benefits.  
> 
> Right, it means that we're getting pretty decent commands-per-int
> coalescing already. I added another drive and repeated, here's that one:
> 
> IOPS w/polled: 25.7M IOPS
> 
> Stock kernel:
> 
> IOPS=21.41M, BW=10.45GiB/s, IOS/call=32/32
> IOPS=21.44M, BW=10.47GiB/s, IOS/call=32/32
> IOPS=21.41M, BW=10.45GiB/s, IOS/call=32/32
> 
> at ~3.7M ints/sec, or about 5.8 IOPS / int on average.
> 
> Patched kernel:
> 
> IOPS=21.90M, BW=10.69GiB/s, IOS/call=31/32
> IOPS=21.89M, BW=10.69GiB/s, IOS/call=32/31
> IOPS=21.89M, BW=10.69GiB/s, IOS/call=32/32
> 
> at the same interrupt rate. So not a reduction, but slighter higher
> perf. Maybe we're reaping more commands on average per interrupt.
> 
> Anyway, not a lot of interesting data there, just figured I'd re-run it
> with the added drive.
> 
> > The opportunity of IRQ coalescing is also dependent on how long the
> > driver's hardirq handler executes. In the posted MSI demux loop, it does
> > not wait for more MSIs to come before existing the pending IRQ polling
> > loop. So if the hardirq handler finishes very quickly, it may not
> > coalesce as much. Perhaps, we need to find more "useful" work to do to
> > maximize the window for coalescing.
> > 
> > I am not familiar with optane driver, need to look into how its hardirq
> > handler work. I have only tested NVMe gen5 in terms of storage IO, i saw
> > 30-50% ints/sec reduction at even lower IRQ rate (200k/sec).  
> 
> It's just an nvme device, so it's the nvme driver. The IRQ side is very
> cheap - for as long as there are CQEs in the completion ring, it'll reap
> them and complete them. That does mean that if we get an IRQ and there's
> more than one entry to complete, we will do all of them. No IRQ
> coalescing is configured (nvme kind of sucks for that...), but optane
> media is much faster than flash, so that may be a difference.
> 
Yeah, I also check the the driver code it seems just wake up the threaded
handler.

For the record, here is my set up and performance data for 4 Samsung disks.
IOPS increased from 1.6M per disk to 2.1M. One difference I noticed is that
IRQ throughput is improved instead of reduction with this patch on my setup.
e.g. BEFORE: 185545/sec/vector 
     AFTER:  220128

CPU: (highest non-turbo freq, maybe different on yours).
echo "Set CPU frequency P1 2.7GHz"                                                                      
for i in `seq 0 1 127`; do  echo 2700000 >  /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq ;done
for i in `seq 0 1 127`; do  echo 2700000 >  /sys/devices/system/cpu/cpu$i/cpufreq/scaling_min_freq ;done

PCI:
[root@emr-bkc posted_msi_tests]# lspci -vv -nn -s 0000:64:00.0|grep -e Lnk -e Sam -e nvme                                                   
64:00.0 Non-Volatile memory controller [0108]: Samsung Electronics Co Ltd NVMe SSD Controller PM174X [144d:a826] (prog-if 02 [NVM Express]) 
        Subsystem: Samsung Electronics Co Ltd Device [144d:aa0a]                                                                            
                LnkCap: Port #0, Speed 32GT/s, Width x4, ASPM notsupported                                                                 
                LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled-CommClk+                                                                     
                LnkSta: Speed 32GT/s (ok), Width x4(ok)                                                                                    
                LnkCap2: Supported Link Speeds: 2.5-32GT/s, Crosslink- Retimer+ 2Retimers+ DRS
                LnkCtl2: Target Link Speed: 32GT/s, EnterCompliance- SpeedDis

NVME setup:                                            
nvme5n1       SAMSUNG MZWLO1T9HCJR-00A07                    
nvme6n1       SAMSUNG MZWLO1T9HCJR-00A07                    
nvme3n1       SAMSUNG MZWLO1T9HCJR-00A07                    
nvme4n1       SAMSUNG MZWLO1T9HCJR-00A07                    

FIO:
[global]                      
bs=4k                         
direct=1                      
norandommap                   
ioengine=libaio               
randrepeat=0                  
readwrite=randread            
group_reporting               
time_based                    
iodepth=64                    
exitall                       
random_generator=tausworthe64 
runtime=30                    
ramp_time=3                   
numjobs=8                     
group_reporting=1             
                              
#cpus_allowed_policy=shared   
cpus_allowed_policy=split     
[disk_nvme6n1_thread_1]       
filename=/dev/nvme6n1         
cpus_allowed=0-7       
[disk_nvme6n1_thread_1]
filename=/dev/nvme5n1  
cpus_allowed=8-15      
[disk_nvme5n1_thread_2]
filename=/dev/nvme4n1  
cpus_allowed=16-23     
[disk_nvme5n1_thread_3]
filename=/dev/nvme3n1  
cpus_allowed=24-31     

iostat w/o posted MSI patch, v6.8-rc1:						
nvme3c3n1     1615525.00   6462100.00         0.00         0.00    6462100						
nvme4c4n1     1615471.00   6461884.00         0.00         0.00    6461884						
nvme5c5n1     1615602.00   6462408.00         0.00         0.00    6462408						
nvme6c6n1     1614637.00   6458544.00         0.00         0.00    6458544	

irqtop (delta 1 sec.)					
           IRQ           TOTAL          DELTA NAME                                      							
           800         6290026         185545 IR-PCI-MSIX-0000:65:00.0 76-edge nvme5q76							
           797         6279554         185295 IR-PCI-MSIX-0000:65:00.0 73-edge nvme5q73							
           799         6281627         185200 IR-PCI-MSIX-0000:65:00.0 75-edge nvme5q75							
           802         6285742         185185 IR-PCI-MSIX-0000:65:00.0 78-edge nvme5q78							
	... ... similar irq rate for all 32 vectors

iostat w/ posted MSI patch:
Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd						
nvme3c3n1     2184313.00   8737256.00         0.00         0.00    8737256          0          0						
nvme4c4n1     2184241.00   8736972.00         0.00         0.00    8736972          0          0						
nvme5c5n1     2184269.00   8737080.00         0.00         0.00    8737080          0          0						
nvme6c6n1     2184003.00   8736012.00         0.00         0.00    8736012          0          0						
						
irqtop w/ posted MSI patch:
           IRQ           TOTAL           DELTA NAME                                     							
           PMN      5230078416         5502657 Posted MSI notification event            							
           423       138068935          220128 IR-PCI-MSIX-0000:64:00.0 80-edge nvme4q80							
           425       138057654          219963 IR-PCI-MSIX-0000:64:00.0 82-edge nvme4q82							
           426       138101745          219890 IR-PCI-MSIX-0000:64:00.0 83-edge nvme4q83							
	... ... similar irq rate for all 32 vectors
IRQ coalescing ratio: posted interrupt notification (PMN)/total MSIs = 78%
550/(22*32.)=.78125         


Thanks,

Jacob

