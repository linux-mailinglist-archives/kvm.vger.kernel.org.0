Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F5B4B425A
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241036AbiBNHAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:00:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbiBNHAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:00:47 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B1C575F7
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:00:40 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 62-20020a17090a09c400b001b80b0742b0so10289663pjo.8
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zPnMHKVlqcgDQB6kXKJ7+KuQAdNLH0y013yuxCMh/uc=;
        b=jAMpDPE2rwLv0xUEZh0rf99E5rltD6fSrYSdLKH9MDqodxvRCPt1zuOb6B9b1nSoMA
         LOc7lWlmOcHkEb3/SBDlw6Q7xWUkfRgOZ1/NqJWEvzc5aDDmO8WA4sfAwP6macnQqeyH
         r6q9dAjHDQScFr8QtjWa/2fYmOShpUA+EwsRzEeG57GB3ibYFUFWOAF6mvoXUDAVkyA5
         qdH+/5VtcQPN2f26W69X4y+bwUZEa/LdHQgNuUtcEPiB3ZcsOsInUXYrSf0CqniMr8OB
         g3UniLutFzrP920Ugjw95OH7nvWvChiNn1a4eZS9a7keu0rnuQTJxjcx3A2k/2SX70Ay
         xBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zPnMHKVlqcgDQB6kXKJ7+KuQAdNLH0y013yuxCMh/uc=;
        b=JrxyFRz5BNtg2W7dlEHksds377XyrOJDqfSW42TPl93gweDLASbCc+k8Cgpm3o2L+n
         2DYB+r8cycaQKPDaXgrMESK0vwe0xUgZBGuNgk0nwhtVJ76JVLxkMzr0OqXlES7cWaNW
         Vb8hBognW8HoA3K+OzIvdekv/u8w5erx5o9oP8Bb4kRdigE/s8JFHNlk0WBE7MsE3sSj
         5F4NQiBJXJs7+aqJ+2IRVLRWPpaWcftV1oSq3Y7HoxtPPhZj5WJaCiWTE+fIcUlDlyF9
         Ms7j735fi8X4EzYUsx8/VYMXbkJeB3rF0prvdBkMSgpPl6eGKFTdn7CCjtJ2PKQTk9YV
         +DSQ==
X-Gm-Message-State: AOAM530BUUNxotg0u/AtoHJxemwlP9VZAKCOVbZy067NHqJBy+FY04U4
        S48z6KRWDz6CIqnEYpkJ6rEP9SQHcog=
X-Google-Smtp-Source: ABdhPJyJ0YhcLpxpXD9Q6qbj2a2Z8CEceYHauRoXxBka/sS6SnTbMSEqpjKMgS7gdS6Ry14yGjGjZ3cqwj8=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:11d0:: with SMTP id
 q16mr12831689plh.134.1644822040248; Sun, 13 Feb 2022 23:00:40 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:33 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-15-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 14/27] KVM: arm64: Make ID registers without id_reg_info writable
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
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

Make ID registers that don't have id_reg_info writable.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fea7b49018b2..9d7041a10b41 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1909,11 +1909,8 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 		/* The value is same as the current value. Nothing to do. */
 		return 0;
 
-	/*
-	 * Don't allow to modify the register's value if the register is raz,
-	 * or the reg doesn't have the id_reg_info.
-	 */
-	if (raz || !GET_ID_REG_INFO(encoding))
+	/* Don't allow to modify the register's value if the register is raz. */
+	if (raz)
 		return -EINVAL;
 
 	/*
-- 
2.35.1.265.g69c8d7142f-goog

