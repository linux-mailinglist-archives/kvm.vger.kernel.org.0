Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C6D53DA74
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244245AbiFEGnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243547AbiFEGnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:43:00 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C5363D1;
        Sat,  4 Jun 2022 23:42:52 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o17so9851011pla.6;
        Sat, 04 Jun 2022 23:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hHrG+8g/+cCdW5LjmoH+wCD9PYTReZVDi2xHgaOhftU=;
        b=WIKcI9O3ojEclt+VX5vNSC4mC86qquiPp+Ridyb1bNhoDgbqSmWl+m1DYgc96SCja5
         RbxIWRToZjU+ul9tr03RJ/y0cqaJbOYMMxpVqLMrcCOi2DSH45TWFYH8Q9t3IY2K/21f
         MZEpuYeg4ZoGyNBzocBMGyBZ0RD3ws6qvqBpaIKAzwdk1OgIY0mpnqPx37zcA7yhFvyG
         VuJ8D9/A9mTsEpFWTHMsF6UEFJnExmGWBqIAzlNtcO4MddOh4BhY8eQ9G6cqaUjGVGfx
         EaaubWETwxCMzHMAZTpv8ocl4FC330IPX/WPhCFStZo5wIncLXBo0rSzsEbZtHMDMuDW
         ZtZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hHrG+8g/+cCdW5LjmoH+wCD9PYTReZVDi2xHgaOhftU=;
        b=V3j1vHvvb6gW309uFRlKqNor5JoTpRTZm71ChKeoBg6KkpTKXBFh3dVNOd+eFft5je
         PGnqECx92CiqYJF/ODLEtxwxCnHJ/9YGYdskh4ivUApLteu3fYtpS5AiVSOzgU9WzADx
         0pRrwYBEg2GOEh4Pj5X6npMwxBH5LttbzDywlYrQ2O51obUGgwsdVZ42AwPX/8e3HWVu
         6U8Vqnnb6U/8qvhRTFkFXuddsdrV8bBC3BNSuDTODUzatbiO3dKD0l/4YxXpcDTm/dsy
         hNYDmYPJAgqnDUW3S5umEMeH6t031ZNmoug9e9A4DT0Ng567kUzaPoVcq0NFMvvUGE8G
         GjFw==
X-Gm-Message-State: AOAM532BTUMEhUkwq2HelcIStvzLctNXDyAIWQ5pQnIGsw6gyZ7yv04A
        58Go/r/TEHGm6lWgfZ/via0cNMJgQT4=
X-Google-Smtp-Source: ABdhPJwf+7H8oNSuT1793ocfEsdkHmtVRwjx6soGsjfx4qIWTs91QTDOs6GVHi4FYqQb03DCT0w9QQ==
X-Received: by 2002:a17:902:7e01:b0:15e:caea:d6 with SMTP id b1-20020a1709027e0100b0015ecaea00d6mr18212182plm.33.1654411371626;
        Sat, 04 Jun 2022 23:42:51 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id g7-20020a636b07000000b003fd3a3db089sm3483496pgc.11.2022.06.04.23.42.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:42:51 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 00/12] KVM: X86/MMU: Simpliy mmu_unsync_walk()
Date:   Sun,  5 Jun 2022 14:43:30 +0800
Message-Id: <20220605064342.309219-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

mmu_pages_clear_parents() is not really required (see patch4).

mmu_unsync_walk() can be simplified when the function is removed.

Lai Jiangshan (12):
  KVM: X86/MMU: Warn if sp->unsync_children > 0 in link_shadow_page()
  KVM: X86/MMU: Rename kvm_unlink_unsync_page() to
    kvm_mmu_page_clear_unsync()
  KVM: X86/MMU: Split a part of kvm_unsync_page() as
    kvm_mmu_page_mark_unsync()
  KVM: X86/MMU: Remove mmu_pages_clear_parents()
  KVM: X86/MMU: Clear unsync bit directly in __mmu_unsync_walk()
  KVM: X86/MMU: Rename mmu_unsync_walk() to mmu_unsync_walk_and_clear()
  KVM: X86/MMU: Remove the useless struct mmu_page_path
  KVM: X86/MMU: Remove the useless idx from struct kvm_mmu_pages
  KVM: X86/MMU: Unfold struct mmu_page_and_offset in struct
    kvm_mmu_pages
  KVM: X86/MMU: Don't add parents to struct kvm_mmu_pages
  KVM: X86/MMU: Remove mmu_pages_first() and mmu_pages_next()
  KVM: X86/MMU: Rename struct kvm_mmu_pages to struct kvm_mmu_page_vec

 arch/x86/kvm/mmu/mmu.c | 173 ++++++++++++-----------------------------
 1 file changed, 51 insertions(+), 122 deletions(-)

-- 
2.19.1.6.gb485710b

