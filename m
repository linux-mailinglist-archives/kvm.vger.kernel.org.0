Return-Path: <kvm+bounces-58291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5616BB8C9AC
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:02:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0369A62568E
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 300B42FB61B;
	Sat, 20 Sep 2025 14:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="J6N6ELnc"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster4-host6-snip4-10.eps.apple.com [57.103.84.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744A92C1587
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.84.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376927; cv=none; b=fLJQNbmEmU5CR3z3pK1PmkXtnS5QIGhBDppI0UzKwpMsLGJgQA89T/wEseQzYlqcRWtGeI2NJ5fB+EjkV6IyDj3igz7P4MEoEyWEhz98zL08RCYgoIeLlQdY2K+iZqcqH3bZbWR6QdkKeOX3EtM11RdNu8oP16uJQr5KkIUBOkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376927; c=relaxed/simple;
	bh=4TAJt4NglAqgPVyKOlVVdRIvRuZh1oraX+YU76dhicU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dWRx7iHNz2AMyPjPO18YJbVwk9afsmYSJ680cM3vU6r7vpbzylIETWXySCafUzqKNbYqhxj0H03tKQspg33XaEce8+PG5mQvIQL5ckn3vmqdx5I+t6P79wepuXf2dFSouFouPyEh5uqpuCTd/mrrGSe4g0fGkvzFviyx9FHuQ90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=J6N6ELnc; arc=none smtp.client-ip=57.103.84.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id 2C02C1817230;
	Sat, 20 Sep 2025 14:02:00 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=XmKfM241cmVZlZwVeAo0Mip3SYl5sZSgX0pYQx4Nm/M=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=J6N6ELncRyEaihjYPJMoxT0fZ8lDelkMxhS3XjCL/ySvU6sc4zdmLg33YgluD9EB0U8pVVkvSWbbPeiUA1Bib/i/r+a2Rsf9or6T5Cq9pDY3OrIT7JZhLvOAGBqTWWhSlL926XiNI9mooMm8ReqImSEpMoz3mEyeqAc6NBmS761CcGREH3q0nw3A/4tXuHvYAoDEbicCoi4tCQllGj2o9TSdEb9kKUmKNFevtXTa6qkk5SjyIObBho3eCwjgiE5ktA1bEeDTQh27AKYyIEqDT0p9zcXwCdmjvM0OYry336Sr8x0DQ58T3uDA5s372ehs7cyz6+LbiBWAvJpjYXu1zA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id 9C2F01817274;
	Sat, 20 Sep 2025 14:01:33 +0000 (UTC)
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
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v6 02/23] accel/system: Introduce hwaccel_enabled() helper
Date: Sat, 20 Sep 2025 16:01:03 +0200
Message-ID: <20250920140124.63046-3-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250920140124.63046-1-mohamed@unpredictable.fr>
References: <20250920140124.63046-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: TQsXet3sfduuP4oVrlPNRW_RbKUJOBUS
X-Proofpoint-ORIG-GUID: TQsXet3sfduuP4oVrlPNRW_RbKUJOBUS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfX7Rpfv5obkvj6
 6cbX4AZaL5mxVBOmy+8ZfSa/KG4W/dKJl6pj7a/MKGUWG+QGnTwHD99KPcUUTJd5PZLdVm4Dss3
 /HRmEel9oVlSLwZr84VX+Dvg94QNTaOjEvr3Zw42xWmhP/4rLeF0GbIjrzswHSW/A5+p37WdmPz
 WO2/JH7r07Euq8mt/xRCk8dYC/F03nzJlNsLleTK3fe1ctx909mzJ0su40I8pG8cF3a78nJS+JB
 76I7bcQo+sdEtJ+ul6hzoojaoClfH9GlFAp3kronxwFkJH9gOtfXxGiTPjfJPtDbaYm/TUDTc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 clxscore=1030 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAABSPGh9BAu13zyo+6rPDlFfBO82bwYTK4Kf+VfMkUpdnReXnSlofyT47TWx3DwWk8UI8KYI+sR6aqel+iq8DFdvgpLfxTNaKyJJb4/6awvku/vWVebvLTsei7gFylr99m45HIpxvS9e8biTrG/jmzk/O0LZoBCiG+OqzHnT312jyAEqtYeOvwbaxKVvsSADdp4+a709bygnOcZHivafZjcbHAOgz/723p9X81BQTrotWRHIPcnERS6cQ49xTIMpfRh+SFnHr+x06/mtV5Xnk9LUezOZRkAPHx6Ez5hRSvV5ncultWhnIvH6FKu47B6bEnysKUV2eELjgn9evZrDWfO/PZXzHiu+1RMV/F01A4C/TaqDZ51ZqBOPuQLIYulrGLHoqiRWTmNJfIQfSv5fOq3+88Itu7zF8W9ydiSeFIr3GawLrUsBOHJNqWFjLh0zWS43rk/To6kz2HvXrhLG/9faZgrVua6/UzOwSbEjgyeX17JkuZ+OlFyqe/Oy2+9DWln4FvW41uF5rwpzSja0QJAJXIiypX5RN17VOG5TJyqG7MQEBDLFtJR4W9TPiUcZfSv7KQJwiNvW8kLJz52sfqPINFGwCv5kXBbyV4vccFkdLxS/9lQDgtiM2FxFate0I+p2sNEn6VMCc68olDxbOm8FoqggpR8+BM/gfoyr5E3lSrcU/TdX4wc85zxcyBYqaHi5m0clLwE2D3qw9Juapwir5r/zdo2of76epEFP8DqTmUm1JkJqB7Mwc704l6ecTqGbSJn3RATjTkHTBwmGtFOZZWfOF5h5zU7NAD+YbGn7intaxEsPpF5wjBqQG2/Lg3xeIfQuCAjCv+0kX7hk7XENYWBsPgx6uKVgsUNHckf1xdKqV031g1sDhakJLkqMQ==

From: Philippe Mathieu-Daudé <philmd@linaro.org>

hwaccel_enabled() return whether any hardware accelerator
is enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/hw_accel.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/system/hw_accel.h b/include/system/hw_accel.h
index fa9228d5d2..49556b026e 100644
--- a/include/system/hw_accel.h
+++ b/include/system/hw_accel.h
@@ -39,4 +39,17 @@ void cpu_synchronize_pre_loadvm(CPUState *cpu);
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


