Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5043E32B591
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380003AbhCCHSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581592AbhCBS7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 13:59:15 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04531C0610CB
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 10:46:21 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id v196so23496808ybv.3
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 10:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5+PA/fudqiuRApGQPz15mK0wOSfWjZ1lIFOzJINKfHU=;
        b=bFc8khCJtym68Ud7GrqEZfDGnDW1noMU/UHyFuPtNmG1Yl+HtHLiwTfXLa3NAlFD6l
         xQrYzsRaQUMiVkc2yrJEIlbEu0Gh52AvTi3RoCcUnjaNjoHa1VKI//OcE4ICm5qMN7ef
         eDWuXOcMBkKH2WchlX5Er0y9ZURj5c678uLA1bPzRu7yxHugiThcqixuy9N/MZp4hLOR
         dXDi27l5EJ7oLACDTSDigecLeWV0u4GtEdSXVHV5bgbqEFe2F4iD0kDsH0Unv1sToZB5
         bhk7EzMnK9NFowaiYNeFT4NFK8XY7XQk96gUOg6nc8SX9PfNAOXs8xu0ZjiRrk7W+rGT
         kLDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5+PA/fudqiuRApGQPz15mK0wOSfWjZ1lIFOzJINKfHU=;
        b=YqUPyoNutFUFt6xfYTferGQmfrIUT8cVKOjaW+NEajvO6tJMgAGnHhj3MkBqZ/8bOa
         0w54J2RCsAv9L8OxYKNuZazF8q7X0UtVj4q6DqBkGmldh2NqM65ZRSA20JZAZiM3O/JS
         26hsqGtxD25PoPcqGc80yFudBy4knqVLsd0afyiP71K8VkXijJFgaoBdNlC3GaRM618a
         RrHZkNV7HDxW4PDROlQJT3BeikdQqFu2vuMKnOeNIJ2XyUrXIhkaSC6ejp4ygz1sUkqz
         IJ6RT/h85aMyEoHIsTm0lMNT/PieHwyMxtHrrR+NOCy6uMG1VkC5dD9ulAsOxUo1c0yq
         7NPA==
X-Gm-Message-State: AOAM533jwdBmXAHjF5Oy/slbu7kFTdvOJlTIiX85FosdhbfSIxX3BMW9
        ZUq0U2DW7lsn1lXTc8gSQugAuTqcYYU=
X-Google-Smtp-Source: ABdhPJwqo6WN5qp31P8PW9KH3y3esG2aSrP8Tl2w1rXS7TOvwfVB4PsGn0IioUSEZ+HCqKZaElgw8+9XVgY=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:805d:6324:3372:6183])
 (user=seanjc job=sendgmr) by 2002:a25:abce:: with SMTP id v72mr34681758ybi.152.1614710780315;
 Tue, 02 Mar 2021 10:46:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  2 Mar 2021 10:45:39 -0800
In-Reply-To: <20210302184540.2829328-1-seanjc@google.com>
Message-Id: <20210302184540.2829328-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210302184540.2829328-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 14/15] KVM: x86/mmu: Sync roots after MMU load iff load as successful
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For clarity, explicitly skip syncing roots if the MMU load failed
instead of relying on the !VALID_PAGE check in kvm_mmu_sync_roots().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 86432d6a4092..34eeb39ee0f9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4818,10 +4818,11 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	else
 		r = mmu_alloc_shadow_roots(vcpu);
 	write_unlock(&vcpu->kvm->mmu_lock);
+	if (r)
+		goto out;
 
 	kvm_mmu_sync_roots(vcpu);
-	if (r)
-		goto out;
+
 	kvm_mmu_load_pgd(vcpu);
 	static_call(kvm_x86_tlb_flush_current)(vcpu);
 out:
-- 
2.30.1.766.gb4fecdf3b7-goog

