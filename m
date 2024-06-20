Return-Path: <kvm+bounces-20046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 02D7890FE55
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 10:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 813721F22C1D
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 08:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97CE017554E;
	Thu, 20 Jun 2024 08:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fsnXzR1j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EAB171063;
	Thu, 20 Jun 2024 08:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718870920; cv=none; b=mTU1aeWGpJHgTlWyG4mmGV+kMkYZUywG9pNAPLiyYBydklPhIBXhQofSvVJcTM8w0frE2/0C3Ceei75tQrhhok9xDX3rBuFV7xeAyEBG+huQz2IKx9oNaqvlIjRP8stR+LCfTuhCVqnZEotuB8H8bOqO92dwv2O9OpSxr3Kz2vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718870920; c=relaxed/simple;
	bh=2purwfY9dz0iABkPlYbptDwsvV7Xd2BdJbWR0cYMUu4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S4UghgjUHlSFBY4+dvnfqT5DjlxgCBzUG0dlL6cVfjpLzf0qNLEHSQelPmvgDEEbj3PH6IbXA813a56sgk5+wkebai2FQbY2yms2KXBLu3qoUO7m9ezCfn1/WEXWNi9hw5jui9ZOimhtVqEY+3PfQQW6xWPz08Uxg4PmKiX71yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fsnXzR1j; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-70625e8860cso511383b3a.2;
        Thu, 20 Jun 2024 01:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718870918; x=1719475718; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mL5A8uxnFw5VSQtj+T6eEUYPzTfHpbbu0xOSwlISEr4=;
        b=fsnXzR1jMD7InzggmQ4Cgzfkc1yx65o22HCwYKs7N4UGKuhftUUqdCWOkYQ6cq1s52
         8t0IxsPGLvLpOt6+jcdmQf69QGGsN9k+ZIBHW+l1Z5KUvFPq3HPWL8NlUSCMJCJv4Jif
         +LqkGehN7ny+6lnAZiDaQjEF71IaK3GS88SKJyYxyEV3l0A7bO2oxzADVVTUnG6SZLdq
         opGHw79zuaNVUrIpzrPfE7STmz0v7YAl5WZMXfwtFDGnHH2IUm1KXoGBwO9ebGRQMkTY
         qPLXlq07unO4IRMfWu71l7N62lm0VaRqGh3c74FfByMItGSLmu6dHGakQ9ZXyPFm2qvh
         gEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718870918; x=1719475718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mL5A8uxnFw5VSQtj+T6eEUYPzTfHpbbu0xOSwlISEr4=;
        b=I6DVfOmF24hu4TekPKqtW2Zdh+GWu32eSBfvUemzUZVN4Ytk+yizVxUr+C2LlkFF2E
         qlB74H40fS4kBwx1da50mrSJpFdWuUR/VuJi2iOTry2+HbE/int3vmtGtlQrOpZhrFkf
         9BXwpFjhCQLgQqrfYCdYiNYadMCG3D2GOWe3zN/5Z5VeXyatg+Q7kqW1hBVs+fWMz+1l
         Fv8vuzhPbqcLmsfr2f64q2DL/UBboQVnGUrRsZrIWP1myjbKjBlc3jtzco2xBGFos5yN
         pJDmDvHFgRKSJzSSVhuYOprbVy5rV4myFmDwmMIHdTgQwut9RASd8WCxw7eMRF6M9/VV
         wwVg==
X-Forwarded-Encrypted: i=1; AJvYcCW54LUZp47VR/G4sFKEsqDzdrSOfzhZpWFvAfStpsi8pugx9XgJJLSBYqVQSXrHIZrg8BKO+WO9IrHPI2f81D4VwZ2g
X-Gm-Message-State: AOJu0YzhslVNnhLtrSSSzEy7B8oc6BFd2noNdjoYQts0euHXyAtKbIKP
	873qFsGyPuX/iPx+KSUjZUmQPXIngZDoYEtvNnrdzeMDpSmR+CNRiFzxDQ==
X-Google-Smtp-Source: AGHT+IGLxqG3L2TAmfhqrx5qozBevACzQpi6s/yK4e7j273CxHvZ0ODsJbHM0wUFyQFYzs69jmFVlw==
X-Received: by 2002:a05:6a00:2a2:b0:704:1ed3:5a19 with SMTP id d2e1a72fcca58-70629cf2083mr4465217b3a.32.1718870918339;
        Thu, 20 Jun 2024 01:08:38 -0700 (PDT)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb71715sm12242840b3a.175.2024.06.20.01.08.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2024 01:08:38 -0700 (PDT)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH] kvm: Simplify kvm_get_running_vcpu()
Date: Thu, 20 Jun 2024 16:11:14 +0800
Message-Id: <20240620081114.70615-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

this_cpu_read() is exactly the same behavior as "preempt_disable() +
__this_cpu_read() + preempt_enable()", and it uses less instructions
in X86.

Just use this_cpu_read() to simplify kvm_get_running_vcpu().

Cc: Marc Zyngier <maz@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/kvm/20200207163410.31276-1-maz@kernel.org/
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 virt/kvm/kvm_main.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14841acb8b95..0d18e9b1017f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6306,21 +6306,14 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 /**
  * kvm_get_running_vcpu - get the vcpu running on the current CPU.
  *
- * We can disable preemption locally around accessing the per-CPU variable,
- * and use the resolved vcpu pointer after enabling preemption again,
+ * The result is either NULL or the vcpu running on the current thread
  * because even if the current thread is migrated to another CPU, reading
  * the per-CPU value later will give us the same value as we update the
  * per-CPU variable in the preempt notifier handlers.
  */
 struct kvm_vcpu *kvm_get_running_vcpu(void)
 {
-	struct kvm_vcpu *vcpu;
-
-	preempt_disable();
-	vcpu = __this_cpu_read(kvm_running_vcpu);
-	preempt_enable();
-
-	return vcpu;
+	return this_cpu_read(kvm_running_vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_get_running_vcpu);
 
-- 
2.19.1.6.gb485710b


