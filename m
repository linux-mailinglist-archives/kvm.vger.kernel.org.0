Return-Path: <kvm+bounces-57408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17884B551F3
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 16:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE4697C372D
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 14:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD3B8309EEC;
	Fri, 12 Sep 2025 14:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rf7xNEVD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883F5305044
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 14:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757688047; cv=none; b=gLtMbxPuPlrFovqkO9m9WQeq54EbbufCn0jJFUpkPwlqYfGExQYk7x1MJ68IvluoFOZDw/wjvQvdDBh+KM1svS/y10mC/Z+scC0++ysPBo0EHg037BaAz6her7jhGOdVfmKrTbhXJjsRL6UZc/e9vzVCHP3m8nBnn0jT5sDRUCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757688047; c=relaxed/simple;
	bh=PLrT3E4vLyawWAJV2Fqj90fo/GvZfp4GcPpYDpUoTYo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IkEP31QnFm+V4QZ/pisxinc5v+st+aWSGxcvevqPm3u76o9mhnwyklXba4yVqbg373CnCFrlpOKGM8oqUCxuJvfx1tsI1zPLdeQPSe+x7YJ2jdRydSKsEmHCR2ixm1PdIiA/aobiJuDZsa+7zFdwQAHQkg9o5+1mYFnEeMoQMTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rf7xNEVD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329ee69e7f1so1807662a91.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 07:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757688045; x=1758292845; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=59zg1D8+KwOnNl/fjkRq6toKtV2ueC+RV0v1lysDQMQ=;
        b=rf7xNEVDZSfgLHPCj3SQgvKsZlFwI7Lyd+C/tCe+IV4XH0zGpQbIaC6xI0KPXDSlT0
         4tgCW4qNclLT9socm1/EC1LMwMW/6tXjAiy/bU+RvA5Yq+ru7E9TUd26mR9nIPlku/9N
         0E8qrxAg+EI/2ZS7FOMiWB0nkxaAi4KTtXh3swIMxgpDmZrVMs7fJaai6nCxJpVwOr7Z
         pkyvUdwrIhfbUaZVuk6rLX8peCzcKRKVmh95JwBEBWPtxxAFSxORQzwonoGeXEKDoag4
         NPix/Ku6rpHr4oOqA/+eSqao8TW+EZHMQbb/9wH9nMn+Bt64J37oRL+HmpIpeCZ7OBmr
         xkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757688045; x=1758292845;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=59zg1D8+KwOnNl/fjkRq6toKtV2ueC+RV0v1lysDQMQ=;
        b=uoXoUOqpwV0ADOecy5oYg1b7VzZPVabP7Pb1rJRe0aAE2+Xg/YdJGKeXvaavdr9GFq
         dZgrLl7unUhAmfKOP8eRAYTQuVzKS0RX6wBtKaTq8fn+nM0z3RbANBD27xCM1ngC0sHR
         n6wXx5sSht/hHTg/SgVYWuiSKsPGH1hAbibDR4n5uODSQ0lkUZP9F2bjxyyzPpGUuoA0
         2XR2cCq3k4XcBFwcIa3Zfe7AojbFo/4hGtE6x1Werxk5FvIZpXPlA0OUxjm07nM47HAz
         L7r4wrH93wcVExO71N337BZkPMidbHxVipAev9miWhDpoTDP2JbbwGlvsxMhu3oISg9k
         zpbQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8JG8wzU481NPAjUSXV8GfqtXdihwmeygnAs+vV0hZMq2vY6dT8XHSxmLha6vOmfURu38=@vger.kernel.org
X-Gm-Message-State: AOJu0YzujhfpRVPtaS+jDBHUn7uTXAlNhpo+/8G81QC8mt5ALzxv+cMj
	gprbc4mt05ul9Mvns1Af7wu2/74hL3lnk2TCOcxpPUhTLVeDimlNcP5tGVnsLvWkP6F5E6oAgHG
	ZZPkQCw==
X-Google-Smtp-Source: AGHT+IEaiqSj724DOUxStmGO7Ji4bYvAv9UvNmfDki7gx80WNU5Huc/OdEyN3ByTZ6TxjpxNYEARSJDlZ+U=
X-Received: from pjl15.prod.google.com ([2002:a17:90b:2f8f:b0:329:7040:8862])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f90:b0:32b:58d4:e9d0
 with SMTP id 98e67ed59e1d1-32de4f85988mr3580752a91.23.1757688044838; Fri, 12
 Sep 2025 07:40:44 -0700 (PDT)
Date: Fri, 12 Sep 2025 07:40:43 -0700
In-Reply-To: <20250912141132.GA85606@k08j02272.eu95sqa>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c10fb477105231e62da28f12c94c5452fa1eff74.1757662000.git.houwenlong.hwl@antgroup.com>
 <aMPbNBofTCFGTCs6@intel.com> <20250912093822.GA10794@k08j02272.eu95sqa> <20250912141132.GA85606@k08j02272.eu95sqa>
Message-ID: <aMQw67a7Ku7wXTXO@google.com>
Subject: Re: [PATCH] KVM: x86: Remove outdated comments and code in kvm_on_user_return()
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 12, 2025, Hou Wenlong wrote:
> On Fri, Sep 12, 2025 at 05:38:22PM +0800, Hou Wenlong wrote:
> > On Fri, Sep 12, 2025 at 04:35:00PM +0800, Chao Gao wrote:
> > > On Fri, Sep 12, 2025 at 03:35:29PM +0800, Hou Wenlong wrote:
> > > >The commit a377ac1cd9d7b ("x86/entry: Move user return notifier out of
> > > >loop") moved fire_user_return_notifiers() into the section with
> > > >interrupts disabled, so the callback kvm_on_user_return() cannot be
> > > >interrupted by kvm_arch_disable_virtualization_cpu() now. Therefore,
> > > >remove the outdated comments and local_irq_save()/local_irq_restore()
> > > >code in kvm_on_user_return().
> > > >
> > > >Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > > >---
> > > > arch/x86/kvm/x86.c | 16 +++++-----------
> > > > 1 file changed, 5 insertions(+), 11 deletions(-)
> > > >
> > > >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > >index 33fba801b205..10afbacb1851 100644
> > > >--- a/arch/x86/kvm/x86.c
> > > >+++ b/arch/x86/kvm/x86.c
> > > >@@ -568,18 +568,12 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
> > > > 	struct kvm_user_return_msrs *msrs
> > > > 		= container_of(urn, struct kvm_user_return_msrs, urn);
> > > > 	struct kvm_user_return_msr_values *values;
> > > >-	unsigned long flags;
> > > >
> > > >-	/*
> > > >-	 * Disabling irqs at this point since the following code could be
> > > >-	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
> > > >-	 */
> > > >-	local_irq_save(flags);
> > > >-	if (msrs->registered) {
> > > >-		msrs->registered = false;
> > > >-		user_return_notifier_unregister(urn);
> > > >-	}
> > > >-	local_irq_restore(flags);
> > > >+	lockdep_assert_irqs_disabled();
> > > 
> > > kvm_offline_cpu() may call into this function. But I am not sure if interrupts
> > > are disabled in that path.
> > >
> > Thanks for pointing that out. I see that interrupts are enabled in the
> > callback during the CPU offline test. I'll remove the
> > lockdep_assert_irqs_disabled() here.
> >
> 
> Upon a second look, can we just disable interrupts in kvm_cpu_offline()?
> The other paths that call kvm_disable_virtualization_cpu() are all in an
> interrupt-disabled state, although it seems that
> kvm_disable_virtualization_cpu() cannot be reentered.

Why do we care?  I.e. what is the motivation for changing this code?  I'm hesitant
to touch this code without good reason given its fragility and subtlety.

