Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51386C6ADC
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 15:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjCWOY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 10:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCWOY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 10:24:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816CA83FB
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679581450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3cxY0YlR+Nav9cgoRAEQz2NR9PgUGMwQJGMBNInuMHU=;
        b=fPpZ7vUvFLKEcgHWv4vDVInkqLi1jTbovZ8cQsYP9rfUlzb0KRZKVvcfJ7V2zdOICA8bv1
        t3r5eLzkO+Djd6TdJ5kxx2Aijjb3V80sA6jXsV3EN39750/ghtb5bT2v7nARMDso9RUvGy
        GGVbZdgM7XxnrH5KarN0t3gaRyaM+h0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-zebO2mxNMGGRdPIOCCd97Q-1; Thu, 23 Mar 2023 10:16:04 -0400
X-MC-Unique: zebO2mxNMGGRdPIOCCd97Q-1
Received: by mail-wm1-f71.google.com with SMTP id d11-20020a05600c34cb00b003ee89ce8cc3so958373wmq.7
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:16:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679580963;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3cxY0YlR+Nav9cgoRAEQz2NR9PgUGMwQJGMBNInuMHU=;
        b=M7nitHI/+B/yJi0pLXD5rIDwAsJfxM3cWpQT6OcgZP2YsGbTGNblNb4aNmD0/g6O+N
         oU0Y02vUjt9YyTj/ocdi+7dA+W0FFdHIxuhXu7Hs7Qzd7SrNvCgORZ4C/1Ue4SOp0yXr
         euxDliXyOZzzKd7qBL5dlXd9WfOQVOxG5WkqkOxyYlUXfjlpWhZJ/MaqLbk2bUj0c81O
         LjfTX2rnqcMbXsZcliclKW+kxiiqCD/JdExBXCx3A84d6MyS7LEhRfLcnWp+pzD/OOt3
         d0VkKCQRl8VC/Tab5L9/oYetY4m1NPciVGFqUi0gmD7j+sNfWUDgw4tpU9Ky2jTnzqGv
         zwoA==
X-Gm-Message-State: AO0yUKVVpyhtnu9iQFtYGBPcP8lwKA6wKLXn+aqLFOb+Ckd+/aVuexr5
        WS/Q625M1MsDX1BuDHhyQdlSuxppOQygRbb6m5FT39HCGd82VNxwO0ohAnhONmEV2yeQQD4uFC3
        M5b6Xrf3CdF7Z
X-Received: by 2002:a1c:4c0d:0:b0:3ed:abb9:7515 with SMTP id z13-20020a1c4c0d000000b003edabb97515mr2479435wmf.11.1679580963329;
        Thu, 23 Mar 2023 07:16:03 -0700 (PDT)
X-Google-Smtp-Source: AK7set/3oWB5oheY84MnPANpjGZQTPaBGqoPuX1i8xTQHcr1RbVYlWVK0NfEAlBy0IX+fO2f9pUY1A==
X-Received: by 2002:a1c:4c0d:0:b0:3ed:abb9:7515 with SMTP id z13-20020a1c4c0d000000b003edabb97515mr2479417wmf.11.1679580963039;
        Thu, 23 Mar 2023 07:16:03 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-179-146.web.vodafone.de. [109.43.179.146])
        by smtp.gmail.com with ESMTPSA id v4-20020a05600c470400b003ee8ab8d6cfsm1991913wmo.21.2023.03.23.07.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 07:16:02 -0700 (PDT)
Message-ID: <9745a2df-1902-6b4c-d617-19fc2e56c909@redhat.com>
Date:   Thu, 23 Mar 2023 15:16:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests v2 10/10] powerpc/sprs: Test hypervisor registers
 on powernv machine
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
 <20230320070339.915172-11-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230320070339.915172-11-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/2023 08.03, Nicholas Piggin wrote:
> This enables HV privilege registers to be tested with the powernv
> machine.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/sprs.c | 31 ++++++++++++++++++++++++-------
>   1 file changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> index dd83dac..a7878ff 100644
> --- a/powerpc/sprs.c
> +++ b/powerpc/sprs.c
> @@ -199,16 +199,16 @@ static const struct spr sprs_power_common[1024] = {
>   [190] = {"HFSCR",	64,	HV_RW, },
>   [256] = {"VRSAVE",	32,	RW, },
>   [259] = {"SPRG3",	64,	RO, },
> -[284] = {"TBL",		32,	HV_WO, },
> -[285] = {"TBU",		32,	HV_WO, },
> -[286] = {"TBU40",	64,	HV_WO, },
> +[284] = {"TBL",		32,	HV_WO, }, /* Things can go a bit wonky with */
> +[285] = {"TBU",		32,	HV_WO, }, /* Timebase changing. Should save */
> +[286] = {"TBU40",	64,	HV_WO, }, /* and restore it. */
>   [304] = {"HSPRG0",	64,	HV_RW, },
>   [305] = {"HSPRG1",	64,	HV_RW, },
>   [306] = {"HDSISR",	32,	HV_RW,		SPR_INT, },
>   [307] = {"HDAR",	64,	HV_RW,		SPR_INT, },
>   [308] = {"SPURR",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
>   [309] = {"PURR",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
> -[313] = {"HRMOR",	64,	HV_RW, },
> +[313] = {"HRMOR",	64,	HV_RW,		SPR_HARNESS, }, /* Harness can't cope with HRMOR changing */
>   [314] = {"HSRR0",	64,	HV_RW,		SPR_INT, },
>   [315] = {"HSRR1",	64,	HV_RW,		SPR_INT, },
>   [318] = {"LPCR",	64,	HV_RW, },
> @@ -350,6 +350,22 @@ static const struct spr sprs_power10_pmu[1024] = {
>   
>   static struct spr sprs[1024];
>   
> +static bool spr_read_perms(int spr)
> +{
> +	if (machine_is_powernv())
> +		return !!(sprs[spr].access & SPR_HV_READ);
> +	else
> +		return !!(sprs[spr].access & SPR_OS_READ);
> +}
> +
> +static bool spr_write_perms(int spr)
> +{
> +	if (machine_is_powernv())
> +		return !!(sprs[spr].access & SPR_HV_WRITE);
> +	else
> +		return !!(sprs[spr].access & SPR_OS_WRITE);
> +}
> +
>   static void setup_sprs(void)
>   {
>   	uint32_t pvr = mfspr(287);	/* Processor Version Register */
> @@ -462,7 +478,7 @@ static void get_sprs(uint64_t *v)
>   	int i;
>   
>   	for (i = 0; i < 1024; i++) {
> -		if (!(sprs[i].access & SPR_OS_READ))
> +		if (!spr_read_perms(i))
>   			continue;
>   		v[i] = mfspr(i);
>   	}
> @@ -473,8 +489,9 @@ static void set_sprs(uint64_t val)
>   	int i;
>   
>   	for (i = 0; i < 1024; i++) {
> -		if (!(sprs[i].access & SPR_OS_WRITE))
> +		if (!spr_write_perms(i))
>   			continue;
> +
>   		if (sprs[i].type & SPR_HARNESS)
>   			continue;
>   		if (!strcmp(sprs[i].name, "MMCR0")) {
> @@ -546,7 +563,7 @@ int main(int argc, char **argv)
>   	for (i = 0; i < 1024; i++) {
>   		bool pass = true;
>   
> -		if (!(sprs[i].access & SPR_OS_READ))
> +		if (!spr_read_perms(i))
>   			continue;
>   
>   		if (sprs[i].width == 32) {

Acked-by: Thomas Huth <thuth@redhat.com>

