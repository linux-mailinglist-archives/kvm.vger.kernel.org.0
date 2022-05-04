Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112C751A0DA
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 15:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346139AbiEDN1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 09:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346562AbiEDN1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 09:27:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 96577B69
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 06:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651670635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uB9pU3WVk0i1LuRdtZkceOYySjC3eD7Y4gfvJ3CK6XQ=;
        b=XWX5r759Z+3WbkgnSXDYwu6Bun1zf6EuyFhhSx0Iu4YhzVFqDQkv4CyJBRLFow+RTgm5nC
        whcuy2BUNPBPxHn8G8KTEL0uBfcJTH+e3wLAH1YZIVs2ZSusxLBa1sb3ItCOGP02+5EFHK
        neibyO1wkAT7T9+rgv+m7T9ZBIy4yxA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-HyBjcIM-O2i22Jzgwp2_HA-1; Wed, 04 May 2022 09:23:54 -0400
X-MC-Unique: HyBjcIM-O2i22Jzgwp2_HA-1
Received: by mail-wm1-f69.google.com with SMTP id o24-20020a05600c379800b003943412e81dso650708wmr.6
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 06:23:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uB9pU3WVk0i1LuRdtZkceOYySjC3eD7Y4gfvJ3CK6XQ=;
        b=snQTFs5Fou6kcR3XaqjuJk6kxKJHwZTGplz/pU1/Re7N9oYaHBJI/A6a/whXeNOy61
         04uTDmJ7X7cVez/T9OwGXz0BIOZsJX0uM2w2ZVbEHFG5PYYarm30fdV0bwm6bq94/hET
         JGV0SDAFtCNKV4jJmG/959Mm4joHaJjUAAuzpIDVsgU/sS2YtYbhf7jJKgDR9P2ahXWi
         l0m2hF6pTWn2FhdJhFd2cB7ugaDRGiQIC1oxKQWUmZWFxDnDYS5BQko/Hh5JkUgqko/a
         hxNO6Gg0MCW6hE+rul3/3NDc0H0eaA1fKH2T9l9QhrHUxUnaFGW3UtsO+6L/eMgvnNq7
         ZXKw==
X-Gm-Message-State: AOAM530P9Ch0S07t33LxUIgG/vBI3axoq/r/sVRpt9TAxDeOmirYcIrq
        mMZKTR60OBSmT/UDR7boNQkc8DIeW767drKTCbT52bBaOodxhA3xUIOsyhBeqxgDboguAGzdjcx
        rZUP1BZ9z5dTD
X-Received: by 2002:adf:dd92:0:b0:20a:d831:222f with SMTP id x18-20020adfdd92000000b0020ad831222fmr15769064wrl.401.1651670633213;
        Wed, 04 May 2022 06:23:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvpC4eWO+EkcHxIjmYLwcOyVO824hC0NLRSv7y0o2o3UBKigLcRd1t3LvZPdAjJYDFVkO8tA==
X-Received: by 2002:adf:dd92:0:b0:20a:d831:222f with SMTP id x18-20020adfdd92000000b0020ad831222fmr15769057wrl.401.1651670633035;
        Wed, 04 May 2022 06:23:53 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id c29-20020adfa31d000000b0020c66310845sm6627973wrb.55.2022.05.04.06.23.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 06:23:52 -0700 (PDT)
Message-ID: <a5b2fc92-6d7a-54c9-9fcc-dd9b137c4c40@redhat.com>
Date:   Wed, 4 May 2022 15:23:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v7 1/3] s390x: Give name to return value of
 tprot()
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220502154101.3663941-1-scgl@linux.ibm.com>
 <20220502154101.3663941-2-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220502154101.3663941-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/05/2022 17.40, Janis Schoetterl-Glausch wrote:
> Improve readability by making the return value of tprot() an enum.
> 
> No functional change intended.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h | 11 +++++++++--
>   lib/s390x/sclp.c         |  6 +++---
>   s390x/tprot.c            | 24 ++++++++++++------------
>   3 files changed, 24 insertions(+), 17 deletions(-)

Looks fine!

Reviewed-by: Thomas Huth <thuth@redhat.com>

