Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A092058D35E
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 07:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbiHIFvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 01:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiHIFvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 01:51:46 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3A71CFFD;
        Mon,  8 Aug 2022 22:51:45 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o3so10457909ple.5;
        Mon, 08 Aug 2022 22:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=6+90d46uiEhYWpTZ4JssbCjk1xBnS3JkA1y/kZ0bVWw=;
        b=bfP/ImI2J+5rAiBzFI8KDYOb9WbKL9uFA4ACFO+YBu++lDAwQ7piT9/TCP+ikCW2J3
         w3V55Z6MSXGoB2q10bNqJKD8Z9PNqcrDT/PeTksDB6ZfiQdSsNVVPUv4BdWHk0IdShFW
         pbTkcpR8C3aGXKYVVq5QtxathyM+Gyosbi8tNz0GUI6SUGm0UUu3A4Snj18Dgd1liC1j
         /3T/hXc0dkziMSAjnHhTyCbsVNtTq7P5VjOkcTZwCCy/0jCOlAjChq5Gse3kZ3myuLKe
         KArwCjG9b8ZWR/NQPf+P/9lEr9k289mS/T2TyTI95rCTrIhh5EGiEU3m6oY0FM51Elvz
         3exA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=6+90d46uiEhYWpTZ4JssbCjk1xBnS3JkA1y/kZ0bVWw=;
        b=CnPkiGwZnkPM+VmeM7tHUgBVQqxWyzCbWRN3gH6Q9+lDaxqMFwZ9lXG1mrAAjtr8Fq
         j3P0Vj8Gr05UK9Ycx4ZnmCoPuQ00rmXjLmXich2QRwWDt/8aUhbSp1wr7o5ajjQ37TEk
         9aW0jj5yOQFpbUA7/5d5mW5Bu6b4gPeU8B2HzdyZlQ+w3or8RXZWVTkyh+UYvRkVIs6X
         tNsFVuQCGMlak7DLKY4UbX3uPxL6t+Gux4VvNln1Pqz/zj5uAVLF+yAsdn4INuk12e4y
         qpgOCk9qeEZG+cjqGusijJQftgfKAN9ata53vlUlomenvcYy2poZOWuBxbtao/GyaMIF
         AtJw==
X-Gm-Message-State: ACgBeo0jIjg6gsa2dcRnXII2mDwAoLeVO2jEmYSwNsU/ixyqhH7kCZoY
        EV5SVrcN70KgFg07UpkExUY=
X-Google-Smtp-Source: AA6agR4A6xz13ikfOViVla/8SfquY+8mgZWRsVLqHHQ3uCXtrXuS1kQWmX17BWvvdrNdzo2aVecGXA==
X-Received: by 2002:a17:90b:1645:b0:1f5:67f:ff84 with SMTP id il5-20020a17090b164500b001f5067fff84mr23537039pjb.86.1660024304937;
        Mon, 08 Aug 2022 22:51:44 -0700 (PDT)
Received: from aa.zhaoxin.com ([180.169.121.82])
        by smtp.gmail.com with ESMTPSA id p8-20020a170902e74800b0016b865ea2ddsm9901184plf.85.2022.08.08.22.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 22:51:44 -0700 (PDT)
From:   Liam Ni <zhiguangni01@gmail.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhiguangni01@gmail.com
Subject: [PATCH] KVM:make cpuid_entry2_find more efficient
Date:   Tue,  9 Aug 2022 13:51:38 +0800
Message-Id: <20220809055138.101470-1-zhiguangni01@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compared with the way of obtaining the pointer by
fetching the value of the array and then fetching the pointer,
the way of obtaining the pointer by the pointer offset is more efficient.

Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index de6d44e07e34..3bf82a891564 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -75,7 +75,7 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	int i;
 
 	for (i = 0; i < nent; i++) {
-		e = &entries[i];
+		e = entries + i;
 
 		if (e->function == function &&
 		    (!(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) || e->index == index))
-- 
2.25.1

