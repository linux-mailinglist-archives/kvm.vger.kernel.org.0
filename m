Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0DB1A33BA
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 14:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgDIMEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 08:04:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37498 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgDIMEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 08:04:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id w10so11639989wrm.4
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 05:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lCmPfTqm1cRtMIpvXq734SPUvTONQxpqo1sItgL7b4o=;
        b=LyKE1uLASPzUYs4GBcNp6r5h5YHAV2+DPhgSp5owG1mKLASYAvj0K/6/XGLWYj+ueC
         bPzhcZV40BHD59DIOki8xpnTLkDbNmVQkdl8zVyRD8SNO8TB69lfArzq/xpdDWxrkJTl
         kv+sArnR3jUnnLxlq01av6GlHGLZ5Uhe/Axq6Sfc3zVc5aUvkwis9errWskiyTwH0nha
         Sq0ZeUR4foe5hvgURdApv6TtaJV9ObwqlOceRyhgHfdaWKT414QUxjK5jfTt8UGofQTX
         tDWASp/CacC8RIPtD3Pa/kX8JIVEzBmCzL8fbDFDYmrtqiIHtPr2WiFFe6dNwnxBrGQu
         tbKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lCmPfTqm1cRtMIpvXq734SPUvTONQxpqo1sItgL7b4o=;
        b=jywSNMpyWrTbhRi16h2C26yzP3c8yF4LBNy+FeqVptEFDaHA3Qvlj3tN9iFnt+9wXU
         iVjaRcHXdr40lWFyF0PpgrppmykfPrTSmFoY9T2pkoRUXKIK2nzXQw0yEERZH03dN7tZ
         dJ3uoi9zOKFUrLGBOVbShtBTP5PP3aeF3pO3AGCNhGS3NhueUUmX01hS2iH8Dc/T9vrx
         aiWI6633ccTNAgaI6P+xQ/WnicMFFQdUuUQK73fA/wfMaKnsT3gber6dSoBGyfa49NKw
         ozp7rnRj421Utl9Patktb8BOKUduKlR0e6D4oYcn62UHK3N++Bc76xWq+wkqtG4tFdJi
         zHBw==
X-Gm-Message-State: AGi0PuZZUnWedOHe/WBkt4sDKzqrCSbMSreoddPUADCBxVOAiudorsVc
        /PMirJGwzYkXNvRbolB/mQSBxvRYC2k=
X-Google-Smtp-Source: APiQypKOdYcsZ7tQmIT9Bg2GAIpd7YZFeplUbWXhnfvRK6Cb62GWg59W4mb0M2Hr44hx5k4YjxMJ9w==
X-Received: by 2002:adf:f8cd:: with SMTP id f13mr13466696wrq.119.1586433886815;
        Thu, 09 Apr 2020 05:04:46 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id e5sm41110117wru.92.2020.04.09.05.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 05:04:46 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: SVM: Do not setup frame pointer in __svm_vcpu_run
Date:   Thu,  9 Apr 2020 14:04:40 +0200
Message-Id: <20200409120440.1427215-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__svm_vcpu_run is a leaf function and does not need
a frame pointer.  %rbp is also destroyed a few instructions
later when guest registers are loaded.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/svm/vmenter.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index fa1af90067e9..c87119a7a0c9 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -35,7 +35,6 @@
  */
 SYM_FUNC_START(__svm_vcpu_run)
 	push %_ASM_BP
-	mov  %_ASM_SP, %_ASM_BP
 #ifdef CONFIG_X86_64
 	push %r15
 	push %r14
-- 
2.25.2

