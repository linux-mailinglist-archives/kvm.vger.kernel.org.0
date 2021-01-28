Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B21430714B
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 09:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhA1ITu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 03:19:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231335AbhA1ITn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 03:19:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611821889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9C3yiPfFKb5aW+Bgfuw5xS6YHiwj8cVR/h8E0NIrX2U=;
        b=QGQG9Dcwk73c0msOeNGC5YboYQsHLu0pc3TY91bw5yOdlFINHEept1H30sDk4dsioMvkO+
        OzgMSvdzR3coflGk/AuHjUIRlccCJ84R0BBHkxSMSOWvpCiW8M3RbZ4SEBsGNwvc+iV29/
        b1sVpiV/ZdcoYPVarBtF11lh5ce2Zmo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-baYiU9SRNnW_70c2gB2tbg-1; Thu, 28 Jan 2021 03:18:06 -0500
X-MC-Unique: baYiU9SRNnW_70c2gB2tbg-1
Received: by mail-ed1-f69.google.com with SMTP id j11so2807507edy.20
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 00:18:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9C3yiPfFKb5aW+Bgfuw5xS6YHiwj8cVR/h8E0NIrX2U=;
        b=XYCp1VeGzzw9QYSoCZM8QAokpM1AJARmy3QftoNr+ygqtkvIAXclgi9tHZichayyRV
         WPt8BpFM8UQxNbf5QZ3cZ7ShYN4N1PQLwLDrpdriPVC7EXtPL7PrztVSKAtj3joR+Uny
         nsKxR6O+KOhXJftuufwfVk8tuH17dg+q8vhWNX3aJVIOPBuR3RKAHvt3YrL8WJiPq51z
         TEhP8f4oxss7ecU/Ld+frBYNHrXAp0B58z38ZIZg4WPCGMYYEHVRUyrr2pm1zoQN/OQQ
         Qy3fWeoUx6JsruCdg0FsAsJjrAwsvAKLAHe7YC3kF7YUOUlt0WsltJQZpMj/AcDZFU8B
         XVfQ==
X-Gm-Message-State: AOAM5330kXLmwmTDiwUp/6nlRu/1v9D/kZkRXosMhpYE9LIJAhLUNLtz
        3SEX36jLP2rFWbG4eEasRgWN+fbTkc9TcRvX+AEGAydCZh0EqH5Wb+sP3g0khSZ6APDqp1gP8SG
        G/GyzJXEyy3Fi
X-Received: by 2002:aa7:d0d4:: with SMTP id u20mr12312765edo.203.1611821885483;
        Thu, 28 Jan 2021 00:18:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJKqbOLa1ltAkb+2RvgjlMFRSmUiSGsTYcB1FyvSUbCwutAznr+10kD6tqpqX55az450Jegg==
X-Received: by 2002:aa7:d0d4:: with SMTP id u20mr12312749edo.203.1611821885259;
        Thu, 28 Jan 2021 00:18:05 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gj9sm1935372ejb.107.2021.01.28.00.18.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 00:18:04 -0800 (PST)
Subject: Re: [PATCH 15/24] kvm: mmu: Wrap mmu_lock cond_resched and needbreak
To:     Ben Gardon <bgardon@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-16-bgardon@google.com> <YAjIddUuw/SZ+7ut@google.com>
 <460d38b9-d920-9339-1293-5900d242db37@redhat.com>
 <CANgfPd_WvXP=mOnxFR8BY=WnbR5Gn8RpK7aR_mOrdDiCh4VEeQ@mail.gmail.com>
 <fae0e326-cfd4-bf5d-97b5-ae632fb2de34@redhat.com>
 <CANgfPd_TOpc_cinPwAyH-0WajRM1nZvn9q6s70jno5LFf2vsdQ@mail.gmail.com>
 <f1ef3118-2a8e-4bf2-b3b0-60ac4947e106@redhat.com>
 <CANgfPd9FaPhQiEkJ=VHKiVWZ_5S3k2uWHU+ViCi4nEF=GU4qsw@mail.gmail.com>
 <4c0d4c30-a95b-7954-d344-fb991270f79a@redhat.com>
 <CANgfPd9torZ_ta7eoB6OwZa3M-LCqU+8802wfWiWDFLio2-Ysg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <816d3c6a-2418-8091-96fb-6a4e6bbf0a95@redhat.com>
Date:   Thu, 28 Jan 2021 09:18:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd9torZ_ta7eoB6OwZa3M-LCqU+8802wfWiWDFLio2-Ysg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/21 22:20, Ben Gardon wrote:
> On Wed, Jan 27, 2021 at 12:55 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 27/01/21 21:08, Ben Gardon wrote:
>>> I'm not entirely sure I understand this suggestion. Are you suggesting
>>> we'd have the spinlock and rwlock in a union in struct kvm but then
>>> use a static define to choose which one is used by other functions? It
>>> seems like if we're using static defines the union doesn't add value.
>>
>> Of course you're right.  You'd just place the #ifdef in the struct kvm
>> definition.
> 
> Ah okay, thanks for clarifying.
> 
>>
>> You can place static inline functions for lock/unlock in
>> virt/kvm/mmu_lock.h, in order to avoid a proliferation of #ifdefs.
> 
> Would you prefer to make that change in this series or at a later
> date? I'm assuming this would replace all the wrapper functions and
> mean that x86 is rwlock only.

Yes, exactly.  I would like to make tdp_mmu=1 the default as soon as 
parallel page faults are in (and thus scalability should be on par with 
the shadow MMU).

Paolo

