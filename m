Return-Path: <kvm+bounces-54875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 79002B29CAB
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 10:50:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2383B7AC8A3
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 08:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16272304962;
	Mon, 18 Aug 2025 08:49:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9E321B905
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 08:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755506982; cv=none; b=u/NJWDocab06dg6Rdbr4Wu/qYNCIFTIHmj0RYyUNuC7hRxwwHVPxU8vI0C/mt0fvedrmTY2eGaPvkhgfaaMdrr+bxUogFjsE0Nv9nKgSXcNLgiaN1gU8nrfT/+5zpPEKmm2zc5e6a5gIlfil7z/2eDb1SUPFR2UvfvdWDWpRlmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755506982; c=relaxed/simple;
	bh=9IJr2B0OQXu342s6+Rz9dTq3rwuyVN/WnfDBo0ZWKck=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IKzFlFzaveEZ9F3EHFV1ySuUgWTLgQXA99lxDKrVt/I+rjJxgbCr+Dqb/PeObannW4SypOIUxvZ1osENJ4mOZrpYY1buACJy/GcPTrRbVuEroiIUKBMtiL6KVbJ4v/rE+pDkM7ZPoidXSZy+yDim+RX0evV1moh6bzgcvFeldzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1755506305-1eb14e1c38d1870001-HEqcsx
Received: from ZXSHMBX3.zhaoxin.com (ZXSHMBX3.zhaoxin.com [10.28.252.165]) by mx2.zhaoxin.com with ESMTP id TaGvIcPsWEu6Wnov (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Mon, 18 Aug 2025 16:38:25 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX3.zhaoxin.com
 (10.28.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Mon, 18 Aug
 2025 16:38:25 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::cd37:5202:5b71:926f]) by
 ZXSHMBX1.zhaoxin.com ([fe80::cd37:5202:5b71:926f%7]) with mapi id
 15.01.2507.044; Mon, 18 Aug 2025 16:38:25 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from ewan-server.lan (10.28.24.128) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Mon, 18 Aug
 2025 16:30:34 +0800
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ewanhai@zhaoxin.com>, <cobechen@zhaoxin.com>, <leoliu@zhaoxin.com>,
	<lyleli@zhaoxin.com>
Subject: [PATCH v2] KVM: x86: allow CPUID 0xC000_0000 to proceed on Zhaoxin CPUs
Date: Mon, 18 Aug 2025 04:30:34 -0400
X-ASG-Orig-Subj: [PATCH v2] KVM: x86: allow CPUID 0xC000_0000 to proceed on Zhaoxin CPUs
Message-ID: <20250818083034.93935-1-ewanhai-oc@zhaoxin.com>
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
X-Moderation-Data: 8/18/2025 4:38:24 PM
X-Barracuda-Connect: ZXSHMBX3.zhaoxin.com[10.28.252.165]
X-Barracuda-Start-Time: 1755506305
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 802
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.145910
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Bypass the Centaur-only filter for the CPUID signature leaf so that
processing continues when the CPU vendor is Zhaoxin.

Signed-off-by: Ewan Hai <ewanhai-oc@zhaoxin.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e2836a255b16..bee8c869259f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1820,7 +1820,8 @@ static int get_cpuid_func(struct kvm_cpuid_array *arr=
ay, u32 func,
 	int r;
=20
 	if (func =3D=3D CENTAUR_CPUID_SIGNATURE &&
-	    boot_cpu_data.x86_vendor !=3D X86_VENDOR_CENTAUR)
+	    boot_cpu_data.x86_vendor !=3D X86_VENDOR_CENTAUR &&
+	    boot_cpu_data.x86_vendor !=3D X86_VENDOR_ZHAOXIN)
 		return 0;
=20
 	r =3D do_cpuid_func(array, func, type);
--=20
2.34.1


