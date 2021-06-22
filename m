Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A943B0C1D
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhFVSCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbhFVSBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:01:45 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C79C061153
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:47 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id a193-20020a3766ca0000b02903a9be00d619so19029544qkc.12
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yVrOMPhzZPdqV1WioAtIf0BXuorXlIfO8VqO1fLczzw=;
        b=EiMHm4jSoPIly8Y8iOtzHiKF1Kgm1utSHqQ/4BFCMwRiuk+zm1AAaHhPOTX61OujL+
         llb+27Sf+eOX8TQnVfeUcY/e4zarGe2Cg9SSQdrQ+9t3Oq3GQBELLorMEVR81GHuroSR
         w/40x68nt8mkoaUApT5cW5hMGNtdM8eKxKHW5vjSc5E2xnHeKg2pM03KAttrOBi+zvJb
         agByEjHNen/MK+wcBfObOYGjSgYvkUdB5+sqC7Oa0ri+ghegi155BX9JB0GnODdKE1Dl
         a5gKsUiOLlZ44TEA6RgtnGw2yuQdPfzXCHLCNI6MT0OZY/w3BnQ0MoBPFeDFEd6KBlwu
         ZA7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yVrOMPhzZPdqV1WioAtIf0BXuorXlIfO8VqO1fLczzw=;
        b=oOjU7TRBoP6/xuTZbwW4vsIwc8nrK8LrhBPgK7j7tJXyHNEY2hVhGHoWDur5AA2KU5
         3zXk3kmYt5xjU7fm8SosO0WT/XUbfsOPqa7f+idq7HodcksC1sXUxEzkiyEwroGi+7/0
         Jpk2PHxTwmqlL+8yECd28Yla+Qh7ea21Omx8bfUvqlA/yxafRLJW5XtL2k13VJGihIGc
         33itQV81H9jvCh5BS8dpN0rx4moWFrjKBWrEoRVFLBxdyuxTQtAegZPYERTyo5LrHEou
         S+Rkc0eou7xywBxr5L5LYNxaso7xgGBQ2pQElRmhP7vs64esBW0KmdCmSTchz7e1onO/
         N6uA==
X-Gm-Message-State: AOAM531nRnxeCOv628zOSEdeOaJQLCpscmdNVsM6nVvrmLoyHSnEb/Tu
        3rad+0e1Vt8C4yBswU5fJeoO6jbNkXc=
X-Google-Smtp-Source: ABdhPJyHSmAYFIl/FI35dSoFxknrxIjIyNHAXOWieOHKKmp9S9zXqV/I+lUFvtCbTofX7lIz9FK9Xm58lhw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:a4c8:: with SMTP id g66mr6288019ybi.301.1624384726396;
 Tue, 22 Jun 2021 10:58:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:07 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-23-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 22/54] KVM: x86/mmu: Ignore CR0 and CR4 bits in nested EPT MMU role
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not incorporate CR0/CR4 bits into the role for the nested EPT MMU, as
EPT behavior is not influenced by CR0/CR4.  Note, this is the guest_mmu,
(L1's EPT), not nested_mmu (L2's IA32 paging); the nested_mmu does need
CR0/CR4, and is initialized in a separate flow.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 241408e6576d..84a40488eba7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4767,8 +4767,10 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 	role.base.guest_mode = true;
 	role.base.access = ACC_ALL;
 
-	role.ext = kvm_calc_mmu_role_ext(vcpu);
+	/* EPT, and thus nested EPT, does not consume CR0, CR4, nor EFER. */
+	role.ext.word = 0;
 	role.ext.execonly = execonly;
+	role.ext.valid = 1;
 
 	return role;
 }
-- 
2.32.0.288.g62a8d224e6-goog

