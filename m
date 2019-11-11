Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A96F73B0
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 13:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfKKMS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 07:18:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60032 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKKMS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 07:18:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCEQUA022403;
        Mon, 11 Nov 2019 12:18:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=mn46o40bNlnHnMHAQWtCaKOscO0mRPRb40Zp9eE01xI=;
 b=EGZHbrrYotyV67VM6J6lvXs6kSMwZEZYacvcf/XuieRp3EM50S5ECcyEBXaRRZuEHkJA
 gRvB7MD0NScHOSZVj4k5C1nbtComlb0+n8b8IM8DOGDCPX5Uj4MLlxGL4eT3ylqyleyZ
 coB0zUo4e+tSSJ4OummphU9sPBW44tWKVTakIuH72zNrMzQn99NEsq85K7eHXPUqFUA8
 2urCYL5aqgUxcIPWS7M74L9WCxKa9ELMFdHS33XoQLA6A/skNdc2EGfysvO+C0hhrZ84
 qN59GKY4zojIAQnO9z/YYISqzasY/ILBWvF+x8uNUHhjmUpZmT3fSue2GepyuaJfN0XT /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w5mvter53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:18:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABC92XF026325;
        Mon, 11 Nov 2019 12:16:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w6r8jfs5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:16:16 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xABCGE2p014775;
        Mon, 11 Nov 2019 12:16:15 GMT
Received: from Lirans-MBP.Home (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 12:16:14 +0000
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, nadav.amit@gmail.com,
        Liran Alon <liran.alon@oracle.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH] KVM: VMX: Consume pending LAPIC INIT event when exit on INIT_SIGNAL
Date:   Mon, 11 Nov 2019 14:16:05 +0200
Message-Id: <20191111121605.92972-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel SDM section 25.2 OTHER CAUSES OF VM EXITS specifies the following
on INIT signals: "Such exits do not modify register state or clear pending
events as they would outside of VMX operation."

When commit 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states")
was applied, I interepted above Intel SDM statement such that
INIT_SIGNAL exit don’t consume the LAPIC INIT pending event.

However, when Nadav Amit run matching kvm-unit-test on a bare-metal
machine, it turned out my interpetation was wrong. i.e. INIT_SIGNAL
exit does consume the LAPIC INIT pending event.
(See: https://www.spinics.net/lists/kvm/msg196757.html)

Therefore, fix KVM code to behave as observed on bare-metal.

Fixes: 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states")
Reported-by: Nadav Amit <nadav.amit@gmail.com>
Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0e7c9301fe86..2c4336ac7576 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3461,6 +3461,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		if (block_nested_events)
 			return -EBUSY;
+		clear_bit(KVM_APIC_INIT, &apic->pending_events);
 		nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
 		return 0;
 	}
-- 
2.20.1

