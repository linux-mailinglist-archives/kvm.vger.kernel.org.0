Return-Path: <kvm+bounces-28460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4399D998D0F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:17:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB9651F21334
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 16:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 957E01CDFC2;
	Thu, 10 Oct 2024 16:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fd+/SYLR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2BC1C5781
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 16:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728577045; cv=none; b=WDgJiLws6aJq65iGVQfZ1WbT1Vu30mf3LJijmRUCaESvUEK4YmuRZeJoD04ZEGSR86+rcsvQpwayvx18O7pn4xcT4ove98DIiKBnUqdReS+HvCLt+P3rljfL1+36MdRr8Ra0rNm1IC3Y7ezIWHV9T7c7v8Dh1PRTHX2BCQXY75E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728577045; c=relaxed/simple;
	bh=mkICGJhs/b7k7NcqmLZRsZKzsjAEjJyvE/rF0/Ik6rc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iyP/+pDQh7VyZujnuNlImED7Z0RU/ZPXyzgCqFaZ97xP6JLwD4VvwoUa2PtV5duoKq8k4seCfU3BVM9At3Fllih/IqskmOoZtqIc2nIghPn/AdaUMvEtEx1xQUMOAabTQs9DBL+/RZILr56PvpF8e54g5UJqNtRa+L5VpJ0zoZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fd+/SYLR; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-20b6144cc2aso11276825ad.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 09:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728577044; x=1729181844; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h7AGLcujdKFyZpliZyyqPh/ARFiEjFEWVx8n6Mc4qjo=;
        b=fd+/SYLRI1Ic3y7GoPFsHw+0NtbaEhg0AHPHnCTCYBWuObJ7bIkZTbyKGsTTCx0SLO
         5f1mhzlgv9LC3Eamm/Tw3epL72Re1aUF9ivHZG/V++LLDkke9Tb3vhpmtLka1l/oRJub
         jnxuSQrOgYSBpQq1/Xi//+tGq03V9aFOIFedPsknsh2XoFuwoWuMS06cMzxs7RB9WJAT
         S0umDQfkXCs7l7MznBOlNE6qxrL/EH+nJPm0ZzUszAu2GU/zx25mKRE5lhTEPXCSShW7
         rP7OhPPjftjXQ0AA9bQiBRRavC5G3gcJ+m1PeokTLI6Z/iscqHeAcmn9g1zwS1OE0mTS
         e8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728577044; x=1729181844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h7AGLcujdKFyZpliZyyqPh/ARFiEjFEWVx8n6Mc4qjo=;
        b=oG+/b8jIu4r71Tr7Tu4wFXWgpNaTS9ZA9YWz+lE2cluzpJrJA20X6zVJ4JBzOH3kZr
         W76z57JhMHMos7j887if5Sro8cbykgBN6IaIeBOHysHKc3r4px2ZojccfcDgQFJ+8JOO
         bN0WyArWiDRMnalqeKk0Rpee2Tqm003RrYDPvJA/nMk6AxGDE+ZYgS6mx22rwZZicsLA
         pNW1PtUYZ/SrQzlYGQjI3H936VLLfI7M1JxnX1QycfDf+ZR8mpxNQjPlbD1oPNwyR2Pz
         bxr11ORvgOMkFVJibHDieIg0tQ+TzpwAPjiLp4UcSJfwAM6mJ3YSEu12XakF+THsxqli
         U0nQ==
X-Gm-Message-State: AOJu0YxUKmFy5Yi5HAR/oAcUQlIiFIC7OpoGPJ8Lbnks86ZrluCshpsN
	nZg16YR/wyqECCYICX/KQHf9qjLw5/GhGI0lQnI7lQItONCmDQ71GUgOV/gwwPAD3Ana3UF1Lje
	WGA==
X-Google-Smtp-Source: AGHT+IFZdLpkV9v3SJniTDouzrdJyZNvDtTDPDMMmXhbNhjoF2bvM4gSJQRc1dXZMa4qVV9ofAyGOr6xM0E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:e806:b0:20b:8d7d:fe08 with SMTP id
 d9443c01a7336-20c804faee8mr417485ad.6.1728577042786; Thu, 10 Oct 2024
 09:17:22 -0700 (PDT)
Date: Thu, 10 Oct 2024 09:17:21 -0700
In-Reply-To: <dade78b3-81b1-45fb-8833-479f508313ac@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009175002.1118178-1-seanjc@google.com> <dade78b3-81b1-45fb-8833-479f508313ac@redhat.com>
Message-ID: <Zwf-EX_JVfAGmrPj@google.com>
Subject: Re: [PATCH v4 0/4] KVM: x86: Fix and harden reg caching from !TASK context
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 10, 2024, Paolo Bonzini wrote:
> On 10/9/24 19:49, Sean Christopherson wrote:
> > Fix a (VMX only) bug reported by Maxim where KVM caches a stale SS.AR_BYTES
> > when involuntary preemption schedules out a vCPU during vmx_vcpu_rest(), and
> > ultimately clobbers the VMCS's SS.AR_BYTES if userspace does KVM_GET_SREGS
> > => KVM_SET_SREGS, i.e. if userspace writes the stale value back into KVM.
> > 
> > v4, as this is a spiritual successor to Maxim's earlier series.
> > 
> > Patch 1 fixes the underlying problem by avoiding the cache in kvm_sched_out().
> 
> I think we want this one in stable?

If anything, we should send Maxim's patch to stable trees.  While not a complete
fix, it resolves the only known scenario where caching SS.AR_BYTES is truly
problematic, it's as low risk as patches get, and it's much more likely to backport
cleanly to older kernels.

> > Patch 2 fixes vmx_vcpu_reset() to invalidate the cache _after_ writing the
> > VMCS, which also fixes the VMCS clobbering bug, but isn't as robust of a fix
> > for KVM as a whole, e.g. any other flow that invalidates the cache too "early"
> > would be susceptible to the bug, and on its own doesn't allow for the
> > hardening in patch 3.

