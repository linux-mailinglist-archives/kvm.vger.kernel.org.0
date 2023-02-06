Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E8B68C494
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 18:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjBFRYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 12:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjBFRYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 12:24:05 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3872BED9
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 09:23:53 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id y22-20020a5d94d6000000b007076e06ba3dso7381786ior.20
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 09:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vuXcpW5hhZycWwjy1Q114Q+HT3FS23f7QbM5HtQY0Fg=;
        b=feKShA/7o9prxIHFhpNnY77ILQUPvgtpZXRk79I3iz0pxZR4XUQSXtxjBLVH+THqDa
         vcSpwZXazMbkumYlUMJRFzZWGBKqZxy7sElr6nYZ7v3kuQZaK1Z1KxDj01LfMeyT7mH3
         6w5A5L2SljnoZgGQsrKJrYCohxcM9xKdu/qZvXTVBpE+tK6GENFkgHYRaOgTsMix1n7e
         uJzgmgooIUCuCP9t9WrcP10nQ2l9L6DGY3FMMbeO+6zNOmAis/kijSg7NFTZvj06P9+8
         3BYpx3rzb2M0cUf0XIK3hGqrmehOJ8k5To3ZsQgGGxqTYW0tVAT0h8grc9edvmNMe+Yw
         uq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vuXcpW5hhZycWwjy1Q114Q+HT3FS23f7QbM5HtQY0Fg=;
        b=ZKv/1rEv4RXO8pxV5ilI3Ik8PjNZLLrayu4hXbBqHHIOaYLSjOSBZlmiFrbVmRL+2G
         MIaP2QuyvvdZgXgvvxoV5VKRgstrekCwniumUCFuCVjK+lZArjlVKcdXtnoziBlE4UT9
         MC2bJ6IAYblI1sTd6ZD3DD1g5aDBoFulbs5sE91/G2IdtUP0NsChuGJzaRbG0dlX9sIx
         sLxmgFaBcYaD8wqW/8dfd1Gj+2uMP9EHhctu8O6tvqbb2iH9oBdVfXD4VieIpvOrBwHj
         i9zr/NrJRIfEI7YCxFgcsnnjmcpGM0tw/8w5Ve0PksnAMhtpbd1MR4aom+3ve8YlxskQ
         PN7A==
X-Gm-Message-State: AO0yUKVVJw+r4GMUOtQqDyFElSZnuGJ+TFSAHjq9uNADoSHlrd2uyow/
        119d8ysKXZfmKWLC+B05Y9Kdm6i66LaG
X-Google-Smtp-Source: AK7set9A/bA5zzEfudk7dWL6RltnEMvURxG1hIJY97EY9SyVcwzO2bKsvygC60t64GkBOI+dM2FgiOiM83Q+
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6602:398e:b0:704:dad2:863d with SMTP
 id bw14-20020a056602398e00b00704dad2863dmr3973430iob.60.1675704232681; Mon,
 06 Feb 2023 09:23:52 -0800 (PST)
Date:   Mon,  6 Feb 2023 17:23:38 +0000
In-Reply-To: <20230206172340.2639971-1-rananta@google.com>
Mime-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206172340.2639971-6-rananta@google.com>
Subject: [PATCH v2 5/7] KVM: arm64: Flush only the memslot after write-protect
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After write-protecting the region, currently KVM invalidates
the entire TLB entries using kvm_flush_remote_tlbs(). Instead,
scope the invalidation only to the targeted memslot. If
supported, the architecture would use the range-based TLBI
instructions to flush the memslot or else fallback to flushing
all of the TLBs.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 409cb187f4911..3e33af0daf1d3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -981,7 +981,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 	write_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs(kvm);
+	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 /**
-- 
2.39.1.519.gcb327c4b5f-goog

