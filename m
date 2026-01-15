Return-Path: <kvm+bounces-68197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F8B2D25CD1
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:40:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 83F503026BFA
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 16:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9081D3BC4E0;
	Thu, 15 Jan 2026 16:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4x7Yf8OW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DDA3B8BB1
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 16:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495194; cv=none; b=EuObyiTFFHf7Er8Az2Hn8vE/o6ILbblP7qaSBSxB1pjJNopXaA/Um5kkK7tnyLCDLw6H4ksd1tyExy5CMh4gP9ZXxgZNF+YtytRg+3vPZkGAdBSrT4n4YWA6e4FFPM+68TDEMfQw7Wo28itnwewSU7OpxyenU+lNlm9X8/W2cWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495194; c=relaxed/simple;
	bh=1iriDoFQECqI5gx+5VUYCNs/AX7t++V1xszroDtDac4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j9qhdIth/vA6U70++u4mSai0ULYnR+AomXvS0ysxV01slOZb6EruUtFipJnSdL61oBwD1fGGK4fvWgL/UCiIKw31nxaEnIcoPCxckOktroTL619lB5AH9K6mgmkGZ+ATURG/Rvw6MaP2fxW2x4Yhgn9n4/XoG8+A+UvG9Ihlcpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4x7Yf8OW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c904a1168so997020a91.1
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 08:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768495193; x=1769099993; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4gTVZDa8gi4A4LKtgeOaQbZo1IPrByh19hL2H//zuzQ=;
        b=4x7Yf8OWDJQr3mTO5E0fjuvGEDKmR2RRMgHd/jvZE0Jb44ns79hj+M3DUtyp0n92gF
         ThiE762Ib9GC7sAajVeh28tjk9h41jFPk/3yfsi/BxM3EoimrXGzCf64WXWWxwfEB8zb
         zyUGlaULgh6jjk8qjyQ//z/+hwM41v3eRgeAg+LxUhVQzGkC7PekVeLdhc6Dh0Snkdq9
         PyY3jLEml3QQWVh8R7qCRsvzEf5oR9pJI6A93Rl5Tv9pjUsxnO8NoCoxXx4bDU86SoIO
         2vGk7hZIuse2AWxHMM7mPkO/xeTnnrijICEACImkrV9QNI7mXi26uGWMLBcu8ovk6J/O
         aVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768495193; x=1769099993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4gTVZDa8gi4A4LKtgeOaQbZo1IPrByh19hL2H//zuzQ=;
        b=pzygm3pgMpfiUG1ld0XyC2UuVtMf9sU4+aGXyxXkiYgUovs22uxnHUboaBpU7Zap7R
         QNCYZ20VDzy8rXRKPCzUDpvq9CR+D2bFlxK0WooMH/WXtdadzw++RBN6Z3uSUCQ3KvaQ
         CwTIxJnxaAoO3yzpqqLy5PYpGHJGSPNfLuzAUlIXrKHbds8lf24hjnuTSfVqFpXQdqrp
         C7GUUHcookyAnTKNN25FziTT0hFEFkpVH675mPkdTbBFccAQUPUuTC3w2K/iVP0ePtqZ
         gov6+dAVXaIC0TLZ1OxKR7oeMsMpnLAYv2eLXL4p2uAfQX55cTFvqFqXo6AXc6DAVHy8
         KXlg==
X-Forwarded-Encrypted: i=1; AJvYcCUQ/ht+N1taowmHvg6s82m0WFKFV1JOU8dz8W6MzTKNNQZ3Pxcmjw03kmKEWQsCIPLj5sY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxIGDS71owyCAG9jwiyDvwFdWco+/yJfFuZVq9wwna+KortbMp
	a4cM+tPHA9HKd1e/1dSJ58PTnluQiPay3EhbdXk4Z0BJenOdWh9POOglRB5wV0SWY0HGWa/jDmk
	MJGj+gg==
X-Received: from pjbqx16.prod.google.com ([2002:a17:90b:3e50:b0:34f:96fa:45e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b42:b0:330:6d2f:1b5d
 with SMTP id 98e67ed59e1d1-35272f9baa0mr72a91.26.1768495192650; Thu, 15 Jan
 2026 08:39:52 -0800 (PST)
Date: Thu, 15 Jan 2026 08:39:51 -0800
In-Reply-To: <CABgObfYk-PxxGOj3az26=tt-p7_qu=eFhgdjKFqva7Stui9HYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com> <20260115122204.GDaWjb7Npp80GK-mFn@fat_crate.local>
 <CABgObfYk-PxxGOj3az26=tt-p7_qu=eFhgdjKFqva7Stui9HYA@mail.gmail.com>
Message-ID: <aWkYVwTyOPxnRgzN@google.com>
Subject: Re: [PATCH v2 0/4] x86, fpu/kvm: fix crash with AMX
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 15, 2026, Paolo Bonzini wrote:
> Il gio 15 gen 2026, 13:22 Borislav Petkov <bp@alien8.de> ha scritto:
> >
> > On Thu, Jan 01, 2026 at 10:05:12AM +0100, Paolo Bonzini wrote:
> > > Fix a possible host panic, due to an unexpected #NM, when a KVM guest
> > > is using AMX features.
> > >
> > > The guest's XFD value, which is stored in fpstate->xfd, is used for both
> > > guest execution and host XSAVE operations.
> >
> > This already sounds weird. Why?
> 
> Because the state of disabled components is undefined anyway. There's
> no point in making all host XSAVEs more expensive, even when the TMM
> registers aren't in use by the guest (which is going to be most of the
> time, likely).
> 
> > Why don't we carry separate XFD copies - guest and host - which we use for the
> > guest and the host, respectively?
> 
> That was exactly what I did in v1, but it's more code and less efficient too.

And creates a weird ABI for KVM:

 : This also creates a nasty, subtle asymmetry in KVM's ABI.  Notably, the comment
 : above is wrong.  XSAVE does NOT run with fpstate->xfd, it runs with whatever
 : happens to be in hardware.  For non-guest tasks, fpstate->xfd is guaranteed to
 : be resident in hardware when save_fpregs_to_fpstate() runs, but for guest tasks,
 : it will usually be the _guest's_ value.  So in the common case, KVM_GET_XSAVE2
 : would not return the same data set by KVM_SET_XSAVE.
 : 
 : In theory we could ensure KVM saved exactly what is resident in hardware, but
 : that's quite tricky (and costly!) as it would require doing xfd_update_state()
 : before _every_ save_fpregs_to_fpstate(), e.g. not just in fpu_swap_kvm_fpstate().
 : E.g. if the host kernel used the FPU from IRQ context (spoiler alert!), then KVM
 : wouldn't have a chance to swap in the maximal XFD[18]=0 value (i.e. the userspace
 : task's XFD).

And IMO papered over the true bug, which is that the xstate snapshot can become
inconsistent relative to KVM's tracking of guest XFD:

 : Lastly, the fix is effectively papering over another bug, which I'm pretty sure
 : is the underlying issue that was originally encountered.  Assuming QEMU doesn't
 : intercept MSR_IA32_XFD for its own purposes, the only sequence I've come up with
 : that would result in KVM trying to load XTILE data with XFD[18]=1, without a
 : colluding userspace VMM (Paolo's selftest) is:
 : 
 :   1. vCPU loads non-init XTILE data without ever setting XFD to a non-zero value
 :      (KVM only disables XFD interception on writes with a non-zero value).
 :   2. Guest executes WRMSR(MSR_IA32_XFD) to set XFD[18] = 1
 :   3. VM-Exit due to the WRMSR
 :   4. Host IRQ arrives and triggers kernel_fpu_begin()
 :   5. save_fpregs_to_fpstate() saves guest FPU with XFD[18]=0
 :   6. fpu_update_guest_xfd() stuffs guest_fpu->fpstate->xfd = XFD[18]=1
 :   7. vcpu_enter_guest() attempts to load XTILE data with XFD[18]=1
 : 
 : Note!  There's no KVM_SET_XSAVE2 in the above, i.e. this doesn't require userspace
 : to trigger save/restore for live migration or whatever, the only timing condition
 : is the arrival of an IRQ that uses kernel FPU during the XFD 0=>1 VM-Exit.

https://lore.kernel.org/all/aVMEcaZD_SzKzRvr@google.com

