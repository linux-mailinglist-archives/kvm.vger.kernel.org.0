Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1ACF457A7D
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 02:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbhKTBxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 20:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234823AbhKTBxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 20:53:18 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DF3C061574
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 17:50:11 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id e9-20020a170902ed8900b00143a3f40299so5497474plj.20
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 17:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=/oTaTNiB/LMk2r2BJ6BITqZh/xo7HcDPFHBzIC0aTcA=;
        b=Y17iUQxETsjV0XAmZHTD+ZjD5tMQk/NOpkpraqf9BW2+v5JR2eBy3f1p4yCP1mV3uC
         PUm9MEBvTS93oMslh7RgrsjIn7MwY6k54gJbA1d9WbMvca4OO99KHtuRdpvxgnR+uFI8
         LbTg7u6ztPgJXa9z5xh0G849CN6AM529jrtRS41dtzaJTlu8O0VHwLxmLIcdHfTH1nzT
         oEv7OW24KEsMMt+gNB/z1zgrC8XGFXUhCRr2vRbVD3sdbBDeSfePKELcnp6wMPAU86Cf
         f8n5fBHLETiqOcQskna/SG3gZC+RBCd39PIXox+DkR1QIc46GJKsFIYBprHQib5cj5Zr
         bLXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=/oTaTNiB/LMk2r2BJ6BITqZh/xo7HcDPFHBzIC0aTcA=;
        b=LIY6CXcdUhEUGwI7xatvzR6t8bvDbJD+SfE+EowV0iVSAp1PwhFfGoMw9iKo4CYTBO
         5y3MhMfrXTYUDUrUqjKvw+LgW9ZenhXYCPWXRXebq7FRA5keh0pTjxFiRAZJAyZ0E6Rp
         FcMZwMznW9oE9bJt2vuuCyz+gBN8mOS9JicdlcIw6JcKhGblJxpI5A5tzCnKL206DSny
         1e/49tmTi/PRGD6w1Eq1i7tXPgCvVMRcOUFof57bU7kVt2+hLQjQbQRbgeGklj+ao9IP
         f2ZejQXFCtry7/LiqfurA41Hq/oNJ1hX3ulUin9bqW8IShKJh2hJCeG7py+HW3w7wdUE
         YvJw==
X-Gm-Message-State: AOAM530iFQU0JJPIQBl+aVLRO9okEfeq+6ANWsKmE45a+Uabg3fCN72t
        eCKYsSMHS/XfucFHq822OgANye6YjBM=
X-Google-Smtp-Source: ABdhPJw57b08V0yHzRvjztHGvC6NDI5qlJErpxBPqWosR83M55tCfe2R+c09/5jVgLkTn+wpYzGFXH7ZbEQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3a89:: with SMTP id
 om9mr5591281pjb.29.1637373010794; Fri, 19 Nov 2021 17:50:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 01:50:08 +0000
Message-Id: <20211120015008.3780032-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH] KVM: x86/mmu: Use yield-safe TDP MMU root iter in MMU
 notifier unmapping
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the yield-safe variant of the TDP MMU iterator when handling an
unmapping event from the MMU notifier, as most occurences of the event
allow yielding.

Fixes: e1eed5847b09 ("KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if possible")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 377a96718a2e..a29ebff1cfa0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1031,7 +1031,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
 		flush |= zap_gfn_range(kvm, root, range->start, range->end,
 				       range->may_block, flush, false);
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

