Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3336B5A71A
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2019 00:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfF1Wms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 18:42:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51748 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfF1Wms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 18:42:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SMYLMa075151;
        Fri, 28 Jun 2019 22:42:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=nfLpJNxJUE+L5vkClBN4y7PdNUNvJNhI7FncPZTssvY=;
 b=s8X56/6TtrNnolL2RnPoh3UARSRhoOqQuJEKqwWSDNl2gpGWyNLGmzXE1BUlydFEmQHd
 G7vDKMC205DnLDOOZZdq3XZsQ4ZgJoS/6U9ktD4VUeW4e5Wy44V47WkwL/btH9+RIntE
 mngTbM9xHtJudNWhlWtedb2/D0oC7AIQ2qGIjxgaZ4D8Vm7JJKzH/XBdIp5FkqZJ42Oz
 WOspNEFBWFjJPJ99frgk/wFHWxAFXYnAzPXanraaWW5OHFr2KSB/Pa2diQbo6EoLiiS8
 Tnmwx1qdJMery7Fah0SBh21BjMOj0J/f97Ce9VTglviRXN0KkWQentW6yHpQHnn3m53D uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t9brtqsax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 22:42:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SMgY6u117989;
        Fri, 28 Jun 2019 22:42:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tat7e68t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 22:42:41 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5SMgebI006158;
        Fri, 28 Jun 2019 22:42:40 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Jun 2019 15:42:40 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 0/2] nVMX: Check Host Segment Registers and Descriptor Tables on vmentry of nested guests
Date:   Fri, 28 Jun 2019 18:14:45 -0400
Message-Id: <20190628221447.23498-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=303
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906280260
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=349 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906280259
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch# 1 implements the following checks, from Intel SDM vol 3C, on
vmentry of nested guests:

   - In the selector field for each of CS, SS, DS, ES, FS, GS and TR, the
     RPL (bits 1:0) and the TI flag (bit 2) must be 0.
   - The selector fields for CS and TR cannot be 0000H.
   - The selector field for SS cannot be 0000H if the "host address-space
     size" VM-exit control is 0.
   - On processors that support Intel 64 architecture, the base-address
     fields for FS, GS and TR must contain canonical addresses.

Patch# 2 adds kvm-unit-tests for the above checks.


[PATCH 1/2] KVM nVMX: Check Host Segment Registers and Descriptor Tables on
[PATCH 2/2] kvm-unit-test nVMX: Test Host Segment Registers and Descriptor Tables on

 arch/x86/kvm/vmx/nested.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

Krish Sadhukhan (1):
      nVMX: Check Host Segment Registers and Descriptor Tables on vmentry of nested guests

 x86/vmx_tests.c     | 159 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+)

Krish Sadhukhan (1):
      nVMX: Test Host Segment Registers and Descriptor Tables on vmentry of nested guests

