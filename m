Return-Path: <kvm+bounces-56615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29AE2B40B8A
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 19:04:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E10242084C5
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 17:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3033A341666;
	Tue,  2 Sep 2025 17:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bjrPBcOr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0DC2E11B8
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 17:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756832682; cv=none; b=s//FH890sq+rtF6qCTMOTUawGDj4xZb/5hbMvmyWyzj8Xk2d9yDeMXkZ+5No6lGAOts1nDIBLmBuZtqnxAFB2F+xV4kZnvlKgFwc7g83EEkLSiJ0vecX06jTluNVI2CAcmyqTNFUwKkjUYefeE5j/Dy9cEm9ix5iKJDlGrWpUUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756832682; c=relaxed/simple;
	bh=SMUkP0mnR8ttMeYUrjJsKoDULZmiSRA+4BBJ8ckn9Z0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lCUneC/wchSYfylZJ/wR4MWRZrozyQMzSgp8+rME5MZt3ci02WyqKSA5bwpCEaxKnVlz8KH/VbUyQzfj0yQfwZjGLpDicPRwEkg9fVWJjJgXF2ZfNnAjFAXda6q7dzM6fKPpfncM825agU9u/44Xj7AJNgziao0alUFVu87rrPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bjrPBcOr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32b58dd475eso106422a91.1
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 10:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756832680; x=1757437480; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2LMLEHyEbRIdXaggZuzXCIZ0dmnUQmlDXD9SxdiA60I=;
        b=bjrPBcOrxDJnQ1eO21t+5swA18i+hi8HZL6y5g7dYBYlJq+Rf+Md2IgDVM82VoVCKS
         1GdCNdSx0mWKS0tnXizOedk/C2n3xfRiHdmP6xeo62pro6kE94W9wnE8D3XP9fpSi+RH
         3er9uIY+e+kTZ+Ry5uY6fTf5zmHhLkwF1BdN8VknLrgzMXUVAO/xAWFd0FL7qBIgQZMP
         L/ezJydhvQsc2ZSFSlKCi+vyPKcZO72VPJXgDr5oK6S13vc8Q4ijtZzQ0tN4VHyy+5Xt
         SzlhMN3x9PFpU0S5Y/VuAuaLAdE1k3hJDNCwhY/h0qSaZoNch4Hetvv42eAjPoblzcoB
         a/8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756832680; x=1757437480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2LMLEHyEbRIdXaggZuzXCIZ0dmnUQmlDXD9SxdiA60I=;
        b=YRJ63E2euZlu1hySTTyDVykrf3QCWJWX5dYg+a9G9xPT2h5XaRiidfSidLP3e7R4wk
         7D0k+/zb1UjxZnvtEd+EnjDhyIK0aNlfmg95wRJI3n5LM7+8vsFzmOfw46wKVUi1UvQK
         aB0Yu5Ib5GCpmwuj/1qlE71JV/Kl8u73qd93ti5QHT7xI/uGZLs7UO7YH3n8q18nxXZY
         f3ZNgOLh2Iwp452qfnpgS7zlp3oeC57l7MNlNn9VrzWYh1M7crULCj0G4YMcybDahS4k
         ggKAykFD6f6Of5cdb9Bn8uYnt2ApBFtVGlh5gSnJa4+6Fa/ZuK7Vam+yNmkTg7y59PQ2
         NqeA==
X-Forwarded-Encrypted: i=1; AJvYcCUg8PPWb3W5pB8tS+j2rNKCIuFGKpNNjHWBih4u2MduE+3kNf+HLcbivvxTACpVkGa+jas=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5+nJ8BN+ZkBhnKk9ytZ7yFZtgOw4kwpM4ActbHFeQmNx0g1dK
	gbwtnyjNCJd+Gwvy3T7COlM42cJQ2WI1sPCIf/M6FDhVKcOeoCw9SAMpS36fZRIcKSFJGJ9pDla
	ouehilA==
X-Google-Smtp-Source: AGHT+IG8vQ2i+8u5m20u/+QD7Xbccgaeo/0vxgLTqeVP8u6AK0S/QWOHDA2bJ2dqkK9l8xruUzSgK+8OWYY=
X-Received: from pjbsp16.prod.google.com ([2002:a17:90b:52d0:b0:329:e84e:1c50])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d0f:b0:329:e4d1:c20f
 with SMTP id 98e67ed59e1d1-329e4d1c399mr3616187a91.9.1756832680152; Tue, 02
 Sep 2025 10:04:40 -0700 (PDT)
Date: Tue, 2 Sep 2025 10:04:38 -0700
In-Reply-To: <aLa34QCJCXGLk/fl@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com> <20250829000618.351013-13-seanjc@google.com>
 <aLFiPq1smdzN3Ary@yzhao56-desk.sh.intel.com> <8445ac8c96706ba1f079f4012584ef7631c60c8b.camel@intel.com>
 <aLIJd7xpNfJvdMeT@google.com> <aLa34QCJCXGLk/fl@yzhao56-desk.sh.intel.com>
Message-ID: <aLcjppW1eiCrxJPC@google.com>
Subject: Re: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the initial
 measurement fails
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 02, 2025, Yan Zhao wrote:
> But during writing another concurrency test, I found a sad news :
> 
> SEAMCALL TDH_VP_INIT requires to hold exclusive lock for resource TDR when its
> leaf_opcode.version > 0. So, when I use v1 (which is the current value in
> upstream, for x2apic?) to test executing ioctl KVM_TDX_INIT_VCPU on different
> vCPUs concurrently, the TDX_BUG_ON() following tdh_vp_init() will print error
> "SEAMCALL TDH_VP_INIT failed: 0x8000020000000080".
> 
> If I switch to using v0 version of TDH_VP_INIT, the contention will be gone.

Uh, so that's exactly the type of breaking ABI change that isn't acceptable.  If
it's really truly necessary, then we can can probably handle the change in KVM
since TDX is so new, but generally speaking such changes simply must not happen.

> Note: this acquiring of exclusive lock was not previously present in the public
> repo https://github.com/intel/tdx-module.git, branch tdx_1.5.
> (The branch has been force-updated to new implementation now).

Lovely.

> > Acquire kvm->lock to prevent VM-wide things from happening, slots_lock to prevent
> > kvm_mmu_zap_all_fast(), and _all_ vCPU mutexes to prevent vCPUs from interefering.
> Nit: we should have no worry to kvm_mmu_zap_all_fast(), since it only zaps
> !mirror roots. The slots_lock should be for slots deletion.

Oof, I missed that.  We should have required nx_huge_pages=never for tdx=1.
Probably too late for that now though :-/

> > Doing that for a vCPU ioctl is a bit awkward, but not awful.  E.g. we can abuse
> > kvm_arch_vcpu_async_ioctl().  In hindsight, a more clever approach would have
> > been to make KVM_TDX_INIT_MEM_REGION a VM-scoped ioctl that takes a vCPU fd.  Oh
> > well.
> > 
> > Anyways, I think we need to avoid the "synchronous" ioctl path anyways, because
> > taking kvm->slots_lock inside vcpu->mutex is gross.  AFAICT it's not actively
> > problematic today, but it feels like a deadlock waiting to happen.
> Note: Looks kvm_inhibit_apic_access_page() also takes kvm->slots_lock inside
> vcpu->mutex.

Yikes.  As does kvm_alloc_apic_access_page(), which is likely why I thought it
was ok to take slots_lock.  But while kvm_alloc_apic_access_page() appears to be
called with vCPU scope, it's actually called from VM scope during vCPU creation.

I'll chew on this, though if someone has any ideas...

> So, do we need to move KVM_TDX_INIT_VCPU to tdx_vcpu_async_ioctl() as well?

If it's _just_ INIT_VCPU that can race (assuming the VM-scoped state transtitions
take all vcpu->mutex locks, as proposed), then a dedicated mutex (spinlock?) would
suffice, and probably would be preferable.  If INIT_VCPU needs to take kvm->lock
to protect against other races, then I guess the big hammer approach could work?

