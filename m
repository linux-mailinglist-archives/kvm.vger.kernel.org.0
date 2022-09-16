Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A5F5BA3A5
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 02:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiIPA47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 20:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiIPA4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 20:56:52 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F9D86B7F
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 17:56:49 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oYzey-002MaO-2t; Fri, 16 Sep 2022 02:56:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=VEOnG0d9S0pJywNSeqi3lnypq2Djl62MShP3DNawH1I=; b=VfVX9tW9nggpfqHLvIlOFg5imA
        ia2FqJnOQC30Ite7fpAsr0TjyZdXkY/c+0ie8KCVrZeANkxaZb1c3BrU3/vTNRyaNRB0i2gBRj2+s
        D8CQefwdVVjGB3U96/kXtriBARZptGtlsr2Bd+xc/l4KoTJaxE7jc+lRfQRs9ZkR6nESpWYekkeNN
        6hsAzq2Z2LpkolE6VTuUz6hKZe9VNSCCpM9K747lsgyargV5EF/1dTijH9BnMPMAeMge3XsEDu0Ic
        y0ijalxsz/WvYDW2OnaiD0+ZN6doxvktoNoziJfi3/UqGWltrP6vu76q+CmYJdZt4tb0JIh8KM5KJ
        GsWnmPCA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oYzex-00081T-Rk; Fri, 16 Sep 2022 02:56:47 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oYzek-0000xy-Be; Fri, 16 Sep 2022 02:56:34 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, shuah@kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [RFC PATCH 1/4] KVM: x86/xen: Ensure kvm_xen_set_evtchn_fast() can use shinfo_cache
Date:   Fri, 16 Sep 2022 02:54:02 +0200
Message-Id: <20220916005405.2362180-2-mhal@rbox.co>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220916005405.2362180-1-mhal@rbox.co>
References: <20220916005405.2362180-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before taking gpc->lock, ensure it has been initialized.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 280cb5dc7341..e32c2cf06223 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1348,7 +1348,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		WRITE_ONCE(xe->vcpu_idx, vcpu->vcpu_idx);
 	}
 
-	if (!vcpu->arch.xen.vcpu_info_cache.active)
+	if (!vcpu->arch.xen.vcpu_info_cache.active || !gpc->active)
 		return -EINVAL;
 
 	if (xe->port >= max_evtchn_port(kvm))
-- 
2.37.2

