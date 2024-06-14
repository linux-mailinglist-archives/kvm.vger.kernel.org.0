Return-Path: <kvm+bounces-19720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05959909363
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 22:29:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 176971C2252B
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 20:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD9B184113;
	Fri, 14 Jun 2024 20:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="UTPFC3A+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC1B1AB523
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 20:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718396951; cv=none; b=pqV9CBPkrChk8vt0SU8Sl09iRmgAcBwJb278cFxw9GWVXXs1dFJv8lgjGmfG+dhnLO06U2sySfX3K8YLpQzoidmQJAkMr/R5U9c3SA3JZiH8xD/hbuS4gb3dlJObXWz8UKzc4vyfLn1ebZvEBKQCrN3XfCDB+UwmHi0iujV2rUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718396951; c=relaxed/simple;
	bh=rE9aL80RorEZ/DIPTVxfLLrUzVpac9U2W0UUK0H057c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cpWvSV35Pe7FujkmiEF4kdFuEBRGhc01nQ+P2BV4njbEX9qzrVur1xtqEbZ01qmJ7DokNm6pjKKoCkip4UkIvbDj7r9Rnp2ltPPkc+hFpZUfbu8wio68MpucvquTHM4duzN2XBqNeG/n/LKWulz0+tQ/kbrexii7fTAdh+MCluY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=UTPFC3A+; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52bc3130ae6so2888044e87.3
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 13:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718396947; x=1719001747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=luWaaedY4w32jXOpW7TpCRbskBqnHi+qmEvw5Pcn7cE=;
        b=UTPFC3A+uKjGuRD2lh2ATw35UwG/RgzlOoYE0jvAo7AO5nCORtraTm2h/luVAPsPMW
         ANt8FgYY22GzUC2Fj8DEY0SKMKsu+L1ZRxgYuaoS31NIYXOgxJUoU4jbuBeezOGNtfks
         pVSecSqOM0HnfCz0O0syLz1xxMJpgIESF1mKaPKVJQOkpZkmGfiR1T4F/YMyyW/xJybM
         MQZuUIkJFRVnGxndnyT9QJ3bUsoTgUn9usg1KuCYNDnHNFWdvMqjQ/GzrBsgJhpffI3t
         5dTQvmQFK3XMJRlUn+uj8FNPlvP+PsynEZWMf7rvDN0nb3o53mdBdUtBu4qlMHIGR3sp
         BKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718396947; x=1719001747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=luWaaedY4w32jXOpW7TpCRbskBqnHi+qmEvw5Pcn7cE=;
        b=lnslrr6xQAhZLABSWUomI9TcQ5m+KNipNrIoh5fb5OkGE1TlKt1s+sJ20m5xi+r9HZ
         umXol26jKSOqq1cGz9Q3SEjyB8gQgPY1zoARDUCXSIim4m8uXw9DFpVaB30YpyVCbyp5
         +qaujnuNAvrvOV+gdAut2YrxlJu2OAGDDxXkarhbN8+JRgN7mRqfFU4zYu5wPgdykexI
         MesP4FQtQBQ98ARmH90kGtmTtXBxuRxWIW8d9I+4oAq1QIsQZvzifwUDt+2uDmjnCCba
         Ry0KXV2N8Sp738TKrEqIdqH5ahmmRm7uBN1RR+iHHWVTc9emVyZGoX8iKV9BNpIg//NW
         4PbA==
X-Gm-Message-State: AOJu0YwI/uTvi+QLu3bqgaVSGZU1Rtbd+oxPTB5zSfK4k4v8hesBS9ei
	UR9CZYgEfsEyPcKFoqUPf1n1VuyCLRaj6T10amrZvGPxhEa/xQ+SLvroszpfu6s=
X-Google-Smtp-Source: AGHT+IEmOHUj5/rqXIRaMS021umCTO3mf09IyNq7zDBRYOl2LevWv78ow0q8ehdYQwLgXBKGkdDqPA==
X-Received: by 2002:a05:6512:3da5:b0:516:d692:5e0b with SMTP id 2adb3069b0e04-52ca6e90530mr2785424e87.54.1718396947349;
        Fri, 14 Jun 2024 13:29:07 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af332a00214df27025e50a49.dip0.t-ipconnect.de. [2003:f6:af33:2a00:214d:f270:25e5:a49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed3685sm217474166b.126.2024.06.14.13.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 13:29:07 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v3 5/5] KVM: selftests: Test vCPU boot IDs above 2^32
Date: Fri, 14 Jun 2024 22:28:59 +0200
Message-Id: <20240614202859.3597745-6-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240614202859.3597745-1-minipli@grsecurity.net>
References: <20240614202859.3597745-1-minipli@grsecurity.net>
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


