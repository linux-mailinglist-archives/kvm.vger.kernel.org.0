Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D31F4EF93A
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350608AbiDAR6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350629AbiDAR5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:57:53 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4281834D4
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:02 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s188-20020a6377c5000000b003825c503580so2004746pgc.13
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IZRim+LrWsbKLhWGtCJAPIUqsiasbKStOmO5lLjRFP8=;
        b=OZ/CKz/kS7tsC+5ET9TAryRE1kCwgOMM6JGu+otu2+fefVt4XEH8bXii6Cm3AUtLCN
         Gw9osJsofH3J6mv+Pa2qF4AgPyuVpqfC38Nn1tKiG+M3EKrlbdGH2QPh3j9eewzu59lx
         ICuKCxkiGaO+YeoyVNcW7Nro8EgWUt56TC8bmJ6E3nLjN6WPFH2wT9SX/X9xZP2ZiF17
         FJmRQTr/BPkOe9FVzGO8FNFlXg4UfuMC8jzLYVLEELEQwUE4jThW/O/paupXC7lWuxy1
         jJcoNEaCMLN9riLuRhRPnUtblhKer7FLcbWvKt2OPcW3oc7aFw2S1ONaKDFn48FfppNp
         IR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IZRim+LrWsbKLhWGtCJAPIUqsiasbKStOmO5lLjRFP8=;
        b=VKC3o4j7Uwvtucv9hGYpwLzRNri9m6YsWbk4zs7/HkR8GB5zEKY3ZsY0527xaqmxMZ
         4oawCdIer9cH2Q/o/aWCFogDnyHZmtv8wobr1ThW6N+YKCmIIzb12lzSFp5+i33M4i1L
         EN96iKJ5Cea/yE9Umf+ssvZnRcHwdE18na7p+nE2OsvzwYYnOiBd4vxfG3W0oPqOFG0D
         rfv7ScUCTfw2zDboSWnc/iZC6iGkvr3Abvr2oGUKpwGT2R5SpXP7udRRPgX21L15xPd6
         JQZCvCaB0Yds4whiNihcBzMiGi6AfZiUUDNRQZqtyNs9GA7V0SJBvJF6bqrOJ0ovQh8T
         5XPg==
X-Gm-Message-State: AOAM533Sg00VNYGvNq3Wr5GiUt92vHZKrOPEnzSkHQtFVApFuvHw4UwM
        Ejnvk51qnq9DZUCAxySrI4+8Ejc8iokUMg==
X-Google-Smtp-Source: ABdhPJw5vwbBPjHYSVeggYwsZsRSNlx5RqVJMTrxoIjsNKWoBtog3ECYJyqS377WsBTJdAeMsxOsjt/Joc7/Ug==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:6403:0:b0:4fa:c74c:83c5 with SMTP id
 y3-20020a626403000000b004fac74c83c5mr11997208pfb.30.1648835762419; Fri, 01
 Apr 2022 10:56:02 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:32 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 01/23] KVM: x86/mmu: Optimize MMU page cache lookup for all
 direct SPs
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        David Matlack <dmatlack@google.com>
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

Commit fb58a9c345f6 ("KVM: x86/mmu: Optimize MMU page cache lookup for
fully direct MMUs") skipped the unsync checks and write flood clearing
for full direct MMUs. We can extend this further to skip the checks for
all direct shadow pages. Direct shadow pages in indirect MMUs (i.e.
shadow paging) are used when shadowing a guest huge page with smaller
pages. Such direct shadow pages, like their counterparts in fully direct
MMUs, are never marked unsynced or have a non-zero write-flooding count.

Checking sp->role.direct also generates better code than checking
direct_map because, due to register pressure, direct_map has to get
shoved onto the stack and then pulled back off.

No functional change intended.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1361eb4599b4..dbfda133adbe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2034,7 +2034,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     int direct,
 					     unsigned int access)
 {
-	bool direct_mmu = vcpu->arch.mmu->direct_map;
 	union kvm_mmu_page_role role;
 	struct hlist_head *sp_list;
 	unsigned quadrant;
@@ -2075,7 +2074,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			continue;
 		}
 
-		if (direct_mmu)
+		/* unsync and write-flooding only apply to indirect SPs. */
+		if (sp->role.direct)
 			goto trace_get_page;
 
 		if (sp->unsync) {
-- 
2.35.1.1094.g7c7d902a7c-goog

