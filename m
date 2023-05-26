Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560D7712880
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 16:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237416AbjEZOf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 10:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjEZOfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 10:35:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0034CE71
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 07:35:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C0B265063
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 14:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88DDC433A0;
        Fri, 26 May 2023 14:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685111634;
        bh=Xl35f5y+0lJ6cnk0BItkJo8xNvJzARnksbTzaqW58BI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+kfFMiHYsGjwJcfHCFkTO0wJg6ZQPhYa+JZGFxnzoZMzMFdWyI6yZKMuhfR+6NN8
         ORgog4mBwfeUYwoV251/69MsgRgmZTmkzoD6dPIONsCpa3UN8hS3uAVnfZBxAkRebu
         8VvyT8maCPStot229vCbIZf8rDXbCvFZEYV87dVAjmwEStlvyrFirdj4jGMDMt1eI8
         yBzZZshEwW+1Sn3eF8AERXyoyKthwcab+IqNi5Qme02v66BM9iDEzEXMFyJJ6NeNh+
         TOMzPvfDOm9bje2fuKPTTD58V6d5EMN/gl58QU7ayErPKQZRE++EsKXKsdI8SPOkeV
         G0kw1PPx9QlgQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q2YVr-000aHS-Sc;
        Fri, 26 May 2023 15:33:51 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 02/17] arm64: Prevent the use of is_kernel_in_hyp_mode() in hypervisor code
Date:   Fri, 26 May 2023 15:33:33 +0100
Message-Id: <20230526143348.4072074-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230526143348.4072074-1-maz@kernel.org>
References: <20230526143348.4072074-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using is_kernel_in_hyp_mode() in hypervisor code is a pretty bad
mistake. This helper only checks for CurrentEL being EL2, which
is always true.

Make the link fail if using the helper in hypervisor context
by referencing a non-existent function. Whilst we're at it,
flag the helper as __always_inline, which it really should be.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/virt.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 4eb601e7de50..91029709d133 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -110,8 +110,13 @@ static inline bool is_hyp_mode_mismatched(void)
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
 }
 
-static inline bool is_kernel_in_hyp_mode(void)
+extern void gotcha_is_kernel_in_hyp_mode(void);
+
+static __always_inline bool is_kernel_in_hyp_mode(void)
 {
+#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
+	gotcha_is_kernel_in_hyp_mode();
+#endif
 	return read_sysreg(CurrentEL) == CurrentEL_EL2;
 }
 
-- 
2.34.1

