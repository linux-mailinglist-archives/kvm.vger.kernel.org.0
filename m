Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5129E4D67B9
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350808AbiCKRjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349575AbiCKRjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:39:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38B91AEECD;
        Fri, 11 Mar 2022 09:38:32 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BH2Y9C028747;
        Fri, 11 Mar 2022 17:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=T4s+2hZyVGkeRMSsgFed8adsOY6kgJs4v3dC+Hsvj5k=;
 b=ee1ZTvPIxgEpFH1o9PPWUnp4LfNIjmFJUVu0EdjWvuBLXePo3I2qkjSxhtDm586dz+jC
 lVSJq3SWGQo8IljxyzFtj/q4ZRhM4D6ojjLDSsmg7j4Lqk+G561eHEOKC0JFhP2nj53S
 dVlLbS1po1xmuUon3RaqtEFf+g7ctg7wq+TWQHJ9Tdn01ccbnqbbwi1McGxEal7k0DHK
 2vN4esHoZdpIBgkiWAKesxH/95TQYf+Qwthl38oRu/xLNw4pzuf4X7KQ1EEfRSAfPaM8
 uYTmWhm/f9Ek+EW9bZm1tMqUDNUhAbwkQtJjv/Ac9knkOMJlZunkHsbswDJzpi90ZxtX Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqf3p2nwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:32 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22BHVT17031630;
        Fri, 11 Mar 2022 17:38:31 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqf3p2nvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:31 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22BHXa12013353;
        Fri, 11 Mar 2022 17:38:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3ep8c3xtcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22BHcQXO45023618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 17:38:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2696E4C044;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 154AC4C040;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id C1A12E1227; Fri, 11 Mar 2022 18:38:25 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH kvm-unit-tests v2 0/6] s390x SIGP fixes
Date:   Fri, 11 Mar 2022 18:38:16 +0100
Message-Id: <20220311173822.1234617-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U_3FjBqSxgAGfXUwPYtGbxe3k2Kh93Yp
X-Proofpoint-GUID: eGx97nEO8gjB0sq6JbRP4VuXrXh9k88F
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-11_07,2022-03-11_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 phishscore=0 clxscore=1015 spamscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

Here is a second version of the SIGNAL PROCESSOR tests, addressing
the comments that were made to v1.

The biggest change is Patch 6, which has effectively been replaced.
Considering comments from Nico and Janosch, and making sure
consumers of smp_sigp get their SIGP retried, I opted to convert
smp_sigp() to perform the CC2 retry under the covers, and remove
smp_sigp_retry() itself. This effectively reverts patch 1, but I
thought the end result was cleaner and less prone to confusion
going forward. If a test needs a no-retry interface going forward,
that would be one thing, but the only places that do that are
the testing of STOP and RESTART itself, which handle this as seen
in patches 4 and 5.

So, thoughts?

v2:
 - Patch 1-2: Applied r-b from Claudio, Janosch, and Nico (thank you!)
 - [JF] Patch 3: Clarified commit message that it's dealing with semantics
   rather than a bugfix.
 - [NB] Patch 4-5: Added return code checks of the _nowait() routines
   (Claudio: I appreciate the r-b on 4, but didn't apply it because of the
   new checks that were made here)
 - [EF] Patch 4-5: Use the non-retry sigp() call directly, rather than
   smp_sigp()
v1: https://lore.kernel.org/r/20220303210425.1693486-1-farman@linux.ibm.com/

Eric Farman (6):
  lib: s390x: smp: Retry SIGP SENSE on CC2
  s390x: smp: Test SIGP RESTART against stopped CPU
  s390x: smp: Fix checks for SIGP STOP STORE STATUS
  s390x: smp: Create and use a non-waiting CPU stop
  s390x: smp: Create and use a non-waiting CPU restart
  lib: s390x: smp: Remove smp_sigp_retry

 lib/s390x/smp.c | 63 ++++++++++++++++++++++++++++++++++++++++++-------
 lib/s390x/smp.h |  3 ++-
 s390x/smp.c     | 53 +++++++++++++++++++++++++----------------
 3 files changed, 89 insertions(+), 30 deletions(-)

-- 
2.32.0

