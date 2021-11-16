Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF28452D4B
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 09:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhKPI7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 03:59:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:47301 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232690AbhKPI7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 03:59:14 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="233487248"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="233487248"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 00:56:17 -0800
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="494382847"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.99])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 00:56:12 -0800
Date:   Tue, 16 Nov 2021 17:06:05 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kele Huang <huangkele@bytedance.com>, chaiwen.cc@bytedance.com,
        xieyongji@bytedance.com, dengliang.1214@bytedance.com,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Re: [RFC] KVM: x86: SVM: don't expose PV_SEND_IPI feature with
 AVIC
Message-ID: <20211116090604.GA12758@gao-cwp>
References: <20211108095931.618865-1-huangkele@bytedance.com>
 <a991bbb4-b507-a2f6-ec0f-fce23d4379ce@redhat.com>
 <f93612f54a5cde53fd9342f703ccbaf3c9edbc9c.camel@redhat.com>
 <CANRm+Cze_b0PJzOGB4-tPdrz-iHcJj-o7QL1t1Pf1083nJDQKQ@mail.gmail.com>
 <d65fbd73-7612-8348-2fd8-8da0f5e2a3c0@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d65fbd73-7612-8348-2fd8-8da0f5e2a3c0@bytedance.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 10:56:25AM +0800, zhenwei pi wrote:
>
>
>On 11/16/21 10:48 AM, Wanpeng Li wrote:
>> On Mon, 8 Nov 2021 at 22:09, Maxim Levitsky <mlevitsk@redhat.com> wrote:
>> > 
>> > On Mon, 2021-11-08 at 11:30 +0100, Paolo Bonzini wrote:
>> > > On 11/8/21 10:59, Kele Huang wrote:
>> > > > Currently, AVIC is disabled if x2apic feature is exposed to guest
>> > > > or in-kernel PIT is in re-injection mode.
>> > > > 
>> > > > We can enable AVIC with options:
>> > > > 
>> > > >     Kmod args:
>> > > >     modprobe kvm_amd avic=1 nested=0 npt=1
>> > > >     QEMU args:
>> > > >     ... -cpu host,-x2apic -global kvm-pit.lost_tick_policy=discard ...
>> > > > 
>> > > > When LAPIC works in xapic mode, both AVIC and PV_SEND_IPI feature
>> > > > can accelerate IPI operations for guest. However, the relationship
>> > > > between AVIC and PV_SEND_IPI feature is not sorted out.
>> > > > 
>> > > > In logical, AVIC accelerates most of frequently IPI operations
>> > > > without VMM intervention, while the re-hooking of apic->send_IPI_xxx
>> > > > from PV_SEND_IPI feature masks out it. People can get confused
>> > > > if AVIC is enabled while getting lots of hypercall kvm_exits
>> > > > from IPI.
>> > > > 
>> > > > In performance, benchmark tool
>> > > > https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com/
>> > > > shows below results:
>> > > > 
>> > > >     Test env:
>> > > >     CPU: AMD EPYC 7742 64-Core Processor
>> > > >     2 vCPUs pinned 1:1
>> > > >     idle=poll
>> > > > 
>> > > >     Test result (average ns per IPI of lots of running):
>> > > >     PV_SEND_IPI      : 1860
>> > > >     AVIC             : 1390
>> > > > 
>> > > > Besides, disscussions in https://lkml.org/lkml/2021/10/20/423
>> > > > do have some solid performance test results to this.
>> > > > 
>> > > > This patch fixes this by masking out PV_SEND_IPI feature when
>> > > > AVIC is enabled in setting up of guest vCPUs' CPUID.
>> > > > 
>> > > > Signed-off-by: Kele Huang <huangkele@bytedance.com>
>> > > 
>> > > AVIC can change across migration.  I think we should instead use a new
>> > > KVM_HINTS_* bit (KVM_HINTS_ACCELERATED_LAPIC or something like that).
>> > > The KVM_HINTS_* bits are intended to be changeable across migration,
>> > > even though we don't have for now anything equivalent to the Hyper-V
>> > > reenlightenment interrupt.
>> > 
>> > Note that the same issue exists with HyperV. It also has PV APIC,
>> > which is harmful when AVIC is enabled (that is guest uses it instead
>> > of using AVIC, negating AVIC benefits).
>> > 
>> > Also note that Intel recently posted IPI virtualizaion, which
>> > will make this issue relevant to APICv too soon.
>> 
>> The recently posted Intel IPI virtualization will accelerate unicast
>> ipi but not broadcast ipis, AMD AVIC accelerates unicast ipi well but
>> accelerates broadcast ipis worse than pv ipis. Could we just handle
>> unicast ipi here?
>> 
>>      Wanpeng
>> 
>Depend on the number of target vCPUs, broadcast IPIs gets unstable
>performance on AVIC, and usually worse than PV Send IPI.
>So agree with Wanpeng's point, is it possible to separate single IPI and
>broadcast IPI on a hardware acceleration platform?

Actually, this is how kernel works in x2apic mode: use PV interface
(hypercall) to send multi-cast IPIs and write ICR MSR directly to send
unicast IPIs.

But if guest works in xapic mode, both unicast and multi-cast are issued
via PV interface. It is a side-effect introduced by commit aaffcfd1e82d.

how about just correcting the logic for xapic:

From 13447b221252b64cd85ed1329f7d917afa54efc8 Mon Sep 17 00:00:00 2001
From: Jiaqing Zhao <jiaqing.zhao@intel.com>
Date: Fri, 9 Apr 2021 13:53:39 +0800
Subject: [PATCH 1/2] x86/apic/flat: Add specific send IPI logic

Currently, apic_flat.send_IPI() uses default_send_IPI_single(), which
is a wrapper of apic->send_IPI_mask(). Since commit aaffcfd1e82d
("KVM: X86: Implement PV IPIs in linux guest"), KVM PV IPI driver will
override apic->send_IPI_mask(), and may cause unwated side effects.

This patch removes such side effects by creating a specific send_IPI
method.

Signed-off-by: Jiaqing Zhao <jiaqing.zhao@intel.com>
---
 arch/x86/kernel/apic/apic_flat_64.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 8f72b4351c9f..3196bf220230 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -64,6 +64,13 @@ static void flat_send_IPI_mask(const struct cpumask *cpumask, int vector)
 	_flat_send_IPI_mask(mask, vector);
 }

+static void flat_send_IPI_single(int cpu, int vector)
+{
+	unsigned long mask = cpumask_bits(cpumask_of(cpu))[0];
+
+	_flat_send_IPI_mask(mask, vector);
+}
+
 static void
 flat_send_IPI_mask_allbutself(const struct cpumask *cpumask, int vector)
 {
@@ -132,7 +139,7 @@ static struct apic apic_flat __ro_after_init = {

 	.calc_dest_apicid		= apic_flat_calc_apicid,

-	.send_IPI			= default_send_IPI_single,
+	.send_IPI			= flat_send_IPI_single,
 	.send_IPI_mask			= flat_send_IPI_mask,
 	.send_IPI_mask_allbutself	= flat_send_IPI_mask_allbutself,
 	.send_IPI_allbutself		= default_send_IPI_allbutself,
--
2.27.0


