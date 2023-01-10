Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37A66642E9
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 15:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238362AbjAJOLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 09:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjAJOLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 09:11:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F49090241
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 06:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673359806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xU6PGlTNk/jOAm69hbehGdR5AFmWPCrwoQ2SymKrkmY=;
        b=X79/SER7WTDJIqgtqXmLmAD76fW9Dr6M4dk9bdjJXsP5T4pkcs/8CevMeeip2csX9hAsmG
        RgZ2A752oSzHhtQeCAvQNvwp8fxD67DA0OnggZoON+d37JYfeSOkZGP18GJ4d7uE7odqdQ
        dRw5LfaRVNKA4hu5YUTGYO4NCbFK9TI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-214-Xa5jCJ_7MBGistVAhQPBQw-1; Tue, 10 Jan 2023 09:10:04 -0500
X-MC-Unique: Xa5jCJ_7MBGistVAhQPBQw-1
Received: by mail-wr1-f70.google.com with SMTP id e29-20020adf9bdd000000b002bb0d0ea681so1979273wrc.20
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 06:10:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xU6PGlTNk/jOAm69hbehGdR5AFmWPCrwoQ2SymKrkmY=;
        b=f5hLsEsad1wQiqVaQjr86I0FV2u7AsZmFLCZW9lgPT+iBMBbpdiqX9Eeie1t2CBc57
         Vf1U7OmEw+CkxPsJV3Ai69TkiTXFgaCvJlpsROfGw16sSoWvyIabXZqp3tVTLPzeSQqJ
         9IXP91hMCEMnF8Vu1DCBx9FzdPmhAzdszM+utWWhP1YJee2siIgUFgr8piTt8DLvDjkR
         dED0bEwOTIpCqLpy+I+w50nYxbWdjiedH6TXWjjKkxVA77FY7c9KneSJy5sc41ksppfW
         /XuY95Dm19FjXpgNj2C6iS1+cKoL7Z4u07vFcuggZCHHsC45CJuKsAbt7rbDuRIEeZJ1
         Jchg==
X-Gm-Message-State: AFqh2kq6uiW35Id3kWYw1qF6vGxMV803Cw831R9KHvgFyhviEajWFwoz
        OgqCcj8GfMQOvBlha2xQerDiYS7ZC00fnydxf6w2BKGaEZr31CZpw6Mo72hFG4GWvUHl2yzpxlb
        nlCHEbJFZ6psy
X-Received: by 2002:adf:f746:0:b0:2b8:bcd8:1818 with SMTP id z6-20020adff746000000b002b8bcd81818mr10289610wrp.1.1673359803020;
        Tue, 10 Jan 2023 06:10:03 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvySRFXcCzIjdS8her35zEPzAicPYbrUSXD9yH4PB5GRQuCjeGmxGt11K3eyH4BSudd8EZe0w==
X-Received: by 2002:adf:f746:0:b0:2b8:bcd8:1818 with SMTP id z6-20020adff746000000b002b8bcd81818mr10289600wrp.1.1673359802798;
        Tue, 10 Jan 2023 06:10:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id q16-20020adff950000000b002bcaa47bf78sm2027077wrr.26.2023.01.10.06.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 06:10:02 -0800 (PST)
Message-ID: <9cd3c43b-4bfe-cf4e-f97e-a0c840574445@redhat.com>
Date:   Tue, 10 Jan 2023 15:10:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 1/2] KVM: x86: Fix deadlock in
 kvm_vm_ioctl_set_msr_filter()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, paul@xen.org
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
 <20221229211737.138861-1-mhal@rbox.co> <20221229211737.138861-2-mhal@rbox.co>
 <Y7RjL+0Sjbm/rmUv@google.com> <c33180be-a5cc-64b1-f2e5-6a1a5dd0d996@rbox.co>
 <Y7dN0Negds7XUbvI@google.com>
 <3a4ab7b0-67f3-f686-0471-1ae919d151b5@redhat.com>
 <f3b61f1c0b92af97a285c9e05f1ac99c1940e5a9.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <f3b61f1c0b92af97a285c9e05f1ac99c1940e5a9.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/23 13:55, David Woodhouse wrote:
>> However, I
>> completely forgot the sev_lock_vcpus_for_migration case, which is the
>> exception that... well, disproves the rule.
>>
> But because it's an exception and rarely happens in practice, lockdep
> didn't notice and keep me honest sooner? Can we take them in that order
> just for fun at startup, to make sure lockdep knows?

Sure, why not.  Out of curiosity, is this kind of "priming" a thing 
elsewhere in the kernel?

>> Fortunately, it's pretty easy to introduce a new lock just for xen.c and
>> revert the docs patch.
> The wording of that made me hold off, on the expectation that if I did
> it myself, you'd probably beat me to it with a patch. But I don't see
> one yet. Shall I?

No, I have already written it but didn't send it because I wanted to 
test it on the real thing using your QEMU patches. :)  But that was a 
rabbit hole of its own, my Xen knowledge is somewhat outdated.

Paolo

