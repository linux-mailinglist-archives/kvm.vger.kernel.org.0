Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1943DEC4
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 11:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbfD2JKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 05:10:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55746 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727650AbfD2JKX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Apr 2019 05:10:23 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3T9AISU131454
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:22 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s5vdq4t62-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:21 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 29 Apr 2019 10:10:13 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 29 Apr 2019 10:10:08 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3T9A7j753215272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 09:10:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F4BA52050;
        Mon, 29 Apr 2019 09:10:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 7C3575206D;
        Mon, 29 Apr 2019 09:10:06 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 3B12A20F606; Mon, 29 Apr 2019 11:10:06 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 11/12] KVM: s390: vsie: Do not shadow CRYCB when no AP and no keys
Date:   Mon, 29 Apr 2019 11:10:01 +0200
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190429091002.71164-1-borntraeger@de.ibm.com>
References: <20190429091002.71164-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042909-0020-0000-0000-000003376726
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042909-0021-0000-0000-00002189DF17
Message-Id: <20190429091002.71164-12-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-29_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=928 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904290067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

When the guest do not have AP instructions nor Key management
we should return without shadowing the CRYCB.

We did not check correctly in the past.

Fixes: b10bd9a256ae ("s390: vsie: Use effective CRYCBD.31 to check CRYCBD validity")
Fixes: 6ee74098201b ("KVM: s390: vsie: allow CRYCB FORMAT-0")

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Message-Id: <1556269010-22258-1-git-send-email-pmorel@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/vsie.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index c6983d962abf..ac411e9e2bd3 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -290,6 +290,7 @@ static int shadow_crycb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	u8 ecb3_flags;
 	u32 ecd_flags;
 	int apie_h;
+	int apie_s;
 	int key_msk = test_kvm_facility(vcpu->kvm, 76);
 	int fmt_o = crycbd_o & CRYCB_FORMAT_MASK;
 	int fmt_h = vcpu->arch.sie_block->crycbd & CRYCB_FORMAT_MASK;
@@ -298,7 +299,8 @@ static int shadow_crycb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	scb_s->crycbd = 0;
 
 	apie_h = vcpu->arch.sie_block->eca & ECA_APIE;
-	if (!apie_h && (!key_msk || fmt_o == CRYCB_FORMAT0))
+	apie_s = apie_h & scb_o->eca;
+	if (!apie_s && (!key_msk || (fmt_o == CRYCB_FORMAT0)))
 		return 0;
 
 	if (!crycb_addr)
@@ -309,7 +311,7 @@ static int shadow_crycb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		    ((crycb_addr + 128) & PAGE_MASK))
 			return set_validity_icpt(scb_s, 0x003CU);
 
-	if (apie_h && (scb_o->eca & ECA_APIE)) {
+	if (apie_s) {
 		ret = setup_apcb(vcpu, &vsie_page->crycb, crycb_addr,
 				 vcpu->kvm->arch.crypto.crycb,
 				 fmt_o, fmt_h);
-- 
2.19.1

