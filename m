Return-Path: <kvm+bounces-26270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB92973931
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 15:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 712CA1C24BC8
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 13:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91A2193073;
	Tue, 10 Sep 2024 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VlpqTSOG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE23192D7B
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 13:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725976679; cv=none; b=Bl+6s4ucxoePGd2sUJCFx+LTR993jTVeo2OnKnXnpYrukznf+cL5Y0VbS8EXqt9Bv3D29WbxBxhhVioLOGDbnHQp2Uz31HammV1XTfwY2m6KeFFbQl61SYySbjBGxxowiVGLtmwGnfkKhzOqnjQCJHTh2cgtTRJSkzGu4gvJV9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725976679; c=relaxed/simple;
	bh=C3OuvsYXzxsi8PsJHLti8+yTLlIB/Wx/T1gR0I+782Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kjsyVmcDH58EceN+4NkyqDx1XEXEbnSrWXuVh1Y84ThRYEgxjkFl95f9F9ImBgK5U5fxEt9Jm0lX5CJ3Lim0+0uB6fZCujUiOUxao9VxIpQ3y8eGzkbWMsHTZHGLOS+v+sCLahH/PTinUWPGaUBQprmIWm1uWJK7SsB/vYfysJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VlpqTSOG; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6db7a8c6910so69293577b3.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 06:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725976676; x=1726581476; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hrgYqxg+OsjDVol4glnNVZPQAh7+/pJe50NmZF8ETrk=;
        b=VlpqTSOGkDmRWca/xoYmQsC0eVo+cgYVz8zxqEHiSBDKcZOv77OGI1xCRGcD3S6IGi
         PZ3WqnQKcQmzbvOZyU9YpXK+GHn5Jx6icQl7ZnOCf3/jawJr7Nyl6dTQCbx6zoXMsWl3
         SNOBJZpKNtUaHYv4zN4SWYP5W0rwUmp4bnRg2m5zlV/hiX/STQCyD2zah/nXvEhZuLHi
         RM5uTKt/r/kjm1+EocY90t2+PfzVjvnt7cPBaTMoDlzPyB/MucWUR1V8S0DXtx3o5t3s
         3wlMMW25/saIhtKtCLwLrXztgpUcO5BW3M/lxLZ0LAdvQREkRxQqXArr7VkQ+jtpT7qW
         LeYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725976676; x=1726581476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hrgYqxg+OsjDVol4glnNVZPQAh7+/pJe50NmZF8ETrk=;
        b=nqz4gfMhWWH5+YzRrvHyRqv4aYTq39AClq3LU84IqYTYXglhCQaZ4u+wBy6POgxTAF
         0CMyQeXIjrx9SHk9oDYQEo6TY46UGMcTK1PLns+9Xk/+uCYd05qJjxwnnYaQrFgLWwWV
         a5q0qB54AF8LowHDp9gvc9P42jD9H3kGbjxZWQ9Z+WSh0kcOTa89xiZzeqIdkLqwHZMM
         YaEhC1vZZtAioWlwJZDbd0QpaxYopA0TXyQMJe372fHQr4cvjpS0yWsc1y8Fvcsai5kU
         uMwz7qCR8Ov0P4G1DAOGIARF+qRa11B2/Nrj/zpC7jCfZfbGZIZfFhRbSaURZWTmC4HO
         nrmA==
X-Forwarded-Encrypted: i=1; AJvYcCVymkbmvyWsXhX3NZgrbBlRVzQABcC6vyxsJewFXcUOAkt8/1WA3Ze/S2GNvpwLPwhPZcw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVWu8+/guzOsVlXlk5oYuHLeTBWxrGLedBK/6Q2DLvwernw59I
	/pVQAwAz7IOW1+IRY1SgBRtAJ6sVaxd7igKYgqa7N4sbYejPZXcUyXvbYpPbmpLZH8+voomRN94
	r3A==
X-Google-Smtp-Source: AGHT+IHYFtzUz/PGpro4LUc7/eZdeUX8GATKxph3lRCbnZwJE9AuGBVRCQAmAzgDSxlh877uyOBvJG8xY08=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c7c7:0:b0:e1a:a29d:33f6 with SMTP id
 3f1490d57ef6-e1d3487ce6dmr143080276.3.1725976676434; Tue, 10 Sep 2024
 06:57:56 -0700 (PDT)
Date: Tue, 10 Sep 2024 06:57:54 -0700
In-Reply-To: <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-10-rick.p.edgecombe@intel.com> <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
 <Zt9kmVe1nkjVjoEg@google.com> <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
Message-ID: <ZuBQYvY6Ib4ZYBgx@google.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, Yuan Yao <yuan.yao@intel.com>, 
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	Kai Huang <kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 10, 2024, Paolo Bonzini wrote:
> On 9/9/24 23:11, Sean Christopherson wrote:
> > In general, I am_very_  opposed to blindly retrying an SEPT SEAMCALL, ever.  For
> > its operations, I'm pretty sure the only sane approach is for KVM to ensure there
> > will be no contention.  And if the TDX module's single-step protection spuriously
> > kicks in, KVM exits to userspace.  If the TDX module can't/doesn't/won't communicate
> > that it's mitigating single-step, e.g. so that KVM can forward the information
> > to userspace, then that's a TDX module problem to solve.
> 
> In principle I agree but we also need to be pragmatic.  Exiting to userspace
> may not be practical in all flows, for example.
> 
> First of all, we can add a spinlock around affected seamcalls.

No, because that defeates the purpose of having mmu_lock be a rwlock.

> This way we know that "busy" errors must come from the guest and have set
> HOST_PRIORITY.
 
We should be able to achieve that without a VM-wide spinlock.  My thought (from
v11?) was to effectively use the FROZEN_SPTE bit as a per-SPTE spinlock, i.e. keep
it set until the SEAMCALL completes.

> It is still kinda bad that guests can force the VMM to loop, but the VMM can
> always say enough is enough.  In other words, let's assume that a limit of
> 16 is probably appropriate but we can also increase the limit and crash the
> VM if things become ridiculous.
> 
> Something like this:
> 
> 	static u32 max = 16;
> 	int retry = 0;
> 	spin_lock(&kvm->arch.seamcall_lock);
> 	for (;;) {
> 		args_in = *in;
> 		ret = seamcall_ret(op, in);
> 		if (++retry == 1) {
> 			/* protected by the same seamcall_lock */
> 			kvm->stat.retried_seamcalls++;
> 		} else if (retry == READ_ONCE(max)) {
> 			pr_warn("Exceeded %d retries for S-EPT operation\n", max);
> 			if (KVM_BUG_ON(kvm, retry == 1024)) {
> 				pr_err("Crashing due to lock contention in the TDX module\n");
> 				break;
> 			}
> 			cmpxchg(&max, retry, retry * 2);
> 		}
> 	}
> 	spin_unlock(&kvm->arch.seamcall_lock);
> 
> This way we can do some testing and figure out a useful limit.

2 :-)

One try that guarantees no other host task is accessing the S-EPT entry, and a
second try after blasting IPI to kick vCPUs to ensure no guest-side task has
locked the S-EPT entry.

My concern with an arbitrary retry loop is that we'll essentially propagate the
TDX module issues to the broader kernel.  Each of those SEAMCALLs is slooow, so
retrying even ~20 times could exceed the system's tolerances for scheduling, RCU,
etc...

> For zero step detection, my reading is that it's TDH.VP.ENTER that fails;
> not any of the MEM seamcalls.  For that one to be resolved, it should be
> enough to do take and release the mmu_lock back to back, which ensures that
> all pending critical sections have completed (that is,
> "write_lock(&kvm->mmu_lock); write_unlock(&kvm->mmu_lock);").  And then
> loop.  Adding a vCPU stat for that one is a good idea, too.

As above and in my discussion with Rick, I would prefer to kick vCPUs to force
forward progress, especially for the zero-step case.  If KVM gets to the point
where it has retried TDH.VP.ENTER on the same fault so many times that zero-step
kicks in, then it's time to kick and wait, not keep retrying blindly.

There is still risk of a hang, e.g. if a CPU fails to respond to the IPI, but
that's a possibility that always exists.  Kicking vCPUs allows KVM to know with
100% certainty that a SEAMCALL should succeed.

Hrm, the wrinkle is that if we want to guarantee success, the vCPU kick would
need to happen when the SPTE is frozen, to ensure some other host task doesn't
"steal" the lock.

