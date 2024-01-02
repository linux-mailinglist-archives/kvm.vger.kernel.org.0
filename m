Return-Path: <kvm+bounces-5417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E90821CE5
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 14:41:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D6731F21165
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 13:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91BE715491;
	Tue,  2 Jan 2024 13:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fOzc5P4R"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D5D15499;
	Tue,  2 Jan 2024 13:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 402CRO3n007372;
	Tue, 2 Jan 2024 13:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=XI5aMYO6zl7/z3swPMcpOerf4v53mYriiEhz308dBJQ=;
 b=fOzc5P4RkMGnsyWStNWrl8zYhZSXmzblFO1T6aX+5IvZUU1X7VU25mSMFTnYEWRycCPU
 Ua8xxB30nbXLYMcSErjclULMjNgZtYWCgG9z2F4Z5IbyBJc2NNlehOmpj2ZlGXqgF27S
 zF0qkpl25DT3K33qQdklaaBVLdiEbL4X0unqBVKYHuuBEuuxo/Xp397tZSeuHjz0KHFq
 +LQ92koYUdq/QnLMYFHuAVlYCJPnLJx5yv0YxeIkk9TZvQ1wbv0ibQ7+HFs7X0wGqrG3
 5hPqC6ljoPieWdBd1g9ZkpF5P9Sp9L/IwbF33Uhdv4mAaYB26cl8qewhHnfto82h1EM3 Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vcjghh9pj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jan 2024 13:37:40 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 402DKjka031073;
	Tue, 2 Jan 2024 13:37:39 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vcjghh9nw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jan 2024 13:37:39 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 402AEI5h017830;
	Tue, 2 Jan 2024 13:37:38 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vawwyn434-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jan 2024 13:37:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 402DbZY344695990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jan 2024 13:37:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3FD7B20043;
	Tue,  2 Jan 2024 13:37:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9A3920040;
	Tue,  2 Jan 2024 13:37:34 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.18.26])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  2 Jan 2024 13:37:34 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com
Subject: [GIT PULL 1/4] s390/uvdevice: Report additional-data length for attestation
Date: Tue,  2 Jan 2024 14:34:52 +0100
Message-ID: <20240102133629.108405-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240102133629.108405-1-frankja@linux.ibm.com>
References: <20240102133629.108405-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bNxa10r1ubsZ3j-nfnsoBUyNo5p4AiH4
X-Proofpoint-ORIG-GUID: _wHjB0hbzCDfKiFFTdbiP0PJhGdxlPWq
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-02_04,2024-01-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 clxscore=1015 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401020104

From: Steffen Eiden <seiden@linux.ibm.com>

Additional data length in the attestation request is an in/out variable.
Software provides the capacity of the buffer. Upon successful request,
firmware reports the actual bytes written to the additional data in that
field. This information is lost, as the length field was not copied back
to userspace before. Attestation might fail, if user space did not
specify the exact amount of needed bytes required, as this length is
part of the attestation measurement.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20231106124922.3032370-1-seiden@linux.ibm.com
Message-Id: <20231106124922.3032370-1-seiden@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 drivers/s390/char/uvdevice.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
index 144cd2e03590..42c9f77f8da0 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -109,6 +109,7 @@ static int uvio_copy_attest_result_to_user(struct uv_cb_attest *uvcb_attest,
 					   struct uvio_attest *uvio_attest)
 {
 	struct uvio_attest __user *user_uvio_attest = (void __user *)uv_ioctl->argument_addr;
+	u32 __user *user_buf_add_len = (u32 __user *)&user_uvio_attest->add_data_len;
 	void __user *user_buf_add = (void __user *)uvio_attest->add_data_addr;
 	void __user *user_buf_meas = (void __user *)uvio_attest->meas_addr;
 	void __user *user_buf_uid = &user_uvio_attest->config_uid;
@@ -117,6 +118,8 @@ static int uvio_copy_attest_result_to_user(struct uv_cb_attest *uvcb_attest,
 		return -EFAULT;
 	if (add_data && copy_to_user(user_buf_add, add_data, uvio_attest->add_data_len))
 		return -EFAULT;
+	if (put_user(uvio_attest->add_data_len, user_buf_add_len))
+		return -EFAULT;
 	if (copy_to_user(user_buf_uid, uvcb_attest->config_uid, sizeof(uvcb_attest->config_uid)))
 		return -EFAULT;
 	return 0;
-- 
2.43.0


