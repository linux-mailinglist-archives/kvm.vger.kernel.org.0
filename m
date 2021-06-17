Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52E93ABACE
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 19:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhFQRrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 13:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbhFQRrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 13:47:18 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F2AC061574
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 10:45:10 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id s17-20020a17090a8811b029016e89654f93so6550652pjn.1
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 10:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6ijVHXkKuXOHj7SiqwpiZuOlv0qDP3mfw8fxeQE0vuQ=;
        b=jBlqQzBe1yDqTTYGiS0zBN/5XGfXSfcirNp81V4VIIktBOYHC1FiKN+QPQS1sj5ues
         nX7CPdDj2gzDk++WlvgmhbWnpDKbQkcpFsQt/3x2FEXBjuVUvJp2KxLW69DC9UE5oWhp
         QjBR+X6DwnEm4fxVJnXyWqmkzIUEI1kNNU9W/oSPOn2jec6YGhvUFBJwMpDl5+efbmZ6
         uBhNrSpT0gVjgkPhgxy7c7xF91uVySAYGVMGBAJic+skdYoovgkRbG0A9OFs8GJcolwE
         HqtoRBo3n8ekle0PlHT672ZNM1k4rKYwNl14EptTf2xnEhvo0xRasFBXDNorKjYzukcp
         MBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6ijVHXkKuXOHj7SiqwpiZuOlv0qDP3mfw8fxeQE0vuQ=;
        b=pP7Qa7Ycn+gMxdml60C/7xGgX5FWkFQ6dEhT8a1cSjoPEMYHdMTANpliJQvfjH+fcw
         nH66SI1/il4ipMak6LmWNOXYyIzVgJfFSRs0bNEt3ZApPb4zsRdXc8U78mn/j7kcGT7g
         hXQ5vVhueJjr1hSU0rQZByThAWjPN0+7XdUIs4kgE5zOxCV8eSDhLr9edQn6oRn9qaRI
         Lagu9z4FVQOzDvYTPjj7kf79Irk8FD5YgVOLEC1gHLd+Kw6HuSvLgFD6u6+612uNI8x2
         +8mOPi2CBiNCYuX7i95PUG9uCk1+0GJdJVBrB+bDeo0ivb7MHyALlZ4WAc4o4dnTwxt8
         yglw==
X-Gm-Message-State: AOAM531TKUYGFWPtVVHPcpVkfz7YRqhvcxVr2V+QZvhWHz58VQeN+svG
        W8dE3zbJdh2tEX+wPe7snd8=
X-Google-Smtp-Source: ABdhPJwGaZFssP3LYSorSFhqtsz9ElZPwYYqvJcPVAbVcX3fcHn1gs841etPuQGMMTPpAXyDI1NRWA==
X-Received: by 2002:a17:902:748c:b029:103:267f:a2b3 with SMTP id h12-20020a170902748cb0290103267fa2b3mr920930pll.23.1623951910236;
        Thu, 17 Jun 2021 10:45:10 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id v7sm5834880pfi.187.2021.06.17.10.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:45:09 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] x86: Flush the TLB after setting user-bit
Date:   Thu, 17 Jun 2021 03:15:43 -0700
Message-Id: <20210617101543.180792-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

According to Intel SDM 4.10.4.3 "Optional Invalidation": "If CR4.SMEP =
0 and a paging-structure entry is modified to change the U/S flag from 0
to 1, failure to perform an invalidation may result in a "spurious"
page-fault exception (e.g., in response to an attempted user-mode
access) but no other adverse behavior."

The access test actually causes in certain environments a spurious
page-fault. So invalidate the relevant PTE after setting the user bit.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/access.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/x86/access.c b/x86/access.c
index 0ad677e..47807cc 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -216,8 +216,12 @@ static unsigned set_cr4_smep(int smep)
     if (smep)
         ptl2[2] &= ~PT_USER_MASK;
     r = write_cr4_checking(cr4);
-    if (r || !smep)
+    if (r || !smep) {
         ptl2[2] |= PT_USER_MASK;
+
+	/* Flush to avoid spurious #PF */
+	invlpg((void *)(2 << 21));
+    }
     if (!r)
         shadow_cr4 = cr4;
     return r;
-- 
2.25.1

