Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BBC623473
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 21:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiKIUWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 15:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiKIUWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 15:22:06 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF59D2FC29;
        Wed,  9 Nov 2022 12:22:04 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9IgWpO001018;
        Wed, 9 Nov 2022 20:22:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=0u9zU+6CvHZqhrEQhchxQW55KuqewBPZhy2tvafFA8w=;
 b=UwxPjptNW4qvSynt4nFN4/pmkcUsbUNv2m2Gozy9+qbhUH7zsl2epAawyJdDlZTU+GZI
 4vIYbL0xTml7mYCP6Nc2UExQn2yL922rIg/UiemecKLz6mZdsBxEF0Ft3CTKXNwWFYFX
 lxj33abVDNfVvtegivHM/GyIkkFbs4v40QYkCR4NtgHVyTPA4311yWdO+48oQJGe1qKa
 2IN9SsKoWQvAAdob9NX/qHhll5S8BGXufMTHDoqyTmQXMOtcAH2X6TlTVJ8uQ4L+u6X4
 64oSJpzJUxil6J+axP7UBSSI0NTtjirFZ5XryfvsRbcrchWaESqPttUTie873ut0JZD4 Xw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3krhqp2f0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 20:22:04 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A9KK21F014384;
        Wed, 9 Nov 2022 20:22:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3kngnce7r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 20:22:02 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A9KMbvb51708346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Nov 2022 20:22:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF179A4054;
        Wed,  9 Nov 2022 20:21:58 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC069A405C;
        Wed,  9 Nov 2022 20:21:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  9 Nov 2022 20:21:58 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 8B38DE009B; Wed,  9 Nov 2022 21:21:58 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH 0/2] s390/vfio-ccw: addressing fixes
Date:   Wed,  9 Nov 2022 21:21:55 +0100
Message-Id: <20221109202157.1050545-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uFLM9VXkmOHv6k4jiwPDCOe3d6ZKIZLN
X-Proofpoint-GUID: uFLM9VXkmOHv6k4jiwPDCOe3d6ZKIZLN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 adultscore=0 mlxlogscore=639 bulkscore=0 spamscore=0
 phishscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211090151
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi everyone,

The attached is a couple of small fixes for the addresses
created/used by vfio-ccw that are shared with hardware,
which I'm sure to lose sooner or later. Hopefully they
could get picked up before that happens.

Alexander Gordeev (1):
  vfio-ccw: sort out physical vs virtual pointers usage

Eric Farman (1):
  vfio/ccw: identify CCW data addresses as physical

 drivers/s390/cio/vfio_ccw_cp.c  | 4 ++--
 drivers/s390/cio/vfio_ccw_fsm.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.34.1

