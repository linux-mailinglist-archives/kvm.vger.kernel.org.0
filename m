Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FC2340611
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhCRMux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:50:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230171AbhCRMub (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 08:50:31 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ICXhV1181244;
        Thu, 18 Mar 2021 08:50:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=c+JX4EYxm/DmDeTHW1yOCsH+/b0JTmv2rfWQ1weXN2I=;
 b=QLrr2ssBN/gxVQLI/DhSlfz9fxyAc8kRCxEn0AaZyYgrSVjW7Lyzsl30WchGHbhFOhdt
 xovvsT+rL2hEKErOfcAshF7dolDCDdLfKZHx4etVWMQ4yven5AqyLau/wOzchmE3l2bU
 9PvPtqp9DyllyJs02UUwQKANZlR31WXN+yEm0vWHxzwCQ0eqnvKVt9s71BRthh9T3Lkc
 WEWincWZ9RZWXP47PkCiMMXyF86w7QaQuGyAT9aVPWNZSCmaDI5h3Y1J/77o7JkYBHbM
 3uS2ZnvoNzT7gmdRq/InRM94ZYBvj6j9Y2/8NQazqVPRZaiCiEW8AJbHaHFepJ9yN+RX eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c10fk097-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 08:50:30 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ICXwXw182858;
        Thu, 18 Mar 2021 08:50:30 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c10fk08m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 08:50:30 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12ICknpk002596;
        Thu, 18 Mar 2021 12:50:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 37b6xjgsdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 12:50:28 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12ICoQdA7668042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 12:50:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5D9AA4055;
        Thu, 18 Mar 2021 12:50:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D546FA4053;
        Thu, 18 Mar 2021 12:50:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.24.61])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 12:50:24 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/3] s390x: Don't run PV testcases under tcg
Date:   Thu, 18 Mar 2021 12:50:13 +0000
Message-Id: <20210318125015.45502-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318125015.45502-1-frankja@linux.ibm.com>
References: <20210318125015.45502-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The UV call facility is only available on hardware.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 scripts/s390x/func.bash | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
index b3912081..bf799a56 100644
--- a/scripts/s390x/func.bash
+++ b/scripts/s390x/func.bash
@@ -21,6 +21,9 @@ function arch_cmd_s390x()
 	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 
 	# run PV test case
+	if [ "$ACCEL" = 'tcg' ]; then
+		return
+	fi
 	kernel=${kernel%.elf}.pv.bin
 	testname=${testname}_PV
 	if [ ! -f "${kernel}" ]; then
-- 
2.27.0

