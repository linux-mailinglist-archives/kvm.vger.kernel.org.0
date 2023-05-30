Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C492716024
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 14:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbjE3MmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 08:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbjE3Ml7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 08:41:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E721AD;
        Tue, 30 May 2023 05:41:36 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UC8TmC008269;
        Tue, 30 May 2023 12:41:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=UBwvqp78X4MzSrMKZIbFMnA/WvjHHKH92r/fj5mdZqA=;
 b=rSGF64744mSOdfCiMsA10Uy/Lil2AtvKG8YBjsQBgOg9d5NhZu9ZWQBycPCeToOBY16Y
 VaGuEdNYZ1PQ77pmnz90VFWwqd++trhY5rNG5E2vsSbsOGIkvIMywJPDz7TdPzTq50On
 8csaTna67YdHU4PPWYihMVLaEHgljWvarNCrxw7FtyCeAdKdNeQnx45JxqK+HLSLborL
 xkdNyqX6lfxsnkKal2gLeagU1U5PqMgjOOaDoflgbj4tFY9FGR1ygY+yCUqU2vNlfXXq
 P/Vg6++jSo+coU5Nk/sPhy03dgoJuj39ShDpG5Wrb3BTDiKLHP1u4VWTIrL/wsZ87FHi jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwg87hs3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:41:03 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34UCAwge016638;
        Tue, 30 May 2023 12:41:02 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwg87hs2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:41:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34U5l6CP010940;
        Tue, 30 May 2023 12:41:01 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qu94e1fnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:41:00 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UCevRQ20382232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 May 2023 12:40:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 775F620043;
        Tue, 30 May 2023 12:40:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E8E620040;
        Tue, 30 May 2023 12:40:57 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 30 May 2023 12:40:57 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/2] Fixing infinite loop on SCLP READ SCP INFO error
Date:   Tue, 30 May 2023 14:40:54 +0200
Message-Id: <20230530124056.18332-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JbPZwt4SGdJ-48cTZTRrbMea_eJdM-kk
X-Proofpoint-ORIG-GUID: yl5HAaDSKQEnjQVxikZpqPOe60cf7bRQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_08,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=577 spamscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305300103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Also implement the SCLP_RC_INSUFFICIENT_SCCB_LENGTH handling and
repeat the sclp command.

Pierre Morel (2):
  s390x: sclp: consider monoprocessor on read_info error
  s390x: sclp: Implement SCLP_RC_INSUFFICIENT_SCCB_LENGTH

 lib/s390x/sclp.c | 64 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 56 insertions(+), 8 deletions(-)

-- 
2.31.1

since v2:

- use tabs in first patch
  (Nico)

- Added comments

- Added SCLP_RC_INSUFFICIENT_SCCB_LENGTH handling
