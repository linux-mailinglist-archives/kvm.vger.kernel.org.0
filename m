Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EB434920A
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 13:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhCYMai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 08:30:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231244AbhCYMaM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 08:30:12 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PCEK6Q191953
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 08:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=OCU5on0LmOLgCaV4hQezQCH2sdjoA4QqdpPkEafMZZU=;
 b=WvenQ51BkeLv3u/dbqLG1amtiC3GH6Qu42Kl3guGSRETOfa67c3OOmq6SMtXVTlJDfud
 Kxu2XqdLU86LZTBzWXOpaXcp1bCGVyew3TtOVT6vObSJmpsz9AbcUKkn0aElD3+mUoEz
 PxUOzzm+y6OZYWucIi6kJS+Dero1PkrUb9pDlbwLCYeCJ4CaV9ZnLvqxct7QijejgILj
 NOE32PsNjHSuYan/2KqcdB1iDI1dwK09QFstT3F6IKwxJmvae4stt+BiwXZs8IVk1asU
 Yzub+EeWgwVSQZ57vOQFVv9H+KrQOTH6y96N/bAOlcEQf8K0u6a4aNqe/7rrbjrLe+DH cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gpjv73ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 08:30:07 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PCI5Z9018133
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 08:30:06 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gpjv73f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 08:30:06 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PCSQ9m028433;
        Thu, 25 Mar 2021 12:30:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 37d99xjtgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 12:30:04 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PCThnh26935662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 12:29:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EA40A405D;
        Thu, 25 Mar 2021 12:30:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BF95A4053;
        Thu, 25 Mar 2021 12:30:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 12:30:01 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, pbonzini@redhat.com
Subject: [PATCH] tools/kvm_stat: Add restart delay
Date:   Thu, 25 Mar 2021 13:29:49 +0100
Message-Id: <20210325122949.1433271-1-raspl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_02:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1011 impostorscore=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 phishscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If this service is enabled and the system rebooted, Systemd's initial
attempt to start this unit file may fail in case the kvm module is not
loaded. Since we did not specify a delay for the retries, Systemd
restarts with a minimum delay a number of times before giving up and
disabling the service. Which means a subsequent kvm module load will
have kvm running without monitoring.
Adding a delay to fix this.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat.service | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/kvm/kvm_stat/kvm_stat.service b/tools/kvm/kvm_stat/kvm_stat.service
index 71aabaffe779..8f13b843d5b4 100644
--- a/tools/kvm/kvm_stat/kvm_stat.service
+++ b/tools/kvm/kvm_stat/kvm_stat.service
@@ -9,6 +9,7 @@ Type=simple
 ExecStart=/usr/bin/kvm_stat -dtcz -s 10 -L /var/log/kvm_stat.csv
 ExecReload=/bin/kill -HUP $MAINPID
 Restart=always
+RestartSec=60s
 SyslogIdentifier=kvm_stat
 SyslogLevel=debug
 
-- 
2.25.1

