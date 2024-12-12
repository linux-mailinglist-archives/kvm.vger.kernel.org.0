Return-Path: <kvm+bounces-33671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D4789EFF04
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 23:11:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E409287D0A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 22:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1331DB922;
	Thu, 12 Dec 2024 22:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RwDp4vca"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1879F1C9B62
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 22:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734041482; cv=none; b=s1ysxPmI69jZYYzxXYKiNMJwtt1L+j3ZuJ2YbYV4Kr7Xt65N4jkgJT4VL+QBm3E6rdbQ6ILpMX0wYMWCG4rdLE5XNHJQrzaHDlAGbm3UHgYVCN+DfxY1DeXiJ0ZOz4mKa8ysdzPTRY7EFoa+Rw1GJSTuOYIS+hAFvD//+bgmTGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734041482; c=relaxed/simple;
	bh=13+8h6kI1TAfWW2u8Ca3Z2Xilpypvcr0DKeH7p6NqUY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=njvvPx6kGJQNMjJv4LwbGhLf/31foYJTG06cZ3mFXGkLAcNi6dQNLIQEYOfB1t6GeV/3BIzLty66kFffIK4c+S8W659LEAjJd5R4+fE8tqdf5OtdxLX698Eai0qSN5VWEIPhAYLUOkdVf2x21d+YHbRA0Lc0t3LodTcw5UJjG+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RwDp4vca; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-728e4bdd69eso1953807b3a.0
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 14:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734041478; x=1734646278; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O8hFG6HST0+xz5AWr8oNcEUA/Zcqg9a67DpfzgQIv1s=;
        b=RwDp4vca5cYn+O3ANWmNzPfOW0bcTY6/nv5rKJOya+5pMyuHENj9uFkS0gqvvzMMWa
         bjieClOFeQBPGl8g4k5lWHQLem/FZWjSoel7CJqbv7Zbs7KzOwEwNlq0eGdPVhFtZIAr
         f/MPf1ovl3TZKH/aIM0e0fOPkA0UdwCawNq4URpX+UvhHs+I0c7ob6flbXSVFYtNuHR3
         194F++j9KHkGZnIsog203jUXTUbymZqVI+KYIaOTWWc900Lzee7iqGkT+S9RvqbneJCL
         YTTR4VG4rZWAmRQRfUdUai20X9YswsRkZ5M5aHSDzSrvCICKm8lf2tr+HJt22yrXZ2Dg
         rmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734041478; x=1734646278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O8hFG6HST0+xz5AWr8oNcEUA/Zcqg9a67DpfzgQIv1s=;
        b=DJU8TnrOZpJHqoqghg4iS7F9no4iVtazgOY4ZaXiSgQHn6Hu+CENM9fAdqP1GaKYz2
         4pU11R7u6W8X9ce8ptNGe4uKl927Wi508uAirMc3FMdtBrmW+nrUUcZfvk6/yNwro4v2
         Dgrp7H7HibyIMRZ/ggOI4q3KKoZ/e7HwpHBzs3z5GLvt8pLPDDAAoDlPjhRktLIQNIK/
         oA6axB0Uw5Iw+ADemTZPenbSHoh0AY09nJN/LTzB1VkxTkV1ed2APLCrtHu7JL8n0nMh
         fvRvLpsKK3UqWu3YDW4ZFCwOCoJ74NkXNdXkO84q05HmkwJeLN/IPhUaYo2n+PTgYR+u
         el/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5BTilgjdQk8DhnemA4PWKEBwqBCkA+g8fqJr4zXWnFh1o7nlPtuqSGFMaYuxL+bhrMyg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNXufa+JHQriZsxKFtF44EF7A5XQpPvPOiiXuv53DxhkZVLJRl
	XBnwBzHgZaovg4ZVusSsJl8b13VpglY/lzh+knvL6oITiCmu4azamPO8eeKNqqaDTUg+WVLSPkd
	Gqg==
X-Google-Smtp-Source: AGHT+IEYe3oACuEmMt/hCqKoxzL+HdkacaXms03GcWAAvu/hVYwocKnminOiRi57LHIwzOhfSkY+i2gDxzI=
X-Received: from pfde6.prod.google.com ([2002:aa7:8c46:0:b0:725:e37e:7451])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2347:b0:725:f18a:da37
 with SMTP id d2e1a72fcca58-7290c3aee61mr234715b3a.0.1734041478467; Thu, 12
 Dec 2024 14:11:18 -0800 (PST)
Date: Thu, 12 Dec 2024 14:11:16 -0800
In-Reply-To: <5b8f7d63-ef0a-487f-bf9d-44421691fa85@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241212032628.475976-1-binbin.wu@linux.intel.com>
 <Z1qZygKqvjIfpOXD@intel.com> <1a5e2988-9a7d-4415-86ad-8a7a98dbc5eb@redhat.com>
 <Z1s1yeWKnvmh718N@google.com> <5b8f7d63-ef0a-487f-bf9d-44421691fa85@redhat.com>
Message-ID: <Z1tfhPaHruhS3teK@google.com>
Subject: Re: [PATCH] i386/kvm: Set return value after handling KVM_EXIT_HYPERCALL
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, xiaoyao.li@intel.com, 
	qemu-devel@nongnu.org, michael.roth@amd.com, rick.p.edgecombe@intel.com, 
	isaku.yamahata@intel.com, farrah.chen@intel.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 12, 2024, Paolo Bonzini wrote:
> On 12/12/24 20:13, Sean Christopherson wrote:
> > On Thu, Dec 12, 2024, Paolo Bonzini wrote:
> > > If ret is less than zero, will stop the VM anyway as
> > > RUN_STATE_INTERNAL_ERROR.
> > > 
> > > If this has to be fixed in QEMU, I think there's no need to set anything
> > > if ret != 0; also because kvm_convert_memory() returns -1 on error and
> > > that's not how the error would be passed to the guest.
> > > 
> > > However, I think the right fix should simply be this in KVM:
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 83fe0a78146f..e2118ba93ef6 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -10066,6 +10066,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> > >   		}
> > >   		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
> > > +		vcpu->run->ret                = 0;
> > 
> > 		vcpu->run->hypercall.ret
> > 
> > >   		vcpu->run->hypercall.nr       = KVM_HC_MAP_GPA_RANGE;
> > >   		vcpu->run->hypercall.args[0]  = gpa;
> > >   		vcpu->run->hypercall.args[1]  = npages;
> > > 
> > > While there is arguably a change in behavior of the kernel both with
> > > the patches in kvm-coco-queue and with the above one, _in practice_
> > > the above change is one that userspace will not notice.
> > 
> > I agree that KVM should initialize "ret", but I don't think '0' is the right
> > value.  KVM shouldn't assume userspace will successfully handle the hypercall.
> > What happens if KVM sets vcpu->run->hypercall.ret to a non-zero value, e.g. -KVM_ENOSYS?
> 
> Unfortunately QEMU is never writing vcpu->run->hypercall.ret, so the guest
> sees -KVM_ENOSYS; this is basically the same bug that Binbin is fixing, just
> with a different value passed to the guest.
> 
> In other words, the above one-liner is pulling the "don't break userspace"
> card.

But how is anything breaking userspace?  QEMU needs to opt-in to intercepting
KVM_HC_MAP_GPA_RANGE, and this has been KVM's behavior since commit 0dbb11230437
("KVM: X86: Introduce KVM_HC_MAP_GPA_RANGE hypercall").

Ah, "ret" happens to be deep in the union and KVM zero allocates vcpu->run, so
QEMU gets lucky and "ret" happens to be zero because no other non-fatal userspace
exit on x86 happens to need as many bytes.  Hilarious.

FWIW, if TDX marshalls hypercall state into KVM's "normal" registers, then KVM's
shenanigans with vcpu->run->hypercall.ret might go away?  Though regardless of
what happens on that front, I think it makes to explicitly initialize "ret" to
*something*.

I checked our VMM, and it does the right thing, so I don't have any objection
to explicitly zeroing "ret".  Though it needs a comment explaining that it's a
terrible hack for broken userspace ;-)

