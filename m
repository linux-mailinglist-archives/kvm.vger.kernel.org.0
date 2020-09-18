Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AF626F77E
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 09:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgIRHza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 03:55:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726344AbgIRHza (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 03:55:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600415728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CRstiCQT/VcDTRvKLZn7v1dtfQ+01y/nuMpQlb2GpZI=;
        b=fxs6Ul4jkECIyi0WO2ww6rZ5NOCosU/4Yeq5u1rqze37GMo7jWoa/9zmoTSSNY6zZlG6nY
        5NN4j0PtTSmMBEqZW40K+AyGjzdXJR6SBEod6R3elvbTCYyCvqRD9ykEygtkIOI4yywtVl
        Y86/TsExYCS2bhJs8j3Qh8hrMZ42I/8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-KoMoPJH4PFOdT1edYx-OfA-1; Fri, 18 Sep 2020 03:55:24 -0400
X-MC-Unique: KoMoPJH4PFOdT1edYx-OfA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 635AD8030A2;
        Fri, 18 Sep 2020 07:55:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 690C268865;
        Fri, 18 Sep 2020 07:55:21 +0000 (UTC)
Date:   Fri, 18 Sep 2020 09:55:18 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        will@kernel.org, zhang.zhanghailiang@huawei.com,
        xiexiangyou@huawei.com
Subject: Re: [RFC v2 7/7] kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
Message-ID: <20200918075518.cbpjb3iswyj3lcym@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-8-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917120101.3438389-8-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 08:01:01PM +0800, Peng Liang wrote:
> Add KVM_CAP_ARM_CPU_FEATURE extension for userpace to check whether KVM
> supports to set CPU features in AArch64.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  Documentation/virt/kvm/api.rst | 8 ++++++++
>  arch/arm64/kvm/arm.c           | 1 +
>  include/uapi/linux/kvm.h       | 1 +
>  3 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index d2b733dc7892..50214ed8f50e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6173,3 +6173,11 @@ specific interfaces must be consistent, i.e. if one says the feature
>  is supported, than the other should as well and vice versa.  For arm64
>  see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
>  For x86 see Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".
> +
> +8.25 KVM_CAP_ARM_CPU_FEATURE
> +-----------------------------------

Too many '----'

> +
> +:Architecture: arm64
> +
> +This capability indicates that userspace can modify the ID registers via
> +KVM_SET_ONE_REG ioctl.

You should say something like "See KVM_SET_ONE_REG:ARM64 ID Registers"
here and also extend the "KVM_SET_ONE_REG" section with a "ARM64 ID
Register" section that describes the limits and return values.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 6d961e192268..918a7a56b224 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -178,6 +178,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>  	case KVM_CAP_ARM_NISV_TO_USER:
>  	case KVM_CAP_ARM_INJECT_EXT_DABT:
> +	case KVM_CAP_ARM_CPU_FEATURE:
>  		r = 1;
>  		break;
>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 7d8eced6f459..12356beadd5a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1037,6 +1037,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_SMALLER_MAXPHYADDR 185
>  #define KVM_CAP_S390_DIAG318 186
>  #define KVM_CAP_STEAL_TIME 187
> +#define KVM_CAP_ARM_CPU_FEATURE 188
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.26.2
>

Thanks,
drew

