Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3C0A0FA9
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 04:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfH2Cs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 22:48:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5688 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725993AbfH2Cs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 22:48:26 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7CF3ED78A60A72B8A524;
        Thu, 29 Aug 2019 10:48:22 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Thu, 29 Aug 2019
 10:48:15 +0800
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Allow more than 256 vcpus for
 KVM_IRQ_LINE
To:     Marc Zyngier <maz@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, Eric Auger <eric.auger@redhat.com>
References: <20190818140710.23920-1-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <47328538-01e6-3152-01f1-ae9c923f628f@huawei.com>
Date:   Thu, 29 Aug 2019 10:46:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190818140710.23920-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2019/8/18 22:07, Marc Zyngier wrote:
> While parts of the VGIC support a large number of vcpus (we
> bravely allow up to 512), other parts are more limited.
> 
> One of these limits is visible in the KVM_IRQ_LINE ioctl, which
> only allows 256 vcpus to be signalled when using the CPU or PPI
> types. Unfortunately, we've cornered ourselves badly by allocating
> all the bits in the irq field.
> 
> Since the irq_type subfield (8 bit wide) is currently only taking
> the values 0, 1 and 2 (and we have been careful not to allow anything
> else), let's reduce this field to only 4 bits, and allocate the
> remaining 4 bits to a vcpu2_index, which acts as a multiplier:
> 
>    vcpu_id = 256 * vcpu2_index + vcpu_index
> 
> With that, and a new capability (KVM_CAP_ARM_IRQ_LINE_LAYOUT_2)
> allowing this to be discovered, it becomes possible to inject
> PPIs to up to 4096 vcpus. But please just don't.
> 
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

And tested together with Eric's patches (KVM+QEMU).


Thanks,
zenghui

