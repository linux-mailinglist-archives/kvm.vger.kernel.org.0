Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C6C533FCC
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 17:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244972AbiEYPAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 11:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245073AbiEYO7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 10:59:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4553AEE34
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 07:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653490778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B9ZJreuQbgdzdiW1AG006ri3QhGpTbi1fLfNKi3VzLs=;
        b=TU1mN04Gtjj6Z3FpPie28iGp+yszjECYnmsYnSuJWtQEB9JU/XbtL+8A1S6YeJH3SGZIbM
        edk63e/MJt1F4c+souZ7cGt4U80MlVE0vnATAg8hHIKq1vp8pJd4MBLJobwfFoPlMDhydX
        /8jdmhedBC/jCAO1W7XW1hB0haiScIk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-VNL5_74IOPCKZcJl8-geXQ-1; Wed, 25 May 2022 10:59:37 -0400
X-MC-Unique: VNL5_74IOPCKZcJl8-geXQ-1
Received: by mail-wm1-f70.google.com with SMTP id m9-20020a05600c4f4900b0039746692dc2so4452392wmq.6
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 07:59:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=B9ZJreuQbgdzdiW1AG006ri3QhGpTbi1fLfNKi3VzLs=;
        b=YA/I8g8rIgkkm4GDkV9mM2D4gesWWwGdrbHL+ZEPnVZF1N6LLVwoFn/lG+wFLsHZt0
         s1ggmEm103bvqqCFClQWyG9+QPpMrsQpnEC50tIl4KROgun/qA7aFiB/I5Fw5xSm+p4z
         AVQqESOOAzPR7oYjITQ4dh9u54Oe6GBFXQpRxvTW8weCPbB7VAyaW+n7c2J5y0Uq34T2
         RGecURcsQA5pSD8VjWmOOCPTLC8LEtUZX0JG9W//5szLv+dkDVpV0Sk3aNYGOTaza3sx
         rSh9Obhgiql1vxJBwd/P06A+JZS4s2AmU46wrDBG6tRhr2a/3Pb3aqincKYz0HpBnN6Z
         zITQ==
X-Gm-Message-State: AOAM533l2yQc5uU+SDVtIBonAGXr1zcSjtNulFV1+lTe3XOtQQEif3fU
        MUXRfI7NbttMmwXOTGJWu2YIhH+ULYG/M1ARTVlnaCbKqWBfVeTONzUt7ccELHR+5J8mqf9iDmE
        NBw0eK4eTFVUFBWYu/lFfS1twsVdzPhNQ0xSSOG8PtPfx9m8Ryie4eB1VwdzOlYKR
X-Received: by 2002:a5d:452c:0:b0:210:1f5:f7e4 with SMTP id j12-20020a5d452c000000b0021001f5f7e4mr2169032wra.184.1653490775928;
        Wed, 25 May 2022 07:59:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8LxrMmb3c/E17tAv28ak7DGswydUQmm54fa7N5L88qAXKPCM3cMpXUmjd011T8FtzcInIbA==
X-Received: by 2002:a5d:452c:0:b0:210:1f5:f7e4 with SMTP id j12-20020a5d452c000000b0021001f5f7e4mr2169006wra.184.1653490775632;
        Wed, 25 May 2022 07:59:35 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r18-20020a05600c35d200b003942a244f53sm2316308wmq.44.2022.05.25.07.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 07:59:35 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: FYI: hyperv_clock  selftest has random failures
In-Reply-To: <201c43722d7f0faffc9a2377fd25fd31f4565898.camel@redhat.com>
References: <201c43722d7f0faffc9a2377fd25fd31f4565898.camel@redhat.com>
Date:   Wed, 25 May 2022 16:59:34 +0200
Message-ID: <87zgj5r73d.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> Just something I noticed today. Happens on both AMD and Intel, kvm/queue. 
>
> Likely the test needs lower tolerancies.
>
> I'll investigate this later
>
> This is on my AMD machine (3970X):
>
> [mlevitsk@starship ~/Kernel/master/src/tools/testing/selftests/kvm]$while true ; do ./x86_64/hyperv_clock  ; done
> ==== Test Assertion Failure ====
>   x86_64/hyperv_clock.c:199: delta_ns * 100 < (t2 - t1) * 100
>   pid=66218 tid=66218 errno=0 - Success
>      1	0x000000000040255d: host_check_tsc_msr_rdtsc at hyperv_clock.c:199
>      2	 (inlined by) main at hyperv_clock.c:223
>      3	0x00007f0f2822d55f: ?? ??:0
>      4	0x00007f0f2822d60b: ?? ??:0
>      5	0x0000000000402744: _start at ??:?
>   Elapsed time does not match (MSR=471600, TSC=461024)
...

Here the test is:

r1 = rdtsc()
m1 = KVM_GET_MSRS (HV_X64_MSR_TIME_REF_COUNT)
nop_loop()
r2 = rdtsc()
m2 = KVM_GET_MSRS (HV_X64_MSR_TIME_REF_COUNT)

and then we compare the difference between rdtsc()-s and
HV_X64_MSR_TIME_REF_COUNT changes with 1% tolerance (r2-r1 vs m2-m1).

It would probably increase accuracy if we do

r1_1 = rdtsc()
KVM_GET_MSRS (HV_X64_MSR_TIME_REF_COUNT)
r1_2 = rdtsc()
nop_loop()
r2_1 = rdtsc()
KVM_GET_MSRS (HV_X64_MSR_TIME_REF_COUNT)
r2_2 = rdtsc()

and compare (r2_2 + r2_1)/2 - (r2_1 + r2_2)/2 vs m2-m1.

and also increase tolerance to say 5%.

> ==== Test Assertion Failure ====
>   x86_64/hyperv_clock.c:234: false
>   pid=66652 tid=66652 errno=4 - Interrupted system call
>      1	0x00000000004026e7: main at hyperv_clock.c:234
>      2	0x00007fdab782d55f: ?? ??:0
>      3	0x00007fdab782d60b: ?? ??:0
>      4	0x0000000000402744: _start at ??:?
>   Failed guest assert: delta_ns * 100 < (t2 - t1) * 100 at x86_64/hyperv_clock.c:74

Same story as above but from within the guest (rdmsr() istead of
KVM_GET_MSRS). We can probably employ the same idea to increate the
accuracy.

-- 
Vitaly

