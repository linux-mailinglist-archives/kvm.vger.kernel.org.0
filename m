Return-Path: <kvm+bounces-23803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EC1494D840
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 22:52:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6CEF28664C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 20:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5E016A935;
	Fri,  9 Aug 2024 20:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fNsD4QNE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A6416A923
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 20:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723236729; cv=none; b=YJ6s3VFawZ42ofYpe0L2u33egP5X+hPNvSywD+lynyEiUxpmjs5B+WF8vIwkHjECg7Nr7JRD7GFx3Cmf209F0lDfy8+gTj4IgjMq+zYOwUlZipZxRn04Qjs9K+bFZc4T3hYL/j/TzJKfdxx/q8Qf+SCKeOQu6opZ3EXfNC78pNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723236729; c=relaxed/simple;
	bh=aRlZUJEaiHRJGRJLYanOLgphxj1dBoKyLzhPuRD+1jE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NumJ9WGLU/FsonyUqjy2/i/NQ3yfBxMRRohkPByDxms2GQ0u8iy19Z8aMw13jm6Oa1P8XM6/nImHUNvR3KBkmRogfcTpB3e2tXY9pUTRCTgydN0BvITOc38uFbfrMhSA0I7nGKlmTzAoAHGznFu8W4FiUX9FEbXwgQ0N24S8rNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fNsD4QNE; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-665a6dd38c8so57710297b3.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 13:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723236727; x=1723841527; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dIbtHxMOA9YLjvqp+dS6Qdcb7Qd+13Wo6Sg7tuMzI5Y=;
        b=fNsD4QNE31StJ1qFHKH8vfbE9M+OprI5rN4w/IcQvUHTZtpu/n3O8JFOcDxHmkTmHM
         nCEavGEOsyXRuYkaEixAv6AdSU1f8zCZMgoBxBtN+Ls/AgN8gbArbRqR5/k3hMVFNRCY
         4Cp4JWhPCpQfhxMQ0oFGox86kscOEJUdPVFNmOt0u0PJwch9+CuLH4qUrHcfWaGbCI/d
         GG42RuFdkzuad7ThfRSL2roOrucg2gowTw0xUOe0jjPQn72ZP4OOpisWZT20rt4LSI4m
         m+nWuzFWED0ElEg4cAI/PbxN9WxK8+NLPw4+qOwJeE3c1/6k4HLYHEOwuL9Fih2uNs/n
         KMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723236727; x=1723841527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dIbtHxMOA9YLjvqp+dS6Qdcb7Qd+13Wo6Sg7tuMzI5Y=;
        b=U8RvjYKj/z3Hb4wQ4kSWmgFGrvNaCmONrH+/OHs7gaKc4MyTyvDWoetBryRiJpLb0L
         K3+Rmun3m150TzDbyF4tsc9GwXNzqjg6FbrB4+0QQ3VyJQKIhmpAJm5PEhpxVY+84HUt
         +BRdMAii1UoxP6frfEXewt3A7ThvSk2vDuEwRRThvSQFkXDaWAG3yiF5ILsC6zW7SPxx
         B0b+iEzabPTfV5qsfg8BJhSFbRggVWhm53TV2heKKIcnN2Ni+d9JJ/TBGD5CN59U+hU5
         ldOAolwxqU9e5UKMn/YylUAucFhwfxGbkqX5VCmxwwbeCn3GoAQUC3sYYmOiA8T7M7Tf
         DA6A==
X-Forwarded-Encrypted: i=1; AJvYcCUaCj38barWn7YTBkAYYmOhlGbd1lv+A8NalykMqpOtZs9hEmZqjtLB/6QSkJRsCP3JD3quC6eEzEU1xzyu9vbPnYjD
X-Gm-Message-State: AOJu0YzjuK8wJirSOTe4F1rqFY2x973XyDEKrPo0ZM3pIbcFCYrKzBXh
	U1I8SiiGHAo9Ov10dZH62Wcq2I0yM8pKbLJ86PLO1AolcyGiQ6fei5a0zYnFHiTl9IsE3vKTJUY
	umh41gcQOlg==
X-Google-Smtp-Source: AGHT+IFEaybp/gQAI2dPTCR/v0E5CX7dxbSJimk27amgMiDWfuzdCjImbiciR7wYsAeR11wIqKwlf/27qs26HA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:8786:0:b0:68d:14aa:894a with SMTP id
 00721157ae682-69ec4a193b8mr1144237b3.2.1723236727230; Fri, 09 Aug 2024
 13:52:07 -0700 (PDT)
Date: Fri,  9 Aug 2024 20:51:58 +0000
In-Reply-To: <20240809205158.1340255-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809205158.1340255-4-amoorthy@google.com>
Subject: [PATCH v2 3/3] KVM: arm64: Perform memory fault exits when stage-2
 handler EFAULTs
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: jthoughton@google.com, amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Right now userspace just gets a bare EFAULT when the stage-2 fault
handler fails to fault in the relevant page. Set up a
KVM_EXIT_MEMORY_FAULT whenever this happens, which at the very least
eases debugging and might also let userspace decide on/take some
specific action other than crashing the VM.

In some cases, user_mem_abort() EFAULTs before the size of the fault is
calculated: return 0 in these cases to indicate that the fault is of
unknown size.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst |  2 +-
 arch/arm64/kvm/arm.c           |  1 +
 arch/arm64/kvm/mmu.c           | 11 ++++++++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c5ce7944005c..7b321fefcb3e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8129,7 +8129,7 @@ unavailable to host or other VMs.
 7.34 KVM_CAP_MEMORY_FAULT_INFO
 ------------------------------
 
-:Architectures: x86
+:Architectures: arm64, x86
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that KVM_RUN *may* fill
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a7ca776b51ec..4121b5a43b9c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -335,6 +335,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6981b1bc0946..c97199d1feac 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1448,6 +1448,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (fault_is_perm && !write_fault && !exec_fault) {
 		kvm_err("Unexpected L2 read permission error\n");
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, 0,
+					      write_fault, exec_fault, false);
 		return -EFAULT;
 	}
 
@@ -1473,6 +1475,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (unlikely(!vma)) {
 		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
 		mmap_read_unlock(current->mm);
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, 0,
+					      write_fault, exec_fault, false);
 		return -EFAULT;
 	}
 
@@ -1568,8 +1572,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(pfn)) {
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, vma_pagesize,
+					      write_fault, exec_fault, false);
 		return -EFAULT;
+	}
 
 	if (kvm_is_device_pfn(pfn)) {
 		/*
@@ -1643,6 +1650,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (mte_allowed) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
 		} else {
+			kvm_prepare_memory_fault_exit(vcpu, fault_ipa, vma_pagesize,
+						      write_fault, exec_fault, false);
 			ret = -EFAULT;
 			goto out_unlock;
 		}
-- 
2.46.0.76.ge559c4bf1a-goog


