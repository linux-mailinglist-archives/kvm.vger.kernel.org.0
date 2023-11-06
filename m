Return-Path: <kvm+bounces-794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B05407E2A04
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 510B4B2100E
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D000029439;
	Mon,  6 Nov 2023 16:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iZVO59G0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2EB28E27
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 16:37:47 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F291310E2;
	Mon,  6 Nov 2023 08:37:44 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6GFNGI003933;
	Mon, 6 Nov 2023 16:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pnZ93IutOSnoJm/QaRLs9GD7tDqrUxVoJK6AhlMd9FM=;
 b=iZVO59G081gwBlOdWENvnysH5tuC3rpxgKnpLEVisDSoY5qLf8j6lZlv66g2VNr+pt4k
 ljXgEe08rmCPtEl8FarJdgUfoDDjDIguTDIk24fhNbxgDWg86BUQGR9/dG3jTtW8mz0Q
 68cJRpNXeRcbJrCrWy57/XrwiK5QSY+I72qVN/13CWLdWKqzM8QZQvWnVP21LkpufXwO
 QpYpnqtHPvd3ofndmED6/HDcHsJZfagigpkOXKAnKDJheaGUMPKoWcpeJEixjfFp451R
 4ODSWvs/7eRYLCNzc/t7+ivXE6pgsHGr4Loz6bcjypGNKlA3nrpx1WcZEkI6ZrhB9HDi jg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u73gn0n77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:37:43 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6GGFvE006558;
	Mon, 6 Nov 2023 16:37:43 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u73gn0n6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:37:43 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Eo2ZE028276;
	Mon, 6 Nov 2023 16:37:42 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u62gjt90v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:37:42 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6Gbeof4391442
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 16:37:40 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6F3B20043;
	Mon,  6 Nov 2023 16:37:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACAE62004B;
	Mon,  6 Nov 2023 16:37:39 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 16:37:39 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        hca@linux.ibm.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 4/8] s390x: lib: don't forward PSW when handling exception in SIE
Date: Mon,  6 Nov 2023 17:37:26 +0100
Message-ID: <20231106163738.1116942-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106163738.1116942-1-nrb@linux.ibm.com>
References: <20231106163738.1116942-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9P7QfSgThZoWmPONAA2PRW_fo_5qODiU
X-Proofpoint-GUID: 5Sv6uXPrWnyOYFVCQiqGojSIHdBxXK82
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060134

When we're handling a pgm int in SIE, we want to return to the SIE
cleanup after handling the exception. That's why we set pgm_old_psw to
the sie_exit label in fixup_pgm_int.

On nullifing pgm ints, fixup_pgm_int will also forward the old PSW such
that we don't cause an pgm int again.

However, when we want to return to the sie_exit label, this is not
needed (since we've manually set pgm_old_psw). Instead, forwarding the
PSW might cause us to skip an instruction or end up in the middle of an
instruction.

So, let's just skip the rest of the fixup in case we're inside SIE.

Note that we're intentionally not fixing up the PSW in the guest; that's
best left to the test at hand by registering their own psw fixup.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/interrupt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index e990c1863630..f7843a8f01c6 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -145,6 +145,7 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
 	if (lowcore.pgm_old_psw.addr >= (uint64_t)&sie_entry &&
 	    lowcore.pgm_old_psw.addr <= (uint64_t)&sie_exit) {
 		lowcore.pgm_old_psw.addr = (uint64_t)&sie_exit;
+		return;
 	}
 
 	switch (lowcore.pgm_int_code) {
-- 
2.41.0


