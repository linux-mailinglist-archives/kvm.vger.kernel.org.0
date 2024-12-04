Return-Path: <kvm+bounces-33078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C11059E4468
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 20:17:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 794FE28954C
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F06720B218;
	Wed,  4 Dec 2024 19:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2dTWpJhX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f201.google.com (mail-vk1-f201.google.com [209.85.221.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292EC207643
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 19:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339670; cv=none; b=qquqgTY6RWHhOmLkOaJ9bSccIpQL7pMKKIJ/VSDN/Zbd+IYkxuagnAhKtjPyhv99Z5Og5jfFwIEVVNAaJpaxgWB6o/9x+qk1dTgB2eBQO/AuiQaxkmpQuzvNHZkk38nu9IQ2YLkr+uaT2iDK/QI01Jpvb6GMZ50elMJifkgvtsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339670; c=relaxed/simple;
	bh=Jp+x9mfldwtvN108bvLRJrP/iKtS1pLZnKipgWETFWY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TrVnW/PluWXk8NnmSfADB2433iJ6jpaOyA7AycyWD48utcDI2gZ6D7v3x7wFOJw39KAVO3HGGlzbCwHtczJq9zSQ3qMRvvfRlZkJzwqknKx3s08In5LFETm1V01cwefehTBGSTP6YrATL5SHh7Nt4XEFQvs0A2xCxpX+deY7R0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2dTWpJhX; arc=none smtp.client-ip=209.85.221.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f201.google.com with SMTP id 71dfb90a1353d-515e42ed4d4so52509e0c.1
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 11:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339667; x=1733944467; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X68RCfWU06ROg+bUYFUfNwQoohzZnJeYoYKE3JS2eGc=;
        b=2dTWpJhX5bZqbwMyiwT+liLjIJKxdgOnn/NKaVeJqbXjcKm5y9MazPJrgsKNnyxbJE
         Gp3Yd51izXIbhyiLjP3aoWsNcOkG1tRrFoh5xTVXMyy9HpY4JuHgnBSmMGGDMXd9OhL9
         Vj4N8/9d8tFTm4ysRSDVwTA8pCrFO4y8LaxmXU3fbsrxiuViEINkp/HXC7o04+KCHY4b
         YFru9Znvx2EouvIuU34OfycNOAiLRn/rCDgrEBliIu8caqk7mcHoAL8LyRmx1dSkVPTE
         xN9JFaIGrwC2TLUGhMyGWp7QOYi5cFk46CpFyd1L8HUUbLlpE+YWha/1i2fcVYCpFrYy
         FPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339667; x=1733944467;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X68RCfWU06ROg+bUYFUfNwQoohzZnJeYoYKE3JS2eGc=;
        b=PZq6h+YbPasAias2Sma1rIxAxFzxj8VnV4sMggCvFtPlRY1W8iN4+QcCQo6hkHZPFM
         n9Vp8K6xNnNNdI34yqRdbnh8zgV+ru1alLW3Cp4DI8URAwHs65ZyYEZaxw2oM+6p5d4k
         Q7CtHkVWgRguXIasOvcCqNdif+6KtIR+64IC9TOhqU260s6ea8qne3YPpnKd8b6r3Jah
         2XrPNSbfBqOZtNRN3hNUCi/21OGXqiQsR/cU4h6aP5NdhZ1ul+1OB4Af+rpQ2NaND9S4
         SFPmEazMvHNCIvOhG+9xbcveIzNG13aoWSsAM6qjKROO3KdEGrv24BCYVcPgD+DP8rIU
         kJ3g==
X-Forwarded-Encrypted: i=1; AJvYcCXUIFDdChaR8BfBgVVa1e7vz5nZn2R3XPeCcE5jnQ5zJQIov0S2xz2MjTNZu1a0g/e8P+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz725m+SWVjjah+HfKv6dtk6SI+or0Oqk04XlnsTthFKIcde8cF
	TRkoML9iLXVEdvUfnb41xbZKwNf0mRZzFGSOoYm28GT0XyqPjzkSMVq/fznUgf6IM9IQYH3ovEr
	d3bpS9VdAK+Zu0jatzg==
X-Google-Smtp-Source: AGHT+IGSL6/LfQGJ9Uj3DkWwK1IsrYPhpONzXFegfmhrDCtj+kw22erCa4lpakX9RjG5PxsHges9rOrFeGcBxOQ3
X-Received: from vkbr6.prod.google.com ([2002:a05:6122:6606:b0:515:3ac1:ec42])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:a25:b0:515:5008:118d with SMTP id 71dfb90a1353d-515bf2a393bmr10094302e0c.2.1733339666972;
 Wed, 04 Dec 2024 11:14:26 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:47 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-13-jthoughton@google.com>
Subject: [PATCH v1 12/13] KVM: selftests: Add KVM_MEM_USERFAULT + guest_memfd
 toggle tests
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Make sure KVM_MEM_USERFAULT can be toggled on and off for
KVM_MEM_GUEST_MEMFD memslots.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index d233cdfb0241..57b7032d7cc3 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -556,6 +556,35 @@ static void test_add_overlapping_private_memory_regions(void)
 	close(memfd);
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
@@ -582,6 +611,7 @@ int main(int argc, char *argv[])
 	    (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))) {
 		test_add_private_memory_region();
 		test_add_overlapping_private_memory_regions();
+		test_private_memory_region_userfault();
 	} else {
 		pr_info("Skipping tests for KVM_MEM_GUEST_MEMFD memory regions\n");
 	}
-- 
2.47.0.338.g60cca15819-goog


