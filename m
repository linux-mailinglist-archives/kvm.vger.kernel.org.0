Return-Path: <kvm+bounces-72280-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SJwZDFEIo2m/9AQAu9opvQ
	(envelope-from <kvm+bounces-72280-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 16:22:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B4161C3E16
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 16:22:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F14EF30A2993
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 15:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8FB947887C;
	Sat, 28 Feb 2026 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eXZfU7fi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18945478856
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 15:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772292170; cv=none; b=GEXJr4oZ0L6YSkKRXy6nJ5kX4gs7BsA3Z06vvttM3ATGh4y5v8qRgD8u9T24WqmwaiM+7o4zYU4qL8z7wJ5irSgxyl4rN2NdgIeofysiJKVhUjCqlcehXiM182Y9jNjS7XHWxG421BOjtWX+zpRGBcNdU4pX2HcJQ1UzdysiFJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772292170; c=relaxed/simple;
	bh=S6uDKROnJeeqIi0NYupNmyjs6pTJRDFiU0dtOZkVFus=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I5b+2G6wqZ1qMpJytDbThIpw2+AQ2/Ek5DSUvBwkFXrgcEO2vq9guRWhXo4l5iFfmhFRjpr/x5UCzuXXdFpEygBbAZhYqFmxDvlmv9NP+w3GK7br2Hmow1nQjlZEp/EP5+YjpmzD9RK2b3DjpHAY4v86Z0Nr5ZLlXF4BauY+Mrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eXZfU7fi; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7987531082aso28998707b3.3
        for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 07:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772292167; x=1772896967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8gJIyL9AfQkuFfPNEXdWTtLgAIKWa7r6TpMrqBv02Ok=;
        b=eXZfU7fiZdyEB5cPUCL2lek1qIrBMg3MoNoO3T7Wvkb0hiDUwSxZZw5nB/mdggLhdu
         WWmREOdEwOFezDWlTQ0tyyCx+190RahDv1FSqp6GloKFbWfrMHHF25RHpIUpx4aItRCI
         /hR6Vb4y2DujPIfmOrvHRrI4JamhHRk4E9LXrzhGKAlY/1WAycuyDiCHFl98IEFIeEFZ
         eACjPL2mJqj5Foj9MrodBEwARpGv/0yrbkyFRKQMbeeAiJyATiiTVrzV6/umuCI5FdEw
         WwOiJJPnJ/rIjEcY5RV0kyywb+FIoJzpYODHisvIH2b6x5f0R5OJrba/+Uim9vQuxhTG
         AnPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772292167; x=1772896967;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8gJIyL9AfQkuFfPNEXdWTtLgAIKWa7r6TpMrqBv02Ok=;
        b=UzkpWvT6Yy6dNexsK2oJ34b3Ss0PYqVFcK/QFteSgZFoHR6skea4jIKmkZIalCxPiJ
         1U5eX8EtqtzS1Ay/vWi9BuwnoZX0ED+XG6IafrzgsuRW2Lv+Pwct4HdmloCKMbfD3vjp
         iWNCsIAbC6mJt/rHKYcvI0ejA/hfgY0b1iWK3I7NH22QGhZhG/xA2Mebk+7Syn/UlpUF
         RDrw+5A7Zw/GVg8biWaE3cqNDkLKKQjeLqYVs61crdtfBPfrgxLvdbw2QiEY5JkAHa69
         XV5zFm0mOh93E4WI4Rt+/D0llmzoeoTwEXiQ34EfoYnIRFA6i6jXsEqYvu62nrXRF1TK
         1GSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCWnEfk81uJs8zEc4lG9MwyqOG0GKf9JiMp6wDnpwJU/3kLbq0Gc5hwFinnAvZIBhfZVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxYIOXAkzrYB7E9pt9PRqpM4ienT2OvPPOXTtQRUMzaRUUMgpN
	xacuFjYjIFxmxKsFvEM/leyp6UGugBxjzq9x1UuNtUoEeKExgHlP82Pd
X-Gm-Gg: ATEYQzy5X68ywqeAFBtssK9y3VepEnU4piBRQfgv3ilLinN4dyk01N1Fcq0U25d+Quw
	GhoYGXO3qsk6u4Ky/1psdPqc0bixrGv9Gi1vAI/OudXm24ywf6EVBmLG24kOBQdX2yp5Q9cVahN
	93zcn8i8RfB++wDdPMaYsSM5PH7xqjmKg//KVaVxsP4CvESbe60KDZ/7NZ4IxVw8rXtX/3Z1rFF
	vimVCWvdmjPeuuYZq/GdOsMieizvvhWOlOdKt28dTVpezT+M2BtkZeZy971dPKkUVRb6eAmpUWa
	byhKFPSSP5euc7ltSqJQ4k3SJm3vISlRGaJdDD1zKBmQ/1nOrqe09vM5KT6js3OY0c9HBZvTi97
	omWqcUQC5SGF6aDpKT5vpZtPh++foMdcKOi+l4WwbD/cDW8PQ+9++G4/SmCR9sBgu13q6AgxjJN
	P2igY5cjBWx87FYEuY4vR2aiPlkvesLNorOzGjzR46BLrfNJmx+b+BRLtIDllzkP2tNQ5kPSYa4
	2+Pv+8xjGagLDbWMhO/cvaO
X-Received: by 2002:a05:690c:1b:b0:796:74cf:df0c with SMTP id 00721157ae682-798855082c6mr61686407b3.24.1772292167012;
        Sat, 28 Feb 2026 07:22:47 -0800 (PST)
Received: from tux ([2601:7c0:c37c:4c00::5c0b])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79876a92039sm32861897b3.8.2026.02.28.07.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Feb 2026 07:22:46 -0800 (PST)
From: Ethan Tidmore <ethantidmore06@gmail.com>
To: anup@brainfault.org
Cc: atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	ajones@ventanamicro.com,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Ethan Tidmore <ethantidmore06@gmail.com>
Subject: [PATCH] RISC-V: KVM: Fix out-of-bounds by 1
Date: Sat, 28 Feb 2026 09:22:26 -0600
Message-ID: <20260228152226.2116895-1-ethantidmore06@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[linux.dev,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,ventanamicro.com,vger.kernel.org,lists.infradead.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-72280-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ethantidmore06@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9B4161C3E16
X-Rspamd-Action: no action

The array kvpmu->pmc is defined as:

struct kvm_pmc pmc[RISCV_KVM_MAX_COUNTERS];

So, accessing it with index RISCV_KVM_MAX_COUNTERS would be
out-of-bounds by 1.

Change index check from > to >=.

Detected by Smatch:
arch/riscv/kvm/vcpu_pmu.c:528 kvm_riscv_vcpu_pmu_ctr_info() error:
buffer overflow 'kvpmu->pmc' 64 <= 64

Fixes: 8f0153ecd3bf1 ("RISC-V: KVM: Add skeleton support for perf")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 3a4d54aa96d8..51a12f90fb30 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -520,7 +520,7 @@ int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 
-	if (cidx > RISCV_KVM_MAX_COUNTERS || cidx == 1) {
+	if (cidx >= RISCV_KVM_MAX_COUNTERS || cidx == 1) {
 		retdata->err_val = SBI_ERR_INVALID_PARAM;
 		return 0;
 	}
-- 
2.53.0


