Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A944E55A3A0
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 23:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiFXVdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 17:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiFXVdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 17:33:12 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCF914D32
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:11 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id z4-20020a056a001d8400b005251a1d6bdaso1621565pfw.18
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ohg8qNeWO0k+2X2oA0Q1pw26PDOaQZastCoJL8M0MaI=;
        b=N9p1wwZh/XCHVIqx4skNWnvlfkCwThNdYWefJOHdhv0LJwlreDXmVvD187AkCAEbRB
         8tpHtkF+pjSVdue9tVQxFtG1k2LsUzoZs7TRDuXmQbLYLvSATZgEjEKWCdpB0+rSyqvU
         COdx62nRUmvroifzPtgEfMBWX//fvMeD2rdgny6jH+mno5kBROrrCtPGZtaVOm1bobBl
         A337SC+795bvuDy9LZxwAl+zsks6SOBz9dpBJER2uburfzxV+4Fd/7OjA0eFYAWBZW98
         aVCscOxEldujKBxA76XjtHASRd6+ZLI7y7qH98DX960+xWmWOnAo1nc5WYtFk5PuLEaR
         WezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ohg8qNeWO0k+2X2oA0Q1pw26PDOaQZastCoJL8M0MaI=;
        b=gEJ04nrBhs3CkSnhapub3TAc1yCQ8SrK7ZuwFp3bcnkgyWfY3m7UAcw8Os8SBJ3fcY
         zHiiNQzYMTAfZCBhnXGnpo40PUV+rTDtg/GpQDXKXbLFw2XTPV+EX39gob6dkg0fhPYr
         +cWDIFBOQ0xXmixJiLe1c8/8Pi1JTmvL//6ekuIVIGqvSdSQwGYD5/1qb46z5KgUCP1I
         RreXHOWDnr8HtAWjXjxIPE3JaW0VzwXHDcccSs1GQy9Insvqk9VWS1uWThY110ih+7Bd
         E+YuupSrLoSYxfeV/uyqHIJayijb7uWW/nGN14lKxgvzNtDZCBgyCJu6X3q46cNpyj6s
         TrEg==
X-Gm-Message-State: AJIora9f9EZKsRymbmwhd51VGR0HXIKmsQN4uGtX6AON8YxwP+2X6MVZ
        zqmPMlGuBmrqeA8U4LHoTdVooJAh+/si5LBY/VkVjozx533tMH2XgM9kmauSS2QO8jkFlIRrdNG
        L+FNJLhJwj8DVwhhNXsqkVZ5Zx5pCu4ZX70UH2ikkLE+SwdvOcs0egZ1gCkfW40U=
X-Google-Smtp-Source: AGRyM1sCWcsELpAQ1wrMtxcug7LwA0BHy7Mo52gKoM/XLGzmSE9sJ46xMPnzPGuTvXrq5lqC6TpMSo9OTYeaXA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:aa8a:b0:16a:1ea5:d417 with SMTP
 id d10-20020a170902aa8a00b0016a1ea5d417mr1128363plr.4.1656106391025; Fri, 24
 Jun 2022 14:33:11 -0700 (PDT)
Date:   Fri, 24 Jun 2022 14:32:50 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 06/13] KVM: selftests: Add vm_mem_region_get_src_fd library function
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

Add a library function to get the backing source FD of a memslot.

Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 54ede9fc923c..72c8881fe8fb 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -322,6 +322,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
+int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 3e45e3776bdf..7c81028f23d8 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -466,6 +466,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 	return &region->region;
 }
 
+/*
+ * KVM Userspace Memory Get Backing Source FD
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   memslot - KVM memory slot ID
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Backing source file descriptor, -1 if the memslot is an anonymous region.
+ *
+ * Returns the backing source fd of a memslot, so tests can use it to punch
+ * holes, or to setup permissions.
+ */
+int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot)
+{
+	struct userspace_mem_region *region;
+
+	region = memslot2region(vm, memslot);
+	return region->fd;
+}
+
 /*
  * VM VCPU Remove
  *
-- 
2.37.0.rc0.161.g10f37bed90-goog

