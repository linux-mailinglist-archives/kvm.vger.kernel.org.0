Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1AB62C8BD2
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 18:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387861AbgK3RzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 12:55:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729370AbgK3RzO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 12:55:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606758828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gi4Rht/ELTnFAZIunHo+toOTUWTBXEGXm5AWopX3S1M=;
        b=W62WWk1nFL06H8WfpvwDAkAaE61mXJcvFTHqHY/Cm9mvhQvNHNvm0QGmL4EvxFQiN84BPV
        G3L37cTJFHDtlHZWyHJoHnOgD0VkQ85F/eY1ieNRYzMPtdoDl5Ve6ne3gP9+bCdU8TZRLO
        fA+DOI9MvlVFevBbERTSBB9UxnH6McY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-Q64NB_2pNnq-ZYDMveWQnA-1; Mon, 30 Nov 2020 12:53:45 -0500
X-MC-Unique: Q64NB_2pNnq-ZYDMveWQnA-1
Received: by mail-ed1-f69.google.com with SMTP id g8so7167257edm.7
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 09:53:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gi4Rht/ELTnFAZIunHo+toOTUWTBXEGXm5AWopX3S1M=;
        b=mCg963ThJ4TAroIliMxg+juNdNONAn3wbqAptfqDe6aTRysbNG7otQWOQ815JXh21d
         UvqDVolflGlRCO/uFhMlYdvf85jbQ3187KLIOgtysIML8WFK+ni6FOiZ7cUXViOBp6Tb
         AcjC6t9mUuG7DKJLYWHWUrhMZYrvcBmipE5yTsTOeokLxG9pjKrKf/jBhkxCLhXyLxS3
         TM1mhQMLSK8DUV7lejVCplyLsOcz5HafxNo3Y7NaOGATqfB6/jpDoh8ZQ/LuqkD74HVr
         Lj4ADqcP+dsPuEi7mQN7UDgumP04ZgUnOZ1jrSpDVkxhfWdCEUFvsywBAfEcCNb64Az1
         f32Q==
X-Gm-Message-State: AOAM533wK1tnIovzwsPfjtLHAVC7y2FJHtCtWxtGEauqVkETKDVkGyl0
        Mi+qlYPdB32GMug9atmoe6RZXWy2H2+7pDxLrjlIVGkVMqhJ4lsByqvf2k5oaJKsbIaR69DvakB
        VMA+rziCieiGO
X-Received: by 2002:a17:907:d01:: with SMTP id gn1mr22075291ejc.357.1606758823760;
        Mon, 30 Nov 2020 09:53:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwPXCLLq0F7NsxdGneoiL0swBKFgNHMjS0gZzWEdxb5xTK81UZfS/uvqb99Yq+sqLin3REwrQ==
X-Received: by 2002:a17:907:d01:: with SMTP id gn1mr22075268ejc.357.1606758823492;
        Mon, 30 Nov 2020 09:53:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m2sm6847080edf.27.2020.11.30.09.53.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 09:53:42 -0800 (PST)
Subject: Re: [PATCH] kvm/x86/mmu: use the correct inherited permissions to get
 shadow page
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@qumranet.com>, linux-doc@vger.kernel.org
References: <20201120095517.19211-1-jiangshanlai@gmail.com>
 <20201126000549.GC450871@google.com>
 <0724aeb9-3466-5505-8f12-a5899144e68f@redhat.com>
 <CAJhGHyApvmQk4bxxK2rJKzyAShFSXyEb2W0qyFcVoUEcsMKs_w@mail.gmail.com>
 <X8Uux62rJdf2feJ2@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7a9d3517-7bcc-723a-5ec5-80018d0850d7@redhat.com>
Date:   Mon, 30 Nov 2020 18:53:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X8Uux62rJdf2feJ2@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/11/20 18:41, Sean Christopherson wrote:
>>
>> pmd1 and pmd2 point to the same pte table, so:
>> ptr1 and ptr3 points to the same page.
>> ptr2 and ptr4 points to the same page.
>>
>>    The guess read-accesses to ptr1 first. So the hypervisor gets the
>> shadow pte page table with role.access=u-- among other things.
>>     (Note the shadowed pmd1's access is uwx)
>>
>>    And then the guest write-accesses to ptr2, and the hypervisor
>> set up shadow page for ptr2.
>>     (Note the hypervisor silencely accepts the role.access=u--
>>      shadow pte page table in FNAME(fetch))
>>
>>    After that, the guess read-accesses to ptr3, the hypervisor
>> reused the same shadow pte page table as above.
>>
>>    At last, the guest writes to ptr4 without vmexit nor pagefault,
>> Which should cause vmexit as the guest expects.
>
> Hmm, yes, KVM would incorrectly handle this scenario.  But, the proposed patch
> would not address the issue as KVM always maps non-leaf shadow pages with full
> access permissions.

Can we have a testcase in kvm-unit-tests?  It's okay of course if it 
only fails with ept=0.

Paolo

