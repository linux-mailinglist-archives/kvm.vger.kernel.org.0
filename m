Return-Path: <kvm+bounces-7600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B5B84494A
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 21:59:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6979E1F22228
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 20:59:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D6E3987A;
	Wed, 31 Jan 2024 20:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EeV75Ta/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D334539AC9;
	Wed, 31 Jan 2024 20:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706734721; cv=none; b=FYG9+bEMcqAsR+RhYXREtrXmWc8jIR8NBwtlTEN2e1rF0e5PtjI2DqS6/Poq1Exugv50FnetY0bfbll4HXqcrWABdrj2bqRKtx+YkHApS1y8sERSn16iBEp+7GKie4E9jKFxLGw4hQg8s86rP21jKs8rTXUicMmYVsEescXtcSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706734721; c=relaxed/simple;
	bh=mfaNsFXsa7n/s6M+84Vkuh5YS7xBXGDLzp2NFXFpnuY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FGKyYNMktwzK63hToXTrDFSpQQc1+JQpYQRQSGkAWSYEvrbQE+RMsdtGuuQBibe1TrYDO0crIQPBTvBi0wmy+uY2N19Nkedpt+7wq4+dvtfK1ehGwf5X9Fj83zT5lBzYlqPuTsqwDjOQZxcobtwodepJd7gpUbQUEdOnrX4foCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EeV75Ta/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40VJ71aE005695;
	Wed, 31 Jan 2024 20:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=uROxfOlsG/i2BXh3gyI6uSEC+T5tvjgl2SPA6N+/7rI=;
 b=EeV75Ta/sSp9SbxCtsKvei90cbSvIgQMpJfwTS4E+SMa+GrLVva5T910djT52QVjCxzQ
 Y+vfaSBXU6xIelrWFEvd5vwqslmKXopGxKSlSXNCnLNmJFGIH7TXCmb7KET/kifWm48J
 a/dj99XasJ6xOq7wMD9eqN9i9PhM6Hc+TtvjRvgxIEeoKWMaDvFeCU2fnFHuWAHRQois
 mnOAF/s8fH4KCamDQ9gREbTHHqIT9s6lSvALVhoV+5tN8rsRVoosi7OLTyYcXDuygVX+
 zjRjySVgDMI3GEoRbnkAPJwVsiMQWFoBy/pNQ9Kf1cWuyUHsH4k3zNMjQKGTtlmxZMeM hw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyuk1kc7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 20:58:38 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40VKrHZc009421;
	Wed, 31 Jan 2024 20:58:38 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyuk1kc7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 20:58:38 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40VIt7uU010884;
	Wed, 31 Jan 2024 20:58:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vweckqg5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 20:58:37 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40VKwYda18547350
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 20:58:34 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4944C2004D;
	Wed, 31 Jan 2024 20:58:34 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36CDB20043;
	Wed, 31 Jan 2024 20:58:34 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 31 Jan 2024 20:58:34 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
	id E9132E0726; Wed, 31 Jan 2024 21:58:33 +0100 (CET)
From: Eric Farman <farman@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH] KVM: s390: remove extra copy of access registers into KVM_RUN
Date: Wed, 31 Jan 2024 21:58:32 +0100
Message-Id: <20240131205832.2179029-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kyn2aVVSi3oN5a46CheACpmm10ywtza8
X-Proofpoint-ORIG-GUID: PLa0Eia98uwQMQEXGvm1WhuxGI9CQt7z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_10,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=759 bulkscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401310162

The routine ar_translation() is called by get_vcpu_asce(), which is
called from a handful of places, such as an interception that is
being handled during KVM_RUN processing. In that case, the access
registers of the vcpu had been saved to a host_acrs struct and then
the guest access registers loaded from the KVM_RUN struct prior to
entering SIE. Saving them back to KVM_RUN at this point doesn't do
any harm, since it will be done again at the end of the KVM_RUN
loop when the host access registers are restored.

But that's not the only path into this code. The MEM_OP ioctl can
be used while specifying an access register, and will arrive here.

Linux itself doesn't use the access registers for much, but it does
squirrel the thread local storage variable into ACRs 0 and 1 in
copy_thread() [1]. This means that the MEM_OP ioctl may copy
non-zero access registers (the upper- and lower-halves of the TLS
pointer) to the KVM_RUN struct, which will end up getting propogated
to the guest once KVM_RUN ioctls occur. Since these are almost
certainly invalid as far as an ALET goes, an ALET Specification
Exception would be triggered if it were attempted to be used.

[1] arch/s390/kernel/process.c:169

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---

Notes:
    I've gone back and forth about whether the correct fix is
    to simply remove the save_access_regs() call and inspect
    the contents from the most recent KVM_RUN directly, versus
    storing the contents locally. Both work for me but I've
    opted for the latter, as it continues to behave the same
    as it does today but without the implicit use of the
    KVM_RUN space. As it is, this is (was) the only reference
    to vcpu->run in this file, which stands out since the
    routines are used by other callers.
    
    Curious about others' thoughts.

 arch/s390/kvm/gaccess.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 5bfcc50c1a68..9205496195a4 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -380,6 +380,7 @@ void ipte_unlock(struct kvm *kvm)
 static int ar_translation(struct kvm_vcpu *vcpu, union asce *asce, u8 ar,
 			  enum gacc_mode mode)
 {
+	int acrs[NUM_ACRS];
 	union alet alet;
 	struct ale ale;
 	struct aste aste;
@@ -391,8 +392,8 @@ static int ar_translation(struct kvm_vcpu *vcpu, union asce *asce, u8 ar,
 	if (ar >= NUM_ACRS)
 		return -EINVAL;
 
-	save_access_regs(vcpu->run->s.regs.acrs);
-	alet.val = vcpu->run->s.regs.acrs[ar];
+	save_access_regs(acrs);
+	alet.val = acrs[ar];
 
 	if (ar == 0 || alet.val == 0) {
 		asce->val = vcpu->arch.sie_block->gcr[1];
-- 
2.40.1


