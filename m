Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0D054BB75
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357224AbiFNUIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357242AbiFNUIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:08:01 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FBC289A9
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:49 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id s10-20020a170902a50a00b00162359521c9so5325956plq.23
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Ykj31SxfOFF88awQ7WBVcXppu/G/Rsb7kgEzRmofc6c=;
        b=iXs8SlZ/Gv1hD19mtuf0EyxToq1qFW6rDVGnC4cUhGkyCbx3MwuX2GytRoV4b16zO0
         vmc2zJSkPpYFCENu5hvk85RZRyOJKIq5s/2l/6MyqVVZlOJ2x+++uCpEZQjm2mX6UiBk
         hyeAJrXaM8klB3Ig7dE1Feu6Gv8XCAf/LwR0N4tZFJ4ROA3U2RVSX8UDAYdA5wkJi+W1
         7jtb7gjuLLZESMVYheuDH2lZdTTPLjfKvLkHQTBJAk7N2CKk14ERskPC491jcAGdgKzD
         ARhhJSGULNPJ5ztxt8PNUVNCSAAfT0l5EHN+eqU02gKOheSBKAXcwC92QtyMcLXgJlCV
         zyHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Ykj31SxfOFF88awQ7WBVcXppu/G/Rsb7kgEzRmofc6c=;
        b=NubU21yu50RYnhDZDDrTWMq2wQooaz84FJxEVPCl/d42NvzrdceWCy/lWZEgm2LgzY
         XeWwkjnBl5DHdq0G7cM95EElw1AfbFqqz/aPLKzqQgzNDr8Lk5PttcbqpBGW0Znhaiy5
         twsE+IEzrbYNFnb2xI7e9cTLeJAnUDCnwZaGsWal6zYvaWCmKXR5JDlVoxNuazjLmLIP
         iQEDDUZ8e/HlWlltalttyRS6Yi5cs/uZfX5esxhQGUErDBcjwsfbgVc06yvGVKwOjE4E
         /LLaCaeLElCB0NWqtM7t2Kn7ekxzmIKaw6srg9ysbe9hhNPFFx+omQUkX0ltbXM9jw2o
         PSQw==
X-Gm-Message-State: AJIora8g5rvmH18owYjed1w5xX/FqHeZGKNMTWyHfL1PPhhftzB5zHKQ
        VCMYD8XmyYopc5BQjb6y2h25ufFoBfA=
X-Google-Smtp-Source: AGRyM1tGeQ4gZu3n6/g13Y00M7lq3cR5HCq7NIfhUmFJxA2dKTega8bfcNYdMrUrZ781r4DhI/qY32rKyfc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:db06:b0:166:42b5:c827 with SMTP id
 m6-20020a170902db0600b0016642b5c827mr6063116plx.145.1655237268267; Tue, 14
 Jun 2022 13:07:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:45 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-21-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 20/42] KVM: selftests: Rename and tweak get_cpuid() to get_cpuid_entry()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename get_cpuid() to get_cpuid_entry() to better reflect its behavior.
Leave set_cpuid() as is to avoid unnecessary churn, that helper will soon
be removed entirely.

Oppurtunistically tweak the implementation to avoid using a temporary
variable in anticipation of taggin the input @cpuid with "const".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/x86_64/processor.h  |  4 ++--
 tools/testing/selftests/kvm/lib/x86_64/processor.c    | 11 +++++------
 tools/testing/selftests/kvm/x86_64/cpuid_test.c       |  4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 7c14e5ffd515..36c75acd4509 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -692,8 +692,8 @@ void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 /*
  * get_cpuid() - find matching CPUID entry and return pointer to it.
  */
-struct kvm_cpuid_entry2 *get_cpuid(struct kvm_cpuid2 *cpuid, uint32_t function,
-				   uint32_t index);
+struct kvm_cpuid_entry2 *get_cpuid_entry(struct kvm_cpuid2 *cpuid,
+					 uint32_t function, uint32_t index);
 /*
  * set_cpuid() - overwrites a matching cpuid entry with the provided value.
  *		 matches based on ent->function && ent->index. returns true
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 7c0363759864..d4ea5628746c 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1190,16 +1190,15 @@ void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
 	}
 }
 
-struct kvm_cpuid_entry2 *get_cpuid(struct kvm_cpuid2 *cpuid, uint32_t function,
-				   uint32_t index)
+struct kvm_cpuid_entry2 *get_cpuid_entry(struct kvm_cpuid2 *cpuid,
+					 uint32_t function, uint32_t index)
 {
 	int i;
 
 	for (i = 0; i < cpuid->nent; i++) {
-		struct kvm_cpuid_entry2 *cur = &cpuid->entries[i];
-
-		if (cur->function == function && cur->index == index)
-			return cur;
+		if (cpuid->entries[i].function == function &&
+		    cpuid->entries[i].index == index)
+			return &cpuid->entries[i];
 	}
 
 	TEST_FAIL("CPUID function 0x%x index 0x%x not found ", function, index);
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index ca36557646b0..8723d73dcdbd 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -157,7 +157,7 @@ static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 	TEST_ASSERT(!rc, "Setting unmodified CPUID after KVM_RUN failed: %d", rc);
 
 	/* Changing CPU features is forbidden */
-	ent = get_cpuid(cpuid, 0x7, 0);
+	ent = get_cpuid_entry(cpuid, 0x7, 0);
 	ebx = ent->ebx;
 	ent->ebx--;
 	rc = __vcpu_set_cpuid(vcpu);
@@ -165,7 +165,7 @@ static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 	ent->ebx = ebx;
 
 	/* Changing MAXPHYADDR is forbidden */
-	ent = get_cpuid(cpuid, 0x80000008, 0);
+	ent = get_cpuid_entry(cpuid, 0x80000008, 0);
 	eax = ent->eax;
 	x = eax & 0xff;
 	ent->eax = (eax & ~0xffu) | (x - 1);
-- 
2.36.1.476.g0c4daa206d-goog

