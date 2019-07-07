Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F019861444
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2019 09:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfGGHle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jul 2019 03:41:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36754 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfGGHle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jul 2019 03:41:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x677d3tn162955;
        Sun, 7 Jul 2019 07:41:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=Ya8c2WvPLtn5i5rAFBSXIiY+pNSri0h+wqokQKn4M8g=;
 b=IhcD754gRijbmoNazIKXQOFECvsm6ErDQFSGM1YDoMZj//gvpryuWHjixLI9tAZIk9tR
 QhmjCIb+oX9zRUTYDnfXtgUYcQ8ZQL8j207UljAvcN+eQaoLKjJcQqi0XqZyD/yG9RZ+
 MLqtbIJoZqNcSCGGOY84qb6yB3jxteVgQj01ZkQLpM43QTd5Ia67oZl3ZRSIUCEeMHTN
 jZLDukOObloM1uIvaHC71912DxdU7xPt7H7XpZamgtlOFIQUHn+C+slSm3eo9p+o30hu
 LlmAcLqoD7XFUizSpb7kfBeOzqTx+9/wHPBAwaUt7/T9BCnK611dMBxlxs6baNgPEG9W ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2tjk2taay9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 07:41:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x677bulI058158;
        Sun, 7 Jul 2019 07:39:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tjgrt3x1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 07:39:22 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x677dLBt014572;
        Sun, 7 Jul 2019 07:39:21 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jul 2019 07:39:20 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 0/5] KVM: nVMX: Skip vmentry checks that are necessary only if VMCS12 is dirty
Date:   Sun,  7 Jul 2019 03:11:42 -0400
Message-Id: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=319
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907070104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=367 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907070104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following functions,

	nested_vmx_check_controls
	nested_vmx_check_host_state
	nested_vmx_check_guest_state

do a number of vmentry checks for VMCS12. However, not all of these checks need
to be executed on every vmentry. This patchset makes some of these vmentry
checks optional based on the state of VMCS12 in that if VMCS12 is dirty, only
then the checks will be executed. This will reduce performance impact on
vmentry of nested guests.


[PATCH 1/5] KVM: nVMX: Skip VM-Execution Control vmentry checks that are
[PATCH 2/5] KVM: nVMX: Skip VM-Exit Control vmentry checks that are
[PATCH 3/5] KVM: nVMX: Skip VM-Entry Control checks that are necessary
[PATCH 4/5] KVM: nVMX: Skip Host State Area vmentry checks that are
[PATCH 5/5] KVM: nVMX: Skip Guest State Area vmentry checks that are

 arch/x86/kvm/vmx/nested.c | 149 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 111 insertions(+), 38 deletions(-)

Krish Sadhukhan (5):
      nVMX: Skip VM-Execution Control vmentry checks that are necessary only if VMCS12 is dirty
      nVMX: Skip VM-Exit Control vmentry checks that are necessary only if VMCS12 is dirty
      nVMX: Skip VM-Entry Control checks that are necessary only if VMCS12 is dirty
      nVMX: Skip Host State Area vmentry checks that are necessary only if VMCS12 is dirty
      nVMX: Skip Guest State Area vmentry checks that are necessary only if VMCS12 is dirty

