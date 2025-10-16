Return-Path: <kvm+bounces-60220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB44BE54F1
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 22:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EE72581C89
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 20:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65A62DCF4B;
	Thu, 16 Oct 2025 20:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="21ERtyXs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861BC1A9F83
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 20:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760645063; cv=none; b=H0PQgdnYhxmGxHUXJarO+KbepGCqvfuC30rAZP+Vo6nxSJUvQb9T7CsTspM365D9zpHEV+PlApfovQeVXSooE+IH+P6P/Ja1HbH8wrL9eurCwsbVYKirEtU/nCi7gwR1zoxxJ1GTs8Flg8HGbVVm0tEZj7lkvFF/YeqNQnU5hMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760645063; c=relaxed/simple;
	bh=6FYjDgh42/rdDprSBTVYpSTAtjBUWQ9+cTdBrRIVV+I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lAR2GgEZdGcNv2zTOW96f9TFhhz05EqBZvRCPsfDZeBqVe28uuoxvkyz8IC+Vttr0Tn4l0VvJOpuUTrIyPkr2FDgHlJDvQSQIbtOqa4eAfMfrfr+BjTjE6sWvCE/BlM/0ZcvI8/BcStGvju8WTFLR3DOfEFtIQO5zJO2TUhf3oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=21ERtyXs; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-269880a7bd9so15202435ad.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 13:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760645061; x=1761249861; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jqb7kJ6kiZ0p+CW5ZbbOBcYhzgQT02h76oqcAal4vWw=;
        b=21ERtyXsa6GzXPuM2I8gqkED+KXnZu6/S6UXM3WrGebl/DV6y+H344/tkPJ+WGO8NL
         7pBcqRsOCvKFDzvnWjvalBaQlh0fHwTO7FTt6PE6SMW6qKGF5+SduQJtRDZm4JbHJWW6
         Fx0SAShuaexe9XJdwzOAKEPbbgmC7MW1Z4J91ksL1kRNV1uYAChJfeNXXbRiQ9S/INbS
         XNeAg8AVaaHoHQ5xIWq8MyUXhxvIx6dZB021vX7lqe2lK5ZfUEB6LcZ8C/FwBzJfB1nQ
         lx5U0BS58Z978VvdbftyjTWJH7dMOEV7jxgCdUfYjfk7kin4hHday4bolpW8v6NTKJBR
         9D5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760645061; x=1761249861;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jqb7kJ6kiZ0p+CW5ZbbOBcYhzgQT02h76oqcAal4vWw=;
        b=aRPWCOF/CmC2gnkDMur05oEjj69X6pnIS7ZxIEK488WcCzDnr5+J7WJmQMU+pAxCuG
         AO/xtCR2y/irGktgcoHj5eK+jFNbtiexKcZXmxsDP2ytt2eNeEiXrXqt98/xoQcjwCm/
         6k0oEA1KWNkBKGGS+vH6dS60YwZhG+f5EcDOqwBHEc58SsRumXEAfvTauKei6IpRlPp2
         +GgQ9Rpficbhhgo5R7LdxtYyox+ZRp/9/vux65snz2edWjZ1zQ1TyRPji7H0o3urTxZa
         QC0iFH+9FONiPYeP0NzSZuDKi9eqw1ndX3No+BEt5F55zAmHWT8tgXb7AnPia0zPwbME
         /akw==
X-Gm-Message-State: AOJu0YzWZGrcb1suq5pVifI7r1hK4uNeGFBJqOZzgB+Zw80bh8VEbddf
	T406pskOCga//diqmvFlkG138H1wEHhsH5U19a4Aoo8ogNFlojNLZPcpjErueGUGaXMr94xSMv/
	F8zLycA==
X-Google-Smtp-Source: AGHT+IEhznhfjB+gb8VYxaVF/itKOuOUs62hiSpzzD8roNvleF8B+Bh5tVSfnMSsk3bPF8Lq+0CT7lrqb9Y=
X-Received: from pjpx13.prod.google.com ([2002:a17:90a:a38d:b0:33b:51fe:1a93])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c951:b0:25c:b1d6:c41a
 with SMTP id d9443c01a7336-290c9cf3517mr13660925ad.11.1760645060865; Thu, 16
 Oct 2025 13:04:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 13:04:13 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016200417.97003-1-seanjc@google.com>
Subject: [PATCH v3 0/4] KVM: VMX: Unify L1D flush for L1TF
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

Unify the L1D cache flushing done to mitigate L1TF under the per-CPU
variable, as the per-vCPU variable has been superfluous for quite some
time.

Patch 1 fixes a bug (I think it's a bug?) I found when poking around the code.
If L1D flushes are conditional and KVM skips an L1D flush on VM-Enter, then
arguably KVM should flush CPU buffers based on other mitigations.

Patches 2-3 bury the L1TF L1D flushing under CONFIG_CPU_MITIGATIONS, partly
because it's absurd that KVM doesn't honor CONFIG_CPU_MITIGATIONS for that
case, partly because it simplifies unifying the tracking code (helps obviate
the need for a stub).

Patch 4 is Brendan's patch and the main goal of the mini-series.

v3:
 - Put the "raw" variant in KVM, dress it up with KVM's "request" terminology,
   and add a comment explaining why _KVM_ knows its usage doesn't need to
   disable virtualization.
 - Add the prep patches.

v2:
 - https://lore.kernel.org/all/20251015-b4-l1tf-percpu-v2-1-6d7a8d3d40e9@google.com
 - Moved the bit back to irq_stat
 - Fixed DEBUG_PREEMPT issues by adding a _raw variant

v1: https://lore.kernel.org/r/20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com


Brendan Jackman (1):
  KVM: x86: Unify L1TF flushing under per-CPU variable

Sean Christopherson (3):
  KVM: VMX: Flush CPU buffers as needed if L1D cache flush is skipped
  KVM: VMX: Bundle all L1 data cache flush mitigation code together
  KVM: VMX: Disable L1TF L1 data cache flush if CONFIG_CPU_MITIGATIONS=n

 arch/x86/include/asm/hardirq.h  |   4 +-
 arch/x86/include/asm/kvm_host.h |   3 -
 arch/x86/kvm/mmu/mmu.c          |   2 +-
 arch/x86/kvm/vmx/nested.c       |   2 +-
 arch/x86/kvm/vmx/vmx.c          | 222 ++++++++++++++++++--------------
 arch/x86/kvm/x86.c              |   6 +-
 arch/x86/kvm/x86.h              |  14 ++
 7 files changed, 144 insertions(+), 109 deletions(-)


base-commit: f222788458c8a7753d43befef2769cd282dc008e
-- 
2.51.0.858.gf9c4a03a3a-goog


