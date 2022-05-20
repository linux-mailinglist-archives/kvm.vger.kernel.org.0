Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3847C52F63B
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 01:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbiETXdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 19:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349869AbiETXdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 19:33:05 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EB3199B36
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:04 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id jg18-20020a17090326d200b0016178ae1c69so4709966plb.6
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zIzRUypz+W9E6mtg9tuZCtp0bD/d3NxgK2XH6wHm+BQ=;
        b=WS5RNNhwOkq3lNDwZkeg0fLu8x7vpQFXqXm1/i9hTw2jICUkyuKzXB/oVSunEAPy+i
         /qbNm6ZiKBO4dHVQKx63HP/Zs0ceiCNplNgu4iyradr7ZvUB1aLOAMsaPERLTTM70lCv
         Lp5+FOZfPJa6mzLa4+l+kHFIGo2iTkwHYoKYNavDMYcL5qEuLPyoCKdsaL/SIFhN+TnY
         kw08F2A8lwG9iDhBAA0CJ3OFsU6sc7sAguZNsRJfan+PPFnbU1rGxZw+WJhax/ispZGg
         NgYfggHK/SJY+u08EJckAhEpZ5u/R3p1gxVHix7AOV7MxwRBKRDaiNi6x7vsw2ecaEWD
         UnEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zIzRUypz+W9E6mtg9tuZCtp0bD/d3NxgK2XH6wHm+BQ=;
        b=LD7Vmnt5OOwUZ/nvtcGZ9ZjTH2SAdoBhdzSX8UhCrHGt5pOfOFdPTGRmSXmy31Bplx
         pqeoF92JiWGNQM5rH5+qdHdL/PHuGreb+qAr5vBUF9pUg9lIYfj2u714ziHSmB4fJVxH
         aAOqHkViqaG6T0I+pNGCLh9KsKZft9jEeJrVTpImnBxa4wKI9DrBmD29bmYWpC37SBn9
         IgrhNS0bLT4shJ1YnERU09/+X0wanzMblw649XtmwibWN9gb++f763cdlyG9t40sZVX+
         VS0lGBm44zPeIznzVkPGjDUxy2/1TW4mj9z8h+9cVb0zloNLkIUqiAJM7xI1vuaJXXtc
         sjqA==
X-Gm-Message-State: AOAM531wkY8SXDS4TY2EZddY7iaxQcFwyMF+R62CDhO2FjJqLom2pVby
        /+W1zJLuxqFBxf7wpizaZdpFf3JHp9/lHw==
X-Google-Smtp-Source: ABdhPJwWcUFm9CbIAAOYRnE1jllqgChDLFkNIV3/mmPZngl6Lom4GcmZgwOznJK19Fts0mdIWkoAplTtwN+ODQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4d90:b0:1de:b54f:c5d with SMTP id
 oj16-20020a17090b4d9000b001deb54f0c5dmr13503524pjb.27.1653089583887; Fri, 20
 May 2022 16:33:03 -0700 (PDT)
Date:   Fri, 20 May 2022 23:32:44 +0000
In-Reply-To: <20220520233249.3776001-1-dmatlack@google.com>
Message-Id: <20220520233249.3776001-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520233249.3776001-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 06/11] KVM: selftests: Add a helper to check EPT/VPID capabilities
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
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

Create a small helper function to check if a given EPT/VPID capability
is supported. This will be re-used in a follow-up commit to check for 1G
page support.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index b8cfe4914a3a..5bf169179455 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -198,6 +198,11 @@ bool load_vmcs(struct vmx_pages *vmx)
 	return true;
 }
 
+static bool ept_vpid_cap_supported(uint64_t mask)
+{
+	return rdmsr(MSR_IA32_VMX_EPT_VPID_CAP) & mask;
+}
+
 /*
  * Initialize the control fields to the most basic settings possible.
  */
@@ -215,7 +220,7 @@ static inline void init_vmcs_control_fields(struct vmx_pages *vmx)
 		struct eptPageTablePointer eptp = {
 			.memory_type = VMX_BASIC_MEM_TYPE_WB,
 			.page_walk_length = 3, /* + 1 */
-			.ad_enabled = !!(rdmsr(MSR_IA32_VMX_EPT_VPID_CAP) & VMX_EPT_VPID_CAP_AD_BITS),
+			.ad_enabled = ept_vpid_cap_supported(VMX_EPT_VPID_CAP_AD_BITS),
 			.address = vmx->eptp_gpa >> PAGE_SHIFT_4K,
 		};
 
-- 
2.36.1.124.g0e6072fb45-goog

