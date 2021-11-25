Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C174445D2B8
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353459AbhKYCDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344579AbhKYCBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:00 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F54C0619D5
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:27 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x3-20020a17090a1f8300b001a285b9f2cbso1685040pja.6
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ccjUlR79AZkyP5X7+2moEEv28sbxx0WARJjKkFZFock=;
        b=YpJ71wjtRpLxk+f1wmV6VQ2SgVKgyV2CzD4i+5LiG6WsAb2azmac2BEBIzSfAn7iGN
         HVjA6yrxN1WFIGpUV/L+GLocN0kClT4STPNwaM8gzrKhEsRqtXqdG9h7E1MjykO/S6AU
         fLM9hfVxRgur+5lD11lo/h9FfY5vfUoFarLluKm3CeVMZwkwVZMs8zg7CFLxKxVwupUH
         h2imUBLlT75Vsw2kCoaUR+pqtIBPXOcUOQ+trEItFnxuS0R2TRy+WYnr24GlCmHMJqgN
         /bwOv/vCSO0Nx5nZgume6iGW3g2y33Ss9JC4kGnqwsZ9Y6B/3Se3eYFocySEl/TVL0AS
         c91A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ccjUlR79AZkyP5X7+2moEEv28sbxx0WARJjKkFZFock=;
        b=MB5ZTG3dU1stfWWpNsDcg1KMF9oQvxYtPy4SNapiZN38BW3Jx0BVyJOTqQPY5CH1tb
         Uyr21iLqaigScXuzLqRd4766gQ3MJ+2riGtrKwXZOv1FazVmF0v89rpcUFl1Cn0ENnY4
         9/diLrL7nckepavLFdwvAglU2A9davMAXSyoVn+zy+oyBgWOvjFlg6iKva1Wy6tGHAwe
         ZnLA/WSI0BzzAIZFojorD2eUoQgaB7MR136HYiwR5F0EqwcutFSds9m+i1ZgfdEbUoua
         jR/xL0XbZ7KVu3EL9C8LVeMEfO02W9NLxBrBOHPc8GzKe5GWA+vFzZZC+CLz76jyLm2G
         QAWA==
X-Gm-Message-State: AOAM530i2W/Tj+VKAuivlmCJXfo8zXiT/rzKJhCC733PWz97cLlqILlU
        55PNpx0sQqNXzEWQjEuw/FJojxMY1PA=
X-Google-Smtp-Source: ABdhPJwK/wgjokfWzo08OqL5voFzyGutw/xg52xQBezlrwGCzEUG/9VDUZEPD/+blyq9WZTCUN7f0BXAAEA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:24d:b0:143:beb5:b6b1 with SMTP id
 j13-20020a170903024d00b00143beb5b6b1mr25277604plh.54.1637803766826; Wed, 24
 Nov 2021 17:29:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:34 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-17-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 16/39] x86/access: Make toggling of PRESENT bit
 a "higher order" action
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make the PRESENT bit a higher order bit so that it isn't toggled on every
iteration, which is a wee bit problematic when trying to expose bugs in
KVM's TLB flushing since a fault is architecturally guaranteed to flush
TLB entries for the faulting virtual address.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index c4db368..24ddeec 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -37,26 +37,30 @@ static int invalid_mask;
 	  (((address) >> (12 + ((level)-1) * 9)) & 511)
 
 /*
- * page table access check tests
+ * Page table access check tests.  Each number/bit represent an individual
+ * test case.  The main test will bump a counter by 1 to run all permutations
+ * of the below test cases (sans illegal combinations).
+ *
+ * Keep the PRESENT and reserved bits in the higher numbers so that they aren't
+ * toggled on every test, e.g. to keep entries in the TLB.
  */
-
 enum {
-	AC_PTE_PRESENT_BIT,
 	AC_PTE_WRITABLE_BIT,
 	AC_PTE_USER_BIT,
 	AC_PTE_ACCESSED_BIT,
 	AC_PTE_DIRTY_BIT,
 	AC_PTE_NX_BIT,
+	AC_PTE_PRESENT_BIT,
 	AC_PTE_BIT51_BIT,
 	AC_PTE_BIT36_BIT,
 
-	AC_PDE_PRESENT_BIT,
 	AC_PDE_WRITABLE_BIT,
 	AC_PDE_USER_BIT,
 	AC_PDE_ACCESSED_BIT,
 	AC_PDE_DIRTY_BIT,
 	AC_PDE_PSE_BIT,
 	AC_PDE_NX_BIT,
+	AC_PDE_PRESENT_BIT,
 	AC_PDE_BIT51_BIT,
 	AC_PDE_BIT36_BIT,
 	AC_PDE_BIT13_BIT,
-- 
2.34.0.rc2.393.gf8c9666880-goog

