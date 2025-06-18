Return-Path: <kvm+bounces-49804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 330E8ADE285
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:28:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 594893AD443
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37021220687;
	Wed, 18 Jun 2025 04:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NqWonq7V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F80D21D5A2
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220689; cv=none; b=a/+PDpn+y1YIfVuzz3AFwyZ++UwR3HhfTcRFLf+pJJwELOZJ8DoV0r5aMzBAJ0sdyROajDHBGfyj1VHucNgR0Iob2ccoGGn7bcxTAsfXc0dZoO1N3UXobk5q4e+J97HS78RR6krSYZpzXz8XpzZAeAb0Cz3wL7heUKcanKQcND8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220689; c=relaxed/simple;
	bh=pBsXSmQz4NiPuEOYLkwfwEN5cJ0gqQwNFVp5scXJ8tE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QuTgMnJBQMwixbpzcOGlBg82KWhXQlDRVktHKO5WCwrMHvvAQrdViaK83Njfi3gbPihF7auZ1mW0mspYulMe1uACAEZ07OPhA18RkkkO+0UezHS8SpoX7BtkESM7CxqocVP7jFv3xHcFvAwqtO89z7SVZR99Zn+9dvc31MB8swk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NqWonq7V; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7391d68617cso348851b3a.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220687; x=1750825487; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IPfdrb3qNj0vF7Vvj49qyj4bUirkHon/mzHMR4ThfgQ=;
        b=NqWonq7VmobhJY6B8Pahfi9r8ORcLnWhWSkGVdhdHb/NzeRnhzTL9TZAj3LBIEnGDO
         PyoIU5ZLbGzQyCoOeSUJqleOL5xMKr0/iKwJzqB+3lKorvTJFk2owbIQS7nPTn2ahsuu
         EENef+MVjqufiUzhAdhebe9p2S77nVA3ghYOsuEOqdum6GAcgRj1BVEKhQi9nL1Bu7Qv
         VEyxd9L8mBfhU4CGRAQietErjL+cws3rDceIVY2a6GOZ2tL+InTKSXzw4VHVo0wRSt2L
         YJ1JDMs0Z/PS+y1hgLNOVMRvK2YLJ5qbxqdAHVNW99FoQGZDxej+h644q5c/x+qTkzon
         B5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220687; x=1750825487;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IPfdrb3qNj0vF7Vvj49qyj4bUirkHon/mzHMR4ThfgQ=;
        b=JkSnwtXzTNQ1UJsYblSE/be44d/8OlKLi2PE/lzR2/FSfDz0PYsFQjg0QFyCHr4qkV
         l0el8SQIAzMhplCXl67oQ6dWv0q3RaCufmteDJwYRRRNSU9Suiii8EXsDu3o+8LJBjmA
         OUKcxS7ZKsg36HDfnCyLtlSRez1qKK1j2MltWEd2oIRojT8I/2y/ts1Qr0hKN1+pelWA
         CV4GMV0nGxiCpfMVzmTgmUz0B4k+A3l3DcbhHelZcZAbq2cEgWB8EVvL5usWfjhGXNgP
         Vcb7+NWGr6+bQwxfexTV0LkEzIqoGhgjpD1Q32fEZgDj6v24eY5k5A7TsJJFF6+bg7Th
         7iBw==
X-Forwarded-Encrypted: i=1; AJvYcCVjdegi2Or7xkcgfKfc9tTkQ6InCiJswkt2Y048HN4HDFfofu12yWsEp+XhwBwhLJlshJs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmguiG7JlTjeiG7LE/P+2sPvGPZthLWNjP5Quo5GbBto/+05gu
	nDPzmt8AoglCUqrq/fYykRhpD1w1OOnynHUVsnWmt+J/WC8g6haDOuJNdCN0obz9FmgXNRAuoM/
	s8yy/zjglYUv1JwoyoVrGag==
X-Google-Smtp-Source: AGHT+IEwWie/mYOzWzkPEMzzYrHW7iM/BMlWT3ZNJE+z50G+eg48u4nBoLAfK8Q5b1sDwPdBgQjlTM5R7I81KayS
X-Received: from pfbgt12.prod.google.com ([2002:a05:6a00:4e0c:b0:746:2524:8aab])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7492:b0:215:d1dd:df4c with SMTP id adf61e73a8af0-22003686bacmr2081008637.6.1750220686708;
 Tue, 17 Jun 2025 21:24:46 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:22 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-14-jthoughton@google.com>
Subject: [PATCH v3 13/15] KVM: selftests: Add KVM_MEM_USERFAULT + guest_memfd
 toggle tests
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Make sure KVM_MEM_USERFAULT can be toggled on and off for
KVM_MEM_GUEST_MEMFD memslots.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index ba3fe8a53b33e..3f77abb257601 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -606,6 +606,35 @@ static void test_mmio_during_vectoring(void)
 
 	kvm_vm_free(vm);
 }
+
+static void test_private_memory_region_userfault(void)
+{
+	struct kvm_vm *vm;
+	int memfd;
+
+	pr_info("Testing toggling KVM_MEM_USERFAULT on KVM_MEM_GUEST_MEMFD memory regions\n");
+
+	vm = vm_create_barebones_type(KVM_X86_SW_PROTECTED_VM);
+
+	test_invalid_guest_memfd(vm, vm->kvm_fd, 0, "KVM fd should fail");
+	test_invalid_guest_memfd(vm, vm->fd, 0, "VM's fd should fail");
+
+	memfd = vm_create_guest_memfd(vm, MEM_REGION_SIZE, 0);
+
+	vm_set_user_memory_region2(vm, MEM_REGION_SLOT, KVM_MEM_GUEST_MEMFD,
+				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
+
+	vm_set_user_memory_region2(vm, MEM_REGION_SLOT,
+				   KVM_MEM_GUEST_MEMFD | KVM_MEM_USERFAULT,
+				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
+
+	vm_set_user_memory_region2(vm, MEM_REGION_SLOT, KVM_MEM_GUEST_MEMFD,
+				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
+
+	close(memfd);
+
+	kvm_vm_free(vm);
+}
 #endif
 
 int main(int argc, char *argv[])
@@ -633,6 +662,7 @@ int main(int argc, char *argv[])
 	    (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))) {
 		test_add_private_memory_region();
 		test_add_overlapping_private_memory_regions();
+		test_private_memory_region_userfault();
 	} else {
 		pr_info("Skipping tests for KVM_MEM_GUEST_MEMFD memory regions\n");
 	}
-- 
2.50.0.rc2.692.g299adb8693-goog


