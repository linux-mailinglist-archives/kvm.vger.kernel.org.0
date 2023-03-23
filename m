Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4CA6C6886
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 13:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbjCWMhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 08:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbjCWMh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 08:37:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F934274A5
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 05:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679574985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C1ZeVwAMcdgE90JtmIiMiS75gDxyRrOisVDnsuVcwUo=;
        b=ehbJj/GgKj/deuSE0gxty8z+4qfEW2cX1PhDLDSj9clGqpK6AY7bkZu6+6/SyIgbT+0tuQ
        Ps91w2m6y1has1cpZHIcL2jswzMiphNCT7uZCvXYpeafqFEP3mqkCQqJIkjWrzoA9kJbI3
        Xh9D61TrjU2cZrI/99+EEQ/StyztXjI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-t5hsbuH6M2e1RBt0OsrgOg-1; Thu, 23 Mar 2023 08:36:21 -0400
X-MC-Unique: t5hsbuH6M2e1RBt0OsrgOg-1
Received: by mail-wm1-f69.google.com with SMTP id bh19-20020a05600c3d1300b003ee93fac4a9so588508wmb.2
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 05:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679574980;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C1ZeVwAMcdgE90JtmIiMiS75gDxyRrOisVDnsuVcwUo=;
        b=cY/M6NDFDFEnFGs+2AwgzP41wceSDpzMMOegD+KLDChV9oJ5jJCescdIdYtMUxXJq3
         1hgrFEk4ZZaeXF1cHNigYfzIy1nT8k/AKyYN7Pp8uJyoTKq+BlxCn6RMabR5CmQjJVnF
         De187ug8A5oaNNMhGxeq34QY94nC2v8hNSy4oVI5nXny3s+8nm+GCSX7x3Sih2NnENdb
         p574reBwTzATwceLVGnZoU5UjOPtoPXXb7biuX7qvXCLeb6v/sR80hitJHp7aqXuGXDW
         JTD2UenlLSexJcaGJg6JfVAZacnXQEbPBbErGU69AjRlt+H8KyNsAF8Bx/2OTrffZQ5q
         Z69A==
X-Gm-Message-State: AO0yUKWzh33YMM2fEMmkKzY9nIaw4X3wj63FY+UXsHr8RCMfo5xQB77M
        sc0j5IKUURdhwx6iww7fzp2ueFrmlj8yRNH5Uwh9MyWOPK0wMoDgZ2IAj4P10ha+InChlOv8Erd
        K1oIj5jELCYlh
X-Received: by 2002:a7b:c7c6:0:b0:3ed:c84c:7efe with SMTP id z6-20020a7bc7c6000000b003edc84c7efemr2405808wmk.7.1679574980325;
        Thu, 23 Mar 2023 05:36:20 -0700 (PDT)
X-Google-Smtp-Source: AK7set8oDnR+hiI0SXiFClKDLDWGr6LPzKLAvyQijtGW1h8/zF2dqcPY+2ZH3SbZTb15LmBbQxnPpA==
X-Received: by 2002:a7b:c7c6:0:b0:3ed:c84c:7efe with SMTP id z6-20020a7bc7c6000000b003edc84c7efemr2405798wmk.7.1679574980073;
        Thu, 23 Mar 2023 05:36:20 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-179-146.web.vodafone.de. [109.43.179.146])
        by smtp.gmail.com with ESMTPSA id s12-20020a1cf20c000000b003ed1f111fdesm1754301wmc.20.2023.03.23.05.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 05:36:19 -0700 (PDT)
Message-ID: <f03084cc-8ac6-b2cb-b2e8-39bc73843ab7@redhat.com>
Date:   Thu, 23 Mar 2023 13:36:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests v2 06/10] powerpc/sprs: Specify SPRs with data
 rather than code
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
 <20230320070339.915172-7-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230320070339.915172-7-npiggin@gmail.com>
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
> A significant rework that builds an array of 'struct spr', where each
> element describes an SPR. This makes various metadata about the SPR
> like name and access type easier to carry and use.
> 
> Hypervisor privileged registers are described despite not being used
> at the moment for completeness, but also the code might one day be
> reused for a hypervisor-privileged test.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> 
> This ended up a little over-engineered perhaps, but there are lots of
> SPRs, lots of access types, lots of changes between processor and ISA
> versions, and lots of places they are implemented and used, so lots of
> room for mistakes. There is not a good system in place to easily
> see that userspace, supervisor, etc., switches perform all the right
> SPR context switching so this is a nice test case to have. The sprs test
> quickly caught a few QEMU TCG SPR bugs which really motivated me to
> improve the SPR coverage.
> ---
>   powerpc/sprs.c | 589 +++++++++++++++++++++++++++++++++----------------
>   1 file changed, 394 insertions(+), 195 deletions(-)
> 
> diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> index db341a9..dd83dac 100644
> --- a/powerpc/sprs.c
> +++ b/powerpc/sprs.c
> @@ -82,231 +82,407 @@ static void mtspr(unsigned spr, uint64_t val)
>   	: "lr", "ctr", "xer");
>   }
>   
> -uint64_t before[1024], after[1024];
> +static uint64_t before[1024], after[1024];
>   
> -/* Common SPRs for all PowerPC CPUs */
> -static void set_sprs_common(uint64_t val)
> -{
> -	// mtspr(9, val);	/* CTR */ /* Used by mfspr/mtspr */
> -	// mtspr(273, val);	/* SPRG1 */  /* Used by our exception handler */
> -	mtspr(274, val);	/* SPRG2 */
> -	mtspr(275, val);	/* SPRG3 */
> -}
> +#define SPR_PR_READ	0x0001
> +#define SPR_PR_WRITE	0x0002
> +#define SPR_OS_READ	0x0010
> +#define SPR_OS_WRITE	0x0020
> +#define SPR_HV_READ	0x0100
> +#define SPR_HV_WRITE	0x0200
> +
> +#define RW		0x333
> +#define RO		0x111
> +#define WO		0x222
> +#define OS_RW		0x330
> +#define OS_RO		0x110
> +#define OS_WO		0x220
> +#define HV_RW		0x300
> +#define HV_RO		0x100
> +#define HV_WO		0x200
> +
> +#define SPR_ASYNC	0x1000	/* May be updated asynchronously */
> +#define SPR_INT		0x2000	/* May be updated by synchronous interrupt */
> +#define SPR_HARNESS	0x4000	/* Test harness uses the register */
> +
> +struct spr {
> +	const char	*name;
> +	uint8_t		width;
> +	uint16_t	access;
> +	uint16_t	type;
> +};
> +
> +/* SPRs common denominator back to PowerPC Operating Environment Architecture */
> +static const struct spr sprs_common[1024] = {
> +  [1] = {"XER",		64,	RW,		SPR_HARNESS, }, /* Compiler */
> +  [8] = {"LR", 		64,	RW,		SPR_HARNESS, }, /* Compiler, mfspr/mtspr */
> +  [9] = {"CTR",		64,	RW,		SPR_HARNESS, }, /* Compiler, mfspr/mtspr */
> + [18] = {"DSISR",	32,	OS_RW,		SPR_INT, },
> + [19] = {"DAR",		64,	OS_RW,		SPR_INT, },
> + [26] = {"SRR0",	64,	OS_RW,		SPR_INT, },
> + [27] = {"SRR1",	64,	OS_RW,		SPR_INT, },
> +[268] = {"TB",		64,	RO	,	SPR_ASYNC, },
> +[269] = {"TBU",		32,	RO,		SPR_ASYNC, },
> +[272] = {"SPRG0",	64,	OS_RW,		SPR_HARNESS, }, /* Int stack */
> +[273] = {"SPRG1",	64,	OS_RW,		SPR_HARNESS, }, /* Scratch */
> +[274] = {"SPRG2",	64,	OS_RW, },
> +[275] = {"SPRG3",	64,	OS_RW, },
> +[287] = {"PVR",		32,	OS_RO, },
> +};

Using a size of 1024 for each of these arrays looks weird. Why don't you add 
a "nr" field to struct spr and specify the register number via that field 
instead of using the index into the array as register number?

  Thomas

