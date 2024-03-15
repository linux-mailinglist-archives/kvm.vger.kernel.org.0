Return-Path: <kvm+bounces-11937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F9BB87D47C
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 20:38:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99CB6284A7A
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 19:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51F352F74;
	Fri, 15 Mar 2024 19:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xkC1M/1X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F111524BC
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 19:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710531524; cv=none; b=fnEbjkhnQvYZDI71C6sMrzSS5bMNh4YkA81yaD/Vm0OK1RMCtHHAMvmxxMQ3msrjx9QuRApcu02SdsqUl3pC6/bRlAMsR8q6TgwdKeDDq5SBMdlugbXehBHQDzYH18UqFbNfpnp/TvSuv0oQxKs65AtNf48/JihVVDYfw2LjleM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710531524; c=relaxed/simple;
	bh=RGPC777eBlkFJio++4t4VlJ1sBxW6uPJFKW/2qQVXYw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sCZY6wkPahk0BkFPU+s4l4/Ll6PK/oKq9/WI4CCp967dMdAvg+Nm3wgnMXlGd6GHbg1oNNUOG6Wv7XzkZnG38zWwd2VDhx8K3RlF/lvfZBk0vpwWQ3gM8dNKcfp2DMzaIfgK9LLgSxEZ6Et6fOa1rSrJkOX22ttqzJ11xcbCwPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xkC1M/1X; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e6a1625e4bso2731518b3a.1
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 12:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710531522; x=1711136322; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+zMeq0vqhynnEQcbVRxi0CACo9uLajOY9qPMbdixPBQ=;
        b=xkC1M/1XFjhKWHCgpxKrt7gTBgfdT5gPooYjI9G6AURZyTPgFN4Py700gD5k8OqM1G
         euwPjJex8pyVZjSmfxxPXzuu+oYjC17wywXfYpLXPDKCi+I/IgA4G6v3FaF+PhA+MBGw
         JacMnR2EWqWkXLOt8AkpeXg+f/06fHYKnLrxETG8BUuL0L/52eo+zK+dMZq/lRsRFj6T
         dhfRFKcrUjztmxous89UsOkOO4/aAvAARNLv1572crz7kPAtl3BtKxiAufdrnuL3WeKF
         TlMx7NKqpjI8wYepDFBL1ZM/z7d71//qjWhne2uw5+nePXv+o8tA6VL4BKkzz6JvtkfD
         UAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710531522; x=1711136322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+zMeq0vqhynnEQcbVRxi0CACo9uLajOY9qPMbdixPBQ=;
        b=iPdI5k5WVCI0OVZdRyCoZbClxkR6MYk7fEiVKCJ0WWvj0E+i9kF5dcnaE/Fyz7T7V7
         +9Mgca15T9pBJ0nPXBurppe4IfO6GRdz/kv9isMOfz/0LWopAwONkdMfVfeVTm3831DT
         LxBaY1TJJ6EDapdMx5nCGoAbB8gbDgo59cbEAW3Thco1rUKZ/Cg9IQ2UCUCZJ/uIAoQc
         KKtBTtHnDRGkfOnXqk00bqUw8nMA6rrBAWnIRdlo2yLeOpAzBsw52Ev745sNkQGNX0pa
         TCvSbe8FSsTgEjoLcZuQJip8skYuqlJHJsgRzd9DXITaDNnkhwzwtbDREwuQ+UAcW2Y1
         EHMg==
X-Forwarded-Encrypted: i=1; AJvYcCWvq/RnB6SIPBHLgeF7XYqGSfTEEBNuf7kwaCUgNyzNIEewtGDZvaLAr+PEodgymIpZhcjfQvH9qnVvKpCfyRXTdZ5o
X-Gm-Message-State: AOJu0YzxZfWHaMC+qsVH/najGjsTDy2hP3WbhajzLQsu9e5BZpJKBhIw
	R5j7Kq2iw3iqMF8l5OuA+p+20WYm4fFWWYcxKrl3b1jY0ASVW1mNnZviEO2T7OYHUKbbePAhVWc
	k5Q==
X-Google-Smtp-Source: AGHT+IGrnIfaYFnn4ZKJ049EDZZpjflnJNqElYAH/XpXBT1sXRkPAf720qtNiX5MM5UcTkO9b+U9YR0+J+I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3999:b0:6e6:7abd:b7c2 with SMTP id
 fi25-20020a056a00399900b006e67abdb7c2mr125648pfb.5.1710531520444; Fri, 15 Mar
 2024 12:38:40 -0700 (PDT)
Date: Fri, 15 Mar 2024 12:38:39 -0700
In-Reply-To: <ea85f773-b5ef-4cf6-b2bd-2c0e7973a090@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com> <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com> <ZfR4UHsW_Y1xWFF-@google.com>
 <ea85f773-b5ef-4cf6-b2bd-2c0e7973a090@intel.com>
Message-ID: <ZfSjvwdJqFJhxjth@google.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, Bo2 Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	Erdem Aktas <erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 15, 2024, Dave Hansen wrote:
> On 3/15/24 09:33, Sean Christopherson wrote:
> >         static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
> >         				      struct tdx_module_args *out)
> >         {
> >         	struct tdx_module_args in = {
> >         		.rcx = gpa | level,
> >         		.rdx = tdr,
> >         	};
> > 
> >         	return tdx_seamcall_sept(TDH_MEM_PAGE_REMOVE, &in, out);
> >         }
> > 
> > generates the below monstrosity with gcc-13.  And that's just one SEAMCALL wrapper,
> > *every* single one generates the same mess.  clang-16 is kinda sorta a little
> > better, as it at least inlines the helpers that have single callers.
> 
> Yeah, that's really awful.
> 
> Is all the inlining making the compiler too ambitious?

No, whether or not the wrappers are inlined doesn't change anything.  gcc actually
doesn't inline any of these helpers.  More below.

> Why is this all inlined in the first place?

Likely because no one looked at the generated code.  The C code is super simple
and looks like it should be inlined.

And the very original code was macro heavy, i.e. relied on inlining to allow the
compiler to precisely set only the actual registers needed for the SEAMCALL.

> tdh_mem_page_remove() _should_ just be logically:
> 
> 	* initialize tdx_module_args.  Move a few things into place on
> 	  the stack and zero the rest.

The "zero the rest" is what generates the fugly code.  The underlying problem is
that the SEAMCALL assembly functions unpack _all_ registers from tdx_module_args.
As a result, tdx_module_args needs to be zeroed to avoid loading registers with
unitialized stack data.

E.g. before I looked at the assembly code, my initial thought to clean things
up by doing:

	struct tdx_module_args in;

	in.rcx = gpa | level;
	in.rdx = tdr;

but that would make one or more sanitizers (and maybe even the compiler itself)
more than a bit unhappy.

The struct is 72 bytes, which adds up to a lot of wasted effort since the majority
of SEAMCALLs only use a few of the 13 registers.

FWIW, the guest side of TDX is equally gross.  E.g. to do kvm_hypercall1(), which
without TDX is simply

   0xffffffff810eb4a2 <+82>:	48 c7 c0 8c 9a 01 00	mov    $0x19a8c,%rax
   0xffffffff810eb4a9 <+89>:	8b 1c 02           	mov    (%rdx,%rax,1),%ebx
   0xffffffff810eb4ac <+92>:	b8 0b 00 00 00     	mov    $0xb,%eax
   0xffffffff810eb4b1 <+97>:	0f 01 c1           	vmcall
   0xffffffff810eb4b4 <+100>:	5b                 	pop    %rbx
   0xffffffff810eb4b5 <+101>:	5d                 	pop    %rbp

the kernel blasts the unused params

   0xffffffff810ffdc1 <+97>:	bf 0b 00 00 00     	mov    $0xb,%edi
   0xffffffff810ffdc6 <+102>:	31 d2              	xor    %edx,%edx
   0xffffffff810ffdc8 <+104>:	31 c9              	xor    %ecx,%ecx
   0xffffffff810ffdca <+106>:	45 31 c0           	xor    %r8d,%r8d
   0xffffffff810ffdcd <+109>:	5b                 	pop    %rbx
   0xffffffff810ffdce <+110>:	41 5e              	pop    %r14
   0xffffffff810ffdd0 <+112>:	e9 bb 1b f0 ff     	jmp    0xffffffff81001990 <tdx_kvm_hypercall>

then loads and zeros a ton of memory (tdx_kvm_hypercall()):

   0xffffffff81001990 <+0>:	nopl   0x0(%rax,%rax,1)
   0xffffffff81001995 <+5>:	sub    $0x70,%rsp
   0xffffffff81001999 <+9>:	mov    %gs:0x28,%rax
   0xffffffff810019a2 <+18>:	mov    %rax,0x68(%rsp)
   0xffffffff810019a7 <+23>:	mov    %edi,%eax
   0xffffffff810019a9 <+25>:	movq   $0x0,0x18(%rsp)
   0xffffffff810019b2 <+34>:	movq   $0x0,0x10(%rsp)
   0xffffffff810019bb <+43>:	movq   $0x0,0x8(%rsp)
   0xffffffff810019c4 <+52>:	movq   $0x0,(%rsp)
   0xffffffff810019cc <+60>:	mov    %rax,0x20(%rsp)
   0xffffffff810019d1 <+65>:	mov    %rsi,0x28(%rsp)
   0xffffffff810019d6 <+70>:	mov    %rdx,0x30(%rsp)
   0xffffffff810019db <+75>:	mov    %rcx,0x38(%rsp)
   0xffffffff810019e0 <+80>:	mov    %r8,0x40(%rsp)
   0xffffffff810019e5 <+85>:	movq   $0x0,0x48(%rsp)
   0xffffffff810019ee <+94>:	movq   $0x0,0x50(%rsp)
   0xffffffff810019f7 <+103>:	movq   $0x0,0x58(%rsp)
   0xffffffff81001a00 <+112>:	movq   $0x0,0x60(%rsp)
   0xffffffff81001a09 <+121>:	mov    %rsp,%rdi
   0xffffffff81001a0c <+124>:	call   0xffffffff819f0a80 <__tdx_hypercall>
   0xffffffff81001a11 <+129>:	mov    %gs:0x28,%rcx
   0xffffffff81001a1a <+138>:	cmp    0x68(%rsp),%rcx
   0xffffffff81001a1f <+143>:	jne    0xffffffff81001a26 <tdx_kvm_hypercall+150>
   0xffffffff81001a21 <+145>:	add    $0x70,%rsp
   0xffffffff81001a25 <+149>:	ret

and then unpacks all of that memory back into registers, and reverses that last
part on the way back, (__tdcall_saved_ret()):

   0xffffffff819f0b10 <+0>:	mov    %rdi,%rax
   0xffffffff819f0b13 <+3>:	mov    (%rsi),%rcx
   0xffffffff819f0b16 <+6>:	mov    0x8(%rsi),%rdx
   0xffffffff819f0b1a <+10>:	mov    0x10(%rsi),%r8
   0xffffffff819f0b1e <+14>:	mov    0x18(%rsi),%r9
   0xffffffff819f0b22 <+18>:	mov    0x20(%rsi),%r10
   0xffffffff819f0b26 <+22>:	mov    0x28(%rsi),%r11
   0xffffffff819f0b2a <+26>:	push   %rbx
   0xffffffff819f0b2b <+27>:	push   %r12
   0xffffffff819f0b2d <+29>:	push   %r13
   0xffffffff819f0b2f <+31>:	push   %r14
   0xffffffff819f0b31 <+33>:	push   %r15
   0xffffffff819f0b33 <+35>:	mov    0x30(%rsi),%r12
   0xffffffff819f0b37 <+39>:	mov    0x38(%rsi),%r13
   0xffffffff819f0b3b <+43>:	mov    0x40(%rsi),%r14
   0xffffffff819f0b3f <+47>:	mov    0x48(%rsi),%r15
   0xffffffff819f0b43 <+51>:	mov    0x50(%rsi),%rbx
   0xffffffff819f0b47 <+55>:	push   %rsi
   0xffffffff819f0b48 <+56>:	mov    0x58(%rsi),%rdi
   0xffffffff819f0b4c <+60>:	mov    0x60(%rsi),%rsi
   0xffffffff819f0b50 <+64>:	tdcall
   0xffffffff819f0b54 <+68>:	push   %rax
   0xffffffff819f0b55 <+69>:	mov    0x8(%rsp),%rax
   0xffffffff819f0b5a <+74>:	mov    %rsi,0x60(%rax)
   0xffffffff819f0b5e <+78>:	pop    %rax
   0xffffffff819f0b5f <+79>:	pop    %rsi
   0xffffffff819f0b60 <+80>:	mov    %r12,0x30(%rsi)
   0xffffffff819f0b64 <+84>:	mov    %r13,0x38(%rsi)
   0xffffffff819f0b68 <+88>:	mov    %r14,0x40(%rsi)
   0xffffffff819f0b6c <+92>:	mov    %r15,0x48(%rsi)
   0xffffffff819f0b70 <+96>:	mov    %rbx,0x50(%rsi)
   0xffffffff819f0b74 <+100>:	mov    %rdi,0x58(%rsi)
   0xffffffff819f0b78 <+104>:	mov    %rcx,(%rsi)
   0xffffffff819f0b7b <+107>:	mov    %rdx,0x8(%rsi)
   0xffffffff819f0b7f <+111>:	mov    %r8,0x10(%rsi)
   0xffffffff819f0b83 <+115>:	mov    %r9,0x18(%rsi)
   0xffffffff819f0b87 <+119>:	mov    %r10,0x20(%rsi)
   0xffffffff819f0b8b <+123>:	mov    %r11,0x28(%rsi)
   0xffffffff819f0b8f <+127>:	xor    %ecx,%ecx
   0xffffffff819f0b91 <+129>:	xor    %edx,%edx
   0xffffffff819f0b93 <+131>:	xor    %r8d,%r8d
   0xffffffff819f0b96 <+134>:	xor    %r9d,%r9d
   0xffffffff819f0b99 <+137>:	xor    %r10d,%r10d
   0xffffffff819f0b9c <+140>:	xor    %r11d,%r11d
   0xffffffff819f0b9f <+143>:	xor    %r12d,%r12d
   0xffffffff819f0ba2 <+146>:	xor    %r13d,%r13d
   0xffffffff819f0ba5 <+149>:	xor    %r14d,%r14d
   0xffffffff819f0ba8 <+152>:	xor    %r15d,%r15d
   0xffffffff819f0bab <+155>:	xor    %ebx,%ebx
   0xffffffff819f0bad <+157>:	xor    %edi,%edi
   0xffffffff819f0baf <+159>:	pop    %r15
   0xffffffff819f0bb1 <+161>:	pop    %r14
   0xffffffff819f0bb3 <+163>:	pop    %r13
   0xffffffff819f0bb5 <+165>:	pop    %r12
   0xffffffff819f0bb7 <+167>:	pop    %rbx
   0xffffffff819f0bb8 <+168>:	ret

It's honestly quite amusing, because y'all took one what I see as one of the big
advantages of TDX over SEV (using registers instead of shared memory), and managed
to effectively turn it into a disadvantage.

Again, I completely understand the maintenance and robustness benefits, but IMO
the pendulum swung a bit too far in that direction.

