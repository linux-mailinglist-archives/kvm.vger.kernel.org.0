Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF004CAD5D
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbiCBSVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbiCBSVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:21:00 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DA223BCE;
        Wed,  2 Mar 2022 10:20:16 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id i66so1684131wma.5;
        Wed, 02 Mar 2022 10:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jCur8YrGp6z/NuQt4H+X/uS6Re1ZqnHb48KX+hfu53o=;
        b=C4GUs40MfOQrW5sBrilqDYxQOs2FYm8f9QxL3hMm+zTP7aTJkzPLfOPhs1lzQD3CVV
         m377cAUO0oZ53mdaNqMWRt8gPsuU0ovUZNlwnvn08ITFVdVy73fb7u4ZK3l7YEeD3ibj
         Nr0sbRwJxI0AewRuDPljZiBP8Rs0uhhv5z2CHj3WgN20jslaIky90KJcGHpqmC59fdS2
         Qa8nmDnuvVenMEGxLwDdlcdtqQpK9jfBGpuqs9iNzQwxXGLrJTfnLFdc9UOpYspXUFb1
         YXTgzNtPfCqnJ+gr1HToZfiOJWVjSxoyE1x2VWPtIUfNECWYDubH4bGdqlIkT+Aovoja
         wBHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jCur8YrGp6z/NuQt4H+X/uS6Re1ZqnHb48KX+hfu53o=;
        b=kiKMeovu8BWc1cFXOco+x2pGcgXzjrh3CGexFM9Oh2FW77WS2g7DePtT/+wo4++TLD
         fKpK+2jKKLAZ1N5fL29wNX4jppccCFfZ4m3qcVaOh1DEfapPOoUd6ppPUWI7Sq4cGnYM
         Igt9L0zo0hcTm53hmi0d0ndjvCmZ5TcQlA1+WOzcsSumu38a2+HAhAPd2M3ndGneWihg
         ihleKMItHuvCJx8rYS0FHYoUwMmqHA/sdeDKsqrLA97Rr0NmHdWFNN9XqSyfZy9tfLjG
         MQ9mBOdNQ9Z5K7zSzcAWbJ7INOSFTT9lsN5dUgCfyJNFHCp/FFfEVJR3fYZY+wd/bleI
         5FKw==
X-Gm-Message-State: AOAM533+R5aIanKciLGby/g2CeIC//xrCr9mTqJ6LBHhz3LxT6694Xdh
        HqHvAL9R4Zy9xM7fa6dA5fqzE68SA7U=
X-Google-Smtp-Source: ABdhPJxtYGh4kFJILKrTt8o6mKhCSuHsw4oW6NwL5OtdhqpgfcLuYtQySmgMW7m0aLTyZuA1mYoFpQ==
X-Received: by 2002:a7b:c94e:0:b0:386:3694:3e78 with SMTP id i14-20020a7bc94e000000b0038636943e78mr935222wml.22.1646245215294;
        Wed, 02 Mar 2022 10:20:15 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id n21-20020a05600c3b9500b003830cbe90c3sm3808590wms.11.2022.03.02.10.20.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 10:20:14 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f4189f26-eff9-9fd0-40a1-69ac7759dedf@redhat.com>
Date:   Wed, 2 Mar 2022 19:20:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 22/28] KVM: x86/mmu: Zap defunct roots via asynchronous
 worker
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-23-seanjc@google.com>
 <b9270432-4ee8-be8e-8aa1-4b09992f82b8@redhat.com>
 <Yh+xA31FrfGoxXLB@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yh+xA31FrfGoxXLB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/22 19:01, Sean Christopherson wrote:
>> +	 */
>> +	if (!refcount_read(&kvm->users_count)) {
>> +		kvm_mmu_zap_all(kvm);
>> +		return;
>> +	}
> 
> I'd prefer we make this an assertion and shove this logic to set_nx_huge_pages(),
> because in that case there's no need to zap anything, the guest can never run
> again.  E.g. (I'm trying to remember why I didn't do this before...)

I did it this way because it seemed like a reasonable fallback for any 
present or future caller.

> One thing that keeps tripping me up is the "readers" verbiage.  I get confused
> because taking mmu_lock for read vs. write doesn't really have anything to do with
> reading or writing state, e.g. "readers" still write SPTEs, and so I keep thinking
> "readers" means anything iterating over the set of roots.  Not sure if there's a
> shorthand that won't be confusing.

Not that I know of.  You really need to know that the rwlock is been 
used for its shared/exclusive locking behavior.  But even on ther OSes 
use shared/exclusive instead of read/write, there are no analogous nouns 
and people end up using readers/writers anyway.

>> It passes a smoke test, and also resolves the debate on the fate of patch 1.
> +1000, I love this approach.  Do you want me to work on a v3, or shall I let you
> have the honors?

I'm already running the usual battery of tests, so I should be able to 
post it either tomorrow (early in my evening) or Friday morning.

Paolo
