Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FB06C39E1
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 20:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCUTIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 15:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjCUTIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 15:08:51 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BE1144B5
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:08:50 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536d63d17dbso165457627b3.22
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679425730;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9+j1oPHXbTvqe5hZN9vvAitTb3qxIgVPM25OG0J2eXo=;
        b=pbreqdpMQe44PD7uS/RocYqLJgn0s52DIUZKnTVRi6FxAWu6R17Z7G1UZF+tfazurv
         JoSibka0r+7kFkmFqSZy2DD4h/ckw5kADOXtFq6KgVmNMfsn50nUYjYdD3qHwsopZFA0
         1Q/OZNaBUWqcTVsanGhaVDy6c2Kn4O/5XlZzzd9MFpMXiUIWgglQNJUST9Xe2pTK/9G7
         dST+l80l1eoQQbcMwsCO63SO40aXFiN9LkXjgWn4ot1NEYdZqf+0P/zwhN4uQeuYGDn4
         HAzGpJbiUXNFdPAGBlzseK2bWZo1M1t34vSTW+crUo95jXURDL+UYVyQJp6AFa62KRNp
         6mSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679425730;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9+j1oPHXbTvqe5hZN9vvAitTb3qxIgVPM25OG0J2eXo=;
        b=skVnZVtiFpzB082XGFTWPJlYJiV/iotealeseQzy+jUnMQak3VLL7Y/admwBJ4fQld
         sJmw9BSIMOTtFwuZb4l6P5AmvkvUsjwj+4zqToRH+XLP56V7pbw+KYxJa2kbmShZKfgM
         4M0ShH9n9DPxvfrauGIvhB1SmJKJ4sX4nyt34VJIyJqJx3Ojgxz6qNo72vTOrk4Xa/M1
         B43+Qa9tBeRkceHMtA//UVY5KUAylFf89HR2SLrD+YPrCFbAzlyEjiRPymMf0RI16YK0
         G3Z6bZROXIq/B4EwmWfus8WItKlf2oiCHuQYp7DIA+UXnv9XcsvN7fN9Ror/eqWoJcUq
         tJWA==
X-Gm-Message-State: AAQBX9d7T1Co+fGrCcdrz7iDA2DCcJN5rHW1wOu0oQktH8qg+hKUzgPg
        BLJw5WyB/Hb5jbbGn/tervOzxta+m8LyF7ETZw==
X-Google-Smtp-Source: AKy350YYtdMapzj90m6MGVzWIrDWevPuFCjGLtj6EMZutax8gOUw17bDrxOlZI7iccy53NmyTopFGbPJXLgjIQWXWQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:6:b0:b5c:f48:3083 with SMTP
 id l6-20020a056902000600b00b5c0f483083mr2157121ybh.11.1679425729799; Tue, 21
 Mar 2023 12:08:49 -0700 (PDT)
Date:   Tue, 21 Mar 2023 19:08:48 +0000
In-Reply-To: <20230317092657.ldtxs3povjhbciq7@orel> (message from Andrew Jones
 on Fri, 17 Mar 2023 10:26:57 +0100)
Mime-Version: 1.0
Message-ID: <gsntiletdirj.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 1/2] KVM: selftests: Provide generic way to read system counter
From:   Colton Lewis <coltonlewis@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     pbonzini@redhat.com, shuah@kernel.org, seanjc@google.com,
        dmatlack@google.com, vipinsh@google.com, maz@kernel.org,
        bgardon@google.com, ricarkol@google.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andrew Jones <andrew.jones@linux.dev> writes:

>> +#if defined(__aarch64__)
>> +
>> +#include "arch_timer.h"
>> +
>> +uint64_t cycles_read(void)
>> +{
>> +	return timer_get_cntct(VIRTUAL);
>> +}
>> +
>> +double cycles_to_ns(struct kvm_vcpu *vcpu, double cycles)
>> +{
>> +	return cycles * (1e9 / timer_get_cntfrq());
>> +}
>> +
>> +#elif defined(__x86_64__)
>> +
>> +#include "processor.h"
>> +
>> +uint64_t cycles_read(void)
>> +{
>> +	return rdtsc();
>> +}
>> +
>> +double cycles_to_ns(struct kvm_vcpu *vcpu, double cycles)
>> +{
>> +	uint64_t tsc_khz = __vcpu_ioctl(vcpu, KVM_GET_TSC_KHZ, NULL);
>> +
>> +	return cycles * (1e9 / (tsc_khz * 1000));
>> +}
>> +#endif

> Instead of the #ifdef's why not must put these functions in
> lib/ARCH/processor.c?

Seems like a good suggestion.
