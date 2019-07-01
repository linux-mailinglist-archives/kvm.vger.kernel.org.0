Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D4D441CD
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391596AbfFMQQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:16:42 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:51141 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731613AbfFMQQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 12:16:41 -0400
Received: by mail-yb1-f202.google.com with SMTP id v83so2783348ybv.17
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 09:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OuMoHtUYB/A86Igsd2Mm9vXsE800Nj7kR2sJJAc9Dbo=;
        b=aDuX9qqOZjqcr0AlhJo2kyypwZIqpYn2rb3eahHvIdvXh+2pO2ay2/B0LzlcqWKev5
         Eanlx3KbVCydE/uF1iPZdvZ457wehyXNqKUBKbo7Q8sJAFH5MI3HmAPnfQlRc2bYfntH
         96IAvwSuDgzmWpvtdCRjQn3oWyoe5j3xhGTRh+535dGJVIkz4QhURuoTmjR4sxOM4gBN
         cUEkpS1sChUvCzmVFNd3hlzcCstgli5HcNRFmzxZ7ZE9uMB0Xc8vE91StRcFdKUEUFDJ
         E2QAgl0OiCJ5iPcd/vJJZniOZNJ91sHaQDlU9gXOQ2FTwCec9G1yK5LXMsU+GbW9pUpP
         ojSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OuMoHtUYB/A86Igsd2Mm9vXsE800Nj7kR2sJJAc9Dbo=;
        b=E/hpszk3vYFIFty4IIyy5LPMF1x1dgzz3aclSckAT3OQvlqauRgAeRsHiAfFejRU5s
         k0Anric7JFUF1WHAdt/hNVJaYimlbPM7VtX9RtXfS7VTDOmdt8X3crycmZ5N6omXFIxg
         vMMlJcfJtFk0tbzwR8FPN7YtWhYcBQhQNJyUNEQv3d3QUUWzL6rX/sE2RGFy4coe62jA
         z8ZIhex3DZzUIaTey0ixThRqvg4tH5XhLo2kMg7hBbc/pk5cxERHqn3sl3IV+PsaQMYj
         0T+CXizyEW90QVICSUTC7hFsfYCFu//gfmbTDzCSnCHzJ8xSTisJa+7poW/vy+wzoRQM
         nmkA==
X-Gm-Message-State: APjAAAU2cGt/5IdsfNteW1egSqT2HWkIwbzoU+cup3fY6gksX9U2KO0y
        qHA9/lxHgzcc5tpeS57Xfa2WvC5MypX12/21IrQxFvOdetw42/sN1eji6A+KGgU/6Xg0lxto3pa
        9qu78NJbft8N8/WNkBL1R8MyI2V2Azcu3zgQ9k6bl10UFcsci4DeSdXOZyozo+8s=
X-Google-Smtp-Source: APXvYqylxuoKMV14ZdRos6vtaDG1Hi/hNuInyUQPfIXpV2awbxsj8pSt9m/ruXeGk2KkUPk75Qvqwd6qhbrMTw==
X-Received: by 2002:a81:51d6:: with SMTP id f205mr20200170ywb.228.1560442600592;
 Thu, 13 Jun 2019 09:16:40 -0700 (PDT)
Date:   Thu, 13 Jun 2019 09:16:08 -0700
Message-Id: <20190613161608.120838-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH] kvm: nVMX: Remove unnecessary sync_roots from handle_invept
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        "Nadav Har'El" <nyh@il.ibm.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Xinhao Xu <xinhao.xu@intel.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When L0 is executing handle_invept(), the TDP MMU is active. Emulating
an L1 INVEPT does require synchronizing the appropriate shadow EPT
root(s), but a call to kvm_mmu_sync_roots in this context won't do
that. Similarly, the hardware TLB and paging-structure-cache entries
associated with the appropriate shadow EPT root(s) must be flushed,
but requesting a TLB_FLUSH from this context won't do that either.

How did this ever work? KVM always does a sync_roots and TLB flush (in
the correct context) when transitioning from L1 to L2. That isn't the
best choice for nested VM performance, but it effectively papers over
the mistakes here.

Remove the unnecessary operations and leave a comment to try to do
better in the future.

Reported-by: Junaid Shahid <junaids@google.com>
Fixes: bfd0a56b90005f ("nEPT: Nested INVEPT")
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Nadav Har'El <nyh@il.ibm.com>
Cc: Jun Nakajima <jun.nakajima@intel.com>
Cc: Xinhao Xu <xinhao.xu@intel.com>
Cc: Yang Zhang <yang.z.zhang@Intel.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by Peter Shier <pshier@google.com>
Reviewed-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/nested.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1032f068f0b9..35621e73e726 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4670,13 +4670,11 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 
 	switch (type) {
 	case VMX_EPT_EXTENT_GLOBAL:
+	case VMX_EPT_EXTENT_CONTEXT:
 	/*
-	 * TODO: track mappings and invalidate
-	 * single context requests appropriately
+	 * TODO: Sync the necessary shadow EPT roots here, rather than
+	 * at the next emulated VM-entry.
 	 */
-	case VMX_EPT_EXTENT_CONTEXT:
-		kvm_mmu_sync_roots(vcpu);
-		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 		break;
 	default:
 		BUG_ON(1);
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

