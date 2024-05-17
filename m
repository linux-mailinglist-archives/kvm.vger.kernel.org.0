Return-Path: <kvm+bounces-17564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48DC28C7F9F
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 03:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6ABB283073
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 01:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 303A5523D;
	Fri, 17 May 2024 01:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pSsmxacn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A9E1392
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 01:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715910008; cv=none; b=Z6tS5g39C/BIW/CuCRFxJuqiNBv74duBl/vgHdodVzpZanwGN3b0lakPgY0O6aY5OW3e1L/xFv1Q7Rr67F81Ihydoqa9kxihx9BtG5PmsQTnZEr8+MOJCaoKPYM9bkGi2hUZsubSSTwJZ0Mupc0WGr0U52m543ip57F3GnX395c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715910008; c=relaxed/simple;
	bh=gCTz2KHRxk9Lid9kOmUCJFWxLsArWEGfrv+bbqNRGVw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RjQun8zntoM1OzzJFvbYSWLlBFeyavDe3iUoQpDcfZ1UeroLBatobFN9zy8ohjLKFxCz+LxV5Z9bSAK277Um5L3ZYsLX5tbT/KNS95l+JFRGW1K6YN+ganPLwdj+wPrOsR77Vh21BIf+6RqEbpnGNT1uSRciEnkMDQK++qxyF3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pSsmxacn; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6dbdcfd39so16427742276.2
        for <kvm@vger.kernel.org>; Thu, 16 May 2024 18:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715910004; x=1716514804; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xCUUcz0dlx0qy8AhJxyVJn5ww5rpLQFL6/SPYHSVvCo=;
        b=pSsmxacnyW1kXzfxN7IORp6u8m/8mrc1Niam70IQEwrjCOQ+bbphsYXNexRpyuNEGj
         u44SHxipRuwFYBw48EG7gC9gaKbsDE9h8EvVWTzwYPCGPk3dHuOMKQ38BZoemIFnd9lZ
         Z5J0Vu1ztmiF/9cxX1AoIcSD/+eUB4A+ET5iX45oq+neazfuyngjMs+MfoBc+wFAGUjh
         0w4zRMpt2aqF5Nl7ZSgOidFNHhkI/fN7lTrpZMn71FOb2ckjzuwjigxh6dHXSXgiRkeb
         4QkzT1PzPPBdAeYDNsjX8EzOKvmQghqaDgYOljRU9UpZjw2S3IN5HC3jJESCcX9bSYvI
         NqmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715910004; x=1716514804;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xCUUcz0dlx0qy8AhJxyVJn5ww5rpLQFL6/SPYHSVvCo=;
        b=Y9lv1sydVoFX2k11XM4t7+MN9RV5xe6N9Zak8jzYiWTv5GgtGjLEFEa/DC03ZCbCys
         IeGOsPSvqK4lhus4lwmMQByyiDpUU5MOWjP1TD+/832HyXVtOkABiM4CQQ1bYRFMNkfI
         Vlt6PLGD3RTnlc+7HPHmZT2xlBrnkOq/oUsPweGt+EOkgdBHhLjMvMe9yN5dJrjvkeFB
         z2xbXAfx9NfqH/lp5iipV0GhQCuYMrhuh/gqt/0/ssOEcjP+pibLxz9IkQjdOlRZCR/P
         S5ksuqoelNUj6FmU+ZXTz7ep1xpPUMoFGvZhL9UGWn3KBeihp4wggyzFr4GRvK/Lzi4S
         iNbg==
X-Forwarded-Encrypted: i=1; AJvYcCUkyjCJEbRwnNcaH8HI0XZ7vTeCt1qHteIqIRyeiZdXO0udovXAiGrYcqzOyh+6R2U9ech+BN0LEnVxwzezJL117clT
X-Gm-Message-State: AOJu0YxhIzfrKLYO8DC/ufQh/WHR9THhr8USUwjyoXOqoBcr3p+wdLib
	tUejhA/yK51+sU2RBbj2nHt2lY5i737HGW2gjijFelO/ADTwrQj7JYIwJbWPl0oTkqQkT6TLTmn
	3nA==
X-Google-Smtp-Source: AGHT+IEl5gCzCVONAyuuis71mk48HQ9DUuYNRPVF8c5oHKUS84P8VnkvbmtQsdgQWTsUOFMQAOjDKHNxHz8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a28c:0:b0:deb:88f1:7d48 with SMTP id
 3f1490d57ef6-dee4f363251mr5284925276.5.1715910004557; Thu, 16 May 2024
 18:40:04 -0700 (PDT)
Date: Thu, 16 May 2024 18:40:02 -0700
In-Reply-To: <ZkVHh49Hn8gB3_9o@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240507154459.3950778-1-pbonzini@redhat.com> <20240507154459.3950778-8-pbonzini@redhat.com>
 <ZkVHh49Hn8gB3_9o@google.com>
Message-ID: <Zka1cub00xu37mHP@google.com>
Subject: Re: [PATCH 7/7] KVM: VMX: Introduce test mode related to EPT
 violation VE
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 15, 2024, Sean Christopherson wrote:
> On Tue, May 07, 2024, Paolo Bonzini wrote:
> > @@ -5200,6 +5215,9 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
> >  	if (is_invalid_opcode(intr_info))
> >  		return handle_ud(vcpu);
> >  
> > +	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
> > +		return -EIO;
> 
> I've hit this three times now when running KVM-Unit-Tests (I'm pretty sure it's
> the EPT test, unsurprisingly).  And unless I screwed up my testing, I verified it
> still fires with Isaku's fix[*], though I'm suddenly having problems repro'ing.
> 
> I'll update tomorrow as to whether I botched my testing of Isaku's fix, or if
> there's another bug lurking.

*sigh*

AFAICT, I'm hitting a hardware issue.  The #VE occurs when the CPU does an A/D
assist on an entry in the L2's PML4 (L2 GPA 0x109fff8).  EPT A/D bits are disabled,
and KVM has write-protected the GPA (hooray for shadowing EPT entries).  The CPU
tries to write the PML4 entry to do the A/D assist and generates what appears to
be a spurious #VE.

Isaku, please forward this to the necessary folks at Intel.  I doubt whatever
is broken will block TDX, but it would be nice to get a root cause so we at least
know whether or not TDX is a ticking time bomb.

A branch with fixes (nested support for PROVE_VE is broken) and debug hooks can
be found here:

  https://github.com/sean-jc/linux vmx/prove_ve_fixes

The failing KUT is nVMX's ept_access_test_not_present.  It is 100% reproducible
on my system (in isolation and in sequence).

  ./x86/run x86/vmx.flat -smp 1 -cpu max,host-phys-bits,+vmx -m 2560 -append ept_access_test_not_present

I ruled out KVM TLB flushing bugs by doing a full INVEPT before every entry to L2.

I (more or less) ruled out KVM SPTE bugs by printing the failing translation
before every entry to L2, and adding KVM_MMU_WARN_ON() checks on the paths that
write SPTEs to assert that the SPTE value won't generate a #VE.

I ruled out a completely bogus EPT Violation by simply resuming the guest without
clearing the #VE info's busy field, and verifying by tracepoints that the same
EPT violation occurs (and gets fixed by KVM).

Unless I botched the SPTE printing, which doesn't seem to be the case as the
printed SPTEs match KVM's tracepoints, I'm out of ideas.

Basic system info:

  processor       : 1
  vendor_id       : GenuineIntel
  cpu family      : 6
  model           : 106
  model name      : Intel(R) Xeon(R) Platinum 8373C CPU @ 2.60GHz
  stepping        : 6
  microcode       : 0xd0003b9
  cpu MHz         : 2600.000
  cache size      : 55296 KB
  physical id     : 0
  siblings        : 72
  core id         : 1
  cpu cores       : 36
  address sizes   : 46 bits physical, 57 bits virtual

Relevant addresses printed from the test:

  PTE[4] @ 109fff8 = 9fed0007
  PTE[3] @ 9fed0ff0 = 9fed1007
  PTE[2] @ 9fed1000 = 9fed2007
  VA PTE @ 9fed2000 = 8000000007
  Created EPT @ 9feca008 = 11d2007
  Created EPT @ 11d2000 = 11d3007
  Created EPT @ 11d3000 = 11d4007
  L1 hva = 40000000, hpa = 40000000, L2 gva = ffffffff80000000, gpa = 8000000000

And the splat from KVM, with extra printing of the exploding translation, and a
dump of the VMCS.

  kvm: VM-Enter 109fff8, spte[4] = 0x8000000000000000
  kvm: VM-Enter 109fff8, spte[4] = 0x80100040becb6807, spte[3] = 0x80100040911ed807, spte[2] = 0x86100040f9e008f7
  kvm: VM-Enter 109fff8, spte[4] = 0x80100040becb6807, spte[3] = 0x80100040911ed807, spte[2] = 0x86100040f9e008f7
  kvm: VM-Enter 109fff8, spte[4] = 0x80100040becb6807, spte[3] = 0x80100040911ed807, spte[2] = 0x86100040f9e008f7
  kvm: VM-Enter 109fff8, spte[4] = 0x80100040becb6807, spte[3] = 0x80100040911ed807, spte[2] = 0x86100040f9e008f7
  kvm: VM-Enter 109fff8, spte[4] = 0x80100040becb6807, spte[3] = 0x80100040911ed807, spte[2] = 0x86100040f9e008f7
  kvm: VM-Enter 109fff8, spte[4] = 0x80100040becb6807, spte[3] = 0x80100040911ed807, spte[2] = 0x86100040f9e008f7
  kvm: VM-Enter 109fff8, spte[4] = 0x80100040becb6807, spte[3] = 0x80100040911ed807, spte[2] = 0x86100040f9e008f7
  kvm: VM-Enter 109fff8, spte[4] = 0x80100040becb6807, spte[3] = 0x80100040911ed807, spte[2] = 0x86100040f9e008f7
  kvm: VM-Enter 109fff8, spte[4] = 0x80100040becb6807, spte[3] = 0x80100040911ed807, spte[2] = 0x86100040f9e008f7
  kvm: VM-Enter 109fff8, spte[4] = 0x80100040becb6807, spte[3] = 0x80100040911ed807, spte[2] = 0x86100040f9e008f7
  kvm: VM-Enter 109fff8, spte[4] = 0x80100040becb6807, spte[3] = 0x80100040911ed807, spte[2] = 0x82100040f9e008f5

  ------------[ cut here ]------------
  WARNING: CPU: 93 PID: 16309 at arch/x86/kvm/vmx/vmx.c:5217 handle_exception_nmi+0x418/0x5d0 [kvm_intel]
  Modules linked in: kvm_intel kvm vfat fat dummy bridge stp llc spidev cdc_ncm cdc_eem cdc_ether usbnet mii xhci_pci xhci_hcd ehci_pci ehci_hcd gq(O) sha3_generic [last unloaded: kvm]
  CPU: 93 PID: 16309 Comm: qemu Tainted: G S      W  O       6.9.0-smp--317ea923d74d-vmenter #319
  Hardware name: Google Interlaken/interlaken, BIOS 0.20231025.0-0 10/25/2023
  RIP: 0010:handle_exception_nmi+0x418/0x5d0 [kvm_intel]
  Code: 48 89 75 c8 44 0f 79 75 c8 2e 0f 86 bf 01 00 00 48 89 df be 01 00 00 00 4c 89 fa e8 f2 78 ed ff b8 01 00 00 00 e9 74 ff ff ff <0f> 0b 4c 8b b3 b8 22 00 00 41 8b 36 83 fe 30 74 09 f6 05 5a ac 01
  RSP: 0018:ff3c22846acebb38 EFLAGS: 00010246
  RAX: 0000000000000001 RBX: ff3c2284dff2c580 RCX: ff3c22845cba9000
  RDX: 4813020000000002 RSI: 0000000000000000 RDI: ff3c2284dff2c580
  RBP: ff3c22846acebb70 R08: ff3c2284a3b3a180 R09: 0000000000000001
  R10: 0000000000000005 R11: ffffffffc0978d80 R12: 0000000080000300
  R13: 0000000000000000 R14: 0000000080000314 R15: 0000000080000314
  FS:  00007fc71fc006c0(0000) GS:ff3c22c2bf880000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 000000012c9fc005 CR4: 0000000000773ef0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  PKRU: 55555554
  Call Trace:
   <TASK>
   vmx_handle_exit+0x565/0x7e0 [kvm_intel]
   vcpu_run+0x188b/0x22b0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x358/0x680 [kvm]
   kvm_vcpu_ioctl+0x4ca/0x5b0 [kvm]
   __se_sys_ioctl+0x7b/0xd0
   __x64_sys_ioctl+0x21/0x30
   x64_sys_call+0x15ac/0x2e40
   do_syscall_64+0x85/0x160
   ? clear_bhb_loop+0x45/0xa0
   ? clear_bhb_loop+0x45/0xa0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7fc7c5e2bfbb
  Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
  RSP: 002b:00007fc71fbffbf0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007fc7c5e2bfbb
  RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000c
  RBP: 000055557d2ef5f0 R08: 00007fc7c600e1c8 R09: 00007fc7c67ab0b0
  R10: 0000000000000123 R11: 0000000000000246 R12: 0000000000000000
  R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
   </TASK>
  ---[ end trace 0000000000000000 ]---

  kvm_intel: VMCS 0000000034d8de8f, last attempted VM-entry on CPU 93
  kvm_intel: *** Guest State ***
  kvm_intel: CR0: actual=0x0000000080010031, shadow=0x0000000080010031, gh_mask=fffffffffffefff7
  kvm_intel: CR4: actual=0x0000000000002060, shadow=0x0000000000002020, gh_mask=fffffffffffef871
  kvm_intel: CR3 = 0x000000000109f000
  kvm_intel: PDPTR0 = 0x0000000000000000  PDPTR1 = 0x0000000000000000
  kvm_intel: PDPTR2 = 0x0000000000000000  PDPTR3 = 0x0000000000000000
  kvm_intel: RSP = 0x000000009fec6f20  RIP = 0x0000000000410d39
  kvm_intel: RFLAGS=0x00010097         DR7 = 0x0000000000000400
  kvm_intel: Sysenter RSP=000000009fec8000 CS:RIP=0008:00000000004001d8
  kvm_intel: CS:   sel=0x0008, attr=0x0a09b, limit=0xffffffff, base=0x0000000000000000
  kvm_intel: DS:   sel=0x0010, attr=0x0c093, limit=0xffffffff, base=0x0000000000000000
  kvm_intel: SS:   sel=0x0010, attr=0x0c093, limit=0xffffffff, base=0x0000000000000000
  kvm_intel: ES:   sel=0x0010, attr=0x0c093, limit=0xffffffff, base=0x0000000000000000
  kvm_intel: FS:   sel=0x0010, attr=0x0c093, limit=0xffffffff, base=0x0000000000000000
  kvm_intel: GS:   sel=0x0010, attr=0x0c093, limit=0xffffffff, base=0x00000000005390f0
  kvm_intel: GDTR:                           limit=0x0000106f, base=0x000000000042aee0
  kvm_intel: LDTR: sel=0x0000, attr=0x00082, limit=0x0000ffff, base=0x0000000000000000
  kvm_intel: IDTR:                           limit=0x00000fff, base=0x000000000054aa60
  kvm_intel: TR:   sel=0x0080, attr=0x0008b, limit=0x0000ffff, base=0x00000000005442c0
  kvm_intel: EFER= 0x0000000000000500
  kvm_intel: PAT = 0x0007040600070406
  kvm_intel: DebugCtl = 0x0000000000000000  DebugExceptions = 0x0000000000000000
  kvm_intel: Interruptibility = 00000000  ActivityState = 00000000
  kvm_intel: MSR guest autoload:
  kvm_intel:    0: msr=0x00000600 value=0x0000000000000000
  kvm_intel: *** Host State ***
  kvm_intel: RIP = 0xffffffffc098e6c0  RSP = 0xff3c22846aceba38
  kvm_intel: CS=0010 SS=0018 DS=0000 ES=0000 FS=0000 GS=0000 TR=0040
  kvm_intel: FSBase=00007fc71fc006c0 GSBase=ff3c22c2bf880000 TRBase=fffffe5926d88000
  kvm_intel: GDTBase=fffffe5926d86000 IDTBase=fffffe0000000000
  kvm_intel: CR0=0000000080050033 CR3=000000012c9fc005 CR4=0000000000773ef0
  kvm_intel: Sysenter RSP=fffffe5926d88000 CS:RIP=0010:ffffffffb7801fa0
  kvm_intel: EFER= 0x0000000000000d01
  kvm_intel: PAT = 0x0407050600070106
  kvm_intel: MSR host autoload:
  kvm_intel:    0: msr=0x00000600 value=0xfffffe5926da0000
  kvm_intel: *** Control State ***
  kvm_intel: CPUBased=0xa5986dfa SecondaryExec=0x02040462 TertiaryExec=0x0000000000000000
  kvm_intel: PinBased=0x0000007f EntryControls=0000d3ff ExitControls=002befff
  kvm_intel: ExceptionBitmap=00160042 PFECmask=00000000 PFECmatch=00000000
  kvm_intel: VMEntry: intr_info=00000000 errcode=00000000 ilen=00000000
  kvm_intel: VMExit: intr_info=80000314 errcode=0000fff8 ilen=00000003
  kvm_intel:         reason=00000000 qualification=0000000000000000
  kvm_intel: IDTVectoring: info=00000000 errcode=00000000
  kvm_intel: TSC Offset = 0xffcd4eeccb7b3279
  kvm_intel: TSC Multiplier = 0x0001000000000000
  kvm_intel: EPT pointer = 0x0000000114fd601e
  kvm_intel: PLE Gap=00000000 Window=00000000
  kvm_intel: Virtual processor ID = 0x0001
  kvm_intel: VE info address = 0x0000000135a04000
  kvm_intel: ve_info: 0x00000030 0xffffffff 0x00000000000006ab 0xffffffff80000000 0x000000000109fff8 0x0000

  kvm: #VE 109fff8, spte[4] = 0x8010000136b61807, spte[3] = 0x8010000136b60807, spte[2] = 0x82100001950008f5
  kvm: VM-Enter 109fff8, spte[4] = 0x8010000136b61807, spte[3] = 0x8010000136b60807, spte[2] = 0x82100001950008f5
  kvm: VM-Enter 109fff8, spte[4] = 0x8010000136b61807, spte[3] = 0x8010000136b60807, spte[2] = 0x80100001b5790807, spte[1] = 0x861000019509f877

