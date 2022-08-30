Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5475A6DA1
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiH3Tmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiH3Tmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:42:38 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558BB7AC32;
        Tue, 30 Aug 2022 12:42:19 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661888538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQeI6zpamXufaG6UtIBPMTAxGRkDzaVjmSqbL7fqmA4=;
        b=D9h9JwBXgp4fk3oXEgNrHS+gL2418x+oOQGDIhu15jN7Y5D9JRtyE3eEsyuBeRj9CrBaD2
        A90lb39Q6XzojxcGyb2Go/11MI9HEgqpfAGScUJOzE/yMG2o6XrcZg782/2VeGVGKzCubS
        V8ZWLLP9SU9I0vP7yG914m7jhzl30+0=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] KVM: arm64: Document behavior of pgtable visitor callback
Date:   Tue, 30 Aug 2022 19:41:25 +0000
Message-Id: <20220830194132.962932-8-oliver.upton@linux.dev>
In-Reply-To: <20220830194132.962932-1-oliver.upton@linux.dev>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,SUBJECT_DRUG_GAP_L,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The argument list to kvm_pgtable_visitor_fn_t has gotten rather long.
Additionally, @old serves as both an input and output parameter, which
isn't easily discerned from the declaration alone.

Document the meaning of the visitor callback arguments and the
conditions under which @old was written to.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 47920ae3f7e7..78fbb7be1af6 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -194,6 +194,22 @@ enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 };
 
+/**
+ * kvm_pgtable_visitor_fn_t - Page table traversal callback for visiting a PTE.
+ * @addr:	Input address (IA) mapped by the PTE.
+ * @end:	IA corresponding to the end of the page table traversal range.
+ * @ptep:	Pointer to the PTE.
+ * @old:	Value of the PTE observed by the visitor. Also used as an output
+ *		parameter for returning the new PTE value.
+ * @flag:	Flag identifying the entry type visited.
+ * @arg:	Argument passed to the callback function.
+ *
+ * Callback function signature invoked during page table traversal. Optionally
+ * returns the new value of the PTE via @old if the new value requires further
+ * traversal (i.e. installing a new table).
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
 typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
 					kvm_pte_t *ptep, kvm_pte_t *old,
 					enum kvm_pgtable_walk_flags flag,
-- 
2.37.2.672.g94769d06f0-goog

