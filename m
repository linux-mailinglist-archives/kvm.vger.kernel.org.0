Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F45602DFE
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 16:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiJROKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 10:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiJROKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 10:10:22 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956A17AC1F
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:10:08 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IDhmVj019493
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:10:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=eyQShOlO321JNqosmPZDTgDUc+g3tdHgefRYpSs5MIU=;
 b=DabZ+k48A2SUEeQr1+9IT5cJtJzSsFFbNg9d3lzyQfTh3kcK7xVpG6oiLxcRTRgj2rb2
 506HzVEbbAO4hkR3aiJdtksuVlo2Lba2uHxlOekhgyv25elztmwcwBjJ2JWCCvc8yv60
 fc94gzGicP8TkbY7LPAWSu7HCh46jQiO3ynn5GTymjxi/c5fhvTwOWyQ9P2wsD1ElLz7
 7eP7zz4e2kgK2/qIv3+BTxgMpzuMuN8uVCMEg1/RWPz2gO5u+yQtRkpIqRNwpwm5T2vv
 bWU/owwaQtl1NvKKBwOKoYcGpLj6TgFey7I1AanDeju3IkzVnA5UVG19fI2wdFyQOqtj BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k9w9dh6bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:10:05 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29IDjjO3029354
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:10:05 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k9w9dh6ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 14:10:05 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29IE65bY027509;
        Tue, 18 Oct 2022 14:10:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3k7mg943ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 14:10:03 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29IEA0Wo63242718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 14:10:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 173AE42041;
        Tue, 18 Oct 2022 14:10:00 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF39C4203F;
        Tue, 18 Oct 2022 14:09:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.8.239])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Oct 2022 14:09:59 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/2] s390x misc fixes
Date:   Tue, 18 Oct 2022 16:09:49 +0200
Message-Id: <20221018140951.127093-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sHejAbAA_z6oVzoihU60wvp0cRfLu5lt
X-Proofpoint-ORIG-GUID: ZsCe18cGngJTp560SPHuRiykFKVuvz3d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_04,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 mlxlogscore=675
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two unrelated misc fixes for s390x:

* abort immediately and without printing anything if a program interrupt is
  received inside an interrupt handler
* fix the uv-host test so that it allocates UV memory properly

Claudio Imbrenda (2):
  lib: s390x: terminate if PGM interrupt in interrupt handler
  s390x: uv-host: fix allocation of UV memory

 lib/s390x/asm/arch_def.h | 11 +++++++++++
 lib/s390x/interrupt.c    | 18 ++++++++++++++----
 s390x/uv-host.c          |  2 +-
 3 files changed, 26 insertions(+), 5 deletions(-)

-- 
2.37.3

