Return-Path: <kvm+bounces-55845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6212B379AE
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 07:07:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98D84208633
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 05:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1503B2EC55E;
	Wed, 27 Aug 2025 05:07:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8139C26E71C;
	Wed, 27 Aug 2025 05:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756271223; cv=none; b=XgzwzV20w73oe8vLtgCIuWdcT/FinPDo/mPsytS6WYzGmVXSGQRA+B9LKbh/p6D8wCsUokSh8FaVVA1YF0FO1igZYyDY83BZLayX5BTCOjH6CbbfakbZ77G0vpa0NkbC3DPUQdhJo3I7iLJXzTHUfmZJodqpvl5AEjOD3D1+plA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756271223; c=relaxed/simple;
	bh=JI7aOfvbtpkrYD3QrqSIAxy6G2P6kcd830fbhdrC4vM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y3wSNsQa8SeA3K1UEFhJTN40Kqf7hS3jZJ4P2Chd0kFX+24ukCEZbcGQbSQuA0bB7rBO6Sri6Z+B1/0z4rtlvwhUWztNvowJq739Z/bmru86tbs6srpBMWWRejD0u7bM4Ao21YWv+OpqIc1wiUr3d/bbPbRvNG5hPtHNdv+DsY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a657db4e830311f0b29709d653e92f7d-20250827
X-CID-CACHE: Type:Local,Time:202508271301+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:bc547704-46f6-4537-bcbe-586d6e61cfdb,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6493067,CLOUDID:7871a2c7ca51f2bc02737c897857e02d,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: a657db4e830311f0b29709d653e92f7d-20250827
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 2029553132; Wed, 27 Aug 2025 13:06:54 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id A2772E008FB5;
	Wed, 27 Aug 2025 11:51:18 +0800 (CST)
X-ns-mid: postfix-68AE80B6-481635499
Received: from localhost.localdomain (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 49687E008FB2;
	Wed, 27 Aug 2025 11:51:01 +0800 (CST)
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
To: "Rafael J . wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Markus Mayer <mmayer@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Eduardo Valentin <edubezval@gmail.com>,
	Keerthy <j-keerthy@ti.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: zhenglifeng <zhenglifeng1@huawei.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Len Brown <lenb@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Beata Michalska <beata.michalska@arm.com>,
	Fabio Estevam <festevam@gmail.com>,
	Pavel Machek <pavel@kernel.org>,
	Sumit Gupta <sumitg@nvidia.com>,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	linux-pm@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	imx@lists.linux.dev,
	linux-omap@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Zihuan Zhang <zhangzihuan@kylinos.cn>
Subject: [PATCH v2 15/18] powercap: dtpm_cpu: Use __free(put_cpufreq_policy) for policy reference
Date: Wed, 27 Aug 2025 11:50:56 +0800
Message-Id: <20250827035056.353772-1-zhangzihuan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250827023202.10310-1-zhangzihuan@kylinos.cn>
References: <20250827023202.10310-1-zhangzihuan@kylinos.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Replace the manual cpufreq_cpu_put() with __free(put_cpufreq_policy)
annotation for policy references. This reduces the risk of reference
counting mistakes and aligns the code with the latest kernel style.

No functional change intended.

Signed-off-by: Zihuan Zhang <zhangzihuan@kylinos.cn>
---
 drivers/powercap/dtpm_cpu.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/powercap/dtpm_cpu.c b/drivers/powercap/dtpm_cpu.c
index 99390ec1481f..65117569d0f3 100644
--- a/drivers/powercap/dtpm_cpu.c
+++ b/drivers/powercap/dtpm_cpu.c
@@ -144,19 +144,16 @@ static int update_pd_power_uw(struct dtpm *dtpm)
 static void pd_release(struct dtpm *dtpm)
 {
 	struct dtpm_cpu *dtpm_cpu =3D to_dtpm_cpu(dtpm);
-	struct cpufreq_policy *policy;
+	struct cpufreq_policy *policy __free(put_cpufreq_policy);
=20
 	if (freq_qos_request_active(&dtpm_cpu->qos_req))
 		freq_qos_remove_request(&dtpm_cpu->qos_req);
=20
 	policy =3D cpufreq_cpu_get(dtpm_cpu->cpu);
-	if (policy) {
+	if (policy)
 		for_each_cpu(dtpm_cpu->cpu, policy->related_cpus)
 			per_cpu(dtpm_per_cpu, dtpm_cpu->cpu) =3D NULL;
=20
-		cpufreq_cpu_put(policy);
-	}
-
 	kfree(dtpm_cpu);
 }
=20
@@ -192,7 +189,7 @@ static int cpuhp_dtpm_cpu_online(unsigned int cpu)
 static int __dtpm_cpu_setup(int cpu, struct dtpm *parent)
 {
 	struct dtpm_cpu *dtpm_cpu;
-	struct cpufreq_policy *policy;
+	struct cpufreq_policy *policy __free(put_cpufreq_policy);
 	struct em_perf_state *table;
 	struct em_perf_domain *pd;
 	char name[CPUFREQ_NAME_LEN];
@@ -207,16 +204,12 @@ static int __dtpm_cpu_setup(int cpu, struct dtpm *p=
arent)
 		return 0;
=20
 	pd =3D em_cpu_get(cpu);
-	if (!pd || em_is_artificial(pd)) {
-		ret =3D -EINVAL;
-		goto release_policy;
-	}
+	if (!pd || em_is_artificial(pd))
+		return -EINVAL;
=20
 	dtpm_cpu =3D kzalloc(sizeof(*dtpm_cpu), GFP_KERNEL);
-	if (!dtpm_cpu) {
-		ret =3D -ENOMEM;
-		goto release_policy;
-	}
+	if (!dtpm_cpu)
+		return -ENOMEM;
=20
 	dtpm_init(&dtpm_cpu->dtpm, &dtpm_ops);
 	dtpm_cpu->cpu =3D cpu;
@@ -239,7 +232,6 @@ static int __dtpm_cpu_setup(int cpu, struct dtpm *par=
ent)
 	if (ret < 0)
 		goto out_dtpm_unregister;
=20
-	cpufreq_cpu_put(policy);
 	return 0;
=20
 out_dtpm_unregister:
@@ -251,8 +243,6 @@ static int __dtpm_cpu_setup(int cpu, struct dtpm *par=
ent)
 		per_cpu(dtpm_per_cpu, cpu) =3D NULL;
 	kfree(dtpm_cpu);
=20
-release_policy:
-	cpufreq_cpu_put(policy);
 	return ret;
 }
=20
--=20
2.25.1


