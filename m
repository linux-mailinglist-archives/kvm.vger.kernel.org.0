Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B21D52AB79
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 21:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352497AbiEQTFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 15:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352462AbiEQTFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 15:05:37 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5101C3F317
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:36 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id y14-20020a17090a784e00b001df7b1f8b74so1813547pjl.5
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nKtCf/D8AHtF58lPeSd+9hqjs5ZUKh4TExdA+8ekbX8=;
        b=NGoN6rJ9giIGMJKOKzFa7GYebMLWUdsBxqIxZiBxtqrUXyiuEzQP/INLF+Cs00I6BO
         U31aC68MB3Ih58K8cSNfmu894NRNZfNaV7z2/C8eiI3tyPQUAaqTnkfiDePvUQv+vmqv
         mqPK0AM1e4pwtzhL7KrLaei8UpLik2l9HyGXMIXrSYNZHE45jZ1jyfwEqGyoe13+sVqc
         LMzRx9OV8WacgpEiFhUqmiWJJXjRDK6OKfvmKIH1G1vWtlcZco7wAn2o2XxALRTY3KNC
         gLIHeGIuk8pX2adqi8xyb9G6XC/FOs2S/lSBjmYxR9ISBO7YCfu/9mnv/zrGTLM7V9CZ
         HugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nKtCf/D8AHtF58lPeSd+9hqjs5ZUKh4TExdA+8ekbX8=;
        b=bc4DdOJnVk79qPqG+RSo0Z3ked4DY/aJ9iE/2WUYQD2wIZWRRJvIgiiIBzN8XVOYBi
         kB11mlQdIsTPCEst30sZD841D3wHNRjoYF3KVaPiFZ9XXOCaJZ9qLYjlSJbbVVvMT6MB
         YhoaY8gvhc3HTFObMOlgQeFYtwYk6Vg5SJuXYPdMnf9Kj60Vkw0dqiJ8KrGdPhXqyYQk
         u3S4ZQbIi5+hAlA7jUTFLEkDe0SkKuJbczLJz87r55Qip9dFrASD7EL4BGPE75HskewT
         RRYlOJXS3ra48I8DDdbA5sn9c4PjbYvBqp13jq7totbiDXnXxuLSSV62NUy25U/wDiwb
         ozaQ==
X-Gm-Message-State: AOAM530AeJ1cIqYscmgz12ot4BmZevd2AGkpeOsYwoOOd4r56D35j7zm
        mPphi43rQ/oITpqY5ffqPvpgWy4/WVnj9g==
X-Google-Smtp-Source: ABdhPJyLOlUIAqeJnLwPpcgSgn9QvVTuoXNGHhULo1LDzxTsMGn6GkH5XaKP1JMg1d3+B0g/1mJT63lPNFw7qg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:248:b0:155:e660:b774 with SMTP id
 j8-20020a170903024800b00155e660b774mr23629323plh.174.1652814335820; Tue, 17
 May 2022 12:05:35 -0700 (PDT)
Date:   Tue, 17 May 2022 19:05:20 +0000
In-Reply-To: <20220517190524.2202762-1-dmatlack@google.com>
Message-Id: <20220517190524.2202762-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20220517190524.2202762-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v2 06/10] KVM: selftests: Add a helper to check EPT/VPID capabilities
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
2.36.0.550.gb090851708-goog

