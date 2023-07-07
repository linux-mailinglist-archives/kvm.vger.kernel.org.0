Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88E774B35C
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 16:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbjGGOy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 10:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbjGGOy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 10:54:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E737E211D;
        Fri,  7 Jul 2023 07:54:54 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 367ElpCw006311;
        Fri, 7 Jul 2023 14:54:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4RrXp7ERIdUDp7nSEyIjv8QbkM92ocDvPwuWR9MTn48=;
 b=CLBd7je0LFBioA7r4KekHdQbKN/UOr7vLPwJ/gY43oskTHmMzAvIUsD4dJl7XTw1+IuA
 iIes+I5gu2T1UzjWn5bLteZ/AlrPTR9ItghOhumM7aB2vNl6/mE9FXCguAzAHYczUj1G
 hhVJjty0Or0VfUHGXgbrxF04EbntEfufKdhEOVcixpKT4r2eZjSfYjCH6FSsx+CoqsmH
 sEAKuuPT/1ubkAjaWEBiasgLOCAiCLrKXWqi486rOE+yJKwN//Weo/OA61WlXpqYSySw
 X71mDYPNcUqUNUcXMdE1zNp/CjxYc+TWV6+KuBctjk+isqbEHnkZcQGldl4m6/xY/Ndz aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rpmsd84yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 14:54:53 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 367EonO2013784;
        Fri, 7 Jul 2023 14:54:53 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rpmsd84y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 14:54:53 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 367BJ9eD000334;
        Fri, 7 Jul 2023 14:54:51 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3rjbs52ynv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 14:54:51 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 367Esl4Z1442366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jul 2023 14:54:47 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C88112004D;
        Fri,  7 Jul 2023 14:54:47 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA24120040;
        Fri,  7 Jul 2023 14:54:46 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jul 2023 14:54:46 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/2] s390x: Improve console handling
Date:   Fri,  7 Jul 2023 14:54:08 +0000
Message-Id: <20230707145410.1679-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tdjqpM-CUiiqoiEGFlua1USBp-0F-0B6
X-Proofpoint-GUID: ZvVYbwCGqN94BEqmAwuW713jPrS4IK8N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-07_10,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 spamscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=772
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307070134
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
\n so each line doesn't necessarily start at column 0. It's time to
finally fix that.

Also, since there are environments that only provide the line-mode
console it's time to add line-mode input to properly support them.

rfc -> v1:
	- Switched to \r\n from \n\r
	- Removed console clear
	- Added truncation logic to maintain 2k limit

Janosch Frank (2):
  lib: s390x: sclp: Add carriage return to line feed
  lib: s390x: sclp: Add line mode input handling

 lib/s390x/sclp-console.c | 193 +++++++++++++++++++++++++++++++++++----
 lib/s390x/sclp.h         |  26 +++++-
 2 files changed, 198 insertions(+), 21 deletions(-)

-- 
2.34.1

