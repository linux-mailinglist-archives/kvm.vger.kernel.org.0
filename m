Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23354E5B7D
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 23:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241377AbiCWWzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 18:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241359AbiCWWzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 18:55:45 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33348CDA6
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:14 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b4-20020a170902e94400b0015309b5c481so1521546pll.6
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iVxsz/nxe69FaKPg7w+D5EN2GRyAtqQAGpLEEQZhEHs=;
        b=VU0CIiC8HQxd7t8K1M3jmQDYqgvIorEmirh+ftwpKsWGJiy95+m1qEDus1m4U1t5WN
         7UXWM/0apqb95IDvBoTfGgiEY71kaeuxiYEsyU32epxdJNRj2uUTmegG80Q51H9el7iw
         CzCdxLJWbmWVpaxM9XP4kHTR0X1vX3oHqxz0FiQlC1w3dPVl1KgUOJ+0Vb3GnEi2WiXy
         3BLwyuXJjxr0ZDwH+JUK1Zbnky1LNQMWWM8Pw1A+slStCy9SQJSNkQAoLARNjOU4OoCp
         CfambUCXnhYDW/wE5aaKMgKRKbhj6NoXnQ2vFGSLAcCcDWiXq6OuSKyDLkdy6rdes+Rm
         0yBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iVxsz/nxe69FaKPg7w+D5EN2GRyAtqQAGpLEEQZhEHs=;
        b=t09zpvoJUBiwa3XOwv26L8fPDONExiTTO2N0n/zrd2gh77QryGjIWW2loX09ktLi+2
         PUOj7tc5CsX+rLxRJsHSEa541ZjkgXla/ojKvXv3nrRPArDqeLFHKRvElDW0LnftRWuf
         81rRPifpp4iKRr4aK497ZICAoSRmtiW2pGt0o3aNZJ9bZkstZysk6kjMxpFgpGECxa3G
         r7FAifJ1fNRV9vX3JNsLMXoTVqiReM4Omkz56ZQ8NeV6iCM8SJT3IyYsPBLtH4RY7Rpj
         UW8joAYYL8Ak8j1FxM7QSpeFYdQQ9H4gzujKorPiD+9eZbBZcLZa3kkJo7WcHVEkKZYs
         Wmvg==
X-Gm-Message-State: AOAM530bU8NLBBJ7k/vmgrmHJv3t2iNdmxiDGknwifNlK6hancwDvR9s
        tAbxoff3Fwjq+wd3HuwilzUD5LpWcyzzpO6QDg9y/DZrc6TzXrh0+htg5p5b7Z5WfEhnO1txOPh
        TvL3J5VcXcOkKGwQyBYaJOdj9e83MBpZ+iRXaAxwmtBEoUtm3oMXiovmrLhoaOjA=
X-Google-Smtp-Source: ABdhPJwo+TcYa43YtvZ8dZVWCEVPpmS+xcdh51rkUG++rK+wYWB1GkUggZNN5tsVJR2O9qdpFXekINZzbsRF/Q==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:bf04:b0:149:c5a5:5323 with SMTP
 id bi4-20020a170902bf0400b00149c5a55323mr2553612plb.97.1648076054305; Wed, 23
 Mar 2022 15:54:14 -0700 (PDT)
Date:   Wed, 23 Mar 2022 15:53:57 -0700
In-Reply-To: <20220323225405.267155-1-ricarkol@google.com>
Message-Id: <20220323225405.267155-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220323225405.267155-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 03/11] KVM: selftests: Add vm_alloc_page_table_in_memslot
 library function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
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

Add a library function to allocate a page-table physical page in a
particular memslot.  The default behavior is to create new page-table
pages in memslot 0.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 4ed6aa049a91..3a69b35e37cc 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -306,6 +306,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
 
 /*
  * Create a VM with reasonable defaults
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d8cf851ab119..e18f1c93e4b4 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2386,9 +2386,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 /* Arbitrary minimum physical address used for virtual translation tables. */
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
 
+vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot)
+{
+	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+			pt_memslot);
+}
+
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
 {
-	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+	return vm_alloc_page_table_in_memslot(vm, 0);
 }
 
 /*
-- 
2.35.1.894.gb6a874cedc-goog

