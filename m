Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD764342A7
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 02:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhJTAxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 20:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhJTAxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 20:53:33 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8729C06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 17:51:19 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t11so14909569plq.11
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 17:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=subject:from:to:cc:references:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gi5veUgEgx76sEuwowotO1UByX7mmtQoUAe4GhJlQS4=;
        b=SVeEp4YxxXJPgp5nHU1zpKK0yHqrG44igvChVj+ctbLES98Vfweq5uifAU7b3E3f5f
         A0kLuu3M6hKZmYS5b/WXgJqVVb4tFYAQSh4PC7aFDbX0IF2/x+HY7NJ0jsDiKhnF3duY
         G8PrtGBGUlVp0ctz0t+NtPZPxs8chqWA54t82ml68OU20quINNzxvV6YWxH5+b+yfPoy
         uF8Ea2cjQF24LCrlu9J3UZWR7/m1gEHibAXou6pJk0ZquSdsgTMs2cvGrTBT/9nBe8yJ
         SWYDAfY/OkdfFL9RGAxjvG6P9AOGyGY14rp9aPIg4d3/rbwy3iq4syLbHMl1MuXvZJ3P
         LQWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=gi5veUgEgx76sEuwowotO1UByX7mmtQoUAe4GhJlQS4=;
        b=OUumrhC0jsBeU3EtmX3MmP14AnYCUzFzYBwnQPTbj6VpREg1KGsRuV0w4op0T0oSsr
         i/rG/EooVO2EkX4iTu7IVym6fEZ6By++6266kIPesa2ZXMjp7WZrhrUc5PoSn7Dt9OQy
         zX4u0+n0TYH7bEbGPzEsn4CFO3K3rlDgWrqA4g3UkesV8ZqEA/1Hzpe9qQkmvY7C881e
         N5YtXBYvT5u+gzFZHvtNCw7TAglLWFy6DbNflrw2DIT0wr8bT2FrE9NvDnsQ02VIs1V5
         AQ+4mde9ldO9syB/RR+3+JhMrMn/m0DGDqMFxMj48Lc5KMHDogQhAThb+RkyriFFJeaC
         AF9w==
X-Gm-Message-State: AOAM530ZHEcKiLC+10VIDvDNEHy190xS8Hi3nfa3E9MiMUf2OOd+lx5R
        WzhoaO84rg5hXnl0wm+mOrbasoGJtqSQ9A==
X-Google-Smtp-Source: ABdhPJxGVdN5MHqdT5c+4mQEI768SoumxIZ6nYaSL5AiVgOTlY6yWTGdKULYftOP/Vw9wIxiEA9GRg==
X-Received: by 2002:a17:902:934c:b0:13d:c685:229b with SMTP id g12-20020a170902934c00b0013dc685229bmr36150119plp.25.1634691079104;
        Tue, 19 Oct 2021 17:51:19 -0700 (PDT)
Received: from ?IPv6:2601:646:8200:baf:e459:c57e:6787:4f09? ([2601:646:8200:baf:e459:c57e:6787:4f09])
        by smtp.gmail.com with ESMTPSA id p12sm409516pfh.52.2021.10.19.17.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 17:51:18 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: x86: mmu: Make NX huge page recovery period
 configurable
From:   Junaid Shahid <junaids@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
References: <20211019013953.116390-1-junaids@google.com>
 <CANgfPd8a3_snsbF7Y-McZMFx4xz4uwWLjXD3VTaKUBr1xnNTrg@mail.gmail.com>
 <1f62f999-3844-39e9-94b4-e06029fbe308@google.com>
Organization: Google
Message-ID: <9734da1a-8be4-adb2-837f-063b78e8657e@google.com>
Date:   Tue, 19 Oct 2021 17:51:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1f62f999-3844-39e9-94b4-e06029fbe308@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/21 5:07 PM, Junaid Shahid wrote:
> On 10/19/21 4:48 PM, Ben Gardon wrote:
>> On Mon, Oct 18, 2021 at 6:40 PM Junaid Shahid <junaids@google.com> wrote:
>>>
>>> -static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp)
>>> +static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp)
>>>   {
>>> -       unsigned int old_val;
>>> +       bool was_recovery_enabled, is_recovery_enabled;
>>>          int err;
>>>
>>> -       old_val = nx_huge_pages_recovery_ratio;
>>> +       was_recovery_enabled = nx_huge_pages_recovery_ratio;
>>> +
>>>          err = param_set_uint(val, kp);
>>>          if (err)
>>>                  return err;
>>>
>>> +       is_recovery_enabled = nx_huge_pages_recovery_ratio;
>>> +
>>>          if (READ_ONCE(nx_huge_pages) &&
>>> -           !old_val && nx_huge_pages_recovery_ratio) {
>>> +           !was_recovery_enabled && is_recovery_enabled) {
>>>                  struct kvm *kvm;
>>>
>>>                  mutex_lock(&kvm_lock);
>>
>> I might be missing something, but it seems like setting
>> nx_huge_pages_recovery_period_ms through this function won't do
>> anything special. Is there any reason to use this function for it
>> versus param_set_uint?
>>
> 
> Yes, you are right. The original patch was using a 0 period to mean that recovery is disabled, but v2 no longer does that, so we indeed don't need to handle the period parameter through this function.
> 

Actually, I think that it may be a good idea to still use a slightly modified form of that function. If the period was originally set to a large value and is now set to a small value, then ideally we should wake up the thread rather than having it wait for the original period to expire.

