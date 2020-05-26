Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772641AB14B
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 21:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504366AbgDOTLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 15:11:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45670 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411816AbgDOTLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 15:11:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03FJ81im062677;
        Wed, 15 Apr 2020 19:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=m8H6UtNxuTOBnymt60AMZmFjPxTy2lbQkSEA1KZ4W5s=;
 b=UpDarNnsVSUHyUXseT4Ljz4tZmRW4s+JuxLdWy5kjJM66k2agHWpdE/bVSch4x0kgBy/
 7s6NuJu5Og8YyLg+9d0LxKUt/r6It6zQO20yGcnaVv+2XZITMmI9tNSdb8CRGvTIAkDR
 yNz5UZ/bTpKRsEIIB4khqIODF1tFYyDabeipMqqbqeAaKz5vILry+aEql85EF5HHUnb1
 AbzvuMHF8Kn+KsZ5VQn3VKrje0eRF6goiNtW8xhqdmMdEedoCdQf+DKjJ+SRxQjfiory
 wYs/Qi427kzArpVXWx6bKq7JXaRm3ffeD4Y+ITQvMe8qjS3i5nxkcOJGsQhD62AcoeaN 7g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30e0bfattg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 19:11:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03FJ7I8f194297;
        Wed, 15 Apr 2020 19:11:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30dn8wuaqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 19:11:02 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03FJB2gs022938;
        Wed, 15 Apr 2020 19:11:02 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Apr 2020 12:11:02 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 0/2 v2] kvm-unit-test: nVMX: Test Selector and Base Address fields of Guest Segment registers
Date:   Wed, 15 Apr 2020 14:30:45 -0400
Message-Id: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=859
 suspectscore=13 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 mlxlogscore=911
 impostorscore=0 adultscore=0 suspectscore=13 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	1. A KVM fix has been added via patch# 1. This fix is required to test
	   the unsetting of "unrestricted guest" VM-execution control in
	   vmcs12.
	2. The kvm-unit-test has been enhanced by adding more combinations of
	   the conditions mentioned in the vmentry checks being tested here.
   

[PATCH 1/2 v2] KVM: nVMX: KVM needs to unset "unrestricted guest" VM-execution
[PATCH 2/2 v2] kvm-unit-tests: nVMX: Test Selector and Base Address fields of Guest Segment

 arch/x86/kvm/vmx/nested.c | 3 +++
 1 file changed, 3 insertions(+)

Krish Sadhukhan (1):
      nVMX: KVM needs to unset "unrestricted guest" VM-execution control in vmcs02 if vmcs12 doesn't set it

 Makefile            |   2 +-
 lib/x86/processor.h |   1 +
 x86/vmx_tests.c     | 201 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 203 insertions(+), 1 deletion(-)

Krish Sadhukhan (1):
      nVMX: Test Selector and Base Address fields of Guest Segment Registers on vmentry of nested guests

