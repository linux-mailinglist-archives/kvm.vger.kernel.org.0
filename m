Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9724D1F08
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348394AbiCHR0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236302AbiCHR0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:26:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67E8855493
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646760348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q/lckdEEo4hed4la2Ow/NwQiBYvBPG8eF9jfDI+IWDk=;
        b=TfwdV8+teKBXuoPRUWWKSiUxHRAQpbwidRjfM5fNP0srLwYvR/vfIeFxPwZNkOEPMcBarF
        nl8YF0oDMcSz/sE1tEJ1UM3k4ht6OLD8GovIilV4QJPVX5RTxUJ3gOfo1WaBOg3Hw+6Xyp
        PRziPvFxs5CYhZzVnKFThkzjW1AEPKw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-gykqanL9P2eWEApjHJc1xA-1; Tue, 08 Mar 2022 12:25:47 -0500
X-MC-Unique: gykqanL9P2eWEApjHJc1xA-1
Received: by mail-wm1-f70.google.com with SMTP id m34-20020a05600c3b2200b0038115c73361so6700902wms.5
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 09:25:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q/lckdEEo4hed4la2Ow/NwQiBYvBPG8eF9jfDI+IWDk=;
        b=f0kpRFYcNc0QfJhw/j9OjRELbAZuQSIQfHmjd7noK3betemqCmbs00J12eTI+UWVIc
         C9BUob7tV7HGnA57rRHLBUhR93VelcauOZYpfp4+MtrrQrYveTHIAg5nM4t3kEmhaKmD
         Nb8+hIe7W6LdKGnP3zgguJyuVuOAYYihx/8GspPQSAFFCHUOeJaQ53iSyk4wTYWJo7hg
         fQOPV2OfyzpIZSEKkw7B5n01uZ48z+gnGgUOb/nixN1a6n0w5eaoQ80kTJrNToBe/Bye
         yoHajfggNR1S7TXhizlJ/JXR8Q8KWs0wPaScbI4bXoe7NFMxnDGtkwiZC8J2OtgwItJm
         k0rw==
X-Gm-Message-State: AOAM531CHTzhH/YGI9191s0TbqbrAz5FOEdvoz/zR+M1ZLbFeLmYR3IE
        +slAf3jit2N63IjEVVtxaAjMi3F4RsSjscho1OcAU2bqLVJ3Kmp/7xNLx8W6MdVjOwbdV2kzfgT
        WkmaNZYMQcmMK
X-Received: by 2002:a05:600c:354d:b0:389:cf43:da5b with SMTP id i13-20020a05600c354d00b00389cf43da5bmr274787wmq.197.1646760345865;
        Tue, 08 Mar 2022 09:25:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2P7TKLZXECaFnC2SY1p8jvQuNdB2bFZjXt7vgrW3IR1ckvbpCgCFrbs8199T7DYQXB/XQ+g==
X-Received: by 2002:a05:600c:354d:b0:389:cf43:da5b with SMTP id i13-20020a05600c354d00b00389cf43da5bmr274766wmq.197.1646760345532;
        Tue, 08 Mar 2022 09:25:45 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id i8-20020a1c5408000000b00389bf11ba0csm2794086wmb.38.2022.03.08.09.25.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 09:25:45 -0800 (PST)
Message-ID: <ec9b7bdd-f85a-5b39-1baa-86b5c68bcf31@redhat.com>
Date:   Tue, 8 Mar 2022 18:25:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 00/17] KVM: Add Xen event channel acceleration
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
References: <20220303154127.202856-1-dwmw2@infradead.org>
 <db8515e4-3668-51d2-d9af-711ebd48ad9b@redhat.com>
 <ec930edc27998dcfe8135a01e368d89747f03c41.camel@infradead.org>
 <adbaebac-19ed-e8b7-a79c-9831d2ac055f@redhat.com>
 <42ed3b0c3a82627975eada3bcc610d4e074cb326.camel@infradead.org>
 <5a0d39d9-48b9-5849-daf7-19fbadd75f8c@redhat.com>
 <e745f08e615e5eacb04ba492f5fcd1e7d14fa96c.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <e745f08e615e5eacb04ba492f5fcd1e7d14fa96c.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 18:20, David Woodhouse wrote:
>> Yes, I'm just talking about the second hunk.  The first is clear(ish).
> Oh, I see.
> 
> When the oneshot timer has expired and hasn't been re-armed by the
> guest, we should return zero as 'expires_ns' so that it doesn't get re-
> armed in the past (and, hopefully, immediately retriggered) when the
> guest is restored.
> 
> Also, we don't really want the timer firing*after*  the guest vCPU
> state has been serialized, since the newly-injected interrupt might not
> get migrated. Hence using hrtimer_cancel() as our check for whether
> it's still pending or not.
> 

I think the two are different.  The first is also clear, and that should 
be fixed with a separate bool or possibly a special meaning for 
expires_ns == -1 (or INT64_MAX, I don't speak Xen hypercalls :)).

The second should not be a problem.  The newly-injected interrupt might 
not get migrated, but it will be injected on the destination.  So it 
shouldn't be a problem, in fact anything that relies on that is probably 
going to be racy.

Paolo

