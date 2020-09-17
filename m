Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AA526D4D8
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 09:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgIQHjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 03:39:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726180AbgIQHjR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 03:39:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600328355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gFxz3S6YXoMOrSDJxG1vrsRe6APjmH4iiOKdeMf0Zas=;
        b=OL+pqbyTEQSn8mYRROZV5VDg1scu5TSsskekTkOxnqI1HJyUketSBxdE+4PaCbVZZ6UqJs
        DNH/yVWRTquqFy49QcRZTGmaJqYxjcWiGDKw90Mj/CABqf+b3KrI3vDBgJWZzDWAPeoFQK
        fb8U9+g4HIPdG7ee19SaD6+TqQYLfQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-zNR9MrB_OvyWpgZYHgXS_g-1; Thu, 17 Sep 2020 03:23:27 -0400
X-MC-Unique: zNR9MrB_OvyWpgZYHgXS_g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B0CE10BBEC3;
        Thu, 17 Sep 2020 07:23:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.179])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 636B97880B;
        Thu, 17 Sep 2020 07:23:22 +0000 (UTC)
Date:   Thu, 17 Sep 2020 09:23:20 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ying Fang <fangying1@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, zhang.zhanghailiang@huawei.com,
        alex.chen@huawei.com
Subject: Re: [PATCH 1/2] KVM: arm64: add KVM_CAP_ARM_MP_AFFINITY extension
Message-ID: <20200917072320.busfksdm62ltpdfp@kamzik.brq.redhat.com>
References: <20200917023033.1337-1-fangying1@huawei.com>
 <20200917023033.1337-2-fangying1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917023033.1337-2-fangying1@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 10:30:32AM +0800, Ying Fang wrote:
> Add KVM_CAP_ARM_MP_AFFINITY extension for userspace to check
> whether KVM supports setting MPIDR on AArch64 platform. Thus
> we can give userspace control over the MPIDR to present
> cpu topology information.
> 
> Signed-off-by: Ying Fang <fangying1@huawei.com>
> ---
>  Documentation/virt/kvm/api.rst | 8 ++++++++
>  arch/arm64/kvm/arm.c           | 1 +
>  include/uapi/linux/kvm.h       | 1 +
>  3 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index eb3a1316f03e..d2fb18613a34 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6159,3 +6159,11 @@ KVM can therefore start protected VMs.
>  This capability governs the KVM_S390_PV_COMMAND ioctl and the
>  KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
>  guests when the state change is invalid.
> +
> +8.24 KVM_CAP_ARM_MP_AFFINITY
> +----------------------------
> +
> +:Architecture: arm64
> +
> +This capability indicates that KVM_ARM_SET_MP_AFFINITY ioctl is available.
> +It is used by to set MPIDR from userspace.
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 46dc3d75cf13..913c8da539b3 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -178,6 +178,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>  	case KVM_CAP_ARM_NISV_TO_USER:
>  	case KVM_CAP_ARM_INJECT_EXT_DABT:
> +	case KVM_CAP_ARM_MP_AFFINITY:
>  		r = 1;

Caps should only return 1 after, or at the same time as, the feature is
introduced, otherwise bisection is broken.

>  		break;
>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f6d86033c4fa..c4874905cd9c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1035,6 +1035,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_LAST_CPU 184
>  #define KVM_CAP_SMALLER_MAXPHYADDR 185
>  #define KVM_CAP_S390_DIAG318 186
> +#define KVM_CAP_ARM_MP_AFFINITY 187
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.23.0
>

Thanks,
drew 

