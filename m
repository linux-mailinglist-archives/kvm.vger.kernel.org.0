Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F0259523C
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 07:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiHPFyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 01:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiHPFxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 01:53:52 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC0F8306E
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:27 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-32851d0f8beso79665527b3.22
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=x0zAkD4YhDSAmJJLXBaHHVhHveKV6FeZwfvyZmVn5X0=;
        b=YKGv7atx+z0swJ45UbcQNtvE5xMGQxflFCn4o6NmqdzeLLedpsYgGOnVIwkryg5QXj
         Cf0i8FDG2rYCn7PWKToyf2Qq7oVLbLhzo0cEZUgxzqMyKGaFr3Krp1JOI4jqABCff1vY
         DSbUFGLtp4hqnJOu2KJJt+tEFsPDjeMSwlBILgO/9iy4nBdIJxtLHA+ials3vP8IixF1
         4Lg68EgJHfW31fvAlixFWgk7hPQijjAog9/+JpXPfpCXhaqlQuMWxiqipmu1ipsVEexP
         dgRbK5EwmT86pIVeGuSCbuzZU0+Cw4HAvU/dCWHdyK7iCYjqgBhIllTG4+2FtXUgjWy1
         hJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=x0zAkD4YhDSAmJJLXBaHHVhHveKV6FeZwfvyZmVn5X0=;
        b=W0+6Z/Vnvx7o9d+/AY3v5VwvXolmms04bGkg2go/6p//I8KYBCw+doSiePPJ25dbwJ
         wh+R2BEBoik0bNtngVzPpzwkoeBfEhOH6Z9JmJSJV8vZDDjAUBBJKKE6CPGbcY+qS74b
         Gl3U2qZi0ZHgY0lVIa5SqAzKO0MERl0I2FRfG7yfBPsXhYzixUpZWUSngkB1EkqaIjn1
         99hBU6qAZiAUpcQdzfoX68tHClJjqgXAvs1UOErne6B+jltp+6/nsaiLNIv1lmj8dVKr
         YBk03ithIks9kibebB8HT2T9GgCv8pXhcg0W429cKa3+Cp5ZhY/vFQpVEPFbP4El3vfy
         KfvQ==
X-Gm-Message-State: ACgBeo1vP8qil1RnpWIe4lXbNswjB+2YIMXjS9XwoymZKx/oE4TsDnnU
        vX5pt1PhEL29nxAY0BDwvEDFqKq5GDg1SA==
X-Google-Smtp-Source: AA6agR5rUC/TtKyQ+gsohEYcWg86cK/+z/iP5ITaqRkvK5f8p1jOa0hQFZj+qURvGh8+rzD+6+P2zKuQfs3fmg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:1a43:0:b0:330:b88:2537 with SMTP id
 a64-20020a811a43000000b003300b882537mr7590329ywa.15.1660604486573; Mon, 15
 Aug 2022 16:01:26 -0700 (PDT)
Date:   Mon, 15 Aug 2022 16:01:07 -0700
In-Reply-To: <20220815230110.2266741-1-dmatlack@google.com>
Message-Id: <20220815230110.2266741-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 6/9] KVM: x86/mmu: Stop needlessly making MMU pages available
 for TDP MMU faults
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Stop calling make_mmu_pages_available() when handling TDP MMU faults.
The TDP MMU does not participate in the "available MMU pages" tracking
and limiting so calling this function is unnecessary work when handling
TDP MMU faults.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 182f9f417e4e..6613ae387e1b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4345,10 +4345,6 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
 
-	r = make_mmu_pages_available(vcpu);
-	if (r)
-		goto out_unlock;
-
 	r = kvm_tdp_mmu_map(vcpu, fault);
 
 out_unlock:
-- 
2.37.1.595.g718a3a8f04-goog

