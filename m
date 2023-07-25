Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6F4761BEC
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 16:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbjGYOjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 10:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbjGYOjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 10:39:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E67A91;
        Tue, 25 Jul 2023 07:39:09 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PEVvpr016619;
        Tue, 25 Jul 2023 14:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2Re98pdwHAvk2ygGGFDbyNaVEfEjPSHdwg14r2KMpcg=;
 b=PZTnXdMOAcxcYCQoTm25tAdovUM3/4Pra67rprpUDBbcIcH4Gx6UerPkuD97cwkM3htv
 Mvh6oVmGwdTJ27eKDnWTCFRu9/gOKv45LvZj3VWG8/7SAz3CagYO8ML1stqK+77zib2b
 +m+PlPrbjlg7HdKfNwnN2zRKwv3xofbMAIuzfpiUAz8HEUQCwmvlyRSDMpR7Zc5qIFly
 0wbxX/3v0BALiE0QCDaeb4NweSgp0MkhVpp+BFF8/QOaU1JScgcmi/LaCyZzBMvsxaIF
 uYzf/ktsHBlUvlnArOhibGbn8BJxNOseehnwrh2ewSSzG9h41yiJqtP53MLKsMNhnZLL CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2g7wrjsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 14:39:08 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36PEW6KG018301;
        Tue, 25 Jul 2023 14:39:07 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2g7wrjmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 14:39:06 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36PEKVCQ002278;
        Tue, 25 Jul 2023 14:39:04 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0unjcb5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 14:39:03 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36PEd1GG21693124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 14:39:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B5102004E;
        Tue, 25 Jul 2023 14:39:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAF7E2004D;
        Tue, 25 Jul 2023 14:39:00 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.155.200.166])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jul 2023 14:39:00 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v4 2/6] KVM: s390: interrupt: Fix single-stepping into program interrupt handlers
Date:   Tue, 25 Jul 2023 16:37:17 +0200
Message-ID: <20230725143857.228626-3-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725143857.228626-1-iii@linux.ibm.com>
References: <20230725143857.228626-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S3BdpMdgfSn2x33RvfGxDJ60QjHGSACu
X-Proofpoint-GUID: 0IsjG6cl3HwPnnuX_nOjxBkSV13y0aoq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_08,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 suspectscore=0 impostorscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, after single-stepping an instruction that generates a
specification exception, GDB ends up on the instruction immediately
following it.

The reason is that vcpu_post_run() injects the interrupt and sets
KVM_GUESTDBG_EXIT_PENDING, causing a KVM_SINGLESTEP exit. The
interrupt is not delivered, however, therefore userspace sees the
address of the next instruction.

Fix by letting the __vcpu_run() loop go into the next iteration,
where vcpu_pre_run() delivers the interrupt and sets
KVM_GUESTDBG_EXIT_PENDING.

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 arch/s390/kvm/intercept.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 954d39adf85c..e54496740859 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -228,6 +228,21 @@ static int handle_itdb(struct kvm_vcpu *vcpu)
 
 #define per_event(vcpu) (vcpu->arch.sie_block->iprcc & PGM_PER)
 
+static bool should_handle_per_event(const struct kvm_vcpu *vcpu)
+{
+	if (!guestdbg_enabled(vcpu) || !per_event(vcpu))
+		return false;
+	if (guestdbg_sstep_enabled(vcpu) &&
+	    vcpu->arch.sie_block->iprcc != PGM_PER) {
+		/*
+		 * __vcpu_run() will exit after delivering the concurrently
+		 * indicated condition.
+		 */
+		return false;
+	}
+	return true;
+}
+
 static int handle_prog(struct kvm_vcpu *vcpu)
 {
 	psw_t psw;
@@ -242,7 +257,7 @@ static int handle_prog(struct kvm_vcpu *vcpu)
 	if (kvm_s390_pv_cpu_is_protected(vcpu))
 		return -EOPNOTSUPP;
 
-	if (guestdbg_enabled(vcpu) && per_event(vcpu)) {
+	if (should_handle_per_event(vcpu)) {
 		rc = kvm_s390_handle_per_event(vcpu);
 		if (rc)
 			return rc;
-- 
2.41.0

