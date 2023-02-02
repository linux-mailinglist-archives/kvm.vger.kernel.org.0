Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00CE6878C8
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 10:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbjBBJ2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 04:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjBBJ22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 04:28:28 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E2A193EA;
        Thu,  2 Feb 2023 01:28:23 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3129CIgg034675;
        Thu, 2 Feb 2023 09:28:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=HcC6NV55pAZlkkrVemqNQ+dkb/uHR1KwZ0a47asRJeA=;
 b=CCcD8GvEnlFmWHKOEroZpVKgEAVDJMgJ5nydizhTGlKHvH9zo0o3Znfe3XK0rw5VoTXK
 zIuHcNYIs81W9a97CU3ejqhJy+aXzahOHbOO3ljnVEQvS46t/z463qRGrxMPnZXGNG8m
 QbMbYIY+wSyoTsjTnmWZ7IPUeQ0dGX+FCSFcyw5++SG/bHUy6Mdn/kSSybLbM9ZxRbxl
 oGj+uTOYQ/Qv7iwhrYdOiCirNVDHAbJLi48b0ERvFgc5FjMJUqA34va+8wc2P0CeCnk0
 GV9QE3jnJlgfZcvA/qS3w+Ilj5teVFojkJaROQbBEDa2v0nRxlr6Wp0jfkQ9xAhgLIe/ eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ng98ft0tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 09:28:22 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3129CevJ036126;
        Thu, 2 Feb 2023 09:28:21 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ng98ft0t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 09:28:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 311KIKNp014521;
        Thu, 2 Feb 2023 09:28:19 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ncvtydyep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 09:28:19 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3129SF2e24838474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Feb 2023 09:28:15 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9E592004B;
        Thu,  2 Feb 2023 09:28:15 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12E9D20043;
        Thu,  2 Feb 2023 09:28:15 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.28.52])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  2 Feb 2023 09:28:14 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH v6 0/2] S390x: CPU Topology Information
Date:   Thu,  2 Feb 2023 10:28:12 +0100
Message-Id: <20230202092814.151081-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R-_y8_qHynip0slDlQjQPOmdO_470vnG
X-Proofpoint-GUID: l9Ok0Ii60sZnCQTmq4_ZiGhBy9QEcj3I
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_15,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302020085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

new version of the kvm-unit-test s390x CPU topology series.

1. what is done
---------------

- First part is checking PTF errors, for KVM and LPAR

- Second part is checking PTF polarization change and STSI
  with the cpu topology including drawers and books.
  This tests are run for KVM only.

To run these tests under KVM successfully you need Linux 6.0
and the QEMU patches you find at:

https://lists.gnu.org/archive/html/qemu-devel/2023-02/msg00081.html

To start the test in KVM just do:

# ./run_tests.sh topology

or

# ./s390x-run s390x/topology.elf \
	-smp 5,drawers=3,books=3,sockets=4,cores=4,maxcpus=144 \
	-append '-drawers 3 -books 3 -sockets 4 -cores 4'

Of course the declaration of the number of socket and core must be
coherent in -smp and -append arguments.


To start the tests in LPAR you do not need any argument.


Regards,
Pierre

Pierre Morel (2):
  s390x: topology: Check the Perform Topology Function
  s390x: topology: Checking Configuration Topology Information

 lib/s390x/sclp.h    |   3 +-
 lib/s390x/stsi.h    |  44 +++++
 s390x/Makefile      |   1 +
 s390x/topology.c    | 399 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 5 files changed, 450 insertions(+), 1 deletion(-)
 create mode 100644 s390x/topology.c

-- 
2.31.1

Changelog:

From v5:

- added drawers and books

- mnest parameter is not needed anymore, replaced
  by the use of sclp.

- Added several tests for polarity change and reset
  for PTF

From v4:

- Simplify the tests for socket and cores only.

