Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F27C26035C
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbgIGMrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 08:47:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31622 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729233AbgIGMr3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Sep 2020 08:47:29 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087CXLZP075524;
        Mon, 7 Sep 2020 08:47:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=2RyC8LYAhiLnnCHqOK/2SaSmB1wB57P8mu9LBs+Qtgg=;
 b=l5z76WXE7cr7A7p3ZL/4riG9e7G1BC9BKaCdQWp4/ZCf5te6NslMqXuU+2DdiIV5UfLx
 5YoPCewxvumNa3Sh3B74i+6EfEDl3ZqONqmwWSG5aY8qHt2ctMhnTDsG+2PQ/aastCij
 hgIQkS1NbXlntYUbwF94H7n8mpU3FO4x0wKnYtTfUPWWkYPgCCCiWbzo0ylLc4epdHl6
 WEQ1V4HCLxNJPcLMjBHWlFBmFaOO69vm6bKWGYr4uT1ehoFgNc8+3DGtq9mEFYEYzmqX
 tn0Dz0VbQ8bLgKGC88R05HPtFdxa6J1/n3jBwzEkLak6xEBwHYvsMTMBzNAjNNhVCmK9 HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33dkc4axvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 08:47:08 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 087CXMDe075593;
        Mon, 7 Sep 2020 08:47:08 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33dkc4axve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 08:47:08 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 087CfamK025350;
        Mon, 7 Sep 2020 12:47:06 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 33c2a82d5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 12:47:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 087Cl3W661276656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Sep 2020 12:47:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCA314C058;
        Mon,  7 Sep 2020 12:47:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB62A4C046;
        Mon,  7 Sep 2020 12:47:02 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Sep 2020 12:47:02 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     borntraeger@de.ibm.com, gor@linux.ibm.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, david@redhat.com, hca@linux.ibm.com
Subject: [PATCH v2 0/2] s390x: pv: Fixes and improvements
Date:   Mon,  7 Sep 2020 08:46:58 -0400
Message-Id: <20200907124700.10374-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_07:2020-09-07,2020-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 suspectscore=1 malwarescore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxlogscore=742 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using the destroy call instead of the export on a VM shutdown, we can
clear out a protected guest much faster.

The 3f exception can in fact be triggered by userspace and therefore
should not panic the whole system, but send a SIGSEGV to the culprit
process.

v2:
	* Removed whitespace damage
	* Directly access task struct for pid and comm
	* Removed NOKPROBE_SYMBOL

Janosch Frank (2):
  s390x: uv: Add destroy page call
  s390x: Add 3f program exception handler

 arch/s390/include/asm/uv.h   |  7 +++++++
 arch/s390/kernel/pgm_check.S |  2 +-
 arch/s390/kernel/uv.c        | 20 ++++++++++++++++++++
 arch/s390/mm/fault.c         | 20 ++++++++++++++++++++
 arch/s390/mm/gmap.c          |  2 +-
 5 files changed, 49 insertions(+), 2 deletions(-)

-- 
2.25.1

