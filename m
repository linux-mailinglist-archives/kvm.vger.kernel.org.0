Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1B64E3D23
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 12:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbiCVLGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 07:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiCVLGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 07:06:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 550812BD9
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 04:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647947107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6xsoBjxsxLTVGWYLLINl5J9vLFCebDJnf+raJ3Dpk4=;
        b=OzNsbYv6liHGYsrRbw+D/uJYyoCNzjzSIlAozwT9v3rh3PlIC6xK0BGlVgvIGnLlQ82Et1
        7tLWAUrpAHI07SbPYz8Ce06mCfpuw1x7i+NeHI+ucx001mKMwPWxtse/Ig6/0w5KxSFa0w
        zT2TXKC4XyLmQqC8iXCDXQTUPfNKPfg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-ruEtj5qhOxiYjLx07JVNUw-1; Tue, 22 Mar 2022 07:05:06 -0400
X-MC-Unique: ruEtj5qhOxiYjLx07JVNUw-1
Received: by mail-wm1-f72.google.com with SMTP id t2-20020a7bc3c2000000b003528fe59cb9so712911wmj.5
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 04:05:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u6xsoBjxsxLTVGWYLLINl5J9vLFCebDJnf+raJ3Dpk4=;
        b=MzbQ825Q1QH/z0wzBBKWPScByA8X8LxTTPLyA0beM1+RJ2hHW4wGEOJ8H3Tey4S0Oc
         48RrKOgUw6ut6Vx90kpU9EWmd2bqn3Pr30+vP+9kimdpvV/bk/Xs91etA/S19bkrAqhs
         Fytm8Mj3dKdBbX7MeLrKrgEUyPAtRGQEZLcPHRECSmV4i3THFJkcsYOfFtdUkZy+ZS1r
         5A2exTXDL9gLxsK+ohcYtp8Auum/V8IlccxPwtB1OWQbNoyHAUB3aRkiCzXtvz+F1CVf
         iRZr69e5B5RaivBFjjYEcDQ1xWyFRp/psWGzO2M/KextoeS815dbuXkQcH8y8Vlrh11u
         xMdg==
X-Gm-Message-State: AOAM5325vevda+xbI3HGihmIa805cawWlY1aVl826R2TFKnjrNdC7mBD
        BXdRg1S7h129XIGM5vbSYNk75ck5hwxqR3F15t7dQ+N4t7/Xw03EvZANkgeGg5d/K55h0m5D9kt
        QFu4nVCHvIOva
X-Received: by 2002:a5d:62cf:0:b0:203:d97c:3bae with SMTP id o15-20020a5d62cf000000b00203d97c3baemr21869333wrv.237.1647947104877;
        Tue, 22 Mar 2022 04:05:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMvnee+CNJXVAgVktpFQqnx3i6NALtWWlwrTDwbe3sitvGME2Wgo26PGxLl76EcQQrhQNg9Q==
X-Received: by 2002:a5d:62cf:0:b0:203:d97c:3bae with SMTP id o15-20020a5d62cf000000b00203d97c3baemr21869316wrv.237.1647947104650;
        Tue, 22 Mar 2022 04:05:04 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id 2-20020a056000154200b00203ee1fd1desm13428813wry.64.2022.03.22.04.05.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 04:05:03 -0700 (PDT)
Message-ID: <06f6fa45-0eeb-3f5b-5140-300a142d9464@redhat.com>
Date:   Tue, 22 Mar 2022 12:05:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH] runtime: indicate failure on
 crash/timeout/abort in TAP
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     mhartmay@linux.ibm.com, frankja@linux.ibm.com, pbonzini@redhat.com
References: <20220310150322.2111128-1-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220310150322.2111128-1-nrb@linux.ibm.com>
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

On 10/03/2022 16.03, Nico Boehr wrote:
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
> ---
>   scripts/runtime.bash | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 6d5fced94246..b41b3d444e27 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -163,9 +163,19 @@ function run()
>           print_result "SKIP" $testname "$summary"
>       elif [ $ret -eq 124 ]; then
>           print_result "FAIL" $testname "" "timeout; duration=$timeout"
> +        if [[ $tap_output != "no" ]]; then

I'd like to avoid "[[" in new code, and the double negation (!= "no) also 
looks a little bit ugly ... could you please replace this line with:

	if [ "$tap_output" = "yes" ]; then

?

> +            echo "not ok TEST_NUMBER - ${testname}: timeout; duration=$timeout" >&3
> +        fi
>       elif [ $ret -gt 127 ]; then
> -        print_result "FAIL" $testname "" "terminated on SIG$(kill -l $(($ret - 128)))"
> +        signame="SIG"$(kill -l $(($ret - 128)))
> +        print_result "FAIL" $testname "" "terminated on $signame"
> +        if [[ $tap_output != "no" ]]; then

dito

> +            echo "not ok TEST_NUMBER - ${testname}: terminated on $signame" >&3
> +        fi
>       else
> +        if [ $ret -eq 127 ] && [[ $tap_output != "no" ]]; then

dito (especially since this mixes [ and [[ in one line)

> +            echo "not ok TEST_NUMBER - ${testname}: aborted" >&3
> +        fi
>           print_result "FAIL" $testname "$summary"
>       fi

As Marc already mentioned, it's indeed a little bit sad that we now have 
parts of the TAP handling in run_tests.sh and some parts in 
scripts/runtime.bash, but I also can't think of a much nicer solution right 
now ... so with this cosmetics fixed:

Reviewed-by: Thomas Huth <thuth@redhat.com>

