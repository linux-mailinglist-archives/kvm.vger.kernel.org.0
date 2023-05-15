Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568D3703F4C
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 23:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244739AbjEOVFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 17:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245551AbjEOVFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 17:05:06 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC7B30C3
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 14:05:04 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-50b37f3e664so23423797a12.1
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 14:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1684184703; x=1686776703;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nTC5Jbhy5Lugdl8MQ6NAHTFMl02UAz0PiZG1+JeYllU=;
        b=r7Y+wGlEbH+TI2ac9S60EZVz17Cngknk9F+P3WXlkCXn22omlX+KWBt3fFfT4MGPSp
         akbRQXfuwTJPVkDlixgmdz/fUHzHkUnGHxo0miYRKzmpud864bwRacWBownvbYIP9+th
         vw8KkVwpxYNRQCCQlqpy/GNxRRKriOFGgPX01jsQcATap99vp5hAXf2YBYHh784Nhs56
         xYA4TadeUTXXzqaO7b/Ni8gOLrX0Q1DLqINSedwIBhOUZisjhXcUrsgUMb2dZn9jbFDk
         yl3ny+kaDc+PLvVK4SNUb6x80DGpELOaAf5f8FJbZQx0ceyNCTBNcZTzjXCVv0y4atxI
         3wYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684184703; x=1686776703;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nTC5Jbhy5Lugdl8MQ6NAHTFMl02UAz0PiZG1+JeYllU=;
        b=MhbYMLuovGj4sBTW8RHaoRi25JUitctFdCjjyUlTrhw7jVqF0GAIhIfSpeH2ztA9T4
         g6rsBCGiCPXLAdRbXL09M7fYIkyM4G7PdCXr4F3PG/gbO0KH3+hdhBGQbpgqW6eaVKxz
         wMDF0XWASHR9GwXnekjTRRnGOSYxM9F4Ng7WMmlPlIzLLHTfypWamHQvEp9uPtOwvoZb
         O/XdQAa8ISnO/t1KmiVmIbwYdFgTDz/zys7ihIc2iT7393dx1J8c4+GDeAk4z6l0PxaO
         4ZL4Pb/PsvKjEYrzTOJnaE2KOQ2wKURpbLrSP5qrD+b4zALzM9cfXVWQ//Mj2dry0Rom
         +++g==
X-Gm-Message-State: AC+VfDwGkkBr/LtaaDk/6c6mDsRHsUu/fuYvynbuyZprNv5g+LhZAKVK
        BfKTGVHVoh3QFLPwYfVWxCUMFbiIBhvRSF6QKSs=
X-Google-Smtp-Source: ACHHUZ6Nc+66OOY20dcOI24Ym3TpCQwZDgHylzSiCmG8NVPaPVKJPowOt8qEG2aWJB4u/54qjQqlYw==
X-Received: by 2002:a17:907:9345:b0:94e:c4b:4d95 with SMTP id bv5-20020a170907934500b0094e0c4b4d95mr29919895ejc.69.1684184703361;
        Mon, 15 May 2023 14:05:03 -0700 (PDT)
Received: from ?IPV6:2003:f6:af37:b00:dfd3:5152:f381:a5f3? (p200300f6af370b00dfd35152f381a5f3.dip0.t-ipconnect.de. [2003:f6:af37:b00:dfd3:5152:f381:a5f3])
        by smtp.gmail.com with ESMTPSA id ib23-20020a1709072c7700b00966069b78absm9977564ejc.192.2023.05.15.14.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 14:05:03 -0700 (PDT)
Message-ID: <234e01b6-1b5c-d682-a078-3dd91a62abf4@grsecurity.net>
Date:   Mon, 15 May 2023 23:05:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.15 0/8] KVM CR0.WP series backport
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     stable@vger.kernel.org, kvm@vger.kernel.org
References: <20230508154709.30043-1-minipli@grsecurity.net>
 <ZF1a8xIGLwcdJDVZ@google.com>
Content-Language: en-US, de-DE
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZF1a8xIGLwcdJDVZ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Paolo, can you please take a look at this as well?]

On 11.05.23 23:15, Sean Christopherson wrote:
> On Mon, May 08, 2023, Mathias Krause wrote:
>> This is a backport of the CR0.WP KVM series[1] to Linux v5.15. It
>> differs from the v6.1 backport as in needing additional prerequisite
>> patches from Lai Jiangshan (and fixes for those) to ensure the
>> assumption it's safe to let CR0.WP be a guest owned bit still stand.
> 
> NAK.
> 
> The CR0.WP changes also very subtly rely on commit 2ba676774dfc ("KVM: x86/mmu:
> cleanup computation of MMU roles for two-dimensional paging"), which hardcodes
> WP=1 in the mmu role.

Well, that commit has the MMU role split into two (mmu_role and
cpu_role) which was not the case for 5.15 and below. In fact, that split
was more confusing than helpful, so commit 7a458f0e1ba1 ("KVM: x86/mmu:
remove extended bits from mmu_role, rename field") /degraded/ mmu_role
to root_role and made clear that bit test helpers like is_cr0_wp() look
at cpu_role instead. In that regard, the backport should be equivalent
to what we have in 6.4, as it's using mmu_role for the older kernels
instead of cpu_role (which does not exist there yet).

>                        Without that, KVM will end up in a weird state when
> reinitializing the MMU context without reloading the root, as KVM will effectively
> change the role of an active root.  E.g. child pages in the legacy MMU will have
> a mix of WP=0 and WP=1 in their role.

But does that really matter? Or, asked differently, don't we have that
very same situation for 6.4 with cpu_role.base.cr0_wp being the bit
looked at and not root_role.cr0_wp?

Either way, with EPT this should only matter if emulation is required
and patch 8 makes sure we'll use the proper value of CR0.WP prior to
starting the guest page table walk by refreshing the relevant cr0_wp
bit. Or am I missing something?

> 
> The inconsistency may or may not cause functional problems (I honestly don't know),
> but this missed dependency is exactly the type of problem that I am/was worried
> about with respect to backporting these changes all the way to 5.15.

While doing the backports I carefully looked at the changes and
differences between the trees and, honestly, I don't think I missed this
dependency as I did account for the mmu_role->{cpu,root}_role split (or
rather unification regarding the backport) as explained above.


>                                                                       I'm simply
> not comfortable backporting these changes due to the number of modifications and
> enhancements that we've made to the TDP MMU, and to KVM's MMU handling in general,
> between 5.15 and 6.1.

I understand your concerns, fiddling with the MMU implementation is not
easy at all, as it has so many combinations to keep in mind and quite
some implicit assumptions throughout the code. Moreover, I'm a newcomer
to this part of the kernel. However, I tried very hard to look at the
changes for the individual backports and double- or even triple-checked
the code to make sure the changes are still consistent with the rest of
the code base. But I'm just a human, so I might have missed something,
but a vague bad feeling doesn't convince me that I did something wrong.
Less so, as KUT supports me in not having messed up things too badly.

I know your backlog is huge and your review time is a scarce resource.
But could you or Paolo please take another look?

Thanks,
Mathias
