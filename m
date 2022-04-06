Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20794F5B6D
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 12:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344937AbiDFKax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 06:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345203AbiDFK10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 06:27:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 197D41FC9E6
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 23:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649227831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=198kYOnNlSWatjSWDYkZaZqYlqwH7e8Coxt4+err8d4=;
        b=JhPc3IWdJxqSFLPoFMa3sYcrFSQz62y2hLfB9Wel8RWmNQ+gCr9dDt3NKRcD7woDWZOosb
        XJ64ml6BjwcgZIsrlKVHu03NJSpZGNbdcrxPrW26hvHCXNUds3fLvRZtBIJgcpfrE10VZb
        YSRroFdDd+D3s9I9CLhYBJ2eJv/0J/s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-Axd4ckrNNwGQSW0idBuJrg-1; Wed, 06 Apr 2022 02:50:27 -0400
X-MC-Unique: Axd4ckrNNwGQSW0idBuJrg-1
Received: by mail-wr1-f69.google.com with SMTP id o26-20020adf8b9a000000b0020617a99c43so159887wra.16
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 23:50:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=198kYOnNlSWatjSWDYkZaZqYlqwH7e8Coxt4+err8d4=;
        b=Aqc1/fWucSG4FHMmyeFfTR5B9m8HPMwH5TbbigZ0EY3UUwLysT0SJ0yfeyQnxOEQaB
         eZ1EDz9LHKvGMdT7y9/Zv0W40rzx5DPaERRdLpAKQ9UEQoPwtdnLDEazwq0fqd41exqs
         GLeISFeAQj5BlnVnyveaoxjL/Te4jWM48F8grOD/lWKHC8ipKRe5XNVZCjsCFmkbvx+2
         2dwD+8ljqbcPQS/fhkocsIFxAk9wXdhqri0Sh4lnNbSRGTk5UB/B3yEhATQTyfQd0h1X
         s1X4IpA7XCpLqVMIdr/PJv7Kh8vE0cM6gnastSlIscPbzexj3KH8sLcCxgX0FpMv+5Mf
         ayhQ==
X-Gm-Message-State: AOAM533FvaQRkvRRKEgqkz6y7I3KhbjWzYwqie2U+VB+FM1OcntwKYew
        klx+kFeSlENo+DyjR3BSja9pWB5ecw7YrEFVtvjy76q18lu6mgQsIF+DutYgHSn3j3tAkwZF9vz
        PmicCW5N9686y
X-Received: by 2002:adf:e104:0:b0:206:109a:c90f with SMTP id t4-20020adfe104000000b00206109ac90fmr5345451wrz.259.1649227826281;
        Tue, 05 Apr 2022 23:50:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfOG1UAtZiCdUWJe2kav8TZU14vYZB6bEN6wUGN9uhrYTMYNd2vY7oaKmt5KqiVF2llkm6fA==
X-Received: by 2002:adf:e104:0:b0:206:109a:c90f with SMTP id t4-20020adfe104000000b00206109ac90fmr5345441wrz.259.1649227826101;
        Tue, 05 Apr 2022 23:50:26 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d588a000000b002052e4aaf89sm13896444wrf.80.2022.04.05.23.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 23:50:25 -0700 (PDT)
Message-ID: <bf27586e-4eb2-4392-1293-328c743eb8ec@redhat.com>
Date:   Wed, 6 Apr 2022 08:50:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH 5/8] s390x: pv-diags: Cleanup includes
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
References: <20220405075225.15903-1-frankja@linux.ibm.com>
 <20220405075225.15903-6-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220405075225.15903-6-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/04/2022 09.52, Janosch Frank wrote:
> This file has way too much includes. Time to remove some.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/pv-diags.c | 17 ++---------------
>   1 file changed, 2 insertions(+), 15 deletions(-)
> 
> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
> index 6899b859..9ced68c7 100644
> --- a/s390x/pv-diags.c
> +++ b/s390x/pv-diags.c
> @@ -8,23 +8,10 @@
>    *  Janosch Frank <frankja@linux.ibm.com>
>    */
>   #include <libcflat.h>
> -#include <asm/asm-offsets.h>
> -#include <asm-generic/barrier.h>
> -#include <asm/interrupt.h>
> -#include <asm/pgtable.h>
> -#include <mmu.h>
> -#include <asm/page.h>
> -#include <asm/facility.h>
> -#include <asm/mem.h>
> -#include <asm/sigp.h>
> -#include <smp.h>
> -#include <alloc_page.h>
> -#include <vmalloc.h>
> -#include <sclp.h>
>   #include <snippet.h>
>   #include <sie.h>
> -#include <uv.h>
> -#include <asm/uv.h>
> +#include <sclp.h>
> +#include <asm/facility.h>

Wow, how did we end up with that huge list? Copy-n-paste from other files?

Reviewed-by: Thomas Huth <thuth@redhat.com>


