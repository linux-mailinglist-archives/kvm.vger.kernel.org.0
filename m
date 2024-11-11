Return-Path: <kvm+bounces-31506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D4919C434F
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 18:14:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C14E52827D1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 17:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 207DB1A706F;
	Mon, 11 Nov 2024 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NHMo+lmP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9C91A4E98
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731345229; cv=none; b=B830eCN1F0wqq6XREhjfjgis6Zz0U6SAOs/Kg+MmCoc2tSRqTScasKL2NbzevE/Ngj/4FxEgJm61Ose8acSzTaQv0O/FbW5O7HTaa3z2bY0dZ8yPglveOW79ecq/WDykuHGS+aE8Fdoa5QwnTDHUeuJYAVew9MQdLCnNv86HH4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731345229; c=relaxed/simple;
	bh=ret7sqyESc5ruXA3nhuPZ3KHNPXoIw4dcOwwP4EC084=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ePS7HpMG6K8h283xUrWjsVe91fA82YA8V2m/lx2uwV6Oxk4iBbHQiQBCqWz8CIqiQsMlZ0a+Uv2Dd83nq5A8cVznfdAT1JEZU3i2/SNJYNT9CDbi9ZqMf+OT0Yv0bURC1htTb3N4r7O15kXwsQAkmR+PRNz3kTi3c+qI3nGXgQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NHMo+lmP; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e49ae1172so4351358b3a.2
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 09:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731345227; x=1731950027; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SF+DpAbHUmcXzFvmBd4F+PWQudXrAabpaBlA9QzlTpM=;
        b=NHMo+lmPF5hKzpo1YbEXsTarRiGiTBb41iMmclPnQyxpKlDpXjAK4WA02glmfY+owQ
         FqHQIDaYjAI8vex8derkAkSQ2HUeR3KZFGwyrplhwS5CbmuhVZF6707R7Et00eE9grs6
         VXEh6X97vVflpslmlHQ9xnqtGUcOaXbhPLsVZYtTwn2RtrRCeQaKdDkP1WllY/1Wc5pm
         Z2RsjEgq9rk/1GLB4lqGci6Wmg9nJDxEktRPAmgyFQiW6FAQh3LU8NmQRL4/PYUuPOoI
         yZ4LO0QHpvyRPQmzPGuGut8flS1mSbHDV5lKw8ibE7lHpCVk1U7d32bkPgQTTQLyFJ2F
         ZihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731345227; x=1731950027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SF+DpAbHUmcXzFvmBd4F+PWQudXrAabpaBlA9QzlTpM=;
        b=XWTferLIEc/2CLaDuPguM37fKwYvF0Al1xBNf0GAaFGBnfsIFGit1mv+SphCGPM7c3
         ZOwxSXN4vO0Asn92/k5OTupxc5rV4NQqtHj93w3itFl2lrM9NyKxRKrWfbneOOYdsktD
         kiO+iVwEerqqoOgTfN4lLZPY3zaRDRU6Vu8IaI8WaKTwbfS+EUlugN6UIuWHTZvONUeC
         nAC5WJcxJbMhkj7DQPlhZ+dBwqOTQDKWkx2F+Y8GwL7EsgOhDHLUUutcq3h7c1XeWFG+
         sisTgSdd3WUmKw/7iBJZ8jPrdCk1JHX2z7mqDpTueEKzXaC+QyY1reb5rEwYyBqa4dRw
         wbAw==
X-Forwarded-Encrypted: i=1; AJvYcCVBQJ63y/o/5owd7QWTehNVUIwYFAQ+/VTsIvPGMAzBGNDZ2+FYDe59lpuNGcEKJa3HNiY=@vger.kernel.org
X-Gm-Message-State: AOJu0YygfrMXdE+eNtfrkItZLT+1csZzHwqCnNykHUrUeJY4tHLL7jLe
	I/m6980jHYgnDhwqxCREx9Sl7X6mFdDD4gYaMZdWk1lqoWzqIdTi75WkL08xOmeu3gpDCYmpYo1
	lVQ==
X-Google-Smtp-Source: AGHT+IEq5f1Lu3Rh31Wea8fuGHNmDS+fJf+Kyq0/eZwavPBgk4wsyTcpVC6U2U12WYNBrtAGigqVlq9MOgI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a18:b0:71e:69bb:d0f8 with SMTP id
 d2e1a72fcca58-7241325edcdmr780540b3a.1.1731345227229; Mon, 11 Nov 2024
 09:13:47 -0800 (PST)
Date: Mon, 11 Nov 2024 09:13:45 -0800
In-Reply-To: <20241111125219.248649120@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241111115935.796797988@infradead.org> <20241111125219.248649120@infradead.org>
Message-ID: <ZzI7SYxeXWOJmlun@google.com>
Subject: Re: [PATCH v2 11/12] x86/kvm/emulate: Implement test_cc() in C
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: pbonzini@redhat.com, jpoimboe@redhat.com, tglx@linutronix.de, 
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	jthoughton@google.com
Content-Type: text/plain; charset="us-ascii"

Can you use "KVM: x86" for the scope?  "x86/kvm" is used for guest changes, i.e.
for paravirt code when running as a KVM guest.

On Mon, Nov 11, 2024, Peter Zijlstra wrote:
> Current test_cc() uses the fastop infrastructure to test flags using
> SETcc instructions. However, int3_emulate_jcc() already fully
> implements the flags->CC mapping, use that.

I think it's worth presenting this as a revert of sorts, even though it's not a
strict revert.  KVM also emulated jcc-like operations in software prior to commit
9ae9febae950 ("KVM: x86 emulator: covert SETCC to fastop"), i.e. the fastop
madness was introduced for performance reasons, not because writing the code was
hard.

Looking at the output of the fastop versus __emulate_cc(), the worst case cost is
two extra conditional branches.  Assuming that eliminating the test_cc() fastop
code avoids having to add another special case in objtool, I am a-ok with the
tradeoff.  Especially since emulating instructions that use test_cc() is largely
limited to older hardware running guest firmware that uses (emulated) SMM, and
maybe a few bespoke use cases.  E.g. I get literally zero hits on test_cc() when
booting a 24 vCPU VM (64-bit or 32-bit kernel) with EPT and unrestricted guest
disabled, as the OVMF build I use doesn't rely on SMM.

And FWIW, a straight revert appears to generate worse code.  I see no reason to
bring it back.

With a massaged shortlog+changelog,

Acked-by: Sean Christopherson <seanjc@google.com>


fastop:
   0x0000000000042c41 <+1537>:  movzbl 0x61(%rbp),%eax
   0x0000000000042c45 <+1541>:  mov    0x10(%rbp),%rdx
   0x0000000000042c49 <+1545>:  shl    $0x4,%rax
   0x0000000000042c4d <+1549>:  and    $0xf0,%eax
   0x0000000000042c52 <+1554>:  and    $0x8d5,%edx
   0x0000000000042c58 <+1560>:  or     $0x2,%dh
   0x0000000000042c5b <+1563>:  add    $0x0,%rax
   0x0000000000042c61 <+1569>:  push   %rdx
   0x0000000000042c62 <+1570>:  popf   
   0x0000000000042c63 <+1571>:  call   0x42c68 <x86_emulate_insn+1576>
   0x0000000000042c68 <+1576>:  mov    %eax,%edx
   0x0000000000042c6a <+1578>:  xor    %eax,%eax
   0x0000000000042c6c <+1580>:  test   %dl,%dl
   0x0000000000042c6e <+1582>:  jne    0x42f24 <x86_emulate_insn+2276>

__emulate_cc:
   0x0000000000042b95 <+1541>:	movzbl 0x61(%rbp),%eax
   0x0000000000042b99 <+1545>:	mov    0x10(%rbp),%rcx
   0x0000000000042b9d <+1549>:	and    $0xf,%eax
   0x0000000000042ba0 <+1552>:	cmp    $0xb,%al
   0x0000000000042ba2 <+1554>:	ja     0x42e90 <x86_emulate_insn+2304>
        0x0000000000042e90 <+2304>:  mov    %rcx,%rdx
        0x0000000000042e93 <+2307>:  mov    %rcx,%rsi
        0x0000000000042e96 <+2310>:  shr    $0x7,%rdx
        0x0000000000042e9a <+2314>:  shr    $0xb,%rsi
        0x0000000000042e9e <+2318>:  xor    %rsi,%rdx
        0x0000000000042ea1 <+2321>:  cmp    $0xd,%al
        0x0000000000042ea3 <+2323>:  ja     0x4339a <x86_emulate_insn+3594>
                0x000000000004339a <+3594>:  and    $0x1,%edx
                0x000000000004339d <+3597>:  and    $0x40,%ecx
                0x00000000000433a0 <+3600>:  or     %rcx,%rdx
                0x00000000000433a3 <+3603>:  setne  %dl
                0x00000000000433a6 <+3606>:  jmp    0x42bba <x86_emulate_insn+1578>
        0x0000000000042ea9 <+2329>:  and    $0x1,%edx
        0x0000000000042eac <+2332>:  jmp    0x42bba <x86_emulate_insn+1578>
   0x0000000000042ba8 <+1560>:	mov    %eax,%edx
   0x0000000000042baa <+1562>:	shr    %dl
   0x0000000000042bac <+1564>:	and    $0x7,%edx
   0x0000000000042baf <+1567>:	and    0x0(,%rdx,8),%rcx
   0x0000000000042bb7 <+1575>:	setne  %dl
   0x0000000000042bba <+1578>:	test   $0x1,%al
   0x0000000000042bbc <+1580>:	jne    0x43323 <x86_emulate_insn+3475>
        0x0000000000043323 <+3475>:  test   %dl,%dl
        0x0000000000043325 <+3477>:  jne    0x4332f <x86_emulate_insn+3487>
        0x0000000000043327 <+3479>:  test   $0x1,%al
        0x0000000000043329 <+3481>:  jne    0x42bca <x86_emulate_insn+1594>
        0x000000000004332f <+3487>:  xor    %eax,%eax
        0x0000000000043331 <+3489>:  jmp    0x42be0 <x86_emulate_insn+1616>
   0x0000000000042bc2 <+1586>:	test   %dl,%dl
   0x0000000000042bc4 <+1588>:	je     0x43327 <x86_emulate_insn+3479>
        0x0000000000043327 <+3479>:  test   $0x1,%al
        0x0000000000043329 <+3481>:  jne    0x42bca <x86_emulate_insn+1594>
        0x000000000004332f <+3487>:  xor    %eax,%eax
        0x0000000000043331 <+3489>:  jmp    0x42be0 <x86_emulate_insn+1616>
   0x0000000000042bca <+1594>:	movslq 0xd0(%rbp),%rsi
   0x0000000000042bd1 <+1601>:	mov    %rbp,%rdi
   0x0000000000042bd4 <+1604>:	add    0x90(%rbp),%rsi
   0x0000000000042bdb <+1611>:	call   0x3a7c0 <assign_eip>

revert:
   0x0000000000042bc9 <+1545>:  movzbl 0x61(%rbp),%esi
   0x0000000000042bcd <+1549>:  mov    0x10(%rbp),%rdx
   0x0000000000042bd1 <+1553>:  mov    %esi,%eax
   0x0000000000042bd3 <+1555>:  shr    %eax
   0x0000000000042bd5 <+1557>:  and    $0x7,%eax
   0x0000000000042bd8 <+1560>:  cmp    $0x4,%eax
   0x0000000000042bdb <+1563>:  je     0x42ed4 <x86_emulate_insn+2324>
        0x0000000000042ed4 <+2324>:  mov    %edx,%ecx
        0x0000000000042ed6 <+2326>:  and    $0x80,%ecx
        0x0000000000042edc <+2332>:  jmp    0x42bff <x86_emulate_insn+1599>
   0x0000000000042be1 <+1569>:  ja     0x43225 <x86_emulate_insn+3173>
        0x0000000000043225 <+3173>:  cmp    $0x6,%eax
        0x0000000000043228 <+3176>:  je     0x434ec <x86_emulate_insn+3884>
                0x00000000000434ec <+3884>:  xor    %edi,%edi
                0x00000000000434ee <+3886>:  jmp    0x43238 <x86_emulate_insn+3192>
        0x000000000004322e <+3182>:  mov    %edx,%edi
        0x0000000000043230 <+3184>:  and    $0x40,%edi
        0x0000000000043233 <+3187>:  cmp    $0x7,%eax
        0x0000000000043236 <+3190>:  jne    0x4325c <x86_emulate_insn+3228>
                0x000000000004325c <+3228>:  mov    %edx,%ecx
                0x000000000004325e <+3230>:  and    $0x4,%ecx
                0x0000000000043261 <+3233>:  cmp    $0x5,%eax
                0x0000000000043264 <+3236>:  je     0x42bff <x86_emulate_insn+1599>
                0x000000000004326a <+3242>:  jmp    0x43218 <x86_emulate_insn+3160>
        0x0000000000043238 <+3192>:  mov    %rdx,%rcx
        0x000000000004323b <+3195>:  shr    $0xb,%rdx
        0x000000000004323f <+3199>:  shr    $0x7,%rcx
        0x0000000000043243 <+3203>:  xor    %edx,%ecx
        0x0000000000043245 <+3205>:  and    $0x1,%ecx
        0x0000000000043248 <+3208>:  or     %edi,%ecx
        0x000000000004324a <+3210>:  jmp    0x42bff <x86_emulate_insn+1599>
   0x0000000000042be7 <+1575>:  mov    %edx,%ecx
   0x0000000000042be9 <+1577>:  and    $0x40,%ecx
   0x0000000000042bec <+1580>:  cmp    $0x2,%eax
   0x0000000000042bef <+1583>:  je     0x42bff <x86_emulate_insn+1599>
   0x0000000000042bf1 <+1585>:  mov    %edx,%ecx
   0x0000000000042bf3 <+1587>:  and    $0x41,%ecx
   0x0000000000042bf6 <+1590>:  cmp    $0x3,%eax
   0x0000000000042bf9 <+1593>:  jne    0x4320a <x86_emulate_insn+3146>
        0x000000000004320a <+3146>:  mov    %edx,%ecx
        0x000000000004320c <+3148>:  and    $0x1,%ecx
        0x000000000004320f <+3151>:  cmp    $0x1,%eax
        0x0000000000043212 <+3154>:  je     0x42bff <x86_emulate_insn+1599>
        0x0000000000043218 <+3160>:  mov    %edx,%ecx
        0x000000000004321a <+3162>:  and    $0x800,%ecx
        0x0000000000043220 <+3168>:  jmp    0x42bff <x86_emulate_insn+1599>
   0x0000000000042bff <+1599>:  test   %ecx,%ecx
   0x0000000000042c01 <+1601>:  setne  %dl
   0x0000000000042c04 <+1604>:  and    $0x1,%esi
   0x0000000000042c07 <+1607>:  xor    %eax,%eax
   0x0000000000042c09 <+1609>:  cmp    %sil,%dl
   0x0000000000042c0c <+1612>:  je     0x42c24 <x86_emulate_insn+1636>
   0x0000000000042c0e <+1614>:  movslq 0xd0(%rbp),%rsi
   0x0000000000042c15 <+1621>:  mov    %rbp,%rdi
   0x0000000000042c18 <+1624>:  add    0x90(%rbp),%rsi
   0x0000000000042c1f <+1631>:  call   0x3a7c0 <assign_eip>

