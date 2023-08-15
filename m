Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4A277D220
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239261AbjHOSn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239228AbjHOSnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:43:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59ADF1;
        Tue, 15 Aug 2023 11:43:40 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FIQxfh004987;
        Tue, 15 Aug 2023 18:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=gK7BHiXi2LZbiwCPhjZXgLpssrCU9wHNzfJtCALM1Jk=;
 b=W6fI6UGf9j5dtGU7nHI7bMU1Lzf99AWsZTFa6CoFQld2v60O2G+qD8ytOmRCiPVRPgNr
 E+1inf8oAeE4YHohEuYFh57Lqwqa02Vm70EGRquU3ZPqmRwS8NMj07RvTRKx8yAZDM5z
 krYuV7VbziojXpGAfWK+6EkAvVJh+fv5itq6Wg636TG+XC2rKuRcdy0r3uwqQ1c/K5Xc
 uYE2jSCNlCiJuNtK8iQWJOq08JHmQwWUhAu5norOPrL8O7WYK9mGueI/DyGK8fkP2tOw
 Za8kMTYNl0Ii9jwPdn6NAk0U3EaRn5eGmVvEm+Z/MGEu6dxxeneMjhCcjej0O+ByVwJG Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgenbrgjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:38 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FIXe36030817;
        Tue, 15 Aug 2023 18:43:37 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgenbrgj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:37 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FI85ob007832;
        Tue, 15 Aug 2023 18:43:36 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3senwk6vgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:36 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FIhZkc34407058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 18:43:35 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A80A558054;
        Tue, 15 Aug 2023 18:43:35 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 845305803F;
        Tue, 15 Aug 2023 18:43:34 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.75.177])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 18:43:34 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH 00/12] s390/vfio_ap: crypto pass-through for SE guests
Date:   Tue, 15 Aug 2023 14:43:21 -0400
Message-Id: <20230815184333.6554-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5YF3gWGIw4D5NjCTtFkHAGJP7XvEyoTF
X-Proofpoint-ORIG-GUID: XtQM0RIcEloMPx9iWxJFqH2gpUoD7ZRe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 clxscore=1011 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308150167
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is for the changes required in the vfio_ap device 
driver to facilitate pass-through of crypto devices to a secure 
execution guest. In particular, it is critical that no data from the
queues passed through to the SE guest is leaked when the guest is 
destroyed. There are also some new response codes returned from the
PQAP(ZAPQ) and PQAP(TAPQ) commands that have been added to the
architecture in support of pass-through of crypto devices to SE guests;
these need to be accounted for when handling the reset of queues.


Janosch Frank (1):
  s390/uv: export uv_pin_shared for direct usage

Tony Krowiak (11):
  s390/vfio-ap: No need to check the 'E' and 'I' bits in APQSW after
    TAPQ
  s390/vfio-ap: clean up irq resources if possible
  s390/vfio-ap: wait for response code 05 to clear on queue reset
  s390/vfio-ap: allow deconfigured queue to be passed through to a guest
  s390/vfio-ap: remove upper limit on wait for queue reset to complete
  s390/vfio-ap: store entire AP queue status word with the queue object
  s390/vfio-ap: use work struct to verify queue reset
  s390/vfio-ap: handle queue state change in progress on reset
  s390/vfio-ap: check for TAPQ response codes 0x35 and 0x36
  kvm: s390: export kvm_s390_pv*_is_protected functions
  s390/vfio-ap: Make sure nib is shared

 arch/s390/include/asm/kvm_host.h      |   3 +
 arch/s390/include/asm/uv.h            |   6 +
 arch/s390/kernel/uv.c                 |   3 +-
 arch/s390/kvm/kvm-s390.h              |  12 --
 arch/s390/kvm/pv.c                    |  14 +++
 drivers/s390/crypto/vfio_ap_ops.c     | 164 +++++++++++++++++---------
 drivers/s390/crypto/vfio_ap_private.h |   6 +-
 7 files changed, 135 insertions(+), 73 deletions(-)

-- 
2.39.3

