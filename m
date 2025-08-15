Return-Path: <kvm+bounces-54774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 27E36B2797E
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 08:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A444C1B6809F
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 06:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2BA92C326D;
	Fri, 15 Aug 2025 06:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lvtl9d5Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4602C0F95
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 06:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755240904; cv=none; b=qHjULhQdiLDEFTX9kWaS2y0BMl2GAWIhOmMTJC60+FV33HfgUGTPMp9xLo6o/WTQZUzdiXZMpk/yHiUuTClMbAGbKz9tgq3R/jlTBIlOKFHx30gsxfj0yXXl4R+oU2uDV9OgrepTtuItZ6RqmzDoxJV8CazXbh4CyzNDfditGt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755240904; c=relaxed/simple;
	bh=gpSS+rp9W3CUUshVNpGGRkh7AqaYeyeVzzjvVQlEPJg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GkzCsgVeUAu2Ui7kT71ohUzXhCi62F/7NVtRgpgeR9cDXLsookkXW9vHki1CoMptHTV56hR8HSRBbEMQjlVSErLN+x7K5dvuU+H99oN2Gg8JByhicMYc5RXnoVXwsmiMk6rjd7KfcARQuz0wfQFNRnKfFcsXZ+U28cELqMQ8lL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lvtl9d5Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755240901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QfpRJDOx7vIf6iHMO1GUhD3FuyAbfUVze5LyzZkdcbY=;
	b=Lvtl9d5Y4KhpQKVDKr5yMfmahBaivAVc8Rvqo7cis+/pgg+9AVG95QyOqdgtxMBCwb51uh
	FPCUtPOUFK4kDZA067ndCpJujBDgTYRfZ8MhRjCu9Zmjl+xhN9efmAp8/HjE47Z0pqCRp0
	1tNvP2/6bVRw2eHTQdWRcOaBi0y9Fgc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-TglmotwJOgS0b5J440xkIg-1; Fri, 15 Aug 2025 02:55:00 -0400
X-MC-Unique: TglmotwJOgS0b5J440xkIg-1
X-Mimecast-MFC-AGG-ID: TglmotwJOgS0b5J440xkIg_1755240899
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-244581ce388so35139175ad.2
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 23:54:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755240899; x=1755845699;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QfpRJDOx7vIf6iHMO1GUhD3FuyAbfUVze5LyzZkdcbY=;
        b=jUIHcyXthRx1YiP/64nVHSiOLvx8M8MVnq1g68U/sudFmFv509jk/+VTNM1+H9vC2P
         NoAwXU3Sk1nLn1dfSrGijSdTnUsTyOLq5GGDAE0LDicolVw+l6zrdfMHDuAFcuRxH2Ar
         EgvRDZgo3jGvnybd5Pvd6VH7qzqBDM+u4pukJe2Rbaon54VkN009xPNCI5PEr1/X9L2a
         EUoLUjp3zZMtylW7QuUHD+zMOStW4Hmz5LzdIw0MJxyB8isv94slu+6tC1QYHb0VIH2j
         fc2PorNKex39HzqcMIgdzmvMOZkj+RdYA7w2WXUPeNdDNDRXoz0oMPcXqTNV9MV2yI9C
         DCdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn0suOqYJO4wgtLuBhfjmi1sVvh/frc48AoPEMKPTJA7fhwhktsfqE0SJ4yscobTxCzIo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZmoDceUUiYwrkND4zb0c9qP1XUTXkLXeABeB/QlYnGc4Am+rD
	8amiQ/ZQqzNkt1Btu7V7XzHI0KXaNceIWMDGfJf4YaqWkZ8hQRu7ynIcR+/vniuhcnTua6YOwZW
	OVXr8N6c/JfW0x2jrQYTbcHdHsux2bcAxxEQ29eSQdFCxLT7Q5rAeZPObDETI9sBa
X-Gm-Gg: ASbGnctZGiSF1GcZXTuv900fzGzn5dM5xX3qoy6JABUp8X+Wlj4Q38djoplOaJAN/GN
	3C3ZaV+1aypkhPcob/BqoRWJAV/WIboEnVELXiWr75SDO2XDKtOpR3CpskgSMopzVBYU2LL8kS9
	IdfMSDl7/ibuwMoHZncyTuZWfU+Pq5tq45c2EiLV/Lpuv605GNcmswZBckUOvJet8y33i1YD/mJ
	sk4D0dA6qqd4EJ4aSCcH5mGbG35trPTWBNGzs4JvwDD2is/L0tdeBmmqhpvBFzAnSPsgFzdkt7U
	mPeuO/rM2W0I4ALqWLQgP04Shh9eMZYi31Q3v+ng8cyPXNaYrnqsyGZm
X-Received: by 2002:a17:902:cccb:b0:240:a430:91d with SMTP id d9443c01a7336-2446d6d389cmr13456515ad.10.1755240898690;
        Thu, 14 Aug 2025 23:54:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5cHP3euI0v4J2p434uBJ3KCjz24PzAMWpErVQO+9dbSjp4LF6SrU77UG22N2IuKad71zFqA==
X-Received: by 2002:a17:902:cccb:b0:240:a430:91d with SMTP id d9443c01a7336-2446d6d389cmr13456335ad.10.1755240898229;
        Thu, 14 Aug 2025 23:54:58 -0700 (PDT)
Received: from ani-lenovo.domain.name ([2401:4900:1c84:e19a:d863:5334:4ba4:f128])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2446d5a1390sm7288125ad.164.2025.08.14.23.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 23:54:57 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: richard.henderson@linaro.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2] kvm/kvm-all: make kvm_park/unpark_vcpu local to kvm-all.c
Date: Fri, 15 Aug 2025 12:24:45 +0530
Message-ID: <20250815065445.8978-1-anisinha@redhat.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_park_vcpu() and kvm_unpark_vcpu() is only used in kvm-all.c. Declare it
static, remove it from common header file and make it local to kvm-all.c

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c  |  4 ++--
 include/system/kvm.h | 17 -----------------
 2 files changed, 2 insertions(+), 19 deletions(-)

changelog:
unexport  kvm_unpark_vcpu() as well and remove unnecessary forward
declarations.

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 890d5ea9f8..f36dfe3349 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -414,7 +414,7 @@ err:
     return ret;
 }
 
-void kvm_park_vcpu(CPUState *cpu)
+static void kvm_park_vcpu(CPUState *cpu)
 {
     struct KVMParkedVcpu *vcpu;
 
@@ -426,7 +426,7 @@ void kvm_park_vcpu(CPUState *cpu)
     QLIST_INSERT_HEAD(&kvm_state->kvm_parked_vcpus, vcpu, node);
 }
 
-int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id)
+static int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id)
 {
     struct KVMParkedVcpu *cpu;
     int kvm_fd = -ENOENT;
diff --git a/include/system/kvm.h b/include/system/kvm.h
index 3c7d314736..4fc09e3891 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -317,23 +317,6 @@ int kvm_create_device(KVMState *s, uint64_t type, bool test);
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
-/**
- * kvm_unpark_vcpu - unpark QEMU KVM vCPU context
- * @s: KVM State
- * @vcpu_id: Architecture vCPU ID of the parked vCPU
- *
- * @returns: KVM fd
- */
-int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id);
-
 /**
  * kvm_create_and_park_vcpu - Create and park a KVM vCPU
  * @cpu: QOM CPUState object for which KVM vCPU has to be created and parked.
-- 
2.50.1


