Return-Path: <kvm+bounces-61894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B84DC2D56F
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:04:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 24B8C4F159E
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 17:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504D8322C81;
	Mon,  3 Nov 2025 17:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uh0coHKJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1633F31DDA0
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762189252; cv=none; b=Gv+tggFkF1+RJYY7OVJz/vALa+IbaWpwHCfThlBe1KSLs0XjhTK6H7J99OehJAUflifZ7EDvvQlcBDSfWEMztFnPR87o+OsOx/SwTIHXiMIUR5xn1aY6ejtcLEXvfxnpQuueTCh/fuEE7iOUos0C7n82Z6QTlxSWC3fxOpvIV+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762189252; c=relaxed/simple;
	bh=epEz5JO14EzdvaM0l5sjchiiiWhS1f9DBzocBK/FLHk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ULdOFJ8mLgDmvQ1ajkCiEsZv/pDbVImB4LeMwOnEE4J/4CwXgTpXxk1bJth1Qr8CrNobW2cl9jyvA9gko8UgLkR1HLNHm0Dpb7zAliAOSqv/XYKZ4YhxXb1/Ro/Orf60N2FaYEDOG7rYndWYIhRm3Hm/uhynZdrBACmuk6IRhK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uh0coHKJ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b9a72a43e42so1279405a12.2
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 09:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762189250; x=1762794050; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6IRIo7fpurV9GwKBfgD4OHFoa2+Cu2Rk9LbA8Fikj3I=;
        b=Uh0coHKJorT4bPh9+27hakbFp4SE4YVDoB8nPNi2YjGoJmOHB0n4LNmFyUqRYotYCK
         0ySBYU9xkfiiKaRYBq5mRXVDZ6rZJdOMXiWPIZYmizl+V0gZrc2kG6U2lkE7VLgEzzjx
         pewFtKE15qEDrDPb9I4J22uAuJ903S8psqXznAHXhVvD+oa2u9RoJc2Pe3xzXiO7psbs
         X9EhG/+4M1XLznvAfo5N84Oh6aadJg88FfWVIgkzC0FsUzJR0rP6rs0ya5+n7AVf8qzm
         AK1VGBzWfdWao97K08AhDabmDL/cqCw5P/Onj3ePhPz95x21/lhsA2TRozMiJu1B5ThO
         T2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762189250; x=1762794050;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6IRIo7fpurV9GwKBfgD4OHFoa2+Cu2Rk9LbA8Fikj3I=;
        b=fxRMhDl84S4u+gD1kIXlTHJtwjzDC0WoPKBc8G5XiKh5aoX+B2XPy9HM9GPS63bZxu
         sw/ogwm0DJMBsexbMpaCyc4DyF+pGEc3BfN8S3bc6GrBA+FIJFscSOAUR8ZsNyRh75ey
         ksh/0NC4jEP5jdtIUMc+MbCH6Hunf5OAItbS7odGe6sGNNtz8BKIirWGKns8I3Has5XZ
         yl4YSxXC0QQDnn1qXAJpZtA9h6JAjkMxZpAij5qAdBFiT/RG5Xn/RXkjxUe5hWmzhJ07
         9Fqjsj8pj6h48RdRSlIRThgt01lB56ZueAZD6+bZtnW418Gc/ULneZBngI5WUbdHcPdG
         76ig==
X-Forwarded-Encrypted: i=1; AJvYcCV6tX5/lTjL28cTQgXYZVtf1h74skW+wE6UnWqWkyAuX7InYuYoGBhhETmS7eAFA0OTnsc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFWjz2OxSlUq0M6tQyf1JNyZHMFwTZEkt07uQC8SwUEMTDzDJr
	mvE0g0udNwlqu2eAa83EzNr9leU3rC74pN7aUUbnX7M4J2uzy0F/Xooga4Hu5/JyLYn89Cc4UE/
	IgdXYoQ==
X-Google-Smtp-Source: AGHT+IF4lU1MjPjgJlhY3ic7+3CyBeck4ktMoovFtnCRGs7Fp/0cEW7DY9B8zdM7xq780PsQFsocJ4vjmC4=
X-Received: from pjqt18.prod.google.com ([2002:a17:90a:ae12:b0:340:c0e9:24b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:185:b0:290:9a31:26da
 with SMTP id d9443c01a7336-2951a37a3d6mr188846515ad.16.1762189250233; Mon, 03
 Nov 2025 09:00:50 -0800 (PST)
Date: Mon, 3 Nov 2025 09:00:48 -0800
In-Reply-To: <20251101041324.k2crtjvwqaxhkasr@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-3-seanjc@google.com>
 <20251101041324.k2crtjvwqaxhkasr@desk>
Message-ID: <aQjfwARMXlb1GGLJ@google.com>
Subject: Re: [PATCH v4 2/8] x86/bugs: Decouple ALTERNATIVE usage from VERW
 macro definition
From: Sean Christopherson <seanjc@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 31, 2025, Pawan Gupta wrote:
> On Thu, Oct 30, 2025 at 05:30:34PM -0700, Sean Christopherson wrote:
> > Decouple the use of ALTERNATIVE from the encoding of VERW to clear CPU
> > buffers so that KVM can use ALTERNATIVE_2 to handle "always clear buffers"
> > and "clear if guest can access host MMIO" in a single statement.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/nospec-branch.h | 21 ++++++++++-----------
> >  1 file changed, 10 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > index 08ed5a2e46a5..923ae21cbef1 100644
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -308,24 +308,23 @@
> >   * CFLAGS.ZF.
> >   * Note: Only the memory operand variant of VERW clears the CPU buffers.
> >   */
> > -.macro __CLEAR_CPU_BUFFERS feature
> >  #ifdef CONFIG_X86_64
> > -	ALTERNATIVE "", "verw x86_verw_sel(%rip)", \feature
> > +#define CLEAR_CPU_BUFFERS_SEQ	verw x86_verw_sel(%rip)
> >  #else
> > -	/*
> > -	 * In 32bit mode, the memory operand must be a %cs reference. The data
> > -	 * segments may not be usable (vm86 mode), and the stack segment may not
> > -	 * be flat (ESPFIX32).
> > -	 */
> > -	ALTERNATIVE "", "verw %cs:x86_verw_sel", \feature
> > +/*
> > + * In 32bit mode, the memory operand must be a %cs reference. The data segments
> > + * may not be usable (vm86 mode), and the stack segment may not be flat (ESPFIX32).
> > + */
> > +#define CLEAR_CPU_BUFFERS_SEQ	verw %cs:x86_verw_sel
> >  #endif
> > -.endm
> > +
> > +#define __CLEAR_CPU_BUFFERS	__stringify(CLEAR_CPU_BUFFERS_SEQ)
> >  
> >  #define CLEAR_CPU_BUFFERS \
> > -	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF
> > +	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF
> >  
> >  #define VM_CLEAR_CPU_BUFFERS \
> > -	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF_VM
> > +	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
> 
> Sorry nitpicking, we have too many "CLEAR_CPU_BUF" in these macros, can we
> avoid adding CLEAR_CPU_BUFFERS_SEQ?

AFAICT, there's no sane way to avoid defining a macro for the raw instruction. :-/

> Or better yet, can we name the actual instruction define to VERW_SEQ, 

Works for me.

