Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F3268DEFC
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 18:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbjBGRc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 12:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbjBGRcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 12:32:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44031EBFC
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 09:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675791118;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Emp7X43Gv6S0iQe88Vb8e/Pvs1J6U0weHKSQt4vkRo=;
        b=jBzMds5W05kdttiCMQ0WEGGWQ/ApU54R8jZ2eiJohXFLzudZIDw2WI5MpSUCJvbIeJInAO
        GIwfpChPnvXC+7G1k0BN7LxxW1vBo7ZvCyCtEgn2CsOPEtBvCcccxodbDUUOryGMmI4lOv
        m/sY87gRTt8L0Q/CrUOHSpQOYr0zrRg=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-400-06qe-gkEO_avYLLdk9s3kA-1; Tue, 07 Feb 2023 12:31:57 -0500
X-MC-Unique: 06qe-gkEO_avYLLdk9s3kA-1
Received: by mail-qk1-f200.google.com with SMTP id x7-20020a05620a098700b007242aa494ddso10253888qkx.19
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 09:31:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Emp7X43Gv6S0iQe88Vb8e/Pvs1J6U0weHKSQt4vkRo=;
        b=o+A7pDl0I9joaMVTzPMFY7Y6b5q43PdNzWZ/0XVpMV0wc77L7nCioiEdQt0b6m98H8
         a2G2M1cErzR/Lqk+5KUSK3UmN0ZEiyPlvAyxhId+rcJurt7F0Y04OFrH5PhXU8XYnrtd
         JQtQqWr0VxjaRu6f4825qz6OJDfruuA6irhOrD8qafHARGwkQr2/cFtLTU6OujadPU4a
         rgoqfsixFyICxRLY16lrjerkXEjtbfBFKJF9657JtVvQwAzbAZtygrM0cdcCtkmH9fWw
         u9kl9Qjm5MzSH2jzBGjw0YVSv27c+Fm6KDCh+FeyzMmMx3RwydsDC+OZUjkbkW++R8nE
         /dsQ==
X-Gm-Message-State: AO0yUKXkzsyULufW42BL18e3MGLlGK0N66nwBi7NDPO/hEL2CrsnWOSI
        RZ9azhQrA4p/wv0yXtnASipDm/jyVB7R0a4oZ4V0Uulj2xh87Ib9TN60AzEkGu/VLSLNcv3K4Ak
        DFKQ70RNOO6Vx
X-Received: by 2002:ac8:59c1:0:b0:3b9:b2ba:9b3d with SMTP id f1-20020ac859c1000000b003b9b2ba9b3dmr6808796qtf.54.1675791117209;
        Tue, 07 Feb 2023 09:31:57 -0800 (PST)
X-Google-Smtp-Source: AK7set9rcKbwD3WF2oVGbNOSRg/intgOsW2YkNms5QyLWSOwVDl4uaTl+11DeZ2v3/KeMawWamox8w==
X-Received: by 2002:ac8:59c1:0:b0:3b9:b2ba:9b3d with SMTP id f1-20020ac859c1000000b003b9b2ba9b3dmr6808753qtf.54.1675791116759;
        Tue, 07 Feb 2023 09:31:56 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id bj29-20020a05620a191d00b0071b158849e5sm10008223qkb.46.2023.02.07.09.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 09:31:56 -0800 (PST)
Message-ID: <45ea9f30-9196-88ad-09bb-b72204cb73c8@redhat.com>
Date:   Tue, 7 Feb 2023 18:31:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 6/6] arm: pmu: Fix
 test_overflow_interrupt()
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev,
        reijiw@google.com
References: <20230126165351.2561582-1-ricarkol@google.com>
 <20230126165351.2561582-7-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230126165351.2561582-7-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 1/26/23 17:53, Ricardo Koller wrote:
> test_overflow_interrupt() (from arm/pmu.c) has a test that passes
> because the previous test leaves the state needed to pass: the
> overflow status register with the expected bits. The test (that should
> fail) does not enable the PMU after mem_access_loop(), which clears
> the PMCR, and before writing into the software increment register.
>
> Fix by clearing the previous test state (pmovsclr_el0) and by enabling
> the PMU before the sw_incr test.
>
> Fixes: 4f5ef94f3aac ("arm: pmu: Test overflow interrupts")
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thank you for the fix!

Eric

> ---
>  arm/pmu.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 1e93ea2..f91b5ca 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -914,10 +914,15 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  
>  	write_regn_el0(pmevcntr, 0, pre_overflow);
>  	write_regn_el0(pmevcntr, 1, pre_overflow);
> +	write_sysreg(ALL_SET_32, pmovsclr_el0);
>  	write_sysreg(ALL_SET_32, pmintenset_el1);
>  	isb();
>  
>  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +
> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	isb();
> +
>  	for (i = 0; i < 100; i++)
>  		write_sysreg(0x3, pmswinc_el0);
>  

