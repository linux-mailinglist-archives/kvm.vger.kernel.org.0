Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A03275434
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 18:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387745AbfGYQi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 12:38:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387825AbfGYQiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 12:38:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6DF51307D977;
        Thu, 25 Jul 2019 16:38:25 +0000 (UTC)
Received: from [10.36.116.102] (ovpn-116-102.ams2.redhat.com [10.36.116.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BD7D60C18;
        Thu, 25 Jul 2019 16:38:22 +0000 (UTC)
Subject: Re: [PATCH v3 06/10] KVM: arm/arm64: vgic-its: Invalidate MSI-LPI
 translation cache on ITS disable
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Saidi, Ali" <alisaidi@amazon.com>
References: <20190725153543.24386-1-maz@kernel.org>
 <20190725153543.24386-7-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <7c464951-7892-6407-bc83-1607bac2b4ca@redhat.com>
Date:   Thu, 25 Jul 2019 18:38:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190725153543.24386-7-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 25 Jul 2019 16:38:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/25/19 5:35 PM, Marc Zyngier wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> If an ITS gets disabled, we need to make sure that further interrupts
> won't hit in the cache. For that, we invalidate the translation cache
> when the ITS is disabled.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 09a179820816..05406bd92ce9 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1597,6 +1597,8 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
>  		goto out;
>  
>  	its->enabled = !!(val & GITS_CTLR_ENABLE);
> +	if (!its->enabled)
> +		vgic_its_invalidate_cache(kvm);
>  
>  	/*
>  	 * Try to process any pending commands. This function bails out early
> 
