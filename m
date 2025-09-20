Return-Path: <kvm+bounces-58297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9687B8C9BE
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:02:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7A6C7B4F03
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D0E22FD7A0;
	Sat, 20 Sep 2025 14:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="IOLDUEDw"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster5-host7-snip4-10.eps.apple.com [57.103.86.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867232AD22
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.86.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376950; cv=none; b=YE50J2DMpMVSvd5jGTDf3ECkaZ2jbMeuK21M3brHpLiB82jf3OS3S/J36fSG7+NL9HQl26lOb5+HE1gAqQllmsniuCcaF8fcZ2K2Vd8px+9N5EJ1o0e/BOTUi1EKQco4KkzLPB4kVkkaUi8GjQqror7WvbANW+/5YZ3XTBIY0VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376950; c=relaxed/simple;
	bh=u7CsTxyki6oLbPAGqZUYiKJguUA7f7OUPajKHDOKbQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3qWDiuuiDUrRbSYX6qeUJHN1i/TiejkjRay1jJd/ugl2GRC+BJixU1xFMfM0BJVHs60kdGfWPkWQ+n1DxDXIckycy7ergVWXOdIu550Xx8GBBsoavffswHb+wl+Q/+lbG7cl2Rn6TUAloLQkY8A1AQdlvVPS68iDDf9akqdosk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=IOLDUEDw; arc=none smtp.client-ip=57.103.86.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id EBF54181721C;
	Sat, 20 Sep 2025 14:02:24 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=zNv66cYWOjcoM4iD8mPZ0d3N5D4+2q07Wwy2NtrQNPs=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=IOLDUEDwDN8Iq3LaU3lApsJnTyoRXdRFTV6DffGbumbm9etkB6vQiAYEaYIO9Pevx9cMGl/eezAahpxy16pNyQWVhr1FO2YcNbRfPxq8GJInbdsuPrchcKa9qh5H+CspfaWA1G7X3KijypHs7PaAzoJ630BzJveyPYwrp0mh8NyiVgHhZvQYWzG8koEZmO6qNzuBWDTvW9/iF6wZyTxDZtq9Du42Z/wBwSNfGNKkKq8TaBcdBijQ/FpRsmPnnGlzoLP2Pn4CNuS6CCKhgPn1yP6m4O2z96XCZj9Me6vfdlOMh8S+JnykpJ29uzHoedEPjcvCz+Mm5dcF8RDB4VJMGg==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id 548F61817261;
	Sat, 20 Sep 2025 14:01:51 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
Cc: Shannon Zhao <shannon.zhaosl@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mads Ynddal <mads@ynddal.dk>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	kvm@vger.kernel.org,
	Igor Mammedov <imammedo@redhat.com>,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	Alexander Graf <agraf@csgraf.de>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Ani Sinha <anisinha@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Peter Maydell <peter.maydell@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 08/23] whpx: common: add WHPX_INTERCEPT_DEBUG_TRAPS define
Date: Sat, 20 Sep 2025 16:01:09 +0200
Message-ID: <20250920140124.63046-9-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250920140124.63046-1-mohamed@unpredictable.fr>
References: <20250920140124.63046-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: o3u7CCR8NAtDuWC5ymQf3UtFwD8cH3bs
X-Proofpoint-GUID: o3u7CCR8NAtDuWC5ymQf3UtFwD8cH3bs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfXyVPhRy0mwR0y
 e5R/zfR8jzzR8mEtuqqlGlwZ0LSX+tKNgpxBnL1/YVFDDro0LkflYEGQRcxqCAOCUsQnG4/zMDo
 D6/aJkpWGDQkpe/eXP9KgDpl0jyOyyb/ZaAMvnu8tHyjWhLS7pNVcrxNffO4B5iyQoiv+h7nuyv
 akRLoN0ueC9Us3EcfD6MC4kj0ZFRPhzamRmervbltMDIT/YOIPauELW3Q6Ym5nRU354/PnpsXCS
 W2TFLPGV0BjC2E5o7RqN0GmMbCTpwbzJzWYP6CDReW/nDyXG6C6ANtWIUwRRTejtuIBnu0YeA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1030 malwarescore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAABsWmkZRyh+Oq6DMHUgSKM9+XQNVd17uzOMrcC6bpCYw1DQe/lDtYZd0jy8ElzQUkjd48E9voKYSn57K5YEXBczx5fSQlFXI+JgaRF5hO4ZXepeZq9tJpiV0xDgKFfFPtGIDG00s6qJjLh2a9BkQPDHpzYzbeFB8DzGm57lhvDPb6bRU+ci9xid7l+CO2W748k1IkmHiHvokfHE/Hxn+vgfEefh4bjKoyzVn/Vs+Bh1zKm9rJdAECgtQd0c1NwzRhT25eJmXOAU7CBWqtdSczgWD2erL/n/i3o0yYy8WkZDN4CJG/H7PjrOA6xERipimHdpBNE+IwNDEhYmn0IYi9/gBVQPE/KnWVIOpawQbk81QCG/q79NtWMFOvM88se8kUPOWfKcej2jBzoomlSqurAhcuDfL1Wp8Fn2CsBCwIE8fYLowUr4fnJ8nOlWJ9XngvtACLZzd4xuKUvM1Mk9IvLwvwdzyh35NCL4Xj3mn1L3/QZJxRbqTCYJIG5KfkL8H2dWjnHtPhNza+4HYPrawJ3x4DV3q77dhD2bN3wnoEHmifv2eQgJybMtbhODtIF2k5qmnYtD+Ctyqj/y64MtMRkcEeIBGBQn7GIyxj6Twcb1IFLBfaojzLdZXwAadSbDHfvG3mAk/2RD4W+PZiHa+PB8LmrEBWisEwtCQuj27gPWJ+qEAn9jJpxTKYfl8HVYqNplWGsksemCuEMYEETJspmC6k+x506dTI9YgOWVvxU4JrILHxuu+c9Q29SqscLu3du65Lhd7HvGsLRTqMgcJDUenqL2whLRp4MQ6+sN5p2UrAUPKygNWLY/w8ZTJDAjM0WuyhCIrdjvZ0M5x55+PoQKiV90aZ4WknZcUq6EAEOKneaMcKUIl2vPJTxV/iWsAlLipGPjmRrGN6ZzA==

As of why: WHPX on arm64 doesn't have debug trap support as of today.

Keep the exception bitmap interface for now - despite that being entirely unavailable on arm64 too.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 accel/whpx/whpx-common.c     | 2 +-
 include/system/whpx-common.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/accel/whpx/whpx-common.c b/accel/whpx/whpx-common.c
index 95664a1df7..c0ff6cacb8 100644
--- a/accel/whpx/whpx-common.c
+++ b/accel/whpx/whpx-common.c
@@ -123,7 +123,7 @@ int whpx_first_vcpu_starting(CPUState *cpu)
          * have one or more breakpoints enabled. Both require intercepting
          * the WHvX64ExceptionTypeBreakpointTrap exception.
          */
-        exception_mask = 1UL << WHvX64ExceptionTypeDebugTrapOrFault;
+        exception_mask = 1UL << WHPX_INTERCEPT_DEBUG_TRAPS;
     } else {
         /* Let the guest handle all exceptions. */
         exception_mask = 0;
diff --git a/include/system/whpx-common.h b/include/system/whpx-common.h
index 7a7c607e0a..73b9f7c119 100644
--- a/include/system/whpx-common.h
+++ b/include/system/whpx-common.h
@@ -20,4 +20,7 @@ int whpx_first_vcpu_starting(CPUState *cpu);
 int whpx_last_vcpu_stopping(CPUState *cpu);
 void whpx_memory_init(void);
 struct whpx_breakpoint *whpx_lookup_breakpoint_by_addr(uint64_t address);
+
+/* On x64: same as WHvX64ExceptionTypeDebugTrapOrFault */
+#define WHPX_INTERCEPT_DEBUG_TRAPS 1
 #endif
-- 
2.50.1 (Apple Git-155)


