Return-Path: <kvm+bounces-8572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAEB0851CE2
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 19:36:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A0A11C22211
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 18:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 695DF405D4;
	Mon, 12 Feb 2024 18:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sZ3kUerr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682FF45BE6
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 18:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707763007; cv=none; b=dRghuZHxZXrgnjiyi8KaEKzDVpHVMXhWJzNMlh9zGy6YVKw0oNZj+bw4TfIUjHNi6iPbZ5puAOFliWJhPks/NA+waMJDWrfWc7+3cdqYAlcyM8hw4FGfB+Oa5kQQRFHHN6fsC7Y5qnsiXkYjw5XAxXnzvhSb5IJ5C++nWspg5sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707763007; c=relaxed/simple;
	bh=m8jYFCrSiAHQCrclsFFugQkVkQ8mNvCBEUbX8VM2B3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bew1t6/xZTptuwXjtNwgiBZmydmPR0kKA40xfuhsmsSaAwNyXQMfhgIB9/K6TmPxRTBn2vrLkxiryCkrdGLAtR23o+ZJHbhZKXVMcV7o5lEiruvKnNe8audFCBakmZubXDQ+E9cCsVe6b+83gJ7cyTTov5MvQPhKkqc/Mg+EMkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sZ3kUerr; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-35d374bebe3so4801705ab.1
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 10:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707763004; x=1708367804; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QamGh/bSN8B/QUCshCi8/HvCoWOBlZLPzsuAV9yhvF0=;
        b=sZ3kUerrX1wuctlMN4KUvBiHcj8BOzmfmdwgZxoRXJh6A2NtrqvVX1yJdlK7BM7QT0
         WvMVyY9BYOK8/1PxQ/fxVbNJsY8KkJZJ0dQXvCYtlKrZZREbfW+MOQRzsU2qNgMFlCpM
         nRTbwryeBSjo9TNJFiv8D+Ijj+gy8d4oPweqMJtoWSB+EDAWxOye8sj89KkOUctgLEs1
         AQRII2ABeB/TMdCN/1b5hDkprcN7GZM+tYNoTdm5isOkuph/tOlVZQmkcu5Xm0KS1JB1
         eKbhmT44tMXgAMHuJPeMymZk8D12w5Jz3yA1/zDCRxSj/J0WNkHsUJmgxdYL8+DlkxYz
         6PZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707763004; x=1708367804;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QamGh/bSN8B/QUCshCi8/HvCoWOBlZLPzsuAV9yhvF0=;
        b=HIcIRJzPyH/fetHWOjOo3gGyhu3IYB8fF2t8zZ8bL2DRd7pneQKUiX+AW7Fh81OktE
         bEivZfM3uh4tlar6tO/enknyb5CztZpcVuX/E3RE2Dxk972352psYYVNjc+irJM9sW1W
         dMIhTimEhc/RVvSeWA11T6O7RRgq9Bl+nmIojCIuWJ47lBe+FXCN/ltEyyMZG1xSofyJ
         uhlo5dRV6X8rr+CgcVhv91shbPp6LVkdmQmcCo1ahqneN7pdIqjMUee65Y+VW/YhzQdX
         pyvbUS9tEWaW/HSiB3xGGTBX6JG4mVAd2ICuQg8Towkhf7zWfZ9tKWlM3GwXzBPEdLd+
         eIbg==
X-Gm-Message-State: AOJu0YzvFX5U4LufTtKZE1GF/wj5FrZGfaqOGaXNZm2ijqBsRwpg8/DC
	7AVM/9NEFvvSPy93PA3XGA4LBy0pdzLdeImIObdKuwcsIwhTIGNJb8iOQ9Fn0j4=
X-Google-Smtp-Source: AGHT+IGx6UQ1RmewCkB263/NEIp8AIh9XRrVDN/CzTI5LD8F8RcBh7WZSovuc7AMI02CREDfWILuew==
X-Received: by 2002:a05:6602:2c41:b0:7c4:5898:11d0 with SMTP id x1-20020a0566022c4100b007c4589811d0mr6176466iov.1.1707763004363;
        Mon, 12 Feb 2024 10:36:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXVJNEWyA0uLfG1KCQYyFnbZS6dUF/q18fJLotyRTkoB71luThdqtt/fYhsZtKzXR4OefxNFpCAzmRDEZt84gpU+K4IU4WtGW1WE56CX9tQJvjVYnOQos6IsYVhvu3aPBggPWiOY7p5RjbWtAeEBmcCdpVCf5Qa/8lqdHDUwgEelbcyf4ooD9ZQgpZ0ZZxVMpNApdZEBynHueLOQFdoOAYL7lTeeU1sTpHeavUScHlMwSUrASo364ktR0RDz/1O2djdYmLOmzRlnLjRlFhDpn4cOmECIkNYeyhyrnrqZ5icYn3+gsWDyWy4NUPNTd9hP+e0QGfZyCcfu5IRMa9/gnmItBZxvKSQ9t0kVY//4fpobw+anEm465/cjdQFNJhTu4B70iScGwOjGVvmjZniXupW/jH037IEEsHjfIKBCfoK5wJ3k+xoavt4DCzeLwdaTYbAvm6VlGeZbvSRaKCxICuB48Tew97/Dhoni9XFxnALqulXXzFSR5Uy1Cc60SF6taTL4oVAIV0D2E7nySG9Jpmt1mlXjKSZ4fQaPw==
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e22-20020a6b6916000000b007c422dfb2f0sm1738311ioc.35.2024.02.12.10.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 10:36:43 -0800 (PST)
Message-ID: <2aa290eb-ec4b-43b1-87db-4df8ccbeaa37@kernel.dk>
Date: Mon, 12 Feb 2024 11:36:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] Coalesced Interrupt Delivery with posted MSI
Content-Language: en-US
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
 Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
 Paul Luse <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
 <051cf099-9ecf-4f5a-a3ac-ee2d63a62fa6@kernel.dk>
 <20240209094307.4e7eacd0@jacob-builder>
 <9285b29c-6556-46db-b0bb-7a85ad40d725@kernel.dk>
 <20240212102742.34e1e2c2@jacob-builder>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240212102742.34e1e2c2@jacob-builder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/12/24 11:27 AM, Jacob Pan wrote:
> Hi Jens,
> 
> On Fri, 9 Feb 2024 13:31:17 -0700, Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 2/9/24 10:43 AM, Jacob Pan wrote:
>>> Hi Jens,
>>>
>>> On Thu, 8 Feb 2024 08:34:55 -0700, Jens Axboe <axboe@kernel.dk> wrote:
>>>   
>>>> Hi Jacob,
>>>>
>>>> I gave this a quick spin, using 4 gen2 optane drives. Basic test, just
>>>> IOPS bound on the drive, and using 1 thread per drive for IO. Random
>>>> reads, using io_uring.
>>>>
>>>> For reference, using polled IO:
>>>>
>>>> IOPS=20.36M, BW=9.94GiB/s, IOS/call=31/31
>>>> IOPS=20.36M, BW=9.94GiB/s, IOS/call=31/31
>>>> IOPS=20.37M, BW=9.95GiB/s, IOS/call=31/31
>>>>
>>>> which is abount 5.1M/drive, which is what they can deliver.
>>>>
>>>> Before your patches, I see:
>>>>
>>>> IOPS=14.37M, BW=7.02GiB/s, IOS/call=32/32
>>>> IOPS=14.38M, BW=7.02GiB/s, IOS/call=32/31
>>>> IOPS=14.38M, BW=7.02GiB/s, IOS/call=32/31
>>>> IOPS=14.37M, BW=7.02GiB/s, IOS/call=32/32
>>>>
>>>> at 2.82M ints/sec. With the patches, I see:
>>>>
>>>> IOPS=14.73M, BW=7.19GiB/s, IOS/call=32/31
>>>> IOPS=14.90M, BW=7.27GiB/s, IOS/call=32/31
>>>> IOPS=14.90M, BW=7.27GiB/s, IOS/call=31/32
>>>>
>>>> at 2.34M ints/sec. So a nice reduction in interrupt rate, though not
>>>> quite at the extent I expected. Booted with 'posted_msi' and I do see
>>>> posted interrupts increasing in the PMN in /proc/interrupts, 
>>>>  
>>> The ints/sec reduction is not as high as I expected either, especially
>>> at this high rate. Which means not enough coalescing going on to get the
>>> performance benefits.  
>>
>> Right, it means that we're getting pretty decent commands-per-int
>> coalescing already. I added another drive and repeated, here's that one:
>>
>> IOPS w/polled: 25.7M IOPS
>>
>> Stock kernel:
>>
>> IOPS=21.41M, BW=10.45GiB/s, IOS/call=32/32
>> IOPS=21.44M, BW=10.47GiB/s, IOS/call=32/32
>> IOPS=21.41M, BW=10.45GiB/s, IOS/call=32/32
>>
>> at ~3.7M ints/sec, or about 5.8 IOPS / int on average.
>>
>> Patched kernel:
>>
>> IOPS=21.90M, BW=10.69GiB/s, IOS/call=31/32
>> IOPS=21.89M, BW=10.69GiB/s, IOS/call=32/31
>> IOPS=21.89M, BW=10.69GiB/s, IOS/call=32/32
>>
>> at the same interrupt rate. So not a reduction, but slighter higher
>> perf. Maybe we're reaping more commands on average per interrupt.
>>
>> Anyway, not a lot of interesting data there, just figured I'd re-run it
>> with the added drive.
>>
>>> The opportunity of IRQ coalescing is also dependent on how long the
>>> driver's hardirq handler executes. In the posted MSI demux loop, it does
>>> not wait for more MSIs to come before existing the pending IRQ polling
>>> loop. So if the hardirq handler finishes very quickly, it may not
>>> coalesce as much. Perhaps, we need to find more "useful" work to do to
>>> maximize the window for coalescing.
>>>
>>> I am not familiar with optane driver, need to look into how its hardirq
>>> handler work. I have only tested NVMe gen5 in terms of storage IO, i saw
>>> 30-50% ints/sec reduction at even lower IRQ rate (200k/sec).  
>>
>> It's just an nvme device, so it's the nvme driver. The IRQ side is very
>> cheap - for as long as there are CQEs in the completion ring, it'll reap
>> them and complete them. That does mean that if we get an IRQ and there's
>> more than one entry to complete, we will do all of them. No IRQ
>> coalescing is configured (nvme kind of sucks for that...), but optane
>> media is much faster than flash, so that may be a difference.
>>
> Yeah, I also check the the driver code it seems just wake up the threaded
> handler.

That only happens if you're using threaded interrupts, which is not the
default as it's much slower. What happens for the normal case is that we
init a batch, and then poll the CQ ring for completions, and then add
them to the completion batch. Once no more are found, we complete the
batch.

You're not using threaded interrupts, are you?

> For the record, here is my set up and performance data for 4 Samsung disks.
> IOPS increased from 1.6M per disk to 2.1M. One difference I noticed is that
> IRQ throughput is improved instead of reduction with this patch on my setup.
> e.g. BEFORE: 185545/sec/vector 
>      AFTER:  220128

I'm surprised at the rates being that low, and if so, why the posted MSI
makes a difference? Usually what I've seen for IRQ being slower than
poll is if interrupt delivery is unreasonably slow on that architecture
of machine. But ~200k/sec isn't that high at all.

> [global]                      
> bs=4k                         
> direct=1                      
> norandommap                   
> ioengine=libaio               
> randrepeat=0                  
> readwrite=randread            
> group_reporting               
> time_based                    
> iodepth=64                    
> exitall                       
> random_generator=tausworthe64 
> runtime=30                    
> ramp_time=3                   
> numjobs=8                     
> group_reporting=1             
>                               
> #cpus_allowed_policy=shared   
> cpus_allowed_policy=split     
> [disk_nvme6n1_thread_1]       
> filename=/dev/nvme6n1         
> cpus_allowed=0-7       
> [disk_nvme6n1_thread_1]
> filename=/dev/nvme5n1  
> cpus_allowed=8-15      
> [disk_nvme5n1_thread_2]
> filename=/dev/nvme4n1  
> cpus_allowed=16-23     
> [disk_nvme5n1_thread_3]
> filename=/dev/nvme3n1  
> cpus_allowed=24-31     

For better performance, I'd change that engine=libaio to:

ioengine=io_uring
fixedbufs=1
registerfiles=1

Particularly fixedbufs makes a big difference, as a big cycle consumer
is mapping/unmapping pages from the application space into the kernel
for O_DIRECT. With fixedbufs=1, this is done once and we just reuse the
buffers. At least for my runs, this is ~15% of the systime for doing IO.
It also removes the page referencing, which isn't as big a consumer, but
still noticeable.

Anyway, side quest, but I think you'll find this considerably reduces
overhead / improves performance. Also makes it so that you can compare
with polled IO on nvme, which aio can't do. You'd just add hipri=1 as an
option for that (with a side note that you need to configure nvme poll
queues, see the poll_queues parameter).

On my box, all the NVMe devices seem to be on node1, not node0 which
looks like it's the CPUs you are using. Might be worth checking and
adjusting your CPU domains for each drive? I also tend to get better
performance by removing the CPU scheduler, eg just pin each job to a
single CPU rather than many. It's just one process/thread anyway, so
really no point in giving it options here. It'll help reduce variability
too, which can be a pain in the butt to deal with.

-- 
Jens Axboe


