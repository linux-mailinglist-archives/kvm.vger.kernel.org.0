Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499B45EC5BE
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 16:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbiI0OSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 10:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiI0OSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 10:18:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD501BCAD4
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 07:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664288293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kJk1wmD2lfaEn2Mk6VfakiGnm87tuqRQXHPFOO58ZMg=;
        b=b84wEY6nO/OjyqH8S08Kwbk4x0Asq4z6Jzuq/L+SXFtqHOtTGOQSksEv4rd6loYq5MkWFc
        gx1UbjfaS8DNOaHrEE6qAp4czMo7+Ibd1GB1ZsHQPkSjMRsQx7gJwea8fciD50I84oSVZP
        4qLtfGZ185Ro5Gg4DD/LRH0+gv5ER14=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-442-FBj-URZDMqix-Ww65MUidg-1; Tue, 27 Sep 2022 10:18:08 -0400
X-MC-Unique: FBj-URZDMqix-Ww65MUidg-1
Received: by mail-ej1-f70.google.com with SMTP id sd4-20020a1709076e0400b00781e6ba94e1so3951178ejc.1
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 07:18:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=kJk1wmD2lfaEn2Mk6VfakiGnm87tuqRQXHPFOO58ZMg=;
        b=3VRkBNoMUlwBmP0h1/oxPAIw3gwWT1tWU1OT9HEhyUxUzbrrjuDimn1wbDIZwAd5JT
         QrZOpm2OC5Tbva8bmsGEua6XUOCOHSBYadtJ5kSnm+pDhyD1C5gBNYcmAdjZyMb88RaO
         dBIS6naLbxos2osAdUkB0bgvK3yo5+4kKUfpCa6V0byXD+R2kS9LjyYP06O1JKFC8nyB
         8j/8/tHLlHscD+6WDeISDXqVL59N3F9YbSbxmK8Y3M7U0PzTK3zPsXMO34XdiKugNGXp
         i/koDyREH3ubSNzookY0pysPPsHIVWtyExbHD0nrFxDTfkxHcsDRSu5OWDLe//fsp7dB
         mprQ==
X-Gm-Message-State: ACrzQf287lXPGsrGe0iUi3bNTMeKyVUx8kcWZw6m6crjWnt3zi1g6UDD
        IdBH3ZN9P7ouzo+f0o32l32RXcd98fzVhQsZvl6HxtbXivdRqVE340U//HMCWEtH4Owib6f/PQF
        0UGDabv1RGnBE
X-Received: by 2002:a05:6402:944:b0:457:6680:a5c0 with SMTP id h4-20020a056402094400b004576680a5c0mr7681372edz.428.1664288283062;
        Tue, 27 Sep 2022 07:18:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7ufqXL0VVbBRPd0J0q1sJ7IzkfuTNNTgQ64LWvaA7gx28QGIiw1DadPciAolZpNmZ8U/+v8w==
X-Received: by 2002:a05:6402:944:b0:457:6680:a5c0 with SMTP id h4-20020a056402094400b004576680a5c0mr7681360edz.428.1664288282884;
        Tue, 27 Sep 2022 07:18:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id a16-20020a50c310000000b00452e7ae2214sm1371480edb.42.2022.09.27.07.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 07:18:02 -0700 (PDT)
Message-ID: <82711e21-15ce-8361-31b8-bfb1b8017698@redhat.com>
Date:   Tue, 27 Sep 2022 16:18:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [RESEND PATCH v2] kvm: mmu: fix typos in struct kvm_arch
Content-Language: en-US
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAPm50aL=0smbohhjAcK=ciUwcQJ=uAQP1xNQi52YsE7U8NFpEw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAPm50aL=0smbohhjAcK=ciUwcQJ=uAQP1xNQi52YsE7U8NFpEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/22 17:05, Hao Peng wrote:
> From: Peng Hao<flyingpeng@tencent.com>
> 
> No 'kvmp_mmu_pages', it should be 'kvm_mmu_page'. And
> struct kvm_mmu_pages and struct kvm_mmu_page are different structures,
> here should be kvm_mmu_page.
> kvm_mmu_pages is defined in arch/x86/kvm/mmu/mmu.c.
> 
> Suggested-by: David Matlack<dmatlack@google.com>
> Signed-off-by: Peng Hao<flyingpeng@tencent.com>
> Reviewed-by: David Matlack<dmatlack@google.com>
> ---
> arch/x86/include/asm/kvm_host.h | 12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)

Queued, but the patch was broken (it had spaces instead of tabs for 
indentation).

Paolo

