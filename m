Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75E878B474
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 17:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjH1Pbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 11:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjH1Pbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 11:31:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5914A8
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 08:31:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41827614B9
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 15:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9725AC433C8;
        Mon, 28 Aug 2023 15:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693236691;
        bh=WbdMRQdkcx1ONaBVtblf9wKZeJC6ZyaT1n0rlYDKwbo=;
        h=From:To:Cc:Subject:Date:From;
        b=d6zhSu0yHVrrHilCP+SGHNNSABzOQsBLTkGx1gbNX/eCQf+UNZ2AFx8GkJpsW0YVz
         wEjSLPR8WCcHdYFsEIF86qmOhpKSOrLj64i1YQm2tDZ52N/jRTQJF6LrI82axrwBPH
         9N4ZH6O4k2PKCygcWPzUiFswaL9D5I5oAE8h1setsFLZrYbP7C3SlNUg4Te/+17SOl
         XXLAeQp0cIzULDLikZUTxlLZveACDOb/eIZQNIw0hbtbB3NV4R5+y65hMA9B93D2Ud
         O5SHmoi+U7UxB4/4pBaFO6ZlOBvj9nKj5SPOE4IVS7kOVAQpFOFaJf/46lY66KUOhw
         PT4lYiSvUdnUg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qaeDB-008lkQ-1B;
        Mon, 28 Aug 2023 16:31:29 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] KVM: arm64: Properly return allocated EL2 VA from hyp_alloc_private_va_range()
Date:   Mon, 28 Aug 2023 16:31:21 +0100
Message-Id: <20230828153121.4179627-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, vdonnefort@google.com, m.szyprowski@samsung.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marek reports that his RPi4 spits out a warning at boot time,
right at the point where the GICv2 virtual CPU interface gets
mapped.

Upon investigation, it seems that we never return the allocated
VA and use whatever was on the stack at this point. Yes, this
is good stuff, and Marek was pretty lucky that he ended-up with
a VA that intersected with something that was already mapped.

On my setup, this random value is plausible enough for the mapping
to take place. Who knows what happens...

Cc: Vincent Donnefort <vdonnefort@google.com>
Fixes: f156a7d13fc3 ("KVM: arm64: Remove size-order align in the nVHE hyp private VA range")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/79b0ad6e-0c2a-f777-d504-e40e8123d81d@samsung.com
---
 arch/arm64/kvm/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 11c1d786c506..50be51cc40cc 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -652,6 +652,9 @@ int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
 
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 
+	if (!ret)
+		*haddr = base;
+
 	return ret;
 }
 
-- 
2.34.1

