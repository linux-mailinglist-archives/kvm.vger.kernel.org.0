Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCDE4D5B57
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 07:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245286AbiCKGEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 01:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347302AbiCKGDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 01:03:54 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8EE1A9494
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:17 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d145-20020a621d97000000b004f7285f67e8so4642516pfd.2
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8ix8hjq3ugfBG2VjWflpErmFpudSQCGZkT4xxCEQk+0=;
        b=kccGSI/hDvCHSQRVFA8c/lxGAUB465N9ZlpJ8LNzZljadoy6eaRouGO0ksm+3PwcW+
         Vhlw6MIBLNr7pwZaCJLg9mCQ6G0xiNhxkQ+NkNKPzxeF0mj2MpMlYGQIZxa+UYj3GQmg
         tof+9FzK+Tco2G/FpPmm/Aq/BarjXPx/wESPFMnryqUzzL0JXlK2j+ocXj/Hd21xGLNR
         TD9gNBskYZIppl3kma9baKZY6db4lEFD/Txe5QS1KABzNA2Y8oH7L3JmvIHVCINfsmSc
         IBuVhbsNro54yM0zh52mmuZHJeTmJ7kx/D3as1ta9Db8JGUNJBmjqAEOR1ze4Fc73LE5
         eXdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8ix8hjq3ugfBG2VjWflpErmFpudSQCGZkT4xxCEQk+0=;
        b=bVmbw3dM1XKHaKhVMlomi4hqr05TWju17N6DXf2/fOEaHv+lsFG3MBRjOcYn4QC5SD
         g90fympSWWyhOb9kw1ppViqrSdHZi9zgifDw1EVlkImGzYgrfREo44kXjPbSgWqErGZK
         D7uE+awl2PDJs3i9t9z8HK453CLyDlfPMWLv0gVH6n3rwqbP1RojZEFrzvmNSUDqAwu/
         8drMmls81NjioZPds5fvGoT3DiUJEt0F6pAkCBHtPhF0oxwunKbma9nIZ6Hid/w4eqjA
         Fgg83O+iwHY8EYgvsGfAF0MArU8Npe345HX5lyo/Zl4LxP4FV9DU1S9mBozTsR4G4bwo
         Zl1Q==
X-Gm-Message-State: AOAM532z7/acph1QDrU5nE+J1hNzsKNPpOMwMICN7RWuJq/i4WQTMvyY
        sIs1NtEvolm7lHx8HKICj4dplxi2f2Ma0I92y+J+0KiOsDOTCrw0aq+xpeW4nLmThhze/TX5vOe
        Ux/E1rF7U9bB1YrLxU2/bVICXb4e+4Eb5MWBYKTFjrzjM5S9/vRr184HS7MWulJs=
X-Google-Smtp-Source: ABdhPJxpGigncSmxYhf4XlgXUbziRCRypFVzTD0H9Yb5hfRYSmi/fZj91kJeTwObWuRykQL3BsReC0ZGkDnYsw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:a0c:b0:4f6:661e:8dda with SMTP
 id p12-20020a056a000a0c00b004f6661e8ddamr8400235pfh.66.1646978537229; Thu, 10
 Mar 2022 22:02:17 -0800 (PST)
Date:   Thu, 10 Mar 2022 22:02:00 -0800
In-Reply-To: <20220311060207.2438667-1-ricarkol@google.com>
Message-Id: <20220311060207.2438667-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 04/11] KVM: selftests: Add vm_alloc_page_table_in_memslot
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

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index d6acec0858c0..c8dce12a9a52 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -307,6 +307,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
 
 /*
  * Create a VM with reasonable defaults
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 64ef245b73de..ae21564241c8 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2409,9 +2409,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
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
2.35.1.723.g4982287a31-goog

