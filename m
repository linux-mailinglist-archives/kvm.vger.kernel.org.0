Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA2948E0E5
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 00:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238225AbiAMXa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 18:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbiAMXa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 18:30:28 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C78C061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 15:30:28 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id b11-20020a17090a6e0b00b001b34cd8941bso7373098pjk.1
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 15:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AODmhi+VFVOG+MvvbisKfeB6Iw9Su49eHa71dUbmlmA=;
        b=bxeFdK9WJLI66HSyP4lpHPAtIHAYec8lVTpn/S7/MaOF2WsxLgxtfnQbYV677PXhMu
         urawvuv3svgJdAzIyGU8nCDNfUXvjEGWrGGc3cJfvItDRfUCRaU8KlHB7qgz+gIQJC4f
         4iiA4HecR57+G0i799Aci9KYlm60dqibXQ5mQq1ygAwRtF6UWaQzHrBt3/XGMBOjDLe6
         acePpfhA7FGAZliB20S8B7d1IlaD8Tp908JE5LiPnkVW4zHo4kPP42kTCPjqi7KKSFWN
         xG6gSsvouTddqbjPZwDz3968UDCmK6mn7f/4yJhByqGlbDZq5XJ7AawvEU/vG68Hg1jw
         w96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AODmhi+VFVOG+MvvbisKfeB6Iw9Su49eHa71dUbmlmA=;
        b=4K+UEDePvHiB4p9UavN/wuClEteBz7lmDzIB+NuMWV+XlBIItCHQ8irM6iC6deHiJw
         LM/f/Lz8afPjYZqgt+ZdP6vIb2GTj9/wJmSkq/rBJpYpogf+1tSy6cdUdKnf9TrlMz+n
         qpwoSOY4L2zmqrZM0klSHXGmyxEFugJFhwXFX6jcpVz3in1rk6Ns84LCNUUppunKMcwA
         2whNC1puzQrbWDNb+8LVdaHhxoo/5lmYFeD42XHiVaGT2iD9VViqeXiURv/y6cWjm8/D
         A4qH7RyJhavqAeCxHdInVdZNKOxr8OMyqQagnnc1neI5LInGAesEK3Zm2KKXokSM+xJe
         UxTw==
X-Gm-Message-State: AOAM533pRX2lovvWKmSbS6URcH0Tg8tionZP5i/6Cvcajk5Z0Gd4aquR
        5ErWhPsyB1IC/iA3PS6qn5QU5vYSe1orGw==
X-Google-Smtp-Source: ABdhPJxriZlwjXtF3bvJFUTSejcCogC/4nB+r5mqRBy8EOIMxpDaUBXxu+Ojo7pkTbJUC3yDhA9I4vhV86og9w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4012:: with SMTP id
 ie18mr7620806pjb.43.1642116627813; Thu, 13 Jan 2022 15:30:27 -0800 (PST)
Date:   Thu, 13 Jan 2022 23:30:18 +0000
In-Reply-To: <20220113233020.3986005-1-dmatlack@google.com>
Message-Id: <20220113233020.3986005-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220113233020.3986005-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 2/4] KVM: x86/mmu: Clear MMU-writable during changed_pte notifier
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When handling the changed_pte notifier and the new PTE is read-only,
clear both the Host-writable and MMU-writable bits in the SPTE. This
preserves the invariant that MMU-writable is set if-and-only-if
Host-writable is set.

No functional change intended. Nothing currently relies on the
afformentioned invariant and technically the changed_pte notifier is
dead code.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/spte.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 8a7b03207762..f8677404c93c 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -215,6 +215,7 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
 
 	new_spte &= ~PT_WRITABLE_MASK;
 	new_spte &= ~shadow_host_writable_mask;
+	new_spte &= ~shadow_mmu_writable_mask;
 
 	new_spte = mark_spte_for_access_track(new_spte);
 
-- 
2.34.1.703.g22d0c6ccf7-goog

