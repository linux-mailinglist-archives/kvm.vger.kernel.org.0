Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB923288806
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 13:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388155AbgJILqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 07:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732494AbgJILqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 07:46:23 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C87C0613D2
        for <kvm@vger.kernel.org>; Fri,  9 Oct 2020 04:46:23 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a27so6390463pfl.17
        for <kvm@vger.kernel.org>; Fri, 09 Oct 2020 04:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=kRLElTJYruy9BhLgGAtIqt00VI4hnTdleImYdQGJD0s=;
        b=du7otss2wXKpS/7PKEpioxcBYamyBReTtg2Op7e06jD60aZoCOGs944MtwO9JPHPjR
         J5k0e8Q0a1GMcP4vSNAgOhbtQM4mdbFYP7cXoDukMcHL84jhbiOwiaDhPlTlaiSqt2CI
         NRkQSsoh5gSzk/vqn2AJr5UhrUtznvVabo9PD6FELuyaOas35dRAmD2z7ereyeaTRGaH
         xvCnKuSHGKuHxRWXngp4JDk5Tu03yakfpkBDZdmSs3esxMnztUNcszXYcb/PpQ1tm1Yz
         kD6Xkbi2TgcAkyeqi95fWDHbglK6q2CSUPLdQbeut9MsEjLt47VHMcS65+BQOMQipiSh
         rrwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kRLElTJYruy9BhLgGAtIqt00VI4hnTdleImYdQGJD0s=;
        b=dB43PfdVKCYtjtzR+iJiZJKHN4f6LtC2ZRlq501+0o17zEQHy4NkKFAprCdFk4JwTO
         IYKc74/CZhFi+a9CSNCRxQsI7o9RdO9ag9+iXKHj4sBNe/Pj1XOjZEpk64klTJ+M7L9h
         /I7v/CPVzmqRiLx4duGWD3UUJw/lmr67nePVkaFcbMrMdrQGu/EpHfCi7PVmLTo2HdW1
         LmnWv7UzkiJ4i7p8wa3W1n1j3cQx+Zy1T/Pl0l5DpkVTgZahiKODc9Zd8X7RM1Wwk/Dl
         v/Hz0SADXKNQ3rZ/gyRcz6r5p+I/bk7txTN3fBMgcawXAq9KQFD2ZqR/lOT0eeXQNKXN
         At1g==
X-Gm-Message-State: AOAM532D21+yGlJ5ieKHhtHYaa5+fwV67+9AsFWa8ztCltobajx43tFy
        biNoJYjACXSj02h+5bb5RdEUix3L5WBhVXbV
X-Google-Smtp-Source: ABdhPJyvDSmJ08rWSvKSiSZlSUN/Wh/9YHFKNYSXEhXVMS/pzrKVbgxIyCans2IGhVLHnbgAyVMnZI71RowkvT30
Sender: "aaronlewis via sendgmr" <aaronlewis@aaronlewis1.sea.corp.google.com>
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:aa7:8d15:0:b029:142:2501:39fe with SMTP
 id j21-20020aa78d150000b0290142250139femr11821949pfe.77.1602243983040; Fri,
 09 Oct 2020 04:46:23 -0700 (PDT)
Date:   Fri,  9 Oct 2020 04:46:12 -0700
In-Reply-To: <20201009114615.2187411-1-aaronlewis@google.com>
Message-Id: <20201009114615.2187411-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20201009114615.2187411-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 1/4] selftests: kvm: Fix the segment descriptor layout to
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
Reviewed-by: Alexander Graf <graf@amazon.com>
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
2.28.0.1011.ga647a8990f-goog

