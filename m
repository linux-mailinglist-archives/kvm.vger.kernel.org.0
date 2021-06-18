Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396923ACFA3
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 18:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhFRQEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 12:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhFRQEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 12:04:37 -0400
X-Greylist: delayed 146 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Jun 2021 09:02:27 PDT
Received: from forward105o.mail.yandex.net (forward105o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE64CC061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 09:02:27 -0700 (PDT)
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward105o.mail.yandex.net (Yandex) with ESMTP id 6DAF5420179C;
        Fri, 18 Jun 2021 18:59:56 +0300 (MSK)
Received: from vla5-44c540c3c576.qloud-c.yandex.net (vla5-44c540c3c576.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3412:0:640:44c5:40c3])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id 69CD2CF40023;
        Fri, 18 Jun 2021 18:59:56 +0300 (MSK)
Received: from vla5-47b3f4751bc4.qloud-c.yandex.net (vla5-47b3f4751bc4.qloud-c.yandex.net [2a02:6b8:c18:3508:0:640:47b3:f475])
        by vla5-44c540c3c576.qloud-c.yandex.net (mxback/Yandex) with ESMTP id ymvwkAhkOw-xuHegVw4;
        Fri, 18 Jun 2021 18:59:56 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624031996;
        bh=GMbb5vcIOnFslYVJos4unsZhvxVTq7jezD4LYC4PMUY=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=FhL06STh8QuOUxlW3+yXkVCRlZAJjVhTiDoXGtyCpzZJQ/fxahy5FfJFVdTJeRoJT
         g2E4Vshkj/c/uY3EmuCOxM31NhTl9d4QbPARbei5/XOSTekvX9xxkRPxQw5u8ETdJm
         AYph5AESop17/gtGVK9S1n9tULaqRE5sXaqy7vxQ=
Authentication-Results: vla5-44c540c3c576.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla5-47b3f4751bc4.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 3mFUfc6Qq2-xt3mR7QH;
        Fri, 18 Jun 2021 18:59:56 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: guest/host mem out of sync on core2duo?
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
Date:   Fri, 18 Jun 2021 18:59:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YMtfQHGJL7XP/0Rq@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

17.06.2021 17:42, Sean Christopherson пишет:
> On Mon, Jun 14, 2021, stsp wrote:
>
>> Wow, excellent shot!  Indeed, the problem then starts reproducing also there!
>> So at least I now have a problematic setup myself, rather than needing to ask
>> for ssh from everyone involved. :)
>>
>> What does this mean to us, though?  That its completely unrelated to any
>> memory synchronization?
> Yes, more than likely this has nothing to do with memory synchronization.

But this still has something to
do with LDT I suppose. Because
before the guest app switches
to prot mode, nothing bad happens.


>>>> I tried to analyze when either of the above happens exactly, and I have a
>>>> very strong suspection that the problem is in a way I update LDT. LDT is
>>>> shared between guest and host with KVM_SET_USER_MEMORY_REGION, and I modify
>>>> it on host.  So it seems like if I just allocated the new LDT entry, there is
>>>> a risk of invalid guest state, as if the guest's LDT still doesn't have it.
>>>> If I modified some LDT entry, there can be a page fault in guest, as if the
>>>> entry is still old.
>>> IIUC, you are updating the LDT itself, e.g. an FS/GS descriptor in the LDT, as
>>> opposed to updating the LDT descriptor in the GDT?
>> I am updating the LDT itself, not modifying its descriptor in gdt. And with
>> the same KVM_SET_SREGS call I also update the segregs to the new values, if
>> needed.
> Hmm, unconditionally calling KVM_SET_SREGS if you modify anything in the LDT
> would be worth trying.  Or did I misunderstand the "if needed" part?

I mean, the registers are modified
only when there is a reason to, for
example I need to inject the interrupt
and call the guest's interrupt handler
by hands. But I did the "unconditional"
test already (and repeated it now) and
indeed it makes the crash reproducible
100%, with only invalid guest state.
Which is very good to debug, indeed.
I am not sure if you want to reproduce
the bug locally or not. Of course it
would be great if you do. :)

For that I pushed this change:
https://github.com/dosemu2/dosemu2/commit/3d83a866c5f04e8902cd653474e03c60e5bdc108
which makes KVM_SET_SREGS to
be called with different regs always.
This is achieved by ignoring the fact
that we stopped in a ring0 monitor,
and always setting up the ring3 context.
It still works on the AMD cpu or with
unrestricted guest on I7.
So... if you really like to replicate the
setup, you will need to first install
dosemu2 from a binary package, to
get the dependencies right. Dealing
with its deps by hands, usually leads
nowhere, so here is the list of distros
for which there are packages:
https://github.com/dosemu2/dosemu2/blob/devel/README

So after installing it from package
and getting deps in, you would need
to uninstall it and build from git, to
get the reproducer patch in (branch
kvm_bug). "make deb" or "make rpm"
can be useful for finding the build-time
deps, but usually

./default-configure -d

is enough (-d means debug build).


>>> Either way, do you also update all relevant segments via KVM_SET_SREGS after
>>> modifying memory?
>> Yes, if this is needed.  Sometimes its not needed, and when not - it seems
>> page fault is more likely. If I also update segregs - then invalid guest
>> state.  But these are just the statistical guesses so far.
> Ah.  Hrm.  It would still be worth doing KVM_SET_SREGS unconditionally, e.g. it
> would narrow the search if the page faults go away and the failures are always
> invalid guest state.

This is what happened indeed, yes.


>>> Anyways, I highly doubt this is a memory synchronization issue, a corner case
>>> related to lack of unrestricted guest is much more likely.
>> Just to be sure I tried the CD bit in CR0 to rule out the caching issues, and
>> that changes nothing.  So...
>>
>> What to do next?
> In addition to the above experiment, can you get a state dump for the invalid
> guest state failure?  I.e. load kvm_intel with dump_invalid_vmcs=1.

It appears I can dynamically modify
the module params via sysfs, so I
didn't even need to reload the kvm_intel.

Dynamic modification seems to work
well with dump_invalid_vmcs but not
with unrestricted_guest, where I still
need to reload the module to change
the param.


>    And on that
> failure, also provide the input to KVM_SET_SREGS.

Here it goes.
But I studied it quite thoroughly
and can't see anything obviously
wrong.


[7011807.029737] *** Guest State ***
[7011807.029742] CR0: actual=0x0000000080000031, 
shadow=0x00000000e0000031, gh_mask=fffffffffffffff7
[7011807.029743] CR4: actual=0x0000000000002041, 
shadow=0x0000000000000001, gh_mask=ffffffffffffe871
[7011807.029744] CR3 = 0x000000000a709000
[7011807.029745] RSP = 0x000000000000eff0  RIP = 0x000000000000017c
[7011807.029746] RFLAGS=0x00080202         DR7 = 0x0000000000000400
[7011807.029747] Sysenter RSP=0000000000000000 CS:RIP=0000:0000000000000000
[7011807.029749] CS:   sel=0x0097, attr=0x040fb, limit=0x000001a0, 
base=0x0000000002110000
[7011807.029751] DS:   sel=0x00f7, attr=0x0c0f2, limit=0xffffffff, 
base=0x0000000000000000
[7011807.029752] SS:   sel=0x009f, attr=0x040f3, limit=0x0000efff, 
base=0x0000000002111000
[7011807.029753] ES:   sel=0x00f7, attr=0x0c0f2, limit=0xffffffff, 
base=0x0000000000000000
[7011807.029764] FS:   sel=0x0000, attr=0x10000, limit=0x00000000, 
base=0x0000000000000000
[7011807.029765] GS:   sel=0x0000, attr=0x10000, limit=0x00000000, 
base=0x0000000000000000
[7011807.029767] GDTR:                           limit=0x00000017, 
base=0x000000000a708100
[7011807.029768] LDTR: sel=0x0010, attr=0x00082, limit=0x0000ffff, 
base=0x000000000ab0a000
[7011807.029769] IDTR:                           limit=0x000007ff, 
base=0x000000000a708200
[7011807.029770] TR:   sel=0x0010, attr=0x0008b, limit=0x00002088, 
base=0x000000000a706000
[7011807.029771] EFER =     0x0000000000000000  PAT = 0x0007040600070406
[7011807.029772] DebugCtl = 0x0000000000000000  DebugExceptions = 
0x0000000000000000
[7011807.029783] Interruptibility = 00000000  ActivityState = 00000000
[7011807.029784] *** Host State ***
[7011807.029785] RIP = 0xffffffffc12525b0  RSP = 0xffffbc831306fc68
[7011807.029787] CS=0010 SS=0018 DS=0000 ES=0000 FS=0000 GS=0000 TR=0040
[7011807.029788] FSBase=00007ffff70a7780 GSBase=ffff968085b40000 
TRBase=fffffe0000102000
[7011807.029789] GDTBase=fffffe0000100000 IDTBase=fffffe0000000000
[7011807.029790] CR0=0000000080050033 CR3=00000004c0642001 
CR4=00000000001626e0
[7011807.029791] Sysenter RSP=fffffe0000102000 CS:RIP=0010:ffffffffbd001720
[7011807.029792] EFER = 0x0000000000000d01  PAT = 0x0407050600070106
[7011807.029793] *** Control State ***
[7011807.029794] PinBased=0000007f CPUBased=b5986dfa SecondaryExec=00002c6a
[7011807.029795] EntryControls=0000d1ff ExitControls=002befff
[7011807.029796] ExceptionBitmap=00060042 PFECmask=00000000 
PFECmatch=00000000
[7011807.029797] VMEntry: intr_info=000004e6 errcode=00000000 ilen=00000002
[7011807.029798] VMExit: intr_info=00000000 errcode=00000000 ilen=00000001
[7011807.029799]         reason=80000021 qualification=0000000000000000
[7011807.029800] IDTVectoring: info=00000000 errcode=00000000
[7011807.029801] TSC Offset = 0xffa686ee1681acf4
[7011807.029802] EPT pointer = 0x00000005fcec605e
[7011807.029803] PLE Gap=00000080 Window=00001000
[7011807.029803] Virtual processor ID = 0x0001


gp regs dump:

(gdb) p /x *regs
$2 = {ebx = 0xff, ecx = 0x1, edx = 0x7bf, esi = 0x772, edi = 0x6e,
   ebp = 0x91e, eax = 0x10001, __null_ds = 0xf7, __null_es = 0xf7,
   __null_fs = 0x0, __null_gs = 0x0, orig_eax = 0xd0000, eip = 0x17c,
   cs = 0x97, __csh = 0x0, eflags = 0x80202, esp = 0xeff0, ss = 0x9f,
   __ssh = 0x0, es = 0xc93d, __esh = 0x0, ds = 0xc53c, __dsh = 0x0, fs = 
0x0,
   __fsh = 0x0, gs = 0x0, __gsh = 0x0}


sregs dump:

(gdb) p /x sregs
$3 = {cs = {base = 0x2110000, limit = 0x1a0, selector = 0x97, type = 0xb,
     present = 0x1, dpl = 0x3, db = 0x1, s = 0x1, l = 0x0, g = 0x0, avl 
= 0x0,
     unusable = 0x0, padding = 0x0}, ds = {base = 0x0, limit = 0xffffffff,
     selector = 0xf7, type = 0x2, present = 0x1, dpl = 0x3, db = 0x1, s 
= 0x1,
     l = 0x0, g = 0x1, avl = 0x0, unusable = 0x0, padding = 0x0}, es = {
     base = 0x0, limit = 0xffffffff, selector = 0xf7, type = 0x2,
     present = 0x1, dpl = 0x3, db = 0x1, s = 0x1, l = 0x0, g = 0x1, avl 
= 0x0,
     unusable = 0x0, padding = 0x0}, fs = {base = 0x0, limit = 0x0,
     selector = 0x0, type = 0x0, present = 0x0, dpl = 0x0, db = 0x0, s = 
0x0,
     l = 0x0, g = 0x0, avl = 0x0, unusable = 0x1, padding = 0x0}, gs = {
     base = 0x0, limit = 0x0, selector = 0x0, type = 0x0, present = 0x0,
     dpl = 0x0, db = 0x0, s = 0x0, l = 0x0, g = 0x0, avl = 0x0, unusable 
= 0x1,
     padding = 0x0}, ss = {base = 0x2111000, limit = 0xefff, selector = 
0x9f,
     type = 0x3, present = 0x1, dpl = 0x3, db = 0x1, s = 0x1, l = 0x0, g 
= 0x0,
     avl = 0x0, unusable = 0x0, padding = 0x0}, tr = {base = 0xa706000,
     limit = 0x2088, selector = 0x10, type = 0xb, present = 0x1, dpl = 0x0,
     db = 0x0, s = 0x0, l = 0x0, g = 0x0, avl = 0x0, unusable = 0x0,
     padding = 0x0}, ldt = {base = 0xab0a000, limit = 0xffff, selector = 
0x10,
     type = 0x2, present = 0x1, dpl = 0x0, db = 0x0, s = 0x0, l = 0x0, g 
= 0x0,
     avl = 0x0, unusable = 0x0, padding = 0x0}, gdt = {base = 0xa708100,
     limit = 0x17, padding = {0x0, 0x0, 0x0}}, idt = {base = 0xa708200,
     limit = 0x7ff, padding = {0x0, 0x0, 0x0}}, cr0 = 0xe0000031, cr2 = 
0x0,
   cr3 = 0xa709000, cr4 = 0x1, cr8 = 0x0, efer = 0x0, apic_base = 
0xfee00900,
   interrupt_bitmap = {0x0, 0x0, 0x0, 0x0}}

> Best case scenario is that KVM_SET_SREGS stuffs invalid guest state that KVM
> doesn't correct detect.  That would be easy to debug and fix, and would give us
> a regression test as well.

OK, let me know how can we
progress towards that point. :)

