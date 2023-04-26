Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26CE6EF4B8
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 14:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240926AbjDZMws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 08:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240909AbjDZMwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 08:52:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FAB12C;
        Wed, 26 Apr 2023 05:52:37 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QCplHu010565;
        Wed, 26 Apr 2023 12:52:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=aBaOKGw0HjBph66n89NfwAHR4JK2mCtsZyChkn+bjtw=;
 b=YnmFoFDUANUVVEnpvPX8Td3zvFDY9YyFAKq13RFV5lqr0ZoYQ71KG5qPE47/AdvDfnS9
 JlR1QeoiEFV8emSEUi3ekNerYeXYQ4Z00GvbAMS5M6+g7iJ6/N1I0OQoV4JK8jt+HSv/
 hSkJe2aft/8o54TdvJjA0XqkQ4XFr3bOfKMX+tbDOY7KuiVZrKxGjAJuwuNvqhZqZCVC
 I7jGnmxLeDjUyZqSKZIZWkx3JMbzjY5QFpFoEWN2nceYpo3qsloWjZ+kLFVxNewYS7IN
 JU0S0QlQZ965wAr1TiYHEmKYvyjAYAIJ3lE9288imrLeK9d5k0LYGk+bmjlM+efx0Dgx CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q73xw0q98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 12:52:36 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33QCqaKo017215;
        Wed, 26 Apr 2023 12:52:36 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q73xw0q6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 12:52:36 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33QCT5RS022373;
        Wed, 26 Apr 2023 12:52:34 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3q47772bp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 12:52:33 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33QCqTep17367398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 12:52:30 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0927C20043;
        Wed, 26 Apr 2023 12:52:29 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75E8420040;
        Wed, 26 Apr 2023 12:52:28 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.39.26])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Apr 2023 12:52:28 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 0/3] KVM: s390: Changes for 6.4
Date:   Wed, 26 Apr 2023 14:51:16 +0200
Message-Id: <20230426125119.11472-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z3AIb96TYKpASMoSsq7NPHwbkXEMqX1_
X-Proofpoint-ORIG-GUID: 5UzWwH8YPLmPOcPvXoAMP-Ta-s1pGTy8
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_05,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=809 impostorscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304260112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

nothing major for today, two patches that continue our phys_to_virt()
conversion efforts and a patch that increases readability.

Please pull,
Janosch

The following changes since commit eeac8ede17557680855031c6f305ece2378af326:

  Linux 6.3-rc2 (2023-03-12 16:36:44 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.4-1

for you to fetch changes up to 8a46df7cd135fe576c18efa418cd1549e51f2732:

  KVM: s390: pci: fix virtual-physical confusion on module unload/load (2023-04-20 16:30:35 +0200)

----------------------------------------------------------------
Minor cleanup:
 - phys_to_virt conversion
 - Improvement of VSIE AP management

----------------------------------------------------------------
Nico Boehr (2):
      KVM: s390: interrupt: fix virtual-physical confusion for next alert GISA
      KVM: s390: pci: fix virtual-physical confusion on module unload/load

Pierre Morel (1):
      KVM: s390: vsie: clarifications on setting the APCB

 arch/s390/kvm/interrupt.c |  4 ++--
 arch/s390/kvm/pci.c       |  2 +-
 arch/s390/kvm/vsie.c      | 50 +++++++++++++++++++++++++++--------------------
 3 files changed, 32 insertions(+), 24 deletions(-)


Nico Boehr (2):
  KVM: s390: interrupt: fix virtual-physical confusion for next alert
    GISA
  KVM: s390: pci: fix virtual-physical confusion on module unload/load

Pierre Morel (1):
  KVM: s390: vsie: clarifications on setting the APCB

 arch/s390/kvm/interrupt.c |  4 ++--
 arch/s390/kvm/pci.c       |  2 +-
 arch/s390/kvm/vsie.c      | 50 +++++++++++++++++++++++----------------
 3 files changed, 32 insertions(+), 24 deletions(-)

-- 
2.40.0

