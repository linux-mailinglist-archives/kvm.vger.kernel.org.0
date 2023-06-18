Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EAF73447C
	for <lists+kvm@lfdr.de>; Sun, 18 Jun 2023 02:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbjFRAJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Jun 2023 20:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbjFRAJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Jun 2023 20:09:20 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888CC170B
        for <kvm@vger.kernel.org>; Sat, 17 Jun 2023 17:09:19 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f44c25595so1035623a12.2
        for <kvm@vger.kernel.org>; Sat, 17 Jun 2023 17:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687046959; x=1689638959;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SZRhH39sdwsf6mf7jmU2xtyZAtu6JfAYC83IgKKrw3g=;
        b=yKkIRX0QpeQIZE1DidVGEAYWTGzy1a7kdjPPYLn8eK2kTitM+zJT9u6VA55WaqmtV6
         pWHjiKIuMZWbo2Pnap/dtOis3oRHJicAz7uD3wD5V/AnkB+f30edVXETNO//NaRsMPv0
         k/E+3VFdUlcad6EjHg+NVkBMrG8YirRZjg8CNYDb5HsmaTFw8gxIHruDw+7xEj5a/N9b
         s5WHerxEKQKPsUwVjAKK/8YaGjoM7Q8orVuDn+mfc8+Hw4YWUMIAnvwn2u9CkSdrJgFI
         sI+/eW+ixsQaT0cz+EHG9Hcon8LeQaDmkuRhNbgFglelLp5mNWJKezlzTzT9vI5/yjsC
         68sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687046959; x=1689638959;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SZRhH39sdwsf6mf7jmU2xtyZAtu6JfAYC83IgKKrw3g=;
        b=eTfuSYxm9PWaTh2i0zCDJnWKNPwr5pc6r+sH3txf0adCDCJi3sZzuztB7VohVfBqCT
         a6azpMy8Z2w4juraILNd9FpimtoYA2Pry/qO7QCc9Cbl9TFsbcj2EdXikYAXl6S+TTNl
         51dOH0soX/fRgXlqUhmZj5DmSVtu+SCT7sJsHO50iTfnq1Jd10XMdHorrBI/VW+bcfJk
         EiUXYpGobbfr667KBwJcc6hgE4PT7oI6rcTUQZpuPmSCVuMFrM9YcTe9zgA5N/9sag6f
         RuyOEm8KbOTX2LpvQ99BNcpWqj8DPAkeI9Ay0EpzsS73+BqS5+ij2wHp5DTG5tmlz17n
         AO8g==
X-Gm-Message-State: AC+VfDzkIE3tZSan6+sC01ud6DN3tYbE+KoRXyhlpo5wpP6bugbpNLev
        NEIzfMcyDBhWmvYlgnK0zBRRtICwGDyE
X-Google-Smtp-Source: ACHHUZ6s/0SDgBjDHb7lnw7v17wR8UYblxJ4u12S9rHeLlYYijB1xGLNmU6+VDed2EOc0mlXhPDl+/6YPoZi
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a63:782:0:b0:517:ce37:756e with SMTP id
 124-20020a630782000000b00517ce37756emr406250pgh.7.1687046959115; Sat, 17 Jun
 2023 17:09:19 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Sun, 18 Jun 2023 00:08:54 +0000
In-Reply-To: <20230618000856.1714902-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230618000856.1714902-1-mizhang@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230618000856.1714902-5-mizhang@google.com>
Subject: [PATCH 4/6] KVM: Documentation: Add the missing tdp_mmu_root_count
 into kvm_mmu_page
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tdp_mmu_root_count into kvm_mmu_page description. tdp_mmu_root_count is
an atomic counter used only in TDP MMU. Its usage and meaning is slightly
different with root_counter in shadow MMU. Update the doc.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 36bfe0fe02bb..3dce2426ad6d 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -230,6 +230,12 @@ Shadow pages contain the following information:
     A counter keeping track of how many hardware registers (guest cr3 or
     pdptrs) are now pointing at the page.  While this counter is nonzero, the
     page cannot be destroyed.  See role.invalid.
+  tdp_mmu_root_count:
+    An atomic reference counter in TDP MMU that allows for parallel
+    accesses.  Accessing the page requires lifting the counter value. The
+    initial value is set as 2 indicating one reference from vCPU and one
+    from TDP MMU itself. While this counter is nonzero, the page cannot be
+    destroyed. Note this field is a union with root_count.
   parent_ptes:
     The reverse mapping for the pte/ptes pointing at this page's spt. If
     parent_ptes bit 0 is zero, only one spte points at this page and
-- 
2.41.0.162.gfafddb0af9-goog

