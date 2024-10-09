Return-Path: <kvm+bounces-28266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3906C9970C2
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:12:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B1F61C22529
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F048C204080;
	Wed,  9 Oct 2024 15:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fnSDfYS5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C39B202F8D
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489013; cv=none; b=rOvQSDnwTD3UflwDXQ60vmein7UrZC3x2vEBVZql1SebdXXRvNJot36jsikVXIvHC07mk1qMwedzqV3yBMd1WQrBT8JiHsBjfansZoV2Qhxal0eRb4t2xJB7kfOndsCh8UiMsifmbIudQPbrFtRp1O1FNJGKkT7ssTdJdNDQ8+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489013; c=relaxed/simple;
	bh=iJgiAVVkswthc5+5Sg734uhrpe9cCqrlEjv/8yEej0c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sFGpg5PLETlKn0coADy8mg+5Gq0v7sViu2XDO8qHpgwhZjXMj/+DRMP/qmkB6J0CHfwxotaah4yzIXxV5PHIOeNrqBBfdmfBtrIK3fnfF7EEDwucgCSBqxg9enqFN3c4S03hwtxDxnOFAoduQy7bx/X5iYBd/nb85Y+8FuZO930=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fnSDfYS5; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e000d68bb1so13383397b3.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489009; x=1729093809; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mkSNDDdTvmOytZei+cHiV7cpe/wxQK6hsvQ24y9wIjk=;
        b=fnSDfYS5iKalBfRgLhSpGhQWtvNUH11/UhY8QMNsbYym7XT99Yrnn9mrQX3riHWc/P
         UI3GJRwt3uEJgL+A3DpzeAKkyPosHfBmmyhE/7fpu0GzgV/oTBwXSFkdgbOOiA3ab+3B
         uC0+3LGzDIwwU7aWDf0ibuuOXNv++AVSH4EK72+ql0rzDe5D5Tc89nxcJbOExXHLES12
         yXrCloidBZprENpMLCEZW6yAL/lWLpL1OFmck//KPytksB0QHzpBFLXBXxeB0EdMntU9
         9lTjVam33Az+4d6I6KBEKvZprvVQZeMiA8q4kb5Ze3EWNuk//mF0gzKSMyhUbsmzSXGd
         kcbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489009; x=1729093809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mkSNDDdTvmOytZei+cHiV7cpe/wxQK6hsvQ24y9wIjk=;
        b=Bl8hIJsCgJvhqzvd9S59ReuSbshYmNYzzLlQZKVXdDcZUKvATgQOBWEVZvtDdZD+Qh
         CMHS409SJ0MfaSkfyzl8M1UcGn+mJWosIB34IRY6g7r81duD7qx1wMXhsyMuOAT5i/RR
         lUzBDRF6VgLEXqYAck12U+rilhrkEopBc3SANE08XbXfzYWD/OkgUNJqLva/tTozWkCc
         wQ6kEty+sf+VxM5Jc1CJex/mKTFKNIOUeFryZX79J90Vw0DrgRjFU5PZ55XAyBphXotn
         83LKzoH+LMaIvvGvXGmWUt83uiCpeJxzt456BYFa8gcBBT+QU3GuDvt0JA+xFc8kDR/o
         +PTg==
X-Forwarded-Encrypted: i=1; AJvYcCUHbDn8jEC69RjF5/ybTYZHuxPODjC2Sc8euC1ZRs7Msmi1z6vhoTDRE5YE5gZ4jN2s6Ls=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+dPbklLdB9GKb3ebuNUFf2P9Ti3RloABEAB+hdFW6vblE1wuw
	cd/KmQNo7n/eSV0QlXbVQutDBxn7qniGm7PnRjoc0OSavDAao8wcA2IDjVZ9HXSYCVldypDuWkL
	kkg==
X-Google-Smtp-Source: AGHT+IE+D7P5FL0ahoVlcq9P7kEER6bVqpKARxPS0zk7xyFxuVv8bFBUXfQ/Ook8UnSyIIw/scGTO80UaRk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4706:b0:6e2:a355:7b5c with SMTP id
 00721157ae682-6e32f33bf7emr177b3.5.1728489009508; Wed, 09 Oct 2024 08:50:09
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:46 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-8-seanjc@google.com>
Subject: [PATCH v3 07/14] KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Try to get/set SREGS in mmu_stress_test only when running on x86, as the
ioctls are supported only by x86 and PPC, and the latter doesn't yet
support KVM selftests.

Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 0b9678858b6d..847da23ec1b1 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -59,10 +59,10 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 
 static void *vcpu_worker(void *data)
 {
+	struct kvm_sregs __maybe_unused sregs;
 	struct vcpu_info *info = data;
 	struct kvm_vcpu *vcpu = info->vcpu;
 	struct kvm_vm *vm = vcpu->vm;
-	struct kvm_sregs sregs;
 
 	vcpu_args_set(vcpu, 3, info->start_gpa, info->end_gpa, vm->page_size);
 
@@ -70,12 +70,12 @@ static void *vcpu_worker(void *data)
 
 	run_vcpu(vcpu);
 	rendezvous_with_boss();
+#ifdef __x86_64__
 	vcpu_sregs_get(vcpu, &sregs);
-#ifdef __x86_64__
 	/* Toggle CR0.WP to trigger a MMU context reset. */
 	sregs.cr0 ^= X86_CR0_WP;
-#endif
 	vcpu_sregs_set(vcpu, &sregs);
+#endif
 	rendezvous_with_boss();
 
 	run_vcpu(vcpu);
-- 
2.47.0.rc0.187.ge670bccf7e-goog


