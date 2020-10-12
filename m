Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4239B28C19E
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 21:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391468AbgJLTrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 15:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391283AbgJLTrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 15:47:39 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2E5C0613D1
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 12:47:37 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id v6so12593891plo.3
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 12:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=kRLElTJYruy9BhLgGAtIqt00VI4hnTdleImYdQGJD0s=;
        b=VbYCilhzAh5d75jt1/Rw6IKq31I6bNJFp6cHs1XQNsyBaYBqeeBxEkKtocNPrtcP0Z
         +w7CfXSo3bcsAPsj6fGJtysBZpZBhE1f+xBDx5ZP+qcXiSXJQhZrSDI1uebrNrnataKz
         +7XWoXogA9gFu4cCIsoTjymFVLzL/yG60NvjsSyEjDrDgMLIyPrYjr+L4pt7cK0Rf6Ye
         DdxXp1zx+hfzd9YgD17pETaYiKjBLCFVDV6QfKIFzEHZH8jnQRclkXo2kaw9zJP6kIk4
         iV7UPrHJpUJ3PdXCrR4rhkFGeOJk2AGgeESptIG6mujHn0YcaEchg+d1mOLDHOYi0sNs
         8cvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kRLElTJYruy9BhLgGAtIqt00VI4hnTdleImYdQGJD0s=;
        b=nhiW3/2JnYtDALW5gdTqOJtRF9Ppv8q+etmFovCn6GMNg3qQP+uE+N1t1o0TwW0ICV
         3Z3+uyuvl/0b337duT4bcVxMU30XagX5QGTjzml4PHTa4tHqjr99RR3EP7QIUTq9kNE4
         Y09axxjerRGypEigSziVcVa6sGLnXUkdSuMpTZrauXnseYrbxEgal03Z4lKS8/iUD4o6
         V4RIN5g6p2ESBTvTI6aMWwnmUeTsvi0N2x1C9BP9x0qCyZLnkiIrWjinAH76es39jrXP
         CUoexvs8HeX0ArfXtfUX0v/ebycp/kZdSAQvN9ypMaTAnfq76Mu2bzsIZxX+PDPg3Ze0
         LbKw==
X-Gm-Message-State: AOAM533Go0Qcm37y7VdUeQwGgs5pu0tAA6TkmJbI0q400Tqy481OE+dd
        eMtkxVTXEPHlIjwVllWhtZPysxDNdcDuZ/Ji
X-Google-Smtp-Source: ABdhPJw8LETdjBiV9xMt/ibGjAUwIHaHuLJo2byCuH/Tr//Hlh5fn1CGAP0/0JWCDMwrxSK+PfRE/sRRTkY+XkcU
Sender: "aaronlewis via sendgmr" <aaronlewis@aaronlewis1.sea.corp.google.com>
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:4b8a:: with SMTP id
 lr10mr11547252pjb.217.1602532057197; Mon, 12 Oct 2020 12:47:37 -0700 (PDT)
Date:   Mon, 12 Oct 2020 12:47:13 -0700
In-Reply-To: <20201012194716.3950330-1-aaronlewis@google.com>
Message-Id: <20201012194716.3950330-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20201012194716.3950330-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v3 1/4] selftests: kvm: Fix the segment descriptor layout to
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

