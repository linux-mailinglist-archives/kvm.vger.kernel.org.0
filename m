Return-Path: <kvm+bounces-66766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 188CCCE6253
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 08:34:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E476130222EF
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 07:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C515263C7F;
	Mon, 29 Dec 2025 07:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="brITrchr"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115091946C8;
	Mon, 29 Dec 2025 07:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766993307; cv=none; b=HISYjC4OPiUbIegeccj281llle5NO1ctpxpZHjVX1EwnmaPmWyseH1Vs71qE5P01lpTgpNjPWTS+GcOSNSNzAJc0BaR/nxd85VWqrMhhWRHT/XOFQDbGwzcb7hZIKIOgrawPlC3j4ETqSDAmbu9RdyMIZIu4GziJocEHGDb95vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766993307; c=relaxed/simple;
	bh=XlpJe0xh/0MZRweqJxIr2/oMiJ9qaYDhLxYdAURhugQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TQFh3jG7Jgpim5hEb8oDm3Dm/1hdcOWKFwr113RBdxIL5VekQHSE9m4gaQw/5t5n0laGHAKiQQkUoYplKLAOeS6q6KS4xLEGJWcfsKUPXWB1cUrtg5sEfiWO/H9WPJm3O0uOeSWB3CRRk9ax/IJ4bHaxHOebCotA6tQRW0W8ulc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=brITrchr; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1766993211;
	bh=3N2ZF0EIrve8G0UVanB92qVexp3wyyghfgRFvk0nz20=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=brITrchrM8XeSfSe00B8DlrtUi1U79wK49AkPFPeIfWWVlSGDTL9mthDPQgolEuv/
	 XxYDwCzIkMWfxUuWtCVaTdkRkn0fZEmXYJ4cYZPLFGx6mPntqG4NzkGLUDg79ilb5t
	 qTj2UnqyYxJbiCaZ5/8elifV3pLZN95DoM7PQTpU=
X-QQ-mid: zesmtpsz5t1766993190t66218374
X-QQ-Originating-IP: 0mX17PCVUwNAxZCLo94gYEtJOiFGbOVlyPwIL3urOno=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 29 Dec 2025 15:26:28 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 7625754697422166379
EX-QQ-RecipientCnt: 11
From: Qiang Ma <maqianga@uniontech.com>
To: anup@brainfault.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	alex@ghiti.fr
Cc: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Qiang Ma <maqianga@uniontech.com>
Subject: [PATCH] RISC-V: KVM: Remove unnecessary 'ret' assignments
Date: Mon, 29 Dec 2025 15:25:30 +0800
Message-Id: <20251229072530.3075496-1-maqianga@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: NFNrK8KlcSCR9EA66xMf7tJVgZ9k+39++g4UbenDi2F6WeVvSDR2o4b6
	P/IH5mZrqlGdHXd9AyY3P9aWz1/mhvabYS7p2NU7zqx97uqd+eNDtBWdeoDzJ2HHboq4WDy
	9lOJp3935ygnDymM4/5HsYuTk/Ffz4Nvqpn+XYdzGBB/c6X586SXd4TZkLxgLACvUQYSDEO
	CJQEnW+ReUp36tz8eHwsMW8C+dcTDJoWNxvyZsUWBsRCyio+jdJhIq3Vz5B+KsmGl2BCrkE
	RdWmRkVmC26Q3Nk0+D0/a/1dlQbUW6pntCtqteTOG6fcQgcpytH9bsVgDJ9QqrKGb999fqB
	O3s0xVsFdEM15wfjkCMx3oXSYqnzqV9jdyXNO3qmezk47qpc8SuTbYScw6u6h5V5RRUPodP
	tEFXtsn5/J6kaib+6cM9y9DRw2RL9w+RkBTAHTCbu8hwJCY7gpSRV8e/6zbNvTZCmX4oTQ/
	EL6hVkKBRhXz0WVYGPd41ZU5el0gdJFHNN7oj3oWgjhn8jg300/rkawZ6e2tjLLjnhfz9ly
	CWqSIyKqNEeZxRwFR8rlxIIspjUFS89cBJdYdiKy4ge9ntj+Y69483KktxwhoT1Gt6ocYOW
	xclIScUt8Cp7Z9RVzrwAQMkX04WeP8o1f8slGQtogdzC3H58GKnQjJDCXaDXQdgTYkTKu5b
	Tg5lZd3c5juf+jh9p5iYm47mD9CWH6xKNg5EdUnt6vKRO0JKRMZZU+on+hoe7ceSedyk3X9
	ayNDmbBtZKTK1yu1f5YFSWkIil3JHB6I/X/9gQ0eln+zCbz5z9VKuM1XT4GdvsXl5t3ZDBz
	DpokjwoJMmaQwr6t37diJsqZes8wpNnxoSp5j9tCCslRpeFBLbDNzbXRAT+AjHlnFV3hjin
	9xZsD0mmWPuQCMGwOhLkjtlwwhd/fvSC450FMncA6VtOsXUwTqEQcTGhp7/KfA4P3ytqKhC
	2C4POwh1jPscnNIXNUzPswls7oxhpT3WoPpfQ13TJU4aXWa+L+3lcRLD2VT61lF3qiGatMu
	GOwmZncQr6lk/ddP2+
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

If the program can execute up to this point, indicating that
kvm_vcpu_write_guest() returns 0, and the actual value of
SBI_SUCCESS is also 0. At this time, ret does not need to be
assigned a value of 0.

Fixes: e309fd113b9f ("RISC-V: KVM: Implement get event info function")

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index a2fae70ee174..4d8d5e9aa53d 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -494,12 +494,9 @@ int kvm_riscv_vcpu_pmu_event_info(struct kvm_vcpu *vcpu, unsigned long saddr_low
 	}
 
 	ret = kvm_vcpu_write_guest(vcpu, shmem, einfo, shmem_size);
-	if (ret) {
+	if (ret)
 		ret = SBI_ERR_INVALID_ADDRESS;
-		goto free_mem;
-	}
 
-	ret = 0;
 free_mem:
 	kfree(einfo);
 out:
-- 
2.20.1


