Return-Path: <kvm+bounces-16243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D34D8B7D4F
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:42:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D69A3288E9F
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 16:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09281369AC;
	Tue, 30 Apr 2024 16:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v/v9fkCh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF13B660
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 16:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495321; cv=none; b=ExaD1OsWR/zNjckb6AtR5IkDI9nrYmVoTyD+8Da6V676NA292K0c6u2+UnFRPrwSAOlGF1vG1dlMClpUn46rfenfLrHibGQEdjY6yKE7EHRWUSLbuIhPHfCNs0F6kYnOe7ND/l83rOi1hMmi+My6hjI7Fk8hSDypm8/SKfULc+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495321; c=relaxed/simple;
	bh=RuvHynscEx3N8O2nIhWF28blEo7KtGpEEGv8k7du9OU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YueDLvRdRyGeQR1ugdlJPm9cG+nzYC1/98bGpjq5bG2r1mHuGugzU5AKU6tpq6Ndm0EVq/bi2q4PJ5al6X/b2oqs6gu+vXB8PJ1GeSbuwx2+SuvbJ8U09vIA3l6TJJckOP1tGoas+dbcGkAMcFp8MMsRjFnRCh9eBUnN2KF6xYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v/v9fkCh; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61b028ae5easo113866337b3.3
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 09:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714495318; x=1715100118; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HykZgCnzrTWilDdkz18AStr1PJXUUU2WkRFzPbgFFyw=;
        b=v/v9fkChnawgExg2Yt6aVpKauichowmX8TBFaOYPrtQlZLvssnAGskVa1FLoDVpjEQ
         Ov5NPeorAOaKcy+9TqzJQKse4L1TJazvXOaQIYAUxhfosCJ+sMk+5J2TlXX5eqH0xuO2
         h5Vk87h6KlMrV7xx3S6KpIFmm7cVN1K7UHVfkg/qRJgk2efhY9qoxsGLUnFG/WL9zIaH
         85xMBYqUET0xL/s1kDbYw2tXxv9Ima8mwmcfyVd7dimkt56xQAqGACMw3PqTGUeItIx5
         eWBo40kYwjYk1GWZKtYk8bnuLEkZT+KEzbuhwrL+rtp1ThT9fqsITD18MWPvD3Z+wbOb
         Uv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714495318; x=1715100118;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HykZgCnzrTWilDdkz18AStr1PJXUUU2WkRFzPbgFFyw=;
        b=ffAXVHLvQWekCsiQu2mpnAL5W6cY4e90v9Pom/Bq45fpCtp3s357Fo1d4EPNdXYjni
         eHuFzPjSZn++efZRtvELYq5iKG6XGYkK0F+Vx0QTAgdDt6Mvm3ZoZ/CqRlmcNdtjULiP
         i8E3TEpAtIV0E0EX9SwyL6ET2hQx6dE3lNGXtMCMpdBim5wk2tfrXeEjgSa4rQ25hI19
         Dcs4OYyM3HSRTwc6N4k1gv/y2nYAbbey30rOFPDUuYTaw7vXhfz8tFevxpQSiW8RJg8m
         4o70EyaBgI9nR0zufZTMa4Zs++FxO3eWft9dOy2blLn9b1jK+GynS13ai9Aq0sXlEUrz
         qqfw==
X-Gm-Message-State: AOJu0Yx9XWs7WWXCUwTiFOYdp4q3rcSjeDJ36x1PN5uS6H81fYPpluBW
	XoIIuKJ+ELnUdJrOv2+MZZ8PQmDNI7Udm3o6lBuSNcBts58AArmVZbQ+4mQnUgzGWwWxaeo0GCu
	2Ig==
X-Google-Smtp-Source: AGHT+IExN7D/AXMuuMNNIQ+8aw15bUi9aAxVMC3n/+QqLMlUJXLUJIqwFzQRElvnDeXoIhP5WEuIwouXGX4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d8a:b0:61b:eb95:7924 with SMTP id
 da10-20020a05690c0d8a00b0061beb957924mr26116ywb.3.1714495318293; Tue, 30 Apr
 2024 09:41:58 -0700 (PDT)
Date: Tue, 30 Apr 2024 09:41:56 -0700
In-Reply-To: <bug-218792-28872@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-218792-28872@https.bugzilla.kernel.org/>
Message-ID: <ZjEfVNwRnE1GUd1T@google.com>
Subject: Re: [Bug 218792] New: Guest call trace with mwait enabled
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 30, 2024, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218792
> 
>             Bug ID: 218792
>            Summary: Guest call trace with mwait enabled
>            Product: Virtualization
>            Version: unspecified
>           Hardware: Intel
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: farrah.chen@intel.com
>         Regression: No
> 
> Environment:
> host/guest kernel:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> e67572cd220(v6.9-rc6)
> QEMU: https://gitlab.com/qemu-project/qemu.git master 5c6528dce86d
> Host/Guest OS: Centos stream9/Ubuntu24.04
> 
> Bug detail description: 
> Boot Guest with mwait enabled(-overcommit cpu-pm=on), guest call trace
> "unchecked MSR access error"
> 
> Reproduce steps:
> img=centos9.qcow2
> qemu-system-x86_64 \
>     -name legacy,debug-threads=on \
>     -overcommit cpu-pm=on \
>     -accel kvm -smp 8 -m 8G -cpu host \
>     -drive file=${img},if=none,id=virtio-disk0 \
>     -device virtio-blk-pci,drive=virtio-disk0 \
>     -device virtio-net-pci,netdev=nic0 -netdev
> user,id=nic0,hostfwd=tcp::10023-:22 \
>     -vnc :1 -serial stdio
> 
> Guest boot with call trace:
> [ 0.475344] unchecked MSR access error: RDMSR from 0xe2 at rIP:

MSR 0xE2 is MSR_PKG_CST_CONFIG_CONTROL, which hpet_is_pc10_damaged() assumes
exists if PC10 substates are supported. KVM doesn't emulate/support
MSR_PKG_CST_CONFIG_CONTROL, i.e. injects a #GP on the guest RDMSR, hence the
splat.  This isn't a KVM bug as KVM explicitly advertises all zeros for the
MWAIT CPUID leaf, i.e. QEMU is effectively telling the guest that PC10 substates
are support without KVM's explicit blessing.

That said, this is arguably a kernel bug (guest side), as I don't see anything
in the SDM that _requires_ MSR_PKG_CST_CONFIG_CONTROL to exist if PC10 substates
are supported.

The issue is likely benign, other that than obvious WARN.  The kernel gracefully
handles the #GP and zeros the result, i.e. will always think PC10 is _disabled_,
which may or may not be correct, but is functionally ok if the HPET is being
emulated by the host, which it probably is.

	rdmsrl(MSR_PKG_CST_CONFIG_CONTROL, pcfg);
	if ((pcfg & 0xF) < 8)
		return false;

The most straightforward fix, and probably the most correct all around, would be
to use rdmsrl_safe() to suppress the WARN, i.e. have the kernel not yell if
MSR_PKG_CST_CONFIG_CONTROL doesn't exist.  Unless HPET is also being passed
through, that'll do the right thing when Linux is a guest.  And if a setup also
passes through HPET, then the VMM can also trap-and-emulate MSR_PKG_CST_CONFIG_CONTROL
as appropriate (doing so in QEMU without KVM support might be impossible, though
again it's unnecessary if QEMU is emulating the HPET).

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index c96ae8fee95e..2afafff18f92 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -980,7 +980,9 @@ static bool __init hpet_is_pc10_damaged(void)
                return false;
 
        /* Check whether PC10 is enabled in PKG C-state limit */
-       rdmsrl(MSR_PKG_CST_CONFIG_CONTROL, pcfg);
+       if (rdmsrl_safe(MSR_PKG_CST_CONFIG_CONTROL, pcfg))
+               return false;
+
        if ((pcfg & 0xF) < 8)
                return false;

> 0xffffffffb5a966b8 (native_read_msr+0x8/0x40)
> [ 0.476465] Call Trace:
> [ 0.476763] <TASK>
> [ 0.477027] ? ex_handler_msr+0x128/0x140
> [ 0.477460] ? fixup_exception+0x166/0x3c0
> [ 0.477934] ? exc_general_protection+0xdc/0x3c0
> [ 0.478481] ? asm_exc_general_protection+0x26/0x30
> [ 0.479052] ? __pfx_intel_idle_init+0x10/0x10
> [ 0.479587] ? native_read_msr+0x8/0x40
> [ 0.480057] intel_idle_init_cstates_icpu.constprop.0+0x5e/0x560
> [ 0.480747] ? __pfx_intel_idle_init+0x10/0x10
> [ 0.481275] intel_idle_init+0x161/0x360
> [ 0.481742] do_one_initcall+0x45/0x220
> [ 0.482209] do_initcalls+0xac/0x130
> [ 0.482643] kernel_init_freeable+0x134/0x1e0
> [ 0.483159] ? __pfx_kernel_init+0x10/0x10
> [ 0.483648] kernel_init+0x1a/0x1c0
> [ 0.484087] ret_from_fork+0x31/0x50
> [ 0.484541] ? __pfx_kernel_init+0x10/0x10
> [ 0.485030] ret_from_fork_asm+0x1a/0x30
> [ 0.485462] </TASK>
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.

