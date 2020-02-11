Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B02159246
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 15:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgBKOvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 09:51:14 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44884 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727707AbgBKOvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 09:51:14 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6146C161BFF83916527A;
        Tue, 11 Feb 2020 22:51:07 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Tue, 11 Feb 2020
 22:50:59 +0800
Subject: Re: [PATCH kvm-unit-tests v2] arm64: timer: Speed up gic-timer-state
 check
To:     Andrew Jones <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <alexandru.elisei@arm.com>
References: <20200211133705.1398-1-drjones@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <60c6c4c7-1d6b-5b64-adc1-8e96f45332c6@huawei.com>
Date:   Tue, 11 Feb 2020 22:50:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200211133705.1398-1-drjones@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 2020/2/11 21:37, Andrew Jones wrote:
> Let's bail out of the wait loop if we see the expected state
> to save over six seconds of run time. Make sure we wait a bit
> before reading the registers and double check again after,
> though, to somewhat mitigate the chance of seeing the expected
> state by accident.
> 
> We also take this opportunity to push more IRQ state code to
> the library.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

[...]

> +
> +enum gic_irq_state gic_irq_state(int irq)

This is a *generic* name while this function only deals with PPI.
Maybe we can use something like gic_ppi_state() instead?  Or you
will have to take all interrupt types into account in a single
function, which is not a easy job I think.

> +{
> +	enum gic_irq_state state;
> +	bool pending = false, active = false;
> +	void *base;
> +
> +	assert(gic_common_ops);
> +
> +	switch (gic_version()) {
> +	case 2:
> +		base = gicv2_dist_base();
> +		pending = readl(base + GICD_ISPENDR) & (1 << PPI(irq));
> +		active = readl(base + GICD_ISACTIVER) & (1 << PPI(irq));
> +		break;
> +	case 3:
> +		base = gicv3_sgi_base();
> +		pending = readl(base + GICR_ISPENDR0) & (1 << PPI(irq));
> +		active = readl(base + GICR_ISACTIVER0) & (1 << PPI(irq));

And you may also want to ensure that the 'irq' is valid for PPI().
Or personally, I'd just use a real PPI number (PPI(info->irq)) as
the input parameter of this function.

> +		break;
> +	}
> +
> +	if (!active && !pending)
> +		state = GIC_IRQ_STATE_INACTIVE;
> +	if (pending)
> +		state = GIC_IRQ_STATE_PENDING;
> +	if (active)
> +		state = GIC_IRQ_STATE_ACTIVE;
> +	if (active && pending)
> +		state = GIC_IRQ_STATE_ACTIVE_PENDING;
> +
> +	return state;
> +}
> 

Otherwise,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

