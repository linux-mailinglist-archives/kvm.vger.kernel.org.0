Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C21569F860
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 16:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbjBVPzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 10:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbjBVPzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 10:55:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC26A3B668;
        Wed, 22 Feb 2023 07:55:11 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MEpDW3003746;
        Wed, 22 Feb 2023 15:55:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SDZ0tTOOiZmnYUA7SMVS58PKHgro0Pe6gZ+H0wAFOuI=;
 b=E9UtJadcB8gqQVYG+LtQUPWwjCXOcwou6sFtgSpwQJdM/mOQVxQz4Xt01xQofe9OOjLF
 bYyml3xlUXzGZeMjKZM+ZRGUyk3OlHsgE+exyrjsNO/qXhU4L2/GMK5LD1BtQx+nlfzZ
 RE8kdUnTlUfrzZqqisqSPeEinO8zNnH2Mo8iKaCk48hwceYTzt6aRI2x3gOmBkM2MmfV
 QqRo3ZYxtON+++1h0afPmkeyBPMzfmogenRCTwxN2wBOcPhVOE1682sz3BfQfMmntSwi
 QX4vf3K1FRYmyGNsGhSZVIVD4ZXebLCPu/aadH9eYXdMq6m075uzYkEDCxgUlwjCRp3t cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwn671qsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 15:55:11 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31MEs1Ui014190;
        Wed, 22 Feb 2023 15:55:10 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwn671qra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 15:55:10 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31M9t44S031888;
        Wed, 22 Feb 2023 15:55:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3ntpa6c7nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 15:55:08 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31MFt5Ro42729972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 15:55:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFB4A20040;
        Wed, 22 Feb 2023 15:55:04 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97D972004D;
        Wed, 22 Feb 2023 15:55:04 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Feb 2023 15:55:04 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, mjrosato@linux.ibm.com,
        farman@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 0/1] KVM: s390: pci: fix virtual-physical confusion on module unload/load
Date:   Wed, 22 Feb 2023 16:55:03 +0100
Message-Id: <20230222155503.43399-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230222155503.43399-1-nrb@linux.ibm.com>
References: <20230222155503.43399-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8Plfllpwr4AVZhRvCXt-B4vD-QQVkZaB
X-Proofpoint-ORIG-GUID: chGNfh5xraoqOFJb25gsZhzsa6AQszgL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_05,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 adultscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220135
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the kvm module is unloaded, zpci_setup_aipb() perists some data in the
zpci_aipb structure in s390 pci code. Note that this struct is also passed
to firmware in the zpci_set_irq_ctrl() call and thus the GAIT must be a
physical address.

On module re-insertion, the GAIT is restored from this structure in
zpci_reset_aipb(). But it is a physical address, hence this may cause
issues when the kvm module is unloaded and loaded again.

Fix virtual vs physical address confusion (which currently are the same) by
adding the necessary physical-to-virtual-conversion in zpci_reset_aipb().

Nico Boehr (1):
  KVM: s390: pci: fix virtual-physical confusion on module unload/load

 arch/s390/kvm/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.39.1

