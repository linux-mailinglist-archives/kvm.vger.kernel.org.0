Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32815AF356
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 20:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiIFSJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 14:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiIFSJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 14:09:50 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03592871A
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 11:09:47 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id h12-20020a170902f54c00b0016f8858ce9bso8200166plf.9
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 11:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=0SMylmi5VoKukevMCg329nqGKx2bQIjB0CpF+sxCEys=;
        b=j8CaVHHKMwtkw0CT4wOaawapBm/83lk9MV8o9HK1oFoiBAmmJWSgFszewtB/f3aQyr
         qv/JSfwxX2JpW0vWeCmAGyOlt364lyU45six1Bn7jxSwk1hRds9NCVd8HnDXaX3/t54N
         WAEMsZQGcEhGfN3hmUubAgn2r0bSdFKS4qXIgBRKdIfDiKrmXQc+8JZxdGAEA8nrBSFt
         NIrLeiq9SLXBTVJuXucL4lfRRvz7OxejDvDcpAy+YIx9oseJcxXKsu6ayKICw2P9jiCl
         PFBlJ7ebRT0xjADDaA+e8O2gUgbW1uOY2iymZ/xs8mC8u4nibHnV7E765pM2IIj5WIcA
         teJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=0SMylmi5VoKukevMCg329nqGKx2bQIjB0CpF+sxCEys=;
        b=71sPGwPSU3mV6ykQUhUrJkNahEJke6MLr8HsfXbU0xOscTtAtbzab2y1SXneWtiiVn
         UBlTZEi3mM283RxGAUCoT7/idvYAadM1DNL2qfd7zKTbc1tNGqp54urtmXxrWac/zCgy
         cmvDNUdD0jYvGZ2TW3341uxccFE5UtMnVNoVwCXXl/EozbWlCn3C8S9SyadWCQJLTIi3
         QBtLCAz7YqV9yYw+Tgunr5Q7bb9leeRlllKRwbDPfSzvr3YpLmPXVnOxBRF0zWhU4pVH
         dLAdjQdg/Q1Au/0lRirtdmXloQiP7HJFdhkgqtWL71y4ZWVwFxX7xZg4YPwJ7oN1Dn0M
         Pd0Q==
X-Gm-Message-State: ACgBeo3NipTQoV/vF46H2Qp3bU3MDiL6yS4zUECnFUvdosxRdesgm55D
        hCkK+xpE4Jvg0RZBojsIFWAjOCbLeLzzd+2p1pGj6CFWp1+gTMcnrjO19EdPceemaE9J1hTGcBH
        VkK73BvUzzSBmaludmLaOHILh7jFJXnHqfgQof8NjN6wAnKuSBSRmBCgv5BpB/34=
X-Google-Smtp-Source: AA6agR6nO2Zhbp7vYQuiuptLKxsuxovt2DSw0/ssCA5XC63l+hdsth9veFaamYsFWfvkP59eq6149XXlA8B55Q==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:164f:b0:1f5:4ced:ed81 with SMTP
 id il15-20020a17090b164f00b001f54ceded81mr25678999pjb.122.1662487786468; Tue,
 06 Sep 2022 11:09:46 -0700 (PDT)
Date:   Tue,  6 Sep 2022 18:09:23 +0000
In-Reply-To: <20220906180930.230218-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220906180930.230218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906180930.230218-7-ricarkol@google.com>
Subject: [PATCH v6 06/13] KVM: selftests: Stash backing_src_type in struct userspace_mem_region
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
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

Add the backing_src_type into struct userspace_mem_region. This struct already
stores a lot of info about memory regions, except the backing source type.
This info will be used by a future commit in order to determine the method for
punching a hole.

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
2.37.2.789.g6183377224-goog

