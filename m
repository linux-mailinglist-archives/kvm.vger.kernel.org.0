Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6296A6760
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 06:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjCAFe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 00:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjCAFev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 00:34:51 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4852C1ADC1
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:50 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id q68-20020a632a47000000b004f74bc0c71fso4174839pgq.18
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677648889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eAAYyK8vwtil/XqRLlZoyfP+rbFvoTDOm4hFzsm92oA=;
        b=hqHGSORoVWqLmkQqW8pJAlq8KwtVrOcdIFvTvy3jGyyCttBrU7Np0jInFNxTVIpyRq
         tPyi+p8ck0xPYDBMS5Vq1TCrZZdkaeMEqSQRYW8Q+lH8oi7LyPAQJ3LDzx3i+RMx7Y/j
         BA6FbQptH4E0TiHpKjH/uCz+tID6ZGN5+iS2KLltHUonKon2cvso/TMJe/v3ZBmb+x8H
         aJBz0OQd2kCyHQLcbnlkDZwiM0jdcIM84so50pVl4smBi3AAKa8WlynL0bKPbWzxj79u
         81Hp9L3X0cw6zx0iWMhVhnX9BkfnNSr0maHYnwLpmg8OPJ2ejCM7kC+WYg2hmtE5tOgB
         N/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677648889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eAAYyK8vwtil/XqRLlZoyfP+rbFvoTDOm4hFzsm92oA=;
        b=2HrW8JIEpt3lBtRRigl17jBKhA3qMBr3EHDXVv5N/MQTjvrb4oUGoahcCzKvIyXlFK
         gxyxEv0TzJeff0MJAPuLCENjsdO2CdTEfjfilXxO0mh1u/buwaHKMEUpnt8B8FYH32CC
         OactS6uyXJssOcbPtdTxKK6RigdGQJCyQCIWsX+cu0Qy/sE/RWWSETkUPrqtsIGv/iRr
         g5WX3NNCbRlNdGv9asRgQc5tpb4+A3FWI9MSRRcLfGCPR3rZT98Km8xLQX6J6A4x0Jcc
         sEql0gfDd+n4kTd0ssMOkAOdA/NZE4yLH1FlrHLCHdyqHDoaPekZtA9wNIUZtfqyfWty
         Oxdg==
X-Gm-Message-State: AO0yUKVtCWI5TTDDufgpC/BzSS55nBoxKmH6CiYGWTbwygNpu7djnXu6
        w0VAUCZxfSt7gbTXe+lVhAP7XgqNZW/yIIfBAx2Ekc8VLShq9WaezJFs03LtLTwRyYwip5/h78V
        1J3vYr/YY0Q45IVfCsqY5jZ3H6X15mAI3E6N8qrXSEmlREG4iwaFNeqmvfVP2o9bFJGQs
X-Google-Smtp-Source: AK7set+NZYFgsUFEPSpp/NjURXEN8Mvt2W8zy9D0r8fOH4WYBAsbH/euV3o7uk9k6dHmL0J4k/9fv4wktcFAaA8v
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:f7d1:b0:19c:140d:aad7 with SMTP
 id h17-20020a170902f7d100b0019c140daad7mr1861398plw.4.1677648889508; Tue, 28
 Feb 2023 21:34:49 -0800 (PST)
Date:   Wed,  1 Mar 2023 05:34:23 +0000
In-Reply-To: <20230301053425.3880773-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230301053425.3880773-7-aaronlewis@google.com>
Subject: [PATCH 6/8] KVM: selftests: Add additional pages to the guest to
 accommodate ucall
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
index 1a6aaef5ccae..0b1fde23729b 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -34,6 +34,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
+int ucall_header_size(void);
 
 /*
  * Perform userspace call without any associated data.  This bare call avoids
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 3ea24a5f4c43..e1d6a2f40d2d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -307,6 +307,7 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 				     uint32_t nr_runnable_vcpus,
 				     uint64_t extra_mem_pages)
 {
+	uint64_t page_size = vm_guest_mode_params[mode].page_size;
 	uint64_t nr_pages;
 
 	TEST_ASSERT(nr_runnable_vcpus,
@@ -335,6 +336,9 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 	 */
 	nr_pages += (nr_pages + extra_mem_pages) / PTES_PER_MIN_PAGE * 2;
 
+	/* Account for the number of pages needed by ucall. */
+	nr_pages += align_up(ucall_header_size(), page_size) / page_size;
+
 	return vm_adjust_num_guest_pages(mode, nr_pages);
 }
 
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 2f0e2ea941cc..b6a75858fe0d 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -11,6 +11,11 @@ struct ucall_header {
 	struct ucall ucalls[KVM_MAX_VCPUS];
 };
 
+int ucall_header_size(void)
+{
+	return sizeof(struct ucall_header);
+}
+
 /*
  * ucall_pool holds per-VM values (global data is duplicated by each VM), it
  * must not be accessed from host code.
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

