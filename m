Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DA95B6B34
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 11:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiIMJxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 05:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiIMJxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 05:53:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECFF5B043
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 02:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663062778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H+b3p8jJeOUzB9Y7KKCEYhhWbXEO9sDNunqO8TSV3bM=;
        b=g+1McP0JrkCwAU1s+QDDAbPdAj9mkPi0zKU0LgTRG9CXskC3DH2dybQYlfjIPS9ScyfKxP
        FIWWDUl8UtJlT2s1R04kmi4TALCr2XoGp0ORp+zQRljvSqskiZRPYf8k6HlMOzHP2gM12K
        5GuonWKl3lxznJjdRiDd8kO236GafZg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-270-QTl8svaWPJ2wtzbnpWuNWA-1; Tue, 13 Sep 2022 05:52:57 -0400
X-MC-Unique: QTl8svaWPJ2wtzbnpWuNWA-1
Received: by mail-wm1-f70.google.com with SMTP id c3-20020a7bc843000000b003b486fc6a40so2440148wml.7
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 02:52:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=H+b3p8jJeOUzB9Y7KKCEYhhWbXEO9sDNunqO8TSV3bM=;
        b=e2sdWZ0YNFF6Ib02RI7ZS92r4nT7pubIgW/44kAkghSzrhNCXmUwb8l2V73Pnlo0d8
         gpxXhndJ7Wd2M/lsc21jUmzb1nipJk3e/oonZSoFiFsjTdDp8PC46gWNKSCihGbPTdtO
         PKbG27yOXfvLLnhAYkYDxXhFIpmsIgW0Mi0lf4Gu5wzG3rwhlbbKkJBB/YbOw3aNMTIh
         8mAttCpfTPLDy6Cm2d0ThKIGrV0P8IfgcheUq9gI0fHS8rzKJ3u2oTt/MT87Y3Oag/Mo
         ZkEWbz8x4IXATbzkz1FUSmNLl7ljzLrzggXHj3p/JDVmYVpUG3omYLO8+b2L1y8+y7Ji
         sOCQ==
X-Gm-Message-State: ACgBeo09XZJ3Jzr2N7WeavGVcoxh9GZpxfMK+pNz+n7r92LJhb2WFbDm
        3qLwJdPvFn1TbfNGPvKp+PzOGhUr4M7OLi+U8ewNCHznI7TDJfvX9ECckN1yD08frxRZ5gdPRW3
        oNZxzGwrHOyPl
X-Received: by 2002:a7b:cbd2:0:b0:3b4:33d1:d938 with SMTP id n18-20020a7bcbd2000000b003b433d1d938mr1687999wmi.123.1663062775984;
        Tue, 13 Sep 2022 02:52:55 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4zvkBVGOCRYEBRc8uffdd7P4Et7K4jKKL5qQNyq1mHNhsM3qay0zjBhaFU0U/N0i61OSqVEA==
X-Received: by 2002:a7b:cbd2:0:b0:3b4:33d1:d938 with SMTP id n18-20020a7bcbd2000000b003b433d1d938mr1687990wmi.123.1663062775806;
        Tue, 13 Sep 2022 02:52:55 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o12-20020a5d4a8c000000b002285f73f11dsm12303111wrq.81.2022.09.13.02.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 02:52:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: selftests: Rename 'msr->availble' to
 'msr->should_not_gp' in hyperv_features test
In-Reply-To: <Yx87WXMXGzLxrT0f@google.com>
References: <20220831085009.1627523-1-vkuznets@redhat.com>
 <20220831085009.1627523-3-vkuznets@redhat.com>
 <Yx87WXMXGzLxrT0f@google.com>
Date:   Tue, 13 Sep 2022 11:52:54 +0200
Message-ID: <874jxbr47d.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Aug 31, 2022, Vitaly Kuznetsov wrote:
>> It may not be clear what 'msr->availble' means. The test actually
>> checks that accessing the particular MSR doesn't cause #GP, rename
>> the varialble accordingly.
>> 
>> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  .../selftests/kvm/x86_64/hyperv_features.c    | 92 +++++++++----------
>>  1 file changed, 46 insertions(+), 46 deletions(-)
>> 
>> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
>> index 79ab0152d281..4ec4776662a4 100644
>> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
>> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
>> @@ -33,7 +33,7 @@ static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
>>  
>>  struct msr_data {
>>  	uint32_t idx;
>> -	bool available;
>> +	bool should_not_gp;
>
> I agree that "available" is a bit inscrutable, but "should_not_gp" is also odd.
>

I think Max suggested it to reduce the code churn and I silently agreed.

> What about inverting it to?
>
> 	bool gp_expected;
>
> or maybe even just
>
> 	bool fault_expected;
>
> and letting the assert define which vector is expected.
>

This also works, will change.

-- 
Vitaly

