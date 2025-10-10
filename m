Return-Path: <kvm+bounces-59781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E51BCE33A
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 20:14:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B79274E3281
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 18:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64EF62FC039;
	Fri, 10 Oct 2025 18:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tw/YOl9F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095822FBE1A
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760120050; cv=none; b=qLDb/dMMWABotywNZ0E7sl2gi3aiYJudx6PTDQNz2hK2U7jRwVDXLKHPjse9ysdFZlHjj0EmXguWJcu66QDV1Q1Yv1XkknTI/10x9mrJFO4m1gHP0G8iwXCkDrVVFR0mumPQxW/lxgCbbqZjopH2pLlcVhmtMANWLpZmbUc2gIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760120050; c=relaxed/simple;
	bh=V0gMhKNlFvxaSiIwQX6I3iUUMqcn4Gj0ndcSzOb074I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mVNME9Z6T4aAZR3P1tmp8dNienT+Yl4q67Z7Cbr6xByC47fmF8+spHx7iboZ1sD/dzL7okVWonU7stBnfyqu9d9PExYGSIsJBhGxNc8xeLFhNTnjR65T/rD2ByNpQ0tiYJq2RmR6EKeQqTqu51q6ZdxReC1Hu8TlDnhuOyIEaks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tw/YOl9F; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2699ebc0319so45173665ad.3
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 11:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760120048; x=1760724848; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RRqqebB5b3S+5bGOfhb1j8iKUMVMXWWcx0kI9eE51UQ=;
        b=tw/YOl9FEZ/r4KlcE7rbHb/33v9YJH9lbVns1Z2Ywnk95C+cFjb/5jW/o4rbhzXJzQ
         qQ4gbnDYpz51a22+b48kbvJEw8yicLE7pBz7ob8DjbFVF1rNv0xAXSMHumSUrkcIhonI
         LxfWSfDzMP0D1H99rEwnFxtGQsETpXgEtavBpfUI2y8/WhU+JqmNnLiKZdSkmYEH82x4
         eVXyfWNwTSgx97bhOCQdu7OYmzHcR5mLXy+ENGFYMX+J9s0zmrPAgxImcKaNtakLD37m
         nxXbKILJQ0E4Dgy/WBEWtsFZRzEor9be6TxWr6BqUDc0Zwo6SCnv2S6g+gwYQOEzK3VQ
         JuTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760120048; x=1760724848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RRqqebB5b3S+5bGOfhb1j8iKUMVMXWWcx0kI9eE51UQ=;
        b=HmWn9bUj1bOxifPeJy7qbT+4McvZYsckCOFTj+Ek4DygABbU0c0h4ydXM8m60qYjIJ
         Kp+nfG6+7tQZ+FiQ8ooaOyO2sfT2sIANVZ+EcOQA/WGTHTI5NFYW6xvt5AiFvvSXGRBi
         J8/ZUWZKJwly/KuTlNSXjsyKaAvtoj/qXKwq7gpYuLF4G99cBpeobYAX2WHPmDKZgzGw
         uCg00snKqlWVH+5sDbw4vwVnw5VTKEEPdLXJJhoLmhCwvObCKW8qqu6AJjRbg1ChCsDP
         pHl+BzwAgC/g035yjQriB6LdtJZ37HIMtqnrXInBE+o60CjSWi5ygaE23npziL7SRdTe
         0TIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpagW7N6YXs14uHiSCyoo1UB+XYpHYg6TjaeLeuqI+pDz7KIVwXLZg5hKyRNAI/8h+sEs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYrYA/qHc4BIKcNLvFfmElcmhqNFtku9+qlp6s//z4iVeyi7qR
	02DYsifO8eO56Dm6LMmktlP0DbJNTv3I1QiUSewJj08fa1Lg9q5DUhTOZpO2/aNuB0hMD4bSOal
	Bg8o9uA==
X-Google-Smtp-Source: AGHT+IH7cFlVTSNM+0j4l/xFWY5dLqOboXxalLgs1PnQJ4K/8YINWNO1tWQ0AvtHmyKAMc8BcWffcUfPi8Q=
X-Received: from plkb3.prod.google.com ([2002:a17:903:fa3:b0:268:1af:fcff])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f54b:b0:265:47:a7b0
 with SMTP id d9443c01a7336-290272117f0mr156739855ad.10.1760120048173; Fri, 10
 Oct 2025 11:14:08 -0700 (PDT)
Date: Fri, 10 Oct 2025 11:14:06 -0700
In-Reply-To: <DDEJY5ON407O.2O7CMOY9311NV@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com> <20250930163635.4035866-10-vipinsh@google.com>
 <DDEJY5ON407O.2O7CMOY9311NV@google.com>
Message-ID: <aOlM7ngJJsEW-5sV@google.com>
Subject: Re: [PATCH v3 9/9] KVM: selftests: Provide README.rst for KVM
 selftests runner
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, kvm-riscv <kvm-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 10, 2025, Brendan Jackman wrote:
> On Tue Sep 30, 2025 at 4:36 PM UTC, Vipin Sharma wrote:
> > @@ -0,0 +1,54 @@
> > +KVM Selftest Runner
> > +===================
> > +
> > +KVM selftest runner is highly configurable test executor that allows to run
> > +tests with different configurations (not just the default), parallely, save
> > +output to disk hierarchically, control what gets printed on console, provide
> > +execution status.

...

> I understand that for reasons of velocity

It's not just velocity, it's also for stability and maintainability.  Selftests are
the wild, wild west; there's no central authority, and many subsystems have "needs"
and opinions.  E.g. tools/testing/selftests/kselftest_harness.h is quite opionated,
_and_ it has fatally been broken multiple due to one subsystem making changes that
broke usage for other subsystems.  Obviously those bugs got sorted out, but it's a
painful experience.

I guess you could say those things are all about velocity in the end; but I want
to call out that it's not just about the initial velocity of landing the series,
it's also about the long-term velocity of being able to make changes to fit KVM's
needs without getting bogged down due to other susbystems adding requirements and
use cases that are irrelevant or at odds with KVM's.

> it might make sense to do this as a KVM-specific thing, but IIUC very little
> of this has anything to do with KVM in particular, right?

The actual implementation doesn't have any dependencies on KVM, but the design
and its goal are tailored to the needs of KVM.

> Is there an expectation to evolve in a more KVM-specific direction?

Sort of?  I don't think we'll ever pick up direct dependencies, but I do think
we'll continue to tailor the runner to the needs of the KVM community.

> (One thing that might be KVM-specific is the concurrency. I assume there
> are a bunch of KVM tests that are pretty isolated from one another and
> reasonable to run in parallel.

Every KVM selftest should be able to run in parallel.  That's actually a very
intentional design property of the runner: any system-level configuration needs
to be done by a "higher" authority, e.g. the human manually running the test, a
wrapper script, some form of CI infrastructure, etc.

> Testing _the_ mm like that just isn't gonna work most of the time. I still
> think this is really specific to individual sets of tests though, in a more
> mature system there would be a metadata mechanism for marking tests as
> parallelisable wrt each other.

Dependency and friendliness tracking is again something we specifically avoided
doing, because the KVM selftests need to be self-contained anyways.  E.g. if a
test requires KVM module param X to be enabled, then the test needs to skip.
The runner takes advantage of that behavior in order to simplify the code; it
really is just a "dumb" executor.

> I guess this patchset is part of an effort to have a more mature system that
> enables that kind of thing.).

Sort of?  My response to Marc covered more of the goals in detail:

https://lore.kernel.org/all/aN8gkEMHuvIVPcCt@google.com

> To avoid confusing people and potentially leave the door open to a
> cleaner integration, please can you add some bits here about how this
> relates to the rest of the kselftest infrastructure? Some questions I
> think are worth answering:
> 
> - As someone who runs KVM selftests, but doesn't work specifically on
>   KVM, to what extent do I need to know about this tool? Can I still run
>   the selftests "the old fashioned way" and if so what do I lose as
>   compared to using the KVM runner?

The runner is purely optional.  You'll lose whatever you don't have, that the
runner provides.  E.g. I have (hacky) scripts to run KVM selftests in parallel,
but without much of the niceties provided by this runner.

> - Does this system change the "data model" of the selftests at all, and
>   if so how? I.e. I think (but honestly I'm not sure) that kselftests
>   are a 2-tier hierarchy of $suite:$test without any further
>   parameterisation or nesting (where there is more detail, it's hidden
>   as implementation details of individual $tests). Do the KVM selftests
>   have this structure?

More or less.

>   If it differs, how does that effect the view from run_kselftest.sh?

AFAIK, nothing in KVM selftests is at odds with run_kselftest.sh.

> - I think (again, not very sure) that in kselftest that each $test is a
>   command executing a process. And this process communicates its status
>   by printing KTAP and returning an exit code. Is that stuff the same
>   for this runner?

Yes?  Except most KVM selftests don't support TAP (yet).

