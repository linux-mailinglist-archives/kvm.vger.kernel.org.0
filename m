Return-Path: <kvm+bounces-60197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 545CCBE4DF1
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:38:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC3095E037A
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D063922126C;
	Thu, 16 Oct 2025 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="cS+ih9jv"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster2-host11-snip4-4.eps.apple.com [57.103.78.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBEC17C21E
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.78.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760636301; cv=none; b=FgQPQyBDDSiGImY3u/nt/benY/c2kkp5PzQgDaUxxuMmljbPPpt1ef/hLzFbRxSLRE52dzHdR0rVEjfA0/BU0HoC8DCzOCnvhOG+jrR1IEWv2gH4deGkKccLTmPwqefVwgVAZPRXpr6FAvyLbP2BxYhcrgmnJsy63x18ifkFVlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760636301; c=relaxed/simple;
	bh=ai4ODpsqO1gMvgwD2fkvZWLvAlsPl5DJmXMxKtRNPok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6vGJG+SzVgMtfD6nBL8QsvXmaPpgydrJMcmXn75XJMsQqiYsTDW2TIKZPVgAtKR8xQsLq+KNkrhQ2KRVLlDsGeObVDBLiuxOjrvcBjkdkO92PyJVbnTJxgwkeV8PZFHy1ZlG/M5RA/rHldn0NjoZ7da7tkFDrM1m3mhx0eTJkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=cS+ih9jv; arc=none smtp.client-ip=57.103.78.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id 2DBD4180012B;
	Thu, 16 Oct 2025 17:38:12 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=+fMggmtg/uZNHz3nywgemPAlDNuqwqAYkYrWDswgN9E=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=cS+ih9jv/76lSChvIrW19avSpSc4nLkuPcYgue5BOS7gfMQJOXg7sQNZs93RY3B44PXelfuW/3UInqTNVPDx+ItDMYIG+wi6yQtsQM5fO+m4qAITa922rOhk9s3zgPgLignodHkTqpF84eTO/hpmO+Pr8y2xiVkYVSyfh+6eD/CnqDY/7tDqifs+3AQs43NYnc53F6CdXs/Te5HGPKNk7sLx8d5i7+OFiDGQX6gyseB1XLDl2mP/DmyYWSC9NXDgV9823b+aO9c4fPNLI2gWZSHwupkgJOpG4qYztPfuu3k+NjnYNiN7quw7IXCMgiODA7xpSgps+ZOoxb65a5o3gQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id E9AF8180012D;
	Thu, 16 Oct 2025 17:38:08 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Igor Mammedov <imammedo@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Ani Sinha <anisinha@redhat.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Zhao Liu <zhao1.liu@intel.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	Sebastian Ott <sebott@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 01/24] target/arm/kvm: add constants for new PSCI versions
Date: Thu, 16 Oct 2025 19:37:40 +0200
Message-ID: <20251016173803.65764-2-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251016173803.65764-1-mohamed@unpredictable.fr>
References: <20251016173803.65764-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: w8Z_qofoQvL0IK33_D3hQfhuXrMooicv
X-Proofpoint-ORIG-GUID: w8Z_qofoQvL0IK33_D3hQfhuXrMooicv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyOCBTYWx0ZWRfX52N0Er/FPRQ/
 T2y1aK4eEx7jrgO80dZBV1JoAuk6DvcFNS2Z9aUSIdalRIXihdBlnsdxwe6Fw+ZmPtjss1U1VjX
 AgA+hsg1/4EviD+zWjAgb2PxunZY31VvfmGI61X75fd/PPV1EagEgJdfjWNjJ/935K+0X2VUQvr
 BbF/PzAxiPCprRUhLZG2i5G+z9q4NNu1emQ8u5Ev47p1Q9IOeRE6m45XvXu3v70cK/jcJz3dreA
 71Ho1BSF1VoNxaqPHyIdQb1cCrYdJkq4ZurdcBPaBajZsLvqkamLUxHp0ry0+M++ACr9sdtuc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 clxscore=1030 malwarescore=0 mlxlogscore=900 suspectscore=0 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160128
X-JNJ: AAAAAAABIFdNmt6jXA8TdvfcIn70LRsn2nOCj9ypBjMsK4Hf/d1hDLBRAZ86v0IPXxYHl8fhWgm//ilIgZsZEKkZBqYg22rAtdEXiUn/BMFEk/7ewoNQbTa7MUom+TVM0qS6B5F5t7ArljTgsoi+7YoQaUoGTinYlybo+QsrQwk/Mz4NsjkbnzXtAmdwLbBbMyaYIwkD8QYAwBSqw3Wk9YO1gEjrxisqioEsINngsy1wYRI8QmChqDk3LcII+Ua/Sby8ugg1hE6JOSQh/6SnIChjjjjyg8xAwJ/y0knAtRzinMO6q40M+ZHJ+W4WZUzx/cWA8RnZVZEFsbR2G28Nzf1L7mC0aakxY0zWPT0S39pNPVBT80p1n2fRDW6gT7OBsD2i8ak8anuqia3Hq0a+s7kKO9Wfdm/4/Z3V+ScsFfsPxIl3vxAhxku9sy0YApkDe4CZX7DDTCmIVhCx5tqNJIt4vEdzCG3rCwRGbF358o9p144uz9jSPqnEatpO5WEQOpBgIUw/v7PatI07fmqVTDRyKnKiN4tx0s/iA4CLqxFlmdzie22Jt4js3FwnJj1Y4vyLc6JSfzXXZsTB+PGiBiSpJUC8SlhW9vTN8l6gFaNSxqS6HgRYqYUeqIW0DrdvaTO8IxphzMOF0+8BoZmOBFj/kWj3/tkTI4aqGc3y6xt+4ZR/aRC+iinzr19Qa7//J8HjxdT7ib87L59FjNy2HjVVfaZ5xexaG7NpQY+B+9Un5Q+b3DHs8FMEkOit5F3xVBj9fkx6EyyIFoMRM87KQ0gz3YYtVD+e6pTTRitFZdkkgUxk2t5iatN9wtHIeId0toKXeDJNLZnoWfg4EsGlOL43ZukTsA2Bw7/gbQme1vCxKzC1hX2bBdW4g7unHVzrVQPfLbTZ4f9bUKYKJzONmMJLZuDGzZSDr851

From: Sebastian Ott <sebott@redhat.com>

Add constants for PSCI version 1_2 and 1_3.

Signed-off-by: Sebastian Ott <sebott@redhat.com>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm-consts.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index 54ae5da7ce..9fba3e886d 100644
--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -97,6 +97,8 @@ MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES, PSCI_1_0_FN_PSCI_FEATURES);
 #define QEMU_PSCI_VERSION_0_2                     0x00002
 #define QEMU_PSCI_VERSION_1_0                     0x10000
 #define QEMU_PSCI_VERSION_1_1                     0x10001
+#define QEMU_PSCI_VERSION_1_2                     0x10002
+#define QEMU_PSCI_VERSION_1_3                     0x10003
 
 MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
 /* We don't bother to check every possible version value */
-- 
2.50.1 (Apple Git-155)


