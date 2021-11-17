Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D31454156
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhKQG4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbhKQG4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:30 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC48C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:32 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id b11-20020a17090acc0b00b001a9179dc89fso2617584pju.6
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/e/xNL5It/1lgtF/0hW/wqDeGrof7OdzTDTZVLebiuk=;
        b=j8pwdmWpIEuKWCZTRLwhV0+yRYK3NzWzVXsmOkuXQzk/OITLmHs/oBnz8G1QX/wawM
         vs/bKWw6PmUCIDTWmNiky72jPMXuslIt8VIV+XhSIsXueL3rJKxq3aQVwCNkYiS+WskV
         KSFv80YxL2vasMGa26Vxi07q1hIQCE9jdF0u9iYfui/TDeSHIRYjdmEK2M9GYYIa/FZe
         85y6czf4vcPBsfW3i3cPheItf4k/flPl08wAWMmMijyctX3SCjp28ZETpem0wYop5kpl
         9e8t18BWLfV9DVa5XK0CrUpd+qB8wfxyE99Fg55DGuKFJtIgdotQ+TTftSsKefX8RpHb
         y22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/e/xNL5It/1lgtF/0hW/wqDeGrof7OdzTDTZVLebiuk=;
        b=DwgQU16RHJ7lVjpqXV7LirCxS0kIwf3p4DezAklOpgZDFTc99ueSJfmZ6sc8rf4ZuZ
         /xW0Z1zQAnY4xA7vzzSr1AT8ZfDhhAVb35QngF7gOiQSqlZPsQmF9mxTVhOJsZ6xd1dF
         dPCKlzNZ3+hwA2nCLeai2VjcVy0B9i2I2evwubNEibRievFaNJichi8ewwutcTWEzYt8
         aOyKld1zn8C20BESn2rIYm1V97gEk4Q6ThxANNsSE5rMON7bGMjQ/ur/mHpjvNcAVOr2
         kYY0H3xdgwypOsim9lSIvuU4NweBQfle37YLLmmQFkUucFNvCWuTxOa5CepQ39vCshfR
         54Zg==
X-Gm-Message-State: AOAM5307uGPtmTMxQi9zp0bdrdvs4xe5/VCuQj7BhpWsqiXx7jVVuSDR
        Wyckog39W5NPv1B31JEaa+67nMI5Yks=
X-Google-Smtp-Source: ABdhPJx7YvjvD0kd3GLB1QJ2fQn3bsN7bXTUBhqNwC5FXsbEwUxuXuwxajhhtCcErhPR8bvE7NcX2/AhwX8=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:4d0a:: with SMTP id
 mw10mr6995057pjb.89.1637132012388; Tue, 16 Nov 2021 22:53:32 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:45 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-16-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 15/29] KVM: arm64: Make ID registers without
 id_reg_info writable
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

Make ID registers that don't have id_reg_info writable.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 659ec880d527..35e458cc1e1d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1886,16 +1886,12 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 	if (err)
 		return err;
 
-	/* Don't allow to change the reg unless the reg has id_reg_info */
-	if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
+	/* Don't allow to change the reg after the first KVM_RUN. */
+	if ((val != read_id_reg(vcpu, rd, raz)) && vcpu->arch.has_run_once)
 		return -EINVAL;
 
 	if (raz)
-		return 0;
-
-	/* Don't allow to change the reg after the first KVM_RUN. */
-	if (vcpu->arch.has_run_once)
-		return -EINVAL;
+		return (val == 0) ? 0 : -EINVAL;
 
 	err = validate_id_reg(vcpu, rd, val);
 	if (err)
-- 
2.34.0.rc1.387.gb447b232ab-goog

