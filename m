Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2878B443D29
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhKCGay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbhKCGaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B76C061203
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w132-20020a25c78a000000b005c27f083240so2665867ybe.16
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VrJ07b06nc9KbJLXSj5zehnLehuxuLDRP/US8C6hfE0=;
        b=ZAVnIZTP+LHKUx7NfjJFSSU8Rs4NWQlt+WSmFir11XcrpVf8vIvANzLB94WHJ6Bf60
         k5sOQZOlmPiZcIyPnZc5h1IMa4HEIbaZcPfZylu7pLpRq3Wo7z+BnTX0y7I5wYkCFuoG
         +eGMgfwCzcXcJHpSeGXyJ+tSsUCHmpwt6ur6pHCiVAdNfjEHT3yYhu+lsxVQ5D2V2KIC
         qvaK+4T5DbMnZpK3Z7YkucwN2EtSX/SR0NY/oCqRV2gxlQCjWzPRe4HiWqu2PEQkt71B
         aKqnarAD6+0QHqmgo1zo2USfPJbv7FQerLfy1iC4jnm1iC7S985cSaZMnGyUSznXz1F/
         su2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VrJ07b06nc9KbJLXSj5zehnLehuxuLDRP/US8C6hfE0=;
        b=Vjd0I4Etrt+LuFd2OepD3HG4eCXIu0iagiaLVN7jE23V000rYHWebZndSImHD8336E
         Eby/aj5MthU2GsBOczOoPjShGfQaC/1kp6xCW4pzF5vM64+aE4yoYH02QuPrtsDzOc39
         bGssFlwiyADEGByBtrQ+srdlhGuNMbdq2EYAYL72wl3FyBTOrI8PbnqsQbIx1NiPJgTk
         RXxtQQiFaagLcQtLmC7GvWDhFOMSJgGpsYEOn3itN7Orgsrlr3RgLwdCVwu+IC12TqLu
         SRjUs3FOs3Cn0fb5kT5jnoS1M4nntEaHeQDXdkccUDLQId5ZKLpzV+KmclyEw1jZ5Mhv
         FfKQ==
X-Gm-Message-State: AOAM532QoQ1PKVH8mroO20RjcslCQhBcvokfYospWgttU19mZ10JMoDt
        6YN+1+Zcn4Cuu771bxX6AAsjsAUFAFY=
X-Google-Smtp-Source: ABdhPJynSsKsRymAV6oD+adfOhHtjHV5sbxdoRvZmrjUVSSHvV6cZcysjNYwYVj1A9HptlBdbRlQUwIXynU=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a25:5d08:: with SMTP id r8mr43342773ybb.227.1635920896128;
 Tue, 02 Nov 2021 23:28:16 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:05 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-14-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 13/28] KVM: arm64: Make ID_DFR1_EL1 writable
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds id_reg_info for ID_DFR1_EL1 to make it writable
by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8abd3f6fd667..f04067fdaa85 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -835,6 +835,11 @@ static struct id_reg_info id_dfr0_el1_info = {
 	.get_reset_val = get_reset_id_dfr0_el1,
 };
 
+static struct id_reg_info id_dfr1_el1_info = {
+	.sys_reg = SYS_ID_DFR1_EL1,
+	.ftr_check_types = S_FCT(ID_DFR1_MTPMU_SHIFT, FCT_LOWER_SAFE),
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -845,6 +850,7 @@ static struct id_reg_info id_dfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
-- 
2.33.1.1089.g2158813163f-goog

