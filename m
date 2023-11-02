Return-Path: <kvm+bounces-400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 486F77DF692
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 16:36:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6596F1C20EF8
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 15:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E121CF9C;
	Thu,  2 Nov 2023 15:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Vpi/wzOF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7031CF90
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 15:35:57 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FD4137
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 08:35:55 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A2FS2FV026921
	for <kvm@vger.kernel.org>; Thu, 2 Nov 2023 15:35:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=wF5NfqQ4bffah4Wkydft3VIxLoSxH5iyzbcDsHM8748=;
 b=Vpi/wzOFnsjKp7DhidVcdUyhqPndA5dORYtPj0wYgu2DyV57jIuXi3lwXo60qTRpD2m4
 X8EWUFUbeptoA0i7LeJNAaYjXbTsr8HeSvnFxeco3FMBto/XMctXFRTrGkvnxF2QBWGd
 jqaY8j6OMKXIy20X1fpwD8iI503jr+dADketBN4MVKVpeQnL1cc3IDXLqT8F5P2Tt11z
 Dr+J1Xa6qY9zY/gabHn3a8B81H2yg1qZrOXxfKNoxw7/TpHSQIx+ZePlXZU6PDLpLNNl
 A5jywWBRGYzTxqgruj2gDP24ZQ/HtoSYJ9w20bDZmyUDi6pC2HmeDoK7DHfOZXCyQmK0 nw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4ee9gcq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 15:35:54 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A2FSba4028761
	for <kvm@vger.kernel.org>; Thu, 2 Nov 2023 15:35:54 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4ee9gcpv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Nov 2023 15:35:54 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A2DuEJf011310;
	Thu, 2 Nov 2023 15:35:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1eukf6b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Nov 2023 15:35:53 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A2FZomd6685372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Nov 2023 15:35:50 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1250A20043;
	Thu,  2 Nov 2023 15:35:50 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DEC9020040;
	Thu,  2 Nov 2023 15:35:49 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Nov 2023 15:35:49 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: nrb@linux.ibm.com, nsg@linux.ibm.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com
Subject: [PATCH v2 1/1] KVM: s390: vsie: fix wrong VIR 37 when MSO is used
Date: Thu,  2 Nov 2023 16:35:49 +0100
Message-ID: <20231102153549.53984-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d805AncK8TAn_IRkf1ifL2rGuO6NZygG
X-Proofpoint-ORIG-GUID: jQb_EDantOZXAGM2hdJvLya3TbE00Bsi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-02_04,2023-11-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxlogscore=825 impostorscore=0 mlxscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311020125

When the host invalidates a guest page, it will also check if the page
was used to map the prefix of any guest CPUs, in which case they are
stopped and marked as needing a prefix refresh. Upon starting the
affected CPUs again, their prefix pages are explicitly faulted in and
revalidated if they had been invalidated. A bit in the PGSTEs indicates
whether or not a page might contain a prefix. The bit is allowed to
overindicate. Pages above 2G are skipped, because they cannot be
prefixes, since KVM runs all guests with MSO = 0.

The same applies for nested guests (VSIE). When the host invalidates a
guest page that maps the prefix of the nested guest, it has to stop the
affected nested guest CPUs and mark them as needing a prefix refresh.
The same PGSTE bit used for the guest prefix is also used for the
nested guest. Pages above 2G are skipped like for normal guests, which
is the source of the bug.

The nested guest runs is the guest primary address space. The guest
could be running the nested guest using MSO != 0. If the MSO + prefix
for the nested guest is above 2G, the check for nested prefix will skip
it. This will cause the invalidation notifier to not stop the CPUs of
the nested guest and not mark them as needing refresh. When the nested
guest is run again, its prefix will not be refreshed, since it has not
been marked for refresh. This will cause a fatal validity intercept
with VIR code 37.

Fix this by removing the check for 2G for nested guests. Now all
invalidations of pages with the notify bit set will always scan the
existing VSIE shadow state descriptors.

This allows to catch invalidations of nested guest prefix mappings even
when the prefix is above 2G in the guest virtual address space.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 61499293c2ac..e55f489e1fb7 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -587,10 +587,6 @@ void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
 
 	if (!gmap_is_shadow(gmap))
 		return;
-	if (start >= 1UL << 31)
-		/* We are only interested in prefix pages */
-		return;
-
 	/*
 	 * Only new shadow blocks are added to the list during runtime,
 	 * therefore we can safely reference them all the time.
-- 
2.41.0


