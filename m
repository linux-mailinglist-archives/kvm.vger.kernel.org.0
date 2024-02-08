Return-Path: <kvm+bounces-8378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C1B784EB28
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 23:06:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50BD91C22A4A
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 22:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32BBD4F60B;
	Thu,  8 Feb 2024 22:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lknxpQss"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0F84F601
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 22:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707429971; cv=none; b=IibtMczCIPz6AonQoz7CBTTIJRwIzxTKt6hzAVHktxQvU1s2pLMLmtRSFUCUKyEGV5ZT0cqay/btCKSMacaSrG1NrBje350w4vEVVaFqE8aBSu1mviXffpUF7zeSHIBoBJ2mhC6LMjkzVco9IZ3JEmnyun9ZJuLdvMR5s9BlBc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707429971; c=relaxed/simple;
	bh=+HqxsW+M2owUPE1t0f3ih4AUm9D5nOd5rHTbwXvGmf4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RmyY1TZd6kapPedosMGRY3LfvXIXTtaR3+x6u4WZK0B2unSd3ZpWwcY4IFMtH/2L05ebjJ9Lg832fsFLbl0bAaXonUrqgJLqcc3pGfkLAPH+Kmr3cfoGtCu5sRIiM5cMZ7c0xihaJOSVbBV7eBLZr56DPina/OQeuKo4M/aALWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lknxpQss; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc746178515so552906276.2
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 14:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707429968; x=1708034768; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qvMyG9nvSBHLUMFOMKRFO9Rewa0dt7iLtbjmjr+czqE=;
        b=lknxpQssqgRn4fHAUeAfrjKv0DS/rSWQX2OXM08f9QFBBuAmiFJA9Dwn7sTl51szmF
         2/IEAEP7ilzwI5OB3VMBr5YAzUS283Zb2lySBdsfiRNNCqHRQGe1GHfUpmm71ahAXvaA
         u2xAt7szGSSYyVqBck0V370VjE/aHtL7+fGWllBHjSS+RFl7w+nE6WdVg4nqTCzUItQb
         pRpzKbeX42QwTDI+NBIuuCcoV2dzTzTkikXWxmVsqwncAVWa2h8oromlYRKhm79zlVVs
         DuzRty6YdtYXu7ug8d5T/AtM0BsWv9qEhWFLnc3vAbeBfnGamXKeh4plIEYirUZdyWJo
         G7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707429968; x=1708034768;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qvMyG9nvSBHLUMFOMKRFO9Rewa0dt7iLtbjmjr+czqE=;
        b=T2qRiJZwDnIdwoyi++9jXwshJNdK4ZU/stLTFgXd6INDkjbAf38+riL7cpJIWbH93H
         mfGWnx0Gb9lVGQ0jstfeuJ17NQo3yn8/h+3FCq6pHhsmxCME0t/9aHa80I8EIHdt0jDM
         NbDzFZ9Ib3I49VCwbHVlsnp8FyxyXhJwOkd5a9vHNeIJSJ+0p6csWlbEr2hSVUyNQiZR
         ooEjtx8a1h+xnk9sjdVTtqyvX3nX5HJ/zZbWlyfVIBsSUGwuCPAeb0px386uw6AYnEMQ
         dJqPy7lx5CoezQkpJBB/2vm+j6DX0NKvP/OBhIy4y1yCwO6lhmdpf74wwImwq7eUzA8V
         M29w==
X-Forwarded-Encrypted: i=1; AJvYcCXOsZ3BK7zxcZb4W3loM8PaLm6u4caFYtsIpKgUiwZKsrTCitL4ZEwZlp+klmMdkhX994IDqengg0zw/I/oF+nB1ww5
X-Gm-Message-State: AOJu0YwTPh8/nMYnzeoGYfxCcEQWcaq0po+prTCYWJnZjLp01qjRhAgu
	6aLM8zCbtSWJKNJwI3tR41sfiW3TbTIplo/4wLbs7fVzrWdHZRKf9GGO2Ii+UabptcGuLEa5LN0
	oyA==
X-Google-Smtp-Source: AGHT+IF4UvzHXxBTFScmavn1RAtcQWZlBrtweDSMjdbmJ5YCqJHNXdskuFeue0XYnVhq0rq10/+PCXtYDjE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100a:b0:dc2:4ab7:3d89 with SMTP id
 w10-20020a056902100a00b00dc24ab73d89mr203274ybt.1.1707429968666; Thu, 08 Feb
 2024 14:06:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Feb 2024 14:06:04 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240208220604.140859-1-seanjc@google.com>
Subject: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
From: Sean Christopherson <seanjc@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly require gcc-12+ to enable asm goto with outputs on gcc to avoid
what is effectively a data corruption bug on gcc-11.  As per
https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html, "asm goto" is
*supposed* be implicitly volatile, but gcc-11 fails to treat it as such.
When compiling with -O2, failure to treat the asm block as volatile can
result in the entire block being discarded during optimization.

Even worse, forcing "asm volatile goto" keeps the block, but generates
completely bogus code.

Hardcode the gcc-12 or later requirement as trying to pipe the assembled
output to stdout, e.g. to query the generated code via objdump, doesn't
work due to the assembler wanting to seek throughout the output file.

Note, gcc-11 is the first gcc version that supports goto w/ outputs
(obviously with a loose definition of "supports").

E.g. given KVM's code sequence:

  vmcs12->guest_pdptr0 = vmcs_read64(GUEST_PDPTR0);
  vmcs12->guest_pdptr1 = vmcs_read64(GUEST_PDPTR1);
  vmcs12->guest_pdptr2 = vmcs_read64(GUEST_PDPTR2);
  vmcs12->guest_pdptr3 = vmcs_read64(GUEST_PDPTR3);

where vmcs_read64() eventually becomes:

	asm_volatile_goto("1: vmread %[field], %[output]\n\t"
			  "jna %l[do_fail]\n\t"

			  _ASM_EXTABLE(1b, %l[do_exception])

			  : [output] "=r" (value)
			  : [field] "r" (field)
			  : "cc"
			  : do_fail, do_exception);

	return value;

  do_fail:
	instrumentation_begin();
	vmread_error(field);
	instrumentation_end();
	return 0;

  do_exception:
	kvm_spurious_fault();
	return 0;

the sequence of VMREADs should generate:

   nopl   0x0(%rax,%rax,1)
   mov    $0x280a,%eax
   vmread %rax,%rax
   jbe    0xffffffff81099849 <sync_vmcs02_to_vmcs12+1929>
   mov    %rax,0xd8(%rbx)
   nopl   0x0(%rax,%rax,1)
   mov    $0x280c,%eax
   vmread %rax,%rax
   jbe    0xffffffff8109982c <sync_vmcs02_to_vmcs12+1900>
   mov    %rax,0xe0(%rbx)
   nopl   0x0(%rax,%rax,1)
   mov    $0x280e,%eax
   vmread %rax,%rax
   jbe    0xffffffff8109980f <sync_vmcs02_to_vmcs12+1871>
   mov    %rax,0xe8(%rbx)
   nopl   0x0(%rax,%rax,1)
   mov    $0x2810,%eax
   vmread %rax,%rax
   jbe    0xffffffff810997f2 <sync_vmcs02_to_vmcs12+1842>
   mov    %rax,0xf0(%rbx)
   jmp    0xffffffff81099297 <sync_vmcs02_to_vmcs12+471>

but gcc-11 will omit the asm block for the VMREAD to GUEST_PDPTR3 and skip
straight to one of the "return 0" statements:

   nopl   0x0(%rax,%rax,1)
   mov    $0x280a,%r13d
   vmread %r13,%r13
   jbe    0xffffffff810996cd <sync_vmcs02_to_vmcs12+1949>
   mov    %r13,0xd8(%rbx)
   nopl   0x0(%rax,%rax,1)
   mov    $0x280c,%r13d
   vmread %r13,%r13
   jbe    0xffffffff810996ae <sync_vmcs02_to_vmcs12+1918>
   mov    %r13,0xe0(%rbx)
   nopl   0x0(%rax,%rax,1)
   mov    $0x280e,%r13d
   vmread %r13,%r13
   jbe    0xffffffff8109968f <sync_vmcs02_to_vmcs12+1887>
   mov    %r13,0xe8(%rbx)
   nopl   0x0(%rax,%rax,1)
   xor    %r12d,%r12d      <= return 0
   mov    %r12,0xf0(%rbx)  <= store result to vmcs12->guest_pdptr3
   jmp    0xffffffff8109912c <sync_vmcs02_to_vmcs12+508>

and with "volatile" forced, gcc-11 generates the correct-at-first-glance,
but terribly broken sequence of:

   nopl   0x0(%rax,%rax,1)
   mov    $0x280a,%r13d
   vmread %r13,%r13
   jbe    0xffffffff810999a4 <sync_vmcs02_to_vmcs12+1988>
   mov    %r13,0xd8(%rbx)
   nopl   0x0(%rax,%rax,1)
   mov    $0x280c,%r13d
   vmread %r13,%r13
   jbe    0xffffffff81099985 <sync_vmcs02_to_vmcs12+1957>
   mov    %r13,0xe0(%rbx)
   nopl   0x0(%rax,%rax,1)
   mov    $0x280e,%r13d
   vmread %r13,%r13
   jbe    0xffffffff81099966 <sync_vmcs02_to_vmcs12+1926>
   mov    %r13,0xe8(%rbx)
   nopl   0x0(%rax,%rax,1)
   mov    $0x2810,%eax
   vmread %rax,%rax
   jbe    0xffffffff8109994a <sync_vmcs02_to_vmcs12+1898>
   xor    %r12d,%r12d     <= WTF gcc!?!?!
   mov    %r12,0xf0(%rbx)

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=103979
Fixes: 587f17018a2c ("Kconfig: add config option for asm goto w/ outputs")
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Linus, I'm sending to you directly as this seems urgent enough to apply
straightaway, and this obviously affects much more than the build system.

 init/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index deda3d14135b..f4e46d64c1e7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -82,6 +82,11 @@ config CC_CAN_LINK_STATIC
 	default $(success,$(srctree)/scripts/cc-can-link.sh $(CC) $(CLANG_FLAGS) $(USERCFLAGS) $(USERLDFLAGS) $(m32-flag) -static)
 
 config CC_HAS_ASM_GOTO_OUTPUT
+	# gcc-11 has a nasty bug where it doesn't treat asm goto as volatile,
+	# which can result in asm blocks being dropped when compiling with -02.
+	# Note, explicitly forcing volatile doesn't entirely fix the bug!
+	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=103979
+	depends on !CC_IS_GCC || GCC_VERSION >= 120000
 	def_bool $(success,echo 'int foo(int x) { asm goto ("": "=r"(x) ::: bar); return x; bar: return 0; }' | $(CC) -x c - -c -o /dev/null)
 
 config CC_HAS_ASM_GOTO_TIED_OUTPUT

base-commit: 047371968ffc470769f541d6933e262dc7085456
-- 
2.43.0.687.g38aa6559b0-goog


