Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F564FDCCA
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 13:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239837AbiDLKlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 06:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355853AbiDLKdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 06:33:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7237917076
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 02:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649756078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xnxDli1btAgXsk0W1CxQfR+KJ5XVP6RYmZ4+xnhZLt0=;
        b=UMJP3k+50i7JHQZvYgEXouUyign+0cyscmjQtsOPEYTTt+GPxYVVvmIxfN5iDBlkMAolGq
        4EZBrBZ2rbSuhkGoF00QKjneb5cZWbfn+prWBH7lahLfXazf/VrDaHE38GIGaJmBxYyy0Q
        jMlG++aHerAYR0Luob5VjPqmGLmO3zE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-Sr_aL8FyNcOY7dSBawgCaw-1; Tue, 12 Apr 2022 05:34:36 -0400
X-MC-Unique: Sr_aL8FyNcOY7dSBawgCaw-1
Received: by mail-wm1-f72.google.com with SMTP id i6-20020a05600c354600b0038be262d9d9so1028895wmq.8
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 02:34:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xnxDli1btAgXsk0W1CxQfR+KJ5XVP6RYmZ4+xnhZLt0=;
        b=pAac2tlIcLOeHCjS6FALUrqiTGtapub7nghLQw+B2sXdqyEKrZyccKqJepK3BfNzpF
         U5ocswjaE4FwmJ/WLWV8fCQElyWEklBXU5OMvX/SDT3F8jZCraTOhq6DCPT4q8eusriu
         NCBz69ZZ+PuJzorA5s+3jLsrNVDZZyQ60S2lYTpc/AffSfCmWZJQVssrDkgjtjFnwZd0
         OKwAmgH8vWxfh8JZ9RW2xb5Of1yJcRk7SPNNOCF6eQB5D29tP/8nd0cfn1xIUwG6JsbU
         tyiz272sdb2mtQ5t9tD+lsxKPiat6jem2QxjNgWOKZQd6t2b3i6SvnG3MgiREVWZRkCI
         0qJA==
X-Gm-Message-State: AOAM530w4BVnztgp6gstOth3vmrPqkU72M/CfPsbWrqljJU+BAIioBQ3
        SsB4vUdKpefqhE+4EMGMtfDtjqL24rnxXfXIf424QvK9UQgOJ2QY8Zzt+Y4284Nm7nLqvnWMqRM
        4rWRmOhHDcbXv
X-Received: by 2002:a5d:6f02:0:b0:207:a746:dc8 with SMTP id ay2-20020a5d6f02000000b00207a7460dc8mr6771713wrb.11.1649756075278;
        Tue, 12 Apr 2022 02:34:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXTkimYPKXc/REfwMVbD9Mt28s60yF/2ettpqwl3Pocb++IITJeleOL+JH9b39wGeWZ2DiSg==
X-Received: by 2002:a5d:6f02:0:b0:207:a746:dc8 with SMTP id ay2-20020a5d6f02000000b00207a7460dc8mr6771701wrb.11.1649756075041;
        Tue, 12 Apr 2022 02:34:35 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id l15-20020a05600c4f0f00b0038cbdf5221dsm2039714wmq.41.2022.04.12.02.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 02:34:34 -0700 (PDT)
Message-ID: <cb6d8f0b-3fb4-670c-f05e-5755d8352cdf@redhat.com>
Date:   Tue, 12 Apr 2022 11:34:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH v1 2/3] s390x: tprot: use system include
 for mmu.h
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220412092941.20742-1-nrb@linux.ibm.com>
 <20220412092941.20742-2-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220412092941.20742-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/04/2022 11.29, Nico Boehr wrote:
> mmu.h should come from the system includes

Maybe: s/system/lib/

> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/tprot.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/tprot.c b/s390x/tprot.c
> index 460a0db7ffcf..760e7ecdf914 100644
> --- a/s390x/tprot.c
> +++ b/s390x/tprot.c
> @@ -12,7 +12,7 @@
>   #include <bitops.h>
>   #include <asm/pgtable.h>
>   #include <asm/interrupt.h>
> -#include "mmu.h"
> +#include <mmu.h>
>   #include <vmalloc.h>
>   #include <sclp.h>
>   

Reviewed-by: Thomas Huth <thuth@redhat.com>

