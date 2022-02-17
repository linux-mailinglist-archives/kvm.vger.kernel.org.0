Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7204BAB81
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 22:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244637AbiBQVEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 16:04:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243866AbiBQVEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 16:04:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0C59D1080
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 13:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645131832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kbg+OqZri34BoKCLL1H4Wwzp/4I4YJYM0faw8mk1Jng=;
        b=F5fMAELnmI2eIwVGAi+BNX7qjjplRsNes2rZF4aciBDR2mXFsjetymGaW4/tUMspcGO8wp
        OiMfczezlmyIEXJYmQMG5dqgTtYiCGsY7TyLnsh32fHPfBt25GEPOZHWj9ptezpoTdgEDX
        PoPZiIG0eaLHA+Mshqqqar24qOLIcBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-qvdlAysIMd-OoGmt1adXEg-1; Thu, 17 Feb 2022 16:03:48 -0500
X-MC-Unique: qvdlAysIMd-OoGmt1adXEg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5400C814245;
        Thu, 17 Feb 2022 21:03:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0492C6AB95;
        Thu, 17 Feb 2022 21:03:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 12/18] KVM: x86/mmu: clear MMIO cache when unloading the MMU
Date:   Thu, 17 Feb 2022 16:03:34 -0500
Message-Id: <20220217210340.312449-13-pbonzini@redhat.com>
In-Reply-To: <20220217210340.312449-1-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For cleanliness, do not leave a stale GVA in the cache after all the roots are
cleared.  In practice, kvm_mmu_load will go through kvm_mmu_sync_roots if
paging is on, and will not use vcpu_match_mmio_gva at all if paging is off.
However, leaving data in the cache might cause bugs in the future.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b01160716c6a..4e8e3e9530ca 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5111,6 +5111,7 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
 	__kvm_mmu_unload(vcpu->kvm, &vcpu->arch.root_mmu);
 	__kvm_mmu_unload(vcpu->kvm, &vcpu->arch.guest_mmu);
+	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 }
 
 static bool need_remote_flush(u64 old, u64 new)
-- 
2.31.1


