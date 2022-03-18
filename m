Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2C84DDF42
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 17:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239335AbiCRQnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 12:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239324AbiCRQnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 12:43:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E3552102A9
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 09:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647621749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1vSc6tKsqTDEdn0ltpuGYsQKefstgNsTqnfTdgOsc7M=;
        b=HmqfL+0zUZ+Bt9XwtqM8u/MyWPjS7iMasaCG51B++1F9AGNXuHzExYaOBj7DvdrxL7woFz
        RG5ZWng2hTPPvV7ZdrmG0vSMvV1wSNOSgdfAFOHoQ/Te99el7hVBOa9tlpvxF9curRBR6V
        GN9SxhFA1VboyLo3KpIm4Rt/z3xVEgE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-kVmja--TPlqtnoIqShaTJw-1; Fri, 18 Mar 2022 12:42:26 -0400
X-MC-Unique: kVmja--TPlqtnoIqShaTJw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEB28381748C;
        Fri, 18 Mar 2022 16:42:25 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9632C40149B5;
        Fri, 18 Mar 2022 16:42:25 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Recurse down to 1GB level when zapping pages in a range
Date:   Fri, 18 Mar 2022 12:42:25 -0400
Message-Id: <20220318164225.2743431-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The recursive zapping that was reintroduced by reverting "KVM: x86/mmu:
Zap only TDP MMU leafs in kvm_zap_gfn_range()" can be expensive.  Allow
zap_gfn_range to recurse down to the PDPTE level, so that periodic
yielding is possible with a finer granularity.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 87d8910c9ac2..53689603078a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -926,8 +926,10 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	/*
 	 * No need to try to step down in the iterator when zapping all SPTEs,
 	 * zapping the top-level non-leaf SPTEs will recurse on their children.
+	 * Do not do it above the 1GB level, to avoid making tdp_mmu_set_spte's
+	 * recursion too expensive and allow yielding.
 	 */
-	int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
+	int min_level = zap_all ? PG_LEVEL_1G : PG_LEVEL_4K;
 
 	end = min(end, tdp_mmu_max_gfn_host());
 
-- 
2.31.1

