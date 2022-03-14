Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092454D7DB5
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 09:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbiCNInF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 04:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbiCNInE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 04:43:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EE8E3F333
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 01:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647247314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M3D+kmvpUzavdeadIHI+7mtJKsMBrFU+PHp7YJEyOeA=;
        b=UCIL+RXC1O2Nz6dAzpTCUIKNr3+ENiZwBbOTzst7FwEnsMoCoXa5FOHTYB0TuXQyzR/joS
        hj/6JS34l9JcF9HRjmYGeV9GR12BS/2Qa3smCKnTPMU1l67bRJHqD8ySeW/agP+WFr68/4
        Ifso4kbkxhkWUSk+JjYhFwAhleBRwmg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-VNlwBF8POCCYN31wFLP-sw-1; Mon, 14 Mar 2022 04:41:53 -0400
X-MC-Unique: VNlwBF8POCCYN31wFLP-sw-1
Received: by mail-wr1-f70.google.com with SMTP id z16-20020adff1d0000000b001ef7dc78b23so4089900wro.12
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 01:41:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M3D+kmvpUzavdeadIHI+7mtJKsMBrFU+PHp7YJEyOeA=;
        b=Yn+Xm5D4xLQ9Lo2bDCTuLdGNNczGZgR9Sx00MjizJCVmbVNle3JMaQvo9MeGdS19fq
         PkhLwnQ8lJOE8oLtFObcOMQe6Soaef8QRVTiR/pM79ykcdTRg0FjnyGBPulvjMaugfui
         YJXf4LkdbGCgz31RZ6+sjul39+NPTkhNoC086JiOTsYvWDBmQUCIBw8zCAhzFZg23h/n
         A2OtihrFWsug4AVCAlEmdfghq2pnCY3ZsvzZdOLSz49OgGHNhE3Qb6KeC+NfdcLF6qkw
         rm+IuwqLB72a8YYwnxLAXnmV4A4iCylFj7WTzvl9YZVdbixpcXimLjOgkBO/uYh2GKgX
         xUqQ==
X-Gm-Message-State: AOAM530xsPHdOQoeD+BPpun5iRiIaKU7p0W8Ic5tagjmTQUVbiPWP5Zd
        lZzqv9tSIMwfTRDMv/Dr9hVaalFTrHhfHkhNKrNZDmc+LQPBKQoXe3acAOgIzLdCKZH/a1CCC8Q
        E+hnMjy6UVXkv
X-Received: by 2002:a05:6000:1682:b0:203:9380:abb1 with SMTP id y2-20020a056000168200b002039380abb1mr12241044wrd.484.1647247311802;
        Mon, 14 Mar 2022 01:41:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWBeQDPBJCLBl+4A2igfAKGP0tax9FakuuYz2eay80du3+AIGhsA/k41Upzwe4YooQCZG8jQ==
X-Received: by 2002:a05:6000:1682:b0:203:9380:abb1 with SMTP id y2-20020a056000168200b002039380abb1mr12241019wrd.484.1647247311452;
        Mon, 14 Mar 2022 01:41:51 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id k12-20020adfb34c000000b001f1e13df54dsm12841674wrd.89.2022.03.14.01.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 01:41:51 -0700 (PDT)
Date:   Mon, 14 Mar 2022 09:41:49 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH] arm: Fix typos
Message-ID: <20220314084149.tgrs2cbzp7ttsftg@gator>
References: <20220311170850.2911898-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311170850.2911898-1-thuth@redhat.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 06:08:50PM +0100, Thomas Huth wrote:
> Correct typos which were discovered with the "codespell" utility.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  arm/cstart.S              | 2 +-
>  arm/gic.c                 | 2 +-
>  arm/micro-bench.c         | 2 +-
>  lib/arm64/asm/assembler.h | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 2401d92..7036e67 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -44,7 +44,7 @@ start:
>  
>  	/*
>  	 * set stack, making room at top of stack for cpu0's
> -	 * exception stacks. Must start wtih stackptr, not
> +	 * exception stacks. Must start with stackptr, not
>  	 * stacktop, so the thread size masking (shifts) work.
>  	 */
>  	ldr	sp, =stackptr
> diff --git a/arm/gic.c b/arm/gic.c
> index 1e3ea80..60457e2 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -909,7 +909,7 @@ static void test_its_pending_migration(void)
>  	gicv3_lpi_rdist_disable(pe0);
>  	gicv3_lpi_rdist_disable(pe1);
>  
> -	/* lpis are interleaved inbetween the 2 PEs */
> +	/* lpis are interleaved between the 2 PEs */
>  	for (i = 0; i < 256; i++) {
>  		struct its_collection *col = i % 2 ? collection[0] :
>  						     collection[1];
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index c731b1d..8436612 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -265,7 +265,7 @@ static void timer_post(uint64_t ntimes, uint64_t *total_ticks)
>  {
>  	/*
>  	 * We use a 10msec timer to test the latency of PPI,
> -	 * so we substract the ticks of 10msec to get the
> +	 * so we subtract the ticks of 10msec to get the
>  	 * actual latency
>  	 */
>  	*total_ticks -= ntimes * (cntfrq / 100);
> diff --git a/lib/arm64/asm/assembler.h b/lib/arm64/asm/assembler.h
> index a271e4c..aa8c65a 100644
> --- a/lib/arm64/asm/assembler.h
> +++ b/lib/arm64/asm/assembler.h
> @@ -32,7 +32,7 @@
>   * kvm-unit-tests has no concept of scheduling.
>   *
>   * 	op:		operation passed to dc instruction
> - * 	domain:		domain used in dsb instruciton
> + * 	domain:		domain used in dsb instruction
>   * 	addr:		starting virtual address of the region
>   * 	size:		size of the region
>   * 	Corrupts:	addr, size, tmp1, tmp2
> -- 
> 2.27.0
>

Applied to arm/queue.

Thanks,
drew 

