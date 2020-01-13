Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B280C1397F9
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 18:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgAMRpT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 12:45:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21369 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726109AbgAMRpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 12:45:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578937517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZjupOVr34zDecwnMFqtNXPvApC4Q2OCWXOaNuSUosdM=;
        b=OUz1zbmlFyfKsy8aq822AesXDhNIiPxfF1FYRsN4aVwyfhKj1G84GIIz/2GbKoQ/llDCDs
        r4RXzfDvHX1TPgzdK5XUxyCPJSrzWbargUL4Azqsy8a8R1KP9nMFmaqWBA5fVBX1HCpKVR
        eJfZhso//FywyCGUBQIHwbxVy5EgnLs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-EQyERcpHO2KS3VKae6uwbg-1; Mon, 13 Jan 2020 12:45:14 -0500
X-MC-Unique: EQyERcpHO2KS3VKae6uwbg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43FE018B9FC1;
        Mon, 13 Jan 2020 17:45:10 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FB418886A;
        Mon, 13 Jan 2020 17:44:59 +0000 (UTC)
Date:   Mon, 13 Jan 2020 18:44:57 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 09/16] arm/arm64: ITS: Enable/Disable
 LPIs at re-distributor level
Message-ID: <20200113174457.gg35yyeaftbadqki@kamzik.brq.redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
 <20200110145412.14937-10-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110145412.14937-10-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 03:54:05PM +0100, Eric Auger wrote:
> This helper function enables or disables the signaling of LPIs
> at redistributor level.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  lib/arm/asm/gic-v3-its.h |  1 +
>  lib/arm/gic-v3-its.c     | 18 ++++++++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
> index 93814f7..d2db292 100644
> --- a/lib/arm/asm/gic-v3-its.h
> +++ b/lib/arm/asm/gic-v3-its.h
> @@ -99,6 +99,7 @@ extern struct its_baser *its_lookup_baser(int type);
>  extern void set_lpi_config(int n, u8 val);
>  extern u8 get_lpi_config(int n);
>  extern void set_pending_table_bit(int rdist, int n, bool set);
> +extern void gicv3_rdist_ctrl_lpi(u32 redist, bool set);
>  
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMARM_GIC_V3_ITS_H_ */
> diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
> index 3037c84..c7c6f80 100644
> --- a/lib/arm/gic-v3-its.c
> +++ b/lib/arm/gic-v3-its.c
> @@ -199,3 +199,21 @@ void init_cmd_queue(void)
>  	its_data.cmd_write = its_data.cmd_base;
>  	writeq(0, its_data.base + GITS_CWRITER);
>  }
> +
> +void gicv3_rdist_ctrl_lpi(u32 redist, bool set)
> +{
> +	void *ptr;
> +	u64 val;
> +
> +	if (redist >= nr_cpus)
> +		report_abort("%s redist=%d >= cpu_count=%d\n",
> +			     __func__, redist, nr_cpus);

I'd use {} here because of the multiline call. But, we don't
use the report API in common code. Well, apparently s390 has
report calls in lib/s390x/interrupt.c, but I don't really
agree with that. IMO, common code failures should always
be unexpected and just assert/assert_msg.

> +
> +	ptr = gicv3_data.redist_base[redist];
> +	val = readl(ptr + GICR_CTLR);
> +	if (set)
> +		val |= GICR_CTLR_ENABLE_LPIS;
> +	else
> +		val &= ~GICR_CTLR_ENABLE_LPIS;
> +	writel(val,  ptr + GICR_CTLR);
> +}
> -- 
> 2.20.1
> 

Also, you can squash this patch into whatever is going to make use
of this new helper.

Thanks,
drew

