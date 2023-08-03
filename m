Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75CD76F174
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 20:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjHCSJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 14:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjHCSJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 14:09:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF8E3A85
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 11:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691085984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S1ZJTd38oGT1lCSM4IaW/s1mn4TZSNjX8w7N3Xg2xtY=;
        b=KbG2v8vs3E8bxTQ7Wmwma9UeLCeXC1xvTgzlMe15llQMKBYU8lQMzaMZjs+esz/ZVxzxjo
        pv52gCd5kjXpkDGAedO3NF+9gAKkY3SKz+8lg0kalfMSeuLdGv77qfqeLo6yzY9n3AQCAR
        90UzMP/YE5GrDKfEuuTTxanYXDTowG0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-5via6L6jOZ2nZsfnhINO4w-1; Thu, 03 Aug 2023 14:06:23 -0400
X-MC-Unique: 5via6L6jOZ2nZsfnhINO4w-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5226eaba9e9so767538a12.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 11:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691085982; x=1691690782;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S1ZJTd38oGT1lCSM4IaW/s1mn4TZSNjX8w7N3Xg2xtY=;
        b=MwiLNM/aB9B8Ziud9ypvu1EwW0yH8j+LKcV+pUB5YrFEakltDHhsznrISo3bE0LDbF
         X8373pLXjS1ycUaz2pANj6RxX1ypiUtV4doMGHzBuXdYjh2RvCxRwgr6yDmGFfWKOCgb
         OrmwYUiq3s655oNagiJoNy25DfzXB8w4qkxUJ+IVqtwEufIloKKIdRsvgiUoVGguzCfw
         OeDVvnBlLeKH0F+vE2tibsMVlmkAdsRaAvgEFM5UFlouLOBac0p2S8oNfAgZgaN7kKV1
         Z0TRB8l2/TyIHam4CdQ6h2NR2Wrj/X2v6AxIti80yqviWIcZnkRInHtWN9+fY+4NNRwn
         iBKg==
X-Gm-Message-State: ABy/qLYBZRNGkxdlkUuA2N/irlyeWRObFC0FyekNLu5ZZ6OhxBFE3YeY
        OC+eAwvRX+pT9FTiH92JkR1aWo3zfQXQ+b0g3OwEjN4Jp6iJx/fdqBXxRA1+7YvaknHiI9uhqHb
        bSYvK1ac2Qpo/
X-Received: by 2002:aa7:c909:0:b0:522:2bc8:cbb8 with SMTP id b9-20020aa7c909000000b005222bc8cbb8mr7896551edt.6.1691085982401;
        Thu, 03 Aug 2023 11:06:22 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFtE+yfltFDHkqS15jMqMR1Edptp9lqv6uXuMSNq97wdoUmq+ekXmmUPeYoAq3AcEaTA4p8dA==
X-Received: by 2002:aa7:c909:0:b0:522:2bc8:cbb8 with SMTP id b9-20020aa7c909000000b005222bc8cbb8mr7896538edt.6.1691085982139;
        Thu, 03 Aug 2023 11:06:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id r9-20020aa7d149000000b005231410bbf2sm108084edo.11.2023.08.03.11.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Aug 2023 11:06:21 -0700 (PDT)
Message-ID: <b22761ea-cab6-0e11-cdc9-ec26c300cd3f@redhat.com>
Date:   Thu, 3 Aug 2023 20:06:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Nikunj A Dadhania <nikunj@amd.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
References: <20230802091107.1160320-1-nikunj@amd.com>
 <20230803120637.GD214207@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Add exception to disable objtool warning for
 kvm-amd.o
In-Reply-To: <20230803120637.GD214207@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/23 14:06, Peter Zijlstra wrote:
> 
> By marking them with STACK_FRAME_NON_STANDARD you will get no ORC data
> at all, and then you also violate the normal framepointer calling
> convention.
> 
> This means that if you need to unwind here you're up a creek without no
> paddles on.

The only weird thing that can happen is ud2 instructions that are 
executed in case the vmload/vmrun/vmsave instructions causes a #GP, from 
the exception handler.

If I understand correctly those ud2 would use ORC information to show 
the backtrace, but even then the frame pointer should be correct.  Of 
these instructions, vmrun is the only one that runs with wrong %rbp; and 
it is unlikely or even impossible that a #GP happens at vmrun, because 
the same operand has been used for a vmload ten instructions before. 
The only time I saw that #GP it was due to a processor errata, but it 
happened consistently on the vmload.

So if frame pointer unwinding can be used in the absence of ORC, Nikunj 
patch should not break anything.

Paolo

