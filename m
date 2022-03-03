Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240154CC787
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 22:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbiCCVFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 16:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbiCCVFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 16:05:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D991939E7;
        Thu,  3 Mar 2022 13:04:33 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223JIw7V018851;
        Thu, 3 Mar 2022 21:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=gR3CwwVbbWFl9r71eyyGS31O1x5BGfpV1zXZccRpTVg=;
 b=McQA+1oAxm277nUerhagktxTfFARy5UlFCStfgERJe12/gBC0dh7LQKlFBZymzFZPLK3
 cv65k1hK01BZy5QGPS+kjqisLwitlz1RhfdAqInXhqz/kC/t50cumc5wowGrXgbTiL75
 m7dCvmK3JVCCnX+gwrI1/6qUwb9OWT7oCVkyAXKsfz2+3uM/gF561SZcT8qU+sRxzuBU
 KzQ/eUAe1u/aRrUOe5tG4C1oXGZa8b2xawlcRGFeWlYLVj93zuHKEPrOqZJRH8ng5344
 pBVarl+i72n0y8qReGEZaKQ03NDFEGUxgOXq4I/DDFv17Lqz9H0b65tyZsONEaNoU5zw +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek3qphtm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:32 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223Kenco011698;
        Thu, 3 Mar 2022 21:04:32 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek3qphtkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:32 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223L3Nlp011624;
        Thu, 3 Mar 2022 21:04:30 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3ek4ka8246-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223L4QRv16515444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 21:04:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1D66AE055;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0346AE045;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 7C3FEE0397; Thu,  3 Mar 2022 22:04:26 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH kvm-unit-tests v1 0/6] s390x: SIGP fixes
Date:   Thu,  3 Mar 2022 22:04:19 +0100
Message-Id: <20220303210425.1693486-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TrWygZ7rfweLWOeEbF-FTyk7UoWh4932
X-Proofpoint-ORIG-GUID: ta0-GsHUinEw7hBV6t95CoDvy0AiBL4H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_09,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 clxscore=1015 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030095
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

Some of you may remember the recent discussions to straighten out
some serialization issues with the SIGNAL PROCESSOR instruction,
and its interaction with userspace. This resulted in a few kernel
patches [1] that reliably solve the issues I was seeing.

The attached kvm-unit-tests series adapts the existing smp tests
such that it can reproduce the problems I saw when those patches
are reverted (typically by simultaneously doing a kernel compile),
and also demonstrate that those patches indeed fix the issue.

There's some cleanup in here too, based on my understanding of
the smp tests as I was walking through here. Thoughts?

[1] 812de04661c4 KVM: s390: Clarify SIGP orders versus STOP/RESTART
    67cf68b6a5cc KVM: s390: Add a routine for setting userspace CPU state
    8eeba194a32e KVM: s390: Simplify SIGP Set Arch handling

Eric Farman (6):
  lib: s390x: smp: Retry SIGP SENSE on CC2
  s390x: smp: Test SIGP RESTART against stopped CPU
  s390x: smp: Fix checks for SIGP STOP STORE STATUS
  s390x: smp: Create and use a non-waiting CPU stop
  s390x: smp: Create and use a non-waiting CPU restart
  lib: s390x: smp: Convert remaining smp_sigp to _retry

 lib/s390x/smp.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++---
 lib/s390x/smp.h |  2 ++
 s390x/smp.c     | 39 +++++++++++++++++++-----------------
 3 files changed, 73 insertions(+), 21 deletions(-)

-- 
2.32.0

