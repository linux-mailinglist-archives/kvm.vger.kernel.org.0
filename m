Return-Path: <kvm+bounces-51511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE94AAF7EEC
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:33:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95B504A1E85
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2B52F19B4;
	Thu,  3 Jul 2025 17:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pBlIx4Bd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E03328641E
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564004; cv=none; b=iTPtwQtSWOq+wqs8F66WPbL0qe8Tq4iYKyvXte4QWvaiFCPeUwymn9hBwnGuRuQW48eYZkc9oRL82SFaLuDwC32ptw4vPyniEk0tKOgl4phFN+Q4gwHUqZEOrnEkKCP+ql+Var2FK8dGlbCiZirC/SO7tNjKHriX236rGLE0wYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564004; c=relaxed/simple;
	bh=pHu7eXBP09vHyoXP15J0qfjXGuLBqzw8MI6CXU6N3pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hbDy9FTf4zRK6ShTkFuhJgHo7AgWrfWYbSu01sLDPMg5Nh7R7UqF/JeY6pi6itB4Y2EHbrniXpzt14OdDMxqT5Xj4BYDpVagi+CXjmqN4P/iq9YwuFDG5a0e1K6mAZddQsJAP5Wj7MK6TFNsBzEITEEAEoZTr7wPYiKH+mOFcKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pBlIx4Bd; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so1368835e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751564001; x=1752168801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZLkTPhlZ6ATb7AAc3VGQov8gsRhAPF8MN9ZoezL4e2s=;
        b=pBlIx4Bd5o51E1afbKgOTTIhxB59ncDBBUn/424PA2oBZE4rS5Vod4/HgE0X/Xxc1R
         hvxdFhPMmkGRkGSNHLpfkueIPVfmez2VhHlbhkZPM69VGwfD3rB1pvTZ4k4BtrJiucvS
         AMJUDnyByTw+NI28dZId8waSjJznme7Gv7IXbYxkJY7OVhPbT37VVcIW9QezeoPTCafm
         XufqfrFh6FbFQXouC2ZsKUzPqtpwP4wg/MdJKgZr53b10GUhcvoUYETkOf9PvaoxRohE
         u5vJR1eTSNPG0V0FzIsG5BnhAiZ0N4pAhSBhfjuuTbUnbyy9qIroHnPo1ZvKUe6NMtBY
         mjZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564001; x=1752168801;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZLkTPhlZ6ATb7AAc3VGQov8gsRhAPF8MN9ZoezL4e2s=;
        b=ShF7M6ei2Nrt2GTaq0iiZ2uG4Mum5DotIZzYiQguNrcoUG5LTykD7aAj1sWz3Rtz6k
         gQI6sL4W5+M6rqMJlk0Ve2plNDwvshVVkFyrA3kUX+1vqB+ueOsMf4weH4SWPaXwCLCA
         iGXLlqd65pzaP8DSTGHBqIFprNcfByvj7F1CKIB04KR8pSQ7YUNgxMAuMUYYqkwAPoAe
         xNIBA3ePuSAf8piDkyAVDe+uRLtajQJSSNiY+lZKdGciXdDgvvWzlJbT3MdtrX7mMJzx
         8u0VWZd5Eb8zOFZeYiHc2CgIbAmJ5hdOUJJF83oiDnM0lf6z6IHhr1u4EYXW6POCXAvR
         SYcg==
X-Forwarded-Encrypted: i=1; AJvYcCWu/si7HIdwH+vNgSme44GRI9uS0Ryi3/7Rh97PdjtDtO2+tZpeSEQNFO1/lQLpZWC+sbI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmdcvNh1+5n1EzEPxT3IHNnXz5gBJIE4B2wHXsJrJAwEPWAZ7P
	l5E7SAGCYvOrLNpUx5xcwg5uoBHiaoCaB6rFbeTGF/7JUe0mM1Uz9vCZjPP3d+Wbu/bJtgQ5mHb
	heFCWnNY=
X-Gm-Gg: ASbGncu65W6mFIrR4SAp4MifJEfLJSx66IbRiF6Po9P+t48Udp2e4rl1UJK/orT8pzp
	Prt+NPX3QQXXiOSeOiM5/viXlN3zv17IwTVzjHRWE+tU2HgRy0zKqZ8T2Wts3bku083e9V2AR57
	6aBrNiTZpBnA2vrd4ZlUvU+CkAkg2/KanZOxjsRP8qBpaIS6ZQmrBbP7dohZAH0S31XylCdDHh8
	geNn90pe4Pzd0JOCKiy+admEyTgaR+b9jTKDkLVt7g+iRZC/SxS5hdxwhJgjhyIDw4LTrYYAhZH
	Znbz+8Sam7CK3zftlzCbIbi59VuvErktY8MHEflU0fOdEjnM/w+6GlmfuXRDiwf//6hQcm/wLu6
	JT9fAj+Q3uve1mIF3l2wFRp2IiiJngJux+DLa
X-Google-Smtp-Source: AGHT+IF7y0Ub+Cf0w0FURKaEgGsSG7UcWWxJaioorDsaWNR4xJx/xmz1NjsWoloY7AE88tq2thGyYg==
X-Received: by 2002:a05:600c:4f84:b0:450:d37c:9fc8 with SMTP id 5b1f17b1804b1-454a3e1a96amr87058205e9.13.1751564000930;
        Thu, 03 Jul 2025 10:33:20 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b4708d099esm332340f8f.21.2025.07.03.10.33.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 10:33:20 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v6 06/39] accel/kvm: Reduce kvm_create_vcpu() declaration scope
Date: Thu,  3 Jul 2025 19:32:12 +0200
Message-ID: <20250703173248.44995-7-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703173248.44995-1-philmd@linaro.org>
References: <20250703173248.44995-1-philmd@linaro.org>
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


