Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C05641027D
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 02:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243367AbhIRA6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 20:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243807AbhIRA6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 20:58:42 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00148C0613C1;
        Fri, 17 Sep 2021 17:57:19 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j1so8049728pjv.3;
        Fri, 17 Sep 2021 17:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1MwVblyi6rCY57E7Ddf6mFxPNkUig1XlnQMyxrn2cZ8=;
        b=BsZl9s47wKeBNzD0K/DUjczU4zrStKph2z3U9YfQmocHfWvw0444DiNd/b6ZtTkRHF
         5GJfgZeLkHNv4cE8mMG9rDaQcouwyVHeEXyebTyGhXgYWyvghXajAkbv9SIZKByhw/kX
         XYdQZzkQJHAQ3aPsRt6RLsxilaZ9AB+S0pynfm2LhQQ6yE5aRIu07/3f6h+lsWxmnhkp
         JwboAPJ3jnX9ahA/EU7STTs0w1hSBq8MfTyTHPz1fPOVhpnzb3CP95six1pFTYsplaaO
         MDH4wr42GAIWqigXzWko/lxHBmDstjEBKu2GCU0Ry3wpCBCenclF9Yhh6QJjFezzxhRk
         Usjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1MwVblyi6rCY57E7Ddf6mFxPNkUig1XlnQMyxrn2cZ8=;
        b=XiBBbq016f1rtI4uxUzD3SwQymhrhRSuVLEzxVQQPxtgLyZJ1HXGqY3ZH90RdrkKzF
         +FXxghdGXBiA5HXx/wK+VItPOwgfVJmyfQIlHoWI3Zd4q10WXy5rD3hAaT0GGda1MxQc
         ZkNh6B9ZdzvwsiW//bwjZNulM/RrnKUqYzzb5MB2sEiRbsR/HNd/T2lcTXo59EYM65tf
         gPugNrWl+8P6pY4dYmjsNaQPnoSQwBtq/hhWRMy0GQKQGWwo+pzXDyD+kcEUpx9XhvSJ
         ZUOpSnbVicDyuTNmcIf+ew7UiB5hhN8wrRfxBjltkJSb7as18fzZFEWWgUhanfzUrITq
         El5g==
X-Gm-Message-State: AOAM531ahfKpcaPh7YI3hsjkrk6xe+AoXAc/ICKXWn1n3koxxYdA5HCo
        lSyezEgTExe/1xrTmy0Hn6/1LlyMSPo=
X-Google-Smtp-Source: ABdhPJwTiAo1Gv82gTlk9T0zsU0AxkDg+1S3PDTvxse1r4O6BWgBF5sGCSlz2GahvfDhGan1bfPM1g==
X-Received: by 2002:a17:90a:d312:: with SMTP id p18mr15355600pju.64.1631926639397;
        Fri, 17 Sep 2021 17:57:19 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id k22sm7278606pfi.149.2021.09.17.17.57.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Sep 2021 17:57:19 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH V2 07/10] KVM: X86: Zap the invalid list after remote tlb flushing
Date:   Sat, 18 Sep 2021 08:56:33 +0800
Message-Id: <20210918005636.3675-8-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210918005636.3675-1-jiangshanlai@gmail.com>
References: <20210918005636.3675-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

In mmu_sync_children(), it can zap the invalid list after remote tlb flushing.
Emptifying the invalid list ASAP might help reduce a remote tlb flushing
in some cases.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2f3f47dc96b0..ff52e8354148 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2032,7 +2032,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 			protected |= rmap_write_protect(vcpu, sp->gfn);
 
 		if (protected) {
-			kvm_flush_remote_tlbs(vcpu->kvm);
+			kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, true);
 			flush = false;
 		}
 
-- 
2.19.1.6.gb485710b

