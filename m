Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5577A570FF6
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 04:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiGLCH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 22:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGLCH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 22:07:27 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DD35C95F
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 19:07:27 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id q4-20020a170902dac400b0016becde3dfbso4822035plx.17
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 19:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=QxrAx9Z3+VyOEyazCWc6ZknWo0acaxb9Pf/HQs6PsAU=;
        b=DBjdB7rX8R2eCVzw8wxQJx2Kj+fv0iNeqo5S7ZFjEbuMgqe7rYf55iL4WCbW9ik+/a
         fEwbjW0e3PJhGlIRVHz6GO3dXU7C/ndm3gip4tCAzTXs6bdcDK3yWFYcN5sEFGdSDoH0
         qSIGoI/nnpY/vZ6p6Rtqb+hMnXqSU9L7S8wv8X7psaBSgqxU1hP4hZ5wavNoEBOfmCA8
         5jwwrotx0+mbG1gnqXFOdyNvWKIUctndsZrKUwIJHKbjwb6XwtyH8g6E+V8aDraV8hBg
         iaJ0DthFmgkP/XGdKbR3sp0vi1xQucy6rD3dW7S0q4BwTZArHLsCEIJ/bXSj5tFulDWy
         0whQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=QxrAx9Z3+VyOEyazCWc6ZknWo0acaxb9Pf/HQs6PsAU=;
        b=PR+tEcAC5ooMDTYPiSlbkujVNI5aoB2vQ/bEsU0lBC5BALUcgYwYMJO8FzwBWUoESp
         pawkAQp7oXGvxrXLqJe7mSIuH7VCy3jA6cDl31SHhA9TLbz5HbnjkcQsUXzn2clKeXR1
         GOkjKNC3gEJKJUFJAcYEsBJPSOBwcF2+XMYPPA5eK0rV+67hJfI/2/OITnWWPimWe/A/
         C+ZzToOywFcJEmc4ga7Mi4DtrLqazPF+YgMHXRIPzSBGbCFgO1H4BSn0Rdf5oJtjMWcY
         rvUrjw0C9pmMV/ECzGzr9fOc7UrVxSkjWP9UgQPw1rQrZhsAv8/xp5MvnYSzQdHMmnO2
         kUWQ==
X-Gm-Message-State: AJIora9UG3t6Jstr7nxJe71cSrOkgpZDbSTNl/BEgmuTJtQJSXFFUdzw
        NkfvpkuS/B0HalKkW/X2LY2mKf4Uibc=
X-Google-Smtp-Source: AGRyM1ugA4oKuvcg6J/K1llP2AXgK0bfOhRgp6ZPou6i8YdfcnRAbWrCCGHFQB+O6KZnck8mTFXNxjM5Yb8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f650:b0:15f:3a10:a020 with SMTP id
 m16-20020a170902f65000b0015f3a10a020mr21278189plg.61.1657591646627; Mon, 11
 Jul 2022 19:07:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Jul 2022 02:07:21 +0000
Message-Id: <20220712020724.1262121-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v3 0/3] KVM: x86/mmu: Cleanups from eager page splitting
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>
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

Eager page splitting cleanups for a few minor things that were noted in
code review but didn't make it into the committed code.

Patch 3 is kinda silly.  If it weren't for the typo, I wouldn't have
bothered (the existing comment is good enough, I couldn't stop tinkering).

v3:
 - Collect more reviews. [David]
 - https://lore.kernel.org/all/20220624213039.2872507-1-seanjc@google.com

v2:
 - Add helper to compute SPTE's index into its parent. [David].
 - Collect reviews [David].
 - Tweak the comment in the last patch after more analysis.

v1:
 - https://lore.kernel.org/all/20220624171808.2845941-1-seanjc@google.com

Sean Christopherson (3):
  KVM: x86/mmu: Add optimized helper to retrieve an SPTE's index
  KVM: x86/mmu: Expand quadrant comment for PG_LEVEL_4K shadow pages
  KVM: x86/mmu: Fix typo and tweak comment for split_desc_cache capacity

 arch/x86/kvm/mmu/mmu.c         | 52 +++++++++++++++++++---------------
 arch/x86/kvm/mmu/paging_tmpl.h |  4 +--
 arch/x86/kvm/mmu/spte.h        |  6 ++++
 3 files changed, 37 insertions(+), 25 deletions(-)


base-commit: b9b71f43683ae9d76b0989249607bbe8c9eb6c5c
-- 
2.37.0.144.g8ac04bfd2-goog

