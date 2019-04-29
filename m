Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32CBDEB9
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 11:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfD2JKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 05:10:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727723AbfD2JKN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Apr 2019 05:10:13 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3T99uw4043161
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:12 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s5wg0j84a-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:12 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 29 Apr 2019 10:10:10 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 29 Apr 2019 10:10:07 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3T9A5JR50790448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 09:10:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A18E711C050;
        Mon, 29 Apr 2019 09:10:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9153111C054;
        Mon, 29 Apr 2019 09:10:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 29 Apr 2019 09:10:05 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 501EF20F5D4; Mon, 29 Apr 2019 11:10:05 +0200 (CEST)
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
Subject: [GIT PULL 08/12] KVM: s390: enable MSA9 keywrapping functions depending on cpu model
Date:   Mon, 29 Apr 2019 11:09:58 +0200
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190429091002.71164-1-borntraeger@de.ibm.com>
References: <20190429091002.71164-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042909-4275-0000-0000-0000032F7819
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042909-4276-0000-0000-0000383ECCC0
Message-Id: <20190429091002.71164-9-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-29_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904290067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of adding a new machine option to disable/enable the keywrapping
options of pckmo (like for AES and DEA) we can now use the CPU model to
decide. As ECC is also wrapped with the AES key we need that to be
enabled.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/kvm-s390.c         | 27 ++++++++++++++++++++++++++-
 arch/s390/kvm/vsie.c             |  5 ++++-
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index c47e22bba87f..e224246ff93c 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -278,6 +278,7 @@ struct kvm_s390_sie_block {
 #define ECD_HOSTREGMGMT	0x20000000
 #define ECD_MEF		0x08000000
 #define ECD_ETOKENF	0x02000000
+#define ECD_ECC		0x00200000
 	__u32	ecd;			/* 0x01c8 */
 	__u8	reserved1cc[18];	/* 0x01cc */
 	__u64	pp;			/* 0x01de */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 38ca8324a91a..eb68ada1334b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2890,6 +2890,25 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	vcpu->arch.enabled_gmap = vcpu->arch.gmap;
 }
 
+static bool kvm_has_pckmo_subfunc(struct kvm *kvm, unsigned long nr)
+{
+	if (test_bit_inv(nr, (unsigned long *)&kvm->arch.model.subfuncs.pckmo) &&
+	    test_bit_inv(nr, (unsigned long *)&kvm_s390_available_subfunc.pckmo))
+		return true;
+	return false;
+}
+
+static bool kvm_has_pckmo_ecc(struct kvm *kvm)
+{
+	/* At least one ECC subfunction must be present */
+	return kvm_has_pckmo_subfunc(kvm, 32) ||
+	       kvm_has_pckmo_subfunc(kvm, 33) ||
+	       kvm_has_pckmo_subfunc(kvm, 34) ||
+	       kvm_has_pckmo_subfunc(kvm, 40) ||
+	       kvm_has_pckmo_subfunc(kvm, 41);
+
+}
+
 static void kvm_s390_vcpu_crypto_setup(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -2902,13 +2921,19 @@ static void kvm_s390_vcpu_crypto_setup(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->crycbd = vcpu->kvm->arch.crypto.crycbd;
 	vcpu->arch.sie_block->ecb3 &= ~(ECB3_AES | ECB3_DEA);
 	vcpu->arch.sie_block->eca &= ~ECA_APIE;
+	vcpu->arch.sie_block->ecd &= ~ECD_ECC;
 
 	if (vcpu->kvm->arch.crypto.apie)
 		vcpu->arch.sie_block->eca |= ECA_APIE;
 
 	/* Set up protected key support */
-	if (vcpu->kvm->arch.crypto.aes_kw)
+	if (vcpu->kvm->arch.crypto.aes_kw) {
 		vcpu->arch.sie_block->ecb3 |= ECB3_AES;
+		/* ecc is also wrapped with AES key */
+		if (kvm_has_pckmo_ecc(vcpu->kvm))
+			vcpu->arch.sie_block->ecd |= ECD_ECC;
+	}
+
 	if (vcpu->kvm->arch.crypto.dea_kw)
 		vcpu->arch.sie_block->ecb3 |= ECB3_DEA;
 }
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index d62fa148558b..c6983d962abf 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -288,6 +288,7 @@ static int shadow_crycb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	const u32 crycb_addr = crycbd_o & 0x7ffffff8U;
 	unsigned long *b1, *b2;
 	u8 ecb3_flags;
+	u32 ecd_flags;
 	int apie_h;
 	int key_msk = test_kvm_facility(vcpu->kvm, 76);
 	int fmt_o = crycbd_o & CRYCB_FORMAT_MASK;
@@ -320,7 +321,8 @@ static int shadow_crycb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	/* we may only allow it if enabled for guest 2 */
 	ecb3_flags = scb_o->ecb3 & vcpu->arch.sie_block->ecb3 &
 		     (ECB3_AES | ECB3_DEA);
-	if (!ecb3_flags)
+	ecd_flags = scb_o->ecd & vcpu->arch.sie_block->ecd & ECD_ECC;
+	if (!ecb3_flags && !ecd_flags)
 		goto end;
 
 	/* copy only the wrapping keys */
@@ -329,6 +331,7 @@ static int shadow_crycb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		return set_validity_icpt(scb_s, 0x0035U);
 
 	scb_s->ecb3 |= ecb3_flags;
+	scb_s->ecd |= ecd_flags;
 
 	/* xor both blocks in one run */
 	b1 = (unsigned long *) vsie_page->crycb.dea_wrapping_key_mask;
-- 
2.19.1

