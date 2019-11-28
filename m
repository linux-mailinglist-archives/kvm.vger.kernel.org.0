Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA4A10C576
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 09:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfK1IvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 03:51:07 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22586 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726558AbfK1IvH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 03:51:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574931066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z2AWT2wfs52RoPoC1URLCNPcXbKnNNEn9oPMtuH3iEM=;
        b=I2HYlDsCJZ/ZpcE73Grw+Yig4oZbnnfSViCJpdctKFrMt0j5ZroM5XVIS7Kqz77/vHpmF/
        UUh/E2HuVoKSZ8IdZg6nrA6iN3PjnGX7Rqecjww/ndghM1+yeOvr3KoEZq9FJ20jlHoCW6
        ypu7Jd42Rn0VYIMy0twLp+t5+FuA69g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-CQZwoQXMPoCxtxZUTHqI0A-1; Thu, 28 Nov 2019 03:51:02 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD8F7DBCB;
        Thu, 28 Nov 2019 08:50:59 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 67F7860BE1;
        Thu, 28 Nov 2019 08:50:53 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: get rid of var ret and out jump label in
 kvm_arch_vcpu_ioctl_set_guest_debug()
To:     linmiaohe <linmiaohe@huawei.com>, maz@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, catalin.marinas@arm.com,
        gregkh@linuxfoundation.org, will@kernel.org,
        andre.przywara@arm.com, tglx@linutronix.de
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1574910582-14405-1-git-send-email-linmiaohe@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e0fae674-4bf7-3ad2-a5ab-e490510ce04f@redhat.com>
Date:   Thu, 28 Nov 2019 09:50:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1574910582-14405-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: CQZwoQXMPoCxtxZUTHqI0A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/28/19 4:09 AM, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> The var ret and out jump label is not really needed. Clean them
> up.
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  arch/arm64/kvm/guest.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 2fff06114a8f..3b836c91609e 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -834,14 +834,10 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  					struct kvm_guest_debug *dbg)
>  {
> -	int ret = 0;
> -
>  	trace_kvm_set_guest_debug(vcpu, dbg->control);
>  
> -	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK) {
> -		ret = -EINVAL;
> -		goto out;
> -	}
> +	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
> +		return -EINVAL;
>  
>  	if (dbg->control & KVM_GUESTDBG_ENABLE) {
>  		vcpu->guest_debug = dbg->control;
> @@ -856,8 +852,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  		vcpu->guest_debug = 0;
>  	}
>  
> -out:
> -	return ret;
> +	return 0;
>  }
>  
>  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
> 

