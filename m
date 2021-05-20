Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABA7389B98
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 05:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhETDHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 23:07:11 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4759 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhETDHL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 23:07:11 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Flvff052jzqV3M;
        Thu, 20 May 2021 11:02:18 +0800 (CST)
Received: from dggpemm000003.china.huawei.com (7.185.36.128) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 11:05:33 +0800
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 dggpemm000003.china.huawei.com (7.185.36.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 11:05:32 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>
CC:     <wanghaibin.wang@huawei.com>, <zhang.zhanghailiang@huawei.com>,
        <gaojinhao@huawei.com>
Subject: [PATCH] KVM: halt polling: Make the adjustment of polling time clearer
Date:   Thu, 20 May 2021 11:05:29 +0800
Message-ID: <20210520030529.22048-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.224]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm000003.china.huawei.com (7.185.36.128)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we have "block_ns > halt_poll_ns" and "block_ns < max_halt_poll_ns",
then "halt_poll_ns < max_halt_poll_ns" is true, so we can drop this extra
condition.

We want to make sure halt_poll_ns is not zero before shrinking it. Put
the condition in shrinking primitive can make code clearer.

None functional change.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 Documentation/virt/kvm/halt-polling.rst | 21 ++++++++++-----------
 virt/kvm/kvm_main.c                     | 11 ++++++-----
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/virt/kvm/halt-polling.rst b/Documentation/virt/kvm/halt-polling.rst
index 4922e4a15f18..d9f699395a7f 100644
--- a/Documentation/virt/kvm/halt-polling.rst
+++ b/Documentation/virt/kvm/halt-polling.rst
@@ -47,17 +47,16 @@ Thus this is a per vcpu (or vcore) value.
 During polling if a wakeup source is received within the halt polling interval,
 the interval is left unchanged. In the event that a wakeup source isn't
 received during the polling interval (and thus schedule is invoked) there are
-two options, either the polling interval and total block time[0] were less than
-the global max polling interval (see module params below), or the total block
-time was greater than the global max polling interval.
-
-In the event that both the polling interval and total block time were less than
-the global max polling interval then the polling interval can be increased in
-the hope that next time during the longer polling interval the wake up source
-will be received while the host is polling and the latency benefits will be
-received. The polling interval is grown in the function grow_halt_poll_ns() and
-is multiplied by the module parameters halt_poll_ns_grow and
-halt_poll_ns_grow_start.
+two options, either the total block time[0] were less than the global max
+polling interval (see module params below), or the total block time was greater
+than the global max polling interval.
+
+In the event that the total block time were less than the global max polling
+interval then the polling interval can be increased in the hope that next time
+during the longer polling interval the wake up source will be received while the
+host is polling and the latency benefits will be received. The polling interval
+is grown in the function grow_halt_poll_ns() and is multiplied by the module
+parameters halt_poll_ns_grow and halt_poll_ns_grow_start.
 
 In the event that the total block time was greater than the global max polling
 interval then the host will never poll for long enough (limited by the global
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6b4feb92dc79..13a9996c4ccb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2906,6 +2906,9 @@ static void shrink_halt_poll_ns(struct kvm_vcpu *vcpu)
 	unsigned int old, val, shrink;
 
 	old = val = vcpu->halt_poll_ns;
+	if (!old)
+		return;
+
 	shrink = READ_ONCE(halt_poll_ns_shrink);
 	if (shrink == 0)
 		val = 0;
@@ -3003,12 +3006,10 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 			if (block_ns <= vcpu->halt_poll_ns)
 				;
 			/* we had a long block, shrink polling */
-			else if (vcpu->halt_poll_ns &&
-					block_ns > vcpu->kvm->max_halt_poll_ns)
+			else if (block_ns > vcpu->kvm->max_halt_poll_ns)
 				shrink_halt_poll_ns(vcpu);
-			/* we had a short halt and our poll time is too small */
-			else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
-					block_ns < vcpu->kvm->max_halt_poll_ns)
+			/* we had a short block, grow polling */
+			else if (block_ns < vcpu->kvm->max_halt_poll_ns)
 				grow_halt_poll_ns(vcpu);
 		} else {
 			vcpu->halt_poll_ns = 0;
-- 
2.19.1

