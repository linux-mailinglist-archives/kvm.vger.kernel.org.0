Return-Path: <kvm+bounces-51260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A8D8AF0BDE
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 08:43:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BAF93A4C71
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 06:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BBBA223DEF;
	Wed,  2 Jul 2025 06:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="YY4Tk6Ur"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9952222AA
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 06:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751438575; cv=none; b=cXWzcbsVy19Fy94NmWNaiO9UuWI+nytPnDLB9/aPCA/Ev696Z33FuO0pZk7U9ZuqwXZtjGA3GVQ+xO8SInjzvkwAm4YxgMkth/Q/bGKVs3XapOn37AzjeoBX0Knp6AIrwH8SRTnY06VBw8Vggx9HnBI3OAQI9ieEyqca5VU9kFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751438575; c=relaxed/simple;
	bh=GyW877mcPzQ4uRJJlN5TIEGPtLtyctz90spQ+sxk5a0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rpnF4mSuPuGZvEQEy+q6PWjbifF6UVBK23MZ2zyJvCyjlPo73GX/K2OmbPCMnVAtbSqq4qPsnwS4gJDlcEa0bduuLx6S5j6pM9gXBAzLAS8xFtu9d48NuGO95vUZhRdeT+CqHJaHq3y0zI+NVDj+WZ4aycnp/XsaSF4MuvpaPkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=YY4Tk6Ur; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-313a001d781so3031179a91.3
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 23:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751438572; x=1752043372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z9EZ4Phati0b3r4J3srvUg6U5BmjsKi6c3l/xlKPGx4=;
        b=YY4Tk6UrfH6i/v3QzDJnwo0Eha3ua5nqM2n2cAW33YAHcInJlu1mas6q0zKPX8cZUc
         uGgC1POLjUw7oufIOKunzABCdJn7AOKaj10Ki4JXRa0OYK1aDcAW2AGHx4/lwamHYZBB
         6b9qDWjtqJZudKhBSg8hNWzAhhVU7WE92oU+IyFNYeLMUOgIAWk3sizTExLhx8TC6x/o
         Mr5PKaKP5H9zbei4FCHBQxZ8D38q/C1FEoirt5UuMOk8ymQG8VIL1KVXiX+MFHJv9IJg
         BZ9LIahdDjUt9ucvCpNVNBMB9hubnWsvVocret3ADIeeicb2/xyJrco+Akd47QdJbDCU
         KWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751438572; x=1752043372;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z9EZ4Phati0b3r4J3srvUg6U5BmjsKi6c3l/xlKPGx4=;
        b=X9jBDRZmwhq2Br0VXTbfcRfiEecO4gZgq+yv3O5KkRF1AKX+yQyiFiLLpQWGLGzO9f
         sGFNRdV3Sd6A4Lk1Yufb9G8IGAXi2G/Y6nGhfj5a1V2sK2Fr++4l2AF3GCbmXer+DdcW
         huMAVsR1aMphWjUPH6uOC+DJutadh8eByRtrCai/PF84CxXcWij/K8l618VG/98pLDyJ
         ZildGkEWCE1aff+cWdY86TEev7Ouo7SXhUG3nBTrxEaTkhNLbK0Bx7yHeS+SwmtSyAKs
         wmU2SIGMIm6cv+BovNQ4fEFpe2M1kVKXR7Rwfa4r1BQstAYnoDpjB32I8kF5OnZSnIKY
         3bTw==
X-Forwarded-Encrypted: i=1; AJvYcCV+uelkDvi1LV1PowZtJJW8NkPcMf8DJIlsU5dDFNU4MpHx4Ss1OKHbvGxLy+SqLuIhzW0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+ZRj6+gIjt93p8WGsJ7pZX/VsHdxUGsV7NB6S/1XXljsCrmSC
	k1Jj6yZ4eGW19FCT8O7+12Ng+Mf+lKzWW43XWqbmtSEpthpW2ndtlQl+wB5GCxJSBz4=
X-Gm-Gg: ASbGnctzl5sgXEOk4lPuInoRoIz/CBIFhgkRrHNhL+k+9DbpfQnF56wDTD0Z9gdHQPK
	M1bmw9vU5G7gkylZ1QUr+rTUIvg34qD6b3iSnYsPewBbU6It7ZM/U9Z/wO2wEGHqG/1AjzaL/Yu
	FVGzj/W1sBy/khCcU4HijOD0SDTZ+W58YAOYrzJGEztWB1LEQnk7i6Y9Zmskleco2plhCwjX/xf
	moUyYqFzNmSGoKX307DrLnhNc9dWyBHWyRwO1yzgJaoulhls07PE1xI6zN9JQCDm/nynHrKZoP3
	fZ6Cqya4ZMQJC+Ugi1qvP9QQzx4ehAY9WdiVtQI6/zT0oXXKF77lhQotaDHhVaQm0V7oq5Hj9RX
	gdxhgGy+CQEqicF1WCg==
X-Google-Smtp-Source: AGHT+IFJ9zmlK89dYYgj1n70N+CdCmNhaprpSgGf8BJahRpAbIqGaZGNBAEBSiNChxrDNeo+HpSy6Q==
X-Received: by 2002:a17:90b:54d0:b0:311:fde5:c4be with SMTP id 98e67ed59e1d1-31a90c352d5mr2767102a91.35.1751438571985;
        Tue, 01 Jul 2025 23:42:51 -0700 (PDT)
Received: from T179DVVMRY.bytedance.net ([2001:c10:ff04:0:1000:0:1:f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-315f5441770sm18439960a91.48.2025.07.01.23.42.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 01 Jul 2025 23:42:51 -0700 (PDT)
From: Liangyan <liangyan.peng@bytedance.com>
To: pbonzini@redhat.com,
	vkuznets@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org,
	Liangyan <liangyan.peng@bytedance.com>
Subject: [RFC] x86/kvm: Use native qspinlock by default when realtime hinted
Date: Wed,  2 Jul 2025 14:42:18 +0800
Message-Id: <20250702064218.894-1-liangyan.peng@bytedance.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When KVM_HINTS_REALTIME is set and KVM_FEATURE_PV_UNHALT is clear,
currently guest will use virt_spin_lock.
Since KVM_HINTS_REALTIME is set, use native qspinlock should be safe
and have better performance than virt_spin_lock.

Signed-off-by: Liangyan <liangyan.peng@bytedance.com>
---
 arch/x86/kernel/kvm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 921c1c783bc1..9080544a4007 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1072,6 +1072,15 @@ static void kvm_wait(u8 *ptr, u8 val)
  */
 void __init kvm_spinlock_init(void)
 {
+	/*
+	 * Disable PV spinlocks and use native qspinlock when dedicated pCPUs
+	 * are available.
+	 */
+	if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
+		pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints\n");
+		goto out;
+	}
+
 	/*
 	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
 	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
@@ -1082,15 +1091,6 @@ void __init kvm_spinlock_init(void)
 		return;
 	}
 
-	/*
-	 * Disable PV spinlocks and use native qspinlock when dedicated pCPUs
-	 * are available.
-	 */
-	if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
-		pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints\n");
-		goto out;
-	}
-
 	if (num_possible_cpus() == 1) {
 		pr_info("PV spinlocks disabled, single CPU\n");
 		goto out;
-- 
2.39.3 (Apple Git-145)


