Return-Path: <kvm+bounces-22407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47F0493DBDA
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:08:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78E4D1C20BAF
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED0DD183080;
	Fri, 26 Jul 2024 23:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nE3pa4YJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04061822FB
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038052; cv=none; b=IqOGMqxliLV5fYvUhR3IEV/2U1uC7eZ/pBiF4WC4ptaCsi9Mr3uN4TmE/tOIKr2qHxH0eD9ATNBVyxUo5t0TWhO8xBDHOhr9SUocMHjfGm4av4vVb3VVfaLDgJC0vB0xlc+2KyVG74Ef2a/Jxu1QD1OUbuC2NBQoazApLhKq9P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038052; c=relaxed/simple;
	bh=V+LqqqAUYhUM/5n5EbZbHeZYUdQNA5yUVRCdR+GfGK4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V6qo+kCbOUQXTMQjfKxO2niITxmObLw6O5zzr6XEcZiiUhznj3Xdz95NLsstdaJEu4wyIOP9V3zTjsGUJhCghNeQPseu7YrjpS/Kt5JPPEKBHKn6LxvWrHt5wblf/v9SLMNV5MIxxfUnwWdHEUHhki+qcY+LI+ReQQVNfE8CpjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nE3pa4YJ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a134fd9261so1530997a12.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038049; x=1722642849; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kZSI1KNdqk//fOFhZYsFCszCldNWPUNapLOmZmlQ+ic=;
        b=nE3pa4YJfXtt227FHvwjhWHwzBZF2cjYR6sav8EMzbU5TswZVIHwB1W5nij6YbAAHr
         bYzgaDXjnIT7TBj5XMQiJoiRTlGOFuXn38jRBs6+7wXGQIrMSlIwzrUks/3ROPl5aLFk
         JPBe81hPcy81kvN7kJA5YeT2shitB0FbgradU4O2lQyV4ksyQt2+KZiCbdPiqRQJsrmE
         6/58JNfGUQDZ149S86zQXqNnNPPeD9IcEIQXPgfEh55JYghY12MTGgGCbd34dO3dM6R/
         PbkHhwEW6GMI33KSKDaqSkO7MvMilYpdmiJfwlhSahl3aKAbd2AECUIZXBWP60uALBhl
         WZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038049; x=1722642849;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kZSI1KNdqk//fOFhZYsFCszCldNWPUNapLOmZmlQ+ic=;
        b=UyCWmpHpczPYxU6ilcCIY9/y8pDr3s4n2GJRSXgwBKOHP1Vjnj/GmO1ddIlbvn8/js
         BA+VTUVsRUBU4ACFNfWIbIy4iEPhHvWmfwodo05vkE6/ZToGIY4izeaTiGnZcr1N0xAw
         yRsIYsM00IgDw0fsGzZtfPB5m1pggA8wwRpnTnuKQXvpcdqghqUSYhrA16TucyK9+GaJ
         ykgOytG3FC+l2sErBfKS+G2weYilE3qD8L1DizeYcB3TlDaRfsGDtPhMs9FNRljkGnhK
         lJbBR+iHE8HiWTUeoUzvAopw8hWvlZyYezDOKYlL6pPvZlYdfe6Pv0RleX3hpKHZXR2f
         nBSw==
X-Gm-Message-State: AOJu0Ywy+s40+74Ar1h519mBDo5CfLUQsRYpce4+XIRz1UPif4Bzk7Qx
	FfYCtyBafwTj4inJrX+Cww7xa3LPW7qyb8pIbsOMNMCLztu2j8xVb5actzJwajGSuYKyuPYUdLF
	H3A==
X-Google-Smtp-Source: AGHT+IHwPJ/UM6h8kXfIVs09j5bz4zlDvOcU2rq/epWSbhMGMPOGMhlwxlAMNu8ktgd9HGr+mJ5fl7Shz2c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:360a:0:b0:7a1:4462:412e with SMTP id
 41be03b00d2f7-7ac8fd30864mr2218a12.9.1722038048851; Fri, 26 Jul 2024 16:54:08
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:53 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-45-seanjc@google.com>
Subject: [PATCH v12 44/84] KVM: x86/mmu: Convert page fault paths to kvm_faultin_pfn()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Convert KVM x86 to use the recently introduced __kvm_faultin_pfn().
Opportunstically capture the refcounted_page grabbed by KVM for use in
future changes.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 14 ++++++++++----
 arch/x86/kvm/mmu/mmu_internal.h |  1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7e7b855ce1e1..53555ea5e5bb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4369,11 +4369,14 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 				 struct kvm_page_fault *fault)
 {
+	unsigned int foll = fault->write ? FOLL_WRITE : 0;
+
 	if (fault->is_private)
 		return kvm_mmu_faultin_pfn_private(vcpu, fault);
 
-	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, true,
-					  fault->write, &fault->map_writable);
+	foll |= FOLL_NOWAIT;
+	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
+				       &fault->map_writable, &fault->refcounted_page);
 
 	/*
 	 * If resolving the page failed because I/O is needed to fault-in the
@@ -4400,8 +4403,11 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 	 * to wait for IO.  Note, gup always bails if it is unable to quickly
 	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
 	 */
-	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, true, true,
-					  fault->write, &fault->map_writable);
+	foll |= FOLL_INTERRUPTIBLE;
+	foll &= ~FOLL_NOWAIT;
+	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
+				       &fault->map_writable, &fault->refcounted_page);
+
 	return RET_PF_CONTINUE;
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index a5113347bb12..e1f8385105a5 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -238,6 +238,7 @@ struct kvm_page_fault {
 	/* Outputs of kvm_mmu_faultin_pfn().  */
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
+	struct page *refcounted_page;
 	bool map_writable;
 
 	/*
-- 
2.46.0.rc1.232.g9752f9e123-goog


