Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D53C2B33
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 02:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731781AbfJAAMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 20:12:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33730 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731180AbfJAAMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 20:12:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x910CTr5016221;
        Tue, 1 Oct 2019 00:12:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=pbBcT1CvpMxQGXeCx8JUrXG+ZpeY1YqFtDqk4vobi9s=;
 b=nxpJwVZY/S9Xnt1ZsvteIOdVkl2w3fdmaDll0qxo5K9n3qBC5sRP3T0PHwoT6qwqffwO
 Zw27clL0pbGnUtmE+7hw6MVXh1ABAd/Z9OFUhAckufvWeGWOYxLq/+op9in/1A46CCUz
 wSK20sw9teOTbhSfsChT9uIlzvdeUaP2tWiule6MQ4v//B2lTKwUPlv04BYoGHMxdu0W
 O2/zIlsVpsk3e4TcdG9s+Azpo8QFfsVl1GcGz6ry0YLAaO4IaVBzqq10E8Y17sgKELdR
 hbS37bfSgcndhfRuJUGKDn5bZdynQgY2moKjy2PHIpGFhWinsfUf5zaj/T9iHvei/oNG /g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v9xxujgcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 00:12:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9109t11127005;
        Tue, 1 Oct 2019 00:12:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vbmpx9xa6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 00:12:23 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x910CMnm025084;
        Tue, 1 Oct 2019 00:12:22 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 17:12:22 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com
Subject: [PATCH] KVM: nVMX: Defer error from VM-entry MSR-load area to until after hardware verifies VMCS guest state-area
Date:   Mon, 30 Sep 2019 19:36:25 -0400
Message-Id: <20190930233626.22852-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=694
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=776 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some VM-entry checks can be offloaded from KVM to hardware. But if we want to
do that, the current implementation of KVM creates a priority issue where the
order in which VM-entry checks need to be performed according to the SDM, is
not maintained. VM-entry fails in nested_vmx_enter_non_root_mode() if an error
is encountered while processing the entries in VM-entry MSR-load area. This
leads to VM-exit due to a VM-entry check that is supposed to be done after
any guest-state checks done in hardware. This patch fixes this priority issue
so that checks that can be offloaded to hardware can now be offloaded.


[PATCH] nVMX: Defer error from VM-entry MSR-load area to until after
 
 arch/x86/kvm/vmx/nested.c | 34 +++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/nested.h | 14 ++++++++++++--
 arch/x86/kvm/vmx/vmcs.h   |  6 ++++++
 3 files changed, 49 insertions(+), 5 deletions(-)

Krish Sadhukhan (1):
      nVMX: Defer error from VM-entry MSR-load area to until after hardware verifies VMCS guest state-area

