Return-Path: <kvm+bounces-43026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EADCA8317E
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 22:01:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00BEC1885B34
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 19:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D7C2144BC;
	Wed,  9 Apr 2025 19:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aI9teiPp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F894213E90
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 19:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744228431; cv=none; b=K6w610fR584Oa+GBJkkHVzJ6FNuOBy+Vmg5KowUhxdUpcdHVGpLWCc8z8he0avWFhvQEP6rg1Hcsna4EoFD9X1HtepYtxV7abTFkjwQ+KRjB2Pks1oZnkk6mMmOJT3pc5Hkj4RncGFQhJrkfrqKTrNuRM6AytFMXs3ua8zzJW84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744228431; c=relaxed/simple;
	bh=rv4mMwuG4jkn773xC8sA0ToKXoLaQgRn7SHaoclVUrY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bLxqrI1vdlQ6rZNLaUgLW8r6NlUfD92DtL+7FEaeSnVOztB9Mwu5ivjgdRO3scMf2jorFovFnbE5mgYVtV8XekzD2CMwO76XRfhV2CNI4mD14Z0PA/RzS60ntXZUTSrnxrzR1U75j/I0yj7mlrKajBnp1Hnf5HPMDh/WqVyy70k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aI9teiPp; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-72f3b4c0305so16825b3a.0
        for <kvm@vger.kernel.org>; Wed, 09 Apr 2025 12:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744228429; x=1744833229; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B/LBm3aV4zfAmxi92/BK6RmsqnpaBnCdXpzKq52/Foc=;
        b=aI9teiPp4IOAdU9GBsw2c5UUNtJjfzYDo5oOlVpoK02KZbfJDi4/BUpMOgjUTDDP77
         Zo1cFX/mi1CVaa7zifjJZefTiSM4bKVOBRbxcHWDsR4ra5zIy6Q8gxph2QBBXdTfWPR0
         5OQe5GpPbqiVQys+My9WQ6FIq3wGpo5XZ/aX/6wj+SeZn0pkfDwDGx1345vl3dMMVxH9
         XNN9BcliriZjlo6Nu9bsZMO7F7TC8FUiDzYlGA2mNiW7XM6g2jB0KjlK3q1zQA8WX7QA
         IvmRm67Z5XfxmOWM6F9ibvqDxN6Uam9M7Va/UcIZ8+KdMP9uVdgncS5xeXVLnTkaWbTL
         dP/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744228429; x=1744833229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B/LBm3aV4zfAmxi92/BK6RmsqnpaBnCdXpzKq52/Foc=;
        b=eDoUqgu64B6RUdkQrPhBs5YQEe+/x41554yPwEgNnBgtloWJ2ehLZMnLVZXAuxM407
         h6j9cgBcPgobNN5joZ1jBr11wmDBwdoDSkCnTtMXv65QlFt0djbhvvelwBEm63w6hT6g
         6ElvRqz8Knrsv/tBZIZq1q1mtVflfY4oSqVGtFXMz1OR+et+A+u481uFwHwqCBqMpfEK
         iFUM1ON6SdGOgQQeEVElDEzeMnOadYkk76HwrTXFYJk7sqVEi9Sq11d6cMQ1FubdyOM8
         LYpSj3az/6ULX0wnZOFP/Ipy2+Hhx+XEKerB/pOckLhL9mdbtp6cpkJH0URXbR6M9zyo
         VtvA==
X-Gm-Message-State: AOJu0YylNxiNmXNOYY2kRpqWs+z9ggiqV3flH/KGLTjAyOIzyRacOiW2
	c/qVOX6nr1gWcCaj7eeb17WOqmsNMVRJ12OKZ7JhEjTk0Gd0kimEWZgshR/iktvwTCbVQOIeSo9
	Ycw==
X-Google-Smtp-Source: AGHT+IEeESm/upruWypiAiAFjj3gqiD2FWPZpn5Oi58JT7YjI+D2LtDvdvxhwdzcKYcXLoDvWUFBt/R8XtU=
X-Received: from pfkq6.prod.google.com ([2002:a05:6a00:846:b0:737:6e43:8e34])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:130c:b0:736:bfc4:ef2c
 with SMTP id d2e1a72fcca58-73bbec49ac8mr221785b3a.0.1744228428902; Wed, 09
 Apr 2025 12:53:48 -0700 (PDT)
Date: Wed, 9 Apr 2025 12:53:47 -0700
In-Reply-To: <20250409014136.2816971-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250409014136.2816971-1-mlevitsk@redhat.com>
Message-ID: <Z_bQS63A2bd-LzgQ@google.com>
Subject: Re: [PATCH v2 0/4] KVM: extract lock_all_vcpus/unlock_all_vcpus
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvm-riscv@lists.infradead.org, 
	Oliver Upton <oliver.upton@linux.dev>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Jing Zhang <jingzhangos@google.com>, Waiman Long <longman@redhat.com>, x86@kernel.org, 
	Kunkun Jiang <jiangkunkun@huawei.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Anup Patel <anup@brainfault.org>, Albert Ou <aou@eecs.berkeley.edu>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>, 
	Borislav Petkov <bp@alien8.de>, Alexandre Ghiti <alex@ghiti.fr>, 
	Keisuke Nishimura <keisuke.nishimura@inria.fr>, Sebastian Ott <sebott@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Will Deacon <will@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, linux-riscv@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="us-ascii"

+Adrian

On Tue, Apr 08, 2025, Maxim Levitsky wrote:
> Implement Paolo's suggestion of reusing

Ha!  I *knew* this felt familiar when I suggested extracting (un)lock_all_vcpus()
to common code in the context of the TDX series.

https://lore.kernel.org/all/Z-V0qyTn2bXdrPF7@google.com

> sev_lock/unlock_vcpus_for_migration in arm and riscv code
> for the purpose of taking vcpu->mutex of all vcpus of a VM.
> 
> Because sev_lock/unlock_vcpus_for_migration already have a workaround
> for lockdep max lock depth, this fixes the lockdep warnings on arm
> which were the inspiration for this refactoring.
> 
> This patch series was only compile tested on all 3 architectures.
> 
> V2: added trylock option to kvm_lock_all_vcpus to be better compatible
> with the orginal code.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (4):
>   locking/mutex: implement mutex_trylock_nested
>   KVM: x86: move sev_lock/unlock_vcpus_for_migration to kvm_main.c
>   KVM: arm64: switch to using kvm_lock/unlock_all_vcpus
>   RISC-V: KVM: switch to kvm_lock/unlock_all_vcpus
> 
>  arch/arm64/include/asm/kvm_host.h     |  3 --
>  arch/arm64/kvm/arch_timer.c           |  4 +-
>  arch/arm64/kvm/arm.c                  | 43 ----------------
>  arch/arm64/kvm/vgic/vgic-init.c       |  4 +-
>  arch/arm64/kvm/vgic/vgic-its.c        |  8 +--
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 12 ++---
>  arch/riscv/kvm/aia_device.c           | 34 +------------
>  arch/x86/kvm/svm/sev.c                | 65 ++----------------------
>  include/linux/kvm_host.h              |  6 +++
>  include/linux/mutex.h                 |  8 +++
>  kernel/locking/mutex.c                | 14 ++++--
>  virt/kvm/kvm_main.c                   | 71 +++++++++++++++++++++++++++
>  12 files changed, 116 insertions(+), 156 deletions(-)
> 
> -- 
> 2.26.3
> 
> 

