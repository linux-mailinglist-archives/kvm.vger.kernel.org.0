Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0C2743DF6
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 16:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbjF3Oze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 10:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjF3Ozc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 10:55:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855B0171E;
        Fri, 30 Jun 2023 07:55:30 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35UElJen028125;
        Fri, 30 Jun 2023 14:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=lDpFoRK1/JvWkbdjwEGp2GZljhqvTVU77TncYGJvVao=;
 b=ryupaRnBGG6ypMqmm22XhFu7U47aeAYGPqreVwbA1MjO3+P+X1UgURO2NezaYEbhIVyt
 9lap7loSSepEKw5KCuA1HxWvWUhcu0AYdE7Y1W8KM3pYd5066y3vfLPq6CQeO8HoBtOT
 e7MXEjMOcvcxW5SrF4F/IfsYjO25U1iOmL3AuSuoQp0bS+UR2OF/6OjftDK0+FLS5Ys6
 WaLBZJdJZH71nopKbm3Ny4AebNZR6XbfModFBGRQBEphbpiHcTt1GaKGPDtObyUuO0U8
 7ReX0WOLQBpCp2QW6l7bR3AJbBe6GQU7nAQBxudm5KLV4bkcwkdDeybuDgNtm6f6ZaPZ xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj143r5gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 14:55:29 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35UEmbsm030740;
        Fri, 30 Jun 2023 14:55:29 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj143r5ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 14:55:29 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35UDJqAK025762;
        Fri, 30 Jun 2023 14:55:27 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3rdr4533tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 14:55:27 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35UEtOKB28443166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 14:55:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1048020049;
        Fri, 30 Jun 2023 14:55:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 147EB20043;
        Fri, 30 Jun 2023 14:55:23 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 14:55:22 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests RFC 0/3] s390x: Improve console handling
Date:   Fri, 30 Jun 2023 14:54:46 +0000
Message-Id: <20230630145449.2312-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fpboecg2XEmWPG74YZKxcOpbsIq4SpqX
X-Proofpoint-GUID: eZ-QzgrX7-7Cfak5Ph6ejJBnuyxGsM76
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_05,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 mlxlogscore=609 priorityscore=1501 mlxscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306300123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Console IO is and has been in a state of "works for me". I don't think
that will change soon since there's no need for a proper console
driver when all we want is the ability to print or read a line at a
time.

However since input is only supported on the ASCII console I was
forced to use it on the HMC. The HMC generally does not add a \r on a
\n so each line doesn't start at column 0. It's time to finally fix
that.

Also, since there are environments that only provide the line-mode
console it's time to add line-mode input to properly support them.

Janosch Frank (3):
  lib: s390x: sclp: Add carriage return to line feed
  lib: s390x: sclp: Clear ASCII screen on setup
  lib: s390x: sclp: Add line mode input handling

 lib/s390x/sclp-console.c | 191 +++++++++++++++++++++++++++++++++++----
 lib/s390x/sclp.h         |  26 +++++-
 s390x/run                |   2 +-
 3 files changed, 197 insertions(+), 22 deletions(-)

-- 
2.34.1

