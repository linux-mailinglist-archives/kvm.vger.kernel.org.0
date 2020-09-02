Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4351025B6CE
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 00:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgIBW6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 18:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBW6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 18:58:02 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77119C061244;
        Wed,  2 Sep 2020 15:58:00 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ds1so519258pjb.1;
        Wed, 02 Sep 2020 15:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XZfw6QbTtE+ig8bz903vOGLjPWd35/ECsGMavmJuypY=;
        b=EFn8sagTMorsR5/jkl/wUofpzJmbCPIma0wCVK84yaTwpnJ0l8C3ts/7jqq3C2xlEF
         Mpen5Hj9djCLDx2DsJFshyL850GLlzwEW7n980XuQxPnOevT5XUhqm6y3Mxe3HOhB4IW
         7/z9HA+7wxuB8DpHWsFDtsuXt+6RWXSQxekf3ylJLDEmH10J/5SBpkEPBo1HEguiG+uu
         4EBV/aFxXe7Dtq/qr5s7s06yPVQ0McfqyyC0WT0cGe6/DNB/5PhyOhOHwZgYVvMEbmdF
         0gCrIRyDbf+WFHAHC9pXCp5wu+6kk3x1cYKi/RCLHz7ZNPvBfvYevy6c1MxGDmv3I3+3
         A+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XZfw6QbTtE+ig8bz903vOGLjPWd35/ECsGMavmJuypY=;
        b=o3HTeoQJtlHEdT+I+wb5Op6otuXQcD1kPGuBNSckTcpipezG8Gze1cLwIX/efnR4lb
         Ntu4aZCwo7v9QM9dvWZrpcXo8T2y0AbtegpCime6d4GNbBiEXDBCTYuKh1rzlKCuPD2S
         TaVkSbFITLe8571jiKEStZpTzRLxAbrShc9TJjvWYJCkMYgyEJRlIIQnECiY6XO+w/L7
         UWXPCL07VUbxYs6t2al/wU7+V1WJ34vrn3ur1ZndDDiqi5EehGcD7UaVda6w2cI1np2j
         b978qSOnHdJHJb2nQi1m9c+fuI4VDLWZdwpiB98z6F6vZZMTZIrv3Ih4fi1Z3Dyhcks4
         /rQg==
X-Gm-Message-State: AOAM532Iz0OjyHRQx2i6u8vICVflEU4Vv2SrOcrSKXN/o3YVDI1mFRr5
        rna3HpK+WO9Nnm1b0TtfMCNsdGwliL0wrQ==
X-Google-Smtp-Source: ABdhPJxJ5NCMU7pH1XkDZ7sFHsPUW3bZZckDyxeLpb3i6oVBoc5ezbFSE4vP8Iz4R0KyUAqxXWSf4Q==
X-Received: by 2002:a17:90a:4486:: with SMTP id t6mr27512pjg.230.1599087479949;
        Wed, 02 Sep 2020 15:57:59 -0700 (PDT)
Received: from thinkpad.teksavvy.com (104.36.148.139.aurocloud.com. [104.36.148.139])
        by smtp.gmail.com with ESMTPSA id q25sm579175pfn.181.2020.09.02.15.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 15:57:05 -0700 (PDT)
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Rustam Kovhaev <rkovhaev@gmail.com>
Subject: [PATCH v2] KVM: fix memory leak in kvm_io_bus_unregister_dev()
Date:   Wed,  2 Sep 2020 15:57:18 -0700
Message-Id: <20200902225718.675314-1-rkovhaev@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

when kmalloc() fails in kvm_io_bus_unregister_dev(), before removing
the bus, we should iterate over all other devices linked to it and call
kvm_iodevice_destructor() for them

Reported-and-tested-by: syzbot+f196caa45793d6374707@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=f196caa45793d6374707
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
v2:
- remove redundant whitespace
- remove goto statement and use if/else
---
 virt/kvm/kvm_main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67cd0b88a6b6..cf88233b819a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4332,7 +4332,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 			       struct kvm_io_device *dev)
 {
-	int i;
+	int i, j;
 	struct kvm_io_bus *new_bus, *bus;
 
 	bus = kvm_get_bus(kvm, bus_idx);
@@ -4349,17 +4349,20 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 
 	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
 			  GFP_KERNEL_ACCOUNT);
-	if (!new_bus)  {
+	if (new_bus) {
+		memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
+		new_bus->dev_count--;
+		memcpy(new_bus->range + i, bus->range + i + 1,
+		       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
+	} else {
 		pr_err("kvm: failed to shrink bus, removing it completely\n");
-		goto broken;
+		for (j = 0; j < bus->dev_count; j++) {
+			if (j == i)
+				continue;
+			kvm_iodevice_destructor(bus->range[j].dev);
+		}
 	}
 
-	memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
-	new_bus->dev_count--;
-	memcpy(new_bus->range + i, bus->range + i + 1,
-	       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
-
-broken:
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
 	synchronize_srcu_expedited(&kvm->srcu);
 	kfree(bus);
-- 
2.28.0

