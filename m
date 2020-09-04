Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DCE25DB48
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 16:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbgIDOUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 10:20:14 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2766 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730494AbgIDNmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 09:42:35 -0400
Received: from lhreml710-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 59EFE247F430A0538772;
        Fri,  4 Sep 2020 14:42:04 +0100 (IST)
Received: from localhost (10.52.125.29) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 4 Sep 2020
 14:42:03 +0100
Date:   Fri, 4 Sep 2020 14:40:29 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        James Morse <james.morse@arm.com>, <kernel-team@android.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH 02/23] irqchip/rvic: Add support for untrusted interrupt
 allocation
Message-ID: <20200904144029.000017ca@Huawei.com>
In-Reply-To: <20200903152610.1078827-3-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
        <20200903152610.1078827-3-maz@kernel.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.125.29]
X-ClientProxiedBy: lhreml743-chm.china.huawei.com (10.201.108.193) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  3 Sep 2020 16:25:49 +0100
Marc Zyngier <maz@kernel.org> wrote:

> Signed-off-by: Marc Zyngier <maz@kernel.org>
Hi Marc,

One trivial comment inline.

> ---
>  drivers/irqchip/irq-rvic.c | 47 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 44 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-rvic.c b/drivers/irqchip/irq-rvic.c
> index 6f37aa4318b6..2747a452202f 100644
> --- a/drivers/irqchip/irq-rvic.c
> +++ b/drivers/irqchip/irq-rvic.c
> @@ -37,6 +37,8 @@ static DEFINE_PER_CPU(unsigned long *, trusted_masked);
>  struct rvic_data {
>  	struct fwnode_handle	*fwnode;
>  	struct irq_domain	*domain;
> +	unsigned long 		*bitmap;
> +	struct mutex		lock;

Nitpick. Good to document the scope of that lock. It's obvious in this
patch but might not be 10 years down the line!

>  	unsigned int		nr_trusted;
>  	unsigned int		nr_untrusted;
>  };
...

