Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A4326F705
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 09:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgIRHbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 03:31:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726648AbgIRHbK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 03:31:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600414269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LdWnLFcFIegyMjIcLSZb+4Ju1sWLp3HPRysavBCaabU=;
        b=agC5JSXdsk+KMdpBV7Y4wdVWzqIFXvhIJi99hPS6lTcG6V65kRJwLwEVG5zfrTWAH0Jtu6
        wfSrnhWfHeGWePvJjVoxydyYf8qG9FbZcZHpUOdLK255nusAudgMXL26XIM/zklUgt0Y9E
        /PQ/5QB5VIiT4D6RNkcfdnJZ4AImnEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-FdsgkyYBOICbB1TLa-515w-1; Fri, 18 Sep 2020 03:31:06 -0400
X-MC-Unique: FdsgkyYBOICbB1TLa-515w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E541100855A;
        Fri, 18 Sep 2020 07:31:05 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 027435DEBB;
        Fri, 18 Sep 2020 07:31:02 +0000 (UTC)
Date:   Fri, 18 Sep 2020 09:30:59 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        will@kernel.org, zhang.zhanghailiang@huawei.com,
        xiexiangyou@huawei.com
Subject: Re: [RFC v2 2/7] arm64: introduce check_features
Message-ID: <20200918073059.izmscvrtbnsbgnlj@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-3-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917120101.3438389-3-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 08:00:56PM +0800, Peng Liang wrote:
> To emulate ID registers, we need to validate the value of the register
> defined by user space.  For most ID registers, we need to check whether
> each field defined by user space is no more than that of host (whether
> host support the corresponding features) and whether the fields are
> supposed to be exposed to guest.  Introduce check_features to do those
> jobs.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |  2 ++
>  arch/arm64/kernel/cpufeature.c      | 23 +++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 2ba7c4f11d8a..954adc5ca72f 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -579,6 +579,8 @@ void check_local_cpu_capabilities(void);
>  
>  u64 read_sanitised_ftr_reg(u32 id);
>  
> +int check_features(u32 sys_reg, u64 val);
> +
>  static inline bool cpu_supports_mixed_endian_el0(void)
>  {
>  	return id_aa64mmfr0_mixed_endian_el0(read_cpuid(ID_AA64MMFR0_EL1));
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 698b32705544..e58926992a70 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2850,3 +2850,26 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
>  
>  	return sprintf(buf, "Vulnerable\n");
>  }
> +
> +int check_features(u32 sys_reg, u64 val)
> +{
> +	struct arm64_ftr_reg *reg = get_arm64_ftr_reg(sys_reg);
> +	const struct arm64_ftr_bits *ftrp;
> +	u64 exposed_mask = 0;
> +
> +	if (!reg)
> +		return -ENOENT;
> +
> +	for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
> +		if (arm64_ftr_value(ftrp, reg->sys_val) <
> +		    arm64_ftr_value(ftrp, val)) {
> +			return -EINVAL;

This assumes that 0b1111 is invalid if the host has e.g. 0b0001,
but, IIRC, there are some ID registers where 0b1111 means the
feature is disabled.

> +		}
> +		exposed_mask |= arm64_ftr_mask(ftrp);
> +	}
> +
> +	if (val & ~exposed_mask)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> -- 
> 2.26.2
> 

I don't think we should be trying to do the verification at the ftr_bits
level, at least not generally. Trying to handle all ID registers the
same way is bound to fail, for the 0b1111 vs. 0b0000 reason pointed
out above, and probably other reasons. As I stated before, we should be
validating each feature of each ID register on a case by case basis,
and we should be using higher level CPU feature checking APIs to get
that right.

Also, what about validating that all VCPUs have consistent features
exposed? Each VCPU could select a valid feature mask by this check,
but different ones, which will obviously create a completely broken
guest.

Thanks,
drew

