Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB881BDD64
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 15:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgD2NVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 09:21:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55844 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726599AbgD2NVw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 09:21:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588166510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kh2zEXuRrHJ7OoyUsto1r+1dFw1T/nGXYT4VtCcPwG4=;
        b=aigJc8JR81mnRUxaWqNlL4tr/sYvl2THPdb1NQJhOVx/r8Sl5G9zQCF5KRjQmU5h1C97oV
        7DPSHieJMWvFEjitXFmA4WthbCA5STi0i6jRXE9ZsWFSc7g1nHk8rL9YkgYHuExewUikXl
        A+OW1lFI0RJgkyG/aiHSQ4//8cP8a3k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-pXIgCupwOnKTnob2EpDzJg-1; Wed, 29 Apr 2020 09:21:49 -0400
X-MC-Unique: pXIgCupwOnKTnob2EpDzJg-1
Received: by mail-wr1-f72.google.com with SMTP id r17so1706013wrg.19
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 06:21:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kh2zEXuRrHJ7OoyUsto1r+1dFw1T/nGXYT4VtCcPwG4=;
        b=h5gggXGmRc9XqNwv9oNNbc61HywIjxF0dsadb+FmQdugV3fCa/K7G9Vr9yHI4QGXu3
         nn8mX3NSlAW9VjzaE9MdEykwxO1d9YUK+OQqqnZMnBUQdQsJHEaiW65V+9HRKDMQZbyt
         eRKs6EcIGzTObFXj5clyqKcjQFp5FR+0JywOjk1bcKl+DCgbGk7lDT89vcUPZfhj6bJr
         8ppgMH/aSl26IAEw/ynfI+UNc8MjEseoXNqkDQDepFnKNe+cerGWtOhPzyud5s+uNwrK
         6ow/VYzTx2H0BR/Bu2gGz19jedNtgY2p+/YN3uH2nIJU/4OqLL3PrLymseGr4JezqtfQ
         6F+A==
X-Gm-Message-State: AGi0PuahG3lHVqpaJfNhpZblA6wZy67XQaKvm3VSoET/7ipH6RZGuyNs
        MucvdsOGibZq9xcSi8fOg/5+W621E987TXVBB2oBIFqeDELnldnaHkrumLnF2sGIBuvaWf9E0um
        5yPV4n/Ol9Yfv
X-Received: by 2002:a5d:574b:: with SMTP id q11mr33967169wrw.324.1588166507575;
        Wed, 29 Apr 2020 06:21:47 -0700 (PDT)
X-Google-Smtp-Source: APiQypIHNXwnwSe2sR6WV2t9YCV9HVySfV4QKReiL6szz5wDHMQxpkv0Y/6/6o/vsY5sereoKPmpnw==
X-Received: by 2002:a5d:574b:: with SMTP id q11mr33967138wrw.324.1588166507283;
        Wed, 29 Apr 2020 06:21:47 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id x18sm7647996wmi.29.2020.04.29.06.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 06:21:46 -0700 (PDT)
Subject: Re: [PATCH RFC 3/6] KVM: x86: interrupt based APF page-ready event
 delivery
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-4-vkuznets@redhat.com>
 <546bb75a-ec00-f748-1f44-2b5299a3d3d7@redhat.com>
 <87ees6h3cm.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <15c625c5-d551-85fd-8412-f88503e6a86b@redhat.com>
Date:   Wed, 29 Apr 2020 15:21:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87ees6h3cm.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 14:40, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 29/04/20 11:36, Vitaly Kuznetsov wrote:
>>> +
>>> +	Type 1 page (page missing) events are currently always delivered as
>>> +	synthetic #PF exception. Type 2 (page ready) are either delivered
>>> +	by #PF exception (when bit 3 of MSR_KVM_ASYNC_PF_EN is clear) or
>>> +	via an APIC interrupt (when bit 3 set). APIC interrupt delivery is
>>> +	controlled by MSR_KVM_ASYNC_PF2.
>>
>> I think we should (in the non-RFC version) block async page faults
>> completely and only keep APF_HALT unless the guest is using page ready
>> interrupt delivery.
> 
> Sure, we can do that. This is, however, a significant behavioral change:
> APF_HALT frees the host, not the guest, so even if the combined
> performance of all guests on the same pCPU remain the same guests with
> e.g. a lot of simultaneously running processes may suffer more.

Yes, it is a significant change.  However the resulting clean up in the
spec is significant, because we don't have type 2 notifications at all
anymore.

(APF_HALT does free the guest a little bit by allowing interrupt
delivery during a host page fault; in particular it lets the scheduler
tick run, which does improve responsiveness somewhat significantly).

Likewise, I think we should clean up the guest side without prejudice.
Patch 6 should disable async page fault unless page-ready interrupts are
available, and drop the page ready case from the #PF handler.

Thanks,

Paolo

> In theory, we can keep two mechanisms side by side for as long as we
> want but if the end goal is to have '#PF abuse eliminated' than we'll
> have to get rid of the legacy one some day. The day when the new
> mechanism lands is also a good choice :-)


