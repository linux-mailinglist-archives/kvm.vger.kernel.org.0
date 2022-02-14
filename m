Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BCD4B5862
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 18:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357004AbiBNRW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 12:22:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237047AbiBNRW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 12:22:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD95165173
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 09:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644859368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=heen2BB+onxLcxe/2Jf8awF4VD6iWVMhKf1QFzuQRwA=;
        b=AyxRE9CG/k1ltEf/MGTXBgUxgSZI24ttTMTUBaFNz4OhXlNaUbuMHAGPNGu0UwYfzJ+OAd
        u1GSwf7iwq9F5II3MwI408DoEU0pW7mN0sU0JYG6NFmnzT3cxpYW6+ilRw4X8Z2GvjvLeU
        tnDo45vYNY7X1Oi15fqojFsIMOz4TrU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-pIOARCFTNeK-rC0nMoBFQQ-1; Mon, 14 Feb 2022 12:22:47 -0500
X-MC-Unique: pIOARCFTNeK-rC0nMoBFQQ-1
Received: by mail-ej1-f71.google.com with SMTP id o4-20020a170906768400b006a981625756so6187147ejm.0
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 09:22:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=heen2BB+onxLcxe/2Jf8awF4VD6iWVMhKf1QFzuQRwA=;
        b=c+5JX2azDe/veqLcLM9odwJn5PO0MCpQVRopR4i0YtrDgF0kFpMxH5MGZmTNld07wD
         UVJbf0JBaOwztUOfsHeXsLjNgv+/ojDRc+Xb4fOP+Qg6mpuVRe6gniWlrlfayou1h0/7
         lHThL+f2f9FqNWqbEdhCZCDf4geqU4E0DnvH4PPGpZMz/kJoCap+GVgRhm+l8n2o8Yym
         Q6NPD07MUeNZw5FYPaN4+5mx7wuw4NEv/Wg0gu/qkpK/jdu2B/IM+0AVnHAgW5qL1vK9
         53piLPef8yygAFnCFd4SEXt0TrcOpP1DQfl23kaYXu6NOvQFOwXP2OWYHhLzHPn5di4M
         ZPZQ==
X-Gm-Message-State: AOAM532zb8TFD7nMjXl+bmk3v53Y602jxJe8LsywJF11K9zaYU584ffY
        gsXlT6VX1nI+rldxwngQr36Q68Xir/4uk+0BEvlsmQQ/iJIqRmp2hwuUPBghVAQmj2HDFXk2Yii
        CKUSVzWt6tOif
X-Received: by 2002:a17:906:2ed1:: with SMTP id s17mr543358eji.174.1644859366224;
        Mon, 14 Feb 2022 09:22:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxx74GvXC0GfGqL2mBl7P8WYj1j9LH2x5O80iJkp6aztCILB1JQgG3KIu9CpvJEA22swB0kyg==
X-Received: by 2002:a17:906:2ed1:: with SMTP id s17mr543350eji.174.1644859366041;
        Mon, 14 Feb 2022 09:22:46 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id q19sm9367532ejm.74.2022.02.14.09.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 09:22:45 -0800 (PST)
Message-ID: <3caa56dc-ec80-a172-a632-42689aaf6f0b@redhat.com>
Date:   Mon, 14 Feb 2022 18:22:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] KVM: SEV: Allow SEV intra-host migration of VM with
 mirrors
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220211193634.3183388-1-pgonda@google.com>
 <a3008754-86a8-88d6-df7f-a2770b0a2c93@redhat.com>
 <CAMkAt6rLafSikpQEKkbbT8DW4OG_pDL63jPLtCFiO1NNtTRe+A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAMkAt6rLafSikpQEKkbbT8DW4OG_pDL63jPLtCFiO1NNtTRe+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 16:52, Peter Gonda wrote:
> On Mon, Feb 14, 2022 at 5:57 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 2/11/22 20:36, Peter Gonda wrote:
>>> +     list_cut_before(&dst->mirror_vms, &src->mirror_vms, &src->mirror_vms);
>>> +     list_for_each_entry_safe(mirror, tmp, &dst->mirror_vms,
>>> +                              mirror_entry) {
>>
>> Is list_for_each_entry_safe actually necessary here?  (It would be if
>> you used list_add/list_del instead of list_cut_before).
> 
>   I don't think so, I think we could use list_for_each_entry here. Do
> you want me to send another revision?

No, I can do that myself, thanks!

Paolo

