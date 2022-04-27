Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945925115BA
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 13:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiD0LTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 07:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiD0LTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 07:19:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F75BB83
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 04:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651058193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lD82ZVw7R4oth33emnzGpEKoVzB0nYZ0rQFbNb3eTlM=;
        b=MwwD4xRoVkAvrGm0urWzJ+teBHRPnq2/Kl5+DdI2NcFJFTxF2ycC2QttOQTC02cpH+I0Wl
        gPfHiZe8+ju1S/0WzSc5feT6rjfsEL3uv0LNjTA3OnePlBtrC3SVgMejJ3UM8nZAk5ljO1
        5v5pgI/R4uVUjcs+3FltBjWsf4x77A4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-cOXTGdhGMfa9-A6rYXx77g-1; Wed, 27 Apr 2022 07:16:29 -0400
X-MC-Unique: cOXTGdhGMfa9-A6rYXx77g-1
Received: by mail-wr1-f72.google.com with SMTP id d28-20020adf9b9c000000b0020ad4a50e14so633004wrc.3
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 04:16:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lD82ZVw7R4oth33emnzGpEKoVzB0nYZ0rQFbNb3eTlM=;
        b=l7WCy1pF6W0FAVz5U6KLx86LpTECwskkgkwTXWx1lEQyvkx4Hx0OL1lqcYUwflDk0Z
         VNe4rYT/G48IFstiGId+Wzzlh/ylScSsgJQvMSCmHPz9AJnao6cL+Dfit3SI6ULsqO5u
         vb+IXkQbGHMQxg2nZRemoUOU1/6p551EVtESxg96sfGXJGVo04Au3TY3GJIjZMELZehp
         LienEihk/wCHlNEzueTuNbBx03OupoNIcgI4fPGUbE6+zN+U3J3iNbWk5kZekeV95RWv
         25YubwVOwXi5z8n2cUCSi6G0DCbO/W1olD3oNK0W9SOVItTmlq5LnmQTUor8X+bgSiR4
         XvhA==
X-Gm-Message-State: AOAM533yguWXePstLBbUg+qDG3N7JysEq/C12jKyJL95GTd7NziDE5tN
        LoWNcbm74oEILyv8FOO80ZFL2/VqDVfTUMJGGGaN4jsRcrXMHezpJj+A5pIutbnrHPCauAFGm2J
        aI0XLI4Ent3zu
X-Received: by 2002:a05:600c:4e46:b0:393:f5fb:b3df with SMTP id e6-20020a05600c4e4600b00393f5fbb3dfmr7752880wmq.80.1651058188352;
        Wed, 27 Apr 2022 04:16:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyH1Fyr7B5E9RCV/fty2KDzccN4Lj9Zik1drFAwE6YYWr5qOXc6O2hNlJCxc0Nrr/lGkUOHpw==
X-Received: by 2002:a05:600c:4e46:b0:393:f5fb:b3df with SMTP id e6-20020a05600c4e4600b00393f5fbb3dfmr7752871wmq.80.1651058188143;
        Wed, 27 Apr 2022 04:16:28 -0700 (PDT)
Received: from [10.33.192.232] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id k33-20020a05600c1ca100b00393e5967f08sm1319895wms.45.2022.04.27.04.16.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 04:16:27 -0700 (PDT)
Message-ID: <d6116a9c-ac9d-4473-a1e4-e524f4706f18@redhat.com>
Date:   Wed, 27 Apr 2022 13:16:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v6 3/3] Disable s390x skey test in GitLab
 CI
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220427100611.2119860-1-scgl@linux.ibm.com>
 <20220427100611.2119860-4-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220427100611.2119860-4-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/04/2022 12.06, Janis Schoetterl-Glausch wrote:
> The test cases newly added to skey.c require kernel 5.18.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   .gitlab-ci.yml | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 4f3049d8..e5768f1d 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -166,7 +166,7 @@ s390x-kvm:
>     - ./configure --arch=s390x
>     - make -j$(nproc)
>     - ACCEL=kvm ./run_tests.sh
> -      selftest-setup intercept emulator sieve sthyi skey diag10 diag308 pfmf
> +      selftest-setup intercept emulator sieve sthyi diag10 diag308 pfmf
>         cmm vector gs iep cpumodel diag288 stsi sclp-1g sclp-3g css skrf sie
>         | tee results.txt
>     - grep -q PASS results.txt && ! grep -q FAIL results.txt

Reviewed-by: Thomas Huth <thuth@redhat.com>

