Return-Path: <kvm+bounces-7242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D2EF83E6F5
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:28:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 520A11C24F05
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C741D5B5B4;
	Fri, 26 Jan 2024 23:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dgi7QXBT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711445B5A2;
	Fri, 26 Jan 2024 23:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706311605; cv=none; b=JnZ0meAsY/APqGpQvyiZUkcD2fwKJ3O6xfSKFotkdLsFSx0tzExSyP1tik84P2dIizhu7tOV3UL8lFVqOiIPmCpJVNeuz/y9DLzMIpppLCZpLQgpVsAU98qfbxtytDoMbGG503e11H59yynuj9XOP/2AwjzWt3xXzCkgUnpLebw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706311605; c=relaxed/simple;
	bh=4kglTVeS+XJa2Xp52prmK0+CovRPk+1iqNVnduvL7Lo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JPHmyKgiGJqkCWS8IxxBbik5LN15T630xVSgOxT1cQ2S2xQF+ncP2YvSNUPyOib8FqfQsSv1rLLSWymUyH5oYMKfUfbOD6IpnZDI8tGQN4nqNDAHBmOLNAW2XEG9+Hnuq9J6GvCvI2PXbmOg1cdicn+i4ngIld7d9z4c7QRl1PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dgi7QXBT; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706311604; x=1737847604;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4kglTVeS+XJa2Xp52prmK0+CovRPk+1iqNVnduvL7Lo=;
  b=Dgi7QXBT9VPzqo7y/UBB+1oy3OifjHlkHOaG0CJDZuit+12pNnFC+cw8
   RgTXCGYAIfrw7UkAgtWHJqeNCY551X0p8nzVoZ0ItH1rPwJEx9u4EHGmR
   aH4aTw7JWiZBK1iZQf8d8akgvyq29+cxu9rhKWgUXVx8bp7lE1E9M5RFe
   M1bwm3NfHgC7JqRfUe/yfotxNzXzEWObuhKjzezffa7+aJ+U8j9Q+Qv9H
   MtzEcfRErJyjgbUL8/o1mHZM2MQasrvhq3KmeGGdJCSMJsFt1tcQR5Ver
   ik8ZKv/bbJuQHPPQr7sHc9oCKEuzynD9OdE6xnRYvZz7iGquIl4Sna6TM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="2477208"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="2477208"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:26:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="906457771"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="906457771"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:26:41 -0800
Date: Fri, 26 Jan 2024 15:32:00 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML
 <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>,
 jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH RFC 09/13] x86/irq: Install posted MSI notification
 handler
Message-ID: <20240126153200.720883db@jacob-builder>
In-Reply-To: <87zfyksyge.ffs@tglx>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
 <20231112041643.2868316-10-jacob.jun.pan@linux.intel.com>
 <20231115125624.GF3818@noisy.programming.kicks-ass.net>
 <87cyvjun3z.ffs@tglx>
 <20231207204607.2d2a3b72@jacob-builder>
 <87zfyksyge.ffs@tglx>
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

Hi Thomas,

On Fri, 08 Dec 2023 12:52:49 +0100, Thomas Gleixner <tglx@linutronix.de>
wrote:

> > Without PIR copy:
> >
> > DMA memfill bandwidth: 4.944 Gbps
> > Performance counter stats for './run_intr.sh 512 30':
> > 
> >     77,313,298,506      L1-dcache-loads
> >               (79.98%) 8,279,458      L1-dcache-load-misses     #
> > 0.01% of all L1-dcache accesses  (80.03%) 41,654,221,245
> > L1-dcache-stores                                              (80.01%)
> > 10,476      LLC-load-misses           #    0.31% of all LL-cache
> > accesses  (79.99%) 3,332,748      LLC-loads
> >                         (80.00%) 30.212055434 seconds time elapsed
> > 
> >        0.002149000 seconds user
> > 30.183292000 seconds sys
> >                         
> >
> > With PIR copy:
> > DMA memfill bandwidth: 5.029 Gbps
> > Performance counter stats for './run_intr.sh 512 30':
> >
> >     78,327,247,423      L1-dcache-loads
> >               (80.01%) 7,762,311      L1-dcache-load-misses     #
> > 0.01% of all L1-dcache accesses  (80.01%) 42,203,221,466
> > L1-dcache-stores                                              (79.99%)
> > 23,691      LLC-load-misses           #    0.67% of all LL-cache
> > accesses  (80.01%) 3,561,890      LLC-loads
> >                         (80.00%)
> >
> >       30.201065706 seconds time elapsed
> >
> >        0.005950000 seconds user
> >       30.167885000 seconds sys  
> 
> Interesting, though I'm not really convinced that this DMA memfill
> microbenchmark resembles real work loads.
> 
> Did you test with something realistic, e.g. storage or networking, too?
I have done the following FIO test on NVME drives and not seeing any
meaningful differences in IOPS between the two implementations.

Here is my setup and results on 4 NVME drives connected to a x16 PCIe slot:

 +-[0000:62]-
 |           +-01.0-[63]----00.0  Samsung Electronics Co Ltd NVMe SSD Controller PM174X
 |           +-03.0-[64]----00.0  Samsung Electronics Co Ltd NVMe SSD Controller PM174X
 |           +-05.0-[65]----00.0  Samsung Electronics Co Ltd NVMe SSD Controller PM174X
 |           \-07.0-[66]----00.0  Samsung Electronics Co Ltd NVMe SSD Controller PM174X


libaio, no PIR_COPY
======================================
fio-3.35                                                                                                           
Starting 512 processes                                                                                             
Jobs: 512 (f=512): [r(512)][100.0%][r=32.2GiB/s][r=8445k IOPS][eta 00m:00s]                                        
disk_nvme6n1_thread_1: (groupid=0, jobs=512): err= 0: pid=31559: Mon Jan  8 21:49:22 2024                          
  read: IOPS=8419k, BW=32.1GiB/s (34.5GB/s)(964GiB/30006msec)                                                      
    slat (nsec): min=1325, max=115807k, avg=42368.34, stdev=1517031.57                                             
    clat (usec): min=2, max=499085, avg=15139.97, stdev=25682.25                                                   
     lat (usec): min=68, max=499089, avg=15182.33, stdev=25709.81                                                  
    clat percentiles (usec):                                                                                       
     |  1.00th=[   734],  5.00th=[   783], 10.00th=[   816], 20.00th=[   857],                                     
     | 30.00th=[   906], 40.00th=[   971], 50.00th=[  1074], 60.00th=[  1369],                                     
     | 70.00th=[ 13042], 80.00th=[ 19792], 90.00th=[ 76022], 95.00th=[ 76022],                                     
     | 99.00th=[ 77071], 99.50th=[ 81265], 99.90th=[ 85459], 99.95th=[ 91751],                                     
     | 99.99th=[200279]                                                                                            
   bw (  MiB/s): min=18109, max=51859, per=100.00%, avg=32965.98, stdev=16.88, samples=14839                       
   iops        : min=4633413, max=13281470, avg=8439278.47, stdev=4324.70, samples=14839                           
  lat (usec)   : 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%, 100=0.01%                                                  
  lat (usec)   : 250=0.01%, 500=0.01%, 750=1.84%, 1000=41.96%                                                      
  lat (msec)   : 2=18.37%, 4=0.20%, 10=3.88%, 20=13.95%, 50=5.42%                                                  
  lat (msec)   : 100=14.33%, 250=0.02%, 500=0.01%                                                                  
  cpu          : usr=1.16%, sys=3.54%, ctx=4932752, majf=0, minf=192764                                            
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%                                     
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%                                    
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%                                    
     issued rwts: total=252616589,0,0,0 short=0,0,0,0 dropped=0,0,0,0                                              
     latency   : target=0, window=0, percentile=100.00%, depth=256                                                 
                                                                                                                   
Run status group 0 (all jobs):                                                                                     
   READ: bw=32.1GiB/s (34.5GB/s), 32.1GiB/s-32.1GiB/s (34.5GB/s-34.5GB/s), io=964GiB (1035GB), run=30006-30006msec 
                                                                                                                   
Disk stats (read/write):                                                                                           
  nvme6n1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=96.31%                                                  
  nvme5n1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=97.15%                                                  
  nvme4n1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=98.06%                                                  
  nvme3n1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=98.94%                                                  
                                                                                                                   
 Performance counter stats for 'system wide':                                                                      
                                                                                                                   
    22,985,903,515      L1-dcache-load-misses                                                   (42.86%)           
    22,989,992,126      L1-dcache-load-misses                                                   (57.14%)           
   751,228,710,993      L1-dcache-stores                                                        (57.14%)           
       465,033,820      LLC-load-misses                  #   18.27% of all LL-cache accesses    (57.15%)           
     2,545,570,669      LLC-loads                                                               (57.14%)           
     1,058,582,881      LLC-stores                                                              (28.57%)           
       326,135,823      LLC-store-misses                                                        (28.57%)           
                                                                                                                   
      32.045718194 seconds time elapsed                                                                       
-------------------------------------------
libaio with PIR_COPY
-------------------------------------------
fio-3.35                                                                                                           
Starting 512 processes                                                                                             
Jobs: 512 (f=512): [r(512)][100.0%][r=32.2GiB/s][r=8445k IOPS][eta 00m:00s]                                        
disk_nvme6n1_thread_1: (groupid=0, jobs=512): err= 0: pid=5103: Mon Jan  8 23:12:12 2024                           
  read: IOPS=8420k, BW=32.1GiB/s (34.5GB/s)(964GiB/30011msec)                                                      
    slat (nsec): min=1339, max=97021k, avg=42447.84, stdev=1442726.09                                              
    clat (usec): min=2, max=369410, avg=14820.01, stdev=24112.59                                                   
     lat (usec): min=69, max=369412, avg=14862.46, stdev=24139.33                                                  
    clat percentiles (usec):                                                                                       
     |  1.00th=[   717],  5.00th=[   783], 10.00th=[   824], 20.00th=[   873],                                     
     | 30.00th=[   930], 40.00th=[  1012], 50.00th=[  1172], 60.00th=[  8094],                                     
     | 70.00th=[ 14222], 80.00th=[ 18744], 90.00th=[ 76022], 95.00th=[ 76022],                                     
     | 99.00th=[ 76022], 99.50th=[ 78119], 99.90th=[ 81265], 99.95th=[ 81265],                                     
     | 99.99th=[135267]                                                                                            
   bw (  MiB/s): min=19552, max=62819, per=100.00%, avg=33774.56, stdev=31.02, samples=14540                       
   iops        : min=5005807, max=16089892, avg=8646500.17, stdev=7944.42, samples=14540                           
  lat (usec)   : 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%, 100=0.01%                                                  
  lat (usec)   : 250=0.01%, 500=0.01%, 750=2.50%, 1000=36.41%                                                      
  lat (msec)   : 2=17.39%, 4=0.27%, 10=5.83%, 20=18.94%, 50=5.59%                                                  
  lat (msec)   : 100=13.06%, 250=0.01%, 500=0.01%                                                                  
  cpu          : usr=1.20%, sys=3.74%, ctx=6758326, majf=0, minf=193128                                            
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%                                     
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%                                    
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%                                    
     issued rwts: total=252677827,0,0,0 short=0,0,0,0 dropped=0,0,0,0                                              
     latency   : target=0, window=0, percentile=100.00%, depth=256                                                 
                                                                                                                   
Run status group 0 (all jobs):                                                                                     
   READ: bw=32.1GiB/s (34.5GB/s), 32.1GiB/s-32.1GiB/s (34.5GB/s-34.5GB/s), io=964GiB (1035GB), run=30011-30011msec 
                                                                                                                   
Disk stats (read/write):                                                                                           
  nvme6n1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=96.36%                                                  
  nvme5n1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=97.18%                                                  
  nvme4n1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=98.08%                                                  
  nvme3n1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=98.96%                                                  
                                                                                                                   
 Performance counter stats for 'system wide':                                                                      
                                                                                                                   
    24,762,800,042      L1-dcache-load-misses                                                   (42.86%)           
    24,764,415,765      L1-dcache-load-misses                                                   (57.14%)           
   756,096,467,595      L1-dcache-stores                                                        (57.14%)           
       483,611,270      LLC-load-misses                  #   16.21% of all LL-cache accesses    (57.14%)           
     2,982,610,898      LLC-loads                                                               (57.14%)           
     1,283,077,818      LLC-stores                                                              (28.57%)           
       313,253,711      LLC-store-misses                                                        (28.57%)           
                                                                                                                   
      32.059810215 seconds time elapsed
                                       


Thanks,

Jacob

