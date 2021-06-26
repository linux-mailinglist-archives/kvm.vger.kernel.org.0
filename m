Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED08E3B4BA1
	for <lists+kvm@lfdr.de>; Sat, 26 Jun 2021 02:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhFZAiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 20:38:02 -0400
Received: from forward100o.mail.yandex.net ([37.140.190.180]:55473 "EHLO
        forward100o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229882AbhFZAiA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 20:38:00 -0400
X-Greylist: delayed 3598 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jun 2021 20:38:00 EDT
Received: from forward100q.mail.yandex.net (forward100q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb97])
        by forward100o.mail.yandex.net (Yandex) with ESMTP id 701E74AC18DF;
        Sat, 26 Jun 2021 03:35:37 +0300 (MSK)
Received: from vla1-68d3ce55e22b.qloud-c.yandex.net (vla1-68d3ce55e22b.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3385:0:640:68d3:ce55])
        by forward100q.mail.yandex.net (Yandex) with ESMTP id 6B80D7080005;
        Sat, 26 Jun 2021 03:35:37 +0300 (MSK)
Received: from vla5-8422ddc3185d.qloud-c.yandex.net (vla5-8422ddc3185d.qloud-c.yandex.net [2a02:6b8:c18:3495:0:640:8422:ddc3])
        by vla1-68d3ce55e22b.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 8bd620jTJ2-ZbHC7Nue;
        Sat, 26 Jun 2021 03:35:37 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624667737;
        bh=Ih9Uz/mRz6J5TvMvjRAUWGF1yy4MVvbwkLtZZvIroWg=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=vP6CrrhMu4woKEgT2ZaTPbVSifUl1wR+f52ei9/Git6+Q6JEEW8dJL9nO0ce8NcM8
         +yBX0g6I69MsHeg5UDQpCD3GYIC0w+p2gJlPxPKCPGM84qoTSNbgucPgYFDAKkzXZw
         MdgPVfkevnzeB1D3t3wAb/Ld4r+b0q5i1Dfp0ofM=
Authentication-Results: vla1-68d3ce55e22b.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla5-8422ddc3185d.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id Qf7rJLo07k-Za2WVIsI;
        Sat, 26 Jun 2021 03:35:36 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: exception vs SIGALRM race on core2 CPUs (with fix!)
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru>
 <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
 <4f40a6e8-07ce-ba12-b3e6-5975ad19a2ff@yandex.ru>
 <cbaa0b83-fc3a-5732-4246-386a0a0ff9b8@yandex.ru>
 <60ae8b9f-89af-e8b3-13c4-99ddea1ced90@yandex.ru>
 <19022e7d-e1f5-06b5-f059-27172ca50011@yandex.ru>
 <f09d851d-bda1-7a99-41cb-a14ea51e1237@yandex.ru>
 <CALMp9eQWKa1vL+jj5HXO1bm+oMo6gQLNw44P7y6ZaF8_WQfukw@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <039ede8e-83ef-134e-eb41-c06a04207187@yandex.ru>
Date:   Sat, 26 Jun 2021 03:35:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQWKa1vL+jj5HXO1bm+oMo6gQLNw44P7y6ZaF8_WQfukw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

26.06.2021 03:15, Jim Mattson пишет:
> On Fri, Jun 25, 2021 at 4:35 PM stsp <stsp2@yandex.ru> wrote:
>> OK, I've finally found that this
>> fixes the race:
>>
>> --- x86.c.old   2021-03-20 12:51:14.000000000 +0300
>> +++ x86.c       2021-06-26 02:28:37.082919492 +0300
>> @@ -9176,8 +9176,10 @@
>>                   if (__xfer_to_guest_mode_work_pending()) {
>>                           srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>>                           r = xfer_to_guest_mode_handle_work(vcpu);
>> -                       if (r)
>> +                       if (r) {
>> +kvm_clear_exception_queue(vcpu);
>>                                   return r;
>> +}
>>                           vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>>                   }
>>           }
>>
>>
>>
>> This is where it returns to user
>> with the PF exception still pending.
>> So... any ideas?
> If the squashed exception was a trap, it's now lost.

I am not saying this patch is
correct or should be applied.

The more interesting question is:
why KVM doesn't _inject_ the PF,
but is rather setting it pending
and then exits to user-space?

#0  kvm_multiple_exception (vcpu=vcpu@entry=0xffff888005934000, 
nr=nr@entry=14,
     has_error=has_error@entry=true, error_code=6, 
has_payload=has_payload@entry=true,
     payload=35979264, reinject=false) at ./include/linux/kvm_host.h:1280
#1  0xffffffff8103a13c in kvm_queue_exception_e_p (payload=<optimized out>,
     error_code=<optimized out>, nr=14, vcpu=0xffff888005934000) at 
arch/x86/kvm/x86.c:641
#2  kvm_inject_page_fault (vcpu=0xffff888005934000, fault=<optimized 
out>) at arch/x86/kvm/x86.c:641
#3  0xffffffff81031454 in kvm_inject_emulated_page_fault 
(vcpu=vcpu@entry=0xffff888005934000,
     fault=fault@entry=0xffffc9000031fc60) at arch/x86/kvm/x86.c:665
#4  0xffffffff8106df86 in paging32_page_fault (vcpu=0xffff888005934000, 
addr=35979264, error_code=6,
     prefault=<optimized out>) at arch/x86/kvm/mmu/paging_tmpl.h:816
#5  0xffffffff8106cdb4 in kvm_mmu_do_page_fault (prefault=false, err=6, 
cr2_or_gpa=35979264,
     vcpu=0xffff888005934000) at arch/x86/kvm/mmu.h:119
#6  kvm_mmu_page_fault (vcpu=vcpu@entry=0xffff888005934000, 
cr2_or_gpa=cr2_or_gpa@entry=35979264,
     error_code=error_code@entry=6, insn=0x0 <fixed_percpu_data>, 
insn_len=0)
     at arch/x86/kvm/mmu/mmu.c:5076
#7  0xffffffff8106d090 in kvm_handle_page_fault (insn_len=<optimized 
out>, insn=<optimized out>,
     fault_address=35979264, error_code=6, vcpu=0xffff888005934000) at 
arch/x86/kvm/mmu/mmu.c:3775
#8  kvm_handle_page_fault (vcpu=0xffff888005934000, error_code=6, 
fault_address=35979264,
     insn=<optimized out>, insn_len=<optimized out>) at 
arch/x86/kvm/mmu/mmu.c:3757
#9  0xffffffff810443e0 in vcpu_enter_guest (vcpu=0xffff888005934000) at 
arch/x86/kvm/x86.c:9090
#10 vcpu_run (vcpu=0xffff888005934000) at arch/x86/kvm/x86.c:9156
#11 kvm_arch_vcpu_ioctl_run (vcpu=vcpu@entry=0xffff888005934000) at 
arch/x86/kvm/x86.c:9385
#12 0xffffffff81020fec in kvm_vcpu_ioctl (filp=<optimized out>, 
ioctl=44672, arg=0)
     at arch/x86/kvm/../../../virt/kvm/kvm_main.c:3292


This is the stack trace when it
is set pending.

