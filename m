Return-Path: <kvm+bounces-38103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD660A35326
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 01:42:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0383F18914DE
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 00:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587B038F82;
	Fri, 14 Feb 2025 00:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iw7tTwYI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E590317E
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 00:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739493654; cv=none; b=luVbRI2tryFd0rc0vKErnage6LGKe/mitFKZeU42umNR7LlQ7WuNAPBnhvijxuL+8ppAmV4ExY8aiSo3CINtul9jbtv2MbapkUAvQu9CHpEfPlty156jS8O8r5M0Fsxx3Op/o6Y4n0usJdbwy1+JKk0Z0R3rz21pH6Z0HSjRGn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739493654; c=relaxed/simple;
	bh=oshhADdaU0DK/NrnmxgfGzcl8lJQMDH7dEKyxcJmwTU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BHu/j1jmGQKSrKClKi/g8w9WIXNww657IlHxEA3ZgFzpVZK1xOgrd+KJyjY66WPvAge0PWgAUwvfX13C9R3Vo9E8GG8/7Dy704t+2uwwDHMLkRcEth9ASorx5lnGf1dsW7YIRVRnJGCi7r6LoP7HXxJYHSb4xPwVCIHBXLxlxBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iw7tTwYI; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220ec5c16e9so6973545ad.1
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 16:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739493652; x=1740098452; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x45uHW/9XYP5wRbdxJaBIYSa/pl3u4cjGPLtpEx1xbY=;
        b=iw7tTwYInCI9jERD64QFCM19YBnDMKKrVbrH4IK6J2/NmwloceLTqp/ProHOezpDds
         sboaSk0Hom3Vfzs2uEWq6jVFRVCe++sK41YeokOhHudzSA1y+3FMCGvqzfWgEE4uVWy/
         uE4wkAA5352VvZB5aQpUrRHLHrloRzGtzcg4elylIRDuxGWz0JfUGEFT8GAUE7KANH/R
         Mjab5Z8uL2t62V2kRtJ8p2pI9LKbx9jMdLTnzGGIqdKCkhdE8R73tm4L6cKNJ7Dev32E
         D51sawS7fkG/clcPRphHewgjrFmZLcP4bkL7T1FONAqTQuUWWQAlExPY0F57tkPmFR4w
         7GDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739493652; x=1740098452;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x45uHW/9XYP5wRbdxJaBIYSa/pl3u4cjGPLtpEx1xbY=;
        b=lswyWEdLMQXLCI2GnQirL6fQxeW2diqRJZkcIGoS+z3wCoo5ZaK/NoWJcjHqWhmlk7
         bVSwWYrJ6xqRG6uXP5j5cbAjC+cr4fW66ScpPXmUu82NAohEBGq+S9xwG1ahXOxvBtNq
         KpIDP6tVLpvBgYM0eHOlrfyHk9GXF0DyaWsDvMyL0Oh6XN5XQJ73bS2vjRP+zL6m8h6/
         VPnhYLjYPBJop4NNtx8Msn2MX2OaNtqiehOJGHkKGF5qR4uyt34xZYguBHz7EWQUAx8q
         V6rmifE6+tn4qRRAA/hu+YzyAqoUchA0dG+6Jx9CO2J+lF1prab4Y4HROXi2zNK6dUFd
         FkwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWq1qPC9zmRT/lVSTLbQno3e+zLT/qdZOGJW8MQzsuwhq8G+XVT5WJxy9N0HYqz/8XHlWM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAR6paJEfeQBNSRzXB3l5mLCA+Zy2uu4xIXNXD4u6jff/xML46
	7viTSUbav2UpaVB9hBqphOpAFslSGM3PfvF4DZouZpkNel+AzMgv5fZ9EMrjLg7wUkEgas2gLM7
	gyg==
X-Google-Smtp-Source: AGHT+IEORtIoq0mZhJ9ZLmmQyLs5AIcdD1Z00r/nxGW72T49fVbNgVu/I9z5KFMgKaZoX1G1ZClI9WaO4yU=
X-Received: from pjbli9.prod.google.com ([2002:a17:90b:48c9:b0:2fc:11a0:c545])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d543:b0:216:501e:e314
 with SMTP id d9443c01a7336-220bbafa000mr149170335ad.20.1739493652206; Thu, 13
 Feb 2025 16:40:52 -0800 (PST)
Date: Thu, 13 Feb 2025 16:40:43 -0800
In-Reply-To: <CACZJ9cX2R_=qgvLdaqbB_DUJhv08c674b67Ln_Qb9yyVwgE16w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CACZJ9cX2R_=qgvLdaqbB_DUJhv08c674b67Ln_Qb9yyVwgE16w@mail.gmail.com>
Message-ID: <Z66RC673dzlq2YuA@google.com>
Subject: Re: [PATCH V2] KVM:x86:Fix an interrupt injection logic error during
 PIC interrupt simulation
From: Sean Christopherson <seanjc@google.com>
To: Liam Ni <zhiguangni01@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, Liam Ni wrote:
> The input parameter level to the pic_irq_request function indicates
> whether there are interrupts to be injected,
> a level value of 1 indicates that there are interrupts to be injected,
> and a level value of 0 indicates that there are no interrupts to be injected.
> And the value of level will be assigned to s->output,
> so we should set s->wakeup_needed to true when s->output is true.

Neither the shortlog nor the changelog actually explains the impact of the bug,
or even what's being fixed.  I rewrote it to this:

    KVM: x86: Wake vCPU for PIC interrupt injection iff a valid IRQ was found
    
    When updating the emulated PIC IRQ status, set "wakeup_needed" if and only
    if a new interrupt was found, i.e. if the incoming level is non-zero and
    an IRQ is being raised.  The bug is relatively benign, as KVM will signal
    a spurious wakeup, e.g. set KVM_REQ_EVENT and kick target vCPUs, but KVM
    will never actually inject a spurious IRQ as kvm_cpu_has_extint() cares
    only about the "output" field.

And that's of particular interest because this fix uncovered a latent bug in
nested VMX.  If an IRQ becomes pending while L2 is running, and the IRQ must be
injected (e.g. APICv is disabled), KVM fails to request KVM_REQ_EVENT and so
doesn't trigger an IRQ window.  But the spurious KVM_REQ_EVENT from
pic_irq_request() masks the bug (I didn't bother tracking down how pic_irq_request()
is getting invoked on nested VM-Exit).

I'm applying the patch in advance of the nVMX fix, because the PIC emulation goof
only helps with fully in-kernel IRQCHIP, i.e. if the PIC and I/O APIC are emulated
by KVM.  E.g. the vmx_apic_passthrough_tpr_threshold_test KVM-Unit-Test fails even
without this change if it's run with a split IRQCHIP.

That said, I'll ensure the nVMX fix lands upstream before this (I'm planning on
tagging it for stable and routing it into 6.14).

> Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
> ---
>  arch/x86/kvm/i8259.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index 8dec646e764b..ec9d6ee7d33d 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -567,7 +567,7 @@ static void pic_irq_request(struct kvm *kvm, int level)
>  {
>     struct kvm_pic *s = kvm->arch.vpic;
> 
> -   if (!s->output)
> +   if (!s->output && level)
>         s->wakeup_needed = true;
>     s->output = level;
>  }
> --
> 2.34.1

