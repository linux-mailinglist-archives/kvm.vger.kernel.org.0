Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D8552D4E5
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239122AbiESNrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbiESNrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:47:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8357820BCA
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A8F9617D4
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF2AC385B8;
        Thu, 19 May 2022 13:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968007;
        bh=E1015Uo5m9qQ+l/7YYTJwJcecYTkXjzWrhDPUZbkvqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sa8MhUqPbbEtNQoduO6nqD4n1geAIXj03Okw2MLZAGzVD/WXwb6+clOJIYjK7za3A
         ruFghhtE3LF4KCXFu2TGRDLKMaro1wB6ba+np+GNntmB80SCIhCXvfvP7PAANFTE7m
         hM0remAoSSBf/B3FkCUzY9cmJpCaDqGRhGoQss7jBh7Z0/D/zEs37i8+htwQWZK8I3
         1lXl53f3OFKaX7MutdoTvi2ugXs60KRKdsXOvCl74EIw6yNdVFbMgn2GgX/tZUiv1l
         dYkuVqY5DAui1d5BcNgkQE7kNmD5z7903UeQvOq332FxoM2WfIu3qHupCv5spkBdS4
         cxWvD4Kdli7Aw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 66/89] KVM: arm64: Donate memory to protected guests
Date:   Thu, 19 May 2022 14:41:41 +0100
Message-Id: <20220519134204.5379-67-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

Instead of sharing memory with protected guests, which still leaves the
host with r/w access, donate the underlying pages so that they are
unmapped from the host stage-2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index c1939dd2294f..e987f34641dd 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -465,7 +465,10 @@ static void handle___pkvm_host_map_guest(struct kvm_cpu_context *host_ctxt)
 	if (ret)
 		goto out;
 
-	ret = __pkvm_host_share_guest(pfn, gfn, shadow_vcpu);
+	if (shadow_state_is_protected(shadow_state))
+		ret = __pkvm_host_donate_guest(pfn, gfn, shadow_vcpu);
+	else
+		ret = __pkvm_host_share_guest(pfn, gfn, shadow_vcpu);
 out:
 	cpu_reg(host_ctxt, 1) =  ret;
 }
-- 
2.36.1.124.g0e6072fb45-goog

