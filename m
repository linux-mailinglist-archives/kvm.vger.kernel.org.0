Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 999D918B1D6
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 11:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgCSK4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 06:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgCSK4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 06:56:02 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37C3A20752;
        Thu, 19 Mar 2020 10:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584615361;
        bh=FgL+vAAVjsz7UBPASMA+6v+M3lCJAwKJ3E3l89+r2xk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xEgMD21+sF/isioXATJ90/m2wi0y1eRKeruTMs8rk9CD1Q9iumXQAdXmWUS4B/RRd
         2Pg+TkmzhNP7c2ra6Akbn061od5ZXeDR2Wk54YMhNqPJefcJMb2XGDcsB2JHpKbS6w
         qxW/nfnI4iwDHFmUPTI+FYcBjJkfVWLyVAQM+xHQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jEsqF-00Duty-9Q; Thu, 19 Mar 2020 10:55:59 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 19 Mar 2020 10:55:59 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 16/23] irqchip/gic-v4.1: Eagerly vmap vPEs
In-Reply-To: <2817cb89-4cc2-549f-6e40-91d941aa8a5f@huawei.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-17-maz@kernel.org>
 <2817cb89-4cc2-549f-6e40-91d941aa8a5f@huawei.com>
Message-ID: <d45e7ddfd51d4d8229e02efc42c8da04@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-17 02:49, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/3/5 4:33, Marc Zyngier wrote:
>> Now that we have HW-accelerated SGIs being delivered to VPEs, it
>> becomes required to map the VPEs on all ITSs instead of relying
>> on the lazy approach that we would use when using the ITS-list
>> mechanism.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Before GICv4.1, we use vlpi_count to evaluate whether the vPE has been
> mapped on the specified ITS, and use this refcount to only issue VMOVP
> to those involved ITSes. It's broken after this patch.
> 
> We may need to re-evaluate "whether the vPE is mapped" now that we're 
> at
> GICv4.1, otherwise *no* VMOVP will be issued on the v4.1 capable 
> machine
> (I mean those without single VMOVP support).
> 
> What I'm saying is something like below (only an idea, it even can't
> compile), any thoughts?
> 
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
> b/drivers/irqchip/irq-gic-v3-its.c
> index 2e12bc52e3a2..3450b5e847ca 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -198,7 +198,8 @@ static u16 get_its_list(struct its_vm *vm)
>  		if (!is_v4(its))
>  			continue;
> 
> -		if (vm->vlpi_count[its->list_nr])
> +		if (vm->vlpi_count[its->list_nr] ||
> +		    gic_requires_eager_mapping())
>  			__set_bit(its->list_nr, &its_list);
>  	}
> 
> @@ -1295,7 +1296,8 @@ static void its_send_vmovp(struct its_vpe *vpe)
>  		if (!is_v4(its))
>  			continue;
> 
> -		if (!vpe->its_vm->vlpi_count[its->list_nr])
> +		if (!vpe->its_vm->vlpi_count[its->list_nr] &&
> +		    !gic_requires_eager_mapping())
>  			continue;
> 
>  		desc.its_vmovp_cmd.col = &its->collections[col_id];

It took me a while to wrap my head around that one, but you're as usual 
spot on.

The use of gic_requires_eager_mapping() is a bit confusing here, as it 
isn't
so much that the VPE is eagerly mapped, but the predicate on which we 
evaluate
the need for a VMOVP. How about this:

diff --git a/drivers/irqchip/irq-gic-v3-its.c 
b/drivers/irqchip/irq-gic-v3-its.c
index cd6451e190c9..348f7a909a69 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -189,6 +189,15 @@ static DEFINE_IDA(its_vpeid_ida);
  #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
  #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)

+/*
+ * Skip ITSs that have no vLPIs mapped, unless we're on GICv4.1, as we
+ * always have vSGIs mapped.
+ */
+static bool require_its_list_vmovp(struct its_vm *vm, struct its_node 
*its)
+{
+	return (gic_rdists->has_rvpeid || vm->vlpi_count[its->list_nr]);
+}
+
  static u16 get_its_list(struct its_vm *vm)
  {
  	struct its_node *its;
@@ -198,7 +207,7 @@ static u16 get_its_list(struct its_vm *vm)
  		if (!is_v4(its))
  			continue;

-		if (vm->vlpi_count[its->list_nr])
+		if (require_its_list_vmovp(vm, its))
  			__set_bit(its->list_nr, &its_list);
  	}

@@ -1295,7 +1304,7 @@ static void its_send_vmovp(struct its_vpe *vpe)
  		if (!is_v4(its))
  			continue;

-		if (!vpe->its_vm->vlpi_count[its->list_nr])
+		if (!require_its_list_vmovp(vpe->its_vm, its))
  			continue;

  		desc.its_vmovp_cmd.col = &its->collections[col_id];


Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
