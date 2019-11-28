Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13EF710C56F
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 09:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfK1ItP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 03:49:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54934 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727508AbfK1ItP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 03:49:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574930954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SR+KTTJ3GlEow7kpfjWw52TLP8VskmK7shD9jzjrLUk=;
        b=dBa/zkhW7Ton+JH9ifZI2LO4hpMx5hP8fcEMRNZqPygU15vxRG7FozHVpi2/wSVMm9vlZb
        GCl92h8vjxzhoFtaIJVVrMx8VKLfHbhmKZNTVu6U6xySU577EPfV9RfDXSzj6sXma+X5nl
        YuG1cxHIHsXPqY2bN4b3tMNfpLxskEs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-k1I8B9FENh-njGBz-WF6VQ-1; Thu, 28 Nov 2019 03:49:13 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82A62107ACE3;
        Thu, 28 Nov 2019 08:49:10 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB6AD60C80;
        Thu, 28 Nov 2019 08:49:03 +0000 (UTC)
Subject: Re: [PATCH] KVM: vgic: Fix potential double free dist->spis in
 __kvm_vgic_destroy()
To:     linmiaohe <linmiaohe@huawei.com>, maz@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, catalin.marinas@arm.com,
        gregkh@linuxfoundation.org, will@kernel.org,
        andre.przywara@arm.com, tglx@linutronix.de
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1574923128-19956-1-git-send-email-linmiaohe@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <115fbbb3-73d5-444a-0aec-61bca0dea435@redhat.com>
Date:   Thu, 28 Nov 2019 09:49:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1574923128-19956-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: k1I8B9FENh-njGBz-WF6VQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/28/19 7:38 AM, linmiaohe wrote:
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
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  virt/kvm/arm/vgic/vgic-init.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 53e3969dfb52..c17c29beeb72 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -171,6 +171,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
>  			break;
>  		default:
>  			kfree(dist->spis);
> +			dist->spis = NULL;
>  			return -EINVAL;
>  		}
>  	}
> 

