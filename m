Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697CA443D24
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhKCGat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhKCGar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:47 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E78C061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:11 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id t75-20020a63784e000000b002993a9284b0so1016290pgc.11
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=q7+v9l/nyn0AhgzFSGXemnn4ohytv9T7PB3GkiLTiSE=;
        b=F/5iIMozxPOo534ZUMCTMOdMx+LyGtJ/iZkeAEsUVRYifAuz8U8ZGbr6iPcr0AjzHk
         6HOT5t7D04o0wT7LaJr16di3GZqV1RVebdyhB5sl8cOudvyAQaBba+mKGbq/3qe4OycH
         e8/0CVyXtti8MBL+PaZBrYK+DNY7pegs7toslxhljSkcdpvcgQJYxgYKl1wzHtuQxgw4
         OCuWQ60zLJGsEbhCt7/x0kJsyFY6Ttk2aE492TMse1o5s9v1xZ65ISDa8M4MNHKuK0AW
         U/g8rvdAII/cUD9IFyW6AnLYnRBJgL1sQnz5rG6jtSyILqqFJHkyM4MtFYiL9OnTooor
         jNwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q7+v9l/nyn0AhgzFSGXemnn4ohytv9T7PB3GkiLTiSE=;
        b=6MqWEcFase135TqIk0jEm7kHi7fV5dbQZmu+JhVtHhcaABJPv0yGbdAYR4dS7zORGk
         AZ/vhPne58Efbder/kmaq/OHDJ57yykngBRHW9R2cdBjHKEu1vyIKEkiF1ZzTiMGxFQo
         Ocj1HIRkH9EoVLRbaKDft9AORLIdOdeDo8gO6/AZrIUU5/srQaIu8/10TLgiYhCyo+3o
         NlBS6DiJs+ulCxKDMRQKTR8cIa8MHAFnuOljvSa501lHhMXLKiW5P4RX/F449B96D23c
         andDi7UCDdnCxG/yYDil0IpRG5GFHB4kGRTkhFpgVvz3Ee6RbPAnr4lec0ybidp+s+hr
         Kzgw==
X-Gm-Message-State: AOAM533ztTG4I1ibsy8E5Lj+fvuLJhSybDTyWBFk7/lgsFqYdgc2W5Hl
        Txq/QqOX9r1sg3HIo3WJbNAOB8I2OBo=
X-Google-Smtp-Source: ABdhPJwKpyNta3uMXyyhmfNw7FgGewWUZO4qQrdHLOYgh4C4cuvOvtPwwORnahFa9CDV9cNccFbK/CUlCZY=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:14c2:b0:47c:2c90:df4f with SMTP id
 w2-20020a056a0014c200b0047c2c90df4fmr41652535pfu.63.1635920890804; Tue, 02
 Nov 2021 23:28:10 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:02 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-11-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 10/28] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
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

When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
expose the value for the guest as it is.  Since KVM doesn't support
IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
exopse 0x0 (PMU is not implemented) instead.

Change cpuid_feature_cap_perfmon_field() to update the field value
to 0x0 when it is 0xf.

Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ef6be92b1921..fd7ad8193827 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
 
 	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
 	if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
-		val = 0;
+		return (features & ~mask);
 
 	if (val > cap) {
 		features &= ~mask;
-- 
2.33.1.1089.g2158813163f-goog

