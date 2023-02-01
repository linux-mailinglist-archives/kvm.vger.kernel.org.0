Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD07686F21
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 20:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbjBAToe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 14:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbjBATo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 14:44:29 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56A67D2BD
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 11:44:28 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id m2so54177195ejb.8
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 11:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2E5YMmSOIqZe/jnf+n11QdKNSwd3QkONdPmR1/5wHHU=;
        b=dN6uhAsKaM6VDdtUOahHFzOhYO0AzcwTuctDdbSBi1eK7+SJZo9eHgYPeHkXfTqYXM
         jFGUyi6ConRUKTp/znJ+WnsVXoR8yHvTEM9JJt/hz5C4/Hi16zD1lVck944gFlUofPyA
         X4LxeoB7DxASdjidq8sq/Aw9rQKVqp8uRZIspm/O2CSouFTY0go1AI3HK6vy4ZNjnfeh
         C3BKsRtassll4W9+PjLg6hklei4tWVPFFoChPdCsl8zxVIycdYQAQE6iZ5qxqgKsBpnS
         AoBvG6UClRQ3ZoCpCwcOwIxtk2ViC8B6QPuFmDUxCtBE4h9vlap6TJAXndDECJckgs75
         ynKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2E5YMmSOIqZe/jnf+n11QdKNSwd3QkONdPmR1/5wHHU=;
        b=VZljZiT7yP3RVAbuvLhZyS8OW5l36H3IxrWwlCneX3MiDyXgaLi+wIOTBJv+C0xP1z
         xrZ4Qgxw1FidR/HqRHN73LT3ZLr+OLXrqSSe6sC6UYQnYj5zG/cCY10Qs0f9FEjSck5+
         ZtMczRjT/HYCCP4uCeXV1rUILdvjRUcJr0rSescG0fxY6HUM3pKgJv/iB+sseoC7cCWV
         nQBj6klmld9e6ClobnbQYrC+JSRU/Zwt3EGPjKBvnpey2JpQGDEceffmi+x/LFqqJgwM
         I7crnKnwsv3WH96OJDpq0xWN9c4T5rOrFa6zJWHa493NhdE83Bxcybr98V1AGe5XU/Z6
         nBHQ==
X-Gm-Message-State: AO0yUKWyde2BLyr9JxkJ5dLPC87L14ThzE7u3qy4SE64F6/s/Nz3e9Mg
        f4/E8c1MVx7xGPawnZDFxuHtUrkh7X6077zKZio=
X-Google-Smtp-Source: AK7set+NXo9TG0IVeGQsdO6K2ylckwuZ/VPruLUn8EfGOGIBcpGHMzEq3mWOaJq14cXbn3rYN1VB0g==
X-Received: by 2002:a17:907:2d28:b0:88e:682e:3a9e with SMTP id gs40-20020a1709072d2800b0088e682e3a9emr2765126ejc.61.1675280667157;
        Wed, 01 Feb 2023 11:44:27 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af111a00277482c051eca183.dip0.t-ipconnect.de. [2003:f6:af11:1a00:2774:82c0:51ec:a183])
        by smtp.gmail.com with ESMTPSA id c23-20020a170906155700b00869f2ca6a87sm10397579ejd.135.2023.02.01.11.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 11:44:26 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v3 3/6] KVM: x86: Do not unload MMU roots when only toggling CR0.WP
Date:   Wed,  1 Feb 2023 20:46:01 +0100
Message-Id: <20230201194604.11135-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230201194604.11135-1-minipli@grsecurity.net>
References: <20230201194604.11135-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need to unload the MMU roots for a direct MMU role when only
CR0.WP has changed -- the paging structures are still valid, only the
permission bitmap needs to be updated.

One heavy user of toggling CR0.WP is grsecurity's KERNEXEC feature to
implement kernel W^X.

The optimization brings a huge performance gain for this case as the
following micro-benchmark running 'ssdd 10 50000' from rt-tests[1] on a
grsecurity L1 VM shows (runtime in seconds, lower is better):

                       legacy     TDP    shadow
kvm.git/queue          11.55s   13.91s    75.2s
kvm.git/queue+patch     7.32s    7.31s    74.6s

For legacy MMU this is ~36% faster, for TTP MMU even ~47% faster. Also
TDP and legacy MMU now both have around the same runtime which vanishes
the need to disable TDP MMU for grsecurity.

Shadow MMU sees no measurable difference and is still slow, as expected.

[1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
v2: handle the CR0.WP case directly in kvm_post_set_cr0() and only for
the direct MMU role -- Sean

I re-ran the benchmark and it's even faster than with my patch, as the
critical path is now the first one handled and is now inline. Thanks a
lot for the suggestion, Sean!

 arch/x86/kvm/x86.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 508074e47bc0..f09bfc0a3cc1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -902,6 +902,15 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
 
 void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
 {
+	/*
+	 * Toggling just CR0.WP doesn't invalidate page tables per se, only the
+	 * permission bits.
+	 */
+	if (vcpu->arch.mmu->root_role.direct && (cr0 ^ old_cr0) == X86_CR0_WP) {
+		kvm_init_mmu(vcpu);
+		return;
+	}
+
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
 		kvm_clear_async_pf_completion_queue(vcpu);
 		kvm_async_pf_hash_reset(vcpu);
-- 
2.39.1

