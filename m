Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5988C115011
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 12:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfLFLxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 06:53:49 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:48713 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726116AbfLFLxt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 06:53:49 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1idCAz-00025P-1c; Fri, 06 Dec 2019 12:53:37 +0100
To:     linmiaohe <linmiaohe@huawei.com>
Subject: Re: [PATCH] KVM: vgic: Fix potential double free dist->spis in  =?UTF-8?Q?=5F=5Fkvm=5Fvgic=5Fdestroy=28=29?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 06 Dec 2019 11:53:36 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <james.morse@arm.com>,
        <julien.thierry.kdev@gmail.com>, <suzuki.poulose@arm.com>,
        <christoffer.dall@arm.com>, <catalin.marinas@arm.com>,
        <eric.auger@redhat.com>, <gregkh@linuxfoundation.org>,
        <will@kernel.org>, <andre.przywara@arm.com>, <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
In-Reply-To: <1574923128-19956-1-git-send-email-linmiaohe@huawei.com>
References: <1574923128-19956-1-git-send-email-linmiaohe@huawei.com>
Message-ID: <c786fec1d39fc8beae4bc4fe4269add9@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: linmiaohe@huawei.com, pbonzini@redhat.com, rkrcmar@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, christoffer.dall@arm.com, catalin.marinas@arm.com, eric.auger@redhat.com, gregkh@linuxfoundation.org, will@kernel.org, andre.przywara@arm.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-11-28 06:38, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
>
> In kvm_vgic_dist_init() called from kvm_vgic_map_resources(), if
> dist->vgic_model is invalid, dist->spis will be freed without set
> dist->spis = NULL. And in vgicv2 resources clean up path,
> __kvm_vgic_destroy() will be called to free allocated resources.
> And dist->spis will be freed again in clean up chain because we
> forget to set dist->spis = NULL in kvm_vgic_dist_init() failed
> path. So double free would happen.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  virt/kvm/arm/vgic/vgic-init.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/virt/kvm/arm/vgic/vgic-init.c 
> b/virt/kvm/arm/vgic/vgic-init.c
> index 53e3969dfb52..c17c29beeb72 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -171,6 +171,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm,
> unsigned int nr_spis)
>  			break;
>  		default:
>  			kfree(dist->spis);
> +			dist->spis = NULL;
>  			return -EINVAL;
>  		}
>  	}

Applied, thanks.

         M.
-- 
Jazz is not dead. It just smells funny...
