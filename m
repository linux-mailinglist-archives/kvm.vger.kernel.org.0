Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF9A4E4E14
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 09:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242638AbiCWIWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 04:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242619AbiCWIWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 04:22:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44EEB6EB32
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 01:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648023662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AjneZe//Jy/LdiEp0CcjBKj0YtofdZ8Csybn3usyaBQ=;
        b=HgMptUuZIa7RvtVFLBozAtu/FKQhSO4twD77LC8oLJFd6M6JLrcSFKSqMNa3ToAkLdZbTJ
        BsfJT73aIMRmsOW4w1QDD+3oph7c2n3YZHT3n7FwWOStPD2sqwpm60lLCh5wsRXz7cuUYl
        LJQuybR5hyxlQT1yzd7sDayKOMTVweo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-vKEOaMjBOq62FZOxFHx2Fg-1; Wed, 23 Mar 2022 04:21:00 -0400
X-MC-Unique: vKEOaMjBOq62FZOxFHx2Fg-1
Received: by mail-wm1-f70.google.com with SMTP id v2-20020a05600c214200b0038c7c02deceso352184wml.8
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 01:21:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AjneZe//Jy/LdiEp0CcjBKj0YtofdZ8Csybn3usyaBQ=;
        b=YLdUfJGnb8Jt0T5XJbUEGOVcLXzqn+S3tSW/EJScoFqUP8iy+zajHiJaIP7S5o2S8e
         Y+3oK59g8n/Cvuml55SVglOZrsosPMvnSby338szZSjGvl5mpfK2Vh7XozpSlPE5ZPQK
         yT6Y5Sn6B7gFjucI2yvtqcT2/zBCHUFIoEIPCWAyngxkEPC4AJxMzwvhEsuAuq49N8LO
         elzO1qeqJFIyOOHT+gpPlyztCCcK2JMp5irPzrDB5EgOgJuV5D7Wb7PP72wqwXT+FjzM
         y+CauWYEorfo4Dv5bQ/WWdc0K/PCl8cnbhsjUG4hb6UW4aArT1BCh4gwLK6yG2u3Kb1c
         mM6g==
X-Gm-Message-State: AOAM533u2CO88e0rI03cft2Iv3CvO3/J6x1XJcrE83RBAPxV0h4KWQAw
        pIltkZ7QarH/IXL6LB71rh2rvg8f0xCECnrvhwARaJQpq8Qd45vXhRguLkXcefFlRa2eq2cdxHh
        a+i5H5SFOrC0u
X-Received: by 2002:a05:6000:1704:b0:203:d857:aa7a with SMTP id n4-20020a056000170400b00203d857aa7amr25595185wrc.513.1648023659773;
        Wed, 23 Mar 2022 01:20:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyezEC9YG07hWIc+9sLhGHT5LZlXsdawoMS5l4RPiJxJWBN8wK1DCT75OefXiOF0nHSFAxClg==
X-Received: by 2002:a05:6000:1704:b0:203:d857:aa7a with SMTP id n4-20020a056000170400b00203d857aa7amr25595172wrc.513.1648023659522;
        Wed, 23 Mar 2022 01:20:59 -0700 (PDT)
Received: from [192.168.8.104] (tmo-098-218.customers.d1-online.com. [80.187.98.218])
        by smtp.gmail.com with ESMTPSA id c11-20020a05600c0a4b00b0037c91e085ddsm4178524wmq.40.2022.03.23.01.20.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 01:20:59 -0700 (PDT)
Message-ID: <4b04c94d-1593-281e-8025-97844e824c8e@redhat.com>
Date:   Wed, 23 Mar 2022 09:20:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH v3 1/1] runtime: indicate failure on
 crash/timeout/abort in TAP
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     mhartmay@linux.ibm.com, frankja@linux.ibm.com, pbonzini@redhat.com
References: <20220322134407.614587-1-nrb@linux.ibm.com>
 <20220322134407.614587-2-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220322134407.614587-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/2022 14.44, Nico Boehr wrote:
> When we have crashes, timeouts or aborts, there is currently no indication for
> this in the TAP output. When all reports() up to this point succeeded, this
> might result in a TAP file looking completely fine even though things went
> terribly wrong.
> 
> For example, when I set the timeout for the diag288 test on s390x to 1 second,
> it fails because it takes quite long, which is properly indicated in the
> normal output:
> 
> $ ./run_tests.sh diag288
> FAIL diag288 (timeout; duration=1s)
> 
> But, when I enable TAP output, I get this:
> 
> $ ./run_tests.sh -t diag288
> TAP version 13
> ok 1 - diag288: diag288: privileged: Program interrupt: expected(2) == received(2)
> ok 2 - diag288: diag288: specification: uneven: Program interrupt: expected(6) == received(6)
> ok 3 - diag288: diag288: specification: unsupported action: Program interrupt: expected(6) == received(6)
> ok 4 - diag288: diag288: specification: unsupported function: Program interrupt: expected(6) == received(6)
> ok 5 - diag288: diag288: specification: no init: Program interrupt: expected(6) == received(6)
> ok 6 - diag288: diag288: specification: min timer: Program interrupt: expected(6) == received(6)
> 1..6
> 
> Which looks like a completely fine TAP file, but actually we ran into a timeout
> and didn't even run all tests.
> 
> With this patch, we get an additional line at the end which properly shows
> something went wrong:
> 
> not ok 7 - diag288: timeout; duration=1s
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>   scripts/runtime.bash | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 6d5fced94246..86405604522d 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -163,8 +163,17 @@ function run()
>           print_result "SKIP" $testname "$summary"
>       elif [ $ret -eq 124 ]; then
>           print_result "FAIL" $testname "" "timeout; duration=$timeout"
> +        if [ "$tap_output" = "yes" ]; then
> +            echo "not ok TEST_NUMBER - ${testname}: timeout; duration=$timeout" >&3
> +        fi
>       elif [ $ret -gt 127 ]; then
> -        print_result "FAIL" $testname "" "terminated on SIG$(kill -l $(($ret - 128)))"
> +        signame="SIG"$(kill -l $(($ret - 128)))
> +        print_result "FAIL" $testname "" "terminated on $signame"
> +        if [ "$tap_output" = "yes" ]; then
> +            echo "not ok TEST_NUMBER - ${testname}: terminated on $signame" >&3
> +        fi
> +    elif [ $ret -eq 127 ] && [ "$tap_output" = "yes" ]; then
> +        echo "not ok TEST_NUMBER - ${testname}: aborted" >&3
>       else
>           print_result "FAIL" $testname "$summary"
>       fi

Thanks, I've pushed it now to the repository!

  Thomas

