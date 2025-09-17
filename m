Return-Path: <kvm+bounces-57866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 805ECB7F16C
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1E091C2810E
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B4C13A86C;
	Wed, 17 Sep 2025 13:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="ltioezOZ"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D46330CB49
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114136; cv=none; b=LH9MLqKDxI7agO5i0uk7KbbTOfB7sqt7XVqJ1zAq8/4VIjJRNfZ8HAQWkXNurCIsoXKoXOyobEop00N4Huh1uoqpMTyjsJxNMjfLmsWnlXqjS4EdZ4eLam8ftFYLTtcPHCYe6WPBNYXEdv8GFcf144FX0Vii++PdYoY0L4ojhzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114136; c=relaxed/simple;
	bh=T+p45GXyyaooEEcEtwAKAYRTZdoohLfkZg/bwqnQM7g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=k//M4bNDxeHzL169c1xgdooB82+hu0E25Vy+GbeKsHkenTvce+dkGp7f/OMjftYEVfJvVBN37/Fn/NTyynSwg3HwOmlJeIMI0G2N9lDIBvSvTPD+fWfo8EBWhZiY1rMJRWttx+0zP+PcmbTGjr0FEkbtKLBDESNNjJWZPHtP1Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=ltioezOZ reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN7D008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:58 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=7PCGJmdjfJHA8NxdiTCGq5+u1H1eLf1xFPp6xeAliLU=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113819; v=1;
        b=ltioezOZX36yhHqqk43mS978ufccOEdZSM8Jx7oYevVrtSzy7fAYmnbW5qi2XcRY
         E+1tC5VWYu4GbRZzYOqObhHcNSFC2Rpdu7JjbMa4EL29PhopMiYnZZsptvTKNcrO
         6uqRg/E/2mVSI/orxoAOVoG5BvHeJpz+1FYJ9UqNxSJdjDnYBlZS3pJGXF1FCd+7
         /kPSDyWBukC5UmKguKm6MqDuChgUXO1XIwv1FFtsTnG+niPGoBCF08flIQvrVrRO
         rL2V/cS1ZaKTkRlI2KSe2R/6cu+VkCvQzNTJTV/mzmIVFIGAM4DyLAH3v0IgVqyX
         mQOjOlLkEeAFxLM2qATLeg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:45 +0900
Subject: [PATCH 33/35] target/mips: QOM-ify AddressSpace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-33-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
References: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Steven Lee <steven_lee@aspeedtech.com>, Troy Lee <leetroy@gmail.com>,
        Jamin Lin <jamin_lin@aspeedtech.com>,
        Andrew Jeffery <andrew@codeconstruct.com.au>,
        Joel Stanley <joel@jms.id.au>, Eric Auger <eric.auger@redhat.com>,
        Helge Deller <deller@gmx.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?utf-8?q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <arikalo@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Alistair Francis <alistair@alistair23.me>,
        Ninad Palsule <ninad@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Yi Liu <yi.l.liu@intel.com>,
        =?utf-8?q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Aditya Gupta <adityag@linux.ibm.com>,
        Gautam Menghani <gautam@linux.ibm.com>, Song Gao <gaosong@loongson.cn>,
        Bibo Mao <maobibo@loongson.cn>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Fan Ni <fan.ni@samsung.com>, David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Subbaraya Sundeep <sundeep.lkml@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>, Laurent Vivier <laurent@vivier.eu>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Bernhard Beschow <shentey@gmail.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Weiwei Li <liwei1518@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        Bin Meng <bmeng.cn@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>, Peter Xu <peterx@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
        qemu-block@nongnu.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-179e8

Make AddressSpaces QOM objects to ensure that they are destroyed when
their owners are finalized and also to get a unique path for debugging
output.

The name arguments were used to distinguish AddresSpaces in debugging
output, but they will represent property names after QOM-ification and
debugging output will show QOM paths. So change them to make them more
concise and also avoid conflicts with other properties.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 target/mips/cpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index b13df32e6479..571caf6f4e0b 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -505,8 +505,8 @@ static void mips_cpu_initfn(Object *obj)
     if (mcc->cpu_def->lcsr_cpucfg2 & (1 << CPUCFG2_LCSRP)) {
         memory_region_init_io(&env->iocsr.mr, OBJECT(cpu), NULL,
                                 env, "iocsr", UINT64_MAX);
-        address_space_init(&env->iocsr.as, NULL,
-                            &env->iocsr.mr, "IOCSR");
+        address_space_init(&env->iocsr.as, OBJECT(cpu),
+                            &env->iocsr.mr, "iocsr-as");
     }
 #endif
 }

-- 
2.51.0


