Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04212F2B53
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 10:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392594AbhALJcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 04:32:48 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10651 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390802AbhALJcs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 04:32:48 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DFQLK10Nyz15rbR;
        Tue, 12 Jan 2021 17:31:05 +0800 (CST)
Received: from DESKTOP-6NKE0BC.china.huawei.com (10.174.185.210) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 12 Jan 2021 17:31:58 +0800
From:   Kunkun Jiang <jiangkunkun@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH] kvm: Fixes lack of KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 enabled check
Date:   Tue, 12 Jan 2021 17:29:42 +0800
Message-ID: <20210112092942.2310-1-jiangkunkun@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.210]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_CLEAR_DIRTY_LOG ioctl lacks the check whether the capability
KVM_CAP_MANUAL_DIRTY_LOG_PROTECT is enabled or not. This may cause
some problems if userspace calls the KVM_CLEAR_DIRTY_LOG ioctl, but
dose't enable this capability. So we'd better to add it.

Fixes: 2a31b9db15353 ("kvm: introduce manual dirty log reprotect")
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fa9e3614d30e..8f5633d8a0e8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1602,6 +1602,9 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
+	if (!kvm->manual_dirty_log_protect)
+		return -EPERM;
+
 	/* Dirty ring tracking is exclusive to dirty log tracking */
 	if (kvm->dirty_ring_size)
 		return -ENXIO;
-- 
2.19.1

