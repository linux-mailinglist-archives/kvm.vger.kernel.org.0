Return-Path: <kvm+bounces-30624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C759B9BC4F7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:54:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 500911F22AEE
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C45E383;
	Tue,  5 Nov 2024 05:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1Q5zT7Kd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0E71FCC63
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730786032; cv=none; b=psijaO9MNNo5a2Rr+qdBHeiXmqJuH52n56wMzN7RJZv2/Nul+I7qBjKCjRzYYOMfBfWIT2ZX3JriP4BAakZOSsIokWR+6wfQMDIRfx03YA2HH5MY3Jyjgl8GTLPxe15qixBGOTelj7WpWhk0LDqvsg9jfcx+/S3R7e9EmZ2fZBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730786032; c=relaxed/simple;
	bh=eJlzUMcpOmWHJiSJMWY8rp4QK+XoHVpYEtzFQswiFbk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F1FNYbb5XLLd+QTALZxTrq5VzLlJ6ngtuJ2SLF5HO219PNZtzXQR1vupQInmDNobJJWlbEmKVYQkWx4TCINiDbMvxAYMoTtAVIyBxFIxc/LKQsm8Hri6K+jTIJNzfvh8PvnEgOflJxIDmQfIaFM1yDJZqU0J8U5b0iLh3vdcV2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1Q5zT7Kd; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e38fabff35so89778177b3.0
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 21:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730786030; x=1731390830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o6I0lsXsH1rGJHzKMzLgK+XDkNKkWp36WmP2kFDs1jI=;
        b=1Q5zT7Kd+V13xaQXEcSOv4hkamoujUdt7E3nfBqylUkbKCBoCIzsP7OIwsRF3/2UFU
         G2aydnex1ijP4WXi4ITjtvFS2TE3Cco+PuKkxcIvoJT78H8dd2Tn75WS2Ak6gec7psbo
         sg5rlJR4fP20yeHjgDFLan58rQJj0hv610DSjbOAlTSRl64YT2S1QHbrhIM0ndFDL2gO
         IYuEEfVRBSO3cNeK5XNEUXUesq4q9CK4HpQd6R/UZRxt6ayb0H4cdX3C+ORxxW7cYIty
         WJ1547FYsfjZ13Vx0HLtDEP9J52TT5dX88rEZQNu5MeJoRD/lL/FCpcatXNGJPwD9tUL
         fmKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730786030; x=1731390830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o6I0lsXsH1rGJHzKMzLgK+XDkNKkWp36WmP2kFDs1jI=;
        b=LPlxQa3zkt8Qfs6gIvOFMZqv2rLkKVq2eEWdkhdtFQXnDuFAWZM7BmGuz6KfuAwspZ
         BV56ccLXiLgrkmlSadsU07tU5Jv2pnh/gCLI+rxwxxdFHRuO6sgrak6NNQ2W7Vw0C/ue
         K4NyfUhPOiL5U0RoSY2hL7DvuT6CBGffPOqzkUACtR4AdWuk2+ZuQQQQHspXHu3C/fpV
         fZ2g5G2TTrg5m9xK/ebeAUJsFSiwhyfISKrzGOIspPCuZhPmAjOAY0JuyXWRqfbnD1nC
         L4h0vBC5FFYLmWcj5327HKtcWdsm3x3yHofd9633BpOo/SCQGGFWFBSU2R/KPgDnBXRT
         N3WQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEiA7VmggLHh61hJmVtW111H7rHjuQPIEYZqGCWXoci/94ryHxs8cTx2yi7WjicFzrkNc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm1yS4jfqkNM+skGWZ91/f8VatmpYERja83kVW2A1dAQtsCGQh
	nf50Kz5NihB1zMQqVk3wygW4ftJ1iu853UxsCucBhFP2RDJ/AzG241W39SAdGL1VTDxyK78dB8I
	RDg==
X-Google-Smtp-Source: AGHT+IHmt5sO/CGCgduHfJxMGbReWDqaMZI7StkG46sJTWcczU8fUEuPHD4g/HJnJzDHoYjdX9OGGAkVpzc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4489:b0:6db:c6eb:bae9 with SMTP id
 00721157ae682-6e9d898f08bmr16943867b3.2.1730786030202; Mon, 04 Nov 2024
 21:53:50 -0800 (PST)
Date: Mon, 4 Nov 2024 21:53:48 -0800
In-Reply-To: <173039503553.1508387.3074658713815866060.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com> <173039503553.1508387.3074658713815866060.b4-ty@google.com>
Message-ID: <Zymy7M5dHs6dWUmu@google.com>
Subject: Re: [PATCH v3 00/14] KVM: selftests: Morph max_guest_mem to mmu_stress
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 31, 2024, Sean Christopherson wrote:
> On Wed, 09 Oct 2024 08:49:39 -0700, Sean Christopherson wrote:
> > The main purpose of this series is to convert the max_guest_memory_test
> > into a more generic mmu_stress_test.  The basic gist of the "conversion"
> > is to have the test do mprotect() on guest memory while vCPUs are
> > accessing said memory, e.g. to verify KVM and mmu_notifiers are working
> > as intended.
> > 
> > Patches 1-4 are a somewhat unexpected side quest.  The original plan was
> > that patch 3 would be a single patch, but things snowballed.
> > 
> > [...]
> 
> Applied to kvm-x86 selftests, with the typo fixup pointed out by James.  Thanks!
> 
> [01/14] KVM: Move KVM_REG_SIZE() definition to common uAPI header
>         https://github.com/kvm-x86/linux/commit/5e07fd0bf516
> [02/14] KVM: selftests: Disable strict aliasing
>         https://github.com/kvm-x86/linux/commit/d1ce2bcd8d2e
> [03/14] KVM: selftests: Return a value from vcpu_get_reg() instead of using an out-param
>         https://github.com/kvm-x86/linux/commit/5c6c7b71a45c
> [04/14] KVM: selftests: Assert that vcpu_{g,s}et_reg() won't truncate
>         https://github.com/kvm-x86/linux/commit/6aa2df3eb90b
> [05/14] KVM: selftests: Check for a potential unhandled exception iff KVM_RUN succeeded
>         https://github.com/kvm-x86/linux/commit/be9f2746d20b
> [06/14] KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/06694f27cfcc
> [07/14] KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/8556ce365a07
> [08/14] KVM: selftests: Compute number of extra pages needed in mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/c7b7876ac5d4
> [09/14] KVM: sefltests: Explicitly include ucall_common.h in mmu_stress_test.c
>         https://github.com/kvm-x86/linux/commit/a657856469e1
> [10/14] KVM: selftests: Enable mmu_stress_test on arm64
>         https://github.com/kvm-x86/linux/commit/1e53cde06102
> [11/14] KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/8630563012b9
> [12/14] KVM: selftests: Precisely limit the number of guest loops in mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/3d4585c220dc
> [13/14] KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
>         https://github.com/kvm-x86/linux/commit/eaafeebca75a
> [14/14] KVM: selftests: Verify KVM correctly handles mprotect(PROT_READ)
>         https://github.com/kvm-x86/linux/commit/a3cd5c187742

As mentioned later in the thread[*], I dropped this series from the 6.13 queue
and will instead target 6.14.

I did however grab the no-strict-aliasing fix for 6.12, and tagged it for stable.
There's no reason to wait to land that commit, and I definitely have no desire to
ever debug that mess again.

[02/14] KVM: selftests: Disable strict aliasing
      https://github.com/kvm-x86/linux/commit/5b188cc4866a

[*] https://lore.kernel.org/all/ZyT61FF0-g8gKZfc@google.com

