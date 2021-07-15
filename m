Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124E13C9C62
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 12:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhGOKJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 06:09:59 -0400
Received: from foss.arm.com ([217.140.110.172]:50472 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232495AbhGOKJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 06:09:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C29E531B;
        Thu, 15 Jul 2021 03:07:05 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.0.163])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5EF843F694;
        Thu, 15 Jul 2021 03:07:04 -0700 (PDT)
Date:   Thu, 15 Jul 2021 11:06:54 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Qu Wenruo <wqu@suse.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: Any way to disable KVM VHE extension?
Message-ID: <20210715100643.GA53188@C02TD0UTHF1T.local>
References: <37f873cf-1b39-ea7f-a5e7-6feb0200dd4c@suse.com>
 <e17449e7-b91d-d288-ff1c-e9451f9d1973@arm.com>
 <0e992d47-1f17-d49f-8341-670770ac49ef@suse.com>
 <6331dfe5-a028-4a71-6cc1-479003a58f47@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6331dfe5-a028-4a71-6cc1-479003a58f47@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 11:00:42AM +0100, Robin Murphy wrote:
> On 2021-07-15 10:44, Qu Wenruo wrote:
> > 
> > 
> > On 2021/7/15 下午5:28, Robin Murphy wrote:
> > > On 2021-07-15 09:55, Qu Wenruo wrote:
> > > > Hi,
> > > > 
> > > > Recently I'm playing around the Nvidia Xavier AGX board, which
> > > > has VHE extension support.
> > > > 
> > > > In theory, considering the CPU and memory, it should be pretty
> > > > powerful compared to boards like RPI CM4.
> > > > 
> > > > But to my surprise, KVM runs pretty poor on Xavier.
> > > > 
> > > > Just booting the edk2 firmware could take over 10s, and 20s to
> > > > fully boot the kernel.
> > > > Even my VM on RPI CM4 has way faster boot time, even just
> > > > running on PCIE2.0 x1 lane NVME, and just 4 2.1Ghz A72 core.
> > > > 
> > > > This is definitely out of my expectation, I double checked to be
> > > > sure that it's running in KVM mode.
> > > > 
> > > > But further digging shows that, since Xavier AGX CPU supports
> > > > VHE, kvm is running in VHE mode other than HYP mode on CM4.
> > > > 
> > > > Is there anyway to manually disable VHE mode to test the more
> > > > common HYP mode on Xavier?
> > > 
> > > According to kernel-parameters.txt, "kvm-arm.mode=nvhe" (or its
> > > low-level equivalent "id_aa64mmfr1.vh=0") on the command line should
> > > do that.
> > 
> > Thanks for this one, I stupidly only searched modinfo of kvm, and didn't
> > even bother to search arch/arm64/kvm...
> > 
> > > 
> > > However I'd imagine the discrepancy is likely to be something more
> > > fundamental to the wildly different microarchitectures. There's
> > > certainly no harm in giving non-VHE a go for comparison, but I
> > > wouldn't be surprised if it turns out even slower...
> > 
> > You're totally right, with nvhe mode, it's still the same slow speed.
> > 
> > BTW, what did you mean by the "wildly different microarch"?
> > Is ARMv8.2 arch that different from ARMv8 of RPI4?
> 
> I don't mean Armv8.x architectural features, I mean the actual
> implementation of NVIDIA's Carmel core is very, very different from
> Cortex-A72 or indeed our newer v8.2 Cortex-A designs.
> 
> > And any extra methods I could try to explore the reason of the slowness?
> 
> I guess the first check would be whether you're trapping and exiting the VM
> significantly more. I believe there are stats somewhere, but I don't know
> exactly where, sorry - I know very little about actually *using* KVM :)
> 
> If it's not that, then it might just be that EDK2 is doing a lot of cache
> maintenance or system register modification or some other operation that
> happens to be slower on Carmel compared to Cortex-A72.

It would also be worthchecking tha the CPUs are running at the speed you
expect, in e.g. case the lack of a DVFS driver means they're running
slow, and this just happens to be more noticeable in a VM.

You can estimate that by using `perf stat` on the host on a busy loop,
and looking what the cpu-cycles count implies.

Thanks,
Mark.
