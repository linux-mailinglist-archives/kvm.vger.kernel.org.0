Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C904F309B
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 14:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbiDEJAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 05:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237467AbiDEIm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 04:42:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3ED5E087
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 01:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649147695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x4AOGqJjZfmSt5BOdEAZNsUMBvrmi8UMagaCyd1GV6o=;
        b=TcO3NCx4NZ3fsc68xWu7kSka3AOC9SlTLvRJCm0HqgD6XqCSG1XmX32htf9D7oenbChlzr
        vUOOMSvSDsPkWcrlgmgoQVvqpNHvRyrkQ1gAWTJ2cEM6TZ50cnbpjoH7d6Ed2QtSJmoNbJ
        TaRmsJEymIfn4DWnzW5Ov+Mpwd+jrIY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284--mR2zp2vNHmjV2870ZWmog-1; Tue, 05 Apr 2022 04:34:54 -0400
X-MC-Unique: -mR2zp2vNHmjV2870ZWmog-1
Received: by mail-wr1-f72.google.com with SMTP id r16-20020adfbb10000000b002060d469943so1259448wrg.4
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 01:34:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x4AOGqJjZfmSt5BOdEAZNsUMBvrmi8UMagaCyd1GV6o=;
        b=BCY9vT+SfoZM5/O11faYdioADBRpgnb18Wu9gFrFEMeUW7xXLbPar1TWplxzbvA7yN
         FI80gCVJfTnjurwccw9fyiRQ7p1bmgBZ5KZwZemobVD6WhoTgpsJaFq69JxxGmh/sGI0
         zoWicuf8W4h6670rYsCVyZALlGeVXbyS1oEujsZlfGgjY/GR+enyUl0TlECQ9KVL9Q6o
         iy2DuCezhss9v/dxHUkGM99KSTZz/bSoPu5/pCcFHIeUqXajiKL9oQLXhz1oQ/Qyayjv
         Cs2y67E0pMf/T6fJQbj1z6BOdJ965rUsc/GFwUZqF/0VLAE98aLtVz4zseqppgzhmefu
         NmsA==
X-Gm-Message-State: AOAM531ON6u81rNVwHY4x4eD/FhRX6yExzLU26Th9xX5hzRz638TfmMe
        169LHyTFKmteUnGe/o8lomGU4jsvGJ+m3uu2gQWCnd4KvM8TIhaED8oA2fxSicCVrRn0+hSoEkv
        iz+fLU4iYK0Jn
X-Received: by 2002:a05:6000:388:b0:204:445:6a56 with SMTP id u8-20020a056000038800b0020404456a56mr1756914wrf.372.1649147693278;
        Tue, 05 Apr 2022 01:34:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQDf/kBQ9A/ofnoHOszDl6yu89JqO25KE7DqKpQ/1rdCMUVuXy2oBRGYoin4CzQpVRx9WVmA==
X-Received: by 2002:a05:6000:388:b0:204:445:6a56 with SMTP id u8-20020a056000038800b0020404456a56mr1756906wrf.372.1649147693048;
        Tue, 05 Apr 2022 01:34:53 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id j17-20020a05600c1c1100b0038e389ab62esm2653163wms.9.2022.04.05.01.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 01:34:52 -0700 (PDT)
Message-ID: <4affb1dc-b9c8-224b-4800-6cb24d197a04@redhat.com>
Date:   Tue, 5 Apr 2022 10:34:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH 1/8] s390x: css: Skip if we're not run by
 qemu
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
References: <20220405075225.15903-1-frankja@linux.ibm.com>
 <20220405075225.15903-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220405075225.15903-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/04/2022 09.52, Janosch Frank wrote:
> There's no guarantee that we even find a device at the address we're
> testing for if we're not running under QEMU.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/css.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index a333e55a..52d35f49 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -15,6 +15,7 @@
>   #include <interrupt.h>
>   #include <asm/arch_def.h>
>   #include <alloc_page.h>
> +#include <hardware.h>
>   
>   #include <malloc_io.h>
>   #include <css.h>
> @@ -641,6 +642,12 @@ int main(int argc, char *argv[])
>   {
>   	int i;
>   
> +	/* There's no guarantee where our devices are without qemu */
> +	if (detect_host() != HOST_IS_KVM && detect_host() != HOST_IS_TCG) {
> +		report_skip("Not running under QEMU");
> +		goto done;
> +	}
> +
>   	report_prefix_push("Channel Subsystem");

Prefix gets pushed after the if-statement (where you jump to "done" via 
goto) ...

>   	enable_io_isc(0x80 >> IO_SCH_ISC);
>   	for (i = 0; tests[i].name; i++) {
> @@ -648,7 +655,8 @@ int main(int argc, char *argv[])
>   		tests[i].func();
>   		report_prefix_pop();
>   	}
> -	report_prefix_pop();
>   
> +done:
> +	report_prefix_pop();

... but here it gets popped in the case of "goto done", too.
==> Please either move the if-statement or the "done" label.

  Thomas


>   	return report_summary();
>   }

