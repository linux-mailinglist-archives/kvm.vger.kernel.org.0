Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625453F1DF1
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 18:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhHSQg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 12:36:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229670AbhHSQg5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 12:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629390981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QRADmVpMk7gxIeSjI8AF9ZEWtYphhMQoIru5hz5pwfU=;
        b=fKuAm696uornlfp87mvc9tN5c8lSQt2KWNDL+ybEJ5UljdfGZ0L3mF7/lZ6g4ZPFm73oeS
        lyxEN6McPvn+jiCBZhbLefpZMY4AAbqRnZOUlvyfiaoSt5eB0e1CAR87+/K9qj88L+pdXQ
        djW7s6X+LyfrP93GR7zSPT8z6409OTE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-Rlh2meTYMQ67wQ4gqU327g-1; Thu, 19 Aug 2021 12:36:17 -0400
X-MC-Unique: Rlh2meTYMQ67wQ4gqU327g-1
Received: by mail-ed1-f71.google.com with SMTP id n4-20020aa7c6840000b02903be94ce771fso3122049edq.11
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 09:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QRADmVpMk7gxIeSjI8AF9ZEWtYphhMQoIru5hz5pwfU=;
        b=q2UzJqG2XudhBBWCh1hF04ueakuQpegMaI3haKCVDgRSzv/r/qIYfUhgLoq8G/zbDz
         OQY5+vNoQDO8PNC9rhsfPHUNN/UHAOiDrv7BuixR1YgTXgU9GFyO22f1Bm5w2BfEDY9M
         Yy/1r9EvbDOflQkqOaEeObOzZ34Qy5cT2AKbBCdVKFVlDEkOatbvSqO9Ixx9ciwR1wKu
         hNg/Gc8XjwTsadj1RVGkZq7aFTf6TRoZOTHhFALH6eWvJFy/bfUhVFO/Mz35yx7J1ULl
         KYmF7TFcaxZ3qA8RdOdrPu3kZ4INm8/pvBF/1AFuQahAJ5agj6WCE/eZ2A7Ce3eYJR1h
         3fUA==
X-Gm-Message-State: AOAM533hk6Kn5NCi7L885y3GRFTjoNNqVnVw4LWe+Mvo082fz0usGjtP
        SHUOsAtqFQy71aOjO+0DcrEn4yqK9Y8Dh6mx+Na7jsSGWHetu//yDDOsULlZ51Zmwx3PyvZOuDZ
        f2aEZpGWAdNlf
X-Received: by 2002:a17:907:3e05:: with SMTP id hp5mr16637757ejc.527.1629390976582;
        Thu, 19 Aug 2021 09:36:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0W8aPaJHnF8/QyCKfWtDdR25ynmh6DTCOlr4xDkLluAyuNdzXBZ4A8UisJ6o4jgu4LgqqyA==
X-Received: by 2002:a17:907:3e05:: with SMTP id hp5mr16637743ejc.527.1629390976415;
        Thu, 19 Aug 2021 09:36:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id r20sm1522212ejz.120.2021.08.19.09.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 09:36:14 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] KVM: x86: Handle the case of 5-level shadow page
 table
To:     Sean Christopherson <seanjc@google.com>,
        Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
References: <20210818165549.3771014-1-wei.huang2@amd.com>
 <20210818165549.3771014-3-wei.huang2@amd.com> <YR1AHVwUM8AS5JvQ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a73558eb-01d0-31e3-d066-8da1c05495d4@redhat.com>
Date:   Thu, 19 Aug 2021 18:36:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YR1AHVwUM8AS5JvQ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/08/21 19:15, Sean Christopherson wrote:
>> When the 5-level page table CPU flag is exposed, KVM code needs to handle
>> this case by pointing mmu->root_hpa to a properly-constructed 5-level page
>> table.
> Similarly, this is wrong, or maybe just poorly worded.  This has nothing to do
> with LA57 being exposed to the guest, it's purely the host using 5-level paging
> and NPT being enabled and exposed to L1.

Like this:

---
KVM: x86/mmu: Support shadowing NPT when 5-level paging is enabled in host

When the 5-level page table CPU flag is set in the host, but the guest
has CR4.LA57=0 (including the case of a 32-bit guest), the top level of
the shadow NPT page tables will be fixed, consisting of one pointer to
a lower-level table and 511 non-present entries.  Extend the existing
code that creates the fixed PML4 or PDP table, to provide a fixed PML5
table if needed.

This is not needed on EPT because the number of layers in the tables
is specified in the EPTP instead of depending on the host CR4.
---

Paolo

