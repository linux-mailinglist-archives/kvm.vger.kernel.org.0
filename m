Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31EB71B646
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 14:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfEMMqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 08:46:45 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50668 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729902AbfEMMqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 08:46:45 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 718BCA2345FBE687C237;
        Mon, 13 May 2019 20:46:43 +0800 (CST)
Received: from ros.huawei.com (10.143.28.118) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Mon, 13 May 2019 20:46:32 +0800
From:   Dongjiu Geng <gengdongjiu@huawei.com>
To:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
Subject: [PATCH v16 01/10] hw/arm/virt: Add RAS platform version for migration
Date:   Mon, 13 May 2019 05:42:59 -0700
Message-ID: <1557751388-27063-2-git-send-email-gengdongjiu@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557751388-27063-1-git-send-email-gengdongjiu@huawei.com>
References: <1557751388-27063-1-git-send-email-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.143.28.118]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support this feature since version 4.1, disable it by
default in the old version.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 hw/arm/virt.c         | 6 ++++++
 include/hw/arm/virt.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 5331ab7..7bdd41b 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2043,8 +2043,14 @@ DEFINE_VIRT_MACHINE_AS_LATEST(4, 1)
 
 static void virt_machine_4_0_options(MachineClass *mc)
 {
+    VirtMachineClass *vmc = VIRT_MACHINE_CLASS(OBJECT_CLASS(mc));
+
     virt_machine_4_1_options(mc);
     compat_props_add(mc->compat_props, hw_compat_4_0, hw_compat_4_0_len);
+    /* Disable memory recovery feature for 4.0 as RAS support was
+     * introduced with 4.1.
+     */
+    vmc->no_ras = true;
 }
 DEFINE_VIRT_MACHINE(4, 0)
 
diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
index 4240709..7f1a033 100644
--- a/include/hw/arm/virt.h
+++ b/include/hw/arm/virt.h
@@ -104,6 +104,7 @@ typedef struct {
     bool disallow_affinity_adjustment;
     bool no_its;
     bool no_pmu;
+    bool no_ras;
     bool claim_edge_triggered_timers;
     bool smbios_old_sys_ver;
     bool no_highmem_ecam;
-- 
1.8.3.1

