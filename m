Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9C57BF47C
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 09:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442525AbjJJHjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 03:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442509AbjJJHjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 03:39:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44733A4
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 00:39:07 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39A7a73u009862
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=DYoLaFsf8hq9F8bAbjGAGcn2vevzx5qWOsaOWiGw4xE=;
 b=OlgvbrG56o6aL/iDN8zXri0yMMpaTvnAbIP+znNPb0HDWDGkQUf2oYZKPOL/lPaTgtf8
 RhoTXfQ9d6qDF4G4blFMJXCXJEq9fnx65vpgmuRtIAFXBdJLR4qip7q3MM7WdSqVaICS
 uigOf6OOvqtxpTSL2SJ+tbakn0e8BAgKhMyx5A99HjxWwqa9PQxorxukfgGy5on/ySWy
 vqNUWQteoHsELr9UNgLpagfxUkoAVOj1nQzOhF50hoKQrwbDBkyIHG1+vZM3CnoaoUpd
 ynxDgRI+VCbpr+QMYC4ABnRN11INN7q6DrnbBanO7ilqCxYqQWSRlN4gkH9iMKH9Fvf6 gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn25q0c1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:39:06 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A7a7dv009900
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:39:06 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn25q0c15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 07:39:06 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A6gP2g024439;
        Tue, 10 Oct 2023 07:39:05 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkhnsf4mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 07:39:05 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39A7d2aa24314436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 07:39:02 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 852D520043;
        Tue, 10 Oct 2023 07:39:02 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5777320040;
        Tue, 10 Oct 2023 07:39:02 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 07:39:02 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/3] s390x: Improve console handling
Date:   Tue, 10 Oct 2023 07:38:52 +0000
Message-Id: <20231010073855.26319-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QZcZuqLDyuOeykygNwhbG5J-s84ESyy9
X-Proofpoint-ORIG-GUID: HwkkuUN93Io9eVACO36M_nF4rypqHLVd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_04,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 mlxlogscore=332 mlxscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310100056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
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

v1:
	* Fenced ASCII compat handling so it's only use in LPAR
	* Squashed compat handling into one patch
	* Added an early detect_host since SCLP might be used in setup
	* Fixed up a few formatting issues in input patch
	* Fixed up copyright stuff

Janosch Frank (3):
  lib: s390x: hw: Provide early detect host
  lib: s390x: sclp: Add compat handling for HMC ASCII consoles
  lib: s390x: sclp: Add line mode input handling

 lib/s390x/hardware.c     |   8 ++
 lib/s390x/hardware.h     |   1 +
 lib/s390x/sclp-console.c | 203 +++++++++++++++++++++++++++++++++++----
 lib/s390x/sclp.h         |  26 ++++-
 4 files changed, 216 insertions(+), 22 deletions(-)

-- 
2.34.1

