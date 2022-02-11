Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E2E4B22CF
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 11:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348801AbiBKKJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 05:09:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbiBKKJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 05:09:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 304B3E7E
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 02:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644574147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tuiIVhVMPKV1txAZFtZEl8nRNpH9lSxIAqZntDpj/IQ=;
        b=CaHCgfnAb2MAHwsPsFcP5pe3DSmfJKkS4ITNinOodZDx2Qvkelk2966ASY0+TqkHC8srcF
        O4eh7Y7N9BMIcFjH3y8HVUDnM0aJNgCndzXq2+MHYN7PIXxO7rbGHEvAbicmO/Owj1kGRs
        ciVdWhedBwoi+ubWHTMymp2DrX75ksQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-vaX2yV5VOUCF7zrxRCTBlg-1; Fri, 11 Feb 2022 05:09:05 -0500
X-MC-Unique: vaX2yV5VOUCF7zrxRCTBlg-1
Received: by mail-ej1-f70.google.com with SMTP id vj1-20020a170907130100b006ccc4f41d03so3870764ejb.3
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 02:09:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tuiIVhVMPKV1txAZFtZEl8nRNpH9lSxIAqZntDpj/IQ=;
        b=si8pPO1UNkY4qM/fbr4pv4fyo9tXAQ1Dh9JU+wjsLbpzt2UhxDWET67ZV14eOcIrMB
         CMrwtdU//yDeCYJV/G898AbwJ+9bt5TU1b72EAFVlsMUhGU1aQguQGnE516QSThbsyvF
         UhyP5dmoDsUgHKuhTfz6drFsa+KD/rLDPUKQQYhAqt91y4MFMPHqiD0vd0patu7jaTr9
         /IApL6AO1HF3n1kxIVVjimsnkbqC/8NDUmA3g+b9IGeU6DKEJYvz+m9qmNRaRXkrsjbE
         rj9mGVOGDnBhPSxD2ypq33SqeMd6LYsRJOvHlm+REMzYiuIKRrGTCYCr2zqHNkh991Mj
         SJ2Q==
X-Gm-Message-State: AOAM532dZjJdx+WE12b//NIN1txyBBOxwqFmCTdVhb/D/FjiK3sibRv3
        0C6wuXiyH8VQXegulqpUXi3AabwddYyGWbyO4RFaKyk2rSdfntJC4knLCviwmKeDqkiV/0Vt5je
        iTZYf7nSHGkX1
X-Received: by 2002:a17:906:63ca:: with SMTP id u10mr721476ejk.27.1644574144814;
        Fri, 11 Feb 2022 02:09:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxJiCVPR/PhVFhZlERTWpkY0KgTzv1yI2acAM7/6eoKbrC4C+TCHrgFSv7rZsfxmkQtCqs6nA==
X-Received: by 2002:a17:906:63ca:: with SMTP id u10mr721456ejk.27.1644574144641;
        Fri, 11 Feb 2022 02:09:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id z8sm4776958ejf.108.2022.02.11.02.09.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 02:09:03 -0800 (PST)
Message-ID: <8160cf73-537a-9cd7-bb61-cca29fb0ebcb@redhat.com>
Date:   Fri, 11 Feb 2022 11:09:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 09/12] KVM: MMU: look for a cached PGD when going from
 32-bit to 64-bit
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-10-pbonzini@redhat.com> <YgW8ySdRSWjPvOQx@google.com>
 <YgW99wRxczsAJ0jv@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgW99wRxczsAJ0jv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 02:37, Sean Christopherson wrote:
>
>> 	if (VALID_PAGE(mmu->root.hpa) && mmu->root.hpa == __pa(mmu->pae_root))
> Gah, that's wrong too, it will allow the pml4_root case.*sigh*   I'm fine punting
> this until the special roots are less special, pml5_root is completely broken
> anyways.

Ok, I'll look at your comments on Jiangshan's series.

Paolo

