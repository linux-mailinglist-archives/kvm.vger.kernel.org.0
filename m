Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68ABD513AC9
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 19:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346684AbiD1R0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 13:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346038AbiD1R0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 13:26:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C76B285966
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 10:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651166572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CYHJD6E6HfiYbx2PKHbXV03lbbkE9/yKMQwwlCTMLzs=;
        b=ZL9rH+FlngAbtdGZNM8RgmudfavTWy9Xiac8VKcLs2Ay684GldDcuJ9zX22pPyn5R2WHCz
        tUxmQvSO66dZm1LklYblCpEHHxIlIWaTTYjoqYCXGOEh1ChYBHF440mUWshvJeJXbgbEUA
        8bi+trlKlD3wZD4qD+oxo4qi93keFvg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-U4og35J8PbSCUFI8D1VXJA-1; Thu, 28 Apr 2022 13:22:49 -0400
X-MC-Unique: U4og35J8PbSCUFI8D1VXJA-1
Received: by mail-ed1-f69.google.com with SMTP id k13-20020a50ce4d000000b00425e4447e64so3102151edj.22
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 10:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CYHJD6E6HfiYbx2PKHbXV03lbbkE9/yKMQwwlCTMLzs=;
        b=1SAy3tOEo9P+BD4j6kiADB0yhrubVy6tDvcHWw6dYkPqGJmydaH0LICnDcNaWZVyIh
         ZFmOuyacwardjNvlz68+rL6jnBIBN3DIMDyH+6YMFLUPU+wPgcCR1weZKRRWF2ZE9MB/
         Hn0wXMyuVCzAEqoj+uQxysMRIhRVCSNBzl3JIKSMs6p15dbC+xnhcknMtQbXbBQkoXoi
         0pHyZpbeEzDP4XtJiecWjsGUHPPRaaSwjGgNl1tbUmjuSfe6OmL5hDvcfnIkq3WR9p2k
         gJsJHEOXbVOftJK91E+MhT9RHn4L4+VuIXqt+qlGwz/BU66z/EuVshhoEYnrvPpUcf4z
         77Vw==
X-Gm-Message-State: AOAM532gU2rKKoG2YTGTQe8jKZtgr3QbuQETxwcZmzdmwHuxPEtvnrzK
        phMBDYenAUPKLtYUvGtQ04ynYp92NNYFUDIfk2CHH9N/DnXcSpOfe1ahZhWAEBY5TdLHAcrwUBB
        mcBKR0TSZ8/hi
X-Received: by 2002:a05:6402:84a:b0:426:262d:967e with SMTP id b10-20020a056402084a00b00426262d967emr5335102edz.286.1651166568313;
        Thu, 28 Apr 2022 10:22:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBq/kWkr4CtJmNaMdPgNDfkiNjwLZz6U/M46LKSjVacOdKNe9Z0Ou/LgFutM5fhzK8BIB98w==
X-Received: by 2002:a05:6402:84a:b0:426:262d:967e with SMTP id b10-20020a056402084a00b00426262d967emr5335079edz.286.1651166568059;
        Thu, 28 Apr 2022 10:22:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id q8-20020aa7cc08000000b0042617ba637esm1880806edt.8.2022.04.28.10.22.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 10:22:47 -0700 (PDT)
Message-ID: <d1e4eaba-2dcd-ec08-4e23-98ab8ea6c37b@redhat.com>
Date:   Thu, 28 Apr 2022 19:22:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [syzbot] WARNING in kvm_mmu_uninit_tdp_mmu (2)
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     syzbot <syzbot+a8ad3ee1525a0c4b40ec@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
References: <00000000000082452505dd503126@google.com>
 <13b3235ef66f22475fd4059df95ad0144548ccd1.camel@redhat.com>
 <YmqzoFqdmH1WuPv0@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YmqzoFqdmH1WuPv0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/28/22 17:32, Sean Christopherson wrote:
> On Tue, Apr 26, 2022, Maxim Levitsky wrote:
>> I can reproduce this in a VM, by running and CTRL+C'in my ipi_stress test,
> 
> Can you post your ipi_stress test?  I'm curious to see if I can repro, and also
> very curious as to what might be unique about your test.  I haven't been able to
> repro the syzbot test, nor have I been able to repro by killing VMs/tests.

Did you test with CONFIG_PREEMPT=y?

(BTW, the fact that it reproduces under 5.17 is a mixed blessing, 
because it means that we can analyze/stare at a simpler codebase).

Paolo

