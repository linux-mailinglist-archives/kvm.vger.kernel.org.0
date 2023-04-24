Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6696ED83D
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 00:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbjDXW7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 18:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbjDXW7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 18:59:05 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D247C9016
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:59:03 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-52503bfeb07so1251799a12.3
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682377143; x=1684969143;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tFdJlULW+RSlKDezjU5UBSNY1Khq0ApSCM2c+f/Cudg=;
        b=YXwi6TY9j7KPw4NvQBhzCtQMyWITMb0YPtI1t13fDl1YE0aukmrNsCZtcRYhJuPDQB
         xhVsJ4p7viGN/SfZOScTa/wTM13k/aYTA+8QXbK+Xd99R8sxcWNNeIJ7FMYg7chL2vlo
         3Uwh5FqgoVti3rR+JTueNTS53hFIzggQHgd1SwuUlseVgOge3XtFg9KTkuSEMFKAgq3x
         LUWYNpNrmIfRzk6E5nTGuso2e4VVfiJsTdsbKdi1kmg6gFvYeHPPcagY/kCyRiPp3oTU
         7yQeLg5f+hqbN7yAjIw4bEfxrhvg1V+1fdy2Wl8DiRA+GupS7oisd0R5UQjgI0sLwfl7
         vvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682377143; x=1684969143;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tFdJlULW+RSlKDezjU5UBSNY1Khq0ApSCM2c+f/Cudg=;
        b=enpoTdaS8ls+Vozti2GdEuFQjGek+emVcvVuM/8duAKvrXwoUGFQSkS6EW+G7S2fGs
         cOb9zAuutzyG6iVH/ZvOEWo3XVdTdB3oTfanlDqDojFr8IkC4Xs3/YHwaInkkp1mJqHu
         cPwTM0lznio4gKylAoHt8Rb+zJSrtzHm8FIjiF4EwiTFwXVRv6J5Gw/e2YlOXT7Kaqz+
         ALhgzrcENJBScEHxOynx8Ab8+QSF4w9Yizm5/fB2I/NsPXQsVuyz2yf25JX++gu/t928
         7dkus4zC6FWWuqfkcD61sDO4RZivWOZL8M25rK6/FdlRO5dExRqefek3lbl+/IErVpmM
         wkdw==
X-Gm-Message-State: AAQBX9cagOlXaUVoYzW/gWqIglR1AYcx1JV+c8Icr0vZZzg1zfNDdWHg
        qQ99E2mMcvo3SnM95oCQllDx9Un3xKFYmXYYS4SM31Pp0z4StIdpRJUx0LWlA++ijSXg5Vk5cex
        DtdBG75DWDLUoWDlV+89R7BcFaZLokrjgw0NEWcSz7V6RpDFiebo742zebeDQ8+qtJrxr
X-Google-Smtp-Source: AKy350Yh66TOrWXBeU7sxJK2vE4NYBg+wVgLzId6VnNl4cgTkS3vAzOl6JqvFMF2YrY57Tjf+HU1MfC6dCm4WBP1
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a63:5f83:0:b0:520:4c05:221 with SMTP id
 t125-20020a635f83000000b005204c050221mr3496809pgb.9.1682377143275; Mon, 24
 Apr 2023 15:59:03 -0700 (PDT)
Date:   Mon, 24 Apr 2023 22:58:51 +0000
In-Reply-To: <20230424225854.4023978-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230424225854.4023978-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424225854.4023978-4-aaronlewis@google.com>
Subject: [PATCH v2 3/6] KVM: selftests: Add additional pages to the guest to
 accommodate ucall
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

Add additional pages to the guest to account for the number of pages
the ucall framework uses.

This is done in preparation for adding string formatting options to
the guest through ucall helpers.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/include/ucall_common.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c         | 4 ++++
 tools/testing/selftests/kvm/lib/ucall_common.c     | 5 +++++
 3 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 1a6aaef5ccae..bcbb362aa77f 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -34,6 +34,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
+int ucall_nr_pages_required(uint64_t page_size);
 
 /*
  * Perform userspace call without any associated data.  This bare call avoids
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 298c4372fb1a..80b3df2a79e6 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -312,6 +312,7 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 				     uint32_t nr_runnable_vcpus,
 				     uint64_t extra_mem_pages)
 {
+	uint64_t page_size = vm_guest_mode_params[mode].page_size;
 	uint64_t nr_pages;
 
 	TEST_ASSERT(nr_runnable_vcpus,
@@ -340,6 +341,9 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 	 */
 	nr_pages += (nr_pages + extra_mem_pages) / PTES_PER_MIN_PAGE * 2;
 
+	/* Account for the number of pages needed by ucall. */
+	nr_pages += ucall_nr_pages_required(page_size);
+
 	return vm_adjust_num_guest_pages(mode, nr_pages);
 }
 
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 2f0e2ea941cc..77ada362273d 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -11,6 +11,11 @@ struct ucall_header {
 	struct ucall ucalls[KVM_MAX_VCPUS];
 };
 
+int ucall_nr_pages_required(uint64_t page_size)
+{
+	return align_up(sizeof(struct ucall_header), page_size) / page_size;
+}
+
 /*
  * ucall_pool holds per-VM values (global data is duplicated by each VM), it
  * must not be accessed from host code.
-- 
2.40.0.634.g4ca3ef3211-goog

