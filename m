Return-Path: <kvm+bounces-41666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 639C9A6BCFC
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA965462ECB
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3831D54E3;
	Fri, 21 Mar 2025 14:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kFi/D4Yz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505C717C219
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 14:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742567580; cv=none; b=naf1moHeqn7X8euau4iKaVg1aJOnMncixgGESmpDbtrAHLKFSQ2+ppMFQxrbi3wUyxHPDYvj9uZnjG+ES1+JVZDbnp/Lt2QCkyw29oE3CxEVaJ88zIE5E8rcDsMp+rXLuihl+ScPr5qSLGTH4sGYOczhzP7c2vFxoF8XCVRDEBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742567580; c=relaxed/simple;
	bh=+LDlUo8we7HXs412riW2XVXscOex6Sq1qjsJfiM5m7E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=V4MzC5g/RUdB57EZ1tdqf3lreJXNIxlJuPw5fsl8J+31vTBOe+htLrik0p7eW8tbXXyHzyMoRtP7BA6QK+gJJ0Ipo/lUM91HpJMuehOVE/MF2LJLgm0+TQISH/2TZaLGZkc6U2gZedIzD39g6mSHDNCqrEtdrnWNzPRNzzsSfEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kFi/D4Yz; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43d0359b1fcso13539335e9.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 07:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742567575; x=1743172375; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MzFQfhx5F8dx0RL9AvvQYwg76iw5NXa4lMy+vsdeqMg=;
        b=kFi/D4YzOt770w/wvjc7ZyU62UJBn2euObrJKUlP60/QTnDz0WjYNyRKXyenjj3+d+
         8AZk3BM6HBEhEuboEEWBdaPijot2KJk1R+mOkr/H2hAabQl1NOd8ELA/Kl6wLzjp3oCE
         IQS4KvAYfhJhHX3vNTbRQ45jI04kVFtmuoFZ4sBeuddZ/kmc1iXJHZwePNhOfdULDkny
         SkrHecAg8qF0Y1r4LiI6qYbEg7biHopf4dE11IDR31/F71iIP9Wf7vCeaN5gGqCnh9Af
         KDhGkmBACtb8vNrH4I8mFFoVQUwY5gm059dGJMQT/7vZ7WJhZiJQdq1vWCauE8RtREL1
         t0Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742567575; x=1743172375;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MzFQfhx5F8dx0RL9AvvQYwg76iw5NXa4lMy+vsdeqMg=;
        b=CZPVfG4hpcNg6S8nymMdr/kCp1U6yrY2TMj5nZbSVet4lyngtPdKyGaW3+p0sBQg9o
         7n0Am8JfhLIfMPYDHqcVhGoeH0KCVmiKqpmcLjOiZzT1jJqEvFOBDds/QEAzed5De2n2
         5TwnoeVT9ToUqEVpPxeHGmcDM7FznPNtv3u8lIezQiF8F6/JxzqdxwKIYwFYhQ+8eYVt
         3I3e9FY6Ou9k2Grzg+sIKIUIA4EZseTkHhyPcXJNfNnCESSauea6G+hmz2FNDBup0paq
         TQgEqq8dNfVZc2kaeuO+9bbdAI6+2UZEv6+makDvD1j4Db0nNpcGEl8cSUDkElqsYrro
         M9SQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5Qh9HpIlxkyXwuusweHpnGkAbpEes67AVsiTFP3Ifqq05iwUKSxOqt7lgzF4UI1sQk8M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6SCj+Q5Jb0e6/9gb24sd92FsI7lM8O41heJJqYAaqO/bio+j5
	0bVRGVqFUk66q0tH2Ujpc4J2Jv6c5BvSr0ou5s6Joq+9olHnrhwBaxmVtMwhCYc=
X-Gm-Gg: ASbGnct/xZ/kwvUYcBjpRC6UqOTf6q9YwUrLSIOU8VP8v3k5a3W70W0nEsr9I6WJO2/
	erYlAYs2z/CMyiSU1Zea3rWYIWu+/lZGmvJlEuIWoL3kk+pJ+IbiL2ZnV0SXwQY7cBnyV/fXjFm
	rDujH4qd2uBB4HOL2fMWY+D2C7LooswAd8sWpoqyGzWP5XlwFkjrBj4ZJmj3CsEysugTeHw6mEz
	pHzAGQW7MbMCFbGIRDbqfZhnaS7pbuMoSHRtyUOLdCOUyFkxYEGkxw3clYKYo4ZZm0m4zsdjhTC
	ZnJxv3YLPan1vVdM/vx6RH4IPS8LIl8k+wL2RjOj5d/J/KThQw==
X-Google-Smtp-Source: AGHT+IFdHgCx4C5nFq7a41Rl1TdfpLB7mC6eqzVe1FxFvJX3eQdkfF3U3LPtyEx8bVlfn1VSsrBleA==
X-Received: by 2002:a05:600c:1c02:b0:43d:5264:3cf0 with SMTP id 5b1f17b1804b1-43d52a08ed8mr22225315e9.11.1742567575525;
        Fri, 21 Mar 2025 07:32:55 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43d4fd27980sm28845345e9.21.2025.03.21.07.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 07:32:55 -0700 (PDT)
Date: Fri, 21 Mar 2025 17:32:53 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Ricardo Koller <ricarkol@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Andrew Jones <drjones@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] KVM: selftests: Fix a couple "prio" signedness bugs
Message-ID: <ca579322-dc9d-4300-bd74-7e9240e930c7@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

There is an assert which relies on "prio" to be signed.

	GUEST_ASSERT(prio >= 0);

Change the type from uint32_t to int.

Fixes: 728fcc46d2c2 ("KVM: selftests: aarch64: Add test for restoring active IRQs")
Fixes: 0ad3ff4a6adc ("KVM: selftests: aarch64: Add preemption tests in vgic_irq")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index f4ac28d53747..e89c0fc5eef3 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -294,7 +294,8 @@ static void guest_restore_active(struct test_args *args,
 		uint32_t first_intid, uint32_t num,
 		kvm_inject_cmd cmd)
 {
-	uint32_t prio, intid, ap1r;
+	uint32_t intid, ap1r;
+	int prio;
 	int i;
 
 	/*
@@ -362,7 +363,8 @@ static void test_inject_preemption(struct test_args *args,
 		uint32_t first_intid, int num,
 		kvm_inject_cmd cmd)
 {
-	uint32_t intid, prio, step = KVM_PRIO_STEPS;
+	uint32_t intid, step = KVM_PRIO_STEPS;
+	int prio;
 	int i;
 
 	/* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
-- 
2.47.2


