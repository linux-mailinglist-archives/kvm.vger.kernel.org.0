Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F621717DE2
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 13:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235471AbjEaLSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 07:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235544AbjEaLSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 07:18:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD1C1B0
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 04:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685531865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3T2nAmOrVmwcKXZ6sK7jHxoUUbFeEl+9AVbRgRYZ+/4=;
        b=eZKaeJBu5aS5nCa7NW1SvEH3BimNj2qmXGrx4Hj7EWe9QMbNOx+IDaaXib3mU5N7zCFCYH
        wFnyxZ2NNKLThnR+t7y7F+RTZIazTxnNs5jW/RnQtqs9Gj3/09ZfveoOoJwvQErY9+Ti6f
        P31OX69+7776pik8GHtwBXZ7kK4120k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-1Q0KBTGbOnK1y7m6DnSD4g-1; Wed, 31 May 2023 07:17:43 -0400
X-MC-Unique: 1Q0KBTGbOnK1y7m6DnSD4g-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f5df65fa35so25575465e9.3
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 04:17:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685531862; x=1688123862;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3T2nAmOrVmwcKXZ6sK7jHxoUUbFeEl+9AVbRgRYZ+/4=;
        b=BUfgmYmwLzBEtmD1EiGCU5hGLVJ0gsYBj9gKaj9hpDGvuJ4Oh/pMruGqQG9xK4G+pe
         k9kgSznsGv8UUbthYOBJCsp3iMoSn3oAjdYn4e9YqEbey3bnPhn0vcj+WvnNZ6cCTZNS
         uypb/uUSWmOOOj9hP5ijcfWcxpuuhZKUvk7mb8Tib7iRm3v9CzDh/zp6fm70/NDqXYHe
         /XB+n3SemLWGw+7dO5uZiyf5SK/DwPUQejTqSK6JxrUTPke4salhweQg18oc2RVU2vGf
         nSgoP5KNqKlhJErMyCDvohamwcyEuG1lllXbVeTWutIR+47T34QfgsJPlTOuE2D5r4F6
         8/Xw==
X-Gm-Message-State: AC+VfDz8ptCMe2X2UrTXP0DXz1df2g5KD6JfBN+it3tm49LvXburJNLh
        rmRLHt+CyEuCzw3Aq4Mnv59sUXlP8hi6ap0PiKXSdABBvrFROCPXJ48rotHfdx5MeaZ+xpCPUc6
        +TRgMKkj5At2x
X-Received: by 2002:a05:600c:2150:b0:3f6:e59:c04c with SMTP id v16-20020a05600c215000b003f60e59c04cmr4328169wml.24.1685531862833;
        Wed, 31 May 2023 04:17:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6wYQ7AnW0Wf8Dqmh35rHKhfQbb3NA2hCURHLgqKb9xwnuVEQb92wXEeryHObSYyBuM7U3A3A==
X-Received: by 2002:a05:600c:2150:b0:3f6:e59:c04c with SMTP id v16-20020a05600c215000b003f60e59c04cmr4328163wml.24.1685531862574;
        Wed, 31 May 2023 04:17:42 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-178-4.web.vodafone.de. [109.43.178.4])
        by smtp.gmail.com with ESMTPSA id q25-20020a7bce99000000b003f4268f51f5sm20577594wmj.0.2023.05.31.04.17.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 04:17:42 -0700 (PDT)
Message-ID: <66a9a0da-30c0-2894-5a57-c746af48a4ea@redhat.com>
Date:   Wed, 31 May 2023 13:17:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests PATCH v1] runtime: don't run pv-host tests when
 gen-se-header is unavailable
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230531103227.1385324-1-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230531103227.1385324-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/05/2023 12.32, Nico Boehr wrote:
> When the gen-se-header tool is not given as an argument to configure,
> all tests which act as a PV host will not be built by the makefiles.
> 
> run_tests.sh will fail when a test binary is missing. This means
> when we add the pv-host tests to unittest.cfg we will have FAILs when
> gen-se-header is missing.
> 
> Since it is desirable to have the tests in unittest.cfg, add a new group
> pv-host which designates tests that act as a PV host. These will only
> run if the gen-se-header tool is available.
> 
> The pv-host group is currently not used, but will be with Janoschs
> series "s390x: Add PV SIE intercepts and ipl tests" here:
> https://lore.kernel.org/all/20230502115931.86280-1-frankja@linux.ibm.com/
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   scripts/runtime.bash | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 07b62b0e1fe7..486dbeda8179 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -98,6 +98,11 @@ function run()
>           return
>       fi
>   
> +    if [ -z "$GEN_SE_HEADER" ] && find_word "pv-host" "$groups"; then
> +        print_result "SKIP" $testname "" "no gen-se-header available for pv-host test"
> +        return
> +    fi


Reviewed-by: Thomas Huth <thuth@redhat.com>

