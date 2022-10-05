Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270EB5F5425
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 14:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJEMER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 08:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJEMEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 08:04:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B27B27B3A
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 05:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664971453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BlPrrfcGT4CkXDtYZUhRJ8tm3C0EIa49OiJh2AlYYUE=;
        b=cw105nJl+CFNpl60J4e9S4UtgG5BOwrtWOhSXXBILiqdyYcuTfrlhWuSWtndwb/x68dkrB
        85h0gMmk7ufrJhkjmVz6HkqAbVKlXGwST2fXUDGO4QR34TG0mo7eAlnFybXhS1KHBO/r+t
        KvQEaIF2yZFiJEEIrwt3lyF161ijwII=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-179-UOyY4d6UPd6CyWAA00wJXA-1; Wed, 05 Oct 2022 08:04:12 -0400
X-MC-Unique: UOyY4d6UPd6CyWAA00wJXA-1
Received: by mail-qv1-f70.google.com with SMTP id jn13-20020ad45ded000000b004b1d055fbc7so357594qvb.2
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 05:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=BlPrrfcGT4CkXDtYZUhRJ8tm3C0EIa49OiJh2AlYYUE=;
        b=wtd0hm8GVakeJEwNx2AC4K/yphwGNL9e6vgMsN5YykHF1e942lmlCbfvU38eK/q8b5
         TQoVgqp3lz+OVMAia/1NqPbWMx37GCYgRmdTDFPyL4qQE/oxqRKHYEJ61aeaQicWvDsN
         pTv5OvfO/SS1jdln7w1qCBGtHNWDYdG1Ktul5GL3zeBBe4nl6yI1nuqC47D3ggKJ2UvZ
         6cYXfaN07fQGhvyywRkDpzhXndc2Q1XMpMbPjG30NwiMJ/tk9V0x1VrW4vVm/EHQE7ww
         x1Z+ltuGg9jPJdsLKn/lPkJ+sP/T+I0tiFsEDZVtLIi2rpJgp1dyPwO9m/ZUrpyacIK9
         3DnA==
X-Gm-Message-State: ACrzQf0TZNA11sL2wvdaLBbwVS5DwHxRoN+YCa9awI+mUUzbg3uv9YSt
        ISJkW8XVP92mNr00bJqX8Qj6/+uegOcwIXPoiqbUvUlMNJVcYIH2sVb/oEyrbcheMmXoBF9aUzs
        hF43GugD06A13
X-Received: by 2002:a05:620a:bcc:b0:6ce:c077:acf3 with SMTP id s12-20020a05620a0bcc00b006cec077acf3mr19618715qki.263.1664971451484;
        Wed, 05 Oct 2022 05:04:11 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4hKMNqZ8bYcjvLp5n2KqUIIJBdLNHxVrMW4wzuvyPidckVVWCZhPsj+BIWR03I5VfGgnaIIg==
X-Received: by 2002:a05:620a:bcc:b0:6ce:c077:acf3 with SMTP id s12-20020a05620a0bcc00b006cec077acf3mr19618692qki.263.1664971451078;
        Wed, 05 Oct 2022 05:04:11 -0700 (PDT)
Received: from [172.20.5.108] (rrcs-66-57-248-11.midsouth.biz.rr.com. [66.57.248.11])
        by smtp.googlemail.com with ESMTPSA id o2-20020ac87c42000000b0035cebb79aaesm15016302qtv.18.2022.10.05.05.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 05:04:10 -0700 (PDT)
Message-ID: <d074cb45-72d3-a4a4-30f9-cfb664bb010a@redhat.com>
Date:   Wed, 5 Oct 2022 14:04:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: Finish removing MPX from arch/x86?
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>
References: <547a1203-0339-7ad2-9505-eab027046298@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <547a1203-0339-7ad2-9505-eab027046298@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/4/22 19:34, Dave Hansen wrote:
> We zapped the userspace MPX ABIs and most of its supporting code in here:
> 
> 	45fc24e89b7c ("x86/mpx: remove MPX from arch/x86")
> 
> But, the XSAVE enabling and KVM code were left in place.  This let folks
> at least keep running guests with MPX.
> 
> It's been a couple of years and I don't think I've had a single person
> opine about the loss of MPX.  Intel also followed through and there's no
> MPX to be found on newer CPUs like my "Tiger Lake" 11th Gen Intel(R)
> Core(TM) i7-1165G7.
> 
> Is it time to zap MPX from arch/x86/kvm/?

I agree that the likelihood of anybody complaining about MPX is low but 
Jim is right that the timeline for removing it is unfortunately quite long.

Removing MPX from XFEATURE_MASK_USER_SUPPORTED is possible, though we 
need to add a new XFEATURE_MASK_GUEST_SUPPORTED that includes MPX.  I'll 
take a look.

Also, it's worth noting that MPX lives in the sigcontext ABI because it 
uses the non-compacted format.  Because of that it is not possible to 
remove the structs from include/asm/fpu/types.h, for example.

Paolo

