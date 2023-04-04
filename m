Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECEB6D6CA1
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 20:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbjDDSvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 14:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235528AbjDDSvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 14:51:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A6735BD
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 11:50:59 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334IfsSk020830;
        Tue, 4 Apr 2023 18:50:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fPTNIPDrRB1pGV3S5nK411t5cqfIOLlICBip2v/0YKE=;
 b=c511E7+aeeqKR9Aa16qX7lcby6SCIMv1qzoB5V5948fHQhWM7vRsRyve1VyKgGczYOto
 AgzleeAMhBXEkxaHQf5Sb490lJjUOdYZLWw/sTkH4VILb+Jfh8s1FaVEOyXxcmsi/Hj2
 3rNq4ALrvhVJ0oH5jBF6mDh/MhjySldRCS6l3LcHXrZE0ArLVJ16WZJYyPIk+Mco8oEk
 YeBPysZwE1Y+Itxj+ZxBVNsM1Cz4rIdzVB1P9oQkOMuu4HLSuUsVfLhk9AQLLnsxxsU2
 kzOPfwG2EYlhpOEy7lqJ7bB++/akgEm3KCosJjPWNhbdr6N/DIjkOhMV6fz2LB0nF+yi XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prsd50680-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:50:56 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334IkNuf006202;
        Tue, 4 Apr 2023 18:50:56 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prsd50671-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:50:56 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 334HtZUH006368;
        Tue, 4 Apr 2023 18:50:54 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3ppc86t1ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 18:50:53 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334IopaG51315110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 18:50:51 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5451820049;
        Tue,  4 Apr 2023 18:50:51 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A0CB20040;
        Tue,  4 Apr 2023 18:50:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 18:50:51 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Peter Feiner <pfeiner@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/3] pretty_print_stacks: prevent invalid address arguments
Date:   Tue,  4 Apr 2023 20:50:45 +0200
Message-Id: <20230404185048.2824384-2-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230404185048.2824384-1-nsg@linux.ibm.com>
References: <20230404185048.2824384-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kWm-76kvkJL2F-cp9pQ6A10hqIj9ZHev
X-Proofpoint-GUID: KGSsdQYX1rF16whDMRT2jyn_2cmJZbed
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_10,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 phishscore=0 mlxlogscore=958 bulkscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040168
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a return address is zero, the script will pass -1 to addr2line which
it considers an invalid flag.
Zero is an unlikely return address, but we might see it, for example
because the backtrace is unreliable on s390x if there is an interrupt
frame on the stack.

Fixes: a9143a24 ("scripts: pretty print stack traces")
Tested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 scripts/pretty_print_stacks.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/pretty_print_stacks.py b/scripts/pretty_print_stacks.py
index 1e59cde6..ba6f0825 100755
--- a/scripts/pretty_print_stacks.py
+++ b/scripts/pretty_print_stacks.py
@@ -22,7 +22,7 @@ def pretty_print_stack(binary, line):
         if addr.startswith('@'):
             addrs[i] = addr[1:]
         else:
-            addrs[i] = '%lx' % (int(addrs[i], 16) - 1)
+            addrs[i] = '%lx' % max((int(addrs[i], 16) - 1), 0)
 
     # Output like this:
     #        0x004002be: start64 at path/to/kvm-unit-tests/x86/cstart64.S:208
-- 
2.37.2

