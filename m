Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A156B4995
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 10:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387419AbfIQIfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 04:35:43 -0400
Received: from foss.arm.com ([217.140.110.172]:52906 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfIQIfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 04:35:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2856928;
        Tue, 17 Sep 2019 01:35:42 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 725C53F575;
        Tue, 17 Sep 2019 01:35:41 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Move the GICv4 residency flow to be
 driven by vcpu_load/put
To:     Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <Andre.Przywara@arm.com>
References: <20190903155747.219802-1-maz@kernel.org>
 <5ab75fec-6014-e3b4-92a3-63d5015814c1@huawei.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <07ddb304-9a7a-64a3-386a-96eea4516346@kernel.org>
Date:   Tue, 17 Sep 2019 09:35:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5ab75fec-6014-e3b4-92a3-63d5015814c1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 17/09/2019 09:10, Zenghui Yu wrote:
> Hi Marc,
> 
> I've run this patch on my box and got the following messages:
> 
> ---8<
> 
> [ 2258.490030] BUG: sleeping function called from invalid context at 
> kernel/irq/manage.c:138
> [ 2258.490034] in_atomic(): 1, irqs_disabled(): 0, pid: 59278, name: CPU 
> 0/KVM
> [ 2258.490039] CPU: 32 PID: 59278 Comm: CPU 0/KVM Kdump: loaded Tainted: 
> G        W         5.3.0+ #26
> [ 2258.490041] Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.58 
> 10/29/2018
> [ 2258.490043] Call trace:
> [ 2258.490056]  dump_backtrace+0x0/0x188
> [ 2258.490060]  show_stack+0x24/0x30
> [ 2258.490066]  dump_stack+0xb0/0xf4
> [ 2258.490072]  ___might_sleep+0x10c/0x130
> [ 2258.490074]  __might_sleep+0x58/0x90
> [ 2258.490078]  synchronize_irq+0x58/0xd8
> [ 2258.490079]  disable_irq+0x2c/0x38
> [ 2258.490083]  vgic_v4_load+0x9c/0xc0
> [ 2258.490084]  vgic_v3_load+0x94/0x170
> [ 2258.490088]  kvm_vgic_load+0x3c/0x60
> [ 2258.490092]  kvm_arch_vcpu_load+0xd4/0x1d0
> [ 2258.490095]  vcpu_load+0x50/0x70
> [ 2258.490097]  kvm_arch_vcpu_ioctl_run+0x94/0x978
> [ 2258.490098]  kvm_vcpu_ioctl+0x3d8/0xa28
> [ 2258.490104]  do_vfs_ioctl+0xc4/0x8e8
> [ 2258.490106]  ksys_ioctl+0x8c/0xa0
> [ 2258.490108]  __arm64_sys_ioctl+0x28/0x58
> [ 2258.490112]  el0_svc_common.constprop.0+0x7c/0x188
> [ 2258.490114]  el0_svc_handler+0x34/0xb8
> [ 2258.490117]  el0_svc+0x8/0xc
> [ 2259.497070] BUG: sleeping function called from invalid context at 
> kernel/irq/manage.c:138

Thanks for reporting this.

[...]

> The logic of disabling the doorbell interrupt in vgic_v4_load() might
> need a fix?

The logic itself looks OK, but doing a full blown disable_irq() is both
counter productive (if we race against a doorbell, there is not much we
can do about it and waiting for it to end is pointless) and wrong
(despite the comment that this can be called in IRQ context, it is
pretty unsafe to do so).

Can you try turning it into a disable_irq_nosync() and let me know if
that helps?

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
