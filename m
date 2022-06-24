Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C792255A39D
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 23:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiFXVdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 17:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiFXVdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 17:33:07 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68326EE3A
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:06 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id m6-20020a056a00080600b00524cc7fdfc2so1666165pfk.0
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PIIOwiRCVKru5M6Nrp84g9xloQXh7ZUyJ0Q6guk3mk8=;
        b=eTuzNcbtyO338kczzwE8DDOMuuaRH1f5Y9dAxTisl5Y7e+/HJAVItIcWXup3kKWD3W
         YRuZUONBmraW2flz1mMIEL8SePvG7HyLIbIDjj2/WpE1BXZjmiNG9JF3SXs1vOChRM75
         eiExX5JwR73k88IDQMW4ctBvGRyRG4Yp03JEbh5Qeye85P+wZINAzf4cv8Q/+pq8MDwT
         fcR/c5q/i4TYfIZwe03W6i+LNsBWcCmCiIF1rVAS8VM3+UCME6mb8Cj0a4vE4Ix2VWqv
         +MbVrnbDVRz/Xylyh8qj8R1FatfKkjQlWzLWEKnV3a7swy5h+JruRveFUWZRAVanriBO
         8UOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PIIOwiRCVKru5M6Nrp84g9xloQXh7ZUyJ0Q6guk3mk8=;
        b=WU9zkgohRgxnRoJj+pqDo/cS7L2pxYuMnb38iYPA0cajP4D/OmnfcgRXL7klB+yweq
         KS3ohjJt9IR939qFLYsBe/08BaXw1i/EMbBMe2WHFVl4kDiGBqJw+FaZzQ+WLF8h+rpI
         oPwzaVAFBYpXLoVsRDb74EOZ3jCA8SDzkvxF8sURiCaO0LvXhyOK9iUeIBs+IxgHdZ3S
         x7N3+emuM8lJswKHLiMEBvOec0fiTAsMcPArWSHQlq3XDp2kGqAxVGZkplcU1rvqTSSU
         nR6Aay3dMlvfZJ/HB8hrBgZv7wh8lGhOTJvalPgFu+9ipYV2QDs3+1pZ5XfGsq6WDSmI
         Rnug==
X-Gm-Message-State: AJIora9K1dnS3R3VLUSBJhVHLRhGZK2JNGnuLqq3+qXni+9Uvjqf9TF9
        X76IVEJfdKFkcBe2+76pU3xNc3bjm0X/uNtv41GNLU8YMgisiV8CbAZXERT40XGakZtR7e8dqKD
        iZHbi44jOv0A64F+QNg/etw8+IS4uD9ESd2yy8hunEIGAf12xOji3wMTzaaMnWjk=
X-Google-Smtp-Source: AGRyM1vyYc6zEfg/uVBMFxS2YQhhzBVbpIiwAhrjvZY1Pv3CVOwjZYTcuI+wbDJ/F+0YKM/Em71XQ1AH/IrKuQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7085:b0:168:97dc:ddde with SMTP
 id z5-20020a170902708500b0016897dcdddemr1071782plk.25.1656106385892; Fri, 24
 Jun 2022 14:33:05 -0700 (PDT)
Date:   Fri, 24 Jun 2022 14:32:47 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 03/13] KVM: selftests: Add vm_alloc_page_table_in_memslot
 library function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com, Ricardo Koller <ricarkol@google.com>
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

Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 7ebfc8c7de17..54ede9fc923c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -579,6 +579,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
 
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f8c104dba258..5ee20d4da222 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1784,9 +1784,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
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
2.37.0.rc0.161.g10f37bed90-goog

