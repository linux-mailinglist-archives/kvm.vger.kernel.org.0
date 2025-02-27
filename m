Return-Path: <kvm+bounces-39479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE9E3A471AE
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:52:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA18E1646A6
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B26013BAE3;
	Thu, 27 Feb 2025 01:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="psR4IJOi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8103171A7
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740620946; cv=none; b=BJTC5tF0sQG0lX7Mm46uL0Ts2jZd2D5jyDOOLCnRAETJeKKZ0OowDNXyN4ophu3Xpqqx3JSkpU2beede2wMP625vaup9vQNyxJTALfeTpMhtsgMcdVx6newAj94kY/q6VL8rMhj9vg05nViAHL1vcj1irAeTed9xgcK2+pNS4n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740620946; c=relaxed/simple;
	bh=GR+iOS9PHyJX5l5gOqI4IGyQHkTVdNkvstXFCHs+wAc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=usPqZt5RAkLeOuAbKo9ZiO9YjaY1857GLW1DWFslLkLagMVhnd6Bm7zvT4jQ5f8HrbTJCIdWx45W4rzy+OcjCACap+OGrWW29H0uaodyumiNGfooFOPUq+fDIqzx48pFrV3BkQt2ihtAcQlmK92pNIsX4pTeK0ZZRxZ/J9/2LVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=psR4IJOi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe86c01f5cso984586a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740620944; x=1741225744; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+EJ2Fw9Yw3pGtCS/WzQ4cMRKwHHs6j+YstrAgEehLYQ=;
        b=psR4IJOiLoAkK++WDqIrepgIYX7r63q5vVs7a14jO9TQpVCbmDpMfZwpXLB2O3dtNA
         ol5f5g02kqUntpg21/Ksf4uzkHT8aVKxDJOeu57PhWz5gNN6D+ooQ7lDtB4RGi8Jg8Zc
         QJsX93BxqeJqOZ4n7sz8TinQPoQ7IK97U8I4loY9S+19IfukK4laiag6T+7KBAhqhVYo
         C63vMKqxd6RgjVkv6akfZMfcqhf8ICIeLoA+eTZNYPnu+ktguTFAKsY2/7ZmlTPPOh+g
         BfQXXBpbusJcOoV3bIGIN2g6QKp5meQgkdp9F9I2oWWsweBFQGL+8H2CnwFwmUlZUhtf
         3Ewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740620944; x=1741225744;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+EJ2Fw9Yw3pGtCS/WzQ4cMRKwHHs6j+YstrAgEehLYQ=;
        b=ecY7x7LnyHx/7G90l3/abwy/9NVRJ1fqKoNhgUX0vz/Zz0m3GHBGmnvlQdl3wpeKc4
         wjarba/g2u3c+XF/6yGazYaWJ5FMbaZP1z18z3prXCj8t1eol1ZlRgbCpgI3yzkAg2d7
         JH+fRy4Zc3Eo0AcdqHqTnzSlBzABo1ieOyhViqBwpMU0a6Ov9ymND3qoYavrf/BLl/ja
         b3GQ+Jh5fxlQ4QirleRDpu18WJCNrDrwX5s7rVrHSSLTRKLdSehCsvxPo/tF3uplEFvp
         rjLVcpz/HScpC7z6+damIV9/cxrJgOYGvtD8Wqb4ek9NgM2GfLler5hsQmyYqk4i4xZG
         PvDw==
X-Forwarded-Encrypted: i=1; AJvYcCWlU+UlfxMQrtq2qd+upejpWZMhK2US18rkyigPEcIZ4+DvDgk37p17MMCu7aqJ3wkZIJE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz74g8aQffzOG7n21ERGsBgIL+ajoQRJZfsulTu2lsTFIE3ArQY
	sKS6Dx6zJ1B/dNA0MgOJbK+d5fpPQBA1Wu0YsfKqzOl8hATJHWcIj5Zfv2Y51chDMBVyKwjMXO0
	fHw==
X-Google-Smtp-Source: AGHT+IFMmd4sNvx0a1bKJ7axvPbAmID7ou+EpSP8fN8+WAF+gm479X2t9xItUh/oedkcJnsMd+O/z1oMVHM=
X-Received: from pjbst5.prod.google.com ([2002:a17:90b:1fc5:b0:2fb:fa85:1678])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d64c:b0:2fe:a336:fe63
 with SMTP id 98e67ed59e1d1-2fea3370023mr1821866a91.24.1740620944197; Wed, 26
 Feb 2025 17:49:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:48:51 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227014858.3244505-1-seanjc@google.com>
Subject: [PATCH 0/7] x86, KVM: Optimize SEV cache flushing
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zheyun Shen <szy0127@sjtu.edu.cn>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Kevin Loughlin <kevinloughlin@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

This is the combination of Kevin's WBNOINVD series[1] with Zheyun's targeted
flushing series[2].  This is very, very lightly tested (emphasis on "very").

Note, I dropped Reviewed-by tags for patches to which I made non-trivial
modifications.

[1] https://lore.kernel.org/all/20250201000259.3289143-1-kevinloughlin@google.com
[2] https://lore.kernel.org/all/20250128015345.7929-1-szy0127@sjtu.edu.cn

Relative to those series:

 - Name the WBNOINVD opcode macro ASM_WBNOINVD to avoid a conflict with
   KVM's CPUID stuff.
 - Fix issues with SMP=n.
 - Define all helpers in x86/lib.
 - Don't return 0 from the helpers.
 - Rename the CPU bitmap to avoid a naming collisions with KVM's existing
   pCPU bitmap for WBINVD, and to not have WBINVD (versus WBNOINVD) in the
   name.
 - Fix builds where CPU bitmaps are off-stack.
 - Massage comments.
 - Mark a CPU as having done VMRUN in pre_sev_run(), but test to see if
   the CPU already ran to avoid the locked RMW, i.e. to (hopefully) avoid
   bouncing the cache line.

Kevin Loughlin (2):
  x86, lib: Add WBNOINVD helper functions
  KVM: SEV: Prefer WBNOINVD over WBINVD for cache maintenance efficiency

Sean Christopherson (2):
  x86, lib: Drop the unused return value from wbinvd_on_all_cpus()
  KVM: x86: Use wbinvd_on_cpu() instead of an open-coded equivalent

Zheyun Shen (3):
  KVM: SVM: Remove wbinvd in sev_vm_destroy()
  x86, lib: Add wbinvd and wbnoinvd helpers to target multiple CPUs
  KVM: SVM: Flush cache only on CPUs running SEV guest

 arch/x86/include/asm/smp.h           | 23 ++++++--
 arch/x86/include/asm/special_insns.h | 19 ++++++-
 arch/x86/kvm/svm/sev.c               | 79 +++++++++++++++++++---------
 arch/x86/kvm/svm/svm.h               |  1 +
 arch/x86/kvm/x86.c                   | 11 +---
 arch/x86/lib/cache-smp.c             | 26 ++++++++-
 6 files changed, 119 insertions(+), 40 deletions(-)


base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.711.g2feabab25a-goog


