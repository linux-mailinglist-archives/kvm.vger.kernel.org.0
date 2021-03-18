Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB7F340614
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhCRMuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:50:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64562 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230169AbhCRMu3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 08:50:29 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ICXbTe073086;
        Thu, 18 Mar 2021 08:50:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=wy7Ore6Cp8Ux222orPtud4aOxSWm5tRjOCOuomNuypA=;
 b=RuCxw1fnO+is0b6Qfg1x/De7moTE0oHyfBNOY6W99MoKOh66eSrdl4YAYwl+fFlIQEsr
 oo4rl/l7l6O/rt4M/tqNvLVaMr+vHfvzcwOX8ZOWYpViv/fNEL6Ko+j/TeVYvrxSYMUE
 rvtCYAHxgsT/6ypVnXWJHQbOnr0Ib3zjzh3aro5bQVgy83cQzB1m8iO7bWljvZbxZyUa
 //Vp3Rf5XxUJbW75zPS8FOZXg2Lrhh28lGLO4/pzd7sgJzKH+SOynNvnMvkQy7E/thfN
 DQctn2N7llASy9qnqgZkbJRF6ikhAvJxOZt3WcWby4UDjvzYXZ5lIpKd3mkcqg+/wMWf SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnrn4fc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 08:50:29 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ICXpUJ074455;
        Thu, 18 Mar 2021 08:50:28 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnrn4fbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 08:50:28 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12ICmjXR007435;
        Thu, 18 Mar 2021 12:50:26 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 37b30p1m2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 12:50:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12ICoOtI328306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 12:50:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87866A4053;
        Thu, 18 Mar 2021 12:50:24 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A11CA4051;
        Thu, 18 Mar 2021 12:50:23 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.24.61])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 12:50:23 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/3] scripts: Fix PV run handling
Date:   Thu, 18 Mar 2021 12:50:12 +0000
Message-Id: <20210318125015.45502-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are some issues that make our current PV handling in
run_tests.sh and s390x/run a bit awkward:

 * With ACCEL=tcg or if KVM is not available we will try to run PV
   tests which won't work
 * If a host key cert has been specified but it does not exists then
   the compilation will break

This series is based on the common script fixes I just sent out.

Janosch Frank (3):
  s390x: Don't run PV testcases under tcg
  configure: s390x: Check if the host key document exists
  s390x: run: Skip PV tests when tcg is the accelerator

 configure               | 5 +++++
 s390x/run               | 5 +++++
 scripts/s390x/func.bash | 3 +++
 3 files changed, 13 insertions(+)

-- 
2.27.0

