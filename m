Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 184D1E218E
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 19:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbfJWROr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 13:14:47 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:45338 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfJWROr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 13:14:47 -0400
Received: by mail-pl1-f202.google.com with SMTP id c8so176786pll.12
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 10:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WJ/03uRoTlVpADfzmCIe76ZMMoZAaSrMg9ZFGLQJXxY=;
        b=smHdWwvV8h/6x4uHdE7piSpoaY0fkzYr//VL02d0BTCFk13SZpWyLSV0mSgPiSdlBK
         DeS8A+YwBhWJZdeTL6pBRyRUguTiHO3NcsteSNXgge9xhKwsg92rOlNL1hPgrbbDNpN5
         Pm4UnOzzUI6zv7rvZ2dsHYhyk8Kw3VZ2NdckRn7Q1TgyefSnNTEJeYrv1O9L5N0JquEw
         AR/BdqBkFOziAUwjMxa101pR5+RBojV0356Zjua6foTfTqAbrzwGzvwEdbyVmylDmpmg
         RYiOUgjUa6I2F21MSEVixPAytb5XiWOOWi7JJtr94iozzDJWwABz3d31eG9uA61366gX
         QRsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WJ/03uRoTlVpADfzmCIe76ZMMoZAaSrMg9ZFGLQJXxY=;
        b=JXAAvDAxKjSZ7NupU0EzsP0YJED7m3omNiAWuc1l0WvSnE5gr/83j58Z5miCQDoD2l
         XAkughIA+N9LtOntuWcxV/ISNBv0YV8JoeHCMbgu68jkO7MIPYafgF8QCBjfNu5VwPRm
         0ZBIXppA81MvMaDwcRV18XOrc1i4Ue8xMc+vXm92Cqg1jCBPl9mmIMLHt4jszYLK7pgX
         mh3j9LB8JxREA3F7FZe3M07fA2DbaoYmUTSTSiboSsqQ3uSJcIA3DZGL7OB1IK3yucKk
         blHrX/DlVE/N2sO2A8+KZsY8Bm1aYLS2aSU1EbAKr6s+1JFVMQl7eAMX0MCPJ5Ug+CL3
         3FCg==
X-Gm-Message-State: APjAAAVGoK5/Ivpud7pUcZJYAMyH9ZcmcXf7+CFoZF0JNuR72e4wUEL7
        YGHa9fUgDIWo2PrImol9FWS77NSfbpQrfeQR93SQKSoaxZ6hbBqSaMgH5824JDCSLlCQqrO8ew7
        Qi3Cot4PQXJA9Tjb/68GRgDnBiTnFB036ZJQH9ZV4xcQZka6nEe9gpF2yOUdx2yE=
X-Google-Smtp-Source: APXvYqyxHz53bvCG8ncILIL85SxrTEuT40NjvKBHrPUWufe0tMQxSB3jYG+9wwX0Oto5OT4AUyDRz9ZKyAgB2A==
X-Received: by 2002:a63:1c24:: with SMTP id c36mr11116121pgc.292.1571850886485;
 Wed, 23 Oct 2019 10:14:46 -0700 (PDT)
Date:   Wed, 23 Oct 2019 10:14:35 -0700
Message-Id: <20191023171435.46287-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH] kvm: call kvm_arch_destroy_vm if vm creation fails
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     John Sperbeck <jsperbeck@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: John Sperbeck <jsperbeck@google.com>

In kvm_create_vm(), if we've successfully called kvm_arch_init_vm(), but
then fail later in the function, we need to call kvm_arch_destroy_vm()
so that it can do any necessary cleanup (like freeing memory).

Fixes: 44a95dae1d229a ("KVM: x86: Detect and Initialize AVIC support")
Signed-off-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 virt/kvm/kvm_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fd68fbe0a75d2..10ac7ae03677b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -645,7 +645,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	r = kvm_arch_init_vm(kvm, type);
 	if (r)
-		goto out_err_no_disable;
+		goto out_err_no_arch_destroy_vm;
 
 	r = hardware_enable_all();
 	if (r)
@@ -698,10 +698,12 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	hardware_disable_all();
 out_err_no_disable:
 	refcount_set(&kvm->users_count, 0);
+	kvm_arch_destroy_vm(kvm);
 	for (i = 0; i < KVM_NR_BUSES; i++)
 		kfree(kvm_get_bus(kvm, i));
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
+out_err_no_arch_destroy_vm:
 	kvm_arch_free_vm(kvm);
 	mmdrop(current->mm);
 	return ERR_PTR(r);
-- 
2.23.0.866.gb869b98d4c-goog

