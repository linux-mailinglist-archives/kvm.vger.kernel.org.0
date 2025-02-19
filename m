Return-Path: <kvm+bounces-38575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 324B7A3C1EA
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 15:21:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FA9A18816C3
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 14:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2021EDA36;
	Wed, 19 Feb 2025 14:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i5CfN0vC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3DF286281
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 14:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739974724; cv=none; b=lN3CCV4igAWl3R88lOTz3RtE7Wcv/+QKXKJqaBvw15zIGGSJcCgPo3pI00SsfBfkS4PxReExOXOOG1dgPBAuB7U5Xco4QGwWqW2DOPUAEZFGXxmoHsLj4cePJwWvekpplFVvWY8EO8vykuLFKW1bA6vo4BB6kv9bPC8p4ht2RQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739974724; c=relaxed/simple;
	bh=WNU7L+pRzTncQAtGYNgI5WB88sb+gLbJX7bWqgPEXSg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lUq2QlbmdxGY/RiuRGp5XM3HUlP1WTlCiUTSiq4QruNjOvBwUL2t449GeihY7Z0uaAvHMwzhLL8Dnxsh0xI0dVX2D2xzQirVkWMcEijBdh4wZ5dAEbvhiPW14Boti0HZDS05y/Umqke2ocIPypOdsGrXNxd/0gRtZ9awHpnz3mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i5CfN0vC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc5a9f18afso7472429a91.1
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 06:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739974723; x=1740579523; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c65p+W814m9oQCzxxz1KTZzmIhTFpCPYJR6tzp05a6w=;
        b=i5CfN0vCDiox0/RzZJxLMXveS+/czg/0xrGOQi1pdhyRnQD0VJVK+CpMIChGb/3dQl
         6zekPsOJNvYp9/7lgiBg+259615fjA26W6Z5GyDgG9pl3Bk/rafE2L5+Mqf9GEcD5WNp
         n41ADWdfglnxFH5fODmrL4+dEVM5ViXtHOoRy8lF5+2CwLz60j+UN9mc+UuJh/FAmq4s
         QjnRUQV6atYvEr1Zw4SaTzUKtzrZzJ03a0tKvsjjbTiITNpCY0913pfsUlDYjE509z16
         s64U6bTDTkXLlftpFJZvOowDWy3McXTb2XbKGf8Je2ml6Iechs7n3GL55mwjzmhaowMc
         +taQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739974723; x=1740579523;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c65p+W814m9oQCzxxz1KTZzmIhTFpCPYJR6tzp05a6w=;
        b=K6DFdiGfUfHdWGxtXJp5ieq1MgnqzxSUY9zuEVuHY55L77cl0hB+ddTBGzZMCfhdRU
         PTh0JDdZqoYKjomES6PuCoyGqXxDQhfXuvqpYxr7fahkkIJZj+F1MIa/AC5alLPaF/fC
         VWLNoBzhkLbGOSgSrkfFbMrargjhq83GkyM0mJr3sZ7G2+RpzJJ5FoKJ+bo3BGLB0oAa
         trspA6oajucpOV3k1pFzGbfaHBELOwVOf19SrITionxMsvgfEblZHfTjFbq+Ed/T+WUb
         fk97B/wbFCzz8F4V4VKo+kEQtvY8kp2RYRzpaE4ZjTLzFygLrBZRhKAInTtsUQWNa3+D
         dRmg==
X-Forwarded-Encrypted: i=1; AJvYcCWMF9NXjdXRUKeHMMML5i+m4/ObWHWWISG9iDwxncAqup1kedzcfePQNn7GHzOOSGJKPxg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy06YWVTT69AafeF2PAu0w6IoavJTFh9NXmUUqFwuHysa0XsMig
	JVa4WiGA1q72XtYdwfjnpfXZseixiE5FX/KqNQyYMPH692ZCZWXTif/rGPk9ktn4U3MtZsBgwZr
	zhg==
X-Google-Smtp-Source: AGHT+IHOtmpikt5e7ycBsXGSUnI2H4uciTvMM1w0M1qwsRTZcqLefcR59vHLVwUI8cqO6b/VLcncUsJZhCQ=
X-Received: from pfbbe20.prod.google.com ([2002:a05:6a00:1f14:b0:730:94db:d304])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a0a:b0:730:7885:d902
 with SMTP id d2e1a72fcca58-7329dcc1259mr5317325b3a.0.1739974722627; Wed, 19
 Feb 2025 06:18:42 -0800 (PST)
Date: Wed, 19 Feb 2025 06:18:41 -0800
In-Reply-To: <Z7U/IlUEcdmxSs90@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250217085535.19614-1-yan.y.zhao@intel.com> <20250217085731.19733-1-yan.y.zhao@intel.com>
 <Z7SvbSHe74HUXvz4@google.com> <Z7U/IlUEcdmxSs90@yzhao56-desk.sh.intel.com>
Message-ID: <Z7XoQU-kEF8osICK@google.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Bail out kvm_tdp_map_page() when VM dead
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 19, 2025, Yan Zhao wrote:
> On Tue, Feb 18, 2025 at 08:03:57AM -0800, Sean Christopherson wrote:
> > On Mon, Feb 17, 2025, Yan Zhao wrote:
> > > Bail out of the loop in kvm_tdp_map_page() when a VM is dead. Otherwise,
> > > kvm_tdp_map_page() may get stuck in the kernel loop when there's only one
> > > vCPU in the VM (or if the other vCPUs are not executing ioctls), even if
> > > fatal errors have occurred.
> > > 
> > > kvm_tdp_map_page() is called by the ioctl KVM_PRE_FAULT_MEMORY or the TDX
> > > ioctl KVM_TDX_INIT_MEM_REGION. It loops in the kernel whenever RET_PF_RETRY
> > > is returned. In the TDP MMU, kvm_tdp_mmu_map() always returns RET_PF_RETRY,
> > > regardless of the specific error code from tdp_mmu_set_spte_atomic(),
> > > tdp_mmu_link_sp(), or tdp_mmu_split_huge_page(). While this is acceptable
> > > in general cases where the only possible error code from these functions is
> > > -EBUSY, TDX introduces an additional error code, -EIO, due to SEAMCALL
> > > errors.
> > > 
> > > Since this -EIO error is also a fatal error, check for VM dead in the
> > > kvm_tdp_map_page() to avoid unnecessary retries until a signal is pending.
> > > 
> > > The error -EIO is uncommon and has not been observed in real workloads.
> > > Currently, it is only hypothetically triggered by bypassing the real
> > > SEAMCALL and faking an error in the SEAMCALL wrapper.
> > > 
> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 08ed5092c15a..3a8d735939b5 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4700,6 +4700,10 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
> > >  	do {
> > >  		if (signal_pending(current))
> > >  			return -EINTR;
> > > +
> > > +		if (vcpu->kvm->vm_dead)
> > 
> > This needs to be READ_ONCE().  Along those lines, I think I'd prefer
> Indeed.
> 
> > 
> > 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
> > 			return -EIO;
> > 
> > or
> > 
> > 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) 
> > 			return -EIO;
> Hmm, what's the difference between the two cases?
> Paste error?

Hrm, yes.  I already forgot what I was thinking, but I believe the second one was
supposed to be:

		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
			return -EIO;

The "check" version should be fine though, i.e. clearing the request is ok,
because kvm_vcpu_ioctl() will see vcpu->kvm->vm_dead before handling KVM_RUN or
any other ioctl.

