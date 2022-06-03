Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448D153C1EA
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239529AbiFCAyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241087AbiFCAuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:24 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694C02DD42
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:34 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s204-20020a632cd5000000b003fc8fd3c242so3056145pgs.7
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=83uHdjveTV9JqF8Qzu1gLbAMw/PFt6x8USvDY99Vle0=;
        b=aJnxC0JYG1QHPuRXcIx9kJd3MMrm58q4iVFryuMfGAsmCOv3S+3IGtZiDhb/6HYrBY
         0zAUzbOWd0MSVHNMaz/mrja/yWNHaMKD+l92I4bGaTv+CIcDA0Ew/SH1t1CevhcCzdc0
         BTRLW3dYgjIIV/OtMZ+ARhyI+VFG3/NqdvCHTjvEhSKh0Mtl/uu1eY0H6gUtfL5x5Uly
         hGFNxK36VBMczD58Qwy3e9nhi3VofST5QmtG94eD7VQiffzsPqYeX8tCKY64YqFGiKfx
         kCU2XIfLf1yU9od7mc8oTh03uOO+7xU0p6ySJlrdQmijN2dQkyouB972L0UsXqjizFIO
         2Qvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=83uHdjveTV9JqF8Qzu1gLbAMw/PFt6x8USvDY99Vle0=;
        b=CsXod1FyHmczdc/z2Ii9NPgJBWzkWbB8GREvRvsrUgtiobfw7yQ7wBZ7R1QnLeYPz3
         4dgAGjq0RQ9vBcc49dhsSjbh8khACeYdMsPzsTI8XJy/oJiKoj2M0HADdEbIdRKShflP
         kpa88f05HLebZfeLRIuDfTB7/x1YIYvkfxaOVYOXCNpn6lDhL5hIo0sr5IthSq6an2N8
         pb+gwS+Z2gu4rP0zEkL1s2QLI8sXikHG6W7JZtL6oV3vKkZpIXkkOQ1tPd94qs/f5Lap
         nXnc2SXlcuV7uSOBLr7YB8tdb9DVXh7hUnBxqPtOXuQYKDk+5vcSF7+PrIE5hGp7KCjn
         FpLw==
X-Gm-Message-State: AOAM530KwCO7SutI7r/W466XE+3DAu1Xg1CjqX2g7Iy8KXPSe8pwHOIz
        tyfOUqDp0mVWjVv3JK5NWOLZ/ZiHxRE=
X-Google-Smtp-Source: ABdhPJwTS6GnZOGxbbEaHTJrMcq3BHfSnkzCF+mGK6UPUtc0wNgiNnwgyfPyzlu5P2+u5T3RiztlsdgAuiM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e54e:b0:162:4b8b:f2be with SMTP id
 n14-20020a170902e54e00b001624b8bf2bemr7673424plf.5.1654217251570; Thu, 02 Jun
 2022 17:47:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:17 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-131-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 130/144] KVM: selftests: Remove vcpu_get() usage from dirty_log_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Grab the vCPU from vm_vcpu_add() directly instead of doing vcpu_get()
after the fact.  This will allow removing vcpu_get() entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 1a5c01c65044..5db56140a995 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -665,7 +665,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 	}
 }
 
-static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
+static struct kvm_vm *create_vm(enum vm_guest_mode mode, struct kvm_vcpu **vcpu,
 				uint64_t extra_mem_pages, void *guest_code)
 {
 	struct kvm_vm *vm;
@@ -676,7 +676,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 	vm = __vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
 
 	log_mode_create_vm_done(vm);
-	vm_vcpu_add(vm, vcpuid, guest_code);
+	*vcpu = vm_vcpu_add(vm, 0, guest_code);
 	return vm;
 }
 
@@ -710,10 +710,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	 * (e.g., 64K page size guest will need even less memory for
 	 * page tables).
 	 */
-	vm = create_vm(mode, 0,
-		       2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K),
-		       guest_code);
-	vcpu = vcpu_get(vm, 0);
+	vm = create_vm(mode, &vcpu,
+		       2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K), guest_code);
 
 	guest_page_size = vm_get_page_size(vm);
 	/*
-- 
2.36.1.255.ge46751e96f-goog

