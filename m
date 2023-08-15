Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B1277D26B
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239478AbjHOSt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239517AbjHOSti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:49:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BF72682
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03B7D65FAE
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 18:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658B2C433C8;
        Tue, 15 Aug 2023 18:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692125239;
        bh=06q1QsWNYOtN3lLwlfSUQzvdroGg3W6METrfZBHZogQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pV7G6WSpDkNYnkRgKdlP3W8v9fNcVAZrp+HfOZLLHc+PoGus7WochARrge0+ovxuM
         d29rh2tjHSu4LRkUsZR8iD1sjatGmhOv2kIZZTZ9RKjO+gu76tjSKFo20cRXam2n5d
         Nxvo9iA/UGn129UbloWpqTlot0V3ggd82crnNPut+U70ap1hNpXv+iDA8xfr3/TYCy
         kuomG9yt5gUQ6r3JN9dUWS14gtRhBINEfPUAHcEegoRJiK8oNroENQcIF32H89ObVe
         bg5P+pOJCyNf8PG7zVCcasYus0rBkNVCWdkIsps+jP59MAHzngc3b/F2SU7UcvEs38
         Jnk6db5NIQ7Ag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qVywn-0055Sd-VD;
        Tue, 15 Aug 2023 19:39:18 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        Jing Zhang <jingzhangos@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 10/28] KVM: arm64: Correctly handle ACCDATA_EL1 traps
Date:   Tue, 15 Aug 2023 19:38:44 +0100
Message-Id: <20230815183903.2735724-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230815183903.2735724-1-maz@kernel.org>
References: <20230815183903.2735724-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, jingzhangos@google.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we blindly reset some HFGxTR_EL2 bits to 0, we also randomly trap
unsuspecting sysregs that have their trap bits with a negative
polarity.

ACCDATA_EL1 is one such register that can be accessed by the guest,
causing a splat on the host as we don't have a proper handler for
it.

Adding such handler addresses the issue, though there are a number
of other registers missing as the current architecture documentation
doesn't describe them yet.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
Reviewed-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 2 ++
 arch/arm64/kvm/sys_regs.c       | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 043c677e9f04..818c111009ca 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -387,6 +387,8 @@
 #define SYS_ICC_IGRPEN0_EL1		sys_reg(3, 0, 12, 12, 6)
 #define SYS_ICC_IGRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
 
+#define SYS_ACCDATA_EL1			sys_reg(3, 0, 13, 0, 5)
+
 #define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
 
 #define SYS_AIDR_EL1			sys_reg(3, 1, 0, 0, 7)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2ca2973abe66..38f221f9fc98 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2151,6 +2151,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CONTEXTIDR_EL1), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
 	{ SYS_DESC(SYS_TPIDR_EL1), NULL, reset_unknown, TPIDR_EL1 },
 
+	{ SYS_DESC(SYS_ACCDATA_EL1), undef_access },
+
 	{ SYS_DESC(SYS_SCXTNUM_EL1), undef_access },
 
 	{ SYS_DESC(SYS_CNTKCTL_EL1), NULL, reset_val, CNTKCTL_EL1, 0},
-- 
2.34.1

