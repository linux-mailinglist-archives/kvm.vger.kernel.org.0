Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D43E5A0855
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 07:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbiHYFKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 01:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbiHYFKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 01:10:20 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0F39A9E0
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:19 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id bf3-20020a17090b0b0300b001fb29d80046so4709184pjb.0
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=pEzlhIhHkJ9oe9us+Ap6efv2GvV7LuN1d5BuceK5HtQ=;
        b=GDyPQuvB4CGkscQbFZesosca0zjSklRpbtqexkueZNX0/pQlIx18BczSNbJOP6N52r
         VK0YZIjzcrbwa8JnR5p94cA3vM3FOALNsiaDpTwkEQ5sYP8zR2+ZCDGSbAHtV1d2ntKO
         1nscFoy1pN1GJ/KqunnMWBDzX60HpvGeV1ZFpeTg2j/LI9cFvBStu4bK+XXveF0y/P93
         iIpNZOY8Cm/V3G+MHqg8np+I0RwEFmMV9x4YMP+uyhlRuqHaRf87tYe6/Jaha/2Nqe24
         hjZfCUriCXxAGqR5uLeTWRpq8z3vDgesV9E3/ACXNMNELEY5hwkQ7ZH9wBrfCwDKEHHR
         b/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=pEzlhIhHkJ9oe9us+Ap6efv2GvV7LuN1d5BuceK5HtQ=;
        b=qSxF8ZmmDz4rmxdFSOckH1A3Khn3vYZXVxDU+DfGl+PRbtMMYWqJe/it6YIGgDwWur
         XaISYt+fNBizL9mZOVTC7wSr4r4v6vYA0LBSb5YyNDQiUV5u2O6ASMpdvAg6htZA1982
         ef+UQlzk69oQ2HX5SaIAyvXiaVIoFgjx8uo7XvB8HMqySpCeTdXNolfgt1L/HLvo9LCF
         DUzBKutOQhdXKiOQpTCh2Z3FGsCqXakUCj5IQjYJq7FS3q+8Vo75hVtzZeQjZxIVHyUp
         n8r5eKynwSwRHEvdVb62c3uQDrID0/FgIlVD8CAhZN2ut4jBykJLSocTQ8SWm7P6SiSD
         ED2w==
X-Gm-Message-State: ACgBeo3IN2ikYH1v+dJuyQHOcwu94x7ghI1MHXdGm3wG256vnQd14hAJ
        /k9azRJcN9CCAzcv1xLgGhzd+CX8NR4=
X-Google-Smtp-Source: AA6agR4QwGnPgJc9EXrJlzOPJDZW1awp7QnK0mmHC+92n4anJ3Yqks2hO/x4pF1tFVBJVUjLL44mvc2Kwdg=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:90a:de96:b0:1fa:e427:e18e with SMTP id
 n22-20020a17090ade9600b001fae427e18emr12097875pjv.116.1661404218605; Wed, 24
 Aug 2022 22:10:18 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:08:42 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-6-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 5/9] KVM: arm64: selftests: Have debug_version() use
 cpuid_get_ufield() helper
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

Change debug_version() to use cpuid_get_ufield() to extract DebugVer
field from the AA64DFR0_EL1 register value.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 713c7240b680..17b17359ac41 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -320,7 +320,7 @@ static int debug_version(struct kvm_vcpu *vcpu)
 	uint64_t id_aa64dfr0;
 
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
-	return id_aa64dfr0 & 0xf;
+	return cpuid_get_ufield(id_aa64dfr0, ID_AA64DFR0_DEBUGVER_SHIFT);
 }
 
 int main(int argc, char *argv[])
-- 
2.37.1.595.g718a3a8f04-goog

