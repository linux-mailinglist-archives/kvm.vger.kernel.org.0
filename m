Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D36440FEB5
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 19:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240159AbhIQRiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 13:38:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237238AbhIQRit (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Sep 2021 13:38:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631900247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TQ69tgYk0yh6UZaHgteT2LE/TfdaRnldb8roVNiJD38=;
        b=iRda8VoJz912C313Y5Txs3k1PPbTu6enWBdm2zv7k8QzcuepFuJP2FOd3k/sdtV7qaGdX4
        ZwUWpsJ6aEr06Ytq7VQ7a77ElfszHiFYQEnF7kRBpkxKaKAiQWJjMy4EDNms6n4dDdCWOx
        J8IIVB0aESEt6JaWqo88O+ZmSKcKR+Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-ogkwsfYdO1qGW_qO0P7jFw-1; Fri, 17 Sep 2021 13:37:25 -0400
X-MC-Unique: ogkwsfYdO1qGW_qO0P7jFw-1
Received: by mail-ed1-f72.google.com with SMTP id z6-20020a50cd06000000b003d2c2e38f1fso9745798edi.1
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 10:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TQ69tgYk0yh6UZaHgteT2LE/TfdaRnldb8roVNiJD38=;
        b=kdeJb7rl4c3Cnti2/3MUwH/l++obzMr47Tvv7nsBlfGIDj0PHPDq0hBWIijnBUjQIo
         n1A3ODR/7BNLH3q1K6o24PbEzTg5BBqSW88fsz++ThSPhI/oJtTr5sIjrsBVuH+iZ1na
         rC13iPOGqznBLS/UGlcQEX5IrNGMCpIoWF2TOYIX9SHANYvGj4alLtgd228m42YGJgyD
         GxrzslRw6CHSyy47VjIbOOjes/lI/ogrMpt76/rz2g7BmZ7AnFA2HJn63aUifLwa7P3x
         eYmt7mnck4IGvsfON9VKvcu7WzbEgaK31qFm3H2bH4HdWK6Ts4+6KhZDTjKYBZ8//9Xt
         6THQ==
X-Gm-Message-State: AOAM531Z7ajQyrK9aB6lKbyfE6YCiTUqZ71JqPhBinPB/dORJ9fSq57n
        E8iS5XS1UeEolED2syO2iRHM9lcStBQ7x65tFLC+7DcWc79IcC5vWT4LcRiNxgj7ZMDTpRZpklh
        VyKcHSfBrWVDw
X-Received: by 2002:aa7:d582:: with SMTP id r2mr13896174edq.324.1631900244583;
        Fri, 17 Sep 2021 10:37:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLtBte+3SaIrVpcwkvtQdqnblyNWMQHx8gbT1bNYByKRPARqRI8cZxbuL5acvrGWIvc77JMg==
X-Received: by 2002:aa7:d582:: with SMTP id r2mr13896157edq.324.1631900244407;
        Fri, 17 Sep 2021 10:37:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k20sm2532336ejd.33.2021.09.17.10.37.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 10:37:22 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: x86: Clean up RESET "emulation"
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
        Reiji Watanabe <reijiw@google.com>
References: <20210914230840.3030620-1-seanjc@google.com>
 <CABgObfYz1b3YO4a9tR02TourLmsnS48RWrOprrsEh=NpbQfjRA@mail.gmail.com>
 <YUTRwNT/O5Ny0MOQ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a77e3edd-2b58-fb46-8a76-2d8446892992@redhat.com>
Date:   Fri, 17 Sep 2021 19:37:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YUTRwNT/O5Ny0MOQ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/09/21 19:34, Sean Christopherson wrote:
>> but I do like it so yes, that was it. Especially the fact that init_vmcb now
>> has a single caller. I would further consider moving save area initialization
>> to *_vcpu_reset, and keeping the control fields in init_vmcb/vmcs. That would
>> make it easier to relate the two functions to separate parts of the manuals.
>
> I like the idea, but I think I'd prefer to tackle that at the same time as generic
> support for handling MSRs at RESET/INIT.

No problem, just roughly sketching some ideas for the future.  But 
you're absolutely right that some MSRs have effects on the control areas 
rather than the save area (and some have effects on neither).

Thanks,

Paolo

> E.g. instead of manually writing
> vmcs.GUEST_SYSENTER_* at RESET, provide infrastruture to automagically run through
> all emulated/virtualized at RESET and/or INIT as appropriate to initialize the
> guest value.
> 

