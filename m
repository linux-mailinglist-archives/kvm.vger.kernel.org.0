Return-Path: <kvm+bounces-53974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D8CBB1B27D
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 719EA7A3BF1
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 11:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B63F024728C;
	Tue,  5 Aug 2025 11:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Hcyvh1q0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438E8245014;
	Tue,  5 Aug 2025 11:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754392495; cv=none; b=Bwfg8JhIRY09gxRcOc/NaVgl5HB2wCo11kG3rouhMGEFiNREmOaS2S7UQRte1DdORJpEs5t4Tn7KK8n22mB8gMFiztalHvgtFjHxcY0gHpzTHPQk4lgAlqnAQdw9WfyOPMkxmfixETRAVTibBtfZApS5l+J+5BtWeaT+fQvh0Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754392495; c=relaxed/simple;
	bh=iIaaWTh2PBlOw+Zrn1Kf9Wxeho/KcidOxTwbz5QUjTU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hcz7qKdYMV2COFVjdHl5GytcMmH6nCAmYWXr6YQ8VPiY6lvnkvLSo1dHzYPOxcAnK8FjFhEjahowqOQDrJLPX6QIH4HYgbkpj1FiqOkn43RqcuCf5vPXLSYYUt+2XzU7h5f8/9RpJssCfsfDQm3e3/luUBRcFxck3KaKabdcrbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Hcyvh1q0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57596Oft023854;
	Tue, 5 Aug 2025 11:14:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=yLOm0GpaQI2TYxlGetOvxqlk0Y2bS4O++u0BiU3/F
	9U=; b=Hcyvh1q0r4qRqvZYlg+HB/h7XzHAE8TLvknPmr7NN4r59c9QfYF3A8GGJ
	ReF4iZyCj3fXgeYoTB6xplTd/PXj2M9H7pYnNQRJXlge/qySd1Dr6+IPgFiUyLAb
	qfgQQJF9ZKZAeAlXqZSqnntRL+qTZKhmZ3JGmpydHw7yKDvLQnnDO6U8t15EZ+Vi
	+1XJYG2xw+hlg2gLCvnUa7b9fY/GFmKUdBKRezDmLjp0K1kIW9ipc70oBFJWQHkX
	9JMREldqaQJlj8A4ZxwL7k0rCHktdzZLEA2KuXHgo2d+NsG8xU7axjI+oikAPDwG
	Q+/ti5pkwnlshGugDQLR+9SeRw/Ww==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 489ab3nyuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 11:14:51 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5758uX2t009971;
	Tue, 5 Aug 2025 11:14:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 489x0p23sy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 11:14:50 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 575BEkcn53281050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 11:14:46 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82EB920040;
	Tue,  5 Aug 2025 11:14:46 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52DD520043;
	Tue,  5 Aug 2025 11:14:46 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Aug 2025 11:14:46 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        mhartmay@linux.ibm.com, borntraeger@de.ibm.com
Subject: [PATCH v1 0/2] KVM: s390: Fix two bugs
Date: Tue,  5 Aug 2025 13:14:44 +0200
Message-ID: <20250805111446.40937-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z+jsHGRA c=1 sm=1 tr=0 ts=6891e7ab cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=2OwXVqhp2XgA:10 a=cAp4uq1tgFU3EhW9v_kA:9
X-Proofpoint-ORIG-GUID: uKprDaspuqbUEpqlI9pgf57cHTv70E4A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDA3OSBTYWx0ZWRfX/TAibTS0P8g5
 TAo2Rx+f2Pd3pB1z2o8WkND9m3srVvSow9QjNWEWbkR91qiPcio7KnCNLEcpvv9mn5+F8kLeFmQ
 ca1T7Y8fEUPRK/xfPjni5Xzj/EL8Zgqq8YJvkAv77/FWwu4O+/1QEGTipFLzDCOJ5ZOMQZTgCmi
 CETn/3nHLHnRg1Oqr2aw/Dg57u03G17k+aGC8SolKN9k38uSrc+6cyYj+s3mw0UNk+8CQiFlfyi
 7Ybk4WDGLbktPyRHO0MMtxGhTBRuwbBUW0SrymLLMH3ymks/P0ZCQ1uhuBMVdvO310QO793XMJb
 vNRBCpMACjYykCc7WMNmHlmIJhFUInyDFjux8gXZMAvLwadmjyxy8bDmQ8+roCVs2cBQPchpicA
 jyueJGz4ZDG4SuSw78uiiE/gBVeMMgFtqhAREWOgJHDlTwn2R0QatdsQTrF/l8boIXF5X8Rp
X-Proofpoint-GUID: uKprDaspuqbUEpqlI9pgf57cHTv70E4A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 clxscore=1011 suspectscore=0
 priorityscore=1501 mlxlogscore=661 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508050079

This small series fixes two bugs in s390 KVM. One is small and trivial,
the other is pretty bad.

* The wrong type of flag was being passed to vcpu_dat_fault_handler();
  it expects a FOLL_* flag, but a FAULT_FLAG_* was passed instead.
* Due to incorrect usage of mmu_notifier_register(), in some rare cases
  when running a secure guest, the struct mm for the userspace process
  would get freed too early and cause a use-after-free.

Claudio Imbrenda (2):
  KVM: s390: Fix incorrect usage of mmu_notifier_register()
  KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion

 arch/s390/kvm/kvm-s390.c |  8 ++++----
 arch/s390/kvm/pv.c       | 14 +++++++++-----
 2 files changed, 13 insertions(+), 9 deletions(-)

-- 
2.50.1


