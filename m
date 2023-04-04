Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360646D5F26
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbjDDLhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbjDDLhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:37:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3CE2D79
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 04:36:53 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3349VpLu011387;
        Tue, 4 Apr 2023 11:36:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=jE3XAsRL4apKqIgk4wKSWm8Bj8iNCgxeTkbraJKcpeU=;
 b=SxaoOao2qwsoLjq+Nu+64v2A5r/QTppun3Wvb5wmK3hD6wYZjE4EOjPX5ZVdhj0OPwSX
 NqTtRaHe1TL9+7o40KjZ2cTa+GMUleeDpiy8XoF/iMYSx1JHYfv4IhRpARocIoTE/NIS
 A2q/iyrlljbnzbNkXGrYAisS29VstCpkZtfcx/NSxg4uLi7DbpMC3SBOkzeoWuJekV0o
 EIuh0oQwlvqb7SMN80ntVpE+hI6IcN7AYLpK3JLyVjjGrUj9/3KrXENfe0CkkoW9YnOc
 gttgm+rKgwVJKfg2iyTVghW2moo6SLhWGDYu55Vt5FwxRphi/EZy0FUNesaym9uVLNvZ nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr4m5c2qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:50 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3349qif0012331;
        Tue, 4 Apr 2023 11:36:50 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr4m5c2q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:50 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3342xnkA015581;
        Tue, 4 Apr 2023 11:36:48 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ppc87ag5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:48 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334Baixb28770612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:36:44 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66C0620040;
        Tue,  4 Apr 2023 11:36:44 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D66B920043;
        Tue,  4 Apr 2023 11:36:43 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.55.238])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:36:43 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL v2 01/14] .gitignore: ignore `s390x/comm.key` file
Date:   Tue,  4 Apr 2023 13:36:26 +0200
Message-Id: <20230404113639.37544-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404113639.37544-1-nrb@linux.ibm.com>
References: <20230404113639.37544-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zsbruB16nJHoxkQUJGf0o7v-Rp03Z3RP
X-Proofpoint-ORIG-GUID: 6VNVUrRvmD0iu-cuLNGUHppfwcTSOghd
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 spamscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Hartmayer <mhartmay@linux.ibm.com>

Ignore the Secure Execution Customer Communication Key file.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230307091051.13945-2-mhartmay@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 33529b6..601822d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -28,5 +28,6 @@ cscope.*
 /s390x/*.bin
 /s390x/snippets/*/*.gbin
 /efi-tests/*
+/s390x/comm.key
 /s390x/snippets/*/*.hdr
 /s390x/snippets/*/*.*obj
-- 
2.39.2

