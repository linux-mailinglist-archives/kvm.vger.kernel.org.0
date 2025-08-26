Return-Path: <kvm+bounces-55709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 51ABBB3502F
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 02:27:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 754FD1A85411
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 00:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31E5230D1E;
	Tue, 26 Aug 2025 00:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n4b7hxDj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C61221F26
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 00:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756168042; cv=none; b=sC5aomd0d2bW2+zwuQaxSkLUA6DD7lYfZS+2gStDS4ijhqUkKVgUcbOfI8GHfTfb2+60QCLgZHg7BFCmX2rhn5xZ/WjSurkPPJMXA/+t8fTn0v6PvbKgJFyAedzZFiGtmroWRzbzf9bM2Tb5hcSgBVeYvTc2plmwgq4M2BEGDD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756168042; c=relaxed/simple;
	bh=5L/BYqW9WfoHeTEgYYwzNBfWpjlpn5EeY5J3QpRZyJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bR0s+nqnck2jpZEmzUc2dAVprp53phpZOSSQxKkJflePF0ZeigmT647diItH9gPotyJWlIySxi8thFX1DFMN4351tEne98VSijhLb1H5sZvdjV8/dfVr3ByCgqIczyX2/DXCkikQ1zVW0pWfgb2T07YQpDNBEFtHFLQC48jbbBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n4b7hxDj; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b49d8b818d2so3100834a12.3
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 17:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756168038; x=1756772838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U4ctZNwYJMz9+Hk7ge9l8ZiYDw45Y30bqY3Iaj5/gqE=;
        b=n4b7hxDjBfsYt0uo0RfIS9dGgRYXS/+wwLACNSNY+Xm9lRam3a5GDARVarSgxrejel
         ktbfj0bz9umQd6oMlGqcS3rqPytnbUyaDxIggjuaF8bL8hv/A40g9pBFTOvlHYwKM5Ye
         FxgbdtsR6k08cF5FGqqAGN2DrfqEiX5yTq5KYTr3KtyF/oK/a90OzE89CgoWctTwHUaP
         Uu1DpinhMouJHp+P8+644CuXLhLdlBAGUVCmE6Az0O88+HOt04WcLJNMgxd3FIE65UVF
         98e8o9ohfeVYsJtqmQUPRLONp8wjpwWffrh2jt4wXAPV/pELpXeGUumV5FkHKeJ+hbJh
         BR3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756168038; x=1756772838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U4ctZNwYJMz9+Hk7ge9l8ZiYDw45Y30bqY3Iaj5/gqE=;
        b=hS1gwTVVvE58BNK/UQv25UPpQRvYq80sJbJwz8FXepDSCGS/7I0Z13/jmfAjVw717r
         PlVsL8EG+L/jKIxncTsNFOfnXwGFQK+8HiHRxosa6SXhTX2BsM9Qchcaxa7oXu3hcyA4
         9L7COmY2+vxwzuKoNPTpRtDF1WUOyCRszSbaQh/k+YafH/yKaS24FHtZV/Z4JG4OsQh4
         BV4fAvUoQ48YwWuJG9AMptAWgUoTYU+SnLxg4rQiUc29KGzg3pyycmqJ3flXqIx7Jmzw
         8/X4EwiRaXUkR6JMr8T0PObEOv6Ms/aX23hvVTxNUBdkQAvi7GMu7qj7lG83vJGAxfCN
         sSCw==
X-Forwarded-Encrypted: i=1; AJvYcCUmU6h68qFq0gsUab9OsDeYk0r99oPfiUD2jkzVcFpXhXNREMYPi6sUGAc9DU7rd5+bPhg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSqsGrd4NdfCWOT/pX+mZ1jXloaLIccs5phAMuFbadhMN7sGDW
	rBr4JndzgzgFKJBepSrOSAbSt0iZwP/QN4h7g1yvB51o2k5nhrmpuFuMkDBYlvz1qfR8l6UZO+G
	vDAiR8g==
X-Google-Smtp-Source: AGHT+IFw5Mjf6HTcAUWU+u7CL/B6QAA0945o29LTS2VrhL4i1mL+9cXlmfjB4AEyc0iYoyyJlQoJr1vqexM=
X-Received: from pjbsp15.prod.google.com ([2002:a17:90b:52cf:b0:30a:7da4:f075])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a105:b0:230:8b26:9d47
 with SMTP id adf61e73a8af0-24340ab318emr21164734637.10.1756168038330; Mon, 25
 Aug 2025 17:27:18 -0700 (PDT)
Date: Mon, 25 Aug 2025 17:27:16 -0700
In-Reply-To: <3188ca61-2591-4576-9777-1671689b7235@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250825200622.3759571-1-seanjc@google.com> <3188ca61-2591-4576-9777-1671689b7235@linux.microsoft.com>
Message-ID: <aKz_ZMvvF0e9nwSn@google.com>
Subject: Re: [PATCH 0/5] Drivers: hv: Fix NEED_RESCHED_LAZY and use common APIs
From: Sean Christopherson <seanjc@google.com>
To: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-hyperv@vger.kernel.org, 
	rcu@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 25, 2025, Nuno Das Neves wrote:
> On 8/25/2025 1:06 PM, Sean Christopherson wrote:
> > Fix a bug where MSHV root partitions don't honor NEED_RESCHED_LAZY, and then
> > deduplicate the TIF related MSHV code by turning the "kvm" entry APIs into
> > more generic "virt" APIs (which ideally would have been done when MSHV root
> > support was added).
> > 
> > Assuming all is well, maybe this could go through the tip tree?
> > 
> > The Hyper-V stuff and non-x86 architectures are compile-tested only.
> > 
> 
> Thanks Sean, I can test the root partition changes.
> 
> A similar change will be needed in mshv_vtl_main.c since it also calls
> mshv_do_pre_guest_mode_work() (hence the "common" in mshv_common.c).

Oof, more dependencies.  I suppose the easiest thing would be to send a series
against

  git://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git queue

and then route everything through there?

Alternatively, frontload the MSHV fixes (which I'll do regardless) and take those
through hyperv and the rest through the tip tree?  That seems like an absurd
amount of juggling though, especially if we want to get the cleanups into 6.18.
And if none of these lands, it's MSHV that'll suffer the most, so betting it all
on the hyperv tree doesn't seem terrible.

> Also, is it possible to make all the mshv driver changes in a single patch?

It's certainly possible, but I'd prefer not do to that.

> It seems like it would be cleaner than refactoring it in patches 1 & 2 and
> then deleting all the refactored code in patch 5.

Only if you don't care about backporting fixes, bisection, or maintaining code.

E.g. if checking NEED_RESCHED_LAZY somehow causes issues, it would be really nice
for that to bisect to exactly that patch, not a patch that also switches to a
completely different set of APIs.

And if someone is wants the fixes in a pre-6.18 kernel, they don't need to
backport all of the KVM and entry code changes just to get the fix.

As for the maintenance headache, see above.

