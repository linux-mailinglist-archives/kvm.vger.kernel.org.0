Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D164D4F9E
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 17:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244279AbiCJQrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 11:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244125AbiCJQr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 11:47:29 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F221986EA
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:17 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id e13-20020a17090301cd00b00150145346f9so2958342plh.23
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6/GjUUfRe2TednvAxOrIHMT0ZcA0ouG3TTihxHdaCW0=;
        b=Ci9RymXtUyaxSqLze1CsiykAC+coEyY7bha7vdnz2IIfbsq+NipcxCu5E/6SKCYP8P
         AZWfyT5rXjCdQA1Gc4bceeNSCG3fmAHG5yIaY6IZRZjo4kFmN0YpfdldarRV/GfHnuBu
         S6vSmARKH46PTiE2z01E5t/V2c3KvFKPvZOphqNi9lLlORngKiLyJmhydv2dYqkYeqtA
         1c/QNL7R77dPvsGRnw1KCbfnc/kg1T0Dxlq2eZnnBoYWzQ1Jma9qeKXqm9VBmtJC6bEA
         JuLGJJoLaYlYhGieelYs4IiVe8BaquDMzGy0TH0xQKbMAD3FEy/HRFuNfprA6v5y0zjf
         MNeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6/GjUUfRe2TednvAxOrIHMT0ZcA0ouG3TTihxHdaCW0=;
        b=FWJi/Gu68m78ey+15p0wGvzOyMMhv4wU4Cz0LZPyy6Se+x2hQHEf2grIp9B8pnbZdU
         llybw5PP7DBSKgtO5P/z7S0KgIMN6ZoXhv2nLiL+LIw2JR3OKyypBaqrD/hFTvG/iROQ
         5pzulVhFjg+CN/cm8dDvcwcwbH/OiOiJfWOPJZBGoHay3faw2g5nygnb9cLb1zeytHyh
         tCL6Jylq9GCQjpJKRdUIPAbkQ2vnEfWuEroIJMzo9fXAIuM65EieoYiF91pJ4N+HgTn2
         B58r7e6l+zG4z8TShbVy0etbPbJstlVi6Ewt65cd0OG6QZuxe4s7p3vsrxqi64+hjULd
         YK2w==
X-Gm-Message-State: AOAM532tf8OjSEB+fivbvneMNcO9Ikb4WGF5AdLQ4+9csuSBj2whFmxv
        WH8c3YJ2O8cdWgZY2+vfiMjUWNdkkMcZ
X-Google-Smtp-Source: ABdhPJzwNz0xJOQ5UQ4Rax3VSodtAuXU0L+axkICu24kh0fHPhU/xTF0kOdXzALpDVGWwJbMh3I+GHUH8LsJ
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2d58:733f:1853:8e86])
 (user=bgardon job=sendgmr) by 2002:aa7:8889:0:b0:4f7:7283:e378 with SMTP id
 z9-20020aa78889000000b004f77283e378mr4535906pfe.36.1646930776770; Thu, 10 Mar
 2022 08:46:16 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:45:30 -0800
In-Reply-To: <20220310164532.1821490-1-bgardon@google.com>
Message-Id: <20220310164532.1821490-12-bgardon@google.com>
Mime-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 11/13] KVM: x86: Fix errant brace in KVM capability handling
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
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

The braces around the KVM_CAP_XSAVE2 block also surround the
KVM_CAP_PMU_CAPABILITY block, likely the result of a merge issue. Simply
move the curly brace back to where it belongs.

Fixes: ba7bb663f5547 ("KVM: x86: Provide per VM capability for disabling PMU virtualization")
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 73df90a6932b..74351cbb9b5b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4352,10 +4352,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
+	}
 	case KVM_CAP_PMU_CAPABILITY:
 		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
 		break;
-	}
 	case KVM_CAP_DISABLE_QUIRKS2:
 		r = KVM_X86_VALID_QUIRKS;
 		break;
-- 
2.35.1.616.g0bdcbb4464-goog

