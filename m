Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E177E6ED3CA
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 19:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjDXRml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 13:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbjDXRmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 13:42:40 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984399747;
        Mon, 24 Apr 2023 10:42:27 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33OHeu4t001948;
        Mon, 24 Apr 2023 17:42:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=608Q4a8pYVpGJLSjStSN9uk8sKhO8fmxYSAQ7Iq7Js8=;
 b=qsamZyAUBftqSJD4eyX2yUdZfFjfGr6GeAVNGQcFFYDnEm1Tnj67sEBLA9Ro/rz1Cmhc
 JDK7Mnxn2HJh3c8L5VA/npHcWwy4ZkdMZNBqQfDyaoKKA1xZcVpeK+hbad9pV1NfA4fp
 1vutsAYm8b93NOEtfL7WDvPMQtYsQVzjPOKSM7FjO+vKIyZX+HTo5G+XpgBSEk371VeH
 CridMIaTVHTbniNWNSD86DEwqimkKDfiUE5kCx1Gre0oCmfyEfr0zXwvq2QY/111yPAv
 ZCYsCQALnzoKHfEaz38uHeajB1Gttd5owbRRd1ClqEMXb9eLPLVLfzKr2VorFmpH5/XS qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q461cf4t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Apr 2023 17:42:26 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33OHf1Ne002025;
        Mon, 24 Apr 2023 17:42:26 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q461cf4rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Apr 2023 17:42:25 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33NMa6rC017233;
        Mon, 24 Apr 2023 17:42:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3q477718d1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Apr 2023 17:42:23 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33OHgK5h54722972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Apr 2023 17:42:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61EAA20040;
        Mon, 24 Apr 2023 17:42:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B08DE20043;
        Mon, 24 Apr 2023 17:42:19 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.94.57])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Apr 2023 17:42:19 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 0/1] Fixing infinite loop on SCLP READ SCP INFO error
Date:   Mon, 24 Apr 2023 19:42:17 +0200
Message-Id: <20230424174218.64145-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U-cuOuWJJy04bMfN_Hqp2j70tA9RW9Ws
X-Proofpoint-ORIG-GUID: thnka0WeNJSDUO1oBrbBwRy_7AYpF8KW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-24_11,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxlogscore=488 clxscore=1011 mlxscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304240158
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Aborting on SCLP READ SCP INFO error leads to a deadloop.

The loop is:
abort() -> exit() -> smp_teardown() -> smp_query_num_cpus() ->
sclp_get_cpu_num() -> assert() -> abort()

Since smp_setup() is done after sclp_read_info() inside setup() this
loop only happens when only the start processor is running.
Let sclp_get_cpu_num() return 1 in this case.

Fixes: 52076a63d569 ("s390x: Consolidate sclp read info")


Pierre Morel (1):
  s390x: sclp: consider monoprocessor on read_info error

 lib/s390x/sclp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.31.1

