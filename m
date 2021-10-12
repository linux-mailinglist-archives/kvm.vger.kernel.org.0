Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93245429E24
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 08:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbhJLG4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 02:56:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233869AbhJLGzu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 02:55:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634021628;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PusTU/wIyb0FBMmdeb7xe1VpsNaesnbUzqyZWS1Qs8o=;
        b=CJrPAytdJDI9Ubdr2jctoMjpMTltswrceEhBhXWKvPuJorZb5mZEItQFKLhSvFvPmfDnNY
        jJ0JqEXtbZWcdP5pXQY87k+8ouaEZCkYyEQAxzF19E1d4BxnUtvO1BO2l7XhifgpdyHwgU
        lo/sG6lbG6E1vUzFYIH8w6ATs/vy4jk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-3XE9AbtjNQGN2ax3wdQmRg-1; Tue, 12 Oct 2021 02:53:47 -0400
X-MC-Unique: 3XE9AbtjNQGN2ax3wdQmRg-1
Received: by mail-wr1-f71.google.com with SMTP id c4-20020a5d6cc4000000b00160edc8bb28so9179092wrc.9
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 23:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PusTU/wIyb0FBMmdeb7xe1VpsNaesnbUzqyZWS1Qs8o=;
        b=m8P5gsvBCIBqFYgFWz8axfwD1RrQZwbCdGomf2WNhr+WScPbxpEi7GkqRqO6MyC0V1
         c+mluxef1U5Gj2ayNJKrLp74sHwqzmaNJhcUrWt9IGoRlbr3NZ+FnhX/NjNHWEXpFT12
         5ygbBKPCfPca+1IzxrAXtdcZrriCLCnQPCZBLYO0F3p/WHW1zQ7k/labjQm//XRN/FgS
         f8rDnzBjOUQt5zjzgcb5AaIXkOxK1ibPRiTwKgCzFUh2DZxfN37iwgte8mmHfaEXPQGr
         wV0G60D8FsnquB75NzdWeBaQjRuZ5iD5Qhe7qWJp1KuW2Jdt3fCMC6JZem1FMWDwkycd
         /TCg==
X-Gm-Message-State: AOAM531hcxCmrYUzxImpxPnda+cWvlxPRaWX8gW3Hp+6jw9uDlpvYwlK
        dzdt+e4g5SR4V8dzYK8o5/wn05n6gIxsHSew5wyeDkZJWB9faWVFrLYjOvMvEfyBq+tOL3wkHF6
        C/FsD2TFh5os0Rlca20DzF7m2WDXqSoH4z8zGgRT5DWP8X5+zMM6UkCX9BF5OrjcncS8=
X-Received: by 2002:adf:a78a:: with SMTP id j10mr29716966wrc.105.1634021625844;
        Mon, 11 Oct 2021 23:53:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxy20Yo3mJbBt8ls3ChSMPXjmopjDKNRAN6cJaZJ/pDMRdkF35AV3gOXZdYNudxhYz0Nq1uBw==
X-Received: by 2002:adf:a78a:: with SMTP id j10mr29716945wrc.105.1634021625552;
        Mon, 11 Oct 2021 23:53:45 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id y8sm9113472wrr.21.2021.10.11.23.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 23:53:45 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests] arm64: gic-v3: Avoid NULL dereferences
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
References: <20211011160420.26785-1-drjones@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <28da2e28-34dc-5516-678b-be4b4153c0ae@redhat.com>
Date:   Tue, 12 Oct 2021 08:53:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211011160420.26785-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,
On 10/11/21 6:04 PM, Andrew Jones wrote:
> LPI allocation requires that the redistributors are configured first.
> It's unlikely that offline cpus have had their redistributors
> configured, so filter them out right away. Also, assert on any cpu,
> not just the calling cpu, in gicv3_lpi_alloc_tables() when we detect
> a unit test failed to follow instructions. Improve the assert with a
> hint message while we're at it.
>
> Cc: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  lib/arm/gic-v3.c       | 6 +++---
>  lib/arm64/gic-v3-its.c | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
> index 2c067e4e9ba2..2f7870ab28bf 100644
> --- a/lib/arm/gic-v3.c
> +++ b/lib/arm/gic-v3.c
> @@ -171,17 +171,17 @@ void gicv3_lpi_alloc_tables(void)
>  	u64 prop_val;
>  	int cpu;
>  
> -	assert(gicv3_redist_base());
> -
>  	gicv3_data.lpi_prop = alloc_pages(order);
>  
>  	/* ID bits = 13, ie. up to 14b LPI INTID */
>  	prop_val = (u64)(virt_to_phys(gicv3_data.lpi_prop)) | 13;
>  
> -	for_each_present_cpu(cpu) {
> +	for_each_online_cpu(cpu) {
>  		u64 pend_val;
>  		void *ptr;
>  
> +		assert_msg(gicv3_data.redist_base[cpu], "Redistributor for cpu%d not initialized. "
> +							"Did cpu%d enable the GIC?", cpu, cpu);
>  		ptr = gicv3_data.redist_base[cpu];
>  
>  		writeq(prop_val, ptr + GICR_PROPBASER);
> diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
> index c22bda3a8ba2..2c69cfda0963 100644
> --- a/lib/arm64/gic-v3-its.c
> +++ b/lib/arm64/gic-v3-its.c
> @@ -104,7 +104,7 @@ void its_enable_defaults(void)
>  	/* Allocate LPI config and pending tables */
>  	gicv3_lpi_alloc_tables();
>  
> -	for_each_present_cpu(cpu)
> +	for_each_online_cpu(cpu)
>  		gicv3_lpi_rdist_enable(cpu);
>  
>  	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);

