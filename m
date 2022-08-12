Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF6C590CDF
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 09:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237623AbiHLHwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 03:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237615AbiHLHwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 03:52:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6F82A6C36
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 00:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fVtXl6guGCe3kM32qFWNzJUFzVgfQUPoss26g6AXaJw=;
        b=IIJ3IgR5mPlhF/fX7kbF71Y5cH1WR+70QgxO6V8fB0Gs7g+rWchcSsfnEXX5aby7x9W+9S
        rTnRGmXjkWOpX++TcuTVVXw+bIAPuBhI/uDt/mr8czAPmUxdk+Ltmn7GTBqqOn3u0XS3FG
        Ppt40iq32M7XXrw8vj2biYso6GWgLhM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-495-C4FWARJgNGO0HsL2ysxB8A-1; Fri, 12 Aug 2022 03:52:16 -0400
X-MC-Unique: C4FWARJgNGO0HsL2ysxB8A-1
Received: by mail-ed1-f72.google.com with SMTP id x20-20020a05640226d400b0043d50aadf3fso168915edd.23
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 00:52:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=fVtXl6guGCe3kM32qFWNzJUFzVgfQUPoss26g6AXaJw=;
        b=DEhafPQYztrMpEdqpFXf/2t0zVnOMEcjHhuXdFvJR/NsU9Cx3Z7Vz4HmWN08sH4Ty6
         drJ3aXEK+RgZNSh0yK/KpnB5r1OBHMhOfaRu6T/nse16qsP+Euip5JCXHWRQX7UzmSOp
         1Wia+E3rzjhc+aDrZcM3PN5RYnolebzR/Tc9AhCFY1mMONekN/FOUdl+W2oJeuDoDN5U
         0+h3AC2i+mzoYAecQbxXfAmHDBlo8f/QvX5OK7HBe50TRQXWqp8ZnsHGfajF6sFoGfU7
         A7u1v+ZX9SuFoXWNV4unbHw+VbC77Pgg3FRZbnbxHjMaZgF+pLw4MEI6jDmMFWW+QZtS
         ahfw==
X-Gm-Message-State: ACgBeo3oItAY/uggRFCjlvlRGllJd4VQ4TxRN9QIBnVfcdGNucq+RxDK
        w3nHtR5nVqAnNCqDBwLO/oPXKfoZAzPbykyrBdS7s9brroZT8cCl9yEuYgPpszYZtJltMIQa1sC
        Oo3q4sAH64Y/B
X-Received: by 2002:a05:6402:3594:b0:440:5036:ec6b with SMTP id y20-20020a056402359400b004405036ec6bmr2547544edc.117.1660290735402;
        Fri, 12 Aug 2022 00:52:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6jpYqgU5GkQLhb5qOrI6rt7uC1GzLZSrZ2cscxHoxOfV3Gep9jfMJd0MvY1nn+qKIIC3qq8w==
X-Received: by 2002:a05:6402:3594:b0:440:5036:ec6b with SMTP id y20-20020a056402359400b004405036ec6bmr2547497edc.117.1660290735175;
        Fri, 12 Aug 2022 00:52:15 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id 24-20020a170906301800b007313a25e56esm513102ejz.29.2022.08.12.00.52.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:52:14 -0700 (PDT)
Message-ID: <959fedce-aada-50e4-ce8d-a842d18439fa@redhat.com>
Date:   Fri, 12 Aug 2022 09:52:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 1/7] perf/x86/core: Update x86_pmu.pebs_capable for
 ICELAKE_{X,D}
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20220721103549.49543-1-likexu@tencent.com>
 <20220721103549.49543-2-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220721103549.49543-2-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/22 12:35, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Ice Lake microarchitecture with EPT-Friendly PEBS capability also support
> the Extended feature, which means that all counters (both fixed function
> and general purpose counters) can be used for PEBS events.
> 
> Update x86_pmu.pebs_capable like SPR to apply PEBS_ALL semantics.
> 
> Cc: Kan Liang <kan.liang@linux.intel.com>
> Fixes: fb358e0b811e ("perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   arch/x86/events/intel/core.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 4e9b7af9cc45..e46fd496187b 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -6239,6 +6239,7 @@ __init int intel_pmu_init(void)
>   	case INTEL_FAM6_ICELAKE_X:
>   	case INTEL_FAM6_ICELAKE_D:
>   		x86_pmu.pebs_ept = 1;
> +		x86_pmu.pebs_capable = ~0ULL;
>   		pmem = true;
>   		fallthrough;
>   	case INTEL_FAM6_ICELAKE_L:

Peter, can you please ack this (you were not CCed on this KVM series but 
this patch is really perf core)?

Thanks,

Paolo

