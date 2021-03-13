Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116E0339C97
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 08:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhCMHfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Mar 2021 02:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhCMHe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Mar 2021 02:34:57 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A6AC061574
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 23:34:57 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so11830082pjc.2
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 23:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3HgyLA1cm8PON8AANlntpjJCCSAi8+m9Kx2hbGBjvCk=;
        b=pmNjIHpVg1CP7Ub8WCe50fGc8P5D0xxNpFS0Pgu1fk2mVrcZROoiFLXPL5/omhH9W6
         TfQANfFtb4aX1gsU72ENTYTD/9ldMxioSQQY1Fm/KWQU6c2eRePf8LbLARwF9GNOkaiH
         PO9q0oCBr0fiqJXtLHMAP3fr+4EVjz21O2yRB6ZtbD7u4Zbo9IqLAUddCPLDTcCY8ijI
         M6UgTCsPaft8CyDfYPB5pCGYPSUa+KklCLzJPs49FzXHBoovzEbip9tx9feBR1+YJRKv
         fLB2+mCJcj0W4N3vthW/egQY9IoadwgrQOE5oRojgX8y+xWieRzWdWxaehQz7k4U9ZM7
         KD+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3HgyLA1cm8PON8AANlntpjJCCSAi8+m9Kx2hbGBjvCk=;
        b=pAY7PQEh8Pvt3/OmFHxuYPbqFdCPwAv/aDbn5TDciwp1XHFzqRhtnpJLTM+vCm7KDP
         dmMsNVgTpP3a88cMwxjhYqLOt73JPncJ1WXn7XYhS3IWQyU93PUtQYjm5xbXjjsnf21l
         KFxrwX/FtAg9A1/SfyA83p9Sqcf6oHN43qd3vHz5Q+8V/rFrUm4NfUiT1Y3wyrVUMMJA
         r58c+qCo808+kj7rFaY5SPx/JHSVuz85FK6EBMsfBzSK+YNNPUrSnJLV4RhE989eTkrn
         9eN9qyvfbBsZA74NrCyFsE77uZfWfTGmnp7EKodB3jk10GGKVq488Ld3f7x8OzKDABRT
         htAg==
X-Gm-Message-State: AOAM530BHo6WFSMgEIJzXenCrJfXFCe6OwAfxG1zEHXiO9s0OttYVDOE
        UXJIeXOUJXbOb8QC736RSJ0=
X-Google-Smtp-Source: ABdhPJyZNv3HNA4qQy7WRYpHqA58GMlu5y3aXj43gY7aLTm87XBj1UVxYxlJFPc6FAlTRacebq9ZqQ==
X-Received: by 2002:a17:90b:228e:: with SMTP id kx14mr2386569pjb.71.1615620896804;
        Fri, 12 Mar 2021 23:34:56 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gw20sm4097462pjb.3.2021.03.12.23.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 23:34:56 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH] x86: on 32-bit do not initialize memory above 2GB
Date:   Fri, 12 Mar 2021 23:30:20 -0800
Message-Id: <20210313073020.36984-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

taskswitch2 test fails on certain configurations with more than 2GB of
memory.

The reason is that on i386, setup_mmu() creates a hole above 2GB and
does not map that area.

Do not initialize the memory above 2GB on i386.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/x86/setup.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 7befe09..001853c 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -107,6 +107,15 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 
 	u64 best_start = (uintptr_t) &edata;
 	u64 best_end = bootinfo->mem_upper * 1024ull;
+
+#ifndef __x86_64__
+	/*
+	 * On i386, setup_mmu() creates a hole above 2GB, so do not initialize
+	 * the memory above 2GB.
+	 */
+	if (best_end > 2ul << 30)
+		best_end = 2ul << 30;
+#endif
 	phys_alloc_init(best_start, best_end - best_start);
 
 	if (bootinfo->mods_count != 1)
-- 
2.25.1

