Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C65F675008
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 09:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjATI5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 03:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjATI5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 03:57:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B007A3EC5B
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 00:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674205017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1wir807rUXDPF7L1FGyCmYNJjdQ4xN3ZAYWnRssjBv0=;
        b=KkHlsZFVcQBkc+jWuSQLL+WRDYdhZXsqEq+8/H8wMUeFMoOZguU8OAyTgtEU8RIy/5ur4K
        xQETJuNFh7HzF8patlCCxe3f+4GEaYFntEpCPbJH0V0if4AlvBdARi5O6gxUhzh2hxoXGt
        BOoCxllVzKwuLLw1bGXqTQboA29iOv4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-561-A44im2xqPj2XdApKUSpv_g-1; Fri, 20 Jan 2023 03:56:54 -0500
X-MC-Unique: A44im2xqPj2XdApKUSpv_g-1
Received: by mail-ed1-f72.google.com with SMTP id b15-20020a056402350f00b0049e42713e2bso3427998edd.0
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 00:56:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1wir807rUXDPF7L1FGyCmYNJjdQ4xN3ZAYWnRssjBv0=;
        b=pZgiA1ZG8lBToZJhX2+2KjHf5DXVPIiGSf9Ozgjn9lEUphdlAKp+DcKGy5tH/YZKW9
         xJG9fXow+p8/hpm/Y3aUMtsNtV7FSBkO+OHatiMWOBPUOaeimDbiDn7VoNg5BQg0hjwV
         W7RKJ78DjYmFsB420EY7uzBPjoOq+juAn0TyxcaQBo/PlaFEVLx6dlSBPL4BpTjhSv3c
         N5iC1xVncogTu24+44C/L3e/enl7hf9963LqlRQd0ZkiTnTRGiHVYGU4I4xmBR7EqaXp
         63tb1fupniCmyBB1HWxKA2tA0EBpMFoB7JUru954wtL3RI1MWyV0ZJj2yTPvZNiSHMcR
         YDbw==
X-Gm-Message-State: AFqh2kqzEG3qCA+iAAtudY29tCjD8RS3pvT8RzTPhwhlwqE1jdrjgs+0
        DjCKDnj/YMcrJ2SvrgVO23NCwd6gU+3GXery+coQl9FCF8Swae4ZZKzFoWopAYsWT6/87UmIu+P
        fSsMYIOHTHUQW
X-Received: by 2002:a17:906:944a:b0:7c1:23f2:5b51 with SMTP id z10-20020a170906944a00b007c123f25b51mr25021271ejx.60.1674205013058;
        Fri, 20 Jan 2023 00:56:53 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtJcdkvsN6BXkn3B4rd+TUahMQcnF3VTMqw3GcND5W8ZGkbbXCYdYmKBAsHb8M81v1E6ujLHg==
X-Received: by 2002:a17:906:944a:b0:7c1:23f2:5b51 with SMTP id z10-20020a170906944a00b007c123f25b51mr25021264ejx.60.1674205012807;
        Fri, 20 Jan 2023 00:56:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id g21-20020a170906869500b0084d36fd208esm16720249ejx.18.2023.01.20.00.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 00:56:52 -0800 (PST)
Message-ID: <dfec1db0-d2f7-cd80-c9f5-0f20b72cbddc@redhat.com>
Date:   Fri, 20 Jan 2023 09:56:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] KVM: x86: add bit to indicate correct tsc_shift
Content-Language: en-US
To:     Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
References: <Y8no/eAQi0QkIJqa@tpad>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y8no/eAQi0QkIJqa@tpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/23 02:06, Marcelo Tosatti wrote:
> Before commit 78db6a5037965429c04d708281f35a6e5562d31b,
> kvm_guest_time_update() would use vcpu->virtual_tsc_khz to calculate
> tsc_shift value in the vcpus pvclock structure written to guest memory.
> 
> For those kernels, if vcpu->virtual_tsc_khz != tsc_khz (which can be the
> case when guest state is restored via migration, or if tsc-khz option is
> passed to QEMU), and TSC scaling is not enabled (which happens if the
> difference between the frequency requested via KVM_SET_TSC_KHZ and the
> host TSC KHZ is smaller than 250ppm), then there can be a difference
> between what KVM_GET_CLOCK would return and what the guest reads as
> kvmclock value.

I don't think it's justifiable to further complicate the userspace API 
for a bug that's been fixed six years ago.  I'd be very surprised if any 
combination of modern upstream {QEMU,kernel} is going to do a successful 
migration from such an old {QEMU,kernel}.  RHEL/CentOS are able to do so 
because *specific pairs* have been tested, but as far as upstream is 
concerned this adds complexity that absolutely no one will use.

I replied on the QEMU patch with further suggestions.

Paolo

