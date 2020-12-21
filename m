Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8DC2DF866
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 05:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgLUEuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Dec 2020 23:50:35 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9543 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbgLUEud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Dec 2020 23:50:33 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Czn7737k1zhv3g;
        Mon, 21 Dec 2020 12:49:07 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Mon, 21 Dec 2020 12:49:40 +0800
Subject: Re: [PATCH] genirq/msi: Initialize msi_alloc_info to zero for
 msi_prepare API
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tglx@linutronix.de>,
        <kvm@vger.kernel.org>, <wanghaibin.wang@huawei.com>
References: <20201218060039.1770-1-yuzenghui@huawei.com>
 <87v9czqaj9.wl-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <48a318c3-ed5e-98fa-fcb1-502df088b78c@huawei.com>
Date:   Mon, 21 Dec 2020 12:49:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87v9czqaj9.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/12/19 1:38, Marc Zyngier wrote:
> Hi Zenghui,
> 
> On Fri, 18 Dec 2020 06:00:39 +0000,
> Zenghui Yu <yuzenghui@huawei.com> wrote:
>>
>> Since commit 5fe71d271df8 ("irqchip/gic-v3-its: Tag ITS device as shared if
>> allocating for a proxy device"), some of the devices are wrongly marked as
>> "shared" by the ITS driver on systems equipped with the ITS(es). The
>> problem is that the @info->flags may not be initialized anywhere and we end
>> up looking at random bits on the stack. That's obviously not good.
>>
>> The straightforward fix is to properly initialize msi_alloc_info inside the
>> .prepare callback of affected MSI domains (its-pci-msi, its-platform-msi,
>> etc). We can also perform the initialization in IRQ core layer for
>> msi_domain_prepare_irqs() API and it looks much neater to me.
>>
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> ---
>>
>> This was noticed when I was playing with the assigned devices on arm64 and
>> VFIO failed to enable MSI-X vectors for almost all VFs (CCed kvm list in
>> case others will hit the same issue). It turned out that these VFs are
>> marked as "shared" by mistake and have trouble with the following sequence:
>>
>> 	pci_alloc_irq_vectors(pdev, 1, 1, flag);
>> 	pci_free_irq_vectors(pdev);
>> 	pci_alloc_irq_vectors(pdev, 1, 2, flag); --> we can only get
>> 						     *one* vector
>>
>> But besides VFIO, I guess there are already some devices get into trouble
>> at probe time and can't work properly.
>>
>>   kernel/irq/msi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
>> index 2c0c4d6d0f83..dc0e2d7fbdfd 100644
>> --- a/kernel/irq/msi.c
>> +++ b/kernel/irq/msi.c
>> @@ -402,7 +402,7 @@ int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
>>   	struct msi_domain_ops *ops = info->ops;
>>   	struct irq_data *irq_data;
>>   	struct msi_desc *desc;
>> -	msi_alloc_info_t arg;
>> +	msi_alloc_info_t arg = { };
>>   	int i, ret, virq;
>>   	bool can_reserve;
> 
> Thanks for having investigated this. I guess my only worry with this
> is that msi_alloc_info_t is a pretty large structure on x86, and
> zeroing it isn't totally free.

It seems that x86 will zero the whole msi_alloc_info_t structure at the
beginning of its .prepare (pci_msi_prepare()/init_irq_alloc_info()). If
this really affects something, I think we can easily address it with
some cleanup (on top of this patch).

> But this definitely looks nicer than
> some of the alternatives (.prepare isn't a good option, as we do rely
> on the flag being set in __platform_msi_create_device_domain(), which
> calls itself .prepare).

Indeed, thanks for fixing the commit message.

> I'll queue it, and we can always revisit this later if Thomas (or
> anyone else) has a better idea.

Thanks!


Zenghui
