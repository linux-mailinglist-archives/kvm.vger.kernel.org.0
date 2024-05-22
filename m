Return-Path: <kvm+bounces-17987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 005CA8CC862
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:58:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 961641F22415
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 21:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E57146D4F;
	Wed, 22 May 2024 21:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FHmSWCZg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D856C146D43
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 21:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716415083; cv=none; b=tGmU/dVacKqAAijKQs+2XV18ZPoaQIDo1/unzaJLINln5wJQzNTCtwD0g0RGG3PEz3Bq9fZodlXkvR46G1DxGayQ5yxYW/mCjpwTWTPKxC67xtD9ILSteXWxeZN7c/tygAiOo904aOdy1WxxNZhhINW28nk0kdhvMODNDyNBZ/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716415083; c=relaxed/simple;
	bh=29IUaPph125YTEEzyzSqhzqBpdvCD+GiSBZvclYW06Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=blfigHsROSmaCPKnSV2G3emt+yQ9FCP94TpL+cvirev31gS484InAmIed26wnp0ycx08v4ewyuYJne4DB7utore5MoPzbzm/RoA5TCKToBCpdeNpdAxL3NV5MtWCdcjBSi93LHMovzUitlPbhKXOCha9r1cCBCBejLDrd/gUdfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FHmSWCZg; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44MKdAhE026067;
	Wed, 22 May 2024 21:57:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=yCiLDo+FpZv9qwONyqqzaSuz2eOmA7/A8abUICV/2NQ=;
 b=FHmSWCZgMPx9I0VCASR8AXb1x+rDn374uDLEx94jGKYVGwSBpv3Cezi7MxvpIa6+yXQ0
 z6uQxdenU+iUd7d+Xq1FwK5pCE/4kWtdddCN0E7qAt4akuchfZtkmzldEbi7QD0nsERb
 Aw4OHbWfzUtnyzy8R0aBrJ9eZjn6sYxa0WXQ4QQzP1YBRx2mG6GLmogGG6wQD+Rff3gS
 SF6cSyaLNvg6XCyoj04K26YmL6svnKIpcZbAjYBxgTycqEyuTZi+r0XrHipEtVEBHjFW
 HRhTrcg240HDP8snZVsUzySsNERE/ocHHbX24gixwAZJsnNzZjyZ/COywSR2lW3NMPJ9 og== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6m7b8h32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 May 2024 21:57:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44MLZoG3005058;
	Wed, 22 May 2024 21:57:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsa40vc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 May 2024 21:57:57 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44MLvuG4007949;
	Wed, 22 May 2024 21:57:56 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y6jsa40ta-1;
	Wed, 22 May 2024 21:57:56 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
        alejandro.j.jimenez@oracle.com
Subject: [kvm-unit-tests PATCH 1/1] x86: vmexit: Allow IPI test to be accelerated by SVM AVIC
Date: Wed, 22 May 2024 21:57:55 +0000
Message-Id: <20240522215755.197363-1-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-22_12,2024-05-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405220152
X-Proofpoint-ORIG-GUID: _WqCb6-gISYxD2qlMYmr_E8_TpANtNIr
X-Proofpoint-GUID: _WqCb6-gISYxD2qlMYmr_E8_TpANtNIr

The vmexit_ipi test can be used as a rough benchmark for IPI performance
since commit 8a8c1fc3b1f8 ("vmexit: measure IPI and EOI cost") added
reporting of the average number of cycles taken for IPI delivery. Avoid
exposing a PIT to the guest so that SVM AVIC is not inhibited and IPI
acceleration can be tested when available and enabled by the host.

Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
 x86/unittests.cfg | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 867a8ea2..70cdda72 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -81,10 +81,13 @@ file = vmexit.flat
 extra_params = -append 'inl_from_pmtimer'
 groups = vmexit
 
+# To allow IPIs to be accelerated by SVM AVIC when the feature is available and
+# enabled, do not create a Programmable Interval Timer (PIT, a.k.a 8254), since
+# such device will disable/inhibit AVIC if exposed to the guest.
 [vmexit_ipi]
 file = vmexit.flat
 smp = 2
-extra_params = -append 'ipi'
+extra_params = -machine pit=off -append 'ipi'
 groups = vmexit
 
 [vmexit_ipi_halt]

base-commit: 00af1c849ced4e515f8659658d18652df2eb08fa
-- 
2.39.3


