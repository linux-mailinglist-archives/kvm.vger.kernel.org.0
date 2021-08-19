Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209F83F2336
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 00:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbhHSWh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 18:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbhHSWh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 18:37:26 -0400
Received: from mail-ot1-x34a.google.com (mail-ot1-x34a.google.com [IPv6:2607:f8b0:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD8AC061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:36:49 -0700 (PDT)
Received: by mail-ot1-x34a.google.com with SMTP id n4-20020a9d64c40000b02904f40ca6ab63so3510749otl.14
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JGqmcJ19wJcSqhtx+3fJtVk+a96fkXkWZoUWYMFazps=;
        b=ncZZlSQt7wFBsfTBRMD0PoGEeGTmX3k2OhH6AlxdOWQrM0lk86yvo6KCvyS+aHyXZh
         4qDVW2mi11CgONQrBgIZ1APYQcnqSy86DZwkzdHvfVC+V6B4SwPf3+yH4q/GS4QU3ljU
         Rccs0M8PyPJp95Yt1I4mLIim27HqRQkqzDfBjlR9ZIGm75uLuFtY7w39kSTp6sizOV+r
         3Wq+I4rDvpqrgf91TvKvNxALCOAvhpu/jPVepZ6t4/IB0uX7fM0gGHKQwkqgXEFDW9wz
         pLcUYttvedIR7jsuxxhXkwcO930SkllyMoV+2JgcimR4cCuUZOqX0YhWh4mkYkybQzt6
         +PEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JGqmcJ19wJcSqhtx+3fJtVk+a96fkXkWZoUWYMFazps=;
        b=S2at9H+5DCN0bGNBt2H92FyUFNXootMdhYmFDLdJO9v0FongPJ5l4LvO0MKbas3+13
         bpm6VhmtfxcJNdZ27oYqki0uiadsB/kqb8PXw9iw3d8bkL2YWBrv/dVnHvamUYhArd9b
         yEBVi89rztxqm+kcph/6K5Y9BYp73+Cvi4NZx49qIBG9TjIy8pUDuAhqjnjn4JI4I2Eg
         i5CvypZPSk5I3GHEnNJUrFam2hwi1cliFViRGjnKckWYfClXlpViaYyOkrHbdjRqpiTW
         p2NvJ58IwPJh1lx2hJEvneZHxNy6tE4m1UWg4gqvYX7YA08Gk0SspwBke7KOIRdYaCAJ
         zm7Q==
X-Gm-Message-State: AOAM5318QgO6GgfVfjuhh9TBcFdA2c5Kp8cgDmZhuLVV3+UfCYK5q4fr
        nGM38BS95vyIb/3RPUTNopl4KRl9524I8w4nREDYYowBZ3txLqMq0X1rTBmbwOzPjQZJEMV2+iH
        dJReWeC5eMd4gBI0B4enlyn2BbaEO3P1xsmp83pkrAjlhNiBhaawLUVa2JA==
X-Google-Smtp-Source: ABdhPJyCGOfK+n259Nrhhm5N9CusHqhw6pA25R66y29TOnm3as1HrzFW519Mnir52OpQDk02U59cIhj6WaM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6808:aa8:: with SMTP id
 r8mr736557oij.171.1629412608962; Thu, 19 Aug 2021 15:36:48 -0700 (PDT)
Date:   Thu, 19 Aug 2021 22:36:39 +0000
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
Message-Id: <20210819223640.3564975-6-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 5/6] selftests: KVM: Promote PSCI hypercalls to asm volatile
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prevent the compiler from reordering around PSCI hypercalls by promoting
to asm volatile.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/aarch64/psci_cpu_on_test.c     | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index 018c269990e1..9c22374fc0f5 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -31,10 +31,10 @@ static uint64_t psci_cpu_on(uint64_t target_cpu, uint64_t entry_addr,
 	register uint64_t x2 asm("x2") = entry_addr;
 	register uint64_t x3 asm("x3") = context_id;
 
-	asm("hvc #0"
-	    : "=r"(x0)
-	    : "r"(x0), "r"(x1), "r"(x2), "r"(x3)
-	    : "memory");
+	asm volatile("hvc #0"
+		     : "=r"(x0)
+		     : "r"(x0), "r"(x1), "r"(x2), "r"(x3)
+		     : "memory");
 
 	return x0;
 }
@@ -46,10 +46,10 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
 	register uint64_t x1 asm("x1") = target_affinity;
 	register uint64_t x2 asm("x2") = lowest_affinity_level;
 
-	asm("hvc #0"
-	    : "=r"(x0)
-	    : "r"(x0), "r"(x1), "r"(x2)
-	    : "memory");
+	asm volatile("hvc #0"
+		     : "=r"(x0)
+		     : "r"(x0), "r"(x1), "r"(x2)
+		     : "memory");
 
 	return x0;
 }
-- 
2.33.0.rc2.250.ged5fa647cd-goog

