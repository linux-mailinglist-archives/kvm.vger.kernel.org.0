Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5552243756
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 11:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHMJKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 05:10:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27744 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726048AbgHMJKl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 05:10:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597309840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WYmYa3wTyDs0toSRca/6MeoUa3K+VKgT/BatpPaLiVM=;
        b=FOY3Ek+sIUhIYp0IqT/mCX/zX7KpUinPTtGZpPUGcvbbqyl+kl+F17LHo6LrTGOJcWC/lR
        2CD/oSeAdFnIX7TBEiQw/8kNaFk+3GBr2RWsGmjt3CyLMDJEKO1XgvIGSIXsJeo1FkswNv
        o6IjVXMvNkVZhnVry7mKQRjFF5XOBk8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-yMOGQ8ArPayW01NhAjnAhg-1; Thu, 13 Aug 2020 05:10:38 -0400
X-MC-Unique: yMOGQ8ArPayW01NhAjnAhg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEF7E1008548;
        Thu, 13 Aug 2020 09:10:36 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E6FBB54596;
        Thu, 13 Aug 2020 09:10:34 +0000 (UTC)
Date:   Thu, 13 Aug 2020 11:10:32 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        will@kernel.org, zhang.zhanghailiang@huawei.com,
        xiexiangyou@huawei.com
Subject: Re: [RFC 4/4] kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
Message-ID: <20200813091032.blyfvuiti7m2xw5i@kamzik.brq.redhat.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
 <20200813060517.2360048-5-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813060517.2360048-5-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 02:05:17PM +0800, Peng Liang wrote:
> Add KVM_CAP_ARM_CPU_FEATURE extension for userpace to check whether KVM
> supports to set CPU features in AArch64.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/kvm/arm.c     | 1 +
>  include/uapi/linux/kvm.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 18ebbe1c64ee..72b9e8fc606f 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -194,6 +194,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>  	case KVM_CAP_ARM_NISV_TO_USER:
>  	case KVM_CAP_ARM_INJECT_EXT_DABT:
> +	case KVM_CAP_ARM_CPU_FEATURE:
>  		r = 1;
>  		break;
>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 1029444d04aa..0eca4f7c7fef 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1035,6 +1035,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_LAST_CPU 184
>  #define KVM_CAP_SMALLER_MAXPHYADDR 185
>  #define KVM_CAP_S390_DIAG318 186
> +#define KVM_CAP_ARM_CPU_FEATURE 187
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.18.4
>

All new caps should be documented in Documentation/virt/kvm/api.rst

Thanks,
drew 

