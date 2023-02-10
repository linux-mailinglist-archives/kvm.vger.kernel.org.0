Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6016915A0
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjBJAeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjBJAdb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:33:31 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0707095F
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:32:45 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id h7-20020a17090a710700b00230b6e1041bso3796681pjk.5
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zEtJJXP/d2l8cjo3sRdPdCH/uW1qOGz7yYT36ga6XYA=;
        b=OIn25dnGFHK3/GsuBf+shRFLsxjVK3A7daMICpgIh6b1/dOcT0jb4kv+ccWY8XrZYW
         Sh4A5EYfXrqr054hEP0OLCQX1e4XV3tdYGdgi0LcQkkd32Lf9sLdc999ImHUh4Wx9SVy
         97ZQ+gMw31UrvhT8Gzbrh2YgeNsxWrp5IWX3SDN+xomuh/7zQp3uUeuVnOzqlB2mftKs
         UIVT6kpcyNPBKO4dyxWeeQJ20PSw2X2W9oroWk3uKEC2ceVgxgZ3n0/QTS2wZsta3Pf4
         LGtUx/enKWsPMrgI5Qlt+FI7kYZmN6+1+E1fniNFKY148RvTdb6HJAI040rD//yjvXiJ
         3PAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zEtJJXP/d2l8cjo3sRdPdCH/uW1qOGz7yYT36ga6XYA=;
        b=ZQCYhuljFqifSIFeV48nd4QUXg+5qB3jH7Ex/ppdaZPYMbPmbpcbiIITRolbHXWqle
         TRcLQHFL1SlXT9lSoAq5yWU7TuxewSZNfbOHjZvXScXkmL/cDqjGQtM4BtSWlmVzdJsv
         6Pctjjiwr/VzC7032+PSKbdc4BbOj+to44kT00pAWAU3JnBEDbr71qF6KMjaiFA9CjKs
         UN1FoxNk0o87NrSNChQ4FY6IehHA1bywDX1Pq9cojmDZVzKFq+2UvBhVzs1qn3fxbqjt
         cQeqflFiMuJd80oReMc04GkhqM/4/NuR3BT8kJ+MZR6VTkdYYzIB+L+uaHRy0KO9/Djs
         N7SA==
X-Gm-Message-State: AO0yUKXO+U/qE+mjyBU+ZLNug/9QXRLiuqzKP3PYqCIG8hkaZ0ukOpff
        GyghaWV7+Yets4l8UuxzwVKQqEeZF28=
X-Google-Smtp-Source: AK7set8fdxQ/hgqraZET/UcBwzSWB1b4GLp3bl9sSvC5JBGhr4UIh8IzLGN4SiZYjs8ajErEAAl9cD0tOQI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9a09:0:b0:593:8deb:820a with SMTP id
 w9-20020aa79a09000000b005938deb820amr2872910pfj.53.1675989144638; Thu, 09 Feb
 2023 16:32:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Feb 2023 00:31:47 +0000
In-Reply-To: <20230210003148.2646712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210003148.2646712-21-seanjc@google.com>
Subject: [PATCH v2 20/21] KVM: selftests: Add negative testcase for PEBS
 format in PERF_CAPABILITIES
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
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

Expand the immutable features sub-test for PERF_CAPABILITIES to verify
KVM rejects any attempt to use a PEBS format other than the host's.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 38aec88d733b..29aaa0419294 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -191,6 +191,16 @@ static void test_immutable_perf_capabilities(union perf_capabilities host_cap)
 			    val.lbr_format, host_cap.lbr_format);
 	}
 
+	/* Ditto for the PEBS format. */
+	for (val.pebs_format = 1; val.pebs_format; val.pebs_format++) {
+		if (val.pebs_format == host_cap.pebs_format)
+			continue;
+
+		r = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, val.capabilities);
+		TEST_ASSERT(!r, "Bad PEBS FMT = 0x%x didn't fail, host = 0x%x",
+			    val.pebs_format, host_cap.pebs_format);
+	}
+
 	kvm_vm_free(vm);
 }
 
-- 
2.39.1.581.gbfd45094c4-goog

