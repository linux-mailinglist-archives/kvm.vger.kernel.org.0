Return-Path: <kvm+bounces-3912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF10580A2A8
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 12:53:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C9611C20941
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 11:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A541BDE5;
	Fri,  8 Dec 2023 11:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="pmjuKESv";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="pS7ZGZq8"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE11171F;
	Fri,  8 Dec 2023 03:52:51 -0800 (PST)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1702036369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Bzhtr8Z/zHR1SS9qrv2WMjasbEmV2BoWGNIe8Z1tRg=;
	b=pmjuKESv4alxlWy9xXV/apAlv4xR7VxTUs7pAvw6l4veAR6iQbL83UpOdjpY/obRJdLcfo
	34PRGPNv5BVBMAhFccxAlq9bBigrkpWfoOBs9VEes7vF1akDLgK/JGE4Mxq0ZzCJVISx5l
	I/dDrPJqVDTtIbL53jyZ+zfZsY4ml/z0eQuZhLdJmsXO5togc6bPvyGnUQgHVXY/inOziR
	MDetaqoIKi0ESx77qQNtGyhDYIQsv7+Io2/KhThR5FzP3k8xcZxBFkr13T4U9GR6xW1NOY
	gf+6L4rqZwU7QHAmqMpzi0g3buykKehh/LFn88D+42VGaMV3BXqV805cQ4YHEw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1702036369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Bzhtr8Z/zHR1SS9qrv2WMjasbEmV2BoWGNIe8Z1tRg=;
	b=pS7ZGZq8uhbuePRlfYDITaiZxhff8pz3xaspEarOeSXWmtVmjO0shwgy4CuY4Dk5GJcri4
	h5Utb4ZE5vc+OqDQ==
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML
 <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>,
 jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH RFC 09/13] x86/irq: Install posted MSI notification handler
In-Reply-To: <20231207204607.2d2a3b72@jacob-builder>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
 <20231112041643.2868316-10-jacob.jun.pan@linux.intel.com>
 <20231115125624.GF3818@noisy.programming.kicks-ass.net>
 <87cyvjun3z.ffs@tglx> <20231207204607.2d2a3b72@jacob-builder>
Date: Fri, 08 Dec 2023 12:52:49 +0100
Message-ID: <87zfyksyge.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Dec 07 2023 at 20:46, Jacob Pan wrote:
> On Wed, 06 Dec 2023 20:50:24 +0100, Thomas Gleixner <tglx@linutronix.de>
> wrote:
>> I don't understand what the whole copy business is about. It's
>> absolutely not required.
>
> My thinking is the following:
> The PIR cache line is contended by between CPU and IOMMU, where CPU can
> access PIR much faster. Nevertheless, when IOMMU does atomic swap of the
> PID (PIR included), L1 cache gets evicted. Subsequent CPU read or xchg will
> deal with invalid cold cache.
>
> By making a copy of PIR as quickly as possible and clearing PIR with xchg,
> we minimized the chance that IOMMU does atomic swap in the middle.
> Therefore, having less L1D misses.
>
> In the code above, it does read, xchg, and call_irq_handler() in a loop
> to handle the 4 64bit PIR bits at a time. IOMMU has a greater chance to do
> atomic xchg on the PIR cache line while doing call_irq_handler(). Therefore,
> it causes more L1D misses.

That makes sense and if we go there it wants to be documented.

> Without PIR copy:
>
> DMA memfill bandwidth: 4.944 Gbps
> Performance counter stats for './run_intr.sh 512 30':                                                             
>                                                                                                                    
>     77,313,298,506      L1-dcache-loads                                               (79.98%)                     
>          8,279,458      L1-dcache-load-misses     #    0.01% of all L1-dcache accesses  (80.03%)                   
>     41,654,221,245      L1-dcache-stores                                              (80.01%)                     
>             10,476      LLC-load-misses           #    0.31% of all LL-cache accesses  (79.99%)                    
>          3,332,748      LLC-loads                                                     (80.00%)                     
>                                                                                                                    
>       30.212055434 seconds time elapsed                                                                            
>                                                                                                                    
>        0.002149000 seconds user                                                                                    
>       30.183292000 seconds sys
>                         
>
> With PIR copy:
> DMA memfill bandwidth: 5.029 Gbps
> Performance counter stats for './run_intr.sh 512 30':
>
>     78,327,247,423      L1-dcache-loads                                               (80.01%)
>          7,762,311      L1-dcache-load-misses     #    0.01% of all L1-dcache accesses  (80.01%)
>     42,203,221,466      L1-dcache-stores                                              (79.99%)
>             23,691      LLC-load-misses           #    0.67% of all LL-cache accesses  (80.01%)
>          3,561,890      LLC-loads                                                     (80.00%)
>
>       30.201065706 seconds time elapsed
>
>        0.005950000 seconds user
>       30.167885000 seconds sys

Interesting, though I'm not really convinced that this DMA memfill
microbenchmark resembles real work loads.

Did you test with something realistic, e.g. storage or networking, too?

Thanks,

        tglx

