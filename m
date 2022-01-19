Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B711D4943A8
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357842AbiASXJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344374AbiASXIJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:08:09 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFCCC061762
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:08 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id k13-20020a65434d000000b00342d8eb46b4so2482825pgq.23
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tb/bgoSf75NpcQTVrVWSlXxFAGhBf9G4A7XAijOZNQY=;
        b=qpsw03RSzHxVn0qOAVYN4tG0fp0hvQBdQPptT4fmaNxgonKflMBW0kTSXTntJf9jyO
         Gu7ZX+xZHyFtIi5d8nO/8gKC6PHXTTqIcYxTHt8GXaMcZltEkXSZHKFy++U/8TX+yVzS
         o0lqFfIKA6G9gAZRcfT/AkEI0uha6stVdNVj2nxLUCf0ZIfmaEW3fpGgbk/3laqVmGAq
         mgwUz68YhTX0q7yJzTQhAfv2bO2nDZhOQ0GG6C9X2hB3EmvHCYnHnynVrowy4bu//22/
         cC7mOrN6wi98WyOL7iX1kd/hO31UczBRksExrnf9lI5HXbCYQpEfnq5rI12RqSn61loD
         8C2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tb/bgoSf75NpcQTVrVWSlXxFAGhBf9G4A7XAijOZNQY=;
        b=To6G9/EoauR9bIAdquOLN1IYGdBts6+rt8KMAhry2lbCNMEiiDPcwWB9/YCv0Gl1UP
         Wtrro5QjTOHQbyYei4onQ0xWdv4ioPft02kWFLVSbFLgiyAwiVWNKoDjIjptUiZF38zl
         AlKRo8w1XyR9Zwy78hm9xLViHBrZPYzipKxS4qAJaKSmjqkbygIZDxtv8JN+k2ktHnf5
         /bnIYOmcQamhIhYm6lJn+o7wnZLkypTKkb9aBWW45iuhVr3Qo+X4rVYLZXuMw9WIZN45
         j5pJwRlzfijgmiml8EhoGpgCwpilkhvOUCl5FoKKfO/PAvKM0V7+vgBrugwKROXz9xsr
         Ghwg==
X-Gm-Message-State: AOAM5325Zk0vmFsrtCE7DOSiLFkWk8pRmOjtgiE2J+WblAeuJsNSVK0L
        +Jhe3nNSlpPRfL+Zet+VXDGbABGhuTW7vQ==
X-Google-Smtp-Source: ABdhPJzUI92PR6qe/UaqXaBTRDo8ANf9xBf4SekIY3I1czcBCAFO6PmZ8/ig4oEEhlF3ozwaAfK2pkwn+Cat8A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:503:0:b0:4bc:764c:5524 with SMTP id
 3-20020a620503000000b004bc764c5524mr32860483pff.25.1642633687686; Wed, 19 Jan
 2022 15:08:07 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:33 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-13-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 12/18] KVM: x86/mmu: Remove redundant role overrides for
 TDP MMU shadow pages
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vCPU's mmu_role already has the correct values for direct,
has_4_byte_gpte, access, and ad_disabled. Remove the code that was
redundantly overwriting these fields with the same values.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 38ec5a61dbff..90b6fbec83cc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -164,10 +164,6 @@ static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
 
 	role = vcpu->arch.mmu->mmu_role.base;
 	role.level = level;
-	role.direct = true;
-	role.has_4_byte_gpte = false;
-	role.access = ACC_ALL;
-	role.ad_disabled = !shadow_accessed_mask;
 
 	return role;
 }
-- 
2.35.0.rc0.227.g00780c9af4-goog

