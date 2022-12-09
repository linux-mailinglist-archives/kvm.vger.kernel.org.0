Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3834647EFE
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 09:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiLIIJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 03:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiLIIJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 03:09:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE203FBAA
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 00:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670573330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yu5+kKIER0XXOyMNzTciuKZhNByC/ICD1fCqGsVZ3Vc=;
        b=OjOMjFpIb2Q/P7B9Rg1oSpJn+Br3ouC51dkKNRLsZ6umcnjhktLudxRtHukz5n8zIE/dth
        jZbYXIoY/GH1Dik92TVUudVJEMb45uOHsMQToMHOn3c+9xGLEsQk6FQIAX0J4GlvPXTXBy
        LARyq01346V1T934siae1SoFEjTob+Y=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-518-Ajm2KjjrMs6uMm3bmE39kA-1; Fri, 09 Dec 2022 03:08:49 -0500
X-MC-Unique: Ajm2KjjrMs6uMm3bmE39kA-1
Received: by mail-ej1-f71.google.com with SMTP id qk16-20020a1709077f9000b007c080a6b4ddso2615111ejc.18
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 00:08:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yu5+kKIER0XXOyMNzTciuKZhNByC/ICD1fCqGsVZ3Vc=;
        b=U2//X2UVWpQCbwLnR+6EAh5hdpBoERnbbdCWpc2IJiXgvXzdJE5asCOM5l3xWY53CQ
         7Y5XCbBBaYiK60bu/YxQSMnq0nbDNRSSRqH0FiXq8Inz3ps8J9P5qgeitlcjenENxSvd
         8b14X8mha1hNnYZvlzgSzCGQmI1sAxaIMS+7v54y4g4Eb3X2OJKxQGh1gIpu1iln6VVq
         /gzcEtngqab3amyLeQj4cUtP/WGdg2LlK5BKriiKipUm+VAAlJJbzWpTEeHvaY8kxtA6
         hBbQvqG5uPghZ8leOItWywiOrtQB9Cv117Up54GoTya90h6bjwbk/6swOug581DtNEw8
         eqmw==
X-Gm-Message-State: ANoB5plz4NHHtTCoRXktuvyPpDXJNESCnb4uVuBfc90iBSdpX3JV8kXF
        lMn53ccmevFt91PkSUTqgNYdI5piiGRlolnRzuhy8A9M10wPicwQ28N3PwWTMayoUmX31REmMMN
        gD0zsV6RB/yL/
X-Received: by 2002:a05:6402:44a:b0:46c:d2f2:123d with SMTP id p10-20020a056402044a00b0046cd2f2123dmr4697614edw.40.1670573328116;
        Fri, 09 Dec 2022 00:08:48 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5r7667C6OXmgEC5Z+6sRu7C2NkDmbkDiR1zIVIJ5e+pJLXpgHVV1OhFN2QxbJEA13QwmklDQ==
X-Received: by 2002:a05:6402:44a:b0:46c:d2f2:123d with SMTP id p10-20020a056402044a00b0046cd2f2123dmr4697599edw.40.1670573327883;
        Fri, 09 Dec 2022 00:08:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id s10-20020a05640217ca00b0045c47b2a800sm327301edy.67.2022.12.09.00.08.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 00:08:47 -0800 (PST)
Message-ID: <40f99ae8-e5c1-efba-ab1d-b8927938d34a@redhat.com>
Date:   Fri, 9 Dec 2022 09:08:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Ben Gardon <bgardon@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Fuad Tabba <tabba@google.com>, Gavin Shan <gshan@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morse <james.morse@arm.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Peter Collingbourne <pcc@google.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Steven Price <steven.price@arm.com>,
        Usama Arif <usama.arif@bytedance.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Will Deacon <will@kernel.org>,
        Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
 <Y4+FmDM7E5WYP3zV@google.com> <Y4+H5Vwy/aLvjqbw@sirena.org.uk>
 <28e7f298-972b-2cb8-df80-951076724c73@redhat.com>
 <877cz3u00b.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <877cz3u00b.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/22 08:49, Marc Zyngier wrote:
> On Tue, 06 Dec 2022 21:43:43 +0000,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 12/6/22 19:20, Mark Brown wrote:
>>>> I almost suggested doing that on multiple occasions this cycle, but ultimately
>>>> decided not to because it would effectively mean splitting series that touch KVM
>>>> and selftests into different trees, which would create a different kind of
>>>> dependency hell.  Or maybe a hybrid approach where series that only (or mostly?)
>>>> touch selftests go into a dedicated tree?
>>>
>>> Some other subsystems do have a separate branch for kselftests.  One
>>> fairly common occurrence is that the selftests branch ends up failing to
>>> build independently because someone adds new ABI together with a
>>> selftest but the patches adding the ABI don't end up on the same branch
>>> as the tests which try to use them.  That is of course resolvable but
>>> it's a common friction point.
>>
>> Yeah, the right solution is simply to merge selftests changes
>> separately from the rest and use topic branches.
> 
> Don't know if this is what you have in mind, but I think that we
> should use topic branches for *everything*. The only things for which
> I don't use a separate branch are the odd drive-by patches, of the
> spelling fix persuasion.

Yeah, I just wish we had better tools to manage them...

Paolo

> That's what we do for arm64 and the IRQ subsystem. It is a bit more
> involved at queuing time, but makes dropping series from -next
> extremely easy, without affecting the history. And crucially, it gives
> everyone a hint to base their stuff on a stable commit, not a random
> "tip of kvm/queue as of three days ago".
> 
> 	M.
> 

