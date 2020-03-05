Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A966A179E54
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 04:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgCEDkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 22:40:03 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:41596 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbgCEDkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 22:40:02 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AD4361CEF13762CC0BFD;
        Thu,  5 Mar 2020 11:40:00 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Mar 2020
 11:39:52 +0800
Subject: Re: [PATCH v5 00/23] irqchip/gic-v4: GICv4.1 architecture support
To:     Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        "James Morse" <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5613bec0-a207-1e59-82d0-8d44fc65a0a4@huawei.com>
Date:   Thu, 5 Mar 2020 11:39:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/3/5 4:33, Marc Zyngier wrote:
> This (now shorter) series expands the existing GICv4 support to deal
> with the new GICv4.1 architecture, which comes with a set of major
> improvements compared to v4.0:
> 
> - One architectural doorbell per vcpu, instead of one doorbell per VLPI
> 
> - Doorbell entirely managed by the HW, with an "at most once" delivery
>    guarantee per non-residency phase and only when requested by the
>    hypervisor
> 
> - A shared memory scheme between ITSs and redistributors, allowing for an
>    optimised residency sequence (the use of VMOVP becomes less frequent)
> 
> - Support for direct virtual SGI delivery (the injection path still involves
>    the hypervisor), at the cost of losing the active state on SGIs. It
>    shouldn't be a big deal, but some guest operating systems might notice
>    (Linux definitely won't care).
> 
> On the other hand, public documentation is not available yet, so that's a
> bit annoying...
> 
> The series is roughly organised in 3 parts:
> 
> (0) Fixes
> (1) v4.1 doorbell management
> (2) Virtual SGI support
> (3) Plumbing of virtual SGIs in KVM
> 
> Notes:
> 
>    - The whole thing is tested on a FVP model, which can be obtained
>      free of charge on ARM's developer website. It requires you to
>      create an account, unfortunately... You'll need a fix for the
>      devicetree that is in the kernel tree (should be merged before
>      the 5.6 release).
> 
>    - This series has uncovered a behaviour that looks like a HW bug on
>      the Cavium ThunderX (aka TX1) platform. I'd very much welcome some
>      clarification from the Marvell/Cavium folks on Cc, as well as an
>      official erratum number if this happens to be an actual bug.
> 
>      [v3 update]
>      People have ignored for two months now, and it is fairly obvious
>      that support for this machine is slowly bit-rotting. Maybe I'll
>      drop the patch and instead start the process of removing all TX1
>      support from the kernel (we'd certainly be better off without it).
> 
>      [v4 update]
>      TX1 is now broken in mainline, and nobody cares. Make of this what
>      you want.
> 
>    - I'm extremely grateful for Zenghui Yu's huge effort in carefully
>      reviewing this rather difficult series (if we ever get to meet
>      face to face, drinks are definitely on me!).

It's a pleasure to review this work and it's pretty useful for
understanding how Linux works as a GICv4.1-capable hypervisor.
Yay, cheers ;-)!

I'll go through the v4.1 spec one more time before the final
review of this series, as we still have plenty of time to do
some reviews (and even some tests) before the 5.7 MW.

> 
>    - Unless someone cries wolf, I plan to take this into 5.7.

Good news!


Thanks,
Zenghui

