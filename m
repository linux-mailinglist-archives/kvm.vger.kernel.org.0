Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914865EFD00
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 20:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbiI2SZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 14:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiI2SZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 14:25:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C60EC566
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 11:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664475918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v5ibpYJAS+Lvg2X1zKklFXddDq44aJbMNXPWgjFNAYk=;
        b=faRvr+GzpHiOHG7sKQf1gqSzlV4n/KwqFmKhM729YNvbjkShR7YXp1FGygo97Z3qwqTWl4
        J8MtHaaHpNjETtNElkk4v55ak2jPo8Bim1trNL0AQagkyedjMYFWRJCnarYKo9Pn/5gYxS
        Dds9pV7t8lboyJ9l6zcgrj+Mp/fqNdU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-Huc9_IUMMXiWArmT8fqCjw-1; Thu, 29 Sep 2022 14:25:17 -0400
X-MC-Unique: Huc9_IUMMXiWArmT8fqCjw-1
Received: by mail-ed1-f71.google.com with SMTP id c6-20020a05640227c600b004521382116dso1857312ede.22
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 11:25:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=v5ibpYJAS+Lvg2X1zKklFXddDq44aJbMNXPWgjFNAYk=;
        b=3eLMWwNYydYrWib7LlJrQXkk6StCf0LIJOprXNTAyQPTdebQFg7Tirfn9/f8oXAqwJ
         Ve31M94GV88GnMUVcghkfALTHH34XULTquaAFlpJsHAz3iPkU99LQd3b8idNUdiPOoWL
         44ucwCgDKd6WO27x9JFRXPW7+NVYN9Rj1a93/CH0u+15PoU7raGLzEr8I3Qtd+S+bd+3
         3yf7xnPO3UPmoA6zb1DMuV3cHCxdjADk1JNxitJ5sK4nq47sKvaP/SXSLW9/OquUfuay
         bJs4yCxpxKEHQSa7p9KITXZFsPzjrmfQx769Uw0zvSaKlLZVIXV5dj8UsSMeFrYv+ZhI
         O1Xw==
X-Gm-Message-State: ACrzQf1YLUAeMtCMyL1L3I8iRULteqGURToxBm6uO+AbrbGOeRHrdyiE
        d/Pa3+xtPtEu3yYG0M35T3++9YYDNUCXZ/B1h9+PMBhkk+do9NQWHzVZJf3/blTArv+hyTQynSg
        nXRqyS0uUlIue
X-Received: by 2002:a05:6402:1394:b0:456:97cd:e9d4 with SMTP id b20-20020a056402139400b0045697cde9d4mr4636304edv.174.1664475916051;
        Thu, 29 Sep 2022 11:25:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4dWlnWCVVkL5jqSUwxXZU+tZyksMHEMPDuLDC1ArTD8Nnvk8mkVFTHP5mAxDcyx/ndWbU4Ow==
X-Received: by 2002:a05:6402:1394:b0:456:97cd:e9d4 with SMTP id b20-20020a056402139400b0045697cde9d4mr4636289edv.174.1664475915848;
        Thu, 29 Sep 2022 11:25:15 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id kv12-20020a17090778cc00b0072af4af2f46sm4323813ejc.74.2022.09.29.11.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 11:25:15 -0700 (PDT)
Message-ID: <830f9f23-3439-5f7a-b6be-8769ed5970c4@redhat.com>
Date:   Thu, 29 Sep 2022 20:25:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v3 0/3] KVM: selftests: Fix nx_huge_pages_test when TDP is
 disabled
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org
References: <20220929181207.2281449-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220929181207.2281449-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/22 20:12, David Matlack wrote:
> Fix nx_huge_pages_test when run on TDP-disabled hosts by mapping the
> test region with huge pages in the VM so that KVM can shadow it with
> huge pages.
> 
> Patches 1 and 2 are precursor patches to add the necessary
> infrastructure to check if TDP is enabled or not.

Queued, thanks.  For now I placed them in kvm/master, but I think they 
will not be in 6.0.

Paolo

> v3:
>   - Skip the selftest if a module param file cannot be opened [Sean]
>   - Add wrappers for reading kvm_intel and kvm_amd params [Sean]
>   - Small renames and error reporting cleanups [Sean]
>   - Decrease sysfs path array from 1024 to 128 bytes [me]
> 
> v2: https://lore.kernel.org/kvm/20220928184853.1681781-1-dmatlack@google.com/
>   - Still use 4K mappins on TDP-enabled hosts [Sean]
>   - Generalize virt_map_2m() to virt_map_level() [me]
>   - Pass nr_bytes instead of nr_pages to virt_map_level() [Sean]
> 
> v1: https://lore.kernel.org/kvm/20220926175219.605113-1-dmatlack@google.com/
> 
> David Matlack (3):
>    KVM: selftests: Tell the compiler that code after TEST_FAIL() is
>      unreachable
>    KVM: selftests: Add helpers to read kvm_{intel,amd} boolean module
>      parameters
>    KVM: selftests: Fix nx_huge_pages_test on TDP-disabled hosts
> 
>   .../selftests/kvm/include/kvm_util_base.h     |  4 ++
>   .../testing/selftests/kvm/include/test_util.h |  6 ++-
>   .../selftests/kvm/include/x86_64/processor.h  |  4 ++
>   tools/testing/selftests/kvm/lib/kvm_util.c    | 39 ++++++++++++++++++
>   .../selftests/kvm/lib/x86_64/processor.c      | 40 +++++++++++++------
>   .../selftests/kvm/x86_64/nx_huge_pages_test.c | 19 ++++++++-
>   6 files changed, 96 insertions(+), 16 deletions(-)
> 
> 
> base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
> prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8

