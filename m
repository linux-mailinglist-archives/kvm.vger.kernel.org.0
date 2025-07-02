Return-Path: <kvm+bounces-51326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 791B3AF61E5
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 20:54:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE81B18947AB
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE342BE620;
	Wed,  2 Jul 2025 18:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iYkFz9pQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13D12F7D0E
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 18:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482476; cv=none; b=pvn9W8Bm6r0LJm00wrbpvE9XUj1YRqwfz/SUc/0vJGbt8l9pJPGYI4nWajJqLHIpBskMs+Q/rVtPTC0JXWy8viliRePqjYV3uE3U3LsH21VDvHBUDJyTKXLfSAD39dvUCpmdIBR0qVU+HudQ8jKBXgIsbMhXKQwrGj4ZjzW8zT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482476; c=relaxed/simple;
	bh=pHu7eXBP09vHyoXP15J0qfjXGuLBqzw8MI6CXU6N3pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d/GK1SGuPkC4/7nzds2A8T1Eg815ZspSy5i30NnKMnEhKLn7utKj+QusdjWPJnj4pfWQbObOezBV1E/1H8OF8xnj2cxGAaNjwOrTlFynSESQqPAgm7frOgjTNVBTyVbYTGKEUd3wobjbRoPNMOhJ8lZRYOFF/P3pPiFKnzU5P30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iYkFz9pQ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a53359dea5so2794169f8f.0
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 11:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482473; x=1752087273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZLkTPhlZ6ATb7AAc3VGQov8gsRhAPF8MN9ZoezL4e2s=;
        b=iYkFz9pQPnNyuCC3mMFNJkzJLT3ySPhqUtPzv5nY2FHSov+B7LIVyAl9s8UafPxf95
         SNjOBsZvbwwLJjmOuD7IAat8i0EaMcDCBQRlfp3DNzEmrv+wu4Zm3HuAT6qukm03zigh
         lGabGYFkQJg0zOx0pD7dEZiBKjovfkG5tabQihOwMPbr1yeXB/j3nmmfF2xVXjem9X9X
         0lPkTthJODqWUPVISD1hWhkibz07anQwI+IjnI8g5YtihEvz3MDw+ZdHe7Lk+/N8gbC/
         OWbkSL/P2P+tl5AlyF5788c2TSc/5BHzfMVmAkUMahUkXGQ8L8DhEdf3jOyNLeRhwrnF
         QskA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482473; x=1752087273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZLkTPhlZ6ATb7AAc3VGQov8gsRhAPF8MN9ZoezL4e2s=;
        b=urbRut06kUxdsM+Ph2B6xTM60bydYOgJD7cYpfUSBSG9gbCdjyYIPvRuaEYI+ek//I
         /SEC4V9AKrAJhha182DMnGjAAfcfSmVCFXtF9nQGRZaWhLGR1TSLVDRmEW70/UjQJpu2
         Y9MytJ5ECfXaEWznBBKmvT9Zs9IA1YgNRIcReAXpJ8bFAJqkWPss54gzw9x9C7c8Mf8Y
         Lv/b0dJSEmaFEr63bn8JFZjpnTnN8cbn2BgB4OY7c5hn/QFsFT2+B5c8cWTivaiuJwcc
         zAKrQ41NlDnAZyQAAWuRaMAwvQ9Q29kOkcKrCxPlHuS3CSG9C//KgjWksyozunI4GQxy
         AIYA==
X-Forwarded-Encrypted: i=1; AJvYcCVUe9f2sRfb5H1iyfl0cevnuH7E6Jc3Jc66bDV32Uwi4Nrt4h/NKdcRmTrz4h4PIwizud8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY8muvc4epvXs6SBUjqIArY0yTHF8ypSzW6GcirGySTZuZB79F
	S9jH0shdvu21Mq2A0w+wlklj/mHZMeDKJ+HWZS+vTwXHO+iHqzo5eEaNMT3sxJ+l2IE=
X-Gm-Gg: ASbGncskaRWQz38zQVj+zg7Q0yh7QWp4NHjJqlo/KPl5qL50AqnvjZ8hMxvB/uLlo3X
	TVkOGkcUZREpEa+UavahSg8bbOVgHPcdYtVTbTJBECDjbJ/rWlb2gotFiHhv9zyEjmiMELaGpmo
	40rbvl1cg/LfcShdgGDwbd7oIUJljMeP9CiGnTIjJ4gAB7Axhngj84Q22ye0QsPc7bkoG7U7ONf
	KvUcQdirHAc7QNcyjdT/o1YftVtmti9axzj//JxFYGhGXAWe8Pxw7Nfnj77EFDMC4HIGLvMaHC3
	PNuWOSD3UgAo1FHL7/fDad7K4I53PTVg4pmCZI5TdRO+5KdEtPcqZIdlSQOdHOTQb/VB/tehdCe
	pwX0T4pefUJh/Cp9RLD//SyIeCNdx/96jcQPJ
X-Google-Smtp-Source: AGHT+IGhOWVCA/GtwJSG1AKi+Hd84LJnSX/lQi41cAsunon2TKagKaTx0uBPjZixIm2CjgJYn0tp6w==
X-Received: by 2002:adf:f1c7:0:b0:3a4:eef9:818a with SMTP id ffacd0b85a97d-3b20095ce85mr2954669f8f.27.1751482473295;
        Wed, 02 Jul 2025 11:54:33 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e5f44dsm16537392f8f.87.2025.07.02.11.54.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 11:54:32 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v4 08/65] accel/kvm: Reduce kvm_create_vcpu() declaration scope
Date: Wed,  2 Jul 2025 20:52:30 +0200
Message-ID: <20250702185332.43650-9-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250702185332.43650-1-philmd@linaro.org>
References: <20250702185332.43650-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

kvm_create_vcpu() is only used within the same file unit.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/kvm.h | 8 --------
 accel/kvm/kvm-all.c  | 8 +++++++-
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/system/kvm.h b/include/system/kvm.h
index 7cc60d26f24..e943df2c09d 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -316,14 +316,6 @@ int kvm_create_device(KVMState *s, uint64_t type, bool test);
  */
 bool kvm_device_supported(int vmfd, uint64_t type);
 
-/**
- * kvm_create_vcpu - Gets a parked KVM vCPU or creates a KVM vCPU
- * @cpu: QOM CPUState object for which KVM vCPU has to be fetched/created.
- *
- * @returns: 0 when success, errno (<0) when failed.
- */
-int kvm_create_vcpu(CPUState *cpu);
-
 /**
  * kvm_park_vcpu - Park QEMU KVM vCPU context
  * @cpu: QOM CPUState object for which QEMU KVM vCPU context has to be parked.
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index d095d1b98f8..17235f26464 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -453,7 +453,13 @@ static void kvm_reset_parked_vcpus(KVMState *s)
     }
 }
 
-int kvm_create_vcpu(CPUState *cpu)
+/**
+ * kvm_create_vcpu - Gets a parked KVM vCPU or creates a KVM vCPU
+ * @cpu: QOM CPUState object for which KVM vCPU has to be fetched/created.
+ *
+ * @returns: 0 when success, errno (<0) when failed.
+ */
+static int kvm_create_vcpu(CPUState *cpu)
 {
     unsigned long vcpu_id = kvm_arch_vcpu_id(cpu);
     KVMState *s = kvm_state;
-- 
2.49.0


