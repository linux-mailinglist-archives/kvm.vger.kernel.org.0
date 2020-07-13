Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE40021DAD9
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 17:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgGMPy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 11:54:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43369 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729027AbgGMPy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 11:54:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594655697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c4HkFhEtHUd4HflwBh60DMnTvo0/5vgOKgf0NAOSu2Q=;
        b=iba9h+bfhStZOx1rlFOSfi8tp+8Yzp5dIv/jPje8GhFUcbgk61/xupx5XAUrYBao7zpIWH
        f4RHp//8dTf461aHnMc7L+dNFIgy4Olw9BlmZTISBnixdTxB/PtLlAyCS/5RxiGFSJgiZa
        OSCmWUc7JV5/kfHy7WSU06AtfXXUl0c=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-hpUq9S91PhmgJkqsINvX-w-1; Mon, 13 Jul 2020 11:54:55 -0400
X-MC-Unique: hpUq9S91PhmgJkqsINvX-w-1
Received: by mail-ed1-f71.google.com with SMTP id y66so21361455ede.19
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 08:54:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=c4HkFhEtHUd4HflwBh60DMnTvo0/5vgOKgf0NAOSu2Q=;
        b=TYhNu7rX4yAAtDgZa0a0Gggo1b4TkMUdyMT9vEQOHKzS2X7oCx31BhuNxnsw34t1ON
         yB37ZRzo7kyfP0W1u1Q6OivGxP/LeIqgRphqtIM14kbvYIVhbX4YCjRF+yhwlObAZMVR
         kLXrnA1J9oaB2V+XVqSzKdoO8jlU0HLLjRpZgU6rPXfSFmDTmqhOGDD8QRXDkuWdKaqh
         9JvqGj7uV91shByAyYEKcLFqWSylMlvqGzBKodZjFWzu1/WVUppsGxeDL+6zF/ObVdrr
         CKWAac4Y+jowjikCDWrqm82HJ7pLwIp7MN7KwC5pA5Fe0oooMD3sR7VbSBqNsAitFR/E
         dO5Q==
X-Gm-Message-State: AOAM53208O+AO8vi0I2cakfXPHKeD+Ac0Szk/eWJ3wTVzibqUmbu58zg
        CAX/v95zfWECTErYpaLoDWiq0S3/6l4Pi9dYHXRHaFA9NCRNXDwpzPEWUlsNLbHOImt9SrTcIHO
        bB2gwKf4j/NEb
X-Received: by 2002:a05:6402:706:: with SMTP id w6mr65691edx.326.1594655694267;
        Mon, 13 Jul 2020 08:54:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznVVkXb8tZQBC8cUiPuWf5rzFbZC7jNTHiR2OBCPWlvuAADZEY+tKdQhcJDKWq866mlZGEww==
X-Received: by 2002:a05:6402:706:: with SMTP id w6mr65681edx.326.1594655694076;
        Mon, 13 Jul 2020 08:54:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l22sm10021336ejr.98.2020.07.13.08.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 08:54:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: properly pad struct kvm_vmx_nested_state_hdr
In-Reply-To: <20200713151750.GA29901@linux.intel.com>
References: <20200713082824.1728868-1-vkuznets@redhat.com> <20200713151750.GA29901@linux.intel.com>
Date:   Mon, 13 Jul 2020 17:54:52 +0200
Message-ID: <878sfntnoz.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, Jul 13, 2020 at 10:28:24AM +0200, Vitaly Kuznetsov wrote:
>> Holes in structs which are userspace ABI are undesireable.
>> 
>> Fixes: 83d31e5271ac ("KVM: nVMX: fixes for preemption timer migration")
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  Documentation/virt/kvm/api.rst  | 2 +-
>>  arch/x86/include/uapi/asm/kvm.h | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 320788f81a05..7beccda11978 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -4345,7 +4345,7 @@ Errors:
>>  	struct {
>>  		__u16 flags;
>>  	} smm;
>> -
>> +	__u16 pad;
>
> I don't think this is sufficient.  Before 83d31e5271ac, the struct was:
>

Before 850448f35aaf. Thanks, I was too lazy to check that.

> 	struct kvm_vmx_nested_state_hdr {
> 		__u64 vmxon_pa;
> 		__u64 vmcs12_pa;
>
> 		struct {
> 			__u16 flags;
> 		} smm;
> 	};
>
> which most/all compilers will pad out to 24 bytes on a 64-bit system.  And
> although smm.flags is padded to 8 bytes, it's initialized as a 2 byte value.
>
> 714             struct kvm_vmx_nested_state_hdr boo;
> 715             u64 val;
> 716
> 717             BUILD_BUG_ON(sizeof(boo) != 3*8);
> 718             boo.smm.flags = 0;
>    0xffffffff810148a9 <+41>:    xor    %eax,%eax
>    0xffffffff810148ab <+43>:    mov    %ax,0x18(%rsp)
>
> 719
> 720             val = *((volatile u64 *)(&boo.smm.flags));
>    0xffffffff810148b0 <+48>:    mov    0x18(%rsp),%rax
>
>
> Which means that userspace built for the old kernel will potentially send in
> garbage for the new 'flags' field due to it being uninitialized stack data,
> even with the layout after this patch.
>
> 	struct kvm_vmx_nested_state_hdr {
> 		__u64 vmxon_pa;
> 		__u64 vmcs12_pa;
>
> 		struct {
> 			__u16 flags;
> 		} smm;
> 		__u16 pad;
> 		__u32 flags;
> 		__u64 preemption_timer_deadline;
> 	};
>
> So to be backwards compatible I believe we need to add a __u32 pad as well,
> and to not cause internal padding issues, either make the new 'flags' a
> __u64 or pad that as well (or add and check a reserved __32).  Making flags
> a __64 seems like the least wasteful approach, e.g.
>
> 	struct kvm_vmx_nested_state_hdr {
> 		__u64 vmxon_pa;
> 		__u64 vmcs12_pa;
>
> 		struct {
> 			__u16 flags;
> 		} smm;
> 		__u16 pad16;
> 		__u32 pad32;
> 		__u64 flags;
> 		__u64 preemption_timer_deadline;
> 	};

I see and I agree but the fix like that needs to get into 5.8 or an ABI
breakage is guaranteed. I'll send v2 immediately, hope Paolo will take a
look.

>
>
>>  	__u32 flags;
>>  	__u64 preemption_timer_deadline;
>>    };
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index 0780f97c1850..aae3df1cbd01 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -414,7 +414,7 @@ struct kvm_vmx_nested_state_hdr {
>>  	struct {
>>  		__u16 flags;
>>  	} smm;
>> -
>> +	__u16 pad;
>>  	__u32 flags;
>>  	__u64 preemption_timer_deadline;
>>  };
>> -- 
>> 2.25.4
>> 
>

-- 
Vitaly

