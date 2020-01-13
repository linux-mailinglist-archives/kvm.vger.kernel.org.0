Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68FB1397E1
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 18:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgAMRiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 12:38:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54730 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727331AbgAMRiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 12:38:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578937085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uceV03oHRXx1E3vMv+AQpLYa8pUwxWrhcTUjGT9wAgg=;
        b=J8pbuSBpre48bblyCitvXaNDA6I/kPUiSQgicqCwyO4iYfxKftXEwgz/xDC+JdjB1trmT8
        y9/rv2DTUwsj0tmbF20ohfVHQ98+Tzp3us76zjkbNJ7HG+Fv11lVDNoqVpbEHJc8bom2ca
        wURys69TEQnEfe8uwbpNXUOyB83PlD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-e3PBCRvpP2ix9wg3H9ZurA-1; Mon, 13 Jan 2020 12:38:01 -0500
X-MC-Unique: e3PBCRvpP2ix9wg3H9ZurA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED7FA107ACC4;
        Mon, 13 Jan 2020 17:37:58 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 83C367E58B;
        Mon, 13 Jan 2020 17:37:53 +0000 (UTC)
Date:   Mon, 13 Jan 2020 18:37:51 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 08/16] arm/arm64: ITS: Init the command
 queue
Message-ID: <20200113173751.q344krmw7bdhrrtg@kamzik.brq.redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
 <20200110145412.14937-9-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110145412.14937-9-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 03:54:04PM +0100, Eric Auger wrote:
> Allocate the command queue and initialize related registers:
> CBASER, CREADR, CWRITER.
> 
> The command queue is 64kB. This aims at not bothing with fullness.

I think these means that the goal isn't completeness? If so, please
write "minimal implementation" or nothing, as all of kvm-unit-tests
is a minimal implementation.

> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v2 -> v3:
> - removed readr
> ---
>  lib/arm/asm/gic-v3-its.h |  6 ++++++
>  lib/arm/gic-v3-its.c     | 22 ++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
> index 2f8b8f1..93814f7 100644
> --- a/lib/arm/asm/gic-v3-its.h
> +++ b/lib/arm/asm/gic-v3-its.h
> @@ -75,10 +75,16 @@ struct its_baser {
>  	int esz;
>  };
>  
> +struct its_cmd_block {
> +	u64     raw_cmd[4];

Do we need these spaces (not even a tab) after the u64?

> +};
> +
>  struct its_data {
>  	void *base;
>  	struct its_typer typer;
>  	struct its_baser baser[GITS_BASER_NR_REGS];
> +	struct its_cmd_block *cmd_base;
> +	struct its_cmd_block *cmd_write;
>  };
>  
>  extern struct its_data its_data;
> diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
> index 6c97569..3037c84 100644
> --- a/lib/arm/gic-v3-its.c
> +++ b/lib/arm/gic-v3-its.c
> @@ -177,3 +177,25 @@ void set_pending_table_bit(int rdist, int n, bool set)
>  		byte &= ~mask;
>  	*ptr = byte;
>  }
> +
> +/**
> + * init_cmd_queue: Allocate the command queue and initialize
> + * CBASER, CREADR, CWRITER
> + */
> +void init_cmd_queue(void);
> +void init_cmd_queue(void)

its_cmd_queue_init

> +{
> +	unsigned long n = SZ_64K >> PAGE_SHIFT;
> +	unsigned long order = fls(n);
> +	u64 cbaser;
> +
> +	its_data.cmd_base = (void *)virt_to_phys(alloc_pages(order));
> +
> +	cbaser = ((u64)its_data.cmd_base | (SZ_64K / SZ_4K - 1)	|
> +			GITS_CBASER_VALID);

120 chars

> +
> +	writeq(cbaser, its_data.base + GITS_CBASER);
> +
> +	its_data.cmd_write = its_data.cmd_base;
> +	writeq(0, its_data.base + GITS_CWRITER);
> +}
> -- 
> 2.20.1
>

Thanks,
drew 

