Return-Path: <kvm+bounces-3114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 478D0800BD2
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 14:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4048B213C8
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 13:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C8938F89;
	Fri,  1 Dec 2023 13:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KbOmbn9l"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DA4131;
	Fri,  1 Dec 2023 05:27:08 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1DOB9n021398;
	Fri, 1 Dec 2023 13:26:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=QIIzSOLbRZNkgGvsJLAAWU7ffxmWVf6ssrpVvfVGXTU=;
 b=KbOmbn9l2zgja3/2u89FTyQXA7eg29PemdZNRjWDfLvYVKj3S4haroLeAviwQDLI5H0U
 TLVRzspX7fDzDPYe4QyuipgPzwhv2tNBGDCn8YIC9wewyRjzoCVRJIKOBXp5T7YtEDb9
 6+T7cTgi06B2/6NSao2smpDtlZP8DXUiPezafGd7UwCH0ck1fud4dNO7EuhtXXaJOMTs
 Yh/MllIS2tLdkXlfmXTDTo0YeGiq6o35sFV3HuxI1coHRKwJMUNuyKQtwoPTtZKI4sFR
 XDfl5Z9WlfXtl+Rxa36XUkuMl7TG25DcUcbSds3J33ncYVHI8Cw6fZnoQEyImKL7/hau fw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqg5qrcv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:26:57 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B1DCYL1005843;
	Fri, 1 Dec 2023 13:26:56 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqg5qrcu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:26:56 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1AY35j000739;
	Fri, 1 Dec 2023 13:26:55 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uku8tngr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:26:55 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B1DQqCT22020714
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 13:26:52 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9947C2004B;
	Fri,  1 Dec 2023 13:26:52 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2EDC20040;
	Fri,  1 Dec 2023 13:26:48 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.171.33.138])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  1 Dec 2023 13:26:48 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:56:48 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, mikey@neuling.org,
        paulus@ozlabs.org, sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM
Subject: [PATCH 05/12] KVM: PPC: Book3S HV nestedv2: Ensure LPCR_MER bit is passed to the L0
Date: Fri,  1 Dec 2023 18:56:10 +0530
Message-ID: <20231201132618.555031-6-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231201132618.555031-1-vaibhav@linux.ibm.com>
References: <20231201132618.555031-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _vHZRsq1I1lpdOi2QrDs_SrRVb8iFsfD
X-Proofpoint-ORIG-GUID: 7RopjzfX3-DNSuMpOub_4pEFRI1DBsc3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_11,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=813 malwarescore=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2312010092

From: Jordan Niethe <jniethe5@gmail.com>

LPCR_MER is conditionally set during entry to a guest if there is a
pending external interrupt. In the nestedv2 case, this change is not
being communicated to the L0, which means it is not being set in the L2.
Ensure the updated LPCR value is passed to the L0.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 069c336b6f3c..6d1f0bca27aa 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4084,6 +4084,8 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (rc < 0)
 		return -EINVAL;
 
+	kvmppc_gse_put_u64(io->vcpu_run_input, KVMPPC_GSID_LPCR, lpcr);
+
 	accumulate_time(vcpu, &vcpu->arch.in_guest);
 	rc = plpar_guest_run_vcpu(0, vcpu->kvm->arch.lpid, vcpu->vcpu_id,
 				  &trap, &i);
-- 
2.42.0


