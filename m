Return-Path: <kvm+bounces-19518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C10B905E0A
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DA3F285CA1
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FC4112C498;
	Wed, 12 Jun 2024 21:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="X5YVAVY2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382AB12B177
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 21:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718229274; cv=none; b=Ovu5gjFpHSk5Y/Ty7SPbHZ5kEaMRYC6sP4O6YqrC7gEhfcO6thG8AJmKamZx9JLhoJJbxu5eTzaQipkRRiX/6IaPQikMtTI+O8uAGxvTm2PPuu0ZxFgGwkxXyUl4Y965RkOjTWOQ3EtcINy4s7FTzz/KkevcwYa5Lw7Q4jME/XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718229274; c=relaxed/simple;
	bh=rE9aL80RorEZ/DIPTVxfLLrUzVpac9U2W0UUK0H057c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z7LFQ+fHlOx+CN0Tm4mcWS3LBdaFndx1BtqL1aW+dpXAUZVUnnnut7M3GXlO7E64siziZr8DsBU0JSCh4niOsQr7L3GpHrt+b3xG1YH//WStiCGh84X1Vat2wZmFCwCqKzkYPRO43hLYlNlnk70tpaG0EiW/205vi8QdXKgY8us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=X5YVAVY2; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-35f275c7286so426537f8f.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718229271; x=1718834071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=luWaaedY4w32jXOpW7TpCRbskBqnHi+qmEvw5Pcn7cE=;
        b=X5YVAVY2jo6PXjmG5uu0KOju133PGEJvHrDBQpIXf3nxjoOTIWbxQJIJg4h5fYeLu4
         ByBLJt2RgZ2xzhRUc7/XPrRloa7XXHCqDaNnLGUHqcnoUTwhnOBnHDtpBlRVNhT0UGLc
         ZeKoiYBXCL8tZrRRRFuSpNq4mZmU6U0sY4+Dp0FE/RxEbSK5ygEtuhJ65HtXUb5PxQno
         5MYO1szdDjnqZ8JFcDklHqwin6iFE/TGQtJHUXoZkB+MzJ2aOfoo/VKmsVgWUrQs+ZfJ
         xORmIljStkUkyeolWzMtZIOkAmWMgj1kASVk8QVdp+s4t40cWRaLdRvSP0nzYSausIAL
         l7rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718229271; x=1718834071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=luWaaedY4w32jXOpW7TpCRbskBqnHi+qmEvw5Pcn7cE=;
        b=uQxV3JtM15rets9+YYWjZje7Num8vaTC/dPnYuKAnF+/zEbU6re5E2pBaXNnb5AtV2
         a2qhxB3S6Dt7rBemqEuLAq0OWXjdotTvMmBPcRo3wdZt0PaVa1AVbteOfte45hGghuku
         YHFrvaqmR8EJmOmo9FSE+2NldSu6x/0+p1Sc+/8SqhL/Rjzh7LyIlIfR6+VuThGxhq3x
         iImvl2v1RVnptDBoTq9RyZGy+yq6rg2aQ8fOJRSwnrGAwKnsOUyHF3JGz9X4qQtIREM7
         DbXuXkU1FVGtB6qGsUWwxEteIrjsBUOxjztEd4CWm/7CFkEcrWu5Z87tLtzNFzwmaL1H
         /guw==
X-Gm-Message-State: AOJu0Yw6vYBN4NdDwWGwG2TKi8Sw4YDB8fikyrftr/EEL1VC6FH8zkeQ
	g4ZZyfzQqYFu8hAXtORnOw2k6cD7DCrva6U7Kh3NYPCEu4OTS+UEIU3mncRGgrc=
X-Google-Smtp-Source: AGHT+IETn65d2hRBRBtVc+jTdn7hRbXFvnUjttjwDiC6xuRpRQfn/eMlbgoF3N640kFd25OZNkJ8yg==
X-Received: by 2002:a5d:4dce:0:b0:35f:2a43:3b16 with SMTP id ffacd0b85a97d-35fe88c4c40mr2064541f8f.33.1718229271644;
        Wed, 12 Jun 2024 14:54:31 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af372f000c444b1ebcbc1017.dip0.t-ipconnect.de. [2003:f6:af37:2f00:c44:4b1e:bcbc:1017])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6dff0247a4sm785359966b.147.2024.06.12.14.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 14:54:30 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v2 4/4] KVM: selftests: Test vCPU boot IDs above 2^32
Date: Wed, 12 Jun 2024 23:54:15 +0200
Message-Id: <20240612215415.3450952-5-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240612215415.3450952-1-minipli@grsecurity.net>
References: <20240612215415.3450952-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM_SET_BOOT_CPU_ID ioctl missed to reject invalid vCPU IDs. Verify
this no longer works and gets rejected with an appropriate error code.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index d691d86e5bc3..50a0c3f61baf 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -33,6 +33,13 @@ static void guest_not_bsp_vcpu(void *arg)
 	GUEST_DONE();
 }
 
+static void test_set_invalid_bsp(struct kvm_vm *vm)
+{
+	int r = __vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *)(1L << 32));
+
+	TEST_ASSERT(r == -1 && errno == EINVAL, "invalid KVM_SET_BOOT_CPU_ID set");
+}
+
 static void test_set_bsp_busy(struct kvm_vcpu *vcpu, const char *msg)
 {
 	int r = __vm_ioctl(vcpu->vm, KVM_SET_BOOT_CPU_ID,
@@ -75,11 +82,15 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 static struct kvm_vm *create_vm(uint32_t nr_vcpus, uint32_t bsp_vcpu_id,
 				struct kvm_vcpu *vcpus[])
 {
+	static int invalid_bsp_tested;
 	struct kvm_vm *vm;
 	uint32_t i;
 
 	vm = vm_create(nr_vcpus);
 
+	if (!invalid_bsp_tested++)
+		test_set_invalid_bsp(vm);
+
 	vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *)(unsigned long)bsp_vcpu_id);
 
 	for (i = 0; i < nr_vcpus; i++)
-- 
2.30.2


