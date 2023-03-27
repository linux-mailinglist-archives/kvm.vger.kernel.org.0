Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4946CA6B4
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 16:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjC0OBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 10:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbjC0OAc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 10:00:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8880B5FC8
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 06:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679925563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ib1Sbmeg5wn9T9cMjoPs94Ttz/AXNygGsYMj5t3rfL0=;
        b=CRhej7xCjHzbreEHlh1YDwp5eQLDRmE7fdh74HFbALhk4ZkP/rtJ3efquQLJWLuvkYve9/
        77vca4tckAX+PCw4mWoUTbiWeHiqNLRUcLfwwL/RA2rKLYuVdhvyMDvLwohznX992w8ZFL
        OBAWXfraRRNx0yhNrOHyfyJZIP/heFU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-etKO0HpfNtancde121vZ6g-1; Mon, 27 Mar 2023 09:59:22 -0400
X-MC-Unique: etKO0HpfNtancde121vZ6g-1
Received: by mail-ed1-f70.google.com with SMTP id t26-20020a50d71a000000b005003c5087caso12716197edi.1
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 06:59:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679925561;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ib1Sbmeg5wn9T9cMjoPs94Ttz/AXNygGsYMj5t3rfL0=;
        b=uq8hwwdCo0hG/mkLyh7cX4QFyqHOJcAq4i1U0dW8vsNmB0CjKMtIVUd2c6af8JGIv0
         bdvhtMmti4UQ0+ZUFHQCtejjjTlug/a96QeHEAfQonGME9dMqHKdnPuVrI+j2h2bukGd
         Wzonn44+7duvYftZLRyIUBTHjGth8RNzVdxbmycTZsmCHl663RhxpHhzyF9duFCXK7Cp
         aYhk87hPl+WP1bKtHO8AkKCv3y9b4PhytqaUsrqwhusCY0mYj0xxIDirMFHt+4Y9Yt6/
         3ID8x+nGc6CgR6g6GNbE5ywcvLisGJohjzBPlHH0dt1Y5Bpx+t/vsDvjgHLnBCig0rId
         OwUg==
X-Gm-Message-State: AAQBX9dvrsrSKw72R1y7TtGSsAz23iT3erjgzcW66ZrTRI0O3KLPKDTj
        c2tERCiIfrNLjrJARiTKoWdgW3lXCAyhCbUFN/JunqecQ/UsmNBEom03SfhMyeyb8KiLpMoyBZA
        2sKobqudVtXqD
X-Received: by 2002:a50:fe94:0:b0:4f9:9e56:84bf with SMTP id d20-20020a50fe94000000b004f99e5684bfmr11332084edt.10.1679925561232;
        Mon, 27 Mar 2023 06:59:21 -0700 (PDT)
X-Google-Smtp-Source: AKy350bnOgenmvlJK/KfZzoCNV2Y22c0JxxStJEq6tgQdOSRmSq0EomzPpCWswApUOVHdn7LueBBXg==
X-Received: by 2002:a50:fe94:0:b0:4f9:9e56:84bf with SMTP id d20-20020a50fe94000000b004f99e5684bfmr11332072edt.10.1679925560982;
        Mon, 27 Mar 2023 06:59:20 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id 15-20020a508e4f000000b004fa99a22c3bsm14659319edx.61.2023.03.27.06.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 06:59:20 -0700 (PDT)
Message-ID: <49385a34-6ad7-255d-68d9-6b41a76f01df@redhat.com>
Date:   Mon, 27 Mar 2023 15:59:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.3, part #2
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     reijiw@google.com, dmatlack@google.com, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <ZBPZ4D9MIsaCNDh6@thinky-boi> <ZB3o/jsQIwS+4g4E@linux.dev>
 <86v8imwhi1.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <86v8imwhi1.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/27/23 13:39, Marc Zyngier wrote:
>> Paolo,
>>
>> Pinging this PR in case you missed it, the issues around host page table walks
>> are particularly urgent as the race on host page table teardown has been
>> reproduced on some setups.
> If we don't hear from Paolo shortly, I suggest we route this via the
> arm64 tree.

It missed the pull request I sent on March 17th by a few hours.  I have 
queued it now and will send it to Linus later today.

Paolo

