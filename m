Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209C859749B
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240960AbiHQQxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238259AbiHQQxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:53:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B82549B44
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660755222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=265om41EZDHYe+PcODYhSNTd6h23qIujZjjWucNkp8o=;
        b=WJf4CjFnHnBDE8xq1XNBZ5+3RHAyinaAn4uJyVXS//bF9RAVHF/gmmPoXrjFqLhpEqJbLv
        Oh6GDR8RKNYg71tFF0gUDDlfjkj+8F1L/slJ68WBJJoAs3hKgX5OfoHysBBOYEY5l9VWcs
        RQT6Vs3yamMPzIRNnPn+KBPjGx4hV9M=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-459-_pN_Yb9QPh6QpEtoP0T0eg-1; Wed, 17 Aug 2022 12:53:40 -0400
X-MC-Unique: _pN_Yb9QPh6QpEtoP0T0eg-1
Received: by mail-ed1-f72.google.com with SMTP id g8-20020a056402424800b0043e81c582a4so9163186edb.17
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:53:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=265om41EZDHYe+PcODYhSNTd6h23qIujZjjWucNkp8o=;
        b=DU7mbzMyoV4o08zq2QBEnboNTx/XXXICfCBdCLwHH7sQ6cR2AeJCZDrG1Lqpcjhh5A
         /kilemJUHM8Iv6EgE5oJt+UC4SGEFg3ryB2AkMpCfH0Qx773phPRQOyDNxRuJ/ASL3Db
         G1v7usOD4+ZV9/YJxV005MY1x3hsYB5zsG2XyHJFIwcJp3ScfkVotxa0MpxlOz5fWPrV
         eh4FOYzIiBdX+AiKxfOEQMsuDERB4uD8IZybMmWOEbmTEB4lOnAWKp7EAkj6PRdZhfHp
         7pSayimgAvXFuP4tIPE/gEfNpkEA4xnaS4dqiEWiRcNep9t6R1T7JwlnXpjKOeqrGlUb
         PwuQ==
X-Gm-Message-State: ACgBeo05aj1zoL6PmU9bX/rC2aVuwyEX5Ifkc+8bF44wDIuWhaE9D7GH
        DP6TKgJMSjMfLfMOaLTe1/Of9DZGWkVLy355k/0QA9OYOIvCFSDAwoEmz4y5iCh7gJ4f6XzH1Pl
        A2mtPUqPm0+vP
X-Received: by 2002:a17:907:9802:b0:730:c005:5d52 with SMTP id ji2-20020a170907980200b00730c0055d52mr17301588ejc.120.1660755219834;
        Wed, 17 Aug 2022 09:53:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7PZMtHG+KJBiNgX2xlHiJ90ibWo3LRQneeadAVO6tOxi5WREJI8703hc5lxh3HV7nbu0SOGQ==
X-Received: by 2002:a17:907:9802:b0:730:c005:5d52 with SMTP id ji2-20020a170907980200b00730c0055d52mr17301579ejc.120.1660755219638;
        Wed, 17 Aug 2022 09:53:39 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id e20-20020a50ec94000000b0043c83ac66e3sm10965967edr.92.2022.08.17.09.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 09:53:39 -0700 (PDT)
Message-ID: <5969026f-8202-3407-b7de-224148e6c1d3@redhat.com>
Date:   Wed, 17 Aug 2022 18:53:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is
 enabled
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm list <kvm@vger.kernel.org>
References: <20220815230110.2266741-1-dmatlack@google.com>
 <20220815230110.2266741-2-dmatlack@google.com>
 <4789d370-ac0d-992b-7161-8422c0b7837c@redhat.com>
 <CALzav=cvxR3R6v2CptJJfPaH1go1zxDE15Aedw3ztT-w+wcVKQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALzav=cvxR3R6v2CptJJfPaH1go1zxDE15Aedw3ztT-w+wcVKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/17/22 18:49, David Matlack wrote:
> On Wed, Aug 17, 2022 at 3:05 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 8/16/22 01:01, David Matlack wrote:
>>> Delete the module parameter tdp_mmu and force KVM to always use the TDP
>>> MMU when TDP hardware support is enabled.
>>>
>>> The TDP MMU was introduced in 5.10 and has been enabled by default since
>>> 5.15. At this point there are no known functionality gaps between the
>>> TDP MMU and the shadow MMU, and the TDP MMU uses less memory and scales
>>> better with the number of vCPUs. In other words, there is no good reason
>>> to disable the TDP MMU.
>>>
>>> Dropping the ability to disable the TDP MMU reduces the number of
>>> possible configurations that need to be tested to validate KVM (i.e. no
>>> need to test with tdp_mmu=N), and simplifies the code.
>>
>> The snag is that the shadow MMU is only supported on 64-bit systems;
>> testing tdp_mmu=0 is not a full replacement for booting up a 32-bit
>> distro, but it's easier (I do 32-bit testing only with nested virt).
> 
> Ah, I did forget about 32-bit systems :(. Do Intel or AMD CPUs support
> TDP in 32-bit mode?

Both do.  Intel theoretically on some 32-bit processors that were 
actually sold, too.

>> Personally I'd have no problem restricting KVM to x86-64 but I know
>> people would complain.
> 
> As a middle-ground we could stop supporting TDP on 32-bit
> systems. 32-bit KVM would continue working but just with shadow
> paging.

The main problem is, shadow paging is awfully slow due to Meltdown 
mitigations these days.  I would start with the read-only parameter and 
then see whether there's more low-hanging fruit (e.g. make fast page 
fault TDP MMU-only).

Paolo

>> What about making the tdp_mmu module parameter read-only, so that at
>> least kvm->arch.tdp_mmu_enabled can be replaced by a global variable?
>>
>> Paolo
>>
> 

