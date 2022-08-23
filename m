Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7562559EFEA
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 01:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiHWXrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 19:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiHWXrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 19:47:39 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150DA8B2C1
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:47:38 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3360c0f0583so263166097b3.2
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=7GdMmXimiZ4YWrwJpImAuE2Hv/nIHXwvZnlXjRcc/Ng=;
        b=U50s677MuXtHCA+m91knSsMiooIAUVYZ1qG5V8w4MZHNwAzh/1qjoz/1WZ2I30aieX
         Ud5aPr/Q0WD2gs6vc32nZjVfDIwwE8UcXp5zn52cbr6aR+6qdjDjofpcCiOCA5VTPUGO
         Y620V036bl+U35DOe9ACtyBfcKsKQ+20ljhSCkF7/6593InGuJa4oLhzsG1AFWyUlzLy
         1sjCh6i7YqeRUuaZzEzfnX5ogqUcMo9ZWdYGVTFAeV1uZOTXIuyQaBdqMhHrnJc8X6df
         QNOrRObf28q4PaPX3JDubRbZEOzU4NUjvkSJNgqHvne8+3QDN7dSBEl+weJAX9lR5Mmm
         DbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=7GdMmXimiZ4YWrwJpImAuE2Hv/nIHXwvZnlXjRcc/Ng=;
        b=KUNUTj/5t1e258PIKawo2RKRJTb+44+DION+4MEcQ2D0J1YsORsqSgHw9S2HIjY7gP
         aIZ9L6izFmQJqHdstGLDmzzMgWZORO7Kj2IsyceG3aOtYblMJPine+mQ7a2AQdVEhzWb
         bzUq4vWgM+umZNMTaA2rLgltEy7XOpvU+6cIkMTbPUWaYG2dtNbmEoJnFK+5pzAVRE9D
         N8TmecmY+giTPz1abYnabDHctMzLQl7cy9zKFoJoC45Fjnth2ySL0/2BG2XGHeEt5PLD
         RUEyPHJN1ochCu2NG4epWRXJR1oGP6Nr9ExWQlMwwQ2bFo6ZkexH7x1zfGJbvOqCqjHG
         ch8A==
X-Gm-Message-State: ACgBeo3P6aBvMGzV+M3WDlgP8fBfsoRKsusG5HnO4wDaLsgrg3FlY+Ay
        AXcaE5sBNS2VYIHIwrTMvPNAskzJiC4Mq2SXLMQWNQBWUI1Z6XeeZCkJpX4JZVL8UQfV9xailvL
        gsS/Y5Thwyon1OS77y4mnGyY9HinKFLsioG83Es4ZubhZXeK2w2wKlQckz2y5KwQ=
X-Google-Smtp-Source: AA6agR7swNIj54jtNeww5gCy36Djcb8X4Yhe0prRsiQoWTaTJSOMakGqlqhqIwD1Zd62icVZoFHiY7AnoovWUQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:da83:0:b0:329:9c04:fe6d with SMTP id
 c125-20020a0dda83000000b003299c04fe6dmr28577685ywe.196.1661298457217; Tue, 23
 Aug 2022 16:47:37 -0700 (PDT)
Date:   Tue, 23 Aug 2022 23:47:17 +0000
In-Reply-To: <20220823234727.621535-1-ricarkol@google.com>
Message-Id: <20220823234727.621535-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220823234727.621535-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v5 03/13] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatclack@google.com, axelrasmussen@google.com,
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
2.37.1.595.g718a3a8f04-goog

