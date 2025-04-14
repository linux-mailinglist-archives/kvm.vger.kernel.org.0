Return-Path: <kvm+bounces-43286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 116ECA88E34
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 23:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E339F166497
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 21:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25DEE1F6667;
	Mon, 14 Apr 2025 21:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I+n8qRFr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60151F4CB8
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 21:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744667325; cv=none; b=d1zTDJxIJo7/smqi7LcZvDRJYpX1GeY8eSlsgwZa4AvzU2PmmLVSESSEIfYgTQCLOTGCPHj3VgEVQw0n7iq65cjSHV2DuMjgA51vWOgJZ0ulXHEMiXZ4tFOjbZuQsSJD/gXMFbhSxX6Zhd0cBaxwj3ArAWxmBoNif2kcs6h0Jrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744667325; c=relaxed/simple;
	bh=v1vU9w9fOgcK6mGNYSWomneT3Jf2m20NWhjo4CsN6RM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S/VgV7rOkGJd7p/tJM9OpRX4sfUj70CKycHNSaZleuhOTXb2cFmlnDNQF3k/rq5jDno3tl8ZNqHFS8P/Gd6hjFqxBpkpYDYUjJsPZ/adPPox3uHVIe0vuOkdZBoOwGcLMz2PovvhHma3tRFx8SMD+BFzFvNXpXnr+OKBmbMIJVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I+n8qRFr; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736abba8c5cso5738406b3a.2
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 14:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744667323; x=1745272123; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U+s/qVOGbhuO+H0U9xUGKtlbnlzqsD0JwzNjS6nutT0=;
        b=I+n8qRFrCHi6VakdA5yhBhJxBGNM5jktot7DwwA0uDVm8pwP+bUK6lGtrgiztITxPf
         HVy/yYbG/qdnsMc+09uJ4QyUSwBfqqBJ3eE4mPeHr+qWCDhoFSjpXM3AVKwRoI8VZ+l7
         fYuDLG5X3ys5uZYzd6WVVutuDRDP05Ra1pvUgM6GoTmRKq8iK0D74xDtojkAObnt8fto
         4zxVaBr2uJaOTgxCCN/2qiboS62DfduDtdrWMc6fuYzcOb9x/wcQKub737pNluu7o8tP
         uKg/v5kaNdeGwvbk9SdkKhYkK6uztq7mAkE9EdhKPboM5E16TO66nIfA7zw90tQnCD6J
         KZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744667323; x=1745272123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U+s/qVOGbhuO+H0U9xUGKtlbnlzqsD0JwzNjS6nutT0=;
        b=gQFDnTOCrLIsQthHPvAF86FYiijdWcTcfwY0gD3VlkL8c3Nf8/wraBu3twiRf8/r0v
         sPjquhsZcwl79kB1RM9R4EOrltTxYGKYB1OirKlBb9MGHqweVMw/YuwYCYLxH5F14Jm8
         4/P4zEpD41X21JXXNtS3GvahhBsvdigttHyV/iTJWcmhFXGuabL43W1SDiF4RB/4c/pi
         WR8jqaeqkqzUxIILjXALqG7iIalYpsnCjV7VQTYx8H8G3GQQFkfYaHDqxZjfUMfoOktz
         5WjX9k4xzh889rn4YgPzM0Xm7iVgHneBGg6puFLgGAVcX1YReVicORVCXyu44szdiDOu
         Ollw==
X-Forwarded-Encrypted: i=1; AJvYcCW7R9oDuEq2l3N7N14TM4FVJ+oUECOTsVMMGsARtjDXD8nrgXfsCYxrjsDICkEwtqs6AmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuQtueTugjASBGJIoMud7KaI7fXzJSwp7u8rdby6D2Dqx3Af/B
	G/4hK00liBXSLv0Tm8Yh6HEonT49YhxSNSGAtP4F7xTVPrhTp07bktkCPkjovrdecXWbIK90yg=
	=
X-Google-Smtp-Source: AGHT+IFXjDd5QaCkjEQM0TvRDAQzKGrw46opDPglY5+CRyoXMxnqy73jYYR6rm5eLj+towNyrRWPQ/Gjxg==
X-Received: from pfbgh6.prod.google.com ([2002:a05:6a00:6386:b0:730:76c4:7144])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:80b:b0:736:326a:bb3e
 with SMTP id d2e1a72fcca58-73bd12b37afmr15068525b3a.15.1744667322971; Mon, 14
 Apr 2025 14:48:42 -0700 (PDT)
Date: Mon, 14 Apr 2025 14:47:32 -0700
In-Reply-To: <20250414214801.2693294-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414214801.2693294-1-sagis@google.com>
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250414214801.2693294-4-sagis@google.com>
Subject: [PATCH v6 03/30] KVM: selftests: Store initial stack address in
 struct kvm_vcpu
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

TDX guests' registers cannot be initialized directly using
vcpu_regs_set(), hence the stack pointer needs to be initialized by
the guest itself, running boot code beginning at the reset vector.

Store the stack address as part of struct kvm_vcpu so that it can
be accessible later to be passed to the boot code for rsp
initialization.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h  | 1 +
 tools/testing/selftests/kvm/lib/x86/processor.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 1bc0b44e78de..74ecfd8d7ae0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -58,6 +58,7 @@ struct kvm_vcpu {
 	int fd;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
+	vm_vaddr_t initial_stack_addr;
 #ifdef __x86_64__
 	struct kvm_cpuid2 *cpuid;
 #endif
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 1d6ae28aa398..7c0fe3b138a1 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -695,6 +695,8 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	vcpu_init_sregs(vm, vcpu);
 	vcpu_init_xcrs(vm, vcpu);
 
+	vcpu->initial_stack_addr = stack_vaddr;
+
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vcpu, &regs);
 	regs.rflags = regs.rflags | 0x2;
-- 
2.49.0.504.g3bcea36a83-goog


