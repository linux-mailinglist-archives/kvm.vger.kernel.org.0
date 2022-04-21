Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE37F50A4D2
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 17:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390399AbiDUQAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390438AbiDUP7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 11:59:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 395B147045
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 08:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650556617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kTeK/qAo71TOtFSLAt36q1Ck1F47EJBRXs8RHdefg1E=;
        b=QddvzlnKhsW2BZeob9ga3fG8IPvj/7eZxhPwSAvGKbExEQqia4miPIfZ9RxwgMSn0pmZeU
        AXiVGFshYtAabTNr3SVMoDCGO2fqvOBH7f575aX/Zhc8bveoK3DYV/Ifz9jctaVPsasfsZ
        cox/LdxCJo0OfC6ASNLQiDj/zLAl0u8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-_gdXU4J0NxGT8eRprjwqFg-1; Thu, 21 Apr 2022 11:56:55 -0400
X-MC-Unique: _gdXU4J0NxGT8eRprjwqFg-1
Received: by mail-wr1-f71.google.com with SMTP id f2-20020a056000036200b00207a14a1f96so1284799wrf.3
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 08:56:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=kTeK/qAo71TOtFSLAt36q1Ck1F47EJBRXs8RHdefg1E=;
        b=XRcRqdWdt/BEAolQoWJPXwzdgoeZBgSz5HfX33gm/d8c0uA22pCOlyv4rMSfIweS01
         2zP/7p3eEeeiZCldi6SGJvwXI8Y3m9XDQr+9O6Fkxa0Vca/uoEXiwrdfnhKHMAwFqBQ3
         pdKrPkwrv38lyCOkizN9DROds4fqfVn3rU3QEXFIZTcYxSS7I0Vx0h8cFjl/375oUmpN
         Eny7JOCOZ8DRwFohXHqfgJDHTf/qvjk8eRKpi0qRmqoOziR/WwiHJ5QeAW90bb49wVeD
         Qx+yxRTvJj8/uhEpZkhf8l9IqqY5bV+HeDcIxoiBWhlRYfsdr5oI/6+OIJ0G4FEPtlIS
         xFZw==
X-Gm-Message-State: AOAM530qxdBG+J35+PzK3TukwxxpGDP7xnF1Gph+1ObY+oRUcLCsPydZ
        F47+9f3hrp9BKnYfTew29Iq6AKhgeqjVKHQDy0KeVSwZd4wAp7i4i0kjcERdvYwsaiUUzZ8+7qu
        lrjsu3Vdtx4ob
X-Received: by 2002:a05:600c:1553:b0:392:8de8:9dfa with SMTP id f19-20020a05600c155300b003928de89dfamr9333055wmg.71.1650556614807;
        Thu, 21 Apr 2022 08:56:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0vnAguST9pNCVtCDxTQ4/Al3Ko2yn2bs4Mmrfapj6XXW5P+04XyixAwoJmjwNo7AIJIlKpg==
X-Received: by 2002:a05:600c:1553:b0:392:8de8:9dfa with SMTP id f19-20020a05600c155300b003928de89dfamr9333046wmg.71.1650556614571;
        Thu, 21 Apr 2022 08:56:54 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id l10-20020a05600002aa00b0020a7cc29000sm2769430wry.75.2022.04.21.08.56.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 08:56:53 -0700 (PDT)
Message-ID: <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com>
Date:   Thu, 21 Apr 2022 17:56:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>,
        John Sperbeck <jsperbeck@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220407195908.633003-1-pgonda@google.com>
 <CAFNjLiXC0AdOw5f8Ovu47D==ex7F0=WN_Ocirymz4xL=mWvC5A@mail.gmail.com>
 <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
 <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
In-Reply-To: <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/20/22 22:14, Peter Gonda wrote:
>>>> svm_vm_migrate_from() uses sev_lock_vcpus_for_migration() to lock all
>>>> source and target vcpu->locks. Mark the nested subclasses to avoid false
>>>> positives from lockdep.
>> Nope. Good catch, I didn't realize there was a limit 8 subclasses:
> Does anyone have thoughts on how we can resolve this vCPU locking with
> the 8 subclass max?

The documentation does not have anything.  Maybe you can call 
mutex_release manually (and mutex_acquire before unlocking).

Paolo

