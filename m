Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE136757D51
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 15:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjGRNXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 09:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjGRNXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 09:23:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6952A3
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 06:23:07 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36IDBR77006965
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 13:23:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=DNlui8jtDrLKgQaTpSeid7AK5hxfSWmp7wDbD8c+QaI=;
 b=Nsm6AFTmF11bf5swc7tZx+cp749XaZ1LPsOWDMOzhMBudJEAdrhKPp464MfIs8Nee/6R
 TnGeablMVrxNold6wrsoGcB0fyNqe4md0oqiWexLLbuj/NPozcR1UYUFY1uCKwxdmVcw
 bYwNCUaE/lSknBBjrGEyFuhzpijyRh6hEJabsOgCXdsZrpQkN+Vq0EqSqFcvImrZVe/2
 VqT1MonONFho625idgA9NNDF5BCRCXprS36jwUIeBsiMlzt7MR/A+rrhjtluxSRqH51v
 j2HMtyn41djrvvPxzdbgnfk9HKOhGCunqGg7f18bYgt9msz9cyuyVs+Yws88hU1XJfmI Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwu0s912m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 13:23:06 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36IDCJR7011068
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 13:23:06 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwu0s9122-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 13:23:06 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36I6xs3r029098;
        Tue, 18 Jul 2023 13:23:05 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3rv6smd2s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 13:23:05 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36IDN1Je19923488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 13:23:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E66920043;
        Tue, 18 Jul 2023 13:23:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F3BA20040;
        Tue, 18 Jul 2023 13:23:01 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jul 2023 13:23:01 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com
Subject: [GIT PULL 0/2] KVM: s390: pv: Two small fixes for 6.5
Date:   Tue, 18 Jul 2023 15:22:58 +0200
Message-ID: <20230718132300.34947-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dPugcz6UfN47oqdV4XcnRanpEYB3vsB3
X-Proofpoint-ORIG-GUID: GDITzuyh0prf5qcsxOG8Nj9wxJmgfGuK
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_09,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=705 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2307180119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

just two small bugfixes for asynchronous destroy.


please pull, thanks!

Claudio


The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b574c:

  Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.5-1

for you to fetch changes up to c2fceb59bbda16468bda82b002383bff59de89ab:

  KVM: s390: pv: fix index value of replaced ASCE (2023-07-18 11:21:51 +0200)

----------------------------------------------------------------
Two fixes for asynchronous destroy

----------------------------------------------------------------
Claudio Imbrenda (2):
      KVM: s390: pv: simplify shutdown and fix race
      KVM: s390: pv: fix index value of replaced ASCE

 arch/s390/kvm/pv.c  | 8 ++++++--
 arch/s390/mm/gmap.c | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.41.0

