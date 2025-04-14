Return-Path: <kvm+bounces-43259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22362A8897B
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 19:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03ABB165DAB
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 17:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2E6C28A1F6;
	Mon, 14 Apr 2025 17:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nMaOgc3P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295D7289363;
	Mon, 14 Apr 2025 17:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744650796; cv=none; b=Dkha649vSZx6G1cRc0M0j6NZYC6vzqvCmFS+/qaqPhJdHmZEDpITF4rXYsK2XJbAQPH5A7CXYxGN3k6KgDDtIPBX42R4JhLqoFUljSIEJFJ0L8Z/lN2Sc5vbf0lBZY0cCvOAQpLaUna1pOr/nKQfr11S4x5FtDQZmaYnWmYEiFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744650796; c=relaxed/simple;
	bh=sFTaMFijVk2HZVriqjm0aoHOUR8tYLFf51KFMR53Zes=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=I1DUy43a2I3NF7bEY88nFzuxIUQN1MlNlc1HE0xkYw9y3O2fCcEH4MER/FE6SwF0eM6mI5BwHfofD0klVjBkrw3aM0p0rfQ6tzb3gu2lNvEsHHZ5Gk+Yox/tO+8IMCYQ8iqu/4EJn7V5tiVNKgBmqEquOrvh0M/lVdjmVfi0MuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nMaOgc3P; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cec5cd73bso31287295e9.3;
        Mon, 14 Apr 2025 10:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744650793; x=1745255593; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AhLhCv09lRa1OLV+bmnI0sicXwTDVpYEF9Itb4YCx/Y=;
        b=nMaOgc3PiklhM+d9MWiAlZKVIMZQZT6Zuv3q329TyWGFgsneT+xvnkofiFTJbI5eeg
         WbFwJ5bqjGqXUBEatndpqvdDF3PeMh0NBb4cNdOtjMSysRmHoVNjZPTGZt4obRcpUdrW
         +zW74MncDa7dt9c8jpr/sCjbKpbc5bnvVkdnWCJumpy1huga5VlkXWm64HEHAwFRIP04
         EBuy687pnONPg6iMuPe1VKOEBW9TF9akC3F5pTBvKjF9LXXkAQZTdHmbpIl2eQDf5zeq
         jTrh9ONS58n9lrOpRAohJyqLWOg2Z7xYnHNQqNNF+RYy/sHPstPa44eIrC85b66E6Hi7
         8RCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744650793; x=1745255593;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AhLhCv09lRa1OLV+bmnI0sicXwTDVpYEF9Itb4YCx/Y=;
        b=LpgzYMbDctPEELPzy+O3tx50+LBNoSZrM625VXx+i7/sWZawRc3tGe4gLnbbIy1QWJ
         jPNdudJQeB48aaZ6N4FE2Kp8gI0F/bA7cHgA6S8vyoMvqBjPRUsIeSYxKBHhAjFOm8av
         IshXuEvQ+17q/ZjJ7SQiQNQU9ho5nro/kkqxIrC/rQuyeDdYQVG3DoRJCpMMSqOckXJS
         MMOTqpVq+E0eDG5i2h+HabMjtG7FZK9UR42iPr1wx4Kg2fjZ1nxTNjStSxCuEfGJJfd2
         cv4gMLbwN8BVACe69Ly/ggxE5KSb54kc5cmwlqQV48df9rDKgXw3BUhjlPCZbj3wG2Xa
         hmsg==
X-Forwarded-Encrypted: i=1; AJvYcCU2bXY16glnlasVviZBRNs7rhH3BqilJMPBctOkJOqxaxbOGedhiY6lRVz4TeHjNxIqULKcJj1pn4K3Gw==@vger.kernel.org, AJvYcCUJnxaJO405Mmv2grjO3ZNca6FCL81MjvTjrFSRjF6Y364+21+q/avj1sNmdVkcJoXkchbTKp586lrHmGs+@vger.kernel.org, AJvYcCWNuB5d3gRwsGwmOLGIr2NQtOFbwYypozyB5EiuLTfXtDsQ4V5uoLh2l/AErOpOxLQ4goVXRsx93vG/mQizVjnWVg==@vger.kernel.org, AJvYcCX089GhHkpR8DgZ36gCYB7kTm5nFtfWyZxmTRHUyziTT3HXdPaYG57zN2K8v+vXzcT5qH2+qJ5op/hm@vger.kernel.org, AJvYcCXWOCRSq4ayoXe2if1ippPVwtY73gXqF2NeTrTf9l0qAWWxXWQOp6wzEWWCYd+ISR46QdA9@vger.kernel.org, AJvYcCXX8T9cwWgYaF3RUduEGhzVZYayp86CyVE1JdS4IAqQoIM5LEG9dEtZf03MWuq5CcUe2+92y1Qsvvo=@vger.kernel.org, AJvYcCXaUTHpJF+A86OGgtKPZUAm2HWt6yBoWc/6Rx8AoCQgr9FPp8aAJl9OEYb+D28HpahI2AQbPrawTLA3UZCT@vger.kernel.org, AJvYcCXznFYsrzaoQWy6I6/a+Rpe0q04KZOmXudOrcpsOqNBeFmqiTuTmmnsAppNDYXMuQ9VUlY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3agagxpEWagA3o+53FldiLAYBp7FKG848P80I4niseUb5PaP9
	8UN1UsDs581NeliTqVILmgK8GIcQ8se3wGGrH8qUycjT4ht6FWqK
X-Gm-Gg: ASbGncvinEuaSivMXvGOZhqNrzCY4jhXYIb2sX26eBBgs9otwWnh5ucjnV10drX4GHs
	iWOj2kq+1BgL5czuFlPfVam5t9tijcNI258JYyby1z9UnZTQcHxzCTUcZk/QgvwclPhTFUqeZsU
	pT5YzJIazUIdXNCZlOumNtsqheI28h1n6oIEhQCnmxCbUsga7hp83kKelNE8nUCWtlPDLxXjmcd
	RZfY1tYR5MHLeVBMJGwFzp03zPbMad+hV/mn80cQgtT0srj0HaAZnSXvR7JtgDa7PkqEO/+wYUs
	0FBq1pjmq20IWkgNF9FvnejuJqECmL0+lJ8vXJZ2/bJbIusjQWxiJ2c8LTujElfQqXsOWIuZ2AA
	sEdqKYlzrzE1JXaip9R9MTw==
X-Google-Smtp-Source: AGHT+IFaPusiZQT0QiFcyLJp0TXK65g3+z16rgMNv9l2dKvCZ0RLPJLCBzoBrYTr6CV/HfnsWx9kLw==
X-Received: by 2002:a05:600c:8519:b0:43d:300f:fa51 with SMTP id 5b1f17b1804b1-43f3a93ebb3mr115773795e9.9.1744650792986;
        Mon, 14 Apr 2025 10:13:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:74f6:abb7:53c9:817c? ([2001:b07:5d29:f42d:74f6:abb7:53c9:817c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f204c500bsm191180875e9.0.2025.04.14.10.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 10:13:12 -0700 (PDT)
Message-ID: <0f4f2ed70829fffb2eb816e34e26be22681705a5.camel@gmail.com>
Subject: Re: [RFC PATCH v1 13/15] x86/msr: Use the alternatives mechanism to
 read MSR
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: xin@zytor.com
Cc: acme@kernel.org, adrian.hunter@intel.com, ajay.kaher@broadcom.com, 
 alexander.shishkin@linux.intel.com, alexey.amakhalov@broadcom.com, 
 andrew.cooper3@citrix.com, bcm-kernel-feedback-list@broadcom.com, 
 boris.ostrovsky@oracle.com, bp@alien8.de, bpf@vger.kernel.org, 
 dave.hansen@linux.intel.com, decui@microsoft.com, haiyangz@microsoft.com, 
 hpa@zytor.com, irogers@google.com, jgross@suse.com, jolsa@kernel.org, 
 kan.liang@linux.intel.com, kvm@vger.kernel.org, kys@microsoft.com, 
 linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
 llvm@lists.linux.dev,  luto@kernel.org, mark.rutland@arm.com,
 mingo@redhat.com, namhyung@kernel.org,  pbonzini@redhat.com,
 peterz@infradead.org, seanjc@google.com, tglx@linutronix.de, 
 tony.luck@intel.com, virtualization@lists.linux.dev, vkuznets@redhat.com, 
 wei.liu@kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org
Date: Mon, 14 Apr 2025 19:13:09 +0200
In-Reply-To: <20250331082251.3171276-14-xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2025-03-31 at 8:22, Xin Li (Intel) wrote:
> diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
> index e672632b1cc0..6e7a9daa03d4 100644
> --- a/arch/x86/xen/xen-asm.S
> +++ b/arch/x86/xen/xen-asm.S
> @@ -399,3 +399,37 @@ SYM_CODE_END(xen_entry_SYSCALL_compat)
>  	RET
>  SYM_FUNC_END(asm_xen_write_msr)
>  EXPORT_SYMBOL_GPL(asm_xen_write_msr)
> +
> +/*
> + * The prototype of the Xen C code:
> + * 	struct { u64 val, bool done } xen_do_read_msr(u32 msr)
> + */
> +SYM_FUNC_START(asm_xen_read_msr)
> +	ENDBR
> +	FRAME_BEGIN
> +	XEN_SAVE_CALLEE_REGS_FOR_MSR
> +	mov %ecx, %edi		/* MSR number */
> +	call xen_do_read_msr
> +	test %dl, %dl		/* %dl=3D1, i.e., ZF=3D0, meaning
> successfully done */
> +	XEN_RESTORE_CALLEE_REGS_FOR_MSR
> +	jnz 2f
> +
> +1:	rdmsr
> +	_ASM_EXTABLE_FUNC_REWIND(1b, -5, FRAME_OFFSET /
> (BITS_PER_LONG / 8))
> +	shl $0x20, %rdx
> +	or %rdx, %rax
> +	/*
> +	 * The top of the stack points directly at the return
> address;
> +	 * back up by 5 bytes from the return address.
> +	 */

This works only if this function has been called directly (e.g. via
`call asm_xen_write_msr`), but doesn't work with alternative call types
(like indirect calls). Not sure why one might want to use an indirect
call to invoke asm_xen_write_msr, but this creates a hidden coupling
between caller and callee.
I don't have a suggestion on how to get rid of this coupling, other
than setting ipdelta in _ASM_EXTABLE_FUNC_REWIND() to 0 and adjusting
the _ASM_EXTABLE_TYPE entries at the call sites to consider the
instruction that follows the function call (instead of the call
instruction) as the faulting instruction (which seems pretty ugly, at
least because what follows the function call could be an instruction
that might itself fault). But you may want to make this caveat explicit
in the comment.

