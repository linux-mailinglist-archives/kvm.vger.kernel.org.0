Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4641D45B3
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 08:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgEOGQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 02:16:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54806 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgEOGQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 02:16:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F6GZ6A158181;
        Fri, 15 May 2020 06:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=uiCA5nOBPKm6rXTYXKWytlWJF6Ig9pQol4RCZ9UiRoo=;
 b=qm6xtWB51V1coW2aj3PuXJrfqv7d7coDUiVcHtxYxumv0AYWAY3IODNJx3EI8Q6ELx8f
 H+lVJ7gyGgh8bKeIqOz6HVFKIuSeyZIAdMcOkyMFP/4vKAJ5y6+wIYWH6Z39cyIRvXgu
 q2hqQv4PS2rs15FkC5/LaZ/cCJ/AIoNOePTm+t2J73jTFVeBNTHX9OaS1PTwnlsfJ3oc
 PyHgSykK+dZuTIgSs7BG0CMWf9usqN0KewQG6l8/JYzoxI5Ahng+NY9FWHQJcK9vxyI9
 pWJakCOvNl+msmqH8FalEzj+AOCExJQcD7UVqV13HaFdIn7ZZ4Y9Bj/Xp8rcI0rWGxHc 4A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3100yg7sqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 06:16:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F68khG066210;
        Fri, 15 May 2020 06:16:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 310vjv6j9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 06:16:44 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04F6GiLd014395;
        Fri, 15 May 2020 06:16:44 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 23:16:44 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 0/3 v3] KVM: nSVM: Check MBZ bits in CR3 and CR4 on vmrun of nested guests
Date:   Fri, 15 May 2020 01:36:06 -0400
Message-Id: <20200515053609.3347-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxlogscore=880 malwarescore=0 suspectscore=1 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=1 spamscore=0 impostorscore=0
 mlxlogscore=902 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150053
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2 -> v3:
	In patch# 1, the mask for guest CR4 reserved bits is now cached in
	'struct kvm_vcpu_arch', instead of in a global variable.


[PATCH 1/3 v3] KVM: x86: Create mask for guest CR4 reserved bits in
[PATCH 2/3 v3] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not set on
[PATCH 3/3 v3] KVM: nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmrun

 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/cpuid.c            |  2 ++
 arch/x86/kvm/svm/nested.c       | 22 ++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h          |  5 ++++-
 arch/x86/kvm/x86.c              | 27 ++++-----------------------
 arch/x86/kvm/x86.h              | 21 +++++++++++++++++++++
 6 files changed, 53 insertions(+), 26 deletions(-)

Krish Sadhukhan (2):
      KVM: x86: Create mask for guest CR4 reserved bits in kvm_update_cpuid()
      nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun of nested gu

 x86/svm.h       |   6 ++++
 x86/svm_tests.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 99 insertions(+), 12 deletions(-)

Krish Sadhukhan (1):
      nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmrun of nested g

