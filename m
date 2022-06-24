Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807A355A39C
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 23:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiFXVdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 17:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiFXVdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 17:33:11 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0810E11C25
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:10 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u6-20020a63d346000000b00407d7652203so1550870pgi.18
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=otVCDsDipEgqqy0EKJSpTC6sTwev8b+0+mqwOVd2AWM=;
        b=YBMHgPJkXnFFS9afwwbH9zZeXr5t3AxpkWUPoME1Cx4KZrzy4yetX4RbI5zIjZF7lc
         y/eg4HH1FfYqF7SNJPBky2VUURlQnF/lvFdMmPBD6OijRt7oe5h0UqIyeSoca8f1tFh+
         Ef9TCMOJc265YUKqbcfwCuvX7lnhOpHhSfiHgkthbDeteIZsh5LD212Z2IqWcv4vOe/Y
         QuYwQmSNlqB6J7Lt9DeABIww7RBEoSjX9qck81pas208WM/fGc7/IBpzHEG7m15D4wAi
         EKuXmCluUtIxqxxEAUzDlYNLTDvIGlKKQAcz10VtrbJfy7Z1X66fsjShJhE34sUI8o9M
         I4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=otVCDsDipEgqqy0EKJSpTC6sTwev8b+0+mqwOVd2AWM=;
        b=JLSZ+Ijb+obPV0y+a/HX2OMfl0767BTMXfRLcBeVrVD8sCJ3xY6r8HB69tFmv/cr/g
         nKM0LLdSGB1507h67PTBGEL1gaPvihzl5kP4iRLD6sdhb4SpZcQDv5+M2i4eWNti8s5j
         JwjnIx3cufWyY9XUTCM7Hf6SXl3JEWicyJhLyI3agiS8BKicApInDAO9ge4wvoLIFNyy
         RcS3fMPhvnEH3KzrcFsWJbvUVG+bBRKYX0nmPpFDjxHgzxdczZ2gDZUKg4VsRykqb+TD
         XhGTbn4QMffDSVgan2+uRvhe/QarwCLlCkhM3MW18WsA8ohVE72SVq+MOn43yuBuMzCE
         UYOQ==
X-Gm-Message-State: AJIora9cJbkFbkZgC+fGzUJZrXPzYAsWYaf0rQrp4Yy2In7HABSNelsR
        uNpH+RC5FGiPBtov/Pi30BPEsz+I9IBGbrZB2Qpehr+/eDwoTw+H1U1AjbkMg9/arSHrr3s+dyq
        qnEsbGtwtorFOKAITJeUmfZ9s5Nudyu+JmI2CZBUKM++jkfIsNOdlMh2p8l7tPlQ=
X-Google-Smtp-Source: AGRyM1vqxKSZJ4P11BC2HxRlI4B+bvpREdVNXBFoOE27FV8Tj3VmayMZgHvvdiIYWdsa2eGYkGNfmyJoOzBzgQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:10c:b0:16a:1166:4ee9 with SMTP id
 y12-20020a170903010c00b0016a11664ee9mr1058965plc.138.1656106389460; Fri, 24
 Jun 2022 14:33:09 -0700 (PDT)
Date:   Fri, 24 Jun 2022 14:32:49 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 05/13] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete
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

Deleting a memslot (when freeing a VM) is not closing the backing fd,
nor it's unmapping the alias mapping. Fix by adding the missing close
and munmap.

Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 5ee20d4da222..3e45e3776bdf 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -531,6 +531,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+	if (region->fd >= 0) {
+		/* There's an extra map when using shared memory. */
+		ret = munmap(region->mmap_alias, region->mmap_size);
+		TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+		close(region->fd);
+	}
 
 	free(region);
 }
-- 
2.37.0.rc0.161.g10f37bed90-goog

