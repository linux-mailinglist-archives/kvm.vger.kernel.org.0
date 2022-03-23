Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744144E5B80
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 23:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241410AbiCWWzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 18:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345331AbiCWWzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 18:55:48 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F59B8D681
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:18 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 138-20020a621690000000b004fa807ac59aso1646935pfw.19
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RQZ9oTCQlO2kkOxWGWPVIC9nBisyNLoKeQuBeACdbVQ=;
        b=p+g7bWwB50EB/w3hkgA0rVNT57FGibDrrLJK/XlvKLVxecBZRbJrvIbXJ+jcvXAkzn
         S1Ze9G7u8gofjR6Kp6iU/N1kcmwr6vx4FewGe8GM9o6xh5Ixh5kUqRrEYob4wRf9NtBL
         4Dv/9xTXxLXO61IseJp55nta5dXslqhiINmTaykUsTyh75+6wK1aw0BDi5hMhMh2Mzmj
         uCq6mZhZUl4qxzzojSU6UU1eioFrn9aWOO/MbqlItHvp78eaOO7o9GOctz6iLmCFOnx6
         W0vtrPT9wQpToA7Vu1IysUe8y7nqgNr03LQmZKjtFIZlbAuxiXzehToAeivCsGyDUMuZ
         alXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RQZ9oTCQlO2kkOxWGWPVIC9nBisyNLoKeQuBeACdbVQ=;
        b=7gSDhzcHbkyjNadbCyFBWnM6NXYqajnU12tFFFUoq+0kIv0pCsF0AewcvVczhDLW5C
         8tSYLDEi3UsNPfPrWU5FWo/A0KCO9WinMQt6xNgND9CpGAHkBEPgUlBZEbA8ToG4wZWG
         WOH3zUULmEVu6UJeMUzowHFtWjhF3zcILKMd1cIEmR3pZtRBnUhLCgVpPqMs3A0fmG8o
         fxPwd+S7q6Zc7nSCdWEjrL7W5FBx/TqeJHUP5UFPFi2S9kjDu71+UwXCJn++6jIbJMFR
         Yn+6R8YiJSt4wQCCy4iijV26/GQW7zgHBQUniUGGFQpBLc5x1jo98vLWucURxXNMM1pW
         2qkg==
X-Gm-Message-State: AOAM533j7A7sIL5FZyATiyBHQrqbkr7vLc0RRVzn2mzkfEH/7I4DF3Pu
        HegQ/761L3dJaIyO88enUcibGtZ4N+4eJ8oqiSynRfqcB41lOwEpYHiWoX/Nk7JS2waZBDbbiZj
        N+mErykfsS91HcsJzVdcAKqmptHL0HYcnkPTXQOrzBmq1n95rfMgjHP1w7+RsbxA=
X-Google-Smtp-Source: ABdhPJzZggTEZsz9VHBBQHG8G2jPGTIF3aQKjvOX95a74j+hsAPzoyo4bO9e+VNMfrpeBTP6J5d5Gh+F73mgOw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a63:6c01:0:b0:37c:73a0:a175 with SMTP id
 h1-20020a636c01000000b0037c73a0a175mr1622779pgc.415.1648076057479; Wed, 23
 Mar 2022 15:54:17 -0700 (PDT)
Date:   Wed, 23 Mar 2022 15:53:59 -0700
In-Reply-To: <20220323225405.267155-1-ricarkol@google.com>
Message-Id: <20220323225405.267155-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20220323225405.267155-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 05/11] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete
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

Deleting a memslot (when freeing a VM) is not closing the backing fd,
nor it's unmapping the alias mapping. Fix by adding the missing close
and munmap.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e18f1c93e4b4..268ad3d75fe2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -679,6 +679,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
+	if (region->fd >= 0) {
+		/* There's an extra map shen using shared memory. */
+		ret = munmap(region->mmap_alias, region->mmap_size);
+		TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
+		close(region->fd);
+	}
 
 	free(region);
 }
-- 
2.35.1.894.gb6a874cedc-goog

