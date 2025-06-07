Return-Path: <kvm+bounces-48698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0820BAD0F1F
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 21:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 579BE16D337
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 19:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BC20217654;
	Sat,  7 Jun 2025 19:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LO2nnOUn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE801EE033;
	Sat,  7 Jun 2025 19:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749325276; cv=none; b=Nle2q0qcCcKI0N+hG00trPZ7KaGPdymXnZU1UYDO6ltQ/AgsiXclW0zlnjvXs61XeYUjeOtw2qqLrkOz4Tm6Ds0Lebr+StMXl5z4zNcI2qFD9g5xJ+uH/E+PBw9FY3PdsgaH7OFvniy9+5GcuehiuVtZS+FQIYoDp3TXJPMKCfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749325276; c=relaxed/simple;
	bh=Y30K3E0yyjFSeZhj+xUBTiPZOGiQLu3gv23G/kKzCMA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CmxcQp+muyMDH96M2Dk0obng0nkAVfeExKg6zqkrRfRY1grYdINM0miIjvuMAa27JK90P+uuSHIelMcBPD2LrGGrUTZNTt7Na76zkDV9XW5/KpuP8SuVeDnsF3muWZM8QFMIJ62yDyzvWDtVmfzReK074C0B7ksENoOMG25TaBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LO2nnOUn; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 557Hfvxl025274;
	Sat, 7 Jun 2025 19:41:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=yEkNIciN2ZXl51snU525fgC5g4mjn
	LWPSAyW/FCbrXE=; b=LO2nnOUnxu4dUKzT+uNxdct5XL7/VHqiogYLJTej2X5sn
	WfRd/dwK1RyuCCBTz1vfaxEYm8dYwlmQvH+WISlGDTLF8M76SXrp1l4sEqtI7gJQ
	vpUFRWDi33JNr+knQrGFlcJyxy9bdaWIhh/HmVeLklLTjGW3u6DLtJZ/1NT47Zht
	oYf2NxADuuIQ+6Q0g8NZACZ9PI70LsLDmffhBR6D0VYh6LRwSZNxCZk2Z8bkY48G
	HGSh0huyzCJ9wItvQwC/BRNMrOUSo9bcBW9V0LzvbCZ75ci1TPCLH4WNIned7aj0
	dcLEVwEgfUvG6WdShbdKMuFt+Wyqi1fDMX9VDuRQQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474dywrdq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Jun 2025 19:41:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 557IF4ex007379;
	Sat, 7 Jun 2025 19:41:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bv5x8ar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Jun 2025 19:41:07 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 557Jf6gP038168;
	Sat, 7 Jun 2025 19:41:06 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 474bv5x8ah-1;
	Sat, 07 Jun 2025 19:41:06 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: alok.a.tiwari@oracle.com, darren.kenny@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vhost-scsi: Fix check for inline_sg_cnt exceeding preallocated limit
Date: Sat,  7 Jun 2025 12:40:29 -0700
Message-ID: <20250607194103.1770451-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-07_08,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506070143
X-Authority-Analysis: v=2.4 cv=fdaty1QF c=1 sm=1 tr=0 ts=684495d3 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=0E5YaXQ-T7Us6pBqENsA:9
X-Proofpoint-ORIG-GUID: zrKFm2P7NJWydziM36CAf1I0LxougJUz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA3MDE0MyBTYWx0ZWRfX7ceZ/gS4wvAA L0+WgZ8Tgjjl7VP6fLXWVruHM8e+vh3ybaRXvs2pYfKP9fOW7HlW0iRJ+MHptBiUkp9BclVMwtk VOL60rSTRJ4LACI92sOShx7sz2Cwfl28bXJvoky259xv7DIpGGj4CEsGgRhdnU421kWM366YrbR
 XzvQl1I1v+dQMGVpW5uSH7p49yOFt6Z7mqvBejEWD9HIlC94+OgVE1EYhZ5jxAg2znxICwssIbA 2uZTmHuGoj4VIPKDcTdCfv3n39a7OyrV+ivZQvj3cQRq8LtmTHje/Zl7W45LZBTDIp90DrRP6lx 02F0/cMcCVal5BnZH01u2O0jLEPw8Qgto+IH33wXK3/vaGETanLdvS0oBBPmB9lq9Q6qRJ9N0bt
 bDHbB5oP6G9UzRM0tbYrXdsSO71TOgJ2ZCy2dd+nUIjXHRxzKKG3NRNFTi2kR2J76Dxp2Z7p
X-Proofpoint-GUID: zrKFm2P7NJWydziM36CAf1I0LxougJUz

The condition comparing ret to VHOST_SCSI_PREALLOC_SGLS was incorrect,
as ret holds the result of kstrtouint() (typically 0 on success),
not the parsed value. Update the check to use cnt, which contains the
actual user-provided value.

prevents silently accepting values exceeding the maximum inline_sg_cnt.

Fixes: bca939d5bcd0 ("vhost-scsi: Dynamically allocate scatterlists")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/vhost/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c12a0d4e6386..8d655b2d15d9 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -71,7 +71,7 @@ static int vhost_scsi_set_inline_sg_cnt(const char *buf,
 	if (ret)
 		return ret;
 
-	if (ret > VHOST_SCSI_PREALLOC_SGLS) {
+	if (cnt > VHOST_SCSI_PREALLOC_SGLS) {
 		pr_err("Max inline_sg_cnt is %u\n", VHOST_SCSI_PREALLOC_SGLS);
 		return -EINVAL;
 	}
-- 
2.47.1


