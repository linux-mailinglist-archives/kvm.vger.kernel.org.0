Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE93F76EB98
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 16:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbjHCOBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 10:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbjHCOBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 10:01:22 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D561730F4
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 07:00:44 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 46e09a7af769-6bca7d82d54so897109a34.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 07:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691071244; x=1691676044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2tfXSWeWMPnAaIHY4KST0Dq87HeMn2MCQyiwOTRx9l0=;
        b=WP69lFjTPQZBrSl5wkrXyzdHsTpyXA2gQa0IRM5fKF/BiJJslBNKpmj/AOs0VzIEi1
         230pC7w5MsZjzMNcQDLIxq8zqZjOWkA9IEz3/H0hwfTng5PnlMtVA9PGgn6q5AcL8Zmr
         8hfkfw+x1vAS4NMP9lydmjgAewKG1iEXAiqWEf5AgOX9bdfy7KwBL+69QaZx11BOJqma
         yK6zfiBC4u0RvubTUeaNRhRXRujYEkUPQgKplcaur9kFc6JnKukD75uePnfQWwa+Uxiz
         WRJWWUXaqG8pv2b7Kit6dPWbwG+UbC6UlEYD3cgz1VR8q4S/7D4IN0T+eu/hu6exODeS
         MM0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071244; x=1691676044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2tfXSWeWMPnAaIHY4KST0Dq87HeMn2MCQyiwOTRx9l0=;
        b=li33JqxsNssxC9EPFygFwQfEf06Yh8XS9S/vqmRz+YWhFVKb5i4yg853uh/4vtnv4R
         MsWELPfOqhxYsOi+mgtw7S5gtjKSOH+nLfl8FjTCeYaIyz6Ualx8BdLku1EVKuKFdLPo
         A0DpsA0eK0TOiG/+XstP6i1YAaAW9lO3+8+oQcFsCWKWbxowisV6PwXeZix0YtsKS9p4
         NbHvmu2YhiuntYoHFpDoEtmtT8O35Y96CiDhFkl0CrlcD+vMvzSOEReIic5LVS2UQMc8
         5meoeJl30fphFFJSU+UZMhP36XaOfL+WhmhIAJe/Uirnh8wrmVWY1hjmjRvni3NMRfgC
         Gs+g==
X-Gm-Message-State: ABy/qLYTLkRgaN9Xux/2ot3Y7g2cdPw18i7Rh1cNo0WkA+qcSvO3dlKR
        e4oLqVLk3TK9NLik2dcUmts1f10QyMdCe8w4gr6row==
X-Google-Smtp-Source: APBJJlG7X8lZjATw94mHRd/2WLRlARX3gMV99Gf7BdNQxmyPF9slcJQDy0JY5lo4gAQ1GC8RuAzNfw==
X-Received: by 2002:a05:6870:2198:b0:1b7:3432:9ec4 with SMTP id l24-20020a056870219800b001b734329ec4mr23759556oae.10.1691071243905;
        Thu, 03 Aug 2023 07:00:43 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e14-20020a0568301e4e00b006b29a73efb5sm11628otj.7.2023.08.03.07.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:43 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v3 05/10] RISC-V: KVM: use EBUSY when !vcpu->arch.ran_atleast_once
Date:   Thu,  3 Aug 2023 11:00:17 -0300
Message-ID: <20230803140022.399333-6-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803140022.399333-1-dbarboza@ventanamicro.com>
References: <20230803140022.399333-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vcpu_set_reg_config() and vcpu_set_reg_isa_ext() is throwing an
EOPNOTSUPP error when !vcpu->arch.ran_atleast_once. In similar cases
we're throwing an EBUSY error, like in mvendorid/marchid/mimpid
set_reg().

EOPNOTSUPP has a conotation of finality. EBUSY is more adequate in this
case since its a condition/error related to the vcpu lifecycle.

Change these EOPNOTSUPP instances to EBUSY.

Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 49d5676928e4..0cf25c18b582 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -212,7 +212,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 			vcpu->arch.isa[0] = reg_val;
 			kvm_riscv_vcpu_fp_reset(vcpu);
 		} else {
-			return -EOPNOTSUPP;
+			return -EBUSY;
 		}
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
@@ -484,7 +484,7 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		kvm_riscv_vcpu_fp_reset(vcpu);
 	} else {
-		return -EOPNOTSUPP;
+		return -EBUSY;
 	}
 
 	return 0;
-- 
2.41.0

