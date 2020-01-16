Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655F713D189
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 02:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgAPBbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 20:31:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57960 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbgAPBbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 20:31:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G1Ujfr012744;
        Thu, 16 Jan 2020 01:31:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=6jxd9Fk5Y4ntwdDAXooxwdtLtWDkZZ/v2lQ6bDXbZzk=;
 b=dLPkorPVHsgZzd2ka15buvY1WkogWYOU+rHxHmYWRtG9vGO+/0kKzC6rcL4x5n5wDW1p
 QZUSCW4UpsPNT7VYKr0/YaAZtCedk4iK05GY4jsM3fSygGHaxcmu0CN7X+8ARvFtuv5b
 jtDwG+yxUbKm1v1qO8wsl//AjZnE2NhUQuLfTPjVzUYbE7nTctWjvKi3eKPu2pDsaisB
 tv41r8uCN6Oe1lxoUgGHd36ofG5ojE+MA45q2rcnLGaI3x88LLIUtSSYBQ/YKSN5WRDO
 rgQnA22E7IwmihLaaxqx5Te+9uZQK4pBaCvOxryg7zrtan2CIHjy4eWC32RNOVw+MXSp tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xf73tykem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 01:31:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G1UkgW016072;
        Thu, 16 Jan 2020 01:31:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xj1as8601-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 01:31:33 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G1VVDX027951;
        Thu, 16 Jan 2020 01:31:32 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 17:31:31 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 0/2 v3] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
Date:   Wed, 15 Jan 2020 19:54:31 -0500
Message-Id: <20200116005433.5242-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=788
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=848 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160010
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2 -> v3:
	The following changes have been made to patch# 1:
	  i) Commit message body mentions the reason for doing this check in
	     software.
	  i) The CONFIG_X86_64 guard in nested_vmx_check_guest_state() is
	     removed.
	  ii) The data type of the parameter to kvm_dr7_valid() is
	      'unsigned long'.


[PATCH 1/2 v3] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
[PATCH 2/2 v3] kvm-unit-test: nVMX: Test GUEST_DR7 on vmentry of nested guests

 arch/x86/kvm/vmx/nested.c | 4 ++++
 arch/x86/kvm/x86.c        | 2 +-
 arch/x86/kvm/x86.h        | 6 ++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

Krish Sadhukhan (1):
      nVMX: Check GUEST_DR7 on vmentry of nested guests

 x86/vmx_tests.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

Krish Sadhukhan (1):
      nVMX: Test GUEST_DR7 on vmentry of nested guests

