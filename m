Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4BD2F4D05
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 15:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbhAMOW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 09:22:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726490AbhAMOW2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 09:22:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610547662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qDvYXlzCWmZW8l7+qsmeJcTXo8simSKtOvRJlD7ivSE=;
        b=ZsbfQEVrxo+/AK/eiGGaNIAblulpACS/Oal/r2MLOK9yrpqnZYmb+Jz0c/hpBSJn+MWrCe
        p3g6c5JXpJwIm+VeylLfizeOPJ6KfByP21QoB4IFsNLhhh4AuKxHkz+0OmTNcU91gRW305
        hBZAnv3VXzhxEckZu2YPKXc9bmWfyzI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-pMQmJxFhNbOzHG9eZDRRgg-1; Wed, 13 Jan 2021 09:21:00 -0500
X-MC-Unique: pMQmJxFhNbOzHG9eZDRRgg-1
Received: by mail-ej1-f71.google.com with SMTP id gu19so922487ejb.13
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 06:21:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qDvYXlzCWmZW8l7+qsmeJcTXo8simSKtOvRJlD7ivSE=;
        b=N0XPa0v+x02kK2jUD1GOxNZJ9DJLmiQw8tWa/a8VTrjb1AlbJufOAyGcKsgaKWabq5
         okgYDDlo3gqs+1/JNuH/6vD5ZPODnajixUvRHZv+GJcjGdmUxIltGAx23QhqFhKB0cXS
         oosdOJ93J8lhpJatVky4InYk07LczUnbYUVipSR9ccoTUcVyJulTRNiXHuOadhkPIIVM
         T4+hry+Z9c0Tx4iccN1VUiiXlvxlrNKfNCf7lJXIjwYeFgVF6pORQVMTf20BL5mlm0BP
         9cAamgZ4rQhESnbIpNC3i6I4KfcAQWPibh1mZEfug99oei/LHeTrLcdYKzAIg8yJFGcL
         qj0w==
X-Gm-Message-State: AOAM5322wfXPlVTolA1bCaziHtkk7zuwCC/rW7GR9R1nmoSFI1ey+jcc
        UiEM2szZbA5GjUrScDe2lp/XqZKiH75jpvEOusQ1FL0EvWURBS+2PnITA2+muyzfERFGJm2CBp+
        Z1nULHeEflzYZ
X-Received: by 2002:a17:907:3e02:: with SMTP id hp2mr1667448ejc.411.1610547658957;
        Wed, 13 Jan 2021 06:20:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyp7TDYokwXAdEbwUKYlzEEcb6iNsi7B6+19TjlnLRs+np3oNZVPDvstreZsI4Crw/ziDFeDw==
X-Received: by 2002:a17:907:3e02:: with SMTP id hp2mr1667435ejc.411.1610547658800;
        Wed, 13 Jan 2021 06:20:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i18sm901264edt.68.2021.01.13.06.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 06:20:58 -0800 (PST)
Subject: Re: UBSAN: shift-out-of-bounds in kvm_vcpu_after_set_cpuid
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        syzbot <syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        the arch/x86 maintainers <x86@kernel.org>
References: <000000000000d5173d05b7097755@google.com>
 <CALMp9eSKrn0zcmSuOE6GFi400PMgK+yeypS7+prtwBckgdW0vQ@mail.gmail.com>
 <X/zYsnfXpd6DT34D@google.com>
 <f1aa1f3c-1dac-2357-ee1c-ab505513382f@redhat.com>
 <X/3UJ7EtyAb2Ww+6@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d3cc2a46-6b8b-cf7c-66f0-22fe4c05465e@redhat.com>
Date:   Wed, 13 Jan 2021 15:20:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X/3UJ7EtyAb2Ww+6@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/21 17:53, Sean Christopherson wrote:
> On Tue, Jan 12, 2021, Paolo Bonzini wrote:
>> On 12/01/21 00:01, Sean Christopherson wrote:
>>>> Perhaps cpuid_query_maxphyaddr() should just look at the low 5 bits of
>>>> CPUID.80000008H:EAX?
>>
>> The low 6 bits I guess---yes, that would make sense and it would have also
>> fixed the bug.
> 
> No, that wouldn't have fixed this specific bug.  In this case, the issue was
> CPUID.80000008H:AL == 0; masking off bits 7:6 wouldn't have changed anything.

Right.

> And, masking bits 7:6 is architecturally wrong.  Both the SDM and APM state that
> bits 7:0 contain the number of PA bits.

They cannot be higher than 52, therefore bits 7:6 are (architecturally) 
always zero.  In other words, I interpret "bit 7:0 contain the number of 
PA bits" as "you need not do an '& 63' yourself", which is basically the 
opposite of "bit 7:6 might be nonzero".  If masking made any difference, 
it would be outside the spec already.

In fact another possibility to avoid UB is to do "& 63" of both s and e 
in rsvd_bits.  This would also be masking bits 7:6 of the CPUID leaf, 
just done differently.

Paolo

> KVM could reject guest.MAXPA > host.MAXPA, but arbitrarily dropping bits would
> be wrong.
> 

