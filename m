Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D5926F698
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 09:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIRHSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 03:18:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39461 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726159AbgIRHSb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 03:18:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600413510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UayBdJRC8Dc6q3iwkfKhighJ8Kurx0LGvj81jk1QulA=;
        b=LEJq3mjGn2n69rdcS6QRW1SE7Xj0IRHrm3ImFLTr7cyJVC9QMjp91YI0VMQC4V0WTvlEQ2
        hDH4nV4pFiIIJh8GD5Qq2hh2MLJ2PSwgARiplSVWqG4hEFjBkSh8NaBxZR9hMQeRFhAs6m
        vns0qOq19yglcml/XsGJ3rvqDaTCPHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-IoD1hUjtPM-ntVodmjwVnw-1; Fri, 18 Sep 2020 03:18:26 -0400
X-MC-Unique: IoD1hUjtPM-ntVodmjwVnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30B396408E;
        Fri, 18 Sep 2020 07:18:25 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 319EC60C13;
        Fri, 18 Sep 2020 07:18:22 +0000 (UTC)
Date:   Fri, 18 Sep 2020 09:18:20 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        will@kernel.org, zhang.zhanghailiang@huawei.com,
        xiexiangyou@huawei.com
Subject: Re: [RFC v2 1/7] arm64: add a helper function to traverse
 arm64_ftr_regs
Message-ID: <20200918071820.e6hghta4yclio7ca@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-2-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917120101.3438389-2-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 08:00:55PM +0800, Peng Liang wrote:
> If we want to emulate ID registers, we need to initialize ID registers
> firstly.  This commit is to add a helper function to traverse
> arm64_ftr_regs so that we can initialize ID registers from
> arm64_ftr_regs.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |  2 ++
>  arch/arm64/kernel/cpufeature.c      | 13 +++++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 89b4f0142c28..2ba7c4f11d8a 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -79,6 +79,8 @@ struct arm64_ftr_reg {
>  
>  extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
>  
> +int arm64_cpu_ftr_regs_traverse(int (*op)(u32, u64, void *), void *argp);
> +
>  /*
>   * CPU capabilities:
>   *
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 6424584be01e..698b32705544 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1112,6 +1112,19 @@ u64 read_sanitised_ftr_reg(u32 id)
>  	return regp->sys_val;
>  }
>  
> +int arm64_cpu_ftr_regs_traverse(int (*op)(u32, u64, void *), void *argp)
> +{
> +	int i, ret;
> +
> +	for (i = 0; i <  ARRAY_SIZE(arm64_ftr_regs); i++) {
> +		ret = (*op)(arm64_ftr_regs[i].sys_id,
> +			    arm64_ftr_regs[i].reg->sys_val, argp);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
>  #define read_sysreg_case(r)	\
>  	case r:		return read_sysreg_s(r)
>  
> -- 
> 2.26.2
>

Skimming the rest of the patches to see how this is used I only saw a
single callsite. Why wouldn't we just put this simple for-loop right
there at that callsite? Or, IOW, I think this traverse function should
be dropped.

Thanks,
drew

