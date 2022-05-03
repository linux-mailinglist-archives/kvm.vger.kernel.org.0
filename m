Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B891C517CF6
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 08:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiECGFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 02:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiECGFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 02:05:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6B93334F
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 23:02:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x79-20020a25ce52000000b006497f075e7dso3961249ybe.15
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 23:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XfyYlyiUJYzy5P/tDVrVjfvZblAQAF1Q2S7Fvl/b6ww=;
        b=pYELEqhevmMMRFuo6qeYvGhQHMgyHNM/ESphHsgQXBuoLUhwPjQueCU9NdIhTEYN8N
         8W8v0dnP2cnMGt/b+WnLn01n5KQq42//Qvk2HBXynA1bEfwIQfS8Qkhj2p4dkqNoXfQH
         wqrylyW+j6Gl8pjO68sPlrX7IiHYeSqO175EJk/57UAcuf5T+HYmABQVaLjL9lqd5qtm
         pKPwShW6lKIAhihNqdN0tn2BSgEHWvGNuXgBIUwL6Pem5qetdQuitxp7jG4ma9Ofk8fA
         PW7Hcuy1Jty7yE2xNwjGi9tuQNAgir2JRejlGnd/xz0VkWs0glMJFZD4f4dDTBW+XQzw
         nR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XfyYlyiUJYzy5P/tDVrVjfvZblAQAF1Q2S7Fvl/b6ww=;
        b=plyO9jn5OAkQeFCz9IJw5F6PPl1LGw9ZcHGMeru3+3HjKyF4uuF09WA9Fvfw1uWJW3
         FbZbyFRAh/2phq/HgyY3B3X5zRzTeaVlpQQNqnFnsShr3+JRd0ghRUKvR12q9w2Q7nKx
         uEXDSOkU9ADaeloTjwadTo+B/C5b8vrK2nLwKNJYN8p6/cXh9YdoHZpY6LdBGdJ0bXyJ
         JwU3dNFtzIcQOPCXVzWCLHxparR0ZSLhDy5GiVHFrEqd8Oa4wKDu7v0AgrHU95Nn8aF0
         Zi+wnYQpe3rCAXJ2wM8Ur+zuKcvi/f6h2Z1JyOS78dtLDqq2Y4S4h4ZgEkHeKAaTUJQ9
         Eygg==
X-Gm-Message-State: AOAM533Wd8+NElbGzNU6T4+9GdG/6BxKbWNTQ7QuxvzkllCpJd9/rwnb
        g5S6aN5LGUqSTL0n3A0S+OUxj9pPhps=
X-Google-Smtp-Source: ABdhPJzWMTJ9eoHCayt8gdpKf+kTy89PEfM2q9IK/XBP9Olgr+AMTdtkI9bHjeCPHU8wQk/OhYk/vEOyRCc=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a25:74d4:0:b0:646:cfd6:daa3 with SMTP id
 p203-20020a2574d4000000b00646cfd6daa3mr12728747ybc.235.1651557731765; Mon, 02
 May 2022 23:02:11 -0700 (PDT)
Date:   Tue,  3 May 2022 06:02:00 +0000
In-Reply-To: <20220503060205.2823727-1-oupton@google.com>
Message-Id: <20220503060205.2823727-3-oupton@google.com>
Mime-Version: 1.0
References: <20220503060205.2823727-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 2/7] KVM: arm64: Don't write to Rt unless sys_reg emulation succeeds
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        reijiw@google.com, ricarkol@google.com,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

emulate_sys_reg() returns 1 unconditionally, even though a a system
register access can fail. Furthermore, kvm_handle_sys_reg() writes to Rt
for every register read, regardless of if it actually succeeded.

Though this pattern is safe (as params.regval is initialized with the
current value of Rt) it is a bit ugly. Indicate failure if the register
access could not be emulated and only write to Rt on success.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 36895c163eae..f0a076e5cc1c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2401,7 +2401,14 @@ static bool is_imp_def_sys_reg(struct sys_reg_params *params)
 	return params->Op0 == 3 && (params->CRn & 0b1011) == 0b1011;
 }
 
-static int emulate_sys_reg(struct kvm_vcpu *vcpu,
+/**
+ * emulate_sys_reg - Emulate a guest access to an AArch64 system register
+ * @vcpu: The VCPU pointer
+ * @params: Decoded system register parameters
+ *
+ * Return: true if the system register access was successful, false otherwise.
+ */
+static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *params)
 {
 	const struct sys_reg_desc *r;
@@ -2410,7 +2417,10 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 
 	if (likely(r)) {
 		perform_access(vcpu, params, r);
-	} else if (is_imp_def_sys_reg(params)) {
+		return true;
+	}
+
+	if (is_imp_def_sys_reg(params)) {
 		kvm_inject_undefined(vcpu);
 	} else {
 		print_sys_reg_msg(params,
@@ -2418,7 +2428,7 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 				  *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
 		kvm_inject_undefined(vcpu);
 	}
-	return 1;
+	return false;
 }
 
 /**
@@ -2446,18 +2456,18 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 	struct sys_reg_params params;
 	unsigned long esr = kvm_vcpu_get_esr(vcpu);
 	int Rt = kvm_vcpu_sys_get_rt(vcpu);
-	int ret;
 
 	trace_kvm_handle_sys_reg(esr);
 
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
 
-	ret = emulate_sys_reg(vcpu, &params);
+	if (!emulate_sys_reg(vcpu, &params))
+		return 1;
 
 	if (!params.is_write)
 		vcpu_set_reg(vcpu, Rt, params.regval);
-	return ret;
+	return 1;
 }
 
 /******************************************************************************
-- 
2.36.0.464.gb9c8b46e94-goog

