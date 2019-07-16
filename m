Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5016AF25
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 20:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388294AbfGPSur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 14:50:47 -0400
Received: from foss.arm.com ([217.140.110.172]:38798 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387773AbfGPSur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 14:50:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FEEF2B;
        Tue, 16 Jul 2019 11:50:46 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB7E83F59C;
        Tue, 16 Jul 2019 11:50:45 -0700 (PDT)
Date:   Tue, 16 Jul 2019 19:50:44 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>,
        kasan-dev@googlegroups.com, kvm@vger.kernel.org,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
Subject: Re: BUG: KASAN: slab-out-of-bounds in
 kvm_pmu_get_canonical_pmc+0x48/0x78
Message-ID: <20190716185043.GV7227@e119886-lin.cambridge.arm.com>
References: <644e3455-ea6d-697a-e452-b58961341381@huawei.com>
 <f9d5d18a-7631-f3e2-d73a-21d8eee183f1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f9d5d18a-7631-f3e2-d73a-21d8eee183f1@huawei.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 16, 2019 at 11:14:37PM +0800, Zenghui Yu wrote:
> 
> On 2019/7/16 23:05, Zenghui Yu wrote:
> > Hi folks,
> > 
> > Running the latest kernel with KASAN enabled, we will hit the following
> > KASAN BUG during guest's boot process.
> > 
> > I'm in commit 9637d517347e80ee2fe1c5d8ce45ba1b88d8b5cd.
> > 
> > Any problems in the chained PMU code? Or just a false positive?
> > 
> > ---8<---
> > 
> > [  654.706268]
> > ==================================================================
> > [  654.706280] BUG: KASAN: slab-out-of-bounds in
> > kvm_pmu_get_canonical_pmc+0x48/0x78
> > [  654.706286] Read of size 8 at addr ffff801d6c8fea38 by task
> > qemu-kvm/23268
> > 
> > [  654.706296] CPU: 2 PID: 23268 Comm: qemu-kvm Not tainted 5.2.0+ #178
> > [  654.706301] Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.58
> > 10/24/2018
> > [  654.706305] Call trace:
> > [  654.706311]  dump_backtrace+0x0/0x238
> > [  654.706317]  show_stack+0x24/0x30
> > [  654.706325]  dump_stack+0xe0/0x134
> > [  654.706332]  print_address_description+0x80/0x408
> > [  654.706338]  __kasan_report+0x164/0x1a0
> > [  654.706343]  kasan_report+0xc/0x18
> > [  654.706348]  __asan_load8+0x88/0xb0
> > [  654.706353]  kvm_pmu_get_canonical_pmc+0x48/0x78
> 
> I noticed that we will use "pmc->idx" and the "chained" bitmap to
> determine if the pmc is chained, in kvm_pmu_pmc_is_chained().
> 
> Should we initialize the idx and the bitmap appropriately before
> doing kvm_pmu_stop_counter()?  Like:

Hi Zenghui,

Thanks for spotting this and investigating - I'll make sure to use KASAN
in the future when testing...

> 
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 3dd8238..cf3119a 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -224,12 +224,12 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
>  	int i;
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> 
> +	bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
> +
>  	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
> -		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
>  		pmu->pmc[i].idx = i;
> +		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
>  	}
> -
> -	bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
>  }

We have to be a little careful here, as the vcpu may be reset after use.
Upon resetting we must ensure that any existing perf_events are released -
this is why kvm_pmu_stop_counter is called before bitmap_zero (as
kvm_pmu_stop_counter relies on kvm_pmu_pmc_is_chained).

(For example, by clearing the bitmap before stopping the counters, we will
attempt to release the perf event for both pmc's in a chained pair. Whereas
we should only release the canonical pmc. It's actually OK right now as we
set the non-canonical pmc perf_event will be NULL - but who knows that this
will hold true in the future. The code makes the assumption that the
non-canonical perf event isn't touched on a chained pair).

The KASAN bug gets fixed by moving the assignment of idx before 
kvm_pmu_stop_counter. Therefore I'd suggest you drop the bitmap_zero hunks.

Can you send a patch with just the idx assignment hunk please?

Thanks,

Andrew Murray

> 
>  /**
> 
> 
> Thanks,
> zenghui
> 
> > [  654.706358]  kvm_pmu_stop_counter+0x28/0x118
> > [  654.706363]  kvm_pmu_vcpu_reset+0x60/0xa8
> > [  654.706369]  kvm_reset_vcpu+0x30/0x4d8
> > [  654.706376]  kvm_arch_vcpu_ioctl+0xa04/0xc18
> > [  654.706381]  kvm_vcpu_ioctl+0x17c/0xde8
> > [  654.706387]  do_vfs_ioctl+0x150/0xaf8
> > [  654.706392]  ksys_ioctl+0x84/0xb8
> > [  654.706397]  __arm64_sys_ioctl+0x4c/0x60
> > [  654.706403]  el0_svc_common.constprop.0+0xb4/0x208
> > [  654.706409]  el0_svc_handler+0x3c/0xa8
> > [  654.706414]  el0_svc+0x8/0xc
> > 
> > [  654.706422] Allocated by task 23268:
> > [  654.706429]  __kasan_kmalloc.isra.0+0xd0/0x180
> > [  654.706435]  kasan_slab_alloc+0x14/0x20
> > [  654.706440]  kmem_cache_alloc+0x17c/0x4a8
> > [  654.706445]  kvm_arch_vcpu_create+0xa0/0x130
> > [  654.706451]  kvm_vm_ioctl+0x844/0x1218
> > [  654.706456]  do_vfs_ioctl+0x150/0xaf8
> > [  654.706461]  ksys_ioctl+0x84/0xb8
> > [  654.706466]  __arm64_sys_ioctl+0x4c/0x60
> > [  654.706472]  el0_svc_common.constprop.0+0xb4/0x208
> > [  654.706478]  el0_svc_handler+0x3c/0xa8
> > [  654.706482]  el0_svc+0x8/0xc
> > 
> > [  654.706490] Freed by task 0:
> > [  654.706493] (stack is not available)
> > 
> > [  654.706501] The buggy address belongs to the object at ffff801d6c8fc010
> >   which belongs to the cache kvm_vcpu of size 10784
> > [  654.706507] The buggy address is located 8 bytes to the right of
> >   10784-byte region [ffff801d6c8fc010, ffff801d6c8fea30)
> > [  654.706510] The buggy address belongs to the page:
> > [  654.706516] page:ffff7e0075b23f00 refcount:1 mapcount:0
> > mapping:ffff801db257e480 index:0x0 compound_mapcount: 0
> > [  654.706524] flags: 0xffffe0000010200(slab|head)
> > [  654.706532] raw: 0ffffe0000010200 ffff801db2586ee0 ffff801db2586ee0
> > ffff801db257e480
> > [  654.706538] raw: 0000000000000000 0000000000010001 00000001ffffffff
> > 0000000000000000
> > [  654.706542] page dumped because: kasan: bad access detected
> > 
> > [  654.706549] Memory state around the buggy address:
> > [  654.706554]  ffff801d6c8fe900: 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 00 00 00
> > [  654.706560]  ffff801d6c8fe980: 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 00 00 00
> > [  654.706565] >ffff801d6c8fea00: 00 00 00 00 00 00 fc fc fc fc fc fc fc
> > fc fc fc
> > [  654.706568]                                         ^
> > [  654.706573]  ffff801d6c8fea80: fc fc fc fc fc fc fc fc fc fc fc fc fc
> > fc fc fc
> > [  654.706578]  ffff801d6c8feb00: fc fc fc fc fc fc fc fc fc fc fc fc fc
> > fc fc fc
> > [  654.706582]
> > ==================================================================
> 
