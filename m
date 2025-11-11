Return-Path: <kvm+bounces-62821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B80C4FF0E
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 23:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B91F93A8131
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 22:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBDBE326947;
	Tue, 11 Nov 2025 22:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KtYkq7o4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF61C23D7DC
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 22:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762898624; cv=none; b=n4YYtCPBAzCe9JbBiPwwOaDRBDAfUC4fTlJGekcyL2VIPphH3gnnUlklNRVHcpibSbtazPdbk2rApfs4rH7IzwWRVcv5NFdG1yp9ILB9vy0nax7/EweKZoDJ0HOEUMNYshnE17b8WCj4RmqmuD1iDEzhOk1lGDlpWobvxu/wKDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762898624; c=relaxed/simple;
	bh=P3IO985UeGPgo5n+w9JIIfOW1qFbKma51AbTx+goFw0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MTlnbaOWWViCSQcosO2FJPyYhuauT7OnfihewTcuumD81g8ak6yGuRToiAoyMTdrZEjFQZQBn4hKZ64hB6/pEQ7Cr7l+6Pc+jXW196t638haVVDcKAOpZaE5q9ZIWpcePz92XZJ0XNgrklzT4MBXkkWfg1grLubQvtIrNidoHMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KtYkq7o4; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7aa9f595688so297453b3a.2
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 14:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762898622; x=1763503422; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KbpCdR4ZoDgfSokixVN9qK5K1buE+rWLn5z25ElA0oI=;
        b=KtYkq7o4e66XIMKiNL5KM+Z320+l0fPValZCYKf2ipfdybQMlB7k5AS3r3WMPaP6oo
         Jo6Dh6ephASlgMzMiHWU4vyEPUzZi5+JAJjENrugUnJpnJ707aVyIQwf+hfDSFXuccTM
         jrDbDyqpK/UNaqyGq36AnmUZkIWObb379fT09PXp4Cl0TTJxoC5+VP0lc1exu7gje1sf
         gu0VT27h+fACEPig8alc46n0Famrzc1j9U8BIQ0aHiitH+gHOop0O7lsGYHWYFUiaB0z
         3EMeEJ1rAjcN+2hWJqhNY1K2OsowOINO1RFomzFOwjErX6H1aNt7iTUDgEYXQ3HvXieW
         4OfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762898622; x=1763503422;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KbpCdR4ZoDgfSokixVN9qK5K1buE+rWLn5z25ElA0oI=;
        b=aEmTf6zCdJssTrQcdgS5jbv06+btvN+QpWtFXqEt5IENZImc1IsEbd9AfC1ijQRm/a
         QnzVzGcUt6XQIUSC5Yi+/Za/9H+GyiCe9n3S9UK6O+1iwhchGczY1Bevbd9ZzDQ6sIF3
         LX87Q9h++86n+oewwQhpwj3NBp3ZPpqNK5BW3qErtScCV+KwyGUg26flekgDK1YbskSe
         YRzOdo/I/+JeMJivHkYYyU2TtYwJvz2JE15AsmHJF2kBqAWOVS+5RMzxdShtP7tgeWMK
         IChY4Nv2oMXVpi40VfuDRkhWtzLtY53P09bS9tq/zWG/yyqODDUvGqKAUvczyaOVYm+H
         /TLA==
X-Forwarded-Encrypted: i=1; AJvYcCVYK9MIUPYdyBqlaj7Xv2pFGlaNDJ5tsKyArKMg3GO8nYPXHv/nrvUu6khCFyxnO4oNskc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiL+5140sUYAnuEWvQZwORakafprsJK04gMcLuC9ZuOpvFWbPi
	s9FB86Qiz09seTcE/9Fe/Vbnx4ge3rezoghaNyVeOZgrVp39pKLCFOQAdVQ2c/IR/Td3IA5K66w
	Z/cs+sg==
X-Google-Smtp-Source: AGHT+IG2OX9by+gRk6KXY2gIknfbeeJ6jUNBwEq6BQRV737htpu9tNGRhCQVKub87SnNL/+3BP22reUnOkk=
X-Received: from pgct20.prod.google.com ([2002:a05:6a02:5294:b0:bbf:9fd6:ee92])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:748e:b0:253:1e04:4e8
 with SMTP id adf61e73a8af0-3590c00a2dcmr737871637.56.1762898621804; Tue, 11
 Nov 2025 14:03:41 -0800 (PST)
Date: Tue, 11 Nov 2025 14:03:40 -0800
In-Reply-To: <20251107190534.GTaQ5C_l_UsZmQR1ph@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-2-seanjc@google.com>
 <20251103181840.kx3egw5fwgzpksu4@desk> <20251107190534.GTaQ5C_l_UsZmQR1ph@fat_crate.local>
Message-ID: <aROyvB0kZSQYmCh0@google.com>
Subject: Re: [PATCH v4 1/8] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 07, 2025, Borislav Petkov wrote:
> On Mon, Nov 03, 2025 at 10:18:40AM -0800, Pawan Gupta wrote:
> > diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > index 08ed5a2e46a5..2be9be782013 100644
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -321,9 +321,11 @@
> >  #endif
> >  .endm
> >  
> > +/* Primarily used in exit-to-userspace path */
> 
> What does "primarily" mean here?
> 
> $ git grep -w CLEAR_CPU_BUFFERS
> 
> says *only* the kernel->user vector.

How about:

/* If necessary, emit VERW on exit-to-userspace to clear CPU buffers. */
#define CLEAR_CPU_BUFFERS \
	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF

> 
> >  #define CLEAR_CPU_BUFFERS \
> >  	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF
> >  
> > +/* For use in KVM */
> 
> That's why the "VM_" prefix is there.

Ya, and this goes away (moved into SVM) by the end of the series.

