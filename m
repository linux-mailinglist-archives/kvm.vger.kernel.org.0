Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855F24FB90D
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345125AbiDKKKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345112AbiDKKKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:10:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266AE42A17;
        Mon, 11 Apr 2022 03:07:57 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B9hJWJ004564;
        Mon, 11 Apr 2022 10:07:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=PIq7azO6pUyQM/9lTH1hBwx7/9FTbtTYMEwnyHIdpdc=;
 b=DMXr7mPNzGvwcocdlqMRO7xSR6USMdDIytMtCVa6r27VJR0WJyBjiDi4MJxHuotNa8de
 evDjt/E9VEDafRYozFWkEtjNJWjtwUMueG+rz4NRJ1C0W+1g8ieg7alegLcCRJOaX9OO
 5wj35TxWMOt1GE8JgibH/p5NdXVbOR9tYD/LIRYAzNfb+B5mMQ/3Z6e3dNF9lxobPs2X
 ThUAOCFYkg9iiBJ0ZdQ+uSCiSyitwnl2J2FCO9J1qIZkV5EipZw5VHazitaM9gVbdxvw
 NCusvBwXPDJ2hAtgn4DjDapAP3uRG/MWaRWHU3DkKD5NIsmEwNzqn8ZIUwV8rxRTXXz7 Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fchxtre4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 10:07:56 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23B9vum9021890;
        Mon, 11 Apr 2022 10:07:55 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fchxtre3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 10:07:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BA7nYJ012228;
        Mon, 11 Apr 2022 10:07:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3fb1s8tuny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 10:07:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BA7osj45154686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 10:07:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92494A4054;
        Mon, 11 Apr 2022 10:07:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F7D8A405B;
        Mon, 11 Apr 2022 10:07:50 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Apr 2022 10:07:50 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/4] s390x: add migration test suport
Date:   Mon, 11 Apr 2022 12:07:46 +0200
Message-Id: <20220411100750.2868587-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QrZ2PwNKIXSM-sFE0QYKWAMcOsv3lYYL
X-Proofpoint-GUID: ycQrH6ECy46LwAmIHWfLIwN3RkHCNFLH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_03,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 spamscore=0 mlxlogscore=949 adultscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add migration test support for s390x.

arm and powerpc already support basic migration tests.

If a test is in the migration group, it can print "migrate" on its console. This
will cause it to be migrated to a new QEMU instance. When migration is finished,
the test will be able to read a newline from its standard input.

We need the following pieces for this to work under s390x:

* read support for the sclp console. This can be very basic, it doesn't even
  have to read anything useful, we just need to know something happened on
  the console.
* s390/run adjustments to call the migration helper script.

Nico Boehr (4):
  lib: s390x: add support for SCLP console read
  s390x: add support for migration tests
  s390x: don't run migration tests under PV
  s390x: add selftest for migration

 lib/s390x/sclp-console.c   | 81 +++++++++++++++++++++++++++++++++++---
 lib/s390x/sclp.h           |  7 ++++
 s390x/Makefile             |  2 +
 s390x/run                  |  7 +++-
 s390x/selftest-migration.c | 27 +++++++++++++
 s390x/unittests.cfg        |  4 ++
 scripts/s390x/func.bash    |  2 +-
 7 files changed, 122 insertions(+), 8 deletions(-)
 create mode 100644 s390x/selftest-migration.c

-- 
2.31.1

