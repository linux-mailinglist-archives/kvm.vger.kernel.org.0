Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701B118712B
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 18:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731726AbgCPRbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 13:31:08 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:28818 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730437AbgCPRbI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 13:31:08 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 13:31:07 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584379867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q1akQPS81W+giPhP70+us9oHf1EnbPYJV9QWBzC/Xbo=;
        b=ZQOHu/p8vFKBaaMF7/SGbE2DNgVuFZxfLVHinNyGD6n68DPuBCwlwoyAxGnXR9xBc4aijX
        HR3lzl7TxQ7r2UQvzvXLvJEGUlNMS5bJ0y+GhXsbrt7YpioYDphaSp5pl9VoGTPa8y4P5H
        uMXIsnCCNA6gSjFJXGM9FHZU07DjLFk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-Zh47tl5WOg-Nn-jxg_VU_w-1; Mon, 16 Mar 2020 13:24:57 -0400
X-MC-Unique: Zh47tl5WOg-Nn-jxg_VU_w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0168CCF12C;
        Mon, 16 Mar 2020 17:10:27 +0000 (UTC)
Received: from [10.36.118.12] (ovpn-118-12.ams2.redhat.com [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FCEC5C1B2;
        Mon, 16 Mar 2020 17:10:22 +0000 (UTC)
Subject: Re: [PATCH v5 02/23] irqchip/gic-v4.1: Skip absent CPUs while
 iterating over redistributors
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-3-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e17a13d5-e28f-5fad-3c27-2ba75f22fc27@redhat.com>
Date:   Mon, 16 Mar 2020 18:10:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-3-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc

On 3/4/20 9:33 PM, Marc Zyngier wrote:
> In a system that is only sparsly populated with CPUs, we can end-up with
sparsely
> redistributors structures that are not initialized. Let's make sure we
redistributor structures
> don't try and access those when iterating over them (in this case when
> checking we have a L2 VPE table).
> 
> Fixes: 4e6437f12d6e ("irqchip/gic-v4.1: Ensure L2 vPE table is allocated at RD level")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  drivers/irqchip/irq-gic-v3-its.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 83b1186ffcad..da883a691028 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -2452,6 +2452,10 @@ static bool allocate_vpe_l2_table(int cpu, u32 id)
>  	if (!gic_rdists->has_rvpeid)
>  		return true;
>  
> +	/* Skip non-present CPUs */
> +	if (!base)
> +		return true;
> +
>  	val  = gicr_read_vpropbaser(base + SZ_128K + GICR_VPROPBASER);
>  
>  	esz  = FIELD_GET(GICR_VPROPBASER_4_1_ENTRY_SIZE, val) + 1;
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

