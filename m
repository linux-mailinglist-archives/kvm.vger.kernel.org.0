Return-Path: <kvm+bounces-15366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FDFF8AB5E6
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 22:07:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51C6B1C20D2C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 20:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA74713CF8F;
	Fri, 19 Apr 2024 20:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfiCvfRU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0718D10A03;
	Fri, 19 Apr 2024 20:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713557241; cv=none; b=EWCfgw6IHu+P8Vqjw1DAtj2EMaQ7D08Y8jVSc0yEMlkw+jRPsu2okUhWyHKUKvXnj5SAWtFBL3lDaHC4ZXUZ1ws60qcwJ+DuQtPPHlXqO2d7ml2LH0mQXd61q5uKEaHiYL11R3yvz+kf1MzuDW85kSEpO3Ilb359dWXeolTlSpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713557241; c=relaxed/simple;
	bh=ycgfHMlt+UlcaG4ketR/yuNNw2hvmApeoBvZ3KPmBP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KC5eSQxMEInqzmma7a4O3BA0Untk4pIsTRhkS1/ArH+IXfvBu/q+AC8ujkY7JSvXQQ5vVQQz6fQxXDE5ueseOTA8uFrslKZYQvVxHR0iSXikYfPCdlG97nkKRYvVVdR/n7+PZ2dZE2ButJYnaS342Cq1nf9cd/JmKSJTRBAAVSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfiCvfRU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1759C072AA;
	Fri, 19 Apr 2024 20:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713557240;
	bh=ycgfHMlt+UlcaG4ketR/yuNNw2hvmApeoBvZ3KPmBP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QfiCvfRU8afAJ78s4+eQn6qzBAimsQ2168PoqAIHVelV/LRVyalukWuZ6HVlfP68B
	 FAeSC1pSGwpOwealSFcBOFuDOIU7XREj+dbocpnEGmodtiP0831dOBTYtVLkqHaFy/
	 a6O81VtJbB5ZZVd7SYwZuKvDZnRFJ6DdxWqL9vTOVXvHFIpXlzjGeJwGjzloMikfA3
	 8Ogdj9mHkI+ra9Ew6t8V0IiTht/NZ1wxXIy8cHyS+GUIe0JhxNXwvEBnsqo2AWnAhu
	 RkbLosw5jKAGFaadrKUV2+dhdXWWbgbC/+XS9+imfzkke0f7phdt6hOdEbVMkhsjJi
	 JCzeiah7YRVZA==
Date: Fri, 19 Apr 2024 17:07:17 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>, Paul Luse <paul.e.luse@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>, Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>, maz@kernel.org,
	seanjc@google.com, Robin Murphy <robin.murphy@arm.com>,
	jim.harris@samsung.com, a.manzanares@samsung.com,
	Bjorn Helgaas <helgaas@kernel.org>, guang.zeng@intel.com,
	robert.hoo.linux@gmail.com, kan.liang@intel.com,
	"Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [PATCH v2 05/13] x86/irq: Reserve a per CPU IDT vector for
 posted MSIs
Message-ID: <ZiLO9RUdMsNlCtI_@x1>
References: <20240415134354.67c9d1d1@jacob-builder>
 <87jzkuxaqv.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87jzkuxaqv.ffs@tglx>

On Fri, Apr 19, 2024 at 06:00:24AM +0200, Thomas Gleixner wrote:
> On Mon, Apr 15 2024 at 13:43, Jacob Pan wrote:
> > On Mon, 15 Apr 2024 11:53:58 -0700, Jacob Pan <jacob.jun.pan@linux.intel.com> wrote:
> >> On Thu, 11 Apr 2024 18:51:14 +0200, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> > If we really care then we do it proper for _all_ of them. Something like
> >> > the uncompiled below. There is certainly a smarter way to do the build
> >> > thing, but my kbuild foo is rusty.  
> >> I too had the concern of the wasting system vectors, but did not know how
> >> to fix it. But now your code below works well. Tested without KVM in
> >> .config to show the gaps:
> >> 
> >> In VECTOR IRQ domain.
> >> 
> >> BEFORE:
> >> System: 46: 0-31,50,235-236,244,246-255
> >> 
> >> AFTER:
> >> System: 46: 0-31,50,241-242,245-255
> >> 
> >> The only gap is MANAGED_IRQ_SHUTDOWN_VECTOR(243), which is expected on a
> >> running system.
> >> 
> >> Verified in irqvectors.s: .ascii "->MANAGED_IRQ_SHUTDOWN_VECTOR $243
> >> 
> >> POSTED MSI/first system vector moved up from 235 to 241 for this case.
> >> 
> >> Will try to let tools/arch/x86/include/asm/irq_vectors.h also use it
> >> instead of manually copy over each time. Any suggestions greatly
> >> appreciated.
> >>
> > On a second thought, if we make system IRQ vector determined at compile
> > time based on different CONFIG options, will it break userspace tools such
> > as perf? More importantly the rule of not breaking userspace.

The rule for tools/perf is "don't impose _any requirement_ on the kernel
developers, they don't have to test if any change they do outside of
tools/ will break something inside tools/."
 
> tools/arch/x86/include/asm/irq_vectors.h is only used to generate the
> list of system vectors for pretty output. And your change already broke
> that.

Yeah, I even moved that from tools/arch/x86/include/asm/irq_vectors.h
to tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h (for next
merge window).

Having it in tools/arch/x86/include/asm/irq_vectors.h was a bad decision
as it, as you mentinoned, is only used to generate string tables:

⬢[acme@toolbox perf-tools-next]$ tools/perf/trace/beauty/tracepoints/x86_irq_vectors.sh 
static const char *x86_irq_vectors[] = {
	[0x02] = "NMI",
	[0x80] = "IA32_SYSCALL",
	[0xec] = "LOCAL_TIMER",
	[0xed] = "HYPERV_STIMER0",
	[0xee] = "HYPERV_REENLIGHTENMENT",
	[0xef] = "MANAGED_IRQ_SHUTDOWN",
	[0xf0] = "POSTED_INTR_NESTED",
	[0xf1] = "POSTED_INTR_WAKEUP",
	[0xf2] = "POSTED_INTR",
	[0xf3] = "HYPERVISOR_CALLBACK",
	[0xf4] = "DEFERRED_ERROR",
	[0xf6] = "IRQ_WORK",
	[0xf7] = "X86_PLATFORM_IPI",
	[0xf8] = "REBOOT",
	[0xf9] = "THRESHOLD_APIC",
	[0xfa] = "THERMAL_APIC",
	[0xfb] = "CALL_FUNCTION_SINGLE",
	[0xfc] = "CALL_FUNCTION",
	[0xfd] = "RESCHEDULE",
	[0xfe] = "ERROR_APIC",
	[0xff] = "SPURIOUS_APIC",
};

⬢[acme@toolbox perf-tools-next]$

Used in:

root@number:~# perf trace -a -e irq_vectors:irq_work_entry/max-stack=32/ --max-events=1
     0.000 kworker/u57:0-/9912 irq_vectors:irq_work_entry(vector: IRQ_WORK)
                                       __sysvec_irq_work ([kernel.kallsyms])
                                       __sysvec_irq_work ([kernel.kallsyms])
                                       sysvec_irq_work ([kernel.kallsyms])
                                       asm_sysvec_irq_work ([kernel.kallsyms])
                                       _raw_spin_unlock_irqrestore ([kernel.kallsyms])
                                       dma_fence_wait_timeout ([kernel.kallsyms])
                                       intel_atomic_commit_tail ([kernel.kallsyms])
                                       process_one_work ([kernel.kallsyms])
                                       worker_thread ([kernel.kallsyms])
                                       kthread ([kernel.kallsyms])
                                       ret_from_fork ([kernel.kallsyms])
                                       ret_from_fork_asm ([kernel.kallsyms])
root@number:~#

But as the original cset introducing this explains, these irq_vectors:
tracepoins operate on just one of the vectors, so irq_work_entry(vector:
IRQ_WORK), irq_vectors:reschedule_exit(vector: RESCHEDULE), etc. 

> The obvious solution to that is to expose that list in sysfs for
> consumption by perf.

nah, the best thing these days is stop using 'int' for vector and use
'enum irq_vector', then since we have BTF we can use that to do the enum
-> string translation, like with (using /sys/kernel/btf/vmlinux, that is
pretty much available everywhere these days):

root@number:~# pahole clocksource_ids
enum clocksource_ids {
	CSID_GENERIC          = 0,
	CSID_ARM_ARCH_COUNTER = 1,
	CSID_MAX              = 2,
};

root@number:~# pahole skb_drop_reason | head
enum skb_drop_reason {
	SKB_NOT_DROPPED_YET                     = 0,
	SKB_CONSUMED                            = 1,
	SKB_DROP_REASON_NOT_SPECIFIED           = 2,
	SKB_DROP_REASON_NO_SOCKET               = 3,
	SKB_DROP_REASON_PKT_TOO_SMALL           = 4,
	SKB_DROP_REASON_TCP_CSUM                = 5,
	SKB_DROP_REASON_SOCKET_FILTER           = 6,
	SKB_DROP_REASON_UDP_CSUM                = 7,
	SKB_DROP_REASON_NETFILTER_DROP          = 8,
root@number:~#

Then its easy to go from 0 to CSID_GENERIC, etc.

⬢[acme@toolbox pahole]$ perf stat -e cycles pahole skb_drop_reason > /dev/null

 Performance counter stats for 'pahole skb_drop_reason':

         6,095,427      cpu_atom/cycles:u/                                                      (2.82%)
       103,694,633      cpu_core/cycles:u/                                                      (97.18%)

       0.039031759 seconds time elapsed

       0.016028000 seconds user
       0.023007000 seconds sys


⬢[acme@toolbox pahole]$

- Arnaldo
 
> But we don't have to do any of that right away. It's an orthogonal
> issue. Just waste the extra system vector to start with and then we can
> add the compile time dependend change on top if we really care about
> gaining back the vectors.
> 
> Thanks,
> 
>         tglx

