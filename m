Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AAF605A69
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiJTJBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJTJBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:01:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CAF186D7E
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:01:05 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K8o1KP009993
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:01:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=yezoIxGjz2/Rw58wuofWPtyRB2UWbUWc2kMqtdXTdww=;
 b=TcAXueNqPms8GLzo3mVEAFI7SAd2IZEpe3t104lxEaaTSuuA7nXjLVZDGM3yGBga5fku
 taCk6vK1X+536gsAUwaDYV8SbyEspwoOs0U1QBeTE72UwuWsigFMxLIkdS1AhbVOFQqB
 /yDSuM3eJ1gmnd6M1ku0TQJEBLjej/XqV2kamEk+XBp+x1dn1T4gz6ejNqoDY242/kcl
 5a/O1C/DHBWOCsDmMEWaxye5/UuVJHy10GeRiUrMEnTDeUZBRNawK96WHqk1myJUREdk
 irROkd5CQk3+8A1cGwB73NOHIIwuwNz6eZdA7lyIKDRKls4mMnogSs21H7mdn+ez21xZ gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb35w89vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:01:04 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K8ogDm013305
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:01:04 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb35w89ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:01:04 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K8niWn004153;
        Thu, 20 Oct 2022 09:01:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3k7mg8xexv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:01:02 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K90xfd66060776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 09:00:59 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 230EB42041;
        Thu, 20 Oct 2022 09:00:59 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 732D442042;
        Thu, 20 Oct 2022 09:00:58 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 09:00:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/7] s390x: PV fixups
Date:   Thu, 20 Oct 2022 09:00:02 +0000
Message-Id: <20221020090009.2189-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DSXYAO_tJXeDQIXDema6U7DnsGN1Kdax
X-Proofpoint-GUID: g32FJzZcvDc-meRIm6Bnk-OsttlMN0m6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=889
 spamscore=0 clxscore=1015 bulkscore=0 phishscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A small set of patches that clean up the PV snippet handling.

v2:
	* Macro uses 64bit PSW mask
	* SBLK reset on PV destroy and uv_init() early return have been split off


Janosch Frank (7):
  s390x: snippets: asm: Add a macro to write an exception PSW
  s390x: MAKEFILE: Use $< instead of pathsubst
  s390x: Add a linker script to assembly snippets
  lib: s390x: sie: Improve validity handling and make it vm specific
  lib: s390x: Use a new asce for each PV guest
  lib: s390x: Enable reusability of VMs that were in PV mode
  lib: s390x: sie: Properly populate SCA

 lib/s390x/asm-offsets.c                  |  2 ++
 lib/s390x/sie.c                          | 37 +++++++++++++-------
 lib/s390x/sie.h                          | 43 ++++++++++++++++++++++--
 lib/s390x/snippet.h                      | 14 +++-----
 lib/s390x/uv.c                           | 35 +++++++++++++++++--
 lib/s390x/uv.h                           |  5 ++-
 s390x/Makefile                           | 18 +++++++---
 s390x/cpu.S                              |  6 ++++
 s390x/mvpg-sie.c                         |  2 +-
 s390x/pv-diags.c                         |  6 ++--
 s390x/snippets/asm/flat.lds              | 35 +++++++++++++++++++
 s390x/snippets/asm/macros.S              | 28 +++++++++++++++
 s390x/snippets/asm/snippet-pv-diag-288.S |  4 +--
 s390x/snippets/asm/snippet-pv-diag-500.S |  6 ++--
 14 files changed, 197 insertions(+), 44 deletions(-)
 create mode 100644 s390x/snippets/asm/flat.lds
 create mode 100644 s390x/snippets/asm/macros.S

-- 
2.34.1

