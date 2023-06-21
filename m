Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84788738DC0
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 19:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjFURvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 13:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjFURur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 13:50:47 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F22212D
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 10:50:31 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id ca18e2360f4ac-77e2c123e8aso472034539f.1
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 10:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687369830; x=1689961830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kpR1MspLCCKbLGu542rFrU99snL12qe0SU5vnENHbnc=;
        b=obkQNETduI4Wdlr8DqbH6rQDpqF2mUi0lafiiZR1QXrNN2+tKemED10KMGrakG13Nq
         +F9e7JIuRjiRR9EfoJnua+9jPsENy4Tu90Vrn/2nK11OMp8Aj/golURDqyPfJ94Cfrxi
         hdWdLoNiohD/PMMDEG0mtQHMd7A92j4tIxNPh8D/cM9gYPH0WwqnOU4OcPsZKdr9HTOs
         pyGKjpe6+P6Xcb6ByP94N+J+yZmYDJogpjw8kcjVcP5B1YTqtAJdqi8Hp9kutYXKuAUx
         OCxMudA25zodKFZSyAwbz9vLyvHyzcqnxGuKjUldsdPVjyx7x6uGCQbzc3ZzHDMDOM0D
         Kg8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687369830; x=1689961830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kpR1MspLCCKbLGu542rFrU99snL12qe0SU5vnENHbnc=;
        b=YqtSideJdKeiJN+V+tDXhM6Z4kQDGLIF44pxJS1NiEFiwXdfw7uJO+Ho4c9Ri1k2qL
         SMrJGHqelm1pqrBP0z7lQ3HugraFaccD7Ow+GTZkVE8cdxoC05TylMQ7G4QB42RlaE/R
         hpF5F2ql7Ax3d+es0XCk77siQ5vfHyIU0lLxQbOFbwOWgxQaBZXOfvn5vdDVyF+4Okgm
         ZLylUqkHWFgEd37H3F6L5u1xiIQOXYfTWXsyaYLag7kUvhNjD9YVWNxLLth4cUZv+gdn
         b7KMN7jxRtKNeLwcxrQyyjp1OaJZmCWbGTvMhVcm/IQ10vIwFjfQSALhHiAVugK75JIS
         v0xg==
X-Gm-Message-State: AC+VfDwUYjQl5OFUWzR3UFAq20hbto4rXKVfj/8/rslxWwAeeZB+rgM/
        bKyZYGPj+A4kxGTGo6bV/Ss3n/4vYQn7
X-Google-Smtp-Source: ACHHUZ6lEejYkvXSZImNPgkcjtxASyr0tUJRYFuyzfo7eVoPr61PQ+mo3lAqnIjMYGuKsT4NfkEe3+3Un922
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6602:152:b0:777:b38d:2333 with SMTP id
 v18-20020a056602015200b00777b38d2333mr5713635iot.3.1687369830330; Wed, 21 Jun
 2023 10:50:30 -0700 (PDT)
Date:   Wed, 21 Jun 2023 17:50:00 +0000
In-Reply-To: <20230621175002.2832640-1-rananta@google.com>
Mime-Version: 1.0
References: <20230621175002.2832640-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230621175002.2832640-10-rananta@google.com>
Subject: [RESEND PATCH v5 09/11] KVM: arm64: Flush only the memslot after write-protect
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
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
index c3ec2141c3284..94f10e670c100 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -992,7 +992,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 	write_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs(kvm);
+	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 /**
-- 
2.41.0.162.gfafddb0af9-goog

