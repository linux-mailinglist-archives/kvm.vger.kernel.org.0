Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67E7349FB5
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCZCVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhCZCUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:20:52 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C70AC061761
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:52 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v186so316609ybe.5
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=EpijQ6V8FeVDkD7HX5egdlZ4dc07ENH1xKoxF44zfAY=;
        b=vurensVFR3hrXyY1NMdpbwaru8VIWvzupZGNxIORfKUkaj6cZcAwrW4S7ZbldvFW0e
         1pj7Sjtemz800HdNKoZvFp6F7/aMexhzotPHhhv54wbWGG2b5JKTkMRv9BDbN2E4Ey9T
         8eW4Z03xVOLOX0hzRddgLv1Chs8SDkxnX6z2o6MpxhGggyvr5FcOq858GvWl6ZoPED7P
         ykGFvoJ6wUIWXZYSEL8RaJGkOTiUZy0E1yO+uZS3qT3g2YOPbNYhWH0rLNLhU1rTGhtk
         ls/hhgkUIDYTaauJwhgRarI2uGASQOz/snbsTpI3O7d7JXOpGXiLwzhMRARvAh1o2E/F
         NZog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=EpijQ6V8FeVDkD7HX5egdlZ4dc07ENH1xKoxF44zfAY=;
        b=Jnw0PGF5bL9KivUNojcxWsUaJdBPX0X9DWRx6EzQ1heBhqW3mKKDhM6rf3pEB2Z2WT
         LKHTVifMmH61s5XIH+YcetLJnPhR6qseaEe5R5kgKwH2Z5Gfoolq4oWCB4ZTKjOhuM0T
         aKZYZmfcHqHkGluInyuZuncEgvINEkBINUP5fv+EEZ+x+3GgGN6W2qvu5daZZJYlbA1l
         GdwvCzGRFSxNLUoV5BmtQY8Scd06uHTZpMlgF6H3Ljq2xuwaeBKTgSFkpeQ9dD9Mpwx3
         vXilUz7yChqOsP+FaqrhuHe2zrraqPmgPWlrBfvo9/vfTSizcSvKFAYh4bRDAHtmd5rG
         hTEg==
X-Gm-Message-State: AOAM533LMwNWEro5MMzxR6EmlBJ4bxMHm+8yiK3aikv6qxztMCgv3JWs
        RvKdB55rTgLbmZqNPgEe9wEPMp6YKYs=
X-Google-Smtp-Source: ABdhPJzbNsIM618ZsZ/2M+kNXws+VM2rkDgsqZ/Jk+w2Zs+6fUW+W9XFuUI0Kj8VYAgdnJCOOVd45R9L9lU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:adc5:: with SMTP id d5mr15715734ybe.361.1616725251714;
 Thu, 25 Mar 2021 19:20:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:57 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-19-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 18/18] KVM: x86/mmu: Drop trace_kvm_age_page() tracepoint
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove x86's trace_kvm_age_page() tracepoint.  It's mostly redundant with
the common trace_kvm_age_hva() tracepoint, and if there is a need for the
extra details, e.g. gfn, referenced, etc... those details should be added
to the common tracepoint so that all architectures and MMUs benefit from
the info.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  1 -
 arch/x86/kvm/mmu/tdp_mmu.c |  2 --
 include/trace/events/kvm.h | 24 ------------------------
 3 files changed, 27 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2070c7a91fdd..9eded46785b5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1467,7 +1467,6 @@ static bool kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	for_each_rmap_spte(rmap_head, &iter, sptep)
 		young |= mmu_spte_age(sptep);
 
-	trace_kvm_age_page(gfn, level, slot, young);
 	return young;
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 21bb8b68a553..2941beb6559a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -949,8 +949,6 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 
 	tdp_mmu_set_spte_no_acc_track(kvm, iter, new_spte);
 
-	trace_kvm_age_page(iter->gfn, iter->level, range->slot, true);
-
 	return true;
 }
 
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 200eb7465530..37e1e1a2d67d 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -255,30 +255,6 @@ TRACE_EVENT(kvm_fpu,
 	TP_printk("%s", __print_symbolic(__entry->load, kvm_fpu_load_symbol))
 );
 
-TRACE_EVENT(kvm_age_page,
-	TP_PROTO(ulong gfn, int level, struct kvm_memory_slot *slot, int ref),
-	TP_ARGS(gfn, level, slot, ref),
-
-	TP_STRUCT__entry(
-		__field(	u64,	hva		)
-		__field(	u64,	gfn		)
-		__field(	u8,	level		)
-		__field(	u8,	referenced	)
-	),
-
-	TP_fast_assign(
-		__entry->gfn		= gfn;
-		__entry->level		= level;
-		__entry->hva		= ((gfn - slot->base_gfn) <<
-					    PAGE_SHIFT) + slot->userspace_addr;
-		__entry->referenced	= ref;
-	),
-
-	TP_printk("hva %llx gfn %llx level %u %s",
-		  __entry->hva, __entry->gfn, __entry->level,
-		  __entry->referenced ? "YOUNG" : "OLD")
-);
-
 #ifdef CONFIG_KVM_ASYNC_PF
 DECLARE_EVENT_CLASS(kvm_async_get_page_class,
 
-- 
2.31.0.291.g576ba9dcdaf-goog

