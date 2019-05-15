Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F921F8C2
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 18:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfEOQij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 12:38:39 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:48494 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbfEOQii (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 12:38:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4841C80D;
        Wed, 15 May 2019 09:38:38 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DDE13F703;
        Wed, 15 May 2019 09:38:35 -0700 (PDT)
Date:   Wed, 15 May 2019 17:38:32 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     Zenghui Yu <yuzenghui@huawei.com>, <christoffer.dall@arm.com>,
        <eric.auger@redhat.com>, <james.morse@arm.com>,
        <julien.thierry@arm.com>, <suzuki.poulose@arm.com>,
        <kvmarm@lists.cs.columbia.edu>, <mst@redhat.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <kvm@vger.kernel.org>,
        <wanghaibin.wang@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Raslan, KarimAllah" <karahmed@amazon.de>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Enable direct irqfd MSI injection
Message-ID: <20190515173832.62afdd90@donnerap.cambridge.arm.com>
In-Reply-To: <20190318133040.1cfad9a4@why.wild-wind.fr.eu.org>
References: <1552833373-19828-1-git-send-email-yuzenghui@huawei.com>
        <86o969z42z.wl-marc.zyngier@arm.com>
        <20190318133040.1cfad9a4@why.wild-wind.fr.eu.org>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Mar 2019 13:30:40 +0000
Marc Zyngier <marc.zyngier@arm.com> wrote:

Hi,

> On Sun, 17 Mar 2019 19:35:48 +0000
> Marc Zyngier <marc.zyngier@arm.com> wrote:
> 
> [...]
> 
> > A first approach would be to keep a small cache of the last few
> > successful translations for this ITS, cache that could be looked-up by
> > holding a spinlock instead. A hit in this cache could directly be
> > injected. Any command that invalidates or changes anything (DISCARD,
> > INV, INVALL, MAPC with V=0, MAPD with V=0, MOVALL, MOVI) should nuke
> > the cache altogether.  
> 
> And to explain what I meant with this, I've pushed a branch[1] with a
> basic prototype. It is good enough to get a VM to boot, but I wouldn't
> trust it for anything serious just yet.
> 
> If anyone feels like giving it a go and check whether it has any
> benefit performance wise, please do so.

So I took a stab at the performance aspect, and it took me a while to find
something where it actually makes a difference. The trick is to create *a
lot* of interrupts. This is my setup now:
- GICv3 and ITS
- 5.1.0 kernel vs. 5.1.0 plus Marc's rebased "ITS cache" patches on top
- 4 VCPU guest on a 4 core machine
- passing through a M.2 NVMe SSD (or a USB3 controller) to the guest
- running FIO in the guest, with:
  - 4K block size, random reads, queue depth 16, 4 jobs (small)
  - 1M block size, sequential reads, QD 1, 1 job (big)

For the NVMe disk I see a whopping 19% performance improvement with Marc's
series (for the small blocks). For a SATA SSD connected via USB3.0 I still
see 6% improvement. For NVMe there were 50,000 interrupts per second on
the host, the USB3 setup came only up to 10,000/s. For big blocks (with
IRQs in the low thousands/s) the win is less, but still a measurable 3%.

Now that I have the setup, I can rerun experiments very quickly (given I
don't loose access to the machine), so let me know if someone needs
further tests.

Cheers,
Andre.

> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/its-translation-cache

