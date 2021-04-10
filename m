Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83B735AE76
	for <lists+kvm@lfdr.de>; Sat, 10 Apr 2021 16:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbhDJOmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Apr 2021 10:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbhDJOmw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Apr 2021 10:42:52 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D02CC06138A
        for <kvm@vger.kernel.org>; Sat, 10 Apr 2021 07:42:37 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z1so9830626edb.8
        for <kvm@vger.kernel.org>; Sat, 10 Apr 2021 07:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g+UooGIfoZx9slLMvWVUsqUczD4vwR4RMOgrCkknVVY=;
        b=Cd/si5A+qKreqoNG5e1vVMDtBMRVT5UOb9918ajRUwyAKr05S7cBVM3ot6OhI66Bl6
         7/jyVfzN3l3X7PxNq/GqnMd/znqwTEnr8UvWZl+9z+pIu80zVxwcXk9PtQvYYQ7jDhw3
         XzObbN41ntL7EGLeHDDvrUWiEJGx5RVqPtcahWg5tBBUlM9HsuXiKHK5HnWWIaQMxiCt
         Hkmb1b0VJ+12rZ/0HQnLhTX0l2IqHbbJjoSA+QUUd4nmaULsuHKi8k9wqXvh+oqDxwuR
         FMJu0vNAYrJ8Yc7e+zMmk0CYMfO8ynZ9l2Erzgsx1Jqt84yIcYG5Jm5qwJK59V7EUnS+
         gBvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=g+UooGIfoZx9slLMvWVUsqUczD4vwR4RMOgrCkknVVY=;
        b=Q/+JwWt6lFEDXEp+HxicybmfFQQ0oGaNaWJi0w00oRAOVcFFLzklkm7habQnKdaU/D
         zQMAASnxepBDoEOJJR+07MEhFk18FXCKWWFhSU16g51kC0qb3xpTRWUl50yCIfIHp7yS
         jiYoIWMgZtmbBIiTse+iQR2UGvOWeZbKZKPWm0otl8/vSlI3GhFqws6L3/PW9ulwnUt3
         k4NYbOf85i85fE5F5+02EFdPpN+yXPZk0trvs2tVR4vBzKMxmKKEgR1XbxLtQmKUVg8P
         E8ynpiNLVvHhzhUv7GlRYLsKLftboNhpLCDP2NZ2xVXUMpY6bLkGjUrWj1y+uh8WRggA
         Uuxg==
X-Gm-Message-State: AOAM532TNYvbZEiPl41rn81+BFskAKd4XCEhTS3p2BdaEg+gCqdUf13/
        FVM9iuj4yiTz6SxDzXLpbFmoD9Sl494=
X-Google-Smtp-Source: ABdhPJxEAp41mgzi/n7ft0OmxVZyTsy4x07vrAsvH8sq6HSJRkWygJdmJv3oVTTdo+xkh+cMmAUwXg==
X-Received: by 2002:a05:6402:518b:: with SMTP id q11mr21767825edd.151.1618065756169;
        Sat, 10 Apr 2021 07:42:36 -0700 (PDT)
Received: from avogadro.redhat.com ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id q18sm3171357edr.26.2021.04.10.07.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 07:42:35 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH kvm-unit-tests] access: use write_cr4_checking to verify support for SMEP or PKE
Date:   Sat, 10 Apr 2021 16:42:33 +0200
Message-Id: <20210410144234.32124-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Free set_cr4_smep from having to report failure to set CR4.SMEP,
so that it can report instead whether CR4 was changed.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/access.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 7dc9eb6..66bd466 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -192,26 +192,23 @@ static void set_cr0_wp(int wp)
     }
 }
 
-static unsigned set_cr4_smep(int smep)
+static void set_cr4_smep(int smep)
 {
     unsigned long cr4 = shadow_cr4;
     extern u64 ptl2[];
-    unsigned r;
 
     cr4 &= ~CR4_SMEP_MASK;
     if (smep)
 	cr4 |= CR4_SMEP_MASK;
     if (cr4 == shadow_cr4)
-        return 0;
+        return;
 
     if (smep)
         ptl2[2] &= ~PT_USER_MASK;
-    r = write_cr4_checking(cr4);
-    if (r || !smep)
+    write_cr4(cr4);
+    if (!smep)
         ptl2[2] |= PT_USER_MASK;
-    if (!r)
-        shadow_cr4 = cr4;
-    return r;
+    shadow_cr4 = cr4;
 }
 
 static void set_cr4_pke(int pke)
@@ -988,19 +985,19 @@ static int ac_test_run(void)
             printf("CR4.PKE not available, disabling PKE tests\n");
 	} else {
             printf("Set PKE in CR4 - expect #GP: FAIL!\n");
-            set_cr4_pke(0);
+            write_cr4_checking(shadow_cr4);
 	}
     }
 
     if (!this_cpu_has(X86_FEATURE_SMEP)) {
 	tests++;
-	if (set_cr4_smep(1) == GP_VECTOR) {
+	if (write_cr4_checking(shadow_cr4 | X86_CR4_SMEP) == GP_VECTOR) {
             successes++;
             invalid_mask |= AC_CPU_CR4_SMEP_MASK;
             printf("CR4.SMEP not available, disabling SMEP tests\n");
 	} else {
             printf("Set SMEP in CR4 - expect #GP: FAIL!\n");
-            set_cr4_smep(0);
+            write_cr4_checking(shadow_cr4);
 	}
     }
 
-- 
2.30.1


