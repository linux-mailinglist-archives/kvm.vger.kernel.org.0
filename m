Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A43256B7E
	for <lists+kvm@lfdr.de>; Sun, 30 Aug 2020 06:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgH3EeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Aug 2020 00:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgH3EeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Aug 2020 00:34:03 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E63C061573;
        Sat, 29 Aug 2020 21:34:03 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id g207so2754174pfb.1;
        Sat, 29 Aug 2020 21:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xT5hOA3Q9LtPiLNaX+syaa1JIKrmhIwC08WtkEEf/0E=;
        b=nmmq4yt2jDGvMdopd9AnAONRTa4o80logLsYKaV7kuMUI6EYuTNs8A+SfJOCmrCiGU
         9TBCTO6Zqp1UghiKDOh/jVOVEyMWWfPDJBL4frWHmSCarqcERdZRwSZ/9HXxAcup6yBJ
         O+GUy7CSvKdtoFN43GxKYsQt8ubs+YyGw/Wszeo8IDodUaLRakVbXoP0n3IG/SdWSSdk
         5jY//dKbifCKbHgxugw5kOulA5x/kU6Gh0DFvYakBca5HCLZfTJgvxXzX4PoZdBTYJ7u
         mkyp+gSWke2XO9T0/gCDh4ej+fpHY0Tror4tF+qoCf0We3od1htIhkJgY1WpnZ+u1mb2
         Io8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xT5hOA3Q9LtPiLNaX+syaa1JIKrmhIwC08WtkEEf/0E=;
        b=VJD/r6QdEp1wLiuzgsBAei/nyIkw7saOi8YvE120pt5DYXSeo100Kimkk+R0FUlohc
         dloDlFVheAjDvU4wdYtxGcF+G/7jZqiGT7LTbGVevimeQoeglKQKRQW2aafwMHIIYCJE
         E+CLmwxWxUO3NXEJqaUIfdCZpUQcjQAnlfC19TwD6nebxnA/DekfJBd8yDSkI5YdnYTv
         Alhfrr6qrQldOSaqAx4y+Yecdljag+2t/XQbQSj7J3wfIh7kyXxvP3Yyh85GLieTaz1u
         4BR/toqhzXV4qzZTvXrDegm5sbaCHevC/S0mvqzT0GOrMyaQyxk+Flk6f2uADXtFwa+u
         BOrQ==
X-Gm-Message-State: AOAM530mDrN86cA4Gh3J9ZdNPpagV21siDWjhw7F4SC8BDjNaCi8lMQI
        101Yli3qU+gJ/NFOODIl+Zw=
X-Google-Smtp-Source: ABdhPJxL59CylV1nSHfWdYJMO6uDnfQ8foYdlMNRTWw78U3S/+mM5nt5uIsDFHhRw3bTt+il0JrooA==
X-Received: by 2002:a63:fe06:: with SMTP id p6mr4181417pgh.337.1598762039854;
        Sat, 29 Aug 2020 21:33:59 -0700 (PDT)
Received: from thinkpad.teksavvy.com (104.36.148.139.aurocloud.com. [104.36.148.139])
        by smtp.gmail.com with ESMTPSA id j18sm3740390pgm.30.2020.08.29.21.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2020 21:33:59 -0700 (PDT)
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Rustam Kovhaev <rkovhaev@gmail.com>
Subject: [PATCH] KVM: fix memory leak in kvm_io_bus_unregister_dev()
Date:   Sat, 29 Aug 2020 21:34:05 -0700
Message-Id: <20200830043405.268044-1-rkovhaev@gmail.com>
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
---
 virt/kvm/kvm_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67cd0b88a6b6..646aa7b82548 100644
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
@@ -4351,6 +4351,11 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 			  GFP_KERNEL_ACCOUNT);
 	if (!new_bus)  {
 		pr_err("kvm: failed to shrink bus, removing it completely\n");
+		for (j = 0; j < bus->dev_count; j++) {
+			if (j == i)
+				continue;
+			kvm_iodevice_destructor(bus->range[j].dev);
+		}
 		goto broken;
 	}
 
-- 
2.28.0

