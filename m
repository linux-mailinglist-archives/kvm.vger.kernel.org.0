Return-Path: <kvm+bounces-35725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2DD0A148FC
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 05:55:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2762188CB6F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 04:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B311B25A638;
	Fri, 17 Jan 2025 04:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IJ01yhzg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF5925A63D;
	Fri, 17 Jan 2025 04:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737089692; cv=none; b=ocfWN0+Pht5r9cflJ9pqX+oMMyxIv92xLFVcWRwfGqE+LD3kpCl/47NxtST9ZmOfoetWC19j+H1Fubi8eh3UPyOIiJp6Jw57npplu+w04tnnUZLVf2Ep7w1ozcZshS1fiScsn30JZ7NVu54y/yumkCDbx8FhjewRo+4nNFa8zCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737089692; c=relaxed/simple;
	bh=I63x7I4Ol/kG4EZ6dbHIfZcgn0SPKDl12VyK3mQhQVM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=izdyO8jLPVWL19oTSv8Ebjf1tToGt8hh82QTl2A8ZP7n3FBl+MbG028AxhwlqjUkATuJNVlJtUXlv/Oj+n3fE140yiD0bb2C2JHG1y5bDrq8Jq6JQPAiRoeKn5oYH1A334c2t4X0+gB2iwfq+uofdglMbof8/0A9qUbFPvsL9tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IJ01yhzg; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d3bdccba49so2916959a12.1;
        Thu, 16 Jan 2025 20:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737089689; x=1737694489; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DUxSH4RG7W4A6HNQ3Oe1GOvRAjl1PmU8ezkbbKLuQVM=;
        b=IJ01yhzgY8Nyn39XFVooY3R+XIoAuKEYFcY8YgSps3TLQK5xJVSfD0QHND8Xdy26fZ
         izShfdLnNCn2HzZSTsSSi+vMlNb4FbhHHEw4xggF9LzBkWBjcwfyLcX5mf9JsDZ8r39+
         qiU+2QZwshomv4aYACyYeR/MdQLQu5ADpLECQSx7tmlpmT1ZwnKEZM5K1lT8+v5QktBr
         NsgXcj6g/W9L1rH3xfGOTZnXLI0W/eMPn7BKqYBc+u4BeSKZhBekjP2yY88AAfuliE1t
         jexKl45rtX7ZlBivLcUJunwM8UyKffEptIivSleNvBS0CJNQH+/anE+SkfyLYiRRgAGN
         gP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737089689; x=1737694489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DUxSH4RG7W4A6HNQ3Oe1GOvRAjl1PmU8ezkbbKLuQVM=;
        b=ERmEwzLQbW+ZOqVSK1KQtaCGRfuxipl4F/2VtslV5zZ6xbz6fuvM6FgitnkOw7V2cD
         9IDgNMhXx7d7EyYZUNPpIb1rVYd98Lw4BZE60ZSbJlc3oaINQkjmRXFmXvaILflbrtPd
         HHxiJ2jycCtOCg2Gb/L8alo3juloETm7ECU8ZWF5eJQYAPVNpjR+V3BG/KUxSy1h5JMf
         Y6dqgKe0aVruTUahUXSVI1Jw7kdkD6A4zKXF2frOQY1yxZV8cv/VtHfigP7F+NUGqF4l
         437yGs3XpnnzU9Ivyn7tOghRi5IEWCzpbASi9phODVvGSUveUD9vsYnQxX4H1qIbUAYv
         cNSg==
X-Forwarded-Encrypted: i=1; AJvYcCWm6+IJx0KPo+wQksgoM27dM9pkLz9gWr6707bd2HRk3MW4llcSwM9lGjXmwbVnA/irkxOnapcha7zJqec7@vger.kernel.org, AJvYcCXMyIKycohf+XyI9eabt9nFJuZcCkkCpwWwnABhODN4Al4wvL1VNpxT26KGs8J3N3KeIFM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8g6GIjoNvTUjnDXI3jzr3QmzpukkeafXP8cHwZienbD6YHhAH
	KieDBmPy2k/f8nf0PgK5KqEhB1rcMTUcJzngD4yDVbuUKBL6Fl/q1kgc97FZq1CWIgoytLkg9GJ
	JTRt2/JJTu9eAVdvvXlkVJsrwCwM=
X-Gm-Gg: ASbGncvw/cIrwKGfLVabeLx0wJz5+6v3I0HWKRHD2qevae9SnjAObPUey0dfI6fC2LP
	Gk31fkjouVfOXxPEckamgAk6evc7lEqEhjs2ohS5k1KFYK0aGPDlMT8fOwRBWizQYG8Ij6pM=
X-Google-Smtp-Source: AGHT+IFktXP/8WH4I4TUWs/FsMtmzATH2LuQHry9QKXzHMsp6LOhwa3VXaeTTs3BzR6+pwLXpuNnry4phcGJVNi88ok=
X-Received: by 2002:a17:906:cec6:b0:ab3:85eb:377b with SMTP id
 a640c23a62f3a-ab38b4c6c1emr117549766b.53.1737089688785; Thu, 16 Jan 2025
 20:54:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFtZq1FwJOtxmbf_NPgYP_ZH=PkXJfF0=cXo0xbGkT5TGv66-A@mail.gmail.com>
 <CAHk-=whnVemumt5AJ1f=rsGdLz4Fk95nZfoBchGmMWCGG63foQ@mail.gmail.com>
 <CAFtZq1FpLfbnJzqc_s=j9TBLyGxe9D_ZYZU2qiES5dgsBAWv+g@mail.gmail.com>
 <2025011646-chariot-revision-5753@gregkh> <E5C85B8E-D8F8-408F-B00B-A3650C9320EA@gmail.com>
 <Z4kkuaY_mJ6z0sa2@google.com>
In-Reply-To: <Z4kkuaY_mJ6z0sa2@google.com>
From: C CHI <chichen241@gmail.com>
Date: Fri, 17 Jan 2025 12:54:38 +0800
X-Gm-Features: AbW1kvblF5C-RCxc3JELDB4EQegdMuk_-JiQxHEs781okGaU2ofwL-qcCYgPhaI
Message-ID: <CAFtZq1F1x5+pXjgUvy=iDMZgY2mPyW+Rq6DKtfD+Msw=-nBaZw@mail.gmail.com>
Subject: Re: Potential Denial-of-Service Vulnerability in KVM When Emulating
 'hlt' Instruction in L2 Guests
To: Sean Christopherson <seanjc@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	"security@kernel.org" <security@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I roughly understand the above content. The main reason for this
phenomenon seems to be the chaotic VM memory layout caused by the
syzkaller template settings. In fact, it=E2=80=99s even observable that the
IDT region in the code doesn=E2=80=99t actually contain any exception handl=
ing
code, very amusing :)


Additionally, I would like to ask about the previously mentioned point
where the IDT is set in the emulated MMIO space. How can I verify
this, and where can I find the relevant code for setting the MMIO
region?


    The guest loops because the the guest's IDT is located in emulated
MMIO space,
    and as suspected above, KVM refuses to emulates HLT for L2.


Also, I'm curious as to what technique is used to get the following
type of logging information, and I'd like to be able to get each ENTRY
and EXIT info on the run




    repro-1289    [019] d....   140.314684: kvm_exit: vcpu 0 reason
EXCEPTION_NMI rip 0x1 info1 0x0000000000004000 info2
0x0000000000000000 intr_info 0x80000301 error_code 0x00000000
    repro-1289    [019] .....   140.314685: kvm_nested_vmexit: vcpu 0
reason EXCEPTION_NMI rip 0x1 info1 0x0000000000004000 info2
0x0000000000000000 intr_info 0x80000301 error_code 0x00000000
    repro-1289    [019] .....   140.314688: kvm_inj_exception: #DB
    repro-1289    [019] d....   140.314688: kvm_entry: vcpu 0, rip 0x1
    repro-1289    [019] d....   140.314704: kvm_exit: vcpu 0 reason
EPT_VIOLATION rip 0x1 info1 0x0000000000000181 info2
0x0000000080000301 intr_info 0x00000000 error_code 0x00000000
    repro-1289    [019] .....   140.314706: kvm_nested_vmexit: vcpu 0
reason EPT_VIOLATION rip 0x1 info1 0x0000000000000181 info2
0x0000000080000301 intr_info 0x00000000 error_code 0x00000000
    repro-1289    [019] .....   140.314706: kvm_page_fault: vcpu 0 rip
0x1 address 0x0000000000001050 error_code 0x181
    repro-1289    [019] .....   140.314708: kvm_inj_exception: #DB [reinjec=
ted]
    repro-1289    [019] d....   140.314709: kvm_entry: vcpu 0, rip 0x1


Sean Christopherson <seanjc@google.com> =E4=BA=8E2025=E5=B9=B41=E6=9C=8816=
=E6=97=A5=E5=91=A8=E5=9B=9B 23:24=E5=86=99=E9=81=93=EF=BC=9A
>
> +KVM and LKML to for archival, as this is not a DoS
>
> On Thu, Jan 16, 2025, chichen241 wrote:
> > It seems that the attachment content is not convenient for you to see, =
so I
> > will reuse the email content to describe it.
>
> ...
>
> > syz_kvm_setup_cpu(/*fd=3D*/vmfd, /*cpufd=3D*/vcpufd, /*usermem=3D*/mem,
> > /*text=3D*/&nop_text, /*ntext*/ 1,/*flags=3D*/-1, /*opts=3D*/opts, /*no=
pt=3D*/1); //
> > The nested vm will run '\x90\xf4', the vm will try to emulate the hlt
> > instruction and fail, entry endless loop.  ioctl(vcpufd, KVM_RUN, NULL)=
;
> > printf("The front kvm_run will caught in loop. This code will not be
> > executed") } ```
> > linux kernel version: 6.12-rc7
> > Also I checked my mailbox and didn't see any quesiton from Sean. Maybe =
there's some mistake?
>
> For posterity:
>
>   > > virtualization. When an L2 guest attempts to emulate an instruction
>
>   How did you coerce KVM into emulating HLT from L2?
>
>   > > using the x86_emulate_instruction() function, and the instruction t=
o
>   > > be emulated is hlt, the x86_decode_emulated_instruction() function
>   > > used for instruction decoding does not support parsing the hlt
>   > > instruction.
>
>   KVM should parse HLT just fine, I suspect the issue is that KVM _intent=
ionally_
>   refuses to emulate HLT from L2, because encountering HLT in the emulato=
r when L2
>   is active either requires the guest to be playing TLB games (e.g. gener=
ate an
>   emulated MMIO exit on a MOV, patch the MOV into a HLT), or it requires =
enabling
>   an off-by-default, "for testing purposes only" KVM module param.
>
>   > > As a result, x86_decode_emulated_instruction() returns
>   > > ctxt->execute as null, causing the L2 guest to fail to execute the =
hlt
>   > > instruction properly. Subsequently, KVM enters an infinite loop,
>
>   Define "infinite loop", i.e. what are the bounds of the loop?  If the "=
loop" is
>   KVM re-entering the guest on the same instruction over and over, then e=
verything
>   is working as intended.
>
>   > > repeatedly invoking x86_emulate_instruction() to perform the same
>   > > operation. This issue does not occur when the instruction to be
>   > > emulated by L2 is another standard instruction.
>   > >
>   > > Therefore, I am wondering whether this constitutes a denial-of-serv=
ice
>   > > (DoS) vulnerability and whether a CVE number can be assigned.
>
>   Unless your reproducer causes a hard hang in KVM, or prevents L1 from g=
aining
>   control from L2, e.g. via a (virtual) interrupt, this is not a DoS.  I =
can imagine
>   scenarios where L2 can put itself into an infinite loop, i.e. DoS itsel=
f, but
>   that's not a vulnerability in any reasonable sense of things.
>
>   > > Generally, for software emulation in L1 guests, KVM's
>   > > x86_emulate_instruction() function will, after parsing the instruct=
ion
>   > > with x86_decode_emulated_instruction(), attempt to use
>   > > retry_instruction() to retry instruction execution.
>
>   No, retry_instruction() is specifically for cases where KVM fails to em=
ulate an
>   instruction _and_ the emulation was triggered by a write to guest PTE t=
hat KVM
>   is shadowing, i.e. a guest page that KVM has made read-only.  If certai=
n criteria
>   were met, KVM will unprotect the page, i.e. make it writable again, and=
 resume
>   the guest to let the CPU retry the instruction.
>
> > ## DESCRIPTION in this file, the most code is from
> > syzkaller(executor/common_kvm_amd64.h), I mainly call the `syz_kvm_setu=
p_cpu`
> > function and run the vm using ioctl `kvm_run`.  First I use
> > `syz_kvm_setup_cpu` to setup the vm to run a nested vm.  The second tim=
e the
> > `syz_kvm_setup_cpu` will turn on the TF bit in the eflag register of th=
e
> > nested vm and let the nested vm run `nop;hlt` code.
> > When running kvm_run, the code will begin looping.
> > ## ANALYSE
> > The nested vm try to emulate the `hlt` code but failed, it will always =
try, caught in an endless loop.
>
> The guest loops because the the guest's IDT is located in emulated MMIO s=
pace,
> and as suspected above, KVM refuses to emulates HLT for L2.
>
> The single-step #DB induced by RFLAGS.TF=3D1 triggers an EPT Violation as=
 a result
> of the CPU trying to vector the #DB with the IDT residing in non-existent=
 memory.
> At this point KVM *should* kick out to host userspace, as userspace is re=
sponsible
> for dealing with the emulate MMIO access during exception vectoring.
>
>            repro-1289    [019] d....   140.314684: kvm_exit: vcpu 0 reaso=
n EXCEPTION_NMI rip 0x1 info1 0x0000000000004000 info2 0x0000000000000000 i=
ntr_info 0x80000301 error_code 0x00000000
>            repro-1289    [019] .....   140.314685: kvm_nested_vmexit: vcp=
u 0 reason EXCEPTION_NMI rip 0x1 info1 0x0000000000004000 info2 0x000000000=
0000000 intr_info 0x80000301 error_code 0x00000000
>            repro-1289    [019] .....   140.314688: kvm_inj_exception: #DB
>            repro-1289    [019] d....   140.314688: kvm_entry: vcpu 0, rip=
 0x1
>            repro-1289    [019] d....   140.314704: kvm_exit: vcpu 0 reaso=
n EPT_VIOLATION rip 0x1 info1 0x0000000000000181 info2 0x0000000080000301 i=
ntr_info 0x00000000 error_code 0x00000000
>            repro-1289    [019] .....   140.314706: kvm_nested_vmexit: vcp=
u 0 reason EPT_VIOLATION rip 0x1 info1 0x0000000000000181 info2 0x000000008=
0000301 intr_info 0x00000000 error_code 0x00000000
>            repro-1289    [019] .....   140.314706: kvm_page_fault: vcpu 0=
 rip 0x1 address 0x0000000000001050 error_code 0x181
>            repro-1289    [019] .....   140.314708: kvm_inj_exception: #DB=
 [reinjected]
>            repro-1289    [019] d....   140.314709: kvm_entry: vcpu 0, rip=
 0x1
>
> KVM misses the weird edge case, and instead ends up trying to emulate the
> instruction at the current RIP.  That instruction happens to be HLT, whic=
h KVM
> doesn't support for L2 (nested guests), and so KVM injects #UD.
>
>            repro-1289    [019] d....   140.314732: kvm_exit: vcpu 0 reaso=
n EPT_VIOLATION rip 0x1 info1 0x00000000000001aa info2 0x0000000080000301 i=
ntr_info 0x00000000 error_code 0x00000000
>            repro-1289    [019] .....   140.314749: kvm_emulate_insn: 0:1:=
f4 (prot32)
>            repro-1289    [019] .....   140.314751: kvm_emulate_insn: 0:1:=
f4 (prot32) failed
>            repro-1289    [019] .....   140.314752: kvm_inj_exception: #UD
>
> Vectoring the #UD suffers the same fate as the #DB, and so KVM unintentio=
nally
> puts the vCPU into an endless loop.
>
>            repro-1289    [019] d....   140.314767: kvm_exit: vcpu 0 reaso=
n EPT_VIOLATION rip 0x1 info1 0x00000000000001aa info2 0x0000000080000306 i=
ntr_info 0x00000000 error_code 0x00000000
>            repro-1289    [019] .....   140.314767: kvm_nested_vmexit: vcp=
u 0 reason EPT_VIOLATION rip 0x1 info1 0x00000000000001aa info2 0x000000008=
0000306 intr_info 0x00000000 error_code 0x00000000
>            repro-1289    [019] .....   140.314768: kvm_page_fault: vcpu 0=
 rip 0x1 address 0x0000000000000f78 error_code 0x1aa
>            repro-1289    [019] .....   140.314778: kvm_emulate_insn: 0:1:=
f4 (prot32)
>            repro-1289    [019] .....   140.314779: kvm_emulate_insn: 0:1:=
f4 (prot32) failed
>
> > ## QUESTION
> > The phenomenon is due to the kvm's emulate function can't emulate all t=
he
> > instructions.
>
> No, the issue is that KVM doesn't detect a weird edge case where the *gue=
st* has
> messed up, and instead of effectively terminating the VM, KVM puts it int=
o an
> infinite loop of sorts.
>
> Amusingly, this edge case was just "fixed" for both VMX and SVM[*] (expec=
ted to
> to land in v6.14).  In quotes because "fixing" the problem really means k=
illing
> the VM instead of letting it loop.
>
>   [1/7] KVM: x86: Add function for vectoring error generation
>         https://github.com/kvm-x86/linux/commit/11c98fa07a79
>   [2/7] KVM: x86: Add emulation status for unhandleable vectoring
>         https://github.com/kvm-x86/linux/commit/5c9cfc486636
>   [3/7] KVM: x86: Unprotect & retry before unhandleable vectoring check
>         https://github.com/kvm-x86/linux/commit/704fc6021b9e
>   [4/7] KVM: VMX: Handle vectoring error in check_emulate_instruction
>         https://github.com/kvm-x86/linux/commit/47ef3ef843c0
>   [5/7] KVM: SVM: Handle vectoring error in check_emulate_instruction
>         https://github.com/kvm-x86/linux/commit/7bd7ff99110a
>   [6/7] selftests: KVM: extract lidt into helper function
>         https://github.com/kvm-x86/linux/commit/4e9427aeb957
>   [7/7] selftests: KVM: Add test case for MMIO during vectoring
>         https://github.com/kvm-x86/linux/commit/62e41f6b4f36
>
> [*] https://lore.kernel.org/all/173457555486.3295983.11848882309599168611=
.b4-ty@google.com

