Return-Path: <kvm+bounces-23999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30AB795077B
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:27:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D43BC1F259E3
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9042C19D088;
	Tue, 13 Aug 2024 14:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uMsJn1Y0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592CD19B3DD
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 14:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723559219; cv=none; b=EHm8H45a3G8mruliYzE12UwskypkuxTG93R+7T+Tgv7Cb1QyQJzKveiUrWTnmqh0dQotMaSTpPL0YZutuK8qLPK8TwwA1HmHnVlbDfn2WAc8ZNDnxgGULEqYpiYXXS78uqy3+QQEBsKrKUVed8+vcAzBbqxGPVY+GWpZ227hKWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723559219; c=relaxed/simple;
	bh=nDFtrRLCiIpry9mS1jdG2ZuIuLH24n/ueW+EVQCN18s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R8I0vphviPUjX3T71+RP5sPFJOp7tG/dVwxf36rpDVNq3Rn5ntR0xRI7qMCRakmRKEakM521DNHEZciet0AVFKkxzzjr1mvz4B0Y3BdwceriLO7vLw9fzjmMq6stPs035KMTULVK7Gs029hr1FNNSkh4HfWfI03Tp2Qn9z0hz3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uMsJn1Y0; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66b3b4415c7so121596147b3.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 07:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723559217; x=1724164017; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nlePOXAg16VujwWpQo53FC8BTqwskF/Ge2QXUD/85QE=;
        b=uMsJn1Y0q5c7NbTS6Fs+eFK8a7drW3DP/h7UfDYq5hafsIz1bwCJ4ZynFF6DFivw/g
         4vv8Y5b+ZxUDH3AqaUSRtjn4UPmD1zZBIbp29lZ8r6Luy/2a7aVb1nU3A/FX4482uTfZ
         z48HrlfMY4/oSquTXxTRJQyZa/TRgQdBcIOKaJ3/3iOnOm85KujSIqyRLOypiBVw/ifw
         8wwp7XPnYLkZa96NZRda8N2x+dK57ZHI0avOx6pY+HzPkTPpvBTchvf1sG5lwv9KfIJx
         nm61VwopZgk7ia/dVnWeZUfflLZtnL+Sc59qBdKBr0QzAjgnlLIXqdao84+0oiGpdR3T
         4igg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723559217; x=1724164017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nlePOXAg16VujwWpQo53FC8BTqwskF/Ge2QXUD/85QE=;
        b=A/jdah1nQIkNVENtV+4DIJA12+9AEjXaSbFJfQUIwTvJGlQDBS+c/41Jirc/Rvt4S7
         nkVFzT+ePTmaZZGinmYEtP95Kf2W+9pKV0TT3SYFtkh1KwYvCF/j5NgqnY29vxD+u0uE
         b4RUFmUeWprEjSrSaa1nd9bOmIyIyS39tNPfyIVmNJhJmSNF+GgwoGUu5u1Hjp6rQwrq
         wuB1dUF4j+NKpJSxU8Tc6MfAg6+echlX27L2nZYIn5uhaOs7Bjf805h7UzNXrWDxB/9C
         wNmvxNBPH7L1PQsYy7ote5y04KEgdpjk4t9ycCeuS7+7lnbQmN2a6wadmQ/rk1x/QOPH
         fi+g==
X-Forwarded-Encrypted: i=1; AJvYcCVJWtO/fhhAKXtndlFYXUolymZvwpTa8fysU+WRcHKBI0zZCSp8Lo2v/4YZC9DfTexZ5AZ5bRaBH5l/iye8hHmg4GPz
X-Gm-Message-State: AOJu0YzQnQmKNq31/SA1Exn8jJf+4eVTJz1NvHrDFBEzBs2GA1s7wFMC
	Rnj+937GF5GU1QxMm5j55ZjJO5ad1S7VzgLYH5gr3dDSU8D2L1WFlwPAfnB64O6eViXz9i8niWG
	jqg==
X-Google-Smtp-Source: AGHT+IEEvTWXYJINBxGMayHtOBEQqp7u1QCGe3ozNbbkvySjfSWo9grl4aqe1MPeA+og7VSh05yZ5yELEz4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:185:b0:e03:2f8e:9d81 with SMTP id
 3f1490d57ef6-e113c909013mr7713276.0.1723559217266; Tue, 13 Aug 2024 07:26:57
 -0700 (PDT)
Date: Tue, 13 Aug 2024 07:26:55 -0700
In-Reply-To: <yq5aikw6ji14.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com> <20240809205158.1340255-4-amoorthy@google.com>
 <yq5aikw6ji14.fsf@kernel.org>
Message-ID: <ZrtskXJ6jH90pqB2@google.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Perform memory fault exits when
 stage-2 handler EFAULTs
From: Sean Christopherson <seanjc@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anish Moorthy <amoorthy@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 12, 2024, Aneesh Kumar K.V wrote:
> Anish Moorthy <amoorthy@google.com> writes:
> 
> > Right now userspace just gets a bare EFAULT when the stage-2 fault
> > handler fails to fault in the relevant page. Set up a
> > KVM_EXIT_MEMORY_FAULT whenever this happens, which at the very least
> > eases debugging and might also let userspace decide on/take some
> > specific action other than crashing the VM.
> >
> > In some cases, user_mem_abort() EFAULTs before the size of the fault is
> > calculated: return 0 in these cases to indicate that the fault is of
> > unknown size.
> >
> 
> VMMs are now converting private memory to shared or vice-versa on vcpu
> exit due to memory fault. This change will require VMM track each page's
> private/shared state so that they can now handle an exit fault on a
> shared memory where the fault happened due to reasons other than
> conversion.

I don't see how filling kvm_run.memory_fault in more locations changes anything.
The userspace exits are inherently racy, e.g. userspace may have already converted
the page to the appropriate state, thus making KVM's exit spurious.  So either
the VMM already tracks state, or the VMM blindly converts to shared/private.

> Should we make it easy by adding additional flag bits to
> indicate the fault was due to attribute and access type mismatch?

Like above, describing _why_ an exit occurred is problematic when an exit races
with a "fix" from userspace.  It's also problematic when there are multiple
possible faults, e.g. if the guest attempts to write to private memory, but
userspace has the memory mapped as read-only, shared (contrived, but possible).
Describing only the fault that KVM's see means the vCPU will encounter multiple
faults, and userspace will end up getting multiple exits

Instead, KVM should describe the access that led to the fault, as planned in the
original series[1][2].  Userpace can then get the page into the correct state
straightaway, or take punitive action if the guest is misbehaving.

	if (is_write)
		vcpu->run->memory_fault.flags |= KVM_MEMORY_FAULT_FLAG_WRITE;
	else if (is_exec)
		vcpu->run->memory_fault.flags |= KVM_MEMORY_FAULT_FLAG_EXEC;
	else
		vcpu->run->memory_fault.flags |= KVM_MEMORY_FAULT_FLAG_READ;

That said, I'm a little hesitant to capture RWX information without a use case,
mainly because it will require a new capability for userspace to be able to rely
on the information.  In hindsight, it probably would have been better to capture
RWX information in the initial implementation.  Doh.

[1] https://lore.kernel.org/all/ZIn6VQSebTRN1jtX@google.com
[2] https://lore.kernel.org/all/ZR4N8cwzTMDanPUY@google.com

