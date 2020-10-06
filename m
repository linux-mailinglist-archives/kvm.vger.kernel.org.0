Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCC4285397
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 23:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgJFVE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 17:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727396AbgJFVE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 17:04:56 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD19DC061755
        for <kvm@vger.kernel.org>; Tue,  6 Oct 2020 14:04:54 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id f9so2071548pjp.1
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 14:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=wmYneUmReevw5Pig2V/tCQ1QYvT7hoDCFpGFyyX8HMk=;
        b=jMx5D4b31/HZQNBv3S4nKM7itXd9++V5P0R3U6G/z9sZgEjK8YGhJouYdz67Oj+z+v
         rpIq93I5dCKyob0R78ScFpTopgcEeN7PTl7u2Ad53E06FODAMdSVo/W1NAlRRdpuuqqE
         6+e74MXJqjSWcCRLsoRMkvFK7kwrbFTWDIo8lNeQkIw+Un8KmkSDD68T6ylQZtzE+onl
         6GWt4mbkbU7odbhO/ijc/dK+LQUlZchdwTWNZ0jV50/dROsjfralzYtYfOQk9SJO/rQ0
         3mnuJQht8qdCgAxnKwG+vHqTE91TXs8IOxEjuls+KIwpXdI35Hhoe15kpN5r92hczpLa
         3BSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wmYneUmReevw5Pig2V/tCQ1QYvT7hoDCFpGFyyX8HMk=;
        b=gDV0bPwkDp7PfyoVjQtfGRXmTI8LsTTfcyNLKdW434kmPQLDtpcRBXI05mxOw7NSuI
         Gx7w2ceVUJxGgy2J7sDuT5XDVTlAfwMFliTcy7XQZexc9hV6xA4vxR2lUcChCUEfcQYk
         aDH3lNO+VkSm28ZVm10O2qU7o4LAOKsbpORzeHbPz2KN+F8mXQa8myPbE8SK3VRsf+62
         iH1qcmxxdKlHKpn+7bnLpSybo+3Kbq72OlwdN+E7MQiTilfKBpwz05uH/f/Hv6g5Xdmv
         S/xnx83o74Kcr7MOBYOHOVq2sPDkTe4frCINiYdRgp68rmhoEAhYcZ9JZzKdT/AGJxWA
         YLcQ==
X-Gm-Message-State: AOAM533ulDmpPj086WdQ9ixGzM3LaIA9BMTr1mxGtY7BXL2Ubhr/Vxfh
        XAS7HRLV1LFI3uvnY6rN4R/A4DNw78GnHAv6
X-Google-Smtp-Source: ABdhPJyxgr0bpMMNTHMjf4WLJJCvA+/4wjgsPYU1+6fXUK5fzWw2dIHr2WXJT+sagYEbC6YlaO1sCcfMzpQwM8HG
Sender: "aaronlewis via sendgmr" <aaronlewis@aaronlewis1.sea.corp.google.com>
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:ed4:: with SMTP id
 gz20mr24624pjb.92.1602018294314; Tue, 06 Oct 2020 14:04:54 -0700 (PDT)
Date:   Tue,  6 Oct 2020 14:04:41 -0700
In-Reply-To: <20201006210444.1342641-1-aaronlewis@google.com>
Message-Id: <20201006210444.1342641-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20201006210444.1342641-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH 1/4] selftests: kvm: Fix the segment descriptor layout to
 match the actual layout
From:   Aaron Lewis <aaronlewis@google.com>
To:     graf@amazon.com
Cc:     pshier@google.com, jmattson@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the layout of 'struct desc64' to match the layout described in the
SDM Vol 3, Chapter 3 "Protected-Mode Memory Management", section 3.4.5
"Segment Descriptors", Figure 3-8 "Segment Descriptor".  The test added
later in this series relies on this and crashes if this layout is not
correct.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c     | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 82b7fe16a824..0a65e7bb5249 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -59,7 +59,7 @@ struct gpr64_regs {
 struct desc64 {
 	uint16_t limit0;
 	uint16_t base0;
-	unsigned base1:8, s:1, type:4, dpl:2, p:1;
+	unsigned base1:8, type:4, s:1, dpl:2, p:1;
 	unsigned limit1:4, avl:1, l:1, db:1, g:1, base2:8;
 	uint32_t base3;
 	uint32_t zero1;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index f6eb34eaa0d2..1ccf6c9b3476 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -392,11 +392,12 @@ static void kvm_seg_fill_gdt_64bit(struct kvm_vm *vm, struct kvm_segment *segp)
 	desc->limit0 = segp->limit & 0xFFFF;
 	desc->base0 = segp->base & 0xFFFF;
 	desc->base1 = segp->base >> 16;
-	desc->s = segp->s;
 	desc->type = segp->type;
+	desc->s = segp->s;
 	desc->dpl = segp->dpl;
 	desc->p = segp->present;
 	desc->limit1 = segp->limit >> 16;
+	desc->avl = segp->avl;
 	desc->l = segp->l;
 	desc->db = segp->db;
 	desc->g = segp->g;
-- 
2.28.0.806.g8561365e88-goog

