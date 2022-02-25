Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30F14C4866
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241775AbiBYPOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241755AbiBYPOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:14:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC1BB1959E6
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 07:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645802005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ov22t1h+p3GE8LnI0EYb92eCXGx+vATLrydZwrAaric=;
        b=jVFGxTav7ApKUnbrctKnAsZv972tRvl+IdVR8pNys91g+UVoyfl3Liwkx7QcTcyO4hdjWS
        RodtKWeHJd2k9Fa0HyJVzOHMPy2AOI+Dbq8GG4qUsn5k30zg5hgUKAaFFmgoWHNaErsZc0
        HQaUivDMfvm177Hl/NO1fhpRCyM5uAA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-gZjxEpFyMGmY62oTg19SAA-1; Fri, 25 Feb 2022 10:13:24 -0500
X-MC-Unique: gZjxEpFyMGmY62oTg19SAA-1
Received: by mail-wm1-f71.google.com with SMTP id i20-20020a05600c051400b00380d5eb51a7so1452833wmc.3
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 07:13:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ov22t1h+p3GE8LnI0EYb92eCXGx+vATLrydZwrAaric=;
        b=MhUPXZKeOyNDqE1ck2+DbjQo3C9W/6QeNoB7UZ8l7qvvN1ICO2EcMTuWIB/g8glxwk
         xYQ4n7L2SYlVnW0ZNsxVEq2h/glvzLvUSyPZpK6aC6YgZDqKkH96w/a4DAREoHaLPTyr
         tHfP4xXlg3Re6VrhxC38O5/2xwKQXdbYlzj/2Zb/vggvapTaadL1Ra3LselehhXAGIXL
         Tm/ZjHuODqpFkOWmGySqEEyk+FsVV/JHs9InISqs1LbxVzCs+FSSRU5jYS4qWTV4KSZw
         ComLEp+mLMmqNfZE3TgeAzFwaDyEqEG0KZiGuTrJtCkNXy3BOCzpprDxobPwrEn3ARws
         6Jnw==
X-Gm-Message-State: AOAM533jR5TjOsm58F01M7rhjxO3Pc0jBiQ39IexolwVBvaIw+6/fXWY
        N3/UUVFGL62qYXgVC2R74RonQoKfO6HJSBfU0vejDQfaH0fFYsrLBeAxNanAyBzS2l5pUSuSMqh
        rkb0yle/UsKvS
X-Received: by 2002:a05:600c:34cf:b0:380:f514:dee1 with SMTP id d15-20020a05600c34cf00b00380f514dee1mr3089256wmq.5.1645802002924;
        Fri, 25 Feb 2022 07:13:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDJ2C15TRsqqLZRDo4H+n1O6Fkpazg6veWu5whVVg5NXk90SmAcwX5kdNdrN9yZWucddmWZQ==
X-Received: by 2002:a05:600c:34cf:b0:380:f514:dee1 with SMTP id d15-20020a05600c34cf00b00380f514dee1mr3089243wmq.5.1645802002719;
        Fri, 25 Feb 2022 07:13:22 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m62-20020a1c2641000000b00380d0cff5f3sm6333003wmm.8.2022.02.25.07.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 07:13:22 -0800 (PST)
Message-ID: <7859e03f-10fa-dbc2-ed3c-5c09e62f9016@redhat.com>
Date:   Fri, 25 Feb 2022 16:13:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] KVM: VMX: Enable Notify VM exit
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220223062412.22334-1-chenyi.qiang@intel.com>
 <CALMp9eT50LjXYSwfWENjmfg=XxT4Bx3RzOYubKty8kr_APXCEw@mail.gmail.com>
 <88eb9a9a-fbe3-8e2c-02bd-4bdfc855b67f@intel.com>
 <6a839b88-392d-886d-836d-ca04cf700dce@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <6a839b88-392d-886d-836d-ca04cf700dce@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/22 16:12, Xiaoyao Li wrote:
>>>>
>>>
>>> I don't like the idea of making things up without notifying userspace
>>> that this is fictional. How is my customer running nested VMs supposed
>>> to know that L2 didn't actually shutdown, but L0 killed it because the
>>> notify window was exceeded? If this information isn't reported to
>>> userspace, I have no way of getting the information to the customer.
>>
>> Then, maybe a dedicated software define VM exit for it instead of 
>> reusing triple fault?
>>
> 
> Second thought, we can even just return Notify VM exit to L1 to tell L2 
> causes Notify VM exit, even thought Notify VM exit is not exposed to L1.

That might cause NULL pointer dereferences or other nasty occurrences.

Paolo

