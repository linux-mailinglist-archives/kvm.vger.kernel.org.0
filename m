Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C74E7915C6
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 12:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350082AbjIDKkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 06:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjIDKkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 06:40:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9989C19B
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 03:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693823966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wrrAxmOl7Fc5ehdBn/+i35ndvgk9dyz/k3neFMBGrkA=;
        b=FD35wfjmGRw9heSyuuKqFlFd4Fcl7q0kghyBabgsZC1XK0LKcSQrx30d2AOdKBiKWx6KMo
        kW5XJeKDmuR9a8UhCZTLDBBVuczCCeGyIepUKQI2QSKmzp+jEh9GbZg9bnSHYZLnfyA3h+
        usYDVDELU6FMgKoIqbh/6qNXIVgmMA8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-572-bI0s1YSnOxC4WjQTo_IxAQ-1; Mon, 04 Sep 2023 06:39:23 -0400
X-MC-Unique: bI0s1YSnOxC4WjQTo_IxAQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-31f49c34d1fso343686f8f.0
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 03:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693823962; x=1694428762;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wrrAxmOl7Fc5ehdBn/+i35ndvgk9dyz/k3neFMBGrkA=;
        b=GuYrbs+9KuJmp7d+xk871kfsFfkadMxu3ywK2LoGje8YbDjx5p7oaM0LCYfqNX5I0l
         m40MyAq6l1lsQ87wVRvIIU1ID/pB8Jn1GIn0NJp9/Idxv8Koy+ZWQ2+bdWNz7rCfP6y4
         9iHW7PIXziazvjcj84wHNQD57yOOHEg7AsUjvB58UvdYbXDhBCalhxFFgo55vq1VhMUb
         28PGIA+jSrMUayRWryd3TnuiBVotZZUnZfugwl1AbKhgQCGF7lir0h3qUHKdMSi5lXUH
         mcUst5h0/+gAItYlEOKnH8MB3dDxAlIWJy9qDmbJRRe1NyHC37qHaxJRcv6W6rtZVN5E
         lSSg==
X-Gm-Message-State: AOJu0Yzk5aZwpslml3/hZPVfz9PfPgAKdaAoiKoTCcZd3H2AgIQXfAnw
        UFjYo5er4LzxZB1mwRm+IcywocBCOd0wzO79AVzbbf0x9VyfFn8iMuZk03LAPaxpoCWJkbMZnrf
        FIj4zS7IoTJCH3J7gaYvV4ME=
X-Received: by 2002:adf:ed08:0:b0:313:f957:bf29 with SMTP id a8-20020adfed08000000b00313f957bf29mr7363513wro.65.1693823962423;
        Mon, 04 Sep 2023 03:39:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbgplqKkw6Vu6xARK0QJsuOMRprGgSL6s3l9wtqZ/cakGNrxcvoJVirpVMtfzIKF1H1hlANQ==
X-Received: by 2002:adf:ed08:0:b0:313:f957:bf29 with SMTP id a8-20020adfed08000000b00313f957bf29mr7363503wro.65.1693823962157;
        Mon, 04 Sep 2023 03:39:22 -0700 (PDT)
Received: from [10.33.192.199] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id a2-20020adff7c2000000b003177074f830sm14146238wrq.59.2023.09.04.03.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Sep 2023 03:39:21 -0700 (PDT)
Message-ID: <c81706fb-5e90-d431-2f6d-07c1f328e7ed@redhat.com>
Date:   Mon, 4 Sep 2023 12:39:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [kvm-unit-tests PATCH v6 8/8] lib: s390x: interrupt: remove
 TEID_ASCE defines
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230904082318.1465055-1-nrb@linux.ibm.com>
 <20230904082318.1465055-9-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230904082318.1465055-9-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/09/2023 10.22, Nico Boehr wrote:
> These defines were - I can only guess - ment for the asce_id field.

s/ment/meant/

> Since print_decode_teid() used AS_PRIM and friends instead, I see little
> benefit in keeping these around.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/asm/interrupt.h | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index 7f73d473b346..48bd78fa1515 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -13,11 +13,6 @@
>   #define EXT_IRQ_EXTERNAL_CALL	0x1202
>   #define EXT_IRQ_SERVICE_SIG	0x2401
>   
> -#define TEID_ASCE_PRIMARY	0
> -#define TEID_ASCE_AR		1
> -#define TEID_ASCE_SECONDARY	2
> -#define TEID_ASCE_HOME		3
> -
>   union teid {
>   	unsigned long val;
>   	union {

With the nit fixed:
Reviewed-by: Thomas Huth <thuth@redhat.com>

