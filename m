Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4FA3C9BCB
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 11:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhGOJbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 05:31:48 -0400
Received: from foss.arm.com ([217.140.110.172]:49796 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231395AbhGOJbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 05:31:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53A646D;
        Thu, 15 Jul 2021 02:28:55 -0700 (PDT)
Received: from [10.57.36.240] (unknown [10.57.36.240])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CB9D3F774;
        Thu, 15 Jul 2021 02:28:54 -0700 (PDT)
Subject: Re: Any way to disable KVM VHE extension?
To:     Qu Wenruo <wqu@suse.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
References: <37f873cf-1b39-ea7f-a5e7-6feb0200dd4c@suse.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <e17449e7-b91d-d288-ff1c-e9451f9d1973@arm.com>
Date:   Thu, 15 Jul 2021 10:28:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <37f873cf-1b39-ea7f-a5e7-6feb0200dd4c@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-07-15 09:55, Qu Wenruo wrote:
> Hi,
> 
> Recently I'm playing around the Nvidia Xavier AGX board, which has VHE 
> extension support.
> 
> In theory, considering the CPU and memory, it should be pretty powerful 
> compared to boards like RPI CM4.
> 
> But to my surprise, KVM runs pretty poor on Xavier.
> 
> Just booting the edk2 firmware could take over 10s, and 20s to fully 
> boot the kernel.
> Even my VM on RPI CM4 has way faster boot time, even just running on 
> PCIE2.0 x1 lane NVME, and just 4 2.1Ghz A72 core.
> 
> This is definitely out of my expectation, I double checked to be sure 
> that it's running in KVM mode.
> 
> But further digging shows that, since Xavier AGX CPU supports VHE, kvm 
> is running in VHE mode other than HYP mode on CM4.
> 
> Is there anyway to manually disable VHE mode to test the more common HYP 
> mode on Xavier?

According to kernel-parameters.txt, "kvm-arm.mode=nvhe" (or its 
low-level equivalent "id_aa64mmfr1.vh=0") on the command line should do 
that.

However I'd imagine the discrepancy is likely to be something more 
fundamental to the wildly different microarchitectures. There's 
certainly no harm in giving non-VHE a go for comparison, but I wouldn't 
be surprised if it turns out even slower...

Robin.

> BTW, this is the dmesg related to KVM on Xavier, running v5.13 upstream 
> kernel, with 64K page size:
> [    0.852357] kvm [1]: IPA Size Limit: 40 bits
> [    0.857378] kvm [1]: vgic interrupt IRQ9
> [    0.862122] kvm: pmu event creation failed -2
> [    0.866734] kvm [1]: VHE mode initialized successfully
> 
> While on CM4, the host runs v5.12.10 upstream kernel (with downstream 
> dtb), with 4K page size:
> [    1.276818] kvm [1]: IPA Size Limit: 44 bits
> [    1.278425] kvm [1]: vgic interrupt IRQ9
> [    1.278620] kvm [1]: Hyp mode initialized successfully
> 
> Could it be the PAGE size causing problem?
> 
> Thanks,
> Qu
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
