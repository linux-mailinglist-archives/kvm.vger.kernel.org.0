Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0EC53C30C
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbiFCAyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241101AbiFCAuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:24 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D3F2ED42
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:37 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u5-20020a17090341c500b0016648422072so1285417ple.8
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BrjMyn6UOGwtIz7DDGBy5Pr7ixuSSx4pzqxP/WjUvpg=;
        b=ls4moDLUsT44nSRyZwv+GbGgLQmDufXHa/fMAqmFfeHCkhU3T63EaZq6nq+SGpeAPD
         3FQImgJFIEGzWuCAKYdLLJ/or38qceUZn22OzSBotbLwLtAb1q9IQXZ2AAl0kVe4w/9I
         Wgdj6AGpYV6xg60tABhHeC4pUiI9UJCsaS7PC5rzJtwBlZHUg8vrymN2rWgTY+YilXG2
         iAPQXuXvrd2fyf4hDOcVmtYcSVoIKldxC73ODI8kpbWMFbKBCYdtlFypraHtFZHWhCrg
         sLlgFXVc4+ZnDLSYhen7uGiViE5RknfYM5mjocDmAROxYL2H5bgUYvLssw+zzTMMqhYc
         s1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BrjMyn6UOGwtIz7DDGBy5Pr7ixuSSx4pzqxP/WjUvpg=;
        b=Hi882M4n8WnPGA6j0NEmkPfWoRlKpLw3n3gmAoaUGtXcGenXiAz/bXGG1b221t+7ee
         kyxFbA6dUmAdfPA7SJVvb15nEzpozYtx/+GN2GcXMTWIN6AlB0Igghjrmg7qzKdfNPgr
         axpLp1/45mpnj5nTah7OzbBJggcKr1QOp9wX76RublTEyMG2imHEftOfZtaXW0CUToh2
         2QgmDHVlekhf6OAb/Q7AiKGuhMeY0MUKV+L3Jak8Uhz6ktZHxBWwtBBwuV1HjibpBgde
         z+GrQ8zfyv6dRM1arwLi4rZVKurEq3OeUb3JJ9kOOE/JMr/yIt/1or6Y41dkYdY1dRZg
         Z7fQ==
X-Gm-Message-State: AOAM533qwdcSNCmTK2DB/gplWYyvnqLPm+x/5iTMrQbeRCywTIB/NzUS
        H5tzTgKqFSkT6p0g7yMP+vvRCUbABTg=
X-Google-Smtp-Source: ABdhPJz4fBpNAWEDph89ezfjs34+rAvq9PrcFCLjqp23S+Xf4PXagSLiQP9GrUfjN/n9pHc475T1OJvN8Qo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr307332pje.0.1654217256913; Thu, 02 Jun
 2022 17:47:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:20 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-134-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 133/144] KVM: selftests: Drop vcpu_get(), rename
 vcpu_find() => vcpu_exists()
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop vcpu_get() and rename vcpu_find() to vcpu_exists() to make it that
much harder for a test to give meaning to a vCPU ID.  I.e. force tests to
capture a vCPU when the vCPU is created.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  2 --
 tools/testing/selftests/kvm/lib/kvm_util.c    | 34 +++++++------------
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 640634bdba9a..2da9db060378 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -93,8 +93,6 @@ struct kvm_vm {
 			continue;			\
 		else
 
-struct kvm_vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpu_id);
-
 struct userspace_mem_region *
 memslot2region(struct kvm_vm *vm, uint32_t memslot);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e08e89174610..8775d7ab39c8 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -459,26 +459,6 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 	return &region->region;
 }
 
-static struct kvm_vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpu_id)
-{
-	struct kvm_vcpu *vcpu;
-
-	list_for_each_entry(vcpu, &vm->vcpus, list) {
-		if (vcpu->id == vcpu_id)
-			return vcpu;
-	}
-
-	return NULL;
-}
-
-struct kvm_vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpu_id)
-{
-	struct kvm_vcpu *vcpu = vcpu_find(vm, vcpu_id);
-
-	TEST_ASSERT(vcpu, "vCPU %d does not exist", vcpu_id);
-	return vcpu;
-}
-
 /*
  * VM VCPU Remove
  *
@@ -1049,6 +1029,18 @@ static int vcpu_mmap_sz(void)
 	return ret;
 }
 
+static bool vcpu_exists(struct kvm_vm *vm, uint32_t vcpu_id)
+{
+	struct kvm_vcpu *vcpu;
+
+	list_for_each_entry(vcpu, &vm->vcpus, list) {
+		if (vcpu->id == vcpu_id)
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Adds a virtual CPU to the VM specified by vm with the ID given by vcpu_id.
  * No additional vCPU setup is done.  Returns the vCPU.
@@ -1058,7 +1050,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	struct kvm_vcpu *vcpu;
 
 	/* Confirm a vcpu with the specified id doesn't already exist. */
-	TEST_ASSERT(!vcpu_find(vm, vcpu_id), "vCPU%d already exists\n", vcpu_id);
+	TEST_ASSERT(!vcpu_exists(vm, vcpu_id), "vCPU%d already exists\n", vcpu_id);
 
 	/* Allocate and initialize new vcpu structure. */
 	vcpu = calloc(1, sizeof(*vcpu));
-- 
2.36.1.255.ge46751e96f-goog

