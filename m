Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5688D52F566
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 23:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353796AbiETV5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 17:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353803AbiETV5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 17:57:38 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CCC18FF04
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:37 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id g5-20020a17090a4b0500b001df2807132fso7579259pjh.7
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zIzRUypz+W9E6mtg9tuZCtp0bD/d3NxgK2XH6wHm+BQ=;
        b=lzkGbxkf2ehhKYfK6S3OwjfDWJjLf7d6QhQboP/E/laGMeRIqVbDGr6t3Nq5MtKcbf
         VkKezaVqxCx38eOIC67UkssNKWJFAsovrUVFMTaCzJHsRjmQu6TyA8C23zzP0Urr1PVw
         sTYfhkogK9mhgiX67QNvjQWi9oHGSJVjSvhyz4ATHzsTs7w67mVEjnTK17lPKhUaWVUA
         Xojw4RKfFuYTWwhhBnafs25YyyR6k/jarM4jtArvZY/5f8pZWVkH1X0BIsKNHTlkEABm
         9pSNJaSwU363zD9WV2WScf8gf11Q/bEcTcc2XKEdtEb2dJuwR6KFwlZ89HDqgAIignNd
         YUYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zIzRUypz+W9E6mtg9tuZCtp0bD/d3NxgK2XH6wHm+BQ=;
        b=SgMitj6Fkqc6VI7kdGEBQbB9AM7TqCTKykWS2/Mk+6AoKEGCCH8a3E0WF3ruMEzhcq
         vmEaJJWf4anIEj6clhz42cCnOyCPRfboX8HsrAISXvyv0hj5xdORyzAyIdbaUDUtmjU9
         wveBqYdo71BoVZ9IwAxO1rtrsVPS7Ns8fIM2u7JRqVbi+02VpH1A0ubMZ2O2Pt+EBkwr
         DP6pNAZo2yET/EZxDK1fDFaosrfU9R8XdCgrKH2uMvcKXg+md4vnUjfbKZ6kF4HBYpOF
         fJ6B4rVLjV4vYBycD/f8LUnM/5WrIdhFIfL0BXknOAuMayCPVooxQ7SSu9WYar6Kmquf
         EJKQ==
X-Gm-Message-State: AOAM531D2VnJdHv2SsmzoKj7ME+DIoWbQK1ktq67sFp/HCn3oyqTejWh
        1o1NRHAdKNH/ZW346g3/Vb/FyBwLOSU8zA==
X-Google-Smtp-Source: ABdhPJxaxMBdZrcVn1fPFu7IgRd1JMlKjV9MGZHsI5h5RID8RyDbDhMRRUkKBSP5NgIr0oNodApYpXKy77jo5g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:228d:b0:510:7594:a73c with SMTP
 id f13-20020a056a00228d00b005107594a73cmr12032983pfe.17.1653083857218; Fri,
 20 May 2022 14:57:37 -0700 (PDT)
Date:   Fri, 20 May 2022 21:57:19 +0000
In-Reply-To: <20220520215723.3270205-1-dmatlack@google.com>
Message-Id: <20220520215723.3270205-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520215723.3270205-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v3 06/10] KVM: selftests: Add a helper to check EPT/VPID capabilities
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

