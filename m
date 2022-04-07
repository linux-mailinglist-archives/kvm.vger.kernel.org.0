Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D744F8103
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 15:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241635AbiDGNyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 09:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234709AbiDGNyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 09:54:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DFE2DB2F9
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 06:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649339555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jL9bXerqanJqYa09D53b5usSPv9ZPbbi9nBHaabOGf0=;
        b=cYsIMtNeilfCDKYaEJPkHxhPdctLEgujiuVervwBNoZ003VKxud7jCVVL9uKmLEvumvFPm
        7uoOmkL6FUrngZiPvh3NPvTZg+gCI0XGGnikusS0K2XcsG5zRcJdYJlC7LJmaRzZ5L5VSF
        Ltd8ETxFlrWtY8BrwOaNKXCMAEnqP18=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-AX2QYtizPxS7Nou_6Cx7aQ-1; Thu, 07 Apr 2022 09:52:32 -0400
X-MC-Unique: AX2QYtizPxS7Nou_6Cx7aQ-1
Received: by mail-ej1-f69.google.com with SMTP id ga31-20020a1709070c1f00b006cec400422fso3094489ejc.22
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 06:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jL9bXerqanJqYa09D53b5usSPv9ZPbbi9nBHaabOGf0=;
        b=UWKQIydhW0WRI5Pw+Vu3w/gX4OyXMZZFn10sRKOHI002Uhj9OFTvN/hgIKjqjYkF1d
         8OH6U/rHstdpZjWuXDoytMBUmGAy1S2SMjnzz3nuPMgIDWRWnL2U6WJKs4GsJViyBil/
         xA37vH5rn4Z6/XeAJUF/MXvYEZmUQD8zQ3fz5ppK1+LM44pfsKal/K+M7lmkk7KH0M0l
         h73rv+oex0QhuOoQRMyIj/84ocOytOkv7XSyzlNfqPZVtVyY2i/qxpM99qHihxOHgA3n
         Oxj0SiZ86pCLP2aQAXBPLxDachEM+fYG/3p3sIq243c3jp6TkKLZrjd8DrgqycJ6Bznn
         xHGQ==
X-Gm-Message-State: AOAM533MvT6/9PBhzUdZ3R6LlR4RH9QAMOgV87Y2VVX+13q9ADsIPaG8
        S2UihdRai+CKL9CZikdb7T1NGtti+UAPQZGsfAIkTKlCWNKKEo645mscUTiRqwFN12Z6nwJCBIb
        4a9egESbK5q8W
X-Received: by 2002:a17:906:9c8e:b0:6df:f6bf:7902 with SMTP id fj14-20020a1709069c8e00b006dff6bf7902mr13355727ejc.191.1649339551254;
        Thu, 07 Apr 2022 06:52:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNoQ4CSwzbLRsARzz7uQFWOARItD+XZF5VJ8pDvdIiL2uFf06aBp56DUc8uT+bnytuRG5OkQ==
X-Received: by 2002:a17:906:9c8e:b0:6df:f6bf:7902 with SMTP id fj14-20020a1709069c8e00b006dff6bf7902mr13355709ejc.191.1649339550964;
        Thu, 07 Apr 2022 06:52:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ky5-20020a170907778500b006d1b2dd8d4csm7697618ejc.99.2022.04.07.06.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 06:52:30 -0700 (PDT)
Message-ID: <ec5ffd8b-acc6-a529-6241-ad96a6cf2f88@redhat.com>
Date:   Thu, 7 Apr 2022 15:52:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 047/104] KVM: x86/mmu: add a private pointer to
 struct kvm_mmu_page
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <499d1fd01b0d1d9a8b46a55bb863afd0c76f1111.1646422845.git.isaku.yamahata@intel.com>
 <a439dc1542539340e845d177be911c065a4e8d97.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <a439dc1542539340e845d177be911c065a4e8d97.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/22 01:43, Kai Huang wrote:
>> +	if (kvm_gfn_stolen_mask(vcpu->kvm)) {
> Please get rid of kvm_gfn_stolen_mask().
> 

Kai, please follow the other reviews that I have posted in the last few 
days.

Paolo

