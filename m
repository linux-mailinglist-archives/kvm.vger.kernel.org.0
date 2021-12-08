Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C568846CA85
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243357AbhLHB6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243383AbhLHB6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:39 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A344DC061748
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:07 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id y6-20020a17090322c600b001428ab3f888so281444plg.8
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=aSFkuCGEBTHTvZi9DSeJE23ynNu9ldCmJkWpDFHPYL4=;
        b=pj1BFS5JDZwdQsoV5ZfUR4IjugpB87psw0hdDXxPgq+MvLU0SnQUMVYqxy80OHAJMz
         h/HlENiyKKLI8u7Ab1qQ/zFZ0keBREMi7vKUUYCICeOYbPGxHfCaEbg6UHNMkziCJEDn
         ic8apfjbU4NgCtjM6YLR3j+K4NyNpQLhRlKKXjwqFT5ebNr5zvgY53H2I+VkERETd09z
         vjcLZXi9NO8+z9zFBak7kTFIzqI71zO2DdlXn/VAjhI6oztWbyjY0w6J/w0ongdSRJSQ
         A4SM8jHE5VE46ur/zAukww8n4VP2XB8Q0gthwSw3Lxsok8nXU/JcGwe97EQIklK6KtfX
         kiXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=aSFkuCGEBTHTvZi9DSeJE23ynNu9ldCmJkWpDFHPYL4=;
        b=n4fki7qEu+kOEGXZ7BZWLemLxENE+8TOmyaXnIqjJnomqRCa9w7lFFJ9Sw1muQqtzH
         SU9e0OyuHx6pwvUkEMFCdHkdT63rQTncMFdPMlj8U5bWIaYZECKu4T41ercvROltdu8y
         NCdx90V7Z8QOeG0OanOCaGa0bJPkO3Uth2chLAc9GtInbuCbv3DwBLWydcv+Z9UnBMDC
         u4idkY+SkZ7A+qryImheva0Yi36I5N1JqfE39H5LE0rBUOJzB0Ladn1LgwzBjwX77bKt
         Vj4U90mFNWctwdUXdd/AgEBrqOFQslyIJEKhTecLnDuC2J+G9WO6xbQY2JbBug/TRG8O
         Lt7g==
X-Gm-Message-State: AOAM531LdiKmwtYNTHX28MwCjuckyAnBk+r6mL0ZrU/pNe9jsRBaDzvS
        V56VuUMhG+//87TG+6XY8+mpP18v0Co=
X-Google-Smtp-Source: ABdhPJx+JTTqJ9FCS754xSjU5PQfNUcp7bYmDjWBmkUjGbJNupRxR6OWycRJ4EvS9kgqXp+3ZNsipA1oW9M=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:2055:b0:142:497c:a249 with SMTP id
 q21-20020a170903205500b00142497ca249mr55114947pla.35.1638928507106; Tue, 07
 Dec 2021 17:55:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:22 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-13-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 12/26] KVM: SVM: Remove unnecessary APICv/AVIC update in
 vCPU unblocking path
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove handling of KVM_REQ_APICV_UPDATE from svm_vcpu_unblocking(), it's
no longer needed as it was made obsolete by commit df7e4827c549 ("KVM:
SVM: call avic_vcpu_load/avic_vcpu_put when enabling/disabling AVIC").
Prior to that commit, the manual check was necessary to ensure the AVIC
stuff was updated by avic_set_running() when a request to enable APICv
became pending while the vCPU was blocking, as the request handling
itself would not do the update.  But, as evidenced by the commit, that
logic was flawed and subject to various races.

Now that svm_refresh_apicv_exec_ctrl() does avic_vcpu_load/put() in
response to an APICv status change, drop the manual check in the
unblocking path.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 37575b71cdf3..16e4ebd980a2 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1039,7 +1039,5 @@ void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
 
 void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
-	if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
-		kvm_vcpu_update_apicv(vcpu);
 	avic_set_running(vcpu, true);
 }
-- 
2.34.1.400.ga245620fadb-goog

