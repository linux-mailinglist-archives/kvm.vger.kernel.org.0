Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14ED35A0F8F
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 13:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241171AbiHYLuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 07:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241164AbiHYLuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 07:50:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59D94BD33
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 04:50:22 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PBftTA020152
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:50:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=wK7IB1VNlo00HGvgAN/kM7EAuHoumrbVlBZBH8YX6ZQ=;
 b=A8PtV4lGuixJiyjJo4j9n+vss+SzIasxwMVJf1SuXSaBQ7WAhyezVIDB7+Ryy/0i4Nii
 MD0W3yTGgHQpcruUiU6uqiM4kQ6DGl2n1nuzOvV/gtnsIZd9XfW2YiyrmHp1Xo2zjZhx
 8orlZ0HNF/zUGwztZNHr851moq5t7u+o+2vtAEa3kirvRcAtAOSsaawk9HbadAI1vPgW
 xPykDSuQJeS1b0bv2pLrv0I65ZgeylAAo0RfUJ1MfumahN2HAlCK3FoclxrluMHgPCBR
 Y8h2EBOmYMkh8rZWzcm51APHepQvVZZE37/4w03zTwACu6KbKCiimBfGKrnxkj21BqIL Bw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j68e9r73a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:50:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27PBZQWK015756
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:50:20 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3j2pvj6cjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:50:20 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27PBoGSn38994216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 11:50:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 505C211C04A;
        Thu, 25 Aug 2022 11:50:16 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1336A11C04C;
        Thu, 25 Aug 2022 11:50:16 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Aug 2022 11:50:16 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [RFC PATCH v1 0/1] KVM: s390: pv: fix clock comparator late after suspend/resume
Date:   Thu, 25 Aug 2022 13:50:14 +0200
Message-Id: <20220825115015.45545-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: N9pT7iIcavLtvTzaY0IAj2d88s2zBmoL
X-Proofpoint-ORIG-GUID: N9pT7iIcavLtvTzaY0IAj2d88s2zBmoL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=653 adultscore=0
 mlxscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After a PV guest in QEMU has been paused and resumed, clock comparator
interrupts are delivered to the guest much too late.

This is caused by QEMU's tod-kvm device restoring the guest's TOD clock
upon guest resume. This is not possible with PV, since the guest's TOD
clock is controlled by the ultravisor.

Even if not allowed under PV, KVM allowed the respective call from
userspace (VM attribute KVM_S390_VM_TOD) and updated its internal data
structures on this call. This can make the ultravisor's and KVM's view
of the guest TOD clock inconsistent. This in turn can lead to the late
delivery of clock comparator interrupts when KVM calculates when to wake
the guest.

This fixes the kernel portion of the problem by disallowing the vm attr
call for the guest TOD clock so userspace cannot mess up KVM's view of
the guest TOD. This fix causes an ugly warning in QEMU though, hence
another fix is due for QEMU to simply not even attempt to set the guest
TOD on resume.

Nico Boehr (1):
  KVM: s390: pv: don't allow userspace to set the clock under PV

 arch/s390/kvm/kvm-s390.c | 9 +++++++++
 1 file changed, 9 insertions(+)

-- 
2.36.1

