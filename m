Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4116F5BBAC7
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 23:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiIQV6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Sep 2022 17:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiIQV6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Sep 2022 17:58:38 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1822717E
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 14:58:35 -0700 (PDT)
Date:   Sat, 17 Sep 2022 21:58:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663451913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QUp4s6kylqCS1H/Wwh67THvWSkQ9J4fPMiM8DGd2CMU=;
        b=kSvZF+wyXB4j5CEkEMnUcYygpmU0FUKxkZuYviVAby65ZmStqnwNe3yyeB9jkwSyOVYytK
        onFI1ZdlVuEK0AaRX8CQo0+iuizzTE6eaRy1BuhG1S79vn1UHXE7FE8ht9H5Dje+VB/X1G
        JBNMS5cfjSIAqzA+9c5Nergx9qdmM2w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v6 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YyZDBIQsux1g97zl@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-10-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220906180930.230218-10-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 06:09:26PM +0000, Ricardo Koller wrote:
> Add a new test for stage 2 faults when using different combinations of
> guest accesses (e.g., write, S1PTW), backing source type (e.g., anon)
> and types of faults (e.g., read on hugetlbfs with a hole). The next
> commits will add different handling methods and more faults (e.g., uffd
> and dirty logging). This first commit starts by adding two sanity checks
> for all types of accesses: AF setting by the hw, and accessing memslots
> with holes.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Hey Ricardo,

You'll need to update .gitignore for this patch. Additionally, building
this test throws the following compiler warning:

In function ‘load_exec_code_for_test’,
    inlined from ‘run_test’ at aarch64/page_fault_test.c:745:2:
aarch64/page_fault_test.c:545:9: warning: array subscript ‘long unsigned int[0]’ is partly outside array bounds of ‘unsigned char[1]’ [-Warray-bounds]
  545 |         memcpy(code, c, 8);
      |         ^~~~~~~~~~~~~~~~~~

I've fixed both of these in the appended diff, feel free to squash.

--
Thanks,
Oliver

From 0a5d3710b9043ae8fe5a9d7cc48eb854d1b7b746 Mon Sep 17 00:00:00 2001
From: Oliver Upton <oliver.upton@linux.dev>
Date: Sat, 17 Sep 2022 21:38:11 +0000
Subject: [PATCH] fixup! KVM: selftests: aarch64: Add aarch64/page_fault_test

---
 tools/testing/selftests/kvm/.gitignore               |  1 +
 .../testing/selftests/kvm/aarch64/page_fault_test.c  | 12 +++---------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index d625a3f83780..7a9022cfa033 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -3,6 +3,7 @@
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
 /aarch64/hypercalls
+/aarch64/page_fault_test
 /aarch64/psci_test
 /aarch64/vcpu_width_config
 /aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 60a6a8a45fa4..5ef2a7b941ec 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -512,7 +512,7 @@ void fail_vcpu_run_mmio_no_syndrome_handler(int ret)
 	events.fail_vcpu_runs += 1;
 }
 
-extern unsigned char __exec_test;
+extern uint64_t __exec_test;
 
 void noinline __return_0x77(void)
 {
@@ -526,7 +526,7 @@ void noinline __return_0x77(void)
  */
 static void load_exec_code_for_test(struct kvm_vm *vm)
 {
-	uint64_t *code, *c;
+	uint64_t *code;
 	struct userspace_mem_region *region;
 	void *hva;
 
@@ -536,13 +536,7 @@ static void load_exec_code_for_test(struct kvm_vm *vm)
 	assert(TEST_EXEC_GVA - TEST_GVA);
 	code = hva + 8;
 
-	/*
-	 * We need the cast to be separate in order for the compiler to not
-	 * complain with: "‘memcpy’ forming offset [1, 7] is out of the bounds
-	 * [0, 1] of object ‘__exec_test’ with type ‘unsigned char’"
-	 */
-	c = (uint64_t *)&__exec_test;
-	memcpy(code, c, 8);
+	*code = __exec_test;
 }
 
 static void setup_abort_handlers(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-- 
2.37.3.968.ga6b4b080e4-goog

