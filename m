Return-Path: <kvm+bounces-54771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63320B27875
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 07:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EB6460103C
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 05:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 615A5277C8E;
	Fri, 15 Aug 2025 05:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HgCx5bEs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ECD23D280
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 05:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755235839; cv=none; b=K/7bcyEz6jcg//KbplyvSv2rWONFatlywzlQ9Nu+X3rfd1aeINhLO/pXHWMeoPgMAR0A5PEb5+qPpYABFoUnc0NNKEA+bpKHCGgk4ldI/pv0QsaoKhATi8wgIN5Yaco6es5oBbbnEhiB4CW5+VUuLUNtpjuSvGUB/AW5oJT2iwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755235839; c=relaxed/simple;
	bh=GKs5eI0592TvtkGs/90baWJBv0Sa86H4QkS4aoIuTQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k5JKRMfP0we69FpBo8uFZUVvs6R2fU7IXUytDauj74UvIzJZarCIr1BBx8buv78S5Cybu63mrvert34UrCBmo+KfrWZdic+Iqvv6fYOb1zUNcjo8rvVJbJe8AT/MSyo6/VYl+0VmuzIYSqnrJQpcEzD/1vujcYqiYY3JDL6cQT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HgCx5bEs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755235833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OHlSvAm9bdBUOrpb3X4JFBC1CXKIgTtZFn6Afgo8h8s=;
	b=HgCx5bEs6zSPpJAwWQ0BuCEMxvxtaMvFSAD3m7lEcoE9oXYR0H3alit2owYZ0ktc+RiMMx
	Hmv+QgnWkqhvL/fQkGP8QAEWZlB14MlW03oM3Xk/UdM9pEyzgk8bv10K0CG9EGwwnXe5jS
	tulttL2vxgE3UlOHlbWDkCS1ynCGkFc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-s4KBzWwqOheI53796mL4QA-1; Fri, 15 Aug 2025 01:30:31 -0400
X-MC-Unique: s4KBzWwqOheI53796mL4QA-1
X-Mimecast-MFC-AGG-ID: s4KBzWwqOheI53796mL4QA_1755235831
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-32326de9d22so1686075a91.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 22:30:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755235830; x=1755840630;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OHlSvAm9bdBUOrpb3X4JFBC1CXKIgTtZFn6Afgo8h8s=;
        b=PhvS1k4+If5OB+hn7bTytb8L1sUX1c3FbfNuSBoRVgm5+fqzH1P9nMduDK4cb+LT84
         aTaGLCrxI8GxBLgdxHkLyluLbeB1lnuogXnHzYC6O1bp8ucx3v0Qxm80nkuGrrDv6MrI
         ydChMSobdLgWgXB/LuXPV7PGzEtvSRZ9CboxDRZpo1nEedvM8aWsYt5fYPO7l1h9N1N1
         AFI557vs+mIHrNeN1BAVyTQdRaQEPAk8Bq3BMdP8QQTDh5R7NcRMf2mhR2X9NXd24hUW
         ikmRsjIkV+7uJc4XzgIQS5FcH7qBT2aQzco4UQSZb4gTODhpFTpBbXIuQE8ANv2QS0Bq
         /zTg==
X-Forwarded-Encrypted: i=1; AJvYcCWoLrw/gKwkxIMVnXHn1CfNaZempo5Lp+RUAG18u2saVvx1b7JTSfW+5YpdXvEY7IHNj/0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yysj0ZW8MVy++mwEFqmnFNoS678xU06EMhMUJ9jDPty6cE6jah6
	vbcJSeUZrlWfb/zS8WAdl0gSuq6S/YQSN3uZga57kp13iaD7n9OfZNz/9bO085TOT9+7IRCI4GH
	OTSm3qlYwGWJ2iZgpC209q/bIVVOQqcqsaY0PJZ84JLAJk8uJYCu4Yw81LC4Eg0jL
X-Gm-Gg: ASbGncv6AtoVMsHJ68js7NF3rWpY4x6QiKWWFEOjz7UmXwv8b/4AS1B7/Eq76UvoNSR
	glbEOib25FNPtxrFfi763qVuw811w2fOF5dH7bxjVySOaj2tr6Y/NDK7LMEUSp2NQkkHtlS/YT4
	OGL5/EXYWQgRAZR+KrwvMe0opbqyBqDnPQ+/AUPl9VTiwfv1TtiV87k8D2VOgtU1xDqHDHQd7xx
	3vsdlkgewTMQzzYw07l8gq5ZXW4Dak0wOA7la/Pu/dV5ceqzc7gSpeYGStQT3FPOWLutbIAWSep
	8hm5zamjWTaKjAejiAaw5rgsd2m/ang+R7D7fz0XSFiwN9F/r0XjtmsU
X-Received: by 2002:a17:90b:5305:b0:31e:7417:9e86 with SMTP id 98e67ed59e1d1-3232978cc8fmr6161740a91.9.1755235830498;
        Thu, 14 Aug 2025 22:30:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFX5oOIfhi3M+WDXrtKmAnTTBuseeBLXuOMo1RXjIkKt9Eao/SYE5dL0A70pIxVQMzxuFHsow==
X-Received: by 2002:a17:90b:5305:b0:31e:7417:9e86 with SMTP id 98e67ed59e1d1-3232978cc8fmr6161707a91.9.1755235829987;
        Thu, 14 Aug 2025 22:30:29 -0700 (PDT)
Received: from ani-lenovo.domain.name ([2401:4900:1c84:e19a:d863:5334:4ba4:f128])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-76e452b40d3sm340665b3a.51.2025.08.14.22.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 22:30:29 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH] kvm/kvm-all: declare kvm_park_vcpu static and make it local to kvm-all.c
Date: Fri, 15 Aug 2025 11:00:21 +0530
Message-ID: <20250815053021.31427-1-anisinha@redhat.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_park_vcpu() is only used in kvm-all.c. Declare it static, remove it from
common header file and make it local to kvm-all.c

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c  | 3 ++-
 include/system/kvm.h | 8 --------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 890d5ea9f8..41cf606ca8 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -141,6 +141,7 @@ static QemuMutex kml_slots_lock;
 #define kvm_slots_unlock()  qemu_mutex_unlock(&kml_slots_lock)
 
 static void kvm_slot_init_dirty_bitmap(KVMSlot *mem);
+static void kvm_park_vcpu(CPUState *cpu);
 
 static inline void kvm_resample_fd_remove(int gsi)
 {
@@ -414,7 +415,7 @@ err:
     return ret;
 }
 
-void kvm_park_vcpu(CPUState *cpu)
+static void kvm_park_vcpu(CPUState *cpu)
 {
     struct KVMParkedVcpu *vcpu;
 
diff --git a/include/system/kvm.h b/include/system/kvm.h
index 3c7d314736..c7fd7533bb 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -317,14 +317,6 @@ int kvm_create_device(KVMState *s, uint64_t type, bool test);
  */
 bool kvm_device_supported(int vmfd, uint64_t type);
 
-/**
- * kvm_park_vcpu - Park QEMU KVM vCPU context
- * @cpu: QOM CPUState object for which QEMU KVM vCPU context has to be parked.
- *
- * @returns: none
- */
-void kvm_park_vcpu(CPUState *cpu);
-
 /**
  * kvm_unpark_vcpu - unpark QEMU KVM vCPU context
  * @s: KVM State
-- 
2.50.1


