Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5FD1534EC1
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 14:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345724AbiEZMB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 08:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346224AbiEZMBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 08:01:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2645D4104
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 05:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653566508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=055SoySeYXCWiLn0CzY+x8sr/f0kC8O6z5eyzr7h1MY=;
        b=ORzKNLyDn4wNKc6rhYshj1G1VDyuixyqr8+EQNZItDsWx7wmsc96YJAPGlduIX8kOAhPS7
        X6qx40QG9rqmmf3Wfe9xjp4un/jVHghmLOSon/fCViOTIqb3669Ie7g4jkvbniw/tjuQq5
        3HjwzPOOSfWsFSRjYd+TtRN7RenJWDg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-S66bJP7xNwmrcYnPxWsIkg-1; Thu, 26 May 2022 08:01:47 -0400
X-MC-Unique: S66bJP7xNwmrcYnPxWsIkg-1
Received: by mail-ej1-f72.google.com with SMTP id gf24-20020a170906e21800b006fe8e7f8783so759105ejb.2
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 05:01:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=055SoySeYXCWiLn0CzY+x8sr/f0kC8O6z5eyzr7h1MY=;
        b=leflufRsO6cggKf8f9e0WhIscLwvG9zJjCHFlRZJkjtO0ow/EMhLRk/UamV0MGVbnE
         LDxnfMB4tAtPW1zLNdy5iQQJYkefr+JGB7pUxdA5JkGBjS9ndy1ns7w3So2X/sBVNYYv
         bQY/cGD4OeuzeLBhHz25/HqSpnMUIHT4ITu8vuchZTrzzeDnWJBwvtBGYKBOrf5CgCd5
         4iA0O3nsG7OI6ODp9E32JTWGGupTd4Yh1JiZtnKlaiIP6ON7B0gEvEA5rw4O3zGTOIct
         tNI1RfP6ACT2hIHIa6Ao9VCXuVQTxIzOom0B+d/c93ii+V2+Ab2ssPsScj1JB+DemFDG
         R2KA==
X-Gm-Message-State: AOAM531aLHWiIReS/R2DFxUCy5BSAX0Eftp2M1MA3kp0v4OGBmgK4atd
        nYGmLp0DhgfgZVfilAgjx0eOQvvplDWgoAJvzO0F3VMoX/YwSn3UCkndai1+jCDU8tEum/BnwfA
        Eo/CSeYBdc5z1
X-Received: by 2002:a05:6402:4384:b0:42b:5bf6:6d0a with SMTP id o4-20020a056402438400b0042b5bf66d0amr23209289edc.298.1653566505412;
        Thu, 26 May 2022 05:01:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKcWoJHWNsYMQzmjLeHxlnKvIV9QJoGSG5PucM9P0VaBH4aybz1rC298akfqvIO/hsmF/cLQ==
X-Received: by 2002:a05:6402:4384:b0:42b:5bf6:6d0a with SMTP id o4-20020a056402438400b0042b5bf66d0amr23209276edc.298.1653566505226;
        Thu, 26 May 2022 05:01:45 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id o15-20020a1709062e8f00b006fe9a2874cdsm446934eji.103.2022.05.26.05.01.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 05:01:44 -0700 (PDT)
Message-ID: <a3ea7446-901f-1d33-47a9-35755b4d86d5@redhat.com>
Date:   Thu, 26 May 2022 14:01:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: x86/MMU: Zap non-leaf SPTEs when disabling dirty
 logging
Content-Language: en-US
To:     Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
References: <20220525230904.1584480-1-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220525230904.1584480-1-bgardon@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/26/22 01:09, Ben Gardon wrote:
> +		WARN_ON(max_mapping_level < iter.level);
> +
> +		/*
> +		 * If this page is already mapped at the highest
> +		 * viable level, there's nothing more to do.
> +		 */
> +		if (max_mapping_level == iter.level)
> +			continue;
> +
> +		/*
> +		 * The page can be remapped at a higher level, so step
> +		 * up to zap the parent SPTE.
> +		 */
> +		while (max_mapping_level > iter.level)
> +			tdp_iter_step_up(&iter);
> +
>   		/* Note, a successful atomic zap also does a remote TLB flush. */
> -		if (tdp_mmu_zap_spte_atomic(kvm, &iter))
> -			goto retry;
> +		tdp_mmu_zap_spte_atomic(kvm, &iter);
> +

Can you make this a sparate function (for example 
tdp_mmu_zap_collapsible_spte_atomic)?  Otherwise looks great!

Paolo

