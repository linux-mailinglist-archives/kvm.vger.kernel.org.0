Return-Path: <kvm+bounces-41752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C1D2A6C9DE
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 12:12:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 969434630A0
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 11:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554891F9F7A;
	Sat, 22 Mar 2025 11:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iM0mSXST"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4151E835C;
	Sat, 22 Mar 2025 11:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742641945; cv=none; b=Ldk6n8rdrgc3EaqmO4hzUVC7368zNBhFoJ4jm36uru0EDyDz+xUQeZXXu0dT0MXyBZJ0VLuKb5zZ1Z8gIbOxUe6gyjA+gVzE2BUxSsLQ4CQBYSOQatoNjWdQE6XDawmjbbivC4I8m9vq/giAxuH+cgMj3JswRXZLHcy56vo6n6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742641945; c=relaxed/simple;
	bh=8bbqt/Vg6mzgohe+8lmIC6psWOGpaMNUF59t9hY9KZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pr0implgyOgorYUkdZE2TMUFfT0W0vOm/cWW1M8McV41E3Faqcuy1pxY8CmbV1DA7yH0ZDOmO5VW6HDc7xCQMJUsOQlOBmFGTdDExdWD2B+PRqGzKRvPKSZYIW+RHA84e8LQh1BHPKqNgymttJesMfgLgJ42fDgcocqC5y1v8PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iM0mSXST; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52MAUY7Q000993;
	Sat, 22 Mar 2025 11:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=6WQwAW
	6D6SOsowQaM6MVk85EQ4UmJRZEgAH6C1kxetE=; b=iM0mSXSTyxeRLxW2OApyeJ
	CnNFSn31SIx9jyeiWk6UsxGUWVe1/ft/NiMdOznYra8oyKOJCG9MvF+eMMkpNIKP
	+FHTScSe2wTGOm3M20bhuAtF/iNpe1h/LHKw//uTjhcCBFQenuN2BjuKSrfUldoP
	hdrtX43qFDN6ZHQJBWcPRMs6i9oM/BsIhub4zrMkZUQPM+jdByBo5g4Ywj6hzoI6
	cYPdDm5mQbFVD0CTHSX+NkilLjOX/2T4Nd0IiEUw7bzb3bsFxastyQu+RzYhqlk3
	+mK+q6hT4k6dtjuuxw+ZxiJbV8G3kiD/bCWxfB5sdV2aUcbC6GsCiwwzKMkfEexw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45hnfsh3q2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 22 Mar 2025 11:12:11 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52M8kPZ4008303;
	Sat, 22 Mar 2025 11:12:10 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45hn89h8ds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 22 Mar 2025 11:12:10 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52MBC63L60227956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 22 Mar 2025 11:12:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 95B6C20043;
	Sat, 22 Mar 2025 11:12:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0393320040;
	Sat, 22 Mar 2025 11:12:06 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.47.152])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 22 Mar 2025 11:12:05 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Michael Mueller <mimu@linux.ibm.com>
Subject: [GIT PULL 1/2] KVM: s390: Don't use %pK through tracepoints
Date: Sat, 22 Mar 2025 12:06:44 +0100
Message-ID: <20250322111119.24548-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250322111119.24548-1-frankja@linux.ibm.com>
References: <20250322111119.24548-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mDdDXYITwP4oq3fj01EPFmi9smPi7oBz
X-Proofpoint-ORIG-GUID: mDdDXYITwP4oq3fj01EPFmi9smPi7oBz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-22_04,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 spamscore=0 clxscore=1015 mlxscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=634 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503220080

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

Restricted pointers ("%pK") are not meant to be used through TP_format().
It can unintentionally expose security sensitive, raw pointer values.

Use regular pointer formatting instead.

Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Link: https://lore.kernel.org/r/20250217-restricted-pointers-s390-v1-1-0e4ace75d8aa@linutronix.de
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20250217-restricted-pointers-s390-v1-1-0e4ace75d8aa@linutronix.de>
---
 arch/s390/kvm/trace-s390.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/trace-s390.h b/arch/s390/kvm/trace-s390.h
index 9ac92dbf680d..9e28f165c114 100644
--- a/arch/s390/kvm/trace-s390.h
+++ b/arch/s390/kvm/trace-s390.h
@@ -56,7 +56,7 @@ TRACE_EVENT(kvm_s390_create_vcpu,
 		    __entry->sie_block = sie_block;
 		    ),
 
-	    TP_printk("create cpu %d at 0x%pK, sie block at 0x%pK",
+	    TP_printk("create cpu %d at 0x%p, sie block at 0x%p",
 		      __entry->id, __entry->vcpu, __entry->sie_block)
 	);
 
@@ -255,7 +255,7 @@ TRACE_EVENT(kvm_s390_enable_css,
 		    __entry->kvm = kvm;
 		    ),
 
-	    TP_printk("enabling channel I/O support (kvm @ %pK)\n",
+	    TP_printk("enabling channel I/O support (kvm @ %p)\n",
 		      __entry->kvm)
 	);
 
-- 
2.49.0


