Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8388A54BB26
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357392AbiFNUJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357292AbiFNUIC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:08:02 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212A242EDB
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:54 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z9-20020a170903018900b00168b66bbde2so5344699plg.12
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=6sq6rj6hOcf7RofhLuTE1YZqxCrSxa9nH7bmYla6Ve4=;
        b=gtFwbBvlNOl94V69Y69CeUBN/v/9ZsmCJYxvsdf5jkijI3TKi8zWco4zFrPlLI/Dbr
         w30+1Ydf0dlNImj7N+ySceO8//UGPhQ6n4YwAHZlqV1n/Ad679e+Io29psdRUTx5JHlg
         gOhiVphWmk7dGAi5F9BOKfNXULxDAThXEOgoVdU7lbSiZqN1GR0dN9SnoT1dkIi4rBoq
         zvu7poj57gUnNJdxcl3MJ4+7ITtlOhtgX+rNitJJwq9OHq8AFQ1JWh2kf4Z895mBUqKz
         SQUey1k/WGWPnJMkVKfugkgwf9lV0D3oNPZcadjnl3rsLAJ+hUxqdr6I66YNpOH5EJFn
         OhrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=6sq6rj6hOcf7RofhLuTE1YZqxCrSxa9nH7bmYla6Ve4=;
        b=JVe4KVBDHO3twvajqjxS6fRU7IIARUFg+3+diVcElmRZXOX05dvwCprfS5q0BQXxsi
         sk6kjQDWPnav9MbRFmRqNoO8+iUVND1xnNmXcvZWbng/QaQZ3SGVIAdQQJOWC3XOpBoG
         ld0QQSOihE0j160t2dRq7Op3LDvt/sKHPbqjl15wazhd5W+TM2vGHkumb2j6j8JA97vc
         aOUDVlEm95jNE28LdqxcMTehXNlEAUYN4xVwrHtPVEKTYSmFHuPavh9peqF+FSz9idWN
         hPavmA+syVUECRoU/jBBgsx1SbtuXnqc8ooAdv2nZQI8YVmMUP/rLl0wO8UXgl9Nhzeh
         kMyQ==
X-Gm-Message-State: AOAM531XtquaUkCffOZ4/lNrCruvy4c4TG1cLHd1xE3Lg5sXccuOMnb3
        BAUiTE4OG6FkWlDUAZ1l5zEtpcAp3Mw=
X-Google-Smtp-Source: ABdhPJwc8Qgd57+EiS3z0qYQYX/WbkXJMJSV/lS4my02g7V+8R8qwOxGczY3Ka2H3SpOwbUW1vGd2h2xDDM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:8141:0:b0:518:425b:760e with SMTP id
 d1-20020aa78141000000b00518425b760emr6360171pfn.27.1655237273630; Tue, 14 Jun
 2022 13:07:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:48 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-24-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 23/42] KVM: selftests: Use vm->pa_bits to generate reserved
 PA bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vm->pa_bits to generate the mask of physical address bits that are
reserved in page table entries.  vm->pa_bits is set when the VM is
created, i.e. it's guaranteed to be valid when populating page tables.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 887272a33837..5fd6563f23d1 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -221,16 +221,12 @@ static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm,
 	uint16_t index[4];
 	uint64_t *pml4e, *pdpe, *pde;
 	uint64_t *pte;
-	struct kvm_cpuid_entry2 *entry;
 	struct kvm_sregs sregs;
-	int max_phy_addr;
 	uint64_t rsvd_mask = 0;
 
-	entry = kvm_get_supported_cpuid_index(0x80000008, 0);
-	max_phy_addr = entry->eax & 0x000000ff;
 	/* Set the high bits in the reserved mask. */
-	if (max_phy_addr < 52)
-		rsvd_mask = GENMASK_ULL(51, max_phy_addr);
+	if (vm->pa_bits < 52)
+		rsvd_mask = GENMASK_ULL(51, vm->pa_bits);
 
 	/*
 	 * SDM vol 3, fig 4-11 "Formats of CR3 and Paging-Structure Entries
-- 
2.36.1.476.g0c4daa206d-goog

