Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1E4270B63
	for <lists+kvm@lfdr.de>; Sat, 19 Sep 2020 09:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgISHVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Sep 2020 03:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISHVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Sep 2020 03:21:18 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B64C0613CE;
        Sat, 19 Sep 2020 00:21:17 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x123so4914556pfc.7;
        Sat, 19 Sep 2020 00:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4kK+jQKJbbHZJYLj3SecCh6+KVR55OeofhrlQ+EkZss=;
        b=GA753YAh76vWLQcwOFASJ9BZ7g+zdnQQoMVOQrXZHs/C0Eg4PK6Umrp1ADlo2Vq89g
         D4Gaa9BGT8T4xTkFUfijllWjJYWyqAW2+U1Cx/J+qeY3Wa1TisVzMbKTY2l7eUSesexs
         /1iaKaWSLblxm1K6q/DHu0SvVeAJ0DWgXVB6CPQHwy/5wG6AL2CFSR0/PKg0/bgUJYG/
         1C0T9jynyBItTyggRzDH4+argbTS/ceQpfAyWXfSQCtGn/YQW9QftQgGR+gUpCIu7/6Q
         ubCSL++9Zmy5f0v51LySeuxHPyqfnh0s66G48yJ2rnAdbnlVNsFNg4Evs3g11puSjaeI
         JUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4kK+jQKJbbHZJYLj3SecCh6+KVR55OeofhrlQ+EkZss=;
        b=QRZ6g/N7FpXOv6fIkXgVtOzZWOBdqVGT+EqllpEdbBmftzhZsx8lOJxW/1KkEJJ44Q
         brHN2TJ9qBeAIMBlZneko427NJLr5brCDJfI+lqttjCqsWR3GAeexuamTTft7arrJFRO
         Bf5DhqO607pCgd6fnqUmhFJdOgrzGFb/pONBos9bU0cHaTfzwUM2uoD0oHQkvjVY2/u5
         OXlsESPZMHuPVmkqQKG6G5nXAjy3JVIlnZdYZSat/jJn/h+xvlAmYkmuW7Ugu2Svk+l6
         pvsSvjLnEepsmW1du2Mvhg7JZeF0bi7uQiUKew84hE2+1U2kUKo9lCC5mVI287KODd/A
         EZlA==
X-Gm-Message-State: AOAM5332Veuc7FwxIsRCPYeu122EygVR4XIO6NJzHaO3l6QxvIklkoWd
        +Z8cd/YUOTSnfXCfsPmSOvE=
X-Google-Smtp-Source: ABdhPJxmZXahfmIqaEqkFnTtyceIDfSg3X1q7TQ60WFIuTxrN5r9F3pocJ2zeq108Wum7M+297Id8Q==
X-Received: by 2002:a62:5586:0:b029:13e:d13d:a12c with SMTP id j128-20020a6255860000b029013ed13da12cmr34972311pfb.20.1600500077185;
        Sat, 19 Sep 2020 00:21:17 -0700 (PDT)
Received: from localhost.localdomain (104.36.148.139.aurocloud.com. [104.36.148.139])
        by smtp.gmail.com with ESMTPSA id ge12sm4713261pjb.26.2020.09.19.00.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 00:21:16 -0700 (PDT)
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, gustavoars@kernel.org,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Rustam Kovhaev <rkovhaev@gmail.com>
Subject: [RESEND PATCH] KVM: use struct_size() and flex_array_size() helpers in kvm_io_bus_unregister_dev()
Date:   Sat, 19 Sep 2020 00:21:55 -0700
Message-Id: <20200919072155.1195714-1-rkovhaev@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make use of the struct_size() helper to avoid any potential type
mistakes and protect against potential integer overflows
Make use of the flex_array_size() helper to calculate the size of a
flexible array member within an enclosing structure

Suggested-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cf88233b819a..68edd25dcb11 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4350,10 +4350,10 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
 			  GFP_KERNEL_ACCOUNT);
 	if (new_bus) {
-		memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
+		memcpy(new_bus, bus, struct_size(bus, range, i));
 		new_bus->dev_count--;
 		memcpy(new_bus->range + i, bus->range + i + 1,
-		       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
+				flex_array_size(new_bus, range, new_bus->dev_count - i));
 	} else {
 		pr_err("kvm: failed to shrink bus, removing it completely\n");
 		for (j = 0; j < bus->dev_count; j++) {
-- 
2.28.0

