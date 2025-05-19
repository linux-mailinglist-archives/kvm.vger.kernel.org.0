Return-Path: <kvm+bounces-47048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBFBDABCB7C
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:32:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 666407A1206
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 029D5225768;
	Mon, 19 May 2025 23:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zcece23w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868F62248BA
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697318; cv=none; b=l/n4i7W5Ah07c43G76RI3KNHS7D5KVxCQV9aseUbGIFVBHZwmuqG1KsNxESyEQBR1iIVhLrFnu9aAbfd8OExZnHTl8CTkinNmV+DsJ6f+vAz8q6ETa4OapCIEXYOo0lUCicuaHMq//3hx2iyKGntYxQkNJuSXaNpsead4ZlG3zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697318; c=relaxed/simple;
	bh=qQIM5Tr5nBvDkLCbk46mds4m9dIPyNzVYzD4a6yvVvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y1TVzMpNAsDWHuts79+U298agp+p/wJNMb/jYfbYD4auuadl0QDrYMgLZISGWryrB+xm+PSXqs6xVFLzIa2y3tOznohUNX+xfox/DI5Uj7UgeCvA+tqQ7DaX50v6yeTeTGXk5y9bqcWp4D1Ik19YnJECeTdfktmbwTSD5BZBof0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zcece23w; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74292762324so3692489b3a.0
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697316; x=1748302116; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jzqljEkDXtAFBsLi8kcGKkXBiNdwCtNEp6kp2mMRpEQ=;
        b=Zcece23wVKa7V75EID6upDRAziP9YbnhojNHdyIbEHBbvy4AnyVRAU1G2Y9FNSrXhX
         FjHSTK1ZDRz1yFOxNGuXDT49+q9GdVupeUbiDwes56qZ3p2rPUOhJJTtHUk9ygPqZK2C
         osgHOOMPnxvo5DWljbjXd/pRmJs4Bzgl30VLn37JNbrvjFFK5G9SE2iWcqkz7ecHXG/r
         XP5y8lhSDV623bd3HEy5m5j8Bh7aBNx8h+uHx3vkxY9z9X4W4oiEk2b41J5W7mQEBop9
         g0kMT1bysHu9a8G04eTgmS0YJyvPlAd7OLjbIRHaryK01K48igaFvnJb7kOwQm0yfJGy
         7Xwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697316; x=1748302116;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jzqljEkDXtAFBsLi8kcGKkXBiNdwCtNEp6kp2mMRpEQ=;
        b=FIpoBGYjhBNsZ7XiGAVOI+kwZy9HnfaFCEcoVmrHPxWaXp4k/1QcjiKdmKMbCfBG8a
         M80IrNmkpS8WmZ/UEhefHlp8rJXMezQ8laDC4Mdzyq+xCG/ADAqOp6zBuvdEKo/tDL3X
         5q0O0QNFF39PU1bmZqHD0sPLzpO0Jq6HCG6rtqLsBx69EV2aVDslDCRRqJGaXhX3wIkS
         +GV0eobQgJIdsdbO2aZpZfiG8qse/4apde18Ko76XFtjCAvb5LwRAcGtIA0628Pf5kEt
         Zz3SXhn1r0n0OkCqQqDYA5LGLEr7vcAJxJbXkiIBy6c9jpbQ69Er9kREUsJj/DT8Ty+1
         J06g==
X-Gm-Message-State: AOJu0YwbrNAG5WxfpqaxuafwqLAJqtVnUO9npUNSPyHcpfcy23jCSlWZ
	wg43JjwuQIcoCUVsuEqC7GCvD0rwnYEnQJhdLFvGuepWQET7MyQHeiZXKIt7ENX0L0tfnYo3p1t
	myuvERg==
X-Google-Smtp-Source: AGHT+IGYPQHinoGic07rRcLqLfD0l06dUYUgvVqfZvDuAHBo4yxWC/GP7uWYn1Sj/q1GSZLdB0srqGbjfm4=
X-Received: from pfmy21.prod.google.com ([2002:aa7:8055:0:b0:73e:665:360])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:10c6:b0:736:a540:c9ad
 with SMTP id d2e1a72fcca58-742a98b833bmr19860524b3a.20.1747697315919; Mon, 19
 May 2025 16:28:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:28:06 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-14-seanjc@google.com>
Subject: [PATCH 13/15] KVM: selftests: Fall back to split IRQ chip if full
 in-kernel chip is unsupported
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Now that KVM x86 allows compiling out support for in-kernel I/O APIC (and
PIC and PIT) emulation, i.e. allows disabling KVM_CREATE_IRQCHIP for all
intents and purposes, fall back to a split IRQ chip for x86 if creating
the full in-kernel version fails with ENOTTY.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 50edc59cc0ca..53116f4ffe97 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1713,7 +1713,18 @@ void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
 /* Create an interrupt controller chip for the specified VM. */
 void vm_create_irqchip(struct kvm_vm *vm)
 {
-	vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
+	int r;
+
+	/*
+	 * Allocate a fully in-kernel IRQ chip by default, but fall back to a
+	 * split model (x86 only) if that fails (KVM x86 allows compiling out
+	 * support for KVM_CREATE_IRQCHIP).
+	 */
+	r = __vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
+	if (r && errno == ENOTTY && kvm_has_cap(KVM_CAP_SPLIT_IRQCHIP))
+		vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
+	else
+		TEST_ASSERT_VM_VCPU_IOCTL(!r, KVM_CREATE_IRQCHIP, r, vm);
 
 	vm->has_irqchip = true;
 }
-- 
2.49.0.1101.gccaa498523-goog


