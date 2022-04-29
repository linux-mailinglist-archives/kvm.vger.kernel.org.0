Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D905153DB
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380089AbiD2SnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380079AbiD2SnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:43:12 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD30FD64DC
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:53 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x9-20020a056a000bc900b0050d919e9c9bso3283863pfu.1
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3CMhq67xTlIFikMfvwBaSUyLTSFbPR0YXiRyht/Utnk=;
        b=r+W/+qQPY1LXyrfIyY9EziNWAyrEZrAhUo6RNdVNSy6Q/z1ndphTX91UY/816fSaOO
         pwBxhuJ6oY0DQJgNJZDNMaTCxpnNnXVsdCqrNKT44c0QfAHIrJWZ1kehD3HOypomEKWi
         mrmZO1GQNDZxPSRQtiNZ6OxqQTTUPpBrKZ6n6pHpHD6f4C6HbqC8gwHv1t/f18y9b+yj
         /h7l8skPc/HvcvihSNNp3hIrJ9uAL6GTsr7OvUXqrhWLxJAs52Ian4IGJahUaTbFqS3O
         qM6wOo6PacwQD9YzwJr9NfQ9GzworvyNVr01IriJ0R5nPKhXoh6jbSeydrT9JIkLZVEx
         QRhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3CMhq67xTlIFikMfvwBaSUyLTSFbPR0YXiRyht/Utnk=;
        b=rJvdcte13vmlImPNOR81f/7Ru1S3sUoW5kDmyiwjqTT7M6Xxnsk0aSuYbGtZhlYkU4
         olmAOP7yJL2a6hOJyJ666XPAZvHlTugtYnvK9fB6WZ3mrtjokSNsLrzahagJ+I43hmYk
         6ik1/ggs4FCs9bwnsqOJS7Ym24QqTL6yb/wqOzSsoUVR1fN2ZxToyS2l9GQFZkgOMO4L
         LMsKu3tRuZkny0vrmEbh65EqqGkk1O/0dVzH91HKbMLqabHQm5Tt/M7WcDT7cUd/18rg
         LW9WbtZCLZ0ZyUhIJh4WhW0hGMwHWiQ6eSStNaO94cRHkPhp76WGYndERy3q9MuqMUei
         wJtQ==
X-Gm-Message-State: AOAM531iHt/YYmeIAb/kS0fECdKYH+7xiru4deQFVlmx0ZeyIaMwd9zu
        upC/po92Rid76QnudtOGNuqWyD6Mi0Um2Q==
X-Google-Smtp-Source: ABdhPJzfQzAGmdDGqEOinV9ksGDLVYyXzm6LAokEQsgVFzbYHLSQ1pusd3jOwyK2DlN+xK//kQTqG4bPoX40uA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:cd49:0:b0:50d:b02e:11df with SMTP id
 o70-20020a62cd49000000b0050db02e11dfmr644111pfg.4.1651257593204; Fri, 29 Apr
 2022 11:39:53 -0700 (PDT)
Date:   Fri, 29 Apr 2022 18:39:32 +0000
In-Reply-To: <20220429183935.1094599-1-dmatlack@google.com>
Message-Id: <20220429183935.1094599-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20220429183935.1094599-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 6/9] KVM: selftests: Add a helper to check EPT/VPID capabilities
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a small helper function to check if a given EPT/VPID capability
is supported. This will be re-used in a follow-up commit to check for 1G
page support.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 715b58f1f7bc..3862d93a18ac 100644
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
2.36.0.464.gb9c8b46e94-goog

