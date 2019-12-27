Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F5212B424
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2019 12:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfL0LDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Dec 2019 06:03:48 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8631 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726053AbfL0LDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Dec 2019 06:03:48 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 515ADEBF5F34B339D376;
        Fri, 27 Dec 2019 19:03:45 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Fri, 27 Dec 2019 19:03:37 +0800
From:   Zeng Tao <prime.zeng@hisilicon.com>
To:     <pbonzini@redhat.com>, <drjones@redhat.com>
CC:     <kvm@vger.kernel.org>, <xuwei5@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>,
        Zeng Tao <prime.zeng@hisilicon.com>
Subject: [kvm-unit-tests PATCH] devicetree: Fix the dt_for_each_cpu_node
Date:   Fri, 27 Dec 2019 19:03:35 +0800
Message-ID: <1577444615-26720-1-git-send-email-prime.zeng@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the /cpus node contains nodes other than /cpus/cpu*, for example:
/cpus/cpu-map/. The test will issue an unexpected assert error as
follow:
[root@localhost]# ./arm-run arm/spinlock-test.flat
qemu-system-aarch64 -nodefaults -machine virt,gic-version=host,accel=kvm
 -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd
-chardev testdev,id=ctd -device pci-testdev -display none -serial stdio
-kernel arm/spinlock-test.flat # -initrd /tmp/tmp.mwPLiF4EWm
lib/arm/setup.c:64: assert failed: ret == 0
        STACK:

In this patch, ignore the non-cpu subnodes instead of return an error.

Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
---
 lib/devicetree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/devicetree.c b/lib/devicetree.c
index 2b89178..1020324 100644
--- a/lib/devicetree.c
+++ b/lib/devicetree.c
@@ -225,7 +225,7 @@ int dt_for_each_cpu_node(void (*func)(int fdtnode, u64 regval, void *info),
 
 		prop = fdt_get_property(fdt, cpu, "device_type", &len);
 		if (prop == NULL)
-			return len;
+			continue;
 
 		if (len != 4 || strcmp((char *)prop->data, "cpu"))
 			continue;
-- 
1.8.3.1

