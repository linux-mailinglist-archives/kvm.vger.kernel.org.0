Return-Path: <kvm+bounces-21716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E75932BA1
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 17:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA3BA280DA5
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 15:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F52919E7D0;
	Tue, 16 Jul 2024 15:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4SGebI7i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F056119E7C4
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 15:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144823; cv=none; b=eS8+8cHvGVvDIRo1L9dYvA0hsoe6SMHDQuC037v99LQtedzM+DF6+r6gM/IS/Xo1d5pWOkYAPzT9K5pEY2wkahmFaSWoXrMtxGAUpKU/3M/bUol4ujTZl9pM6O4PJHM5I2qaR7R9leyZfyWBtTn6NlhvLXkaId6efcnXz1TqJ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144823; c=relaxed/simple;
	bh=YpEF0Q6yKkYxLuQtT2PJS/GZ92XHHf4x1MDsqSuwVCk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f4JxpIgsNLeEcFjABqAcBf9zdH4qTP3yKKi/c4skk2IHEFmklw6IMBivBjeSK+veUaiOHAGGxp5YSWQ5Q9vmyCPPLu5li8qnnL9MgNg5mEOOwNTbAI3UvNshOQf0K4gxJrDdV4G6gbLMsdk04xzPRfVYTGEhqjCOZQNsXjapLEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4SGebI7i; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70afd833ba9so3231482b3a.1
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 08:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721144821; x=1721749621; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ETWgHgOd443GlHDheQNvvEwb46QHybHGr7wnanCFogo=;
        b=4SGebI7iw6V6jR9glZcEtxBZ6Ur5cF7+TLS51iaw7rfy0sRRBuLLrWsDgFXrGS93Qw
         jcep0fZPitNTZpnc+s7Qb4Y86j7W6aV2AYvOYVGpGKOBeHij7qJictFCKZt6EbbYMycs
         nwHXnxE4GY8q9XZ5ygUBn1Z2fWCXdMnToK0V8AVETHeMufQQRDIafzPgykUvqXedZ9WG
         VYNLCMreLZkHzHwWoJvEPw2mGILOHnmJMxeBCHLqByGsUd2AwR1OH88RWw9Ac82xm9X4
         c5kKddXLW0H4iHPyHGQYV5Kd3AAXtUa0pZRaxkuctu2CSa+sz+Qc97W/5nuqklCFbfX+
         oVWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721144821; x=1721749621;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ETWgHgOd443GlHDheQNvvEwb46QHybHGr7wnanCFogo=;
        b=BZzPQarvTSpoCWqhfhs53DlLrP33OauqlpXGwOG6jNCzul3LiTN5TDqGBRYO8mveNF
         YHdQQf7XAh4/K7pTPQOCxqjYwAQKFSHCoyDdFaK5TG2Cx+cKhF3LFlDDlzsMnKsPoW7x
         +Q/aPiXFuxvKfnA5W6d41/r7HWh6cwwoIt+2m1hKQqfFtm6/N4rw5uM1WpcMqJ50eiRi
         WFKvfnFMdtDFHp6xSnLOgXt/QJYUXMIaybFi3voz8+E1V/gOWC4CrDINaTv7r5aM54nq
         Aej45zcxvdDdVw073yaZr4UZ0nVmTp8nbZeZ7LTeWLvxFo1zwqjc6n6W3DvddJQm9e+r
         vNBw==
X-Gm-Message-State: AOJu0YwEItmA7bB+Mhmqa2C1i50BShPQYP/VWzoppxinHxe+1xN0BJLj
	rqZgCiXeqNdohAw0B6ZiVEy8c9HxfYF0sjiG0UUMD3P+TYu4EItfvf+tnVcQc+0JsfNsDNLFvAl
	LZA==
X-Google-Smtp-Source: AGHT+IGc/BULnIieuwv9+FBRnu1M5AufL70Ng4HgUceQ2bAiT7WRdGZZQ21V3+tP1L1LEbg35yWRxfFG4Ss=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a93:b0:706:6b52:438c with SMTP id
 d2e1a72fcca58-70c14000242mr208338b3a.0.1721144821054; Tue, 16 Jul 2024
 08:47:01 -0700 (PDT)
Date: Tue, 16 Jul 2024 08:46:54 -0700
In-Reply-To: <0f60918d-bc46-4332-ad28-c155a1990e3d@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712235701.1458888-1-seanjc@google.com> <20240712235701.1458888-9-seanjc@google.com>
 <0f60918d-bc46-4332-ad28-c155a1990e3d@redhat.com>
Message-ID: <ZpaV7kaVL1rj7MXj@google.com>
Subject: Re: [GIT PULL (sort of)] KVM: x86: Static call changes for 6.11
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 16, 2024, Paolo Bonzini wrote:
> On 7/13/24 01:56, Sean Christopherson wrote:
> > Here's a massage pull request for the static_call() changes, just in case you
> > want to go this route instead of applying patches directly after merging
> > everything else for 6.11 (it was easy to generate this).  If you want to go the
> > patches route, I'll post 'em next week.
> > 
> > The following changes since commit c1c8a908a5f4c372f8a8dca0501b56ffc8d260fe:
> > 
> >    Merge branch 'vmx' (2024-06-28 22:22:53 +0000)
> > 
> > are available in the Git repository at:
> > 
> >    https://github.com/kvm-x86/linux.git  tags/kvm-x86-static_calls-6.11
> > 
> > for you to fetch changes up to b528de209c858f61953023b405a4abbf9a9933da:
> > 
> >    KVM: x86/pmu: Add kvm_pmu_call() to simplify static calls of kvm_pmu_ops (2024-06-28 15:23:49 -0700)
> 
> Thanks, indeed there was no straggler static_call() after applying
> this.  However, there might be a problem: static_call_cond() is equal
> to static_call() only if CONFIG_HAVE_STATIC_CALL_INLINE,

No, I think you misread the #if-#elif-#else.  It's only the !HAVE_STATIC_CALL
case that requires use of static_call_cond().  From include/linux/static_call.h:

  #ifdef CONFIG_HAVE_STATIC_CALL_INLINE
  #define static_call_cond(name)	(void)__static_call(name)

  #elif defined(CONFIG_HAVE_STATIC_CALL)
  #define static_call_cond(name)	(void)__static_call(name)

  #else
  #define static_call_cond(name)	(void)__static_call_cond(name)

  #endif

And per Josh, from an old RFC[*] to yank out static_call_cond():

 : Static calling a NULL pointer is a NOP, unless you're one of those poor
 : souls running on an arch (or backported x86 monstrosity) with
 : CONFIG_HAVE_STATIC_CALL=n, then it's a panic.

I double checked that 32-bit KVM works on Intel (which is guaranteed to have a
NULL guest_memory_reclaimed()).  I also verified that the generated code is
identical for both static_call() and static_call_cond(), i.e. the READ_ONCE() of
the func at runtime that's present in __static_call_cond() isn't showing up.

Dump of assembler code for function kvm_arch_guest_memory_reclaimed:
   0xc1042094 <+0>:	call   0xc10ce650 <__fentry__>
   0xc1042099 <+5>:	push   %ebp
   0xc104209a <+6>:	mov    %esp,%ebp
   0xc104209c <+8>:	call   0xc1932d8c <__SCT__kvm_x86_guest_memory_reclaimed>
   0xc10420a1 <+13>:	pop    %ebp
   0xc10420a2 <+14>:	ret    
End of assembler dump.

Dump of assembler code for function __SCT__kvm_x86_guest_memory_reclaimed:
   0xc1932d8c <+0>:	ret    
   0xc1932d8d <+1>:	int3   
   0xc1932d8e <+2>:	nop
   0xc1932d8f <+3>:	nop
   0xc1932d90 <+4>:	nop
   0xc1932d91 <+5>:	ud1    %esp,%ecx
End of assembler dump.

[*] https://lore.kernel.org/all/cover.1678474914.git.jpoimboe@kernel.org

