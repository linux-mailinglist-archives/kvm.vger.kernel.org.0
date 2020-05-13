Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A531D1B52
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 18:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389350AbgEMQlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 12:41:31 -0400
Received: from foss.arm.com ([217.140.110.172]:50416 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728354AbgEMQlb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 12:41:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 874C131B;
        Wed, 13 May 2020 09:41:30 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98F3E3F305;
        Wed, 13 May 2020 09:41:29 -0700 (PDT)
Subject: Re: [PATCH v2 kvmtool 00/30] Add reassignable BARs and PCIE 1.1
 support
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <a395e1f397699053840e58207918866b@kernel.org>
 <1f0fb8bc-664d-4f6c-9aa6-2c74c90c9c24@arm.com>
Message-ID: <5832e9d8-4c55-d2e9-2544-b789d14ef6be@arm.com>
Date:   Wed, 13 May 2020 17:41:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1f0fb8bc-664d-4f6c-9aa6-2c74c90c9c24@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/13/20 4:15 PM, Alexandru Elisei wrote:
> Hi,
>
> On 5/13/20 3:56 PM, Marc Zyngier wrote:
>> Hi all,
>>
>> On 2020-01-23 13:47, Alexandru Elisei wrote:
>>> kvmtool uses the Linux-only dt property 'linux,pci-probe-only' to prevent
>>> it from trying to reassign the BARs. Let's make the BARs reassignable so
>>> we can get rid of this band-aid.
>> Is there anything holding up this series? I'd really like to see it
>> merged in mainline kvmtool, as the EDK2 port seem to have surfaced
>> (and there are environments where running QEMU is just overkill).
>>
>> It'd be good if it could be rebased and reposted.
> Thank you for the interest, v3 is already out there, by the way, and the first 18
> patches are already merged.

v3 can be found at link [1]. The cover letter mentions that I had to drop Julien
Thierry's patch that fixed the UART overlapping with the PCI I/O region because it
broke guests that used 64k pages. Which means that EDK2 + PCI still doesn't work
with kvmtool, even if the series gets merged. On the plus side, CFI flash
emulation is merged and EDK2 works right now with kvmtool, as long as you stick to
virtio-mmio (which unfortunately means no passthrough as well). I tested this with
the EDK2 firmware posted by Ard [2].

[1] https://www.spinics.net/lists/kvm/msg211272.html
[2] https://www.spinics.net/lists/kvm/msg213842.html
>
> I finished working on v4 and I was just getting ready to run the finally battery
> of tests. If I don't discover any bugs (fingers crossed!), I'll send v4 tomorrow.

Just as I feared, the last patch in the series, the one that adds PCIe support,
breaks EDK2. EDK2 doesn't know about legacy PCI so the aforementioned overlap is
not an issue. But as soon as I advertise support for PCIe EDK2 breaks because of
it. I think I'll just drop the PCIe support patch from the series (so I don't
regress EDK2 + virtio-mmio support) and re-send it after this entire issue gets
sorted.

Thanks,
Alex
