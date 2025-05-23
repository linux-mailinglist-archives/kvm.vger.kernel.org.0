Return-Path: <kvm+bounces-47602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B70DDAC27FC
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 18:57:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1B277ADC26
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 16:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2673C293479;
	Fri, 23 May 2025 16:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aC0XGSlh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50C5221547
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748019457; cv=none; b=VAdKvy2p/O5c6yK1e/rKBZPgxFM/6QIQ0LilGDJdfI5VQNKhS1zFARtV9shN/ZxciDy1j61nlB6JIZv9yPW/XL3RqtgS2ZgJj52+pcLd9KPkyOtHzmlbdEBg5A37z9vB6dpL2gQw0YS73D+jPi3aWkfG5roBV7RgJUPhMrzQz0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748019457; c=relaxed/simple;
	bh=dzcmhlnVKKdWYCIX3XHmBq2cR+Pxheb4XJE7tjG3Mno=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U8lBrVIK34q68Rh1hESKsfd4fZk/+gcVW5JexXENZNv4aDWDLRkMBLeWYnWtAWbanSgaCe1PIxAZmXhqNiNgQ5hEiyWzPYMhqSLLUzWBpbG/0ChAmOuegOcf43nObGFWeIrNVsl9E+hw/1rnXveFXHgDKPf/WASjgdkSLmYWOho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aC0XGSlh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3108d5123c4so101675a91.1
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 09:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748019455; x=1748624255; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tg6VPPI8kv2xdiChglqqkBYvwi/LLRExk2X0fxJWCgo=;
        b=aC0XGSlhtWE2p1SBXcUFqTBIyEslxhQbxhTbqWc65pgs9ngy2N5CFaQ5RkOOsnDP/+
         mDWcX5s+uh+L0rG6AWTeu05j9k5dCygdfkFSqoc5XLrwEn6aXTCbcYtBJnS4SETq1WZ0
         iMRxncMW71rCsyjCSrIQMh/zYAq085UBCWbCGt9K4ZksUqrrsLd+heFJUvIzEi2xzePe
         Xe86gBkTyVUYwp5HzOlyaEgd+ctSeJ0edMqTBS5e3EeNJKeAhWSHwQGXLSA5Bj6flSI6
         yRlKXE0LHcChR0BUw1y6Hyu5pUNQnPqwYhUwIsJJZJwCZRuK0sAc5kHqovtbLfhXk0DC
         JwoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748019455; x=1748624255;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tg6VPPI8kv2xdiChglqqkBYvwi/LLRExk2X0fxJWCgo=;
        b=pYBYq+BvJSa8F0Q6LTILadeEuvbB92nKKasGZlpr16CYA4XrjXfQSwVa98yfNdXOog
         1tcmIMJAEO7YxJXyJTpR9U+a4+wNK02XRzNkr3mFb6R28wYVfwqf2tKB1Z9X8+qbMpU2
         3oSVwCcLBDRXpWI3ca5arke2ef54AO2M/uUhbVvp7lgZZSROLDdHp//9Pb0a+sfKxDvQ
         6KJ1gQ6D6+VpGK+Rzxl/GylEd89N5QnBkHlkZUjl0FCih5PzQfNac7p3BjWr3nXnxx47
         OY17dsSiwE2dICZG1YKZ8ASyVRCm370rbuJ9fLF/ynXYgb2WaxqYm8dDFj2GylnIYnQl
         Dqzw==
X-Forwarded-Encrypted: i=1; AJvYcCVn8Fy4tQPoSkVAA9GgmnItedVcgaZ3cOKMDu6ho6sv8GBmrzXy9SDGWvU52B6KEInnq5M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr8szBxasNd5ne8K59oC8DeqedP5WnmuFfdHO4YCGxwReSj3Cb
	140NeaGLd+2tEYxKvjBTPjMVWA6g/Rfj/xEvprTUWiuFWRfoozaYd7FMjRnl/D8j+8KIzWD8X77
	p8aqmcQ==
X-Google-Smtp-Source: AGHT+IEHfCYOjZsuRb/M8TPESis6ZI0dnDFaK77moTYHdMcRaVyF428KvmMqQTyXTjdclRuzgfc1Xfc0P2U=
X-Received: from pjb6.prod.google.com ([2002:a17:90b:2f06:b0:2f8:49ad:406c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:528d:b0:2fa:15ab:4de7
 with SMTP id 98e67ed59e1d1-30e830ebd92mr52401611a91.12.1748019454866; Fri, 23
 May 2025 09:57:34 -0700 (PDT)
Date: Fri, 23 May 2025 09:57:33 -0700
In-Reply-To: <20250522151031.426788-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522151031.426788-1-chao.gao@intel.com>
Message-ID: <aDCo_SczQOUaB2rS@google.com>
Subject: Re: [PATCH v8 0/6] Introduce CET supervisor state support
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	tglx@linutronix.de, dave.hansen@intel.com, pbonzini@redhat.com, 
	peterz@infradead.org, rick.p.edgecombe@intel.com, weijiang.yang@intel.com, 
	john.allen@amd.com, bp@alien8.de, chang.seok.bae@intel.com, xin3.li@intel.com, 
	Dave Hansen <dave.hansen@linux.intel.com>, Eric Biggers <ebiggers@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <kees@kernel.org>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Mitchell Levy <levymitchell0@gmail.com>, 
	Nikolay Borisov <nik.borisov@suse.com>, Oleg Nesterov <oleg@redhat.com>, 
	Sohil Mehta <sohil.mehta@intel.com>, Stanislav Spassov <stanspas@amazon.de>, 
	Vignesh Balasubramanian <vigbalas@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 22, 2025, Chao Gao wrote:
> Chao Gao (4):
>   x86/fpu/xstate: Differentiate default features for host and guest FPUs
>   x86/fpu: Initialize guest FPU permissions from guest defaults
>   x86/fpu: Initialize guest fpstate and FPU pseudo container from guest
>     defaults
>   x86/fpu: Remove xfd argument from __fpstate_reset()
> 
> Yang Weijiang (2):
>   x86/fpu/xstate: Introduce "guest-only" supervisor xfeature set
>   x86/fpu/xstate: Add CET supervisor xfeature support as a guest-only
>     feature

Acked-by: Sean Christopherson <seanjc@google.com>

Side topic, and *probably* unrelated to this series, I tripped the following
WARN when running it through the KVM tests (though I don't think it has anything
to do with KVM?).  The WARN is the version of xfd_validate_state() that's guarded
by CONFIG_X86_DEBUG_FPU=y.

   WARNING: CPU: 232 PID: 15391 at arch/x86/kernel/fpu/xstate.c:1543 xfd_validate_state+0x65/0x70
   Modules linked in: kvm_intel kvm irqbypass vfat fat dummy bridge stp llc intel_vsec cdc_acm cdc_ncm cdc_eem cdc_ether usbnet mii xhci_pci xhci_hcd ehci_pci ehci_hcd [last unloaded: kvm_intel]
   CPU: 232 UID: 0 PID: 15391 Comm: DefaultEventMan Tainted: G S                  6.15.0-smp--3542d5d75b5c-cet #678 NONE 
   Tainted: [S]=CPU_OUT_OF_SPEC
   Hardware name: Google Izumi-EMR/izumi, BIOS 0.20240807.2-0 10/09/2024
   RIP: 0010:xfd_validate_state+0x65/0x70
   Code: 10 4c 3b 60 18 74 23 49 81 fe 80 c4 45 ab 74 15 4d 0b 7e 08 49 f7 d7 49 85 df 75 0e 5b 41 5c 41 5e 41 5f 5d c3 40 84 ed 75 f2 <0f> 0b eb ee 0f 1f 80 00 00 00 00 66 0f 1f 00 0f 1f 44 00 00 48 89
   RSP: 0018:ff7ada85584a3e08 EFLAGS: 00010246
   RAX: ff2c5d2908a53940 RBX: 00000000000e00ff RCX: ff2c5d2908a53940
   RDX: 0000000000000001 RSI: 00000000000e00ff RDI: ff2c5d2908a521c0
   RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
   R10: ffffffffaa56fa4d R11: 0000000000000000 R12: 0000000000040000
   R13: ff2c5d2908a521c0 R14: ffffffffab45c480 R15: 0000000000000000
   FS:  00007f21084d6700(0000) GS:ff2c5da752b41000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 0000000000000000 CR3: 00000001ca832006 CR4: 0000000000f73ef0
   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
   PKRU: 00000000
   Call Trace:
    <TASK>
    fpu__clear_user_states+0x9c/0x100
    arch_do_signal_or_restart+0x142/0x210
    exit_to_user_mode_loop+0x55/0x100
    do_syscall_64+0x205/0x2c0
    entry_SYSCALL_64_after_hwframe+0x4b/0x53
   RIP: 0033:0x55ad185f2ee0
   Code: 8c fc 48 8d 0d 6e d5 8e fc 4c 8d 05 64 cb 78 fc bf 03 00 00 00 ba 25 03 00 00 49 89 c1 31 c0 e8 e6 2e 08 00 cc cc cc cc cc cc <55> 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 28 49 89 d7 49 89
   RSP: 002b:00007f21084d3e38 EFLAGS: 00000246 ORIG_RAX: 00000000000001b9
   RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000055ad18136f73
   RDX: 00007f21084d3e40 RSI: 00007f21084d3f70 RDI: 000000000000001b
   RBP: 00007f21084d4f90 R08: 0000000000000000 R09: 0000000000000000
   R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
   R13: 000011f03fbc2f00 R14: ffffffffffffffff R15: 0000000000000000
    </TASK>
   irq event stamp: 368
   hardirqs last  enabled at (367): [<ffffffffaaf5f1b8>] _raw_write_unlock_irq+0x28/0x40
   hardirqs last disabled at (368): [<ffffffffaaf5487d>] __schedule+0x1bd/0xea0
   softirqs last  enabled at (0): [<ffffffffaa2aa1ca>] copy_process+0x38a/0x1350
   softirqs last disabled at (0): [<0000000000000000>] 0x0
   ---[ end trace 0000000000000000 ]---

But I've hit the WARN once before, so whatever is going on is pre-existing.  I
haven't done any experiments to see if the WARN fires more frequently with this
series.  I mentioned it here purely out of convenience.

  ------------[ cut here ]------------
  WARNING: CPU: 77 PID: 14821 at arch/x86/kernel/fpu/xstate.c:1466 xfd_validate_state+0x4a/0x50
  Modules linked in: kvm_intel kvm irqbypass vfat fat dummy bridge stp llc intel_vsec cdc_acm cdc_ncm cdc_eem cdc_ether usbnet mii xhci_pci xhci_hcd ehci_pci ehci_hcd sr_mod cdrom loop [last unloaded: kvm]
  CPU: 77 UID: 0 PID: 14821 Comm: futex-default-S Tainted: G S      W           6.15.0-smp--a2104d5ba341-sink #605 NONE 
  Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
  Hardware name: Google Izumi-EMR/izumi, BIOS 0.20240807.2-0 10/09/2024
  RIP: 0010:xfd_validate_state+0x4a/0x50
  Code: 50 0a a9 4d 8b 80 90 17 00 00 49 3b 48 18 74 1a 48 81 ff 80 a4 65 a7 74 0d 48 0b 47 08 48 f7 d0 48 85 f0 75 05 c3 84 d2 75 fb <0f> 0b c3 0f 1f 00 66 0f 1f 00 0f 1f 44 00 00 48 89 f8 48 8b 7f 10
  RSP: 0018:ff1ba89ef124fe58 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffffffffa644871e RCX: 0000000000040000
  RDX: 0000000000000001 RSI: 00000000000600ff RDI: ffffffffa765a480
  RBP: 0000000000000000 R08: ff137abd4db65bc0 R09: 0000000000000000
  R10: ffffffffa6775f8d R11: 0000000000000000 R12: 0000000000000000
  R13: 0000000000000000 R14: ff137abd4db65b80 R15: 0000000000000000
  FS:  00007fea8bce7700(0000) GS:ff137afc151b3000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 00000001a87c0004 CR4: 0000000000f73ef0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
  PKRU: 00000000
  Call Trace:
   <TASK>
   fpu__clear_user_states+0x92/0xf0
   arch_do_signal_or_restart+0x134/0x200
   syscall_exit_to_user_mode+0x8a/0x110
   do_syscall_64+0x8b/0x160
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x563afb5588c0
  Code: f0 e9 df fc ff ff 48 8b 5d 88 4d 89 f0 e9 b5 fe ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <55> 48 89 e5 41 57 41 56 41 55 41 54 53 50 49 89 d7 e8 0a 6f f2 01
  RSP: 002b:00007fea8bce4e78 EFLAGS: 00000202 ORIG_RAX: 00000000000000e8
  RAX: 0000000000000000 RBX: 000011fcd50a6dd0 RCX: 0000563af84d6b30
  RDX: 00007fea8bce4e80 RSI: 00007fea8bce4fb0 RDI: 000000000000001e
  RBP: 00007fea8bce5c30 R08: 0000000000000000 R09: 00007fea8bce6ca0
  R10: 00000000000007d0 R11: 0000000000000202 R12: 0000000063239328
  R13: 00000000680b9c83 R14: 00000000000007d0 R15: 000011fcd5c46150
   </TASK>
  irq event stamp: 496018
  hardirqs last  enabled at (496017): [<ffffffffa7158965>] _raw_spin_unlock_irqrestore+0x35/0x50
  hardirqs last disabled at (496018): [<ffffffffa714e6fd>] __schedule+0x1bd/0xe90
  softirqs last  enabled at (495074): [<ffffffffa64c02ec>] __irq_exit_rcu+0x6c/0x130
  softirqs last disabled at (495065): [<ffffffffa64c02ec>] __irq_exit_rcu+0x6c/0x130
  ---[ end trace 0000000000000000 ]---

