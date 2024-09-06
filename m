Return-Path: <kvm+bounces-26034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C0EA96FD30
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 23:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C592B22050
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 21:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A820158543;
	Fri,  6 Sep 2024 21:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ogfewqEJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F5D13E03E
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 21:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657361; cv=none; b=eertUPRiYR4il+CWE/XrGG5A3EV0T0SuQAT2tu7IdG4w+XFn5ZmuV1+pbT3f2LygZZfqasXAJhA76N2M6KE4nmQ966b24TypwpF5xULqLJaVKc/ViFpG6qiXuBr90Ez3bnahyVFIoSIgiLm77afGckojrzZrYR28fG5hI6+kTqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657361; c=relaxed/simple;
	bh=eMxGOodtBW2fNQBcV/Vjo5HBI+UPeio/fR7QHQkm+0M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cQr1EGVzrM86zzo9yW33yxutWONL+BerZIArgyYwz9ZcEqe3cqDJyBdcDn6KStDwTpkzBCahn9aI5dzqZvtrZZWcfTpxinlIuhrQBYsIxWlz0aOuQvf1He9JGHJ9zVgDP0hzFY/LuFr4GMdr2Wt9E8Uz2EiL1LdKHdUXZfKX8WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ogfewqEJ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0353b731b8so5948550276.2
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 14:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725657359; x=1726262159; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O0pikVsuPIymy9mQcsYH9buCVbx4mgvVE8xCp4ufTvM=;
        b=ogfewqEJY2lep2vTK8ylVwsd0cZ7PRTEwzMaDERa9GpKd2iJJbjacssJy0ulKFjMAN
         VIiNIBzznbOSk5TZEHauR3UsOKoqK6TBIM84z0gkurWzAkxZwUNY5Ky5Nza7e0iwRNo4
         ta0b9ap/Gb70Bow9/Lwie70GmBXlsQ/DA7KrxF4O2DVFNA/VDvLI2l6DYnsZAShJuEHW
         R5kKuFjF/V1u8sfok3LM9p3uqVUFmaqfJ3690fMJIhpnwYj5SLR7L1869A7kbwV0x/yX
         9L0we+DfckGA1mhWZD0dpQv5yjb3ZQtcbEMfVlPhvONjhk4BO2CT40KlHdd64IjdMkNh
         8D8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725657359; x=1726262159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O0pikVsuPIymy9mQcsYH9buCVbx4mgvVE8xCp4ufTvM=;
        b=YndC5lHexuXIMC4ide7SVY9AEYR2v4pxTLjyYY//RJSLN3Vref9aa3/t67MtBRh3Zd
         807Ike0jw5R/nigED++JdWVOuOWoQOCJGo9sR3iJqH2jiho4163qLI4ddE9LYKdBhBAC
         zdClLMRw78gp0won1zawzGYpncobUHca4QVj0oE3pNYPFDHdwemy8t9r6dJyTaJk1RF2
         V1PQMSR0wozeMBIaAWVf7p6f5DW/bQeyqa3iHO05vP0e+Gx8ugskM3mHPfeOhiQeKHcY
         niQcXzsPmtivuEtAQUgQNXSLqJnu5gqMc27QmAVd2u/ouKNM4y84VzA9PyUZWM5Pxq5c
         3DRg==
X-Forwarded-Encrypted: i=1; AJvYcCUYQDvtlI4qYiqoA2MEu+PwBv7qiYh0JqIyzn/ZFt7Qbh/TUj18YSfDvtlhrZzxaRvK6X4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx58wusaOrqqglmwGDQjEpVe0mqdvJc2QilRwTfFMCE1eubl74z
	5V18Iq87GPFWm0/neptdK7U3ZgH0vRJCvxyeyai0BnORLsKgpTYCuIGCXUPEBfOwY7PHXo+338d
	XtQ==
X-Google-Smtp-Source: AGHT+IEhyXOb6ueTZoO2nNI//nUTPRUCj/uBjHhClAJ2CXjFjvXhugvAh2XP6oo8m69S1gMkq9KL2itwG4s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:81cd:0:b0:e11:44fb:af26 with SMTP id
 3f1490d57ef6-e1d3485d963mr6031276.2.1725657358725; Fri, 06 Sep 2024 14:15:58
 -0700 (PDT)
Date: Fri, 6 Sep 2024 14:15:57 -0700
In-Reply-To: <y2vqv2k6b3ytwgvxkhl3jlxx2lpfcla6zigccuo426zp63lqgl@zvdztkpwuxed>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240902144219.3716974-1-erbse.13@gmx.de> <y2vqv2k6b3ytwgvxkhl3jlxx2lpfcla6zigccuo426zp63lqgl@zvdztkpwuxed>
Message-ID: <ZttxDQ6v-1OAVja9@google.com>
Subject: Re: [PATCH] KVM: x86: Only advertise KVM_CAP_READONLY_MEM when
 supported by VM
From: Sean Christopherson <seanjc@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tom Dohrmann <erbse.13@gmx.de>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 06, 2024, Shakeel Butt wrote:
> On Mon, Sep 02, 2024 at 02:42:19PM GMT, Tom Dohrmann wrote:
> > Until recently, KVM_CAP_READONLY_MEM was unconditionally supported on
> > x86, but this is no longer the case for SEV-ES and SEV-SNP VMs.
> > 
> > When KVM_CHECK_EXTENSION is invoked on a VM, only advertise
> > KVM_CAP_READONLY_MEM when it's actually supported.
> > 
> > Fixes: 66155de93bcf ("KVM: x86: Disallow read-only memslots for SEV-ES and SEV-SNP (and TDX)")
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Michael Roth <michael.roth@amd.com>
> > Signed-off-by: Tom Dohrmann <erbse.13@gmx.de>
> > ---
> >  arch/x86/kvm/x86.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 70219e406987..9ad7fe279e72 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4656,7 +4656,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >  	case KVM_CAP_ASYNC_PF_INT:
> >  	case KVM_CAP_GET_TSC_KHZ:
> >  	case KVM_CAP_KVMCLOCK_CTRL:
> > -	case KVM_CAP_READONLY_MEM:
> >  	case KVM_CAP_IOAPIC_POLARITY_IGNORED:
> >  	case KVM_CAP_TSC_DEADLINE_TIMER:
> >  	case KVM_CAP_DISABLE_QUIRKS:
> > @@ -4815,6 +4814,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >  	case KVM_CAP_VM_TYPES:
> >  		r = kvm_caps.supported_vm_types;
> >  		break;
> > +	case KVM_CAP_READONLY_MEM:
> > +		r = kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
> 
> Need a break here otherwise -Wimplicit-fallthrough option will warn.

Heh, Nathan beat you to it:

https://lore.kernel.org/all/20240905-kvm-x86-avoid-clang-implicit-fallthrough-v1-1-f2e785f1aa45@kernel.org

