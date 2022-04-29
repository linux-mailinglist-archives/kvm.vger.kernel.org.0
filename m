Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8346D514DD9
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 16:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377763AbiD2Osb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377752AbiD2Os2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:48:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49EB65588
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651243509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=reLN1pG1/CChgH6ozCSwMmfyN+LJMqKj0Ol22hvsDgw=;
        b=Vpp4qT6PMzFJlWeMiynSYd74/XZKoPYXDfSSnQPMVDwK1rSf8IyfXfVmgiTvYzIQJQUiDV
        S19RYua3pYegIPuUO37ivfXYNKJmw0D0mSMP/pyMb4q/QAuz2wgBEiSX28BrmS6IEGnzBK
        ETSXFtX8V6H7DfdT9p/WBOVN8coOqps=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-xTCFGf8wMXOdLY_kZZsSnw-1; Fri, 29 Apr 2022 10:45:07 -0400
X-MC-Unique: xTCFGf8wMXOdLY_kZZsSnw-1
Received: by mail-ej1-f70.google.com with SMTP id oz9-20020a1709077d8900b006f3d9488090so3120904ejc.6
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:45:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=reLN1pG1/CChgH6ozCSwMmfyN+LJMqKj0Ol22hvsDgw=;
        b=4es/r19sNVWwnOuuktDwARyI+oHE8OcnWjFrx5FWmzS5+LuWKU57kgKYE2v/TN4sjI
         T3ogdci5a/jEgdCCr06p/Tn2le1NxT/6LJe82zqKfq8DcB9fX6Yqpy0XGEm5CfW003nY
         MV7G6LXK4mnwl+So8l5kFmLLXTBV9pXrHuGDR4fcl9X/aJe/xCb572TcE/iQ2j0dL99m
         u3471ryNqXnfhbMirlBu4MojTcAomnJeBfJ6D2UocSe7wIWYQpt35HmvANO4ZaX5SQLu
         sitROYsytCyo2sn2tEgnQreiElvDUcsvZdYgmWeVuoMj1FYbZvEleiDtnOov5/iQ5kdy
         6BBA==
X-Gm-Message-State: AOAM532nKtoftqwyZV3R7ztrwL+aMd1ARBW01FU+xtcuqxklwj7Xgoe6
        Bj3a2vdBS96tPSsR3scWqhNHJpF4iVgSf/VpIjalJ2BudvreGp3FGFXccyXD/9byrrQEiuor2eq
        E0NAIo0X1Vam1
X-Received: by 2002:a17:907:3f91:b0:6d7:16c0:ae1b with SMTP id hr17-20020a1709073f9100b006d716c0ae1bmr36173034ejc.74.1651243506540;
        Fri, 29 Apr 2022 07:45:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrRMmBaW56vukrRtL88Onw+W9T5clAHH2pPU49YFnPmyqnQ5xD7Ht1ZUTszCVALYKc3un4wQ==
X-Received: by 2002:a17:907:3f91:b0:6d7:16c0:ae1b with SMTP id hr17-20020a1709073f9100b006d716c0ae1bmr36173012ejc.74.1651243506264;
        Fri, 29 Apr 2022 07:45:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id t19-20020aa7d4d3000000b0042617ba63c2sm3038883edr.76.2022.04.29.07.45.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 07:45:05 -0700 (PDT)
Message-ID: <67222fe0-7bf0-ec7a-0791-a4d48391a15e@redhat.com>
Date:   Fri, 29 Apr 2022 16:45:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220429031757.2042406-1-mizhang@google.com>
 <4b0936bf-fd3e-950a-81af-fd393475553f@redhat.com>
 <Ymv3vwBEgCH0CMPH@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: fix potential races when walking host page
 table
In-Reply-To: <Ymv3vwBEgCH0CMPH@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 16:35, Sean Christopherson wrote:
> On Fri, Apr 29, 2022, Paolo Bonzini wrote:
>>> +out:
>>> +	local_irq_restore(flags);
>>> +	return level;
>>> +}
>>> +EXPORT_SYMBOL_GPL(kvm_lookup_address_level_in_mm);
>>
>> Exporting is not needed.
>>
>> Thanks for writing the walk code though.  I'll adapt it and integrate the
>> patch.
> 
> But why are we fixing this only in KVM?  I liked the idea of stealing perf's
> implementation because it was a seemlingly perfect fit and wouldn't introduce
> new code (ignoring wrappers, etc...).
> 
> We _know_ that at least one subsystem is misusing lookup_address_in_pgd() and
> given that its wrappers are exported, I highly doubt KVM is the only offender.
> It really feels like we're passing the buck here by burying the fix in KVM.

There are two ways to do it:

* having a generic function in mm/.  The main issue there is the lack of 
a PG_LEVEL_{P4D,PUD,PMD,PTE} enum at the mm/ level.  We could use 
(ctz(x) - 12) / 9 to go from size to level, but it's ugly and there 
could be architectures with heterogeneous page table sizes.

* having a generic function in arch/x86/.  In this case KVM seems to be 
the odd one that doesn't need the PTE.  For example vc_slow_virt_to_phys 
needs the PTE, and needs the size rather than the "level" per se.

So for now I punted, while keeping open the door for moving code from 
arch/x86/kvm/ to mm/ if anyone else (even other KVM ports) need the same 
logic.

Paolo

