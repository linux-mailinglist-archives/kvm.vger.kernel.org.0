Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA356734474
	for <lists+kvm@lfdr.de>; Sun, 18 Jun 2023 02:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbjFRAJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Jun 2023 20:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjFRAJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Jun 2023 20:09:14 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F65170B
        for <kvm@vger.kernel.org>; Sat, 17 Jun 2023 17:09:13 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b549e81cc1so1553895ad.2
        for <kvm@vger.kernel.org>; Sat, 17 Jun 2023 17:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687046953; x=1689638953;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VS80TIN3Apx7Lv9ngje3zYu1jx02+rpCr9yV1s94q+g=;
        b=qsV0MFwzdd4/C7i0HHJ9CBkbmMVR7hwOd2cmA+0KzTHzNh9ELEVms5TTB/4dzHUDyy
         gGGdEsHTFl85eB0vuIJz6s3e58HYKqZmv2eJfSw+XXEzHrnK15RPIln+eN/w3Mzlec61
         nqju5F/mk+3B7UGborz8J3MyzvFeWabttyLOn3D+a0ziu6+Xt2aVdnvkedR5h4IlvrhX
         Y3FuKXEauGt+lxIdBa18cGzxxXjmubFYp/Y+G3XWoTZOCVdaFMpsjXlNOe1u6FIM6l0U
         DxJKRaifxq5yPP+xvMAo0t85Tci89KUCc436mq+go+r+m0TnblxwU7rIG/1LtDaTjYR9
         hoBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687046953; x=1689638953;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VS80TIN3Apx7Lv9ngje3zYu1jx02+rpCr9yV1s94q+g=;
        b=YbicZgmLn3uItJoMnBsZhT0QOPJFQMkPQwZlCohNGBsymCHoz/XHX/8D8cGhc8lh8a
         qMFuER2GuxeZmX3drWeoSnw4bhN9HvBLsdnpfWFde5EwZRIGiUMDrsnT3y0RW7nsv1+l
         W7ewgGDbGr8GNx0rLaRyTuX67wIM34fLPyLdeCvXVIv22qEqX2GhgnWNyDG1Oua8XxI1
         Nefrpvr6VuCb0wL4bV5Bb0HGctLfKRwOkG6VtiWFtHK5Tp6NnoRfhgZgjB4jMSG/UoOY
         b3lNegTwsKUaBhQCt8PB+c05SBmNi6+489ADQtIB6zWjSGq/IYjk2QwE2rDpDk7q7Wiy
         bPpA==
X-Gm-Message-State: AC+VfDwYq6zlSECD21hY55oHvevhWVmuYFeGr6jB4Y6RN66elBGGPTQU
        UyO9UCUHMafuofBY3cKAjSZbiwxtNWS+
X-Google-Smtp-Source: ACHHUZ7FUaWe91QusDNXC7G8USu5P3g7Xm5fFQ3geWg+aIW+9MIzFHs89tza+DkgLMXcq6FDjqk2LCkqQA35
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a63:ed06:0:b0:546:a389:b815 with SMTP id
 d6-20020a63ed06000000b00546a389b815mr385438pgi.1.1687046953388; Sat, 17 Jun
 2023 17:09:13 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Sun, 18 Jun 2023 00:08:51 +0000
In-Reply-To: <20230618000856.1714902-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230618000856.1714902-1-mizhang@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230618000856.1714902-2-mizhang@google.com>
Subject: [PATCH 1/6] KVM: Documentation: Add the missing guest_mode in kvm_mmu_page_role
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the missing guest_mode in kvm_mmu_page_role description. guest_mode
tells KVM whether a shadow page is used for the L1 or an L2. Update the
missing field in documentation.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 8364afa228ec..561efa8ec7d7 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -202,6 +202,8 @@ Shadow pages contain the following information:
     Is 1 if the MMU instance cannot use A/D bits.  EPT did not have A/D
     bits before Haswell; shadow EPT page tables also cannot use A/D bits
     if the L1 hypervisor does not enable them.
+  role.guest_mode:
+    Indicates the shadow page is created for a nested guest.
   role.passthrough:
     The page is not backed by a guest page table, but its first entry
     points to one.  This is set if NPT uses 5-level page tables (host
-- 
2.41.0.162.gfafddb0af9-goog

