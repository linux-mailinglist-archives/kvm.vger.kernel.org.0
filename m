Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67CA24859B
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 15:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgHRNFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 09:05:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64804 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726435AbgHRNE4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 09:04:56 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ID0XsQ126285;
        Tue, 18 Aug 2020 09:04:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=QSGBUV6MOcfvrCr+VKEIoq4Kg1hMeheyz5CfCznPvLM=;
 b=jkeJN95Dn27fIuLPtKn5AFo5IXGgoJjd8Q2Ua1BGzlLQIlaYlWqY7zoVubCgPCS5OI6N
 jICZhVBQi54/5MrZ52auSoSswYI0zPHGU5vyQEz8nUQ6xCNe0juhCu6a6PKqif4XilKE
 FEoZSGtsEMQ2neUfg+eXaohl2wbTH6cZrN28wuoFWPPDogjtoMvY1kTNYdNBLw9IyHXm
 CQg/z+IaqjnKGsoPYL9EDuokefwoDkuK1hcR4pEwm/d758VC9CtU8oTka/yb/V5RXoo9
 2QqsTe8LhdbQuT4Uiz/fUjglvQqhXPkkVSR5GDTnaNKbRBe+4ZsUwyqlmDdQKThr2U0Z 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3304t1ha9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 09:04:54 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07ID0hnV127374;
        Tue, 18 Aug 2020 09:04:54 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3304t1ha97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 09:04:54 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07ID1d1c031890;
        Tue, 18 Aug 2020 13:04:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3304um0ncx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 13:04:52 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07ID4nuw27722178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 13:04:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C63E14C050;
        Tue, 18 Aug 2020 13:04:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55B974C040;
        Tue, 18 Aug 2020 13:04:49 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.52.109])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Aug 2020 13:04:49 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 3/4] run_tests/mkstandalone: add arch_cmd hook
Date:   Tue, 18 Aug 2020 15:04:23 +0200
Message-Id: <20200818130424.20522-4-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200818130424.20522-1-mhartmay@linux.ibm.com>
References: <20200818130424.20522-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_07:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 suspectscore=1 mlxscore=0 lowpriorityscore=0 mlxlogscore=992
 malwarescore=0 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows us, for example, to auto generate a new test case based on
an existing test case.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 scripts/common.bash | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index c7acdf14a835..a6044b7c6c35 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -19,7 +19,7 @@ function for_each_unittest()
 	while read -r -u $fd line; do
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
 			if [ -n "${testname}" ]; then
-				"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 			fi
 			testname=${BASH_REMATCH[1]}
 			smp=1
@@ -49,11 +49,16 @@ function for_each_unittest()
 		fi
 	done
 	if [ -n "${testname}" ]; then
-		"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 	fi
 	exec {fd}<&-
 }
 
+function arch_cmd()
+{
+	[ "${ARCH_CMD}" ] && echo "${ARCH_CMD}"
+}
+
 # The current file has to be the only file sourcing the arch helper
 # file
 ARCH_FUNC=scripts/${ARCH}/func.bash
-- 
2.25.4

