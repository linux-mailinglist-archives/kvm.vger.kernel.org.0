Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1173262FC
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 13:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBZM5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 07:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhBZM5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 07:57:06 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F2FC061574;
        Fri, 26 Feb 2021 04:56:25 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id cf12so10011064edb.8;
        Fri, 26 Feb 2021 04:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jaergPFFsfPW93kbmHCbVQ0vZ9RjLcsMl8m5iUEbS3E=;
        b=FFpcIOsV0q6mKbXaHG8rv7+yS3t+c7qga/dKvM4bQKkru+hax+Z2EMhUgVkhgRSgqG
         VMlVcfkYbIVhkv71eSZKDfrJKgGxrh5LEHCgqpcU9xI0VOxCtXm3qJA04qUFOcYcUos5
         heCT+b0WDoMeu2OhW5SzQ5K4bEbRqLJjf54WZ2HWPpHaXzlZDhe7vbu3g9Dp4gSiT14b
         qwrdNhWXqaPU35zYf4vjYk+eiUYrn3D8iLzmoTTaRIFAUXFo/bC4jEHqLj4kuLmN7UQ/
         crH3PjwUFnk2qrL1qOBZOOvDppdehpPkcfIDGLl3yp8XXyHMIZbluIX1khFJvS7PuNSH
         ke3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jaergPFFsfPW93kbmHCbVQ0vZ9RjLcsMl8m5iUEbS3E=;
        b=G5jdvD8w9DZXvRukab8VIP8yQZi7eao/QRiYh0MIuK2SiwtNM+HooQlLiDZ2novxU+
         7bhaHbG+TkHiI2Y6f0G/sRzLgDhfQtTJwcs//QlafEwHYuKMWsmlVfmBtvFPOWmMn56F
         AgePLs+Y1NYp4R59nD/bMZ9Ez+cEn2Bv094W1JI3xECPp+LvH5oQZPyObo2zgSwmTQIX
         1RxfR+GOe67lmbd1QDrgf0bCknS6ZomwSXHDiSudr8b9RwG0bcFQVrKOkwU84IasP7KV
         3FmHhJKKOsgnVkgDfCxLI4FX746igxsKI/ugtUEksYTA5Tq/Vsbe2+LD8QF7UFPq3/n1
         1ycQ==
X-Gm-Message-State: AOAM530WTN8TOEc5ytcdta9ZaMsk5F6Cfe/rWOoCPq2nuPHC66RfbOqE
        YbcfYztbcacDjPW1tNv84MFtnI8d2Ga6wA==
X-Google-Smtp-Source: ABdhPJxx+Mt2qgGNb6QwegwSCbm5VrKR19qYN+VGhqPn8DAOgv2ASvaOX+razj8v/hKJUDx61HtkEA==
X-Received: by 2002:a05:6402:1aca:: with SMTP id ba10mr3164723edb.6.1614344184418;
        Fri, 26 Feb 2021 04:56:24 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id bn2sm5270463ejb.35.2021.02.26.04.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 04:56:23 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM/SVM: Move vmenter.S exception fixups out of line
Date:   Fri, 26 Feb 2021 13:56:21 +0100
Message-Id: <20210226125621.111723-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid jump by moving exception fixups out of line.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/svm/vmenter.S | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 343108bf0f8c..4fa17df123cd 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -80,15 +80,9 @@ SYM_FUNC_START(__svm_vcpu_run)
 	/* Enter guest mode */
 	sti
 
-3:	vmrun %_ASM_AX
-	jmp 5f
-4:	cmpb $0, kvm_rebooting
-	jne 5f
-	ud2
-	_ASM_EXTABLE(3b, 4b)
+1:	vmrun %_ASM_AX
 
-5:
-	cli
+2:	cli
 
 #ifdef CONFIG_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
@@ -155,6 +149,13 @@ SYM_FUNC_START(__svm_vcpu_run)
 #endif
 	pop %_ASM_BP
 	ret
+
+3:	cmpb $0, kvm_rebooting
+	jne 2b
+	ud2
+
+	_ASM_EXTABLE(1b, 3b)
+
 SYM_FUNC_END(__svm_vcpu_run)
 
 /**
@@ -174,18 +175,15 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 #endif
 	push %_ASM_BX
 
-	/* Enter guest mode */
+	/* Move @vmcb to RAX. */
 	mov %_ASM_ARG1, %_ASM_AX
+
+	/* Enter guest mode */
 	sti
 
 1:	vmrun %_ASM_AX
-	jmp 3f
-2:	cmpb $0, kvm_rebooting
-	jne 3f
-	ud2
-	_ASM_EXTABLE(1b, 2b)
 
-3:	cli
+2:	cli
 
 #ifdef CONFIG_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
@@ -205,4 +203,11 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 #endif
 	pop %_ASM_BP
 	ret
+
+3:	cmpb $0, kvm_rebooting
+	jne 2b
+	ud2
+
+	_ASM_EXTABLE(1b, 3b)
+
 SYM_FUNC_END(__svm_sev_es_vcpu_run)
-- 
2.29.2

