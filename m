Return-Path: <kvm+bounces-51412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB2BAF711C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:57:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AACEA7AED7B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D9E82E3AFD;
	Thu,  3 Jul 2025 10:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Tr8EdY3I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFBE2E2F12
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540192; cv=none; b=MeGevjbIDzHYQ5sODYOhkqthiRV9QdfnwUlWOIU/1ryXar13ud7MZDzZBlRte5W6qcdp5GzlSXMwx66/jhx1ottw2esorhRrYwZ0j2sfi/z/kZ5NYyx+Ii/zY+1n3BXTPVF4DFZhWpXEKmMI99pORmnBoqesrPYKJpJ/vdE7rFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540192; c=relaxed/simple;
	bh=pHu7eXBP09vHyoXP15J0qfjXGuLBqzw8MI6CXU6N3pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eJO+Am5aB+988RRSAdDkWbW21V0ZBnsZl4DXGWYxbWqe0OHpck/5tv9zPqntC3JpNqJKNOLNHYfnT5HZ6A95MnZIcdX5+wV8rEaDUI/2lCmpRtGYZYrGi1MYWyvrr0QJcKZXk6zVIPJQ/7MbtVgsjSX1VXYIYeDU7KgypU0LEME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Tr8EdY3I; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4538bc52a8dso54967125e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540189; x=1752144989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZLkTPhlZ6ATb7AAc3VGQov8gsRhAPF8MN9ZoezL4e2s=;
        b=Tr8EdY3I673ILZZUPz4nNf4ml07A2WeOPjVLFaqdn01vXLmG6xJGHHZyMk7MDgYxsh
         gJpG/IcOer7JtkxfwuFQ3T0RuLchg5gMRZdp3/tiVmzmQEs7B78v9uVsE4txBw7wRlE8
         2sXsB4MSp3RNWGYy7t5+DLxB0GzmEk+XbRlY9iUe5S5C9WLN/+TB3eN6FZyz2HNSacM/
         OsdlOir5TnSA6iIcU24zNMhAEYgsxAKAlm9RMDqDs7yY4VkQ8PkAuOTJOReAEFOLvu8r
         kkx8juKNNwQYbdFsqfYVx7DkfwRssiMWCnIbpfKIEmN6LTFRT7Sv0uAHPOSlIVMfdjlV
         WYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540189; x=1752144989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZLkTPhlZ6ATb7AAc3VGQov8gsRhAPF8MN9ZoezL4e2s=;
        b=crRYICUqXcbmiJoyhdV/DE/qhpSXSzGsDln4LEXOlf//dwDGAl2Uxw8Qs8ucDVmQUr
         MPzM8l5XRWOQWU0u3Yo8aw0OqKwUHShMXthCgucCUrhGHKxsuBnblpeb/CPGs/5ktImD
         F+Gub24Qyi+H4DU54RolrCCZ8Baek93yga0DJ/6y+nOUO3V0u012AcsSOcTR00luzMoj
         YIqnms6wGc7+TqZ1ZuVkC2qX/Lnz8Tn0G3qSDTySABP4Pah/Z3aySJ7hEwDpU/4d3W/F
         cnZX+t7KscTjGhTe58XCNCQHQSUaec20BaFU1S9Ee7y7e7BDcpQecAJcFPP7SJjDYAmV
         XYIg==
X-Forwarded-Encrypted: i=1; AJvYcCXqrkmn/MxVovkdSlbN435z7XlUVb1KaA3JhTufpc7tb98YU3H1AmtN2QrX0owR6j3fwwU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJEvPpUiUJLcHdEUCiOv8ltUjlEbCW4yqcr36OI2yooF42rt9G
	9xJf2slYi7ITacdcrZ8nGfMPcIRdPelImD6SJ/9hJClxaomOHzVpbikds/lq2X3TGRs=
X-Gm-Gg: ASbGncvrhYoVU/+Sg2AM3p7bfS+NWbTgJEaQ6UGlz+ShZX7oxbShQ4DD5iV5UqyToz1
	utKaQfqkRj7r2fSmbh9PPtAPNOwk74RHqPFQSmN3OPFwG7YAv1PMZ1lIqZA8j9y57Z7lSlu2ooS
	u348aPfNXDRZQXmpMGDwfFIL2PWZxP0mAy5ATTpaeRRAOJRJl7GpQU6Hh0eLAHPE5BwbN1OXScj
	g63/KtEtpjKCfTUo8lU3VCg23SEAzYEjJs4UD4kt3BFrxOdVDYV9t8YKmxnu23cwKSLOOoSjkKs
	D2m1u4Q12NpiHezCOFaO/KEJJC464d2cDDeUnrVuBk5cckqsN0ZASQpQFHQxHUmpCSHsA/yNsdb
	FsvoP+RtuyTY=
X-Google-Smtp-Source: AGHT+IHuKoRl7IVxhklc+/5kCHwCdvXpAUKF7ZaqVxNvXsyGIXTaK/fKEVO6nr2FvIxQ868pijTYfg==
X-Received: by 2002:a05:6000:26c4:b0:3a4:c909:ce16 with SMTP id ffacd0b85a97d-3b32fb30d66mr2261011f8f.49.1751540189377;
        Thu, 03 Jul 2025 03:56:29 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9be5bbfsm23032435e9.34.2025.07.03.03.56.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:56:28 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 09/69] accel/kvm: Reduce kvm_create_vcpu() declaration scope
Date: Thu,  3 Jul 2025 12:54:35 +0200
Message-ID: <20250703105540.67664-10-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
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


