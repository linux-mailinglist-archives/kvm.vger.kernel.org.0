Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7773D44CB39
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhKJVXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbhKJVXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:23:00 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC1CC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:11 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id e4-20020a630f04000000b002cc40fe16afso2090987pgl.23
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AZLTHxJn0HLhiHimWkLHNhs7fasAZ14U8RcSe/gnCrg=;
        b=gqgL1m3nhTAJ92oR8AiaBJv8WXjt6N339BTwWTYY5qclKH2aar13D4rubhmZOHEPf+
         boZ/tdCPUk8zpfHg+8/l5ptSgVll2+T4k7f5p8yKwFvTtTrtD71J1yqrpWUAkeMuZUcf
         Bt/4cQQcl48L680dvaDsS0KR7RQnfXRmrfA2ve7NxLJzb9UrD+x7VmJ8vlbpKdFN7Mib
         Xit/vXw+8HQw0TDwXEOaP1+2QybfCuJ/bk4m8+djTgilmu8bRK9ze7AUbU7lHisu8pvl
         c8xhs58fY0Qq7LBqzlvkJzYg+NbvA2MDubFaACjf3DuXom2dLV7l+fWE03vdB3UQxmAl
         n8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AZLTHxJn0HLhiHimWkLHNhs7fasAZ14U8RcSe/gnCrg=;
        b=X/TbUal2ZQWd+Fs2PhmGFStE+yiALtN6w7UM7yP72npRo5LHpKDDpxE66UD+A/qiXW
         4D5woCJ352QPTOsyGNH7Qfqzbe8UDJjJOGhSK+MrhVAkXdRrEjmAjjO3/DY+Y7Uv21sM
         jy1k21QvL/c78nznKcGrupys45j6dJ4omowBBQc8m5g4wEGu7bYNIgSd3wrkPO2Csyvb
         V5yGtk3QluQfclwoInZfv9o8mZMBqN92bkTHs5CUsPXAiX+tmE8idrDEo8uhfVjljamu
         Z8Ou4zNnOZOmOadrQWk1BZUJfo+FyCf7zSAECRtaHOhMw8o3D/lMF0kGtkwCuFJ2vXlK
         ZJgA==
X-Gm-Message-State: AOAM53076qaPuycA/It5m5RKhKLnSJBFIheuIl41XayeIV6atdfnhkx0
        3JaQXRyGSaGqZkGtJy37XhZeabkPM2V3iQvYa1ucQos27MwfVzl5ssvJLbsIl92nQYJnrzPi6Iv
        3ozo1+w1OWQ6Pkwl7jK0fpyJ3b+xG4Y4M75vAZaG25SR7RqLgYFNYQS0euGlB9i8GkPNM
X-Google-Smtp-Source: ABdhPJzIXwZAsauW8Zy1CbClJh4xfq6ZkJ59DoXu2ece3hOH0ioAXzbgHBWglbGDL6FaVUUqnA5A0mhuUIhuk5qR
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:8e85:b0:142:7621:e3b3 with SMTP
 id bg5-20020a1709028e8500b001427621e3b3mr1986392plb.84.1636579210768; Wed, 10
 Nov 2021 13:20:10 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:19:49 +0000
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Message-Id: <20211110212001.3745914-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211110212001.3745914-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 02/14] x86: fix call to set_gdt_entry
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The low four bits of the fourth argument are unused, make them
zero in all the callers.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/desc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index e7378c1..b691c9b 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -336,7 +336,7 @@ void setup_tss32(void)
 	tss_intr.ds = tss_intr.es = tss_intr.fs = tss_intr.ss = 0x10;
 	tss_intr.gs = read_gs();
 	tss_intr.iomap_base = (u16)desc_size;
-	set_gdt_entry(TSS_INTR, (u32)&tss_intr, desc_size - 1, 0x89, 0x0f);
+	set_gdt_entry(TSS_INTR, (u32)&tss_intr, desc_size - 1, 0x89, 0);
 }
 
 void set_intr_task_gate(int e, void *fn)
-- 
2.34.0.rc1.387.gb447b232ab-goog

