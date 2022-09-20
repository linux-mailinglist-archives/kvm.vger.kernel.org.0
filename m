Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF255BDB42
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiITEP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiITEPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:15:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD7227CF5
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:15:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b14-20020a056902030e00b006a827d81fd8so1066041ybs.17
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=MpiWeS5yT9XQtTMvfOWTUplS/QmLd1Rz7gB7rSz3ANA=;
        b=WGfWOvd651OPU36vfdkVf6aKW6kkKSmQdI9uaJ8UegJkA8h64GkxoGQN0mOlZ450ZR
         cF+4kqmvwDIGt5rgJEswPRo5RR38yVMyFPVm52++arxNBTL/Wp1A6yxZlwNrmbWcyhQF
         AaeUAhp2EL8qQCophfoyouvtjJDFNSeuGz4TRvJqW5CtWIZsExlIL0XL0A76w+IDGeuv
         roAGE04ShN5CxI3hDyMsQweQ3B2aqFubf3TKizCvQsCo/is29MOxAR1emEy8+emc5zaL
         wSPF92flRwEow21BPz/DCFufyaIgejTRvRcj0JFgSkYXSEyh9zkd2B6QD3FESrsEdayy
         dOfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=MpiWeS5yT9XQtTMvfOWTUplS/QmLd1Rz7gB7rSz3ANA=;
        b=c17yQWuO65Bq49pQlSwhDpbnEOBLN27tlQVVXijZnFBZ3l/P3FWW6eixz6PdjPSJLs
         xBhBvGZ3NMhkFVVUTc1ej91dX6SylGouB9y4DnEqlrbMw6f5BbuLHa376lC1jGYhWM0Q
         TThV12+SE93CXqFWnfVlco07FWNm4Lhl4PWKuTH5iaSee9Ky2yt8b0NA0ruVk6dLcn95
         0ZaU8+yqTClFuMARXCgimR4oB1sWNtTL8dAQqWH9l8kzj/FgdiYnxVCxW6bGIO98ZiqF
         /yv3NlCOa8VzODa22/HizFsCUtu1b/RtbR9XZ32siVTcx7QQo9okygH/k0bH33r2bnQQ
         n7JA==
X-Gm-Message-State: ACrzQf0Cb3UYxKzj3M7wxymGkWx/P3kTzrRQG75Cu2qQwos2KyreVINz
        s4H5SIoVJmJS+0SE/asy3XhtBME6YZUkS8tvVcZFch4J+e52yzQbJqC2YAmajX70HPbVtBMDV0A
        aa3DjfitJRBfeMqmRjSSOT/usvlmhWCXKO0m/iR0NO8s98dhZFy2/GLg2b35VYjU=
X-Google-Smtp-Source: AMsMyM743v9RHjCbocTeIC8k7S8usQkHw9SN6JnI4RIjXLvXo1eeVqBlWeIPovzZ3O5kAOfJedfifjR+iHq8Xw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:f88:0:b0:6a2:805:7e70 with SMTP id
 130-20020a250f88000000b006a208057e70mr18193563ybp.461.1663647321752; Mon, 19
 Sep 2022 21:15:21 -0700 (PDT)
Date:   Tue, 20 Sep 2022 04:15:02 +0000
In-Reply-To: <20220920041509.3131141-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920041509.3131141-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920041509.3131141-7-ricarkol@google.com>
Subject: [PATCH v6 06/13] KVM: selftests: Stash backing_src_type in struct userspace_mem_region
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
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

Add the backing_src_type into struct userspace_mem_region. This struct already
stores a lot of info about memory regions, except the backing source type.
This info will be used by a future commit in order to determine the method for
punching a hole.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 24fde97f6121..b2dbe253d4d0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -34,6 +34,7 @@ struct userspace_mem_region {
 	struct sparsebit *unused_phy_pages;
 	int fd;
 	off_t offset;
+	enum vm_mem_backing_src_type backing_src_type;
 	void *host_mem;
 	void *host_alias;
 	void *mmap_start;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9dd03eda2eb9..5a9f080ff888 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -887,6 +887,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 			    vm_mem_backing_src_alias(src_type)->name);
 	}
 
+	region->backing_src_type = src_type;
 	region->unused_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
-- 
2.37.3.968.ga6b4b080e4-goog

