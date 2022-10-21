Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F33607039
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 08:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJUGng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 02:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJUGne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 02:43:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE82C242C81
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 23:43:33 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29L6cRri009688
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=VGvpVhoP5PUA4LNMhvD3mrf+XZkV1ppVkgRUajdJGQw=;
 b=s/8+yi7j3PPxRSUf6NTn3BH9xXaoIFQLD6mypLy31pQdoC0//oYer8C8Zx/4vlAi/yTR
 z23X5OISBxbGUhZAHxm/V3qeoTYE7GOj7vTXnUM1hVF2RBjWSha80eKt2r/U3aX6RMT0
 kXI2h+RR7MdBittJWCCdXfKb3DlX1EU86qD7FFCs0Nbg3/DY+VERxq4hmCHv1otIdSeD
 9QlZZidtbWq65VI02TtCIaqZYQcDwIaRfn9eUrbxifzUIjYPsSV0AdEHc+EpN1xgkZGa
 umqxK7mxQc7OlHy/kKOJeGdTyweDnmjQeiGOb+6nF5mMO30sXhpWgIpZyqRjSxs9v9C+ kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbp1y8mjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:43:33 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29L6MYaQ025926
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:43:33 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbp1y8mhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 06:43:33 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29L6aMFK021410;
        Fri, 21 Oct 2022 06:43:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3k7mg9fj60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 06:43:30 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29L6hRmp2294414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Oct 2022 06:43:27 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BC6F11C050;
        Fri, 21 Oct 2022 06:43:27 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B41511C04A;
        Fri, 21 Oct 2022 06:43:26 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Oct 2022 06:43:26 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/6] s390x: PV fixups
Date:   Fri, 21 Oct 2022 06:38:56 +0000
Message-Id: <20221021063902.10878-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xdV24ZERE4hzBVKuRLJA2_MHxkj5wmBP
X-Proofpoint-GUID: G_V-rcLr-oMFjg5fybpYdY2HtSQx314D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_01,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=744 phishscore=0 impostorscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A small set of patches that clean up the PV snippet handling.

v3:
	* Dropped asm snippet linker script patch for now
	* Replaced memalign_pages_flags() with memalign_pages()
	* PV ASCEs will now recieve DT and TL fields from the main test ASCE

v2:
	* Macro uses 64bit PSW mask
	* SBLK reset on PV destroy and uv_init() early return have been split off


Janosch Frank (6):
  s390x: snippets: asm: Add a macro to write an exception PSW
  s390x: MAKEFILE: Use $< instead of pathsubst
  lib: s390x: sie: Improve validity handling and make it vm specific
  lib: s390x: Use a new asce for each PV guest
  lib: s390x: Enable reusability of VMs that were in PV mode
  lib: s390x: sie: Properly populate SCA

 lib/s390x/asm-offsets.c                  |  2 ++
 lib/s390x/sie.c                          | 37 +++++++++++++-------
 lib/s390x/sie.h                          | 43 ++++++++++++++++++++++--
 lib/s390x/uv.c                           | 35 +++++++++++++++++--
 lib/s390x/uv.h                           |  5 ++-
 s390x/Makefile                           |  2 +-
 s390x/cpu.S                              |  6 ++++
 s390x/snippets/asm/macros.S              | 28 +++++++++++++++
 s390x/snippets/asm/snippet-pv-diag-288.S |  4 +--
 s390x/snippets/asm/snippet-pv-diag-500.S |  6 ++--
 10 files changed, 140 insertions(+), 28 deletions(-)
 create mode 100644 s390x/snippets/asm/macros.S

-- 
2.34.1

