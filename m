Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC4D4A8D2
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 19:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbfFRRwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 13:52:08 -0400
Received: from mail.skyhub.de ([5.9.137.197]:53524 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbfFRRwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 13:52:08 -0400
Received: from zn.tnic (p200300EC2F07D60019BABA83A299EA47.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:d600:19ba:ba83:a299:ea47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8C4FA1EC0A4A;
        Tue, 18 Jun 2019 19:52:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1560880326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Zu5kcTvwYq6sgobl1omYrIQbVIX8kFpsqelDoNtcAAs=;
        b=n+7YRrbez/0fyTiVaYknbuJKssG4cBsQIrJkUFQAKvX5/LdT2G3QRKVd1DtOFpuwpHPoL3
        7cZPxRA82LaTia+EJe2j8tQs2BLWkUdW8vMO+Z5EYWYrdFccgdh6irlx825wtZ/FRx011C
        YQGdhKTFjwFpSqYX2choKt9ruV6Sjm0=
Date:   Tue, 18 Jun 2019 19:51:53 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        joro@8bytes.org, pbonzini@redhat.com, mingo@redhat.com,
        hpa@zytor.com, kvm@vger.kernel.org, syzkaller@googlegroups.com,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: kernel BUG at arch/x86/kvm/x86.c:361! on AMD CPU
Message-ID: <20190618175153.GC26346@zn.tnic>
References: <37952f51-7687-672c-45d9-92ba418c9133@oracle.com>
 <20190612161255.GN32652@zn.tnic>
 <af0054d1-1fc8-c106-b503-ca91da5a6fee@oracle.com>
 <20190612195152.GQ32652@zn.tnic>
 <20190612205430.GA26320@linux.intel.com>
 <20190613071805.GA11598@zn.tnic>
 <df80299b-8e1f-f48b-a26b-c163b4018d01@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <df80299b-8e1f-f48b-a26b-c163b4018d01@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 11:13:22AM -0400, George Kennedy wrote:
>    319f3:       0f 01 da                vmload                       <--- svm_vcpu_run+0xa83

Hmm, so VMLOAD can fault for a bunch of reasons if you look at its
description in the APM.

Looking at your Code: section and building with your config, rIP and the
insns around it point to:

All code
========
   0:	00 55 89             	add    %dl,-0x77(%rbp)
   3:	d2 45 89             	rolb   %cl,-0x77(%rbp)
   6:	c9                   	leaveq 
   7:	48 89 e5             	mov    %rsp,%rbp
   a:	8b 45 18             	mov    0x18(%rbp),%eax
   d:	50                   	push   %rax
   e:	8b 45 10             	mov    0x10(%rbp),%eax
  11:	50                   	push   %rax
  12:	e8 8a 42 6b 00       	callq  0x6b42a1
  17:	58                   	pop    %rax
  18:	5a                   	pop    %rdx
  19:	c9                   	leaveq 
  1a:	c3                   	retq   
  1b:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  21:	66 66 66 66 90       	data16 data16 data16 xchg %ax,%ax
  26:	55                   	push   %rbp
  27:	48 89 e5             	mov    %rsp,%rbp
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  31:	66 66 66 66 90       	data16 data16 data16 xchg %ax,%ax
  36:	55                   	push   %rbp
  37:	48 89 e5             	mov    %rsp,%rbp
  3a:	41 55                	push   %r13
  3c:	41 54                	push   %r12
  3e:	41                   	rex.B
  3f:	89                   	.byte 0x89

0000000000017f30 <__bpf_trace_kvm_nested_vmexit>:
   17f30:       55                      push   %rbp
   17f31:       89 d2                   mov    %edx,%edx
   17f33:       45 89 c9                mov    %r9d,%r9d
   17f36:       48 89 e5                mov    %rsp,%rbp
   17f39:       8b 45 18                mov    0x18(%rbp),%eax
   17f3c:       50                      push   %rax
   17f3d:       8b 45 10                mov    0x10(%rbp),%eax
   17f40:       50                      push   %rax
   17f41:       e8 00 00 00 00          callq  17f46 <__bpf_trace_kvm_nested_vmexit+0x16>
   17f46:       58                      pop    %rax
   17f47:       5a                      pop    %rdx
   17f48:       c9                      leaveq 
   17f49:       c3                      retq   
   17f4a:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)

0000000000017f50 <kvm_spurious_fault>:
   17f50:       e8 00 00 00 00          callq  17f55 <kvm_spurious_fault+0x5>
   17f55:       55                      push   %rbp
   17f56:       48 89 e5                mov    %rsp,%rbp
   17f59:       0f 0b                   ud2    
   17f5b:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)

so the invalid opcode splat is dumping the insn bytes around rIP the
UD2 happens but in order to see which of the VMLOAD conditions causes
the fault, you'd probably need to intercept the fault handler and dump
registers in the hypervisor to check.

There's something else that's bothering me though: your splat is from
the guest yet there is svm_vcpu_run() mentioned there which should be
called by the hypervisor and not by the guest. Unless you're doing
nested virt stuff...

Anyway, sorry that I cannot be of more help - I'm sure KVM guys would
make much more sense of it.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
