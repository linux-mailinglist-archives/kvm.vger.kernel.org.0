Return-Path: <kvm+bounces-60196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8936DBE4DF0
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AE5E5E1057
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C5121D3D9;
	Thu, 16 Oct 2025 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="b2qFVsXg"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster2-host8-snip4-10.eps.apple.com [57.103.78.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8073EED8
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.78.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760636301; cv=none; b=arUEnMQh8ercZyuyTBknLAtdfNLMO2NKl5u0/WQspdA87jVbcn4YMUjizyoliF5+3k8rwgp8epfNTgRHUh1QuGs/KuwPL86pXdyV8HBLQCE5u91sg73bihM11NIi259GUwiDc97rHgPpjCDQ+DOCsaPq+oka+IyPVhPBf8x/eLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760636301; c=relaxed/simple;
	bh=zYLQVDbjH6U/5wVrDJdcy4U1ETlPIZJW7JCyPKEFi7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CutJ+jFK1hxG/UCUK4agIsSM+UuIz+LVes14C4oHwo3uVx80xMjIWyZxxRW34FmtSkRefLyexv458mlVWMckHzWrqUxgrOmmPwk07KQsPJcWSDaMtvRaty+ZBhK/gJNHT25r9C8oM+UtCxZhYLN00ss8KsvhrlzJYzBcXwNpiGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=b2qFVsXg; arc=none smtp.client-ip=57.103.78.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id 0B684180010B;
	Thu, 16 Oct 2025 17:38:15 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=aRq3YU5535mG5uSPAFBSlmsbBJkL1R5+IAqIsTf/zZw=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=b2qFVsXgBzjjOYrGCsSGuF3CIZSBecsxutWTAw1k7fboouzd15OBeREYRPiZDl5lv4Eg15k2Ce5QOpO7H6iiAkpPm5zjLqDcc9TOdyo8tUFhhbWGPQzaFW9/Bx7RYo3t3cGd0Z+nE/gMW/vcFCaE++qqA2jg8r9FHrWcAv2XTwdMxPq6thisq1mSwGXhOXRxfWJ5F9qBymfm0t6WvX+t5Y2XH5NoenR2eYsY1+JiINIhLe6ymep2MnMkMqmGfKCkF8cLkX+EvLS3dgAu7PheDlUNnK/BT3jgpGCBX2LcYdldupG/EoHIG/p+275kLge7s2dLlHC45d/NEBe7fwFlJA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id 70455180009D;
	Thu, 16 Oct 2025 17:38:12 +0000 (UTC)
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
	Pedro Barbuda <pbarbuda@microsoft.com>
Subject: [PATCH v8 02/24] accel/system: Introduce hwaccel_enabled() helper
Date: Thu, 16 Oct 2025 19:37:41 +0200
Message-ID: <20251016173803.65764-3-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251016173803.65764-1-mohamed@unpredictable.fr>
References: <20251016173803.65764-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: QAwfuhYe2JYUcoIdMrURBotqdvTmE11z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyOCBTYWx0ZWRfX73d3UabjojQn
 BmUc4G2wNP3DcBH3dw6RWMunMfzPGDMatt6qRtQaSNK6MSk74lWzGzjqp9lH0uyDRx4UUmFo6Wu
 GPoBlisb8vKkYLC/xGudMuM7d3tOHgEnj6cZ6ESRGuhjTR7hKDN1hsIfnsWNqpZ8ZsbFGzvBkYG
 jO6RF8gZZT8s5WdUQTYtJSzxGQhjvnHlUvFY9NM4AVyxZ7w1W/8toPqQoD7tqWEgq7pJohv/NL0
 VHUbh65bZdpe8Tvx4cEZRo1C7+/xJdhROF5UUAfO+1WtDZ60RV76yN+2ZABaAgg8/39nKCGtU=
X-Proofpoint-GUID: QAwfuhYe2JYUcoIdMrURBotqdvTmE11z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 clxscore=1030 malwarescore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2506270000 definitions=main-2510160128
X-JNJ: AAAAAAABYb2fM5ExWIiemk1nPoapfp5IdDJUiZ9mtROZdnXQrB1ItAC3f3lhbmDhqMn+MEZPFB+NMkqjl2jVxQslUpLacaLuiYIRELb7dHpyhWv+ojVso63Ix7VUiz7wt7kA+bpaWx2+YS3oXK+xPHt6SLgv8FdIf00Ik94nqSwq3vsNxhCD7QheQxkkbpzCmf1l1ojiuvjduKNAhNY2ckqEcPHb+wIqrcDFm8JE13KeLQHhOm66pz/Iotl1Xu1kCTGJncx3qesYAH34CaPAocYT22HhIAAHtgdIzB4TRkjDlEvv/MShu5awpFWpk0UCTg+vHMlK14p21pcFY2pfYGYhik3Kx5TmRyC3g5NxDJirbMoMmxp8mQUyE0KLrdDDqD69Gd7WqAzizePh3rh3YM663ZnRGEbB1YwX5nxNwgUy3mICWrbz7PuBlHtdx5QNRN9EDuFzVqkl5Bhd3fQG57kGk5rAp+97+4Q3y5/KaLqF+nYCUxZ08hlrjkaZzD4LZNy5BpyU5iD6rclahr9wE75ZZ0+aNFovDDXYKixpHvDmbiEoggoCiFp1bffH/sZGJ2nO0BpyF4Z2gKIOMHaDAq04gdfVhUob41Ap3vIA+QA9PAt/udiO5cf4YvoSqYaA71FzmyWdR1cwAgOzkuVct9HTaVpzcvWCPTB1u6F5bLkghLxvuOkvY/p5YT6KrVypvFahs26lQgy7NxexC7FS9K9cHtPi0a9gIrmunU5FslCNWpgx8nxpgmlJ9GUj540skIEmbKYAPufPpVQ6RlcEmazhVi6Psg4JSsarHpWNJSWScFE+kJyyDEldxl5Yv5slFTw9lKFOsdQYFYH4+KD8Zs9VwmDrIzz+l4+AObEuWK1tWyZg3wFrk/21C18pY9ghsruaPjbjMcQd4F1/695jW2aE+SmRg+cbTQ==

From: Philippe Mathieu-Daudé <philmd@linaro.org>

hwaccel_enabled() return whether any hardware accelerator
is enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/hw_accel.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/system/hw_accel.h b/include/system/hw_accel.h
index 55497edc29..628a50e066 100644
--- a/include/system/hw_accel.h
+++ b/include/system/hw_accel.h
@@ -40,4 +40,17 @@ void cpu_synchronize_pre_loadvm(CPUState *cpu);
 void cpu_synchronize_post_reset(CPUState *cpu);
 void cpu_synchronize_post_init(CPUState *cpu);
 
+/**
+ * hwaccel_enabled:
+ *
+ * Returns: %true if a hardware accelerator is enabled, %false otherwise.
+ */
+static inline bool hwaccel_enabled(void)
+{
+    return hvf_enabled()
+        || kvm_enabled()
+        || nvmm_enabled()
+        || whpx_enabled();
+}
+
 #endif /* QEMU_HW_ACCEL_H */
-- 
2.50.1 (Apple Git-155)


