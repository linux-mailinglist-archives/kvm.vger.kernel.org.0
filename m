Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8834DE831
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 14:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243069AbiCSNmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 09:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243064AbiCSNmu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 09:42:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72E8C2B518A
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 06:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647697288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mQi7xFMYfOWyLlpSHeawp9xwfNF6ITZZucszyLn7QPI=;
        b=cTCawbjP75swEmYKjBaeSfCEUVXuqdXffoGKhz3VlNXpnDRCm1EJd2m6u8UhBuhepr0KXu
        IACYoCxVv2yn/jCqneqHi3ZO8EHsGiX7czZuNi7wlHfjUHIhoUYRrR/gXKa9s5BN9woH2G
        +dF1vzGXC9vkjGtxp3gJEsyGyp761ns=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-tSNVN1L7MnWTUtV6vhva_w-1; Sat, 19 Mar 2022 09:41:27 -0400
X-MC-Unique: tSNVN1L7MnWTUtV6vhva_w-1
Received: by mail-ed1-f71.google.com with SMTP id o20-20020aa7dd54000000b00413bc19ad08so6539425edw.7
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 06:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mQi7xFMYfOWyLlpSHeawp9xwfNF6ITZZucszyLn7QPI=;
        b=Exb/63J8cWZeWNnqv4uMKZe5fCjJ00pReccvlF851+5atiwQ+zg5deLO37WFDguqxL
         2KFju+HsN9auF/ZpTnVgACBiehys+tBGY2E82yEn/Qndqt6SwDL2xVKK39S5igmp6tNR
         BKxroxWoSQwykmZJn+XcNNo4MGmpOR03BSyfXRBfcXSPXllFzyilAaqVEh0CwhSHzjnt
         SoSz9OpQloYB2hW6KXxaoZGV0SP9kufPSKRGep9hfzBNHrbFcrCpcQKg27WZzKjMxPqO
         nxMQ3/O/+LMcdCo9WXimzIbpIr8u8ofignlrqMT5fNaDOzKmQFVsYHThBj67W91iQMnw
         BnzQ==
X-Gm-Message-State: AOAM532pqy5pgVkEWq5Hm0tZx9qmEmX9tYLaHWmzCUlJXNKmMz8WNrU1
        eGPDsYcfK7zPyKiNtRM/tKmjt5d7caWjAi2Yh34KLPZKqw68m+JJnD0uryX7GhiAybTYzFyvG2l
        CpH070MuQxr5c
X-Received: by 2002:a17:907:2ce6:b0:6df:a489:d2e1 with SMTP id hz6-20020a1709072ce600b006dfa489d2e1mr10277494ejc.264.1647697286001;
        Sat, 19 Mar 2022 06:41:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvHViZozaI0XwntIgTr6VVZG4XFmzvdsrrVXo32I0dV2xBftQMYHF4gHYcwELVjle0XuaP9A==
X-Received: by 2002:a17:907:2ce6:b0:6df:a489:d2e1 with SMTP id hz6-20020a1709072ce600b006dfa489d2e1mr10277479ejc.264.1647697285750;
        Sat, 19 Mar 2022 06:41:25 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id v2-20020a509d02000000b00412d53177a6sm5657734ede.20.2022.03.19.06.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Mar 2022 06:41:25 -0700 (PDT)
Message-ID: <ad13632c-127d-ff5a-6530-5282e58521b1@redhat.com>
Date:   Sat, 19 Mar 2022 14:41:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH -v1.2] kvm/emulate: Fix SETcc emulation function offsets
 with SLS
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jamie Heilman <jamie@audible.transient.net>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <YjHYh3XRbHwrlLbR@zn.tnic>
 <YjIwRR5UsTd3W4Bj@audible.transient.net> <YjI69aUseN/IuzTj@zn.tnic>
 <YjJFb02Fc0jeoIW4@audible.transient.net> <YjJVWYzHQDbI6nZM@zn.tnic>
 <20220316220201.GM8939@worktop.programming.kicks-ass.net>
 <YjMBdMlhVMGLG5ws@zn.tnic> <YjMS8eTOhXBOPFOe@zn.tnic>
 <YjMVpfe/9ldmWX8W@hirez.programming.kicks-ass.net>
 <94df38ce-6bd7-a993-7d9f-0a1418a1c8df@redhat.com> <YjXcRsR2T8WGnVjl@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YjXcRsR2T8WGnVjl@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/19/22 14:36, Borislav Petkov wrote:
> On Sat, Mar 19, 2022 at 02:24:06PM +0100, Paolo Bonzini wrote:
>> Sorry for responding late, I was sick the past few days.  Go ahead and apply
>> it to tip/x86/core with the rest of the SLS and IBT patches.  If you place
>> it in front of the actual insertion of the INT3 it will even be bisectable,
>> but I'm not sure if your commit hashes are already frozen.
> 
> I think they are and we need this fix in 5.17 where the SLS stuff went
> in. I'll send it to Linus tomorrow.

Nah, don't worry.  I'll take care of it, I'm still not 100% on top of 
things but I can handle one patch. :)

Paolo

>> Just one thing:
> 
> Yeah, peterz can then do this ontop, before sending the IBT pile.
> 
> Thx for letting us know!
> 

