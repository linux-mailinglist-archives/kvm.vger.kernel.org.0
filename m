Return-Path: <kvm+bounces-34196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64A1F9F899A
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 02:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF62916991C
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 01:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6853FBA5;
	Fri, 20 Dec 2024 01:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gy1sOYJ/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DAB1CD1F
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 01:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658754; cv=none; b=IVt4oUHk0EZJTx7kyWl9B0kRBKo75Q36UWdwYszkgLJ+BSmKqpA0sUkXkBmiKNH/FI93Ro+9DBVaLGIbqf54mCOnap320PFOnRp7M7ctdihXHF/x9uDTuCXVPlH8NZek40B5hS7or3sLJQCUOUgVkfytytsH4KCGl4Nt8pISIeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658754; c=relaxed/simple;
	bh=x+G/SKe65zYqmcjfUDWiwO99pE05MNdhz6X9PomzPYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jPynmLQSpecoNVLLj8MSQZWXB8OXuZrY+Lj2wJIGhm4hEMDD+SSodGa0fxph4z3vg0U0+g9+jjJdWnK68eesrVcBGwbQ+NNOcdFQ5F/g5LLsXYLHBb4ibjG4ZSNz7y4JIzAoZXPI2Bt+cv0KNIps4ds4+HqWNgrt/oGC3Hs0qJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gy1sOYJ/; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21655569152so12654775ad.2
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 17:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734658752; x=1735263552; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VJst1sRt7o765YHKTsyCLHu+qBA9pewJkWtnndgMLN0=;
        b=Gy1sOYJ/9dNZiwp6AIpFu5aEI/7NnphKHg0vq0utlmoJw0iAG+yjGkYoeZ7HfFfSAA
         ZZBox9PpDLPhsQPOBoSiD7+ujZaWvJOK4MC8E9+Re8czgvInh4QrmQW7e/034Q1MrPna
         0HSVUhFnWoWERjNYXIzAJS2Ouv0oDkpqTkZNzYJyUFpwjQWbVFSyX+lBgThwAi/zYUt9
         jCjuSyJWzyQCf49Jw7tLuy8DOvsru5t7LdI02U6mwHDaXnIV1NesprwWMXIW0ccKu6S1
         0cdOmOHqydF8XjdQJWsfxr3IgqB0BlfmFXW4JvYTdAvF5AfixJ+IVJNZWgXZMqF04KtP
         n3jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734658752; x=1735263552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VJst1sRt7o765YHKTsyCLHu+qBA9pewJkWtnndgMLN0=;
        b=xL+K+Lto0JYrQBtAjC6QuP/aCvXsbLwAOQfutvQUDoHy6fkIOV0pmrauTvoFywZpW9
         398A5T9xVRTHyFHUG8JzUIX38/qXYNy73S3vzY4W9Tna9aPg4lG0Xf+u5Km6QB66rorW
         vqwCP4mTaUS5aOGtwhBWj3FaPt3aC9HgJuzUArLkoKTycxIBD8S1l3GMl+UjMCpfK03Y
         xffWa41BKe4sTP5Q7SrDiv6/a6lhK9NT1rah98IqGW9V2wlcBaB3fc8E0opPsAxghLqz
         yxWno8k9xTBcXn9mppBz4H/ZFa8kQwUVSaWR10OZytltmAgV019lrr5Fw73FrGm4fGHD
         tLvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaL1luosVv6/THiBf/i/J38wIygrLKQi4RrRa9Qknk7auNsMkq73ZU3V/1tQYFUhQemW0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrSLGerdeRpjSjSZGvFzIdhFnF4PT8IpYWelV+TXAWI2rmxy4k
	3cQ0QIquZVezSNFt7XP/2q11o04TSifNfG+KkZID5syORybdBO5llZiARDrBBWcFsHy8Jw/uFF2
	phA==
X-Google-Smtp-Source: AGHT+IGsWQbkvzY4Nq8NW+TxgBWjNbfzrSia5xRKbrBdsJJ8VjsmNkZOW2nxKqNkxRXVufnLriMmB7/RPeQ=
X-Received: from plbkw12.prod.google.com ([2002:a17:902:f90c:b0:216:3e9d:6bc4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c406:b0:215:854c:a71a
 with SMTP id d9443c01a7336-219e6ebb68dmr11030635ad.34.1734658751894; Thu, 19
 Dec 2024 17:39:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:39:00 -0800
In-Reply-To: <20241220013906.3518334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220013906.3518334-3-seanjc@google.com>
Subject: [PATCH 2/8] KVM: selftests: Close VM's binary stats FD when releasing VM
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Close/free a VM's binary stats cache when the VM is released, not when the
VM is fully freed.  When a VM is re-created, e.g. for state save/restore
tests, the stats FD and descriptor points at the old, defunct VM.  The FD
is still valid, in that the underlying stats file won't be freed until the
FD is closed, but reading stats will always pull information from the old
VM.

Note, this is a benign bug in the current code base as none of the tests
that recreate VMs use binary stats.

Fixes: 83f6e109f562 ("KVM: selftests: Cache binary stats metadata for duration of test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 91d295ef5d02..9138801ecb60 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -709,6 +709,15 @@ void kvm_vm_release(struct kvm_vm *vmp)
 
 	ret = close(vmp->kvm_fd);
 	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
+
+	/* Free cached stats metadata and close FD */
+	if (vmp->stats_desc) {
+		free(vmp->stats_desc);
+		vmp->stats_desc = NULL;
+
+		ret = close(vmp->stats_fd);
+		TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
+	}
 }
 
 static void __vm_mem_region_delete(struct kvm_vm *vm,
@@ -748,12 +757,6 @@ void kvm_vm_free(struct kvm_vm *vmp)
 	if (vmp == NULL)
 		return;
 
-	/* Free cached stats metadata and close FD */
-	if (vmp->stats_desc) {
-		free(vmp->stats_desc);
-		close(vmp->stats_fd);
-	}
-
 	/* Free userspace_mem_regions. */
 	hash_for_each_safe(vmp->regions.slot_hash, ctr, node, region, slot_node)
 		__vm_mem_region_delete(vmp, region);
-- 
2.47.1.613.gc27f4b7a9f-goog


