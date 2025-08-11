Return-Path: <kvm+bounces-54470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EAD0B21AB7
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:24:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 331631904550
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8729C2E36FB;
	Tue, 12 Aug 2025 02:24:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150F920C478
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 02:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754965451; cv=none; b=rmo603TO8PVcxoID1yl0l3tHgNhZYnHR4VPVfDrRzAGb++WfyL2p2X72ogATHvEHpYZM0FE446QGnDgqc68P4fzbw5CfX/bzVIJLwoHtCzD6EaauPracasf9xnjjHYsZ0RYCecxPFFEeCG6T0+Alfvlqb/M4+IIt0H94Dn6F/3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754965451; c=relaxed/simple;
	bh=LoZ77/PwopwQcEYQmpRgdlMhFd+st0uM3ty72vN0JUY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sDHJRt786yw08BFWY9wfmm8kTLbS0w+tnSAPIxUIKYwUCzl25yUTYwGrxEWUNrRT7OTievA+lHI8MOxHL1jzcxeZCF0TIn9P+KHOr2bCcXCv2Wyj/ucN9AUzttrYozY8tBhw9W4ar94C2Xoo9RILGx0mNDGSWk4ItPx65rdzo14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1754964569-086e2329571b8d00001-HEqcsx
Received: from ZXSHMBX3.zhaoxin.com (ZXSHMBX3.zhaoxin.com [10.28.252.165]) by mx1.zhaoxin.com with ESMTP id 0SwBfEufX5o39h3D (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Tue, 12 Aug 2025 10:09:29 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX3.zhaoxin.com
 (10.28.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Tue, 12 Aug
 2025 10:09:28 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::cd37:5202:5b71:926f]) by
 ZXSHMBX1.zhaoxin.com ([fe80::cd37:5202:5b71:926f%7]) with mapi id
 15.01.2507.044; Tue, 12 Aug 2025 10:09:28 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from ewan-server.zhaoxin.com (10.28.24.128) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Mon, 11 Aug
 2025 09:35:58 +0800
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ewanhai@zhaoxin.com>, <cobechen@zhaoxin.com>, <leoliu@zhaoxin.com>,
	<lyleli@zhaoxin.com>
Subject: [PATCH] KVM: x86: expose CPUID 0xC000_0000 for Zhaoxin "Shanghai" vendor
Date: Sun, 10 Aug 2025 21:35:58 -0400
X-ASG-Orig-Subj: [PATCH] KVM: x86: expose CPUID 0xC000_0000 for Zhaoxin "Shanghai" vendor
Message-ID: <20250811013558.332940-1-ewanhai-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 8/12/2025 10:09:28 AM
X-Barracuda-Connect: ZXSHMBX3.zhaoxin.com[10.28.252.165]
X-Barracuda-Start-Time: 1754964569
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 1731
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.53
X-Barracuda-Spam-Status: No, SCORE=-1.53 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=DATE_IN_PAST_24_48, DATE_IN_PAST_24_48_2
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.145629
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 DATE_IN_PAST_24_48     Date: is 24 to 48 hours before Received: date
	0.48 DATE_IN_PAST_24_48_2   DATE_IN_PAST_24_48_2

Both vendor IDs used by Zhaoxin ("  Shanghai  " and "Centaurhauls") rely
on leaf 0xC000_0000 to advertise the max 0xC000_00xx function. Extend
KVM so the leaf is returned for either ID and rename the local constant
CENTAUR_CPUID_SIGNATURE to ZHAOXIN_CPUID_SIGNATURE.  The constant is
used only inside cpuid.c, so the rename is NFC outside this file.

Signed-off-by: Ewan Hai <ewanhai-oc@zhaoxin.com>
---
 arch/x86/kvm/cpuid.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e2836a255b16..beb83eaa1868 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1811,7 +1811,7 @@ static int do_cpuid_func(struct kvm_cpuid_array *arra=
y, u32 func,
 	return __do_cpuid_func(array, func);
 }
=20
-#define CENTAUR_CPUID_SIGNATURE 0xC0000000
+#define ZHAOXIN_CPUID_SIGNATURE 0xC0000000
=20
 static int get_cpuid_func(struct kvm_cpuid_array *array, u32 func,
 			  unsigned int type)
@@ -1819,8 +1819,9 @@ static int get_cpuid_func(struct kvm_cpuid_array *arr=
ay, u32 func,
 	u32 limit;
 	int r;
=20
-	if (func =3D=3D CENTAUR_CPUID_SIGNATURE &&
-	    boot_cpu_data.x86_vendor !=3D X86_VENDOR_CENTAUR)
+	if (func =3D=3D ZHAOXIN_CPUID_SIGNATURE &&
+		boot_cpu_data.x86_vendor !=3D X86_VENDOR_CENTAUR &&
+		boot_cpu_data.x86_vendor !=3D X86_VENDOR_ZHAOXIN)
 		return 0;
=20
 	r =3D do_cpuid_func(array, func, type);
@@ -1869,7 +1870,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 			    unsigned int type)
 {
 	static const u32 funcs[] =3D {
-		0, 0x80000000, CENTAUR_CPUID_SIGNATURE, KVM_CPUID_SIGNATURE,
+		0, 0x80000000, ZHAOXIN_CPUID_SIGNATURE, KVM_CPUID_SIGNATURE,
 	};
=20
 	struct kvm_cpuid_array array =3D {
--=20
2.34.1


