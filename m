Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF515AF34C
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 20:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiIFSJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 14:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIFSJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 14:09:41 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0696521E31
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 11:09:41 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3451e7b0234so58682737b3.23
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 11:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=Y+OPxQ5AWFMtnU0dHjjR3+DOg2GIHj7/VBS3FzZlKj0=;
        b=kN8zzv7uiZEn8zwiQPHFwI8t63lHXUuE8j8u79e7MDqO/PYCyCdjx3uq2JwQT2YMA8
         vr49Vw4PR1tiDGjrfMp4SuYE+8PyKDoO2sWdl3Tbs/mZ683Ox6Q812fCImU83PN2B1QT
         PqQ9w7fXuY/VzfpM1hvi4JJ98op2j7fPdVVbzVj2OoufLWSXyYhu+F2bcuaebYVVLqCI
         R/b7rIa/UhFWjIQqoMxxookySHSMoDfE7Xy0tJpke5tQQy2AnSEQyu+mAwEmwmGTtN4j
         YtFumVaGUpvJY48IJL/HMethavHUcah9UExsZ41xwaJXxOxNysutwu7qz1d11SS05KUR
         9mQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=Y+OPxQ5AWFMtnU0dHjjR3+DOg2GIHj7/VBS3FzZlKj0=;
        b=qHHlylzHzYw4fMNn7KLGXlEuGGIVz63htH8g7C06Hhe3KJIqwAls2qhJtwkp0forbI
         Ze0j7CFtmD/dZfvRx6t51GDZogChzcEPf9Rm0xEwJhAeO400EIB4Fd+hyJdotQcf9aTS
         WUBb4JGpicTpPG7OczUoZF4eUEZv9lVnO6ZcQ95Bmltf372DCIlLgiCdmajAr9hcXQZm
         chH7xi1LLp4JJmpDqVeMdPL568nBFvuQoFzZ2ZIoF3vGoVeQee7ellL88oQQ+DUsE9p2
         uW0NSz6SYzag9SrJow7HpSk90RTqf3Vf2aSr/L+eqasLgx1x0L7aV1SJ2FbQoyGPuIHx
         cafg==
X-Gm-Message-State: ACgBeo2t521UcE0JFXEXWjeQ3qJ3dcxn+J/PShPZNlyZ70iFsyOB34G4
        j2hDNZPwIrLYGwxIvc/Ym/8adtNjw5JuagYTIurZQqc72joFVp4ba/5DnzBhbGjrzDd5ZZNu9eG
        iHUINt6V/lJKsX/9AR4qzvsnIhf5VhHAFlbDWdXHJ0nsdZL1EGK9LlEFZuWwiZBs=
X-Google-Smtp-Source: AA6agR4ySKWHnI41ZN/mG2ne0AGMDwf5L2OJtYAPLM0Rb3A+J+MVOfmECZFXwRPRqhGuYpuf0MM5DeqYIehqpw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:c986:0:b0:325:1b81:9f77 with SMTP id
 l128-20020a0dc986000000b003251b819f77mr41841979ywd.182.1662487780294; Tue, 06
 Sep 2022 11:09:40 -0700 (PDT)
Date:   Tue,  6 Sep 2022 18:09:20 +0000
In-Reply-To: <20220906180930.230218-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220906180930.230218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906180930.230218-4-ricarkol@google.com>
Subject: [PATCH v6 03/13] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
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

Deleting a memslot (when freeing a VM) is not closing the backing fd,
nor it's unmapping the alias mapping. Fix by adding the missing close
and munmap.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..9dd03eda2eb9 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -544,6 +544,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
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
2.37.2.789.g6183377224-goog

