Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C379724D523
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 14:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgHUMih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 08:38:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728550AbgHUMif (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 08:38:35 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LCW73e059935
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 08:38:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DspWVj5sAZNSyaOmyzuAOl6gPUo0dAvPlhjF9HxSnKQ=;
 b=mfCRIJC+A7eDlVFkfwst66hZbwaFjyUscCSnYy1giClMg/L4sCsapUGkg4XdFjMiznAs
 9Xl1Zu1HFybeLvMjqWxVx/bBzPaegU0BW4tcluYj3lb4m6RbfmMtJt9uXqgsdFP6gGZC
 wIBzl8agzQqGGbTEQ5LiAB/uf0F6l3F82Z5BfqJbMEepK6hrt7ikTXn+swHMKQGyuQAf
 PEwjfJT09VHsqGJquai6pBJAh+YL/uufn9nFMNZFexugFAZaQ1QMXAcWzO4dRh2f4QLB
 pt9DicvYVvjvcrAVYbWvFwq5H2z9XkgQrP0wDTdrfT17X+8S6b12S5W6hkK+W3j+Wrps mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 331uj4e7yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 08:38:35 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07LCWcOu061373
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 08:38:34 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 331uj4e7y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 08:38:34 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LCZS8f013979;
        Fri, 21 Aug 2020 12:38:32 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3304um4b29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 12:38:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LCcUXQ27853176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 12:38:30 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CF124C063;
        Fri, 21 Aug 2020 12:38:30 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4AD24C05A;
        Fri, 21 Aug 2020 12:38:29 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.60.23])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Aug 2020 12:38:29 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 1/2] runtime.bash: remove outdated comment
Date:   Fri, 21 Aug 2020 14:37:43 +0200
Message-Id: <20200821123744.33173-2-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821123744.33173-1-mhartmay@linux.ibm.com>
References: <20200821123744.33173-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_06:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit 6e1d3752d7ca ("tap13: list testcases individually") the
comment is no longer valid. Therefore let's remove it.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 scripts/runtime.bash | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index c88e246245a6..caa4c5ba18cc 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -53,9 +53,6 @@ skip_nodefault()
 
 function print_result()
 {
-    # output test results in a TAP format
-    # https://testanything.org/tap-version-13-specification.html
-
     local status="$1"
     local testname="$2"
     local summary="$3"
-- 
2.25.4

