Return-Path: <kvm+bounces-39067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCE97A4316D
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 00:57:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC5B5172FDE
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 23:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22C58211A36;
	Mon, 24 Feb 2025 23:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BZ27Tmm+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB0A211476
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 23:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441358; cv=none; b=EhHqidshJrv4B2gZafOS4TD+hDtVEv8bArHwUp+WtlunD2XVaNthhlsDE8MOJd4fwXUsY/LuYB2mDMprSeVquiBqEBym9M2CvW0SDOsev04uHtxBVh7YFd4MM6k70oRkKI7rqK3It/t0UfKwOlZEhggofqcEh7Sopb4V6dvhbFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441358; c=relaxed/simple;
	bh=RyQAx7Z5zYd41S/+BHB5zwIwQj3p0JUw5qeOKaGY3V4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WVMuAnmygArUgwNFlMrpF3iFPc4qa6bQsqLECMLsbi4X4S/+03Wb0VjzqPRLTeDwUfCu1YWvVwmw3eTOe/wrodc7sJWWD2+OHcM3tAsw3Wcs+0XYIr3V81qpF5pGzw1U50xQTStHxwZeNWvx2vCC+d/KBssGjddhsC2GIDJEKL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BZ27Tmm+; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2210121ac27so104241085ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 15:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740441356; x=1741046156; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TJTgZNhYY30nXxMYJRDXX1rx/rqsWdUW6nwlsEZr+Zo=;
        b=BZ27Tmm+0QH19zZj62ZGEh+dxD7t/20Btf+JCNALcqii6YqEJSTX0ElCdk9HTL/pHI
         Qme7R9yhgjGvb5Dkb+t0yEOMAXYbwC41zTcaKD+OBdts8dhV2/Gt0pCkD6/6Ye50cAmZ
         +ZoRLnoV0vDSYZe2xiWYCtX7ff8RrANGFRoWP/4CwFqZZjqgeg0tYKDaazJPH/J5NcKL
         VHPXZ/F1o+HyFqX2fzI2bhmhwlPVW18ya00Pv4pg2DXGL9t0CatOeP0u5Igc1bk4U1VB
         hjL40TUmBPsRlmjqymJP21V/lh9UJ3q5QOn43Jm8UJhiAdzS65GXPW12SrEqP00WyjlT
         lY3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740441356; x=1741046156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TJTgZNhYY30nXxMYJRDXX1rx/rqsWdUW6nwlsEZr+Zo=;
        b=M8qYyDwBMRr3zFg6V8JYHY4dLarTjRT+q4/BHV4B9cXshfYdmttNzp2vaswiOX4G4C
         patR2yKTgE+rBRYpo3ePUbdUsuMPv13luZOTV5wd7bsgoMdcXCu5vKJ3wQ16mVDlz/Sf
         Rj5giyH7T/BGNb5OOHqoaO5EYFwC/8Dpx7mlpNgXxN8e9ez27cDf/RPbm9n+vVAa6u2m
         pqixCk/n5mcp4OShNAtv6Obe4dt3XS6GJZNAp3Q6cpljmERuWqyoDtTmL4VWlk3F1k4Z
         mKr4K8KrZqV2kcmghInUPLEW2isZ6QZKSskvWAImC5GrxvP2Hw65uhuOZx9gEnQQkuqQ
         EOyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXP3EPtJgCP3oq1MNt1R2kCjFS6tDNbcP3uvd0kSNCS+f02wIEp2T99bBQuPDlr1eTAPAo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzA5N+MwM1TRKz/EFyRBgtTxDQs6G2stXmckuWAIOufGfUcW46m
	DW6BIrq6kN+Yf5RALe52+vR8n9lXeMjq61fu2vdSg2kyaRI2fLED8q04nV3lVF2ILXYmGupaZLa
	lPA==
X-Google-Smtp-Source: AGHT+IHgthprmvsK7rAfh+PsqOM1pat7xQuGm72FmKpfdI+qTOt1cCxKN5aFSZszJT1EFJi9jy4pNoVXfJY=
X-Received: from pfbig2.prod.google.com ([2002:a05:6a00:8b82:b0:730:7c03:35e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1947:b0:732:623e:2bdc
 with SMTP id d2e1a72fcca58-73426c84885mr24369761b3a.2.1740441355733; Mon, 24
 Feb 2025 15:55:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 15:55:41 -0800
In-Reply-To: <20250224235542.2562848-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224235542.2562848-7-seanjc@google.com>
Subject: [PATCH 6/7] KVM: x86: Fold guts of kvm_arch_sync_events() into kvm_arch_pre_destroy_vm()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>, Jim Mattson <jmattson@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"

Fold the guts of kvm_arch_sync_events() into kvm_arch_pre_destroy_vm(), as
the kvmclock and PIT background workers only need to be stopped before
destroying vCPUs (to avoid accessing vCPUs as they are being freed); it's
a-ok for them to be running while the VM is visible on the global vm_list.

Note, the PIT also needs to be stopped before IRQ routing is freed
(because KVM's IRQ routing is garbage and assumes there is always non-NULL
routing).

Opportunistically add comments to explain why KVM stops/frees certain
assets early.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a61dbd1f0d01..ea445e6579f1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12772,9 +12772,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 void kvm_arch_sync_events(struct kvm *kvm)
 {
-	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
-	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
-	kvm_free_pit(kvm);
+
 }
 
 /**
@@ -12855,6 +12853,17 @@ EXPORT_SYMBOL_GPL(__x86_set_memory_region);
 
 void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 {
+	/*
+	 * Stop all background workers and kthreads before destroying vCPUs, as
+	 * iterating over vCPUs in a different task while vCPUs are being freed
+	 * is unsafe, i.e. will lead to use-after-free.  The PIT also needs to
+	 * be stopped before IRQ routing is freed.
+	 */
+	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
+	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
+
+	kvm_free_pit(kvm);
+
 	kvm_mmu_pre_destroy_vm(kvm);
 }
 
-- 
2.48.1.658.g4767266eb4-goog


