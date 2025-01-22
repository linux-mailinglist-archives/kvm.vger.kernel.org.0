Return-Path: <kvm+bounces-36220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0193CA18B92
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 07:02:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9ED4C1884040
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 06:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7916C19007D;
	Wed, 22 Jan 2025 06:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d3FKjh6v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C7D14A619
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 06:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737525757; cv=none; b=ihh4btnUfjyQII12CWS3LBW5ej/hKTWUBp/M9bdWTdPB9KAw9FD11RQ3nn2EAUDKiCu/g36Z76YE7u87LHhEM5Xv2pRC8BspgoeWXHeDuJSeaXN+P5ZKzi1TLrzL65PN8Pu0t7mq1cr4CuyIqo+HTI/kCjw9hdGqlRuzFF9tyFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737525757; c=relaxed/simple;
	bh=Wi9pr1dIRcwr1+NR/edbtY4oMgqpwXXn6OtV1EpZDvw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=X/PSttSsSnBLj7e1FyHjnCXDHfIeRQk6uz1CoJ2axc/Iyb8bLwcAoK20663hsc0pBRhU/m6OdRorjSO7skY6yTZEBHp0NQC9YTbcaO4OBKkOHY/xijyNVzOyRmCRIY3ZJaRbgkuifjLYBotzUKwWpPC38bqX7XK+Qh+THRAGfJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d3FKjh6v; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aaf3c3c104fso1255911266b.1
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 22:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737525754; x=1738130554; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZXOl6WdYwG2K4mEEpy1F9d5rBMT1V4GutAkmnt8NIbA=;
        b=d3FKjh6vtQkVHuJ+7uH6c4ZDlKoRiFc2vKZ28+BDgiqG6cGE5Uh+mVQru5Gdz+5TDF
         ERQ0m89vfuE6WMMDUY9yS+WzWPnObca0oyzmYvSE42ZTVqUZd/1UThbZP4z/7TfxwBPF
         nbmZcftP0YAfctmeSDkduSDTLv1EG9UmO412O1Dp50tE4IEBAz4Q0eUuD8emlukGNLgL
         alCYH3bkzIi2IuD4f0x4XKngDDiPqg8/0KOqPJVTHsRJAplT25i8zao5X9nzCuUZh1t/
         OMGi9xrnONljhEkv4y51W5OEtC9S8tzGAWDglx7hVek5uWBLkDbDwecR6UkS7Jhz8wwZ
         i5Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737525754; x=1738130554;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZXOl6WdYwG2K4mEEpy1F9d5rBMT1V4GutAkmnt8NIbA=;
        b=G4uDB/xdgm/M5K0M0iMk11kstzaOhXRIf/TKHga/eqZBH8+mC/3pUZkY2TkP9w8yZY
         v/y1WVKJxFlYPtLCM1xclGounSoZJ2NZrBOLzUDvLvliSCgpTIfCPmKfAetU369KqgXv
         wZOEiVgq37OAwpZzGM8lCP4BEDfuhPxAoKhM/vyZ5CMauxOjEtosnr7ojZtPPpMnpFQA
         VRqaj83nX0xcTnNp8IVJcjXmLpMdRXeriOZOzztvOhhC5lZUpfFXZ324b6ksMJfvkj+5
         o1YWs88Qc5hTjw9NwtKYNhH/l+d6pMkftqumAIaW8BoQnsiipLTwW6kVBs1scqQfbUAQ
         kTTA==
X-Forwarded-Encrypted: i=1; AJvYcCXgltd4tZ2dbcfoXRTo4UxnQiPhWLa4CmXnYq9PwPLlPwrIWAGtxtmxXIFNNa/6bD609Us=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvRImHb91YhSlh2Ey9eds0TykpMCjSkw1sEiU90ZHOIRrz5isS
	ex2mYa8FN0Jr8y5NgPaTf0lDdxPSljN+guuVJnBssAQ0q76/lzgSw7NlBzuCdG+n9qstGPnruo+
	/1+0pwtAkNpfYKPYQuuklsFJMKA9UTIiYG5KGrVMleDQHYgnfSoTl2A==
X-Gm-Gg: ASbGnctcr92tBU03ZyKJ1kW5s78FPgeS0nYM8dG12rIsyHyBcH9Sp9IoNYz/r7l2g84
	bLcPv1Ell0fQqXfUFigGeip2Z5XbTBxA38MIJQx+zcmdEYxBYnr9L7aAj7xuGDebdbeamrzcj1l
	ugyIdD
X-Google-Smtp-Source: AGHT+IGXmg/LOjeS/FchY3VO9xMq8SPGqlLeo/7zuKndnBOq/2pBWKoIs3TkhMvCBPNbYgwXtAgaHEGQbJLgjaWqJhE=
X-Received: by 2002:a17:906:22cd:b0:ab3:a0ad:17aa with SMTP id
 a640c23a62f3a-ab3a0ad2018mr1486754666b.56.1737525750045; Tue, 21 Jan 2025
 22:02:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: John Stultz <jstultz@google.com>
Date: Tue, 21 Jan 2025 22:02:18 -0800
X-Gm-Features: AbW1kvZF0IwIU4eo5ucO2covu9JBx-81r3Al2LNyWnwtOkMOCwpUD__O5qKvlb4
Message-ID: <CANDhNCq5_F3HfFYABqFGCA1bPd_+xgNj-iDQhH4tDk+wi8iZZg@mail.gmail.com>
Subject: BUG: Occasional unexpected DR6 value seen with nested virtualization
 on x86
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Jim Mattson <jmattson@google.com>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, 
	kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

For awhile now, when testing Android in our virtualized x86
environment (cuttlefish), we've seen flakey failures ~1% or less in
testing with the bionic sys_ptrace.watchpoint_stress test:
https://android.googlesource.com/platform/bionic/+/refs/heads/main/tests/sys_ptrace_test.cpp#221

The failure looks like:
bionic/tests/sys_ptrace_test.cpp:(194) Failure in test
sys_ptrace.watchpoint_stress
Expected equality of these values:
  4
  siginfo.si_code
    Which is: 1
sys_ptrace.watchpoint_stress exited with exitcode 1.

Basically we expect to get a SIGTRAP with si_code: TRAP_HWBKPT, but
occasionally we get an si_code of TRAP_BRKPT.

I managed to reproduce the problem, and isolated it down to the call path:
[  173.185462] __send_signal_locked+0x3af/0x4b0
[  173.185563] send_signal_locked+0x16e/0x1b0
[  173.185649] force_sig_info_to_task+0x118/0x150
[  173.185759] force_sig_fault+0x60/0x80
[  173.185847] send_sigtrap+0x48/0x50
[  173.185933] noist_exc_debug+0xbe/0x100

Where we seem to be in exc_debug_user():
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/traps.c#n1067

Specifically here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/traps.c#n1130
        icebp = !dr6;
        ...
        /* Add the virtual_dr6 bits for signals. */
        dr6 |= current->thread.virtual_dr6;
        if (dr6 & (DR_STEP | DR_TRAP_BITS) || icebp)
        send_sigtrap(regs, 0, get_si_code(dr6));

Where get_si_code() is here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/include/asm/traps.h#n28
static inline int get_si_code(unsigned long condition)
{
        if (condition & DR_STEP)
                return TRAP_TRACE;
        else if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
                return TRAP_HWBKPT;
        else
                return TRAP_BRKPT;
}

We seem to be hitting the case where dr6 is null, and then as icebp
gets set in that case, we will call get_si_code() with a zero value
code, that gives us TRAP_BRKPT instead of TRAP_HWBKPT.

The dr6 value passed to exc_debug_user() comes from
debug_read_clear_dr6() in the definition for
DEFINE_IDTENTRY_DEBUG_USER(exc_debug):
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/traps.c#n1147
Where debug_read_clear_dr6() is implemented here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/traps.c#n926

I then cut down and ported the bionic test out so it could build under
a standard debian environment:
https://github.com/johnstultz-work/bionic-ptrace-reproducer

Where I was able to reproduce the same problem in a debian VM (after
running the test in a loop for a short while).

Now, here's where it is odd. I could *not* reproduce the problem on
bare metal hardware, *nor* could I reproduce the problem in a virtual
environment.  I can *only* reproduce the problem with nested
virtualization (running the VM inside a VM).

I have reproduced this on my intel i12 NUC using the same v6.12 kernel
on metal + virt + nested environments.  It also reproduced on the NUC
with v5.15 (metal) + v6.1 (virt) + v6.1(nested).

I've also reproduced it with both the vms using only 1 cpu, and
tasksetting qemu on the bare metal to a single cpu to rule out any
sort issue with virtcpus migrating around.

Also setting enable_shadow_vmcs=0 on the metal host didn't seem to
affect the behavior.

I've tried to do some tracing in the arch/x86/kvm/x86.c logic, but
I've not yet directly correlated anything on the hosts to the point
where we read the zero DR6 value in the nested guest.

But I'm not very savvy around virtualization or ptrace watchpoints or
low level details around intel DB6 register, so I wanted to bring this
up on the list to see if folks had suggestions or ideas to further
narrow this down?  Happy to test things as it's pretty simple to
reproduce here.

Many thanks to Alex Bennee and Jim Mattson for their testing
suggestions to help narrow this down so far.

thanks
-john

