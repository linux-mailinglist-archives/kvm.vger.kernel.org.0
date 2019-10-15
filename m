Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE15D6C8A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfJOAlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:41:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38964 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfJOAlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:41:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0dRfb191849;
        Tue, 15 Oct 2019 00:40:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=sxyKiRJ4bzUtMpCBs8jUg7kEwo3d//uN0WhGuYjqjiY=;
 b=CNzydutU/FJkT0mnT+elEWeXHhxVUQ8SjSrKM6y9z1XhxKx+JqW1Z4BERX/6bUfVh2iJ
 AXdHtK7F/8jvrYcf+6Y81bQlT88G2L5jegSbFrpoL9Iy/nSbLQUqjFJCq8cNwueIeBiw
 0qFrjbztDaC31ZIIF+eBAjTyh5NfCGH/QefHGlykxfq/4w8JD+jKbVwBmsgHBsAi6AV6
 x5svtzpq5e7EaYkHT1voCTtonjEFuqWrPbIzWEw1Sytz2GBKQ3R+YT8fHy4aguNkA1HT
 vKw6/P+fkCUMKc7uMzytDD4mozGjsDOD2GQsFSO03fOvknNL3p5WnS3JAWH2hbZKTsS0 mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vk7fr4555-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:40:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0baEf001083;
        Tue, 15 Oct 2019 00:40:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vkr9y5vcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:40:48 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9F0elk7010618;
        Tue, 15 Oct 2019 00:40:47 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 00:40:47 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com
Subject: [PATCH 0/2 v2] KVM: nVMX: Defer error from VM-entry MSR-load area to until after hardware verifies VMCS guest state-area
Date:   Mon, 14 Oct 2019 20:04:44 -0400
Message-Id: <20191015000446.8099-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=850
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=927 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150005
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
        1. In patch# 1, the invalid VM-entry MSR-load area for vmcs02 is 
           now a system-wide entity. It is allocated and initialized 
           during VMX initialization. The exit qualification is now
           contained in a 32-bit variable in 'struct nested_vmx'.
        2. Patch# 2 is new. It rolls back MSR updates when VM-entry
           fails due to invalid VM-entry MSR-load area.


Some VM-entry checks can be offloaded from KVM to hardware. But if we want to
do that, the current implementation of KVM creates a priority issue where the
order in which VM-entry checks need to be performed according to the SDM, is
not maintained. VM-entry fails in nested_vmx_enter_non_root_mode() if an error
is encountered while processing the entries in VM-entry MSR-load area. This
leads to VM-exit due to a VM-entry check that is supposed to be done after
any guest-state checks done in hardware. This patch fixes this priority issue
so that checks that can be offloaded to hardware can now be offloaded.


[PATCH 1/2 v2] nVMX: Defer error from VM-entry MSR-load area to until
[PATCH 2/2 v2] nVMX: Rollback MSR-load if VM-entry fails due to VM-entry

 arch/x86/kvm/vmx/nested.c | 84 +++++++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/nested.h | 29 ++++++++++++++--
 arch/x86/kvm/vmx/vmx.c    | 18 ++++++++++
 arch/x86/kvm/vmx/vmx.h    | 14 ++++++++
 4 files changed, 136 insertions(+), 9 deletions(-)

Krish Sadhukhan (2):
      nVMX: Defer error from VM-entry MSR-load area to until after hardware verifies VMCS guest state-area
      nVMX: Rollback MSR-load if VM-entry fails due to VM-entry MSR-loading

