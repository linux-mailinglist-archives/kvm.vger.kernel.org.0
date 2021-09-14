Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD1A40AAC0
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 11:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhINJZ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 05:25:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230103AbhINJZ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 05:25:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631611479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6eUT5aaraqAWkuE8C9hQZ8wEwgwIbUTUok3BPR1VmCk=;
        b=Ik+ETu6B2BpHO3wOf2F7J2KABefBimfPqZ7h/kVvLV8Jy6XeWLYR0tRf6lF2mWa6+yqcLV
        LG2hH1uvjo7JbiJoPlO4a2fVeLEVz3PurGVbaCkN0XVqCKR6qiz/IPWb4qFLQ6jWskE+T0
        s1PBqJv4M6bC/fxoiUJR43ie33UGZHM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-rRCy8O9JNkODh4vP9MJmtw-1; Tue, 14 Sep 2021 05:24:38 -0400
X-MC-Unique: rRCy8O9JNkODh4vP9MJmtw-1
Received: by mail-ed1-f70.google.com with SMTP id z6-20020a50cd06000000b003d2c2e38f1fso1610859edi.1
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 02:24:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6eUT5aaraqAWkuE8C9hQZ8wEwgwIbUTUok3BPR1VmCk=;
        b=Jam01pNnSxRW+TNetoGIYNZav3ZOhvVl6UXvdcqLYvGjbDrwTtJzqytHnDjriyGnK2
         VIEhKDb+w804d6YfHwvx2ZsQ2JTYTpSRmzyKz7VS9MYaLV6cnXWWLq8NiAHfPwZkQIbb
         hJCfiNK0UnM9PJCBKQ9KEzeZeOZBVMUO/aKn4bGJ03/X0fLm+zkM9Uzbwc2v3aylPe1L
         7z6lxn1ZM4fgBdSlVyjIv11JsseoVK53iCCKuZYLOTm/WaWqKNIxcfAso17RFWRZUfum
         pGGXiFWJBXRetoUpeaOKhKdCzLQQ6NxuLfO1I4rla7hWoJi8RzX2OuxTDwGxGJRYX9qX
         Siew==
X-Gm-Message-State: AOAM532t8lP4EarZfWmLGbmN2RC7xvaRU+MjTlXR6+1t6yMAFGMbFqQQ
        b34Gco2QzrrOWV+l1ffwQDQsapjtDMdMB3TM0EliYWcXosVxAh5/18dsDBDxVSj3a4vfLPuC6TS
        5AvwFZQlCXQmT
X-Received: by 2002:a17:906:3ce2:: with SMTP id d2mr17979063ejh.410.1631611477066;
        Tue, 14 Sep 2021 02:24:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJPtSEC6E3buj4o2YiBULsC0xfeCeTqpctyx2iTAATorSkT5ah2J8mPCLmx7GtLJxDJ5YfkA==
X-Received: by 2002:a17:906:3ce2:: with SMTP id d2mr17979048ejh.410.1631611476892;
        Tue, 14 Sep 2021 02:24:36 -0700 (PDT)
Received: from localhost.localdomain ([2a04:ee41:4:31cb:e591:1e1e:abde:a8f1])
        by smtp.gmail.com with ESMTPSA id q19sm5263011edc.74.2021.09.14.02.24.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 02:24:36 -0700 (PDT)
Subject: Re: [RFC PATCH 3/3] nSVM: use svm->nested.save to load vmcb12
 registers and avoid TOC/TOU races
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20210903102039.55422-1-eesposit@redhat.com>
 <20210903102039.55422-4-eesposit@redhat.com>
 <21d2bf8c4e3eb3fc5d297fd13300557ec686b625.camel@redhat.com>
 <73b5a5bb-48f2-3a08-c76b-a82b5b69c406@redhat.com>
 <9585f1387b2581d30b74cd163a9aac2adbd37a93.camel@redhat.com>
 <2b1e17416cef1e37f42e9bc8b2283b03d2651cb2.camel@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <ee207b0c-eab3-13ba-44be-999f849008d2@redhat.com>
Date:   Tue, 14 Sep 2021 11:24:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2b1e17416cef1e37f42e9bc8b2283b03d2651cb2.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14/09/2021 11:12, Maxim Levitsky wrote:
> On Tue, 2021-09-14 at 12:02 +0300, Maxim Levitsky wrote:
>> On Tue, 2021-09-14 at 10:20 +0200, Emanuele Giuseppe Esposito wrote:
>>> On 12/09/2021 12:42, Maxim Levitsky wrote:
>>>>>    
>>>>> -	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
>>>>> +	if (!nested_vmcb_valid_sregs(vcpu, &svm->nested.save) ||
>>>>>    	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
>>>> If you use a different struct for the copied fields, then it makes
>>>> sense IMHO to drop the 'control' parameter from nested_vmcb_check_controls,
>>>> and just use the svm->nested.save there directly.
>>>>
>>>
>>> Ok, what you say in patch 2 makes sense to me. I can create a new struct
>>> vmcb_save_area_cached, but I need to keep nested.ctl because 1) it is
>>> used also elsewhere, and different fields from the one checked here are
>>> read/set and 2) using another structure (or the same
>>
>> Yes, keep nested.ctl, since vast majority of the fields are copied I think.
> 
> But actually that you mention it, I'll say why not to create vmcb_control_area_cached
> as well indeed and change the type of svm->nested.save to it. (in a separate patch)
> 
> I see what you mean that we modify it a bit (but we shoudn't to be honest) and such, but
> all of this can be fixed.

So basically you are proposing:

struct svm_nested_state {
	...
	struct vmcb_control_area ctl; // we need this because it is used 
everywhere, I think
	struct vmcb_control_area_cached ctl_cached;
	struct vmcb_save_area_cached save_cached;
	...
}

and then

if (!nested_vmcb_valid_sregs(vcpu, &svm->nested.save_cached) ||
     !nested_vmcb_check_controls(vcpu, &svm->nested.ctl_cached)) {

like that?

Or do you want to delete nested.ctl completely and just keep the fields 
actually used in ctl_cached?

Also, note that as I am trying to use vmcb_save_area_cached, it is worth 
noticing that nested_vmcb_valid_sregs() is also used in 
svm_set_nested_state(), so it requires some additional little changes.

Thank you,
Emanuele

> 
> The advantage of having vmcb_control_area_cached is that it becomes impossible to use
> by mistake a non copied field from the guest.
> 
> It would also emphasize that this stuff came from the guest and should be treated as
> a toxic waste.
> 
> Note again that this should be done if we agree as a separate patch.
> 
>>
>> Best regards,
>> 	Maxim Levitsky
>>
>>
>>> vmcb_save_area_cached) in its place would just duplicate the same fields
>>> of nested.ctl, creating even more confusion and possible inconsistency.
>>>
>>> Let me know if you disagree.
>>>
>>> Thank you,
>>> Emanuele
>>>
> 
> 

