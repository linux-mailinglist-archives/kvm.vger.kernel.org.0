Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77C84C5290
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbiBZARc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240518AbiBZARG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:06 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE022261F1
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:25 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id x25-20020a63b219000000b0037425262baeso1319538pge.13
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JDThRSqN0byFLKsQYI89Co7AKmuBCHnME5v6WomODDw=;
        b=KnNEuHSDYY9Qpv8Sc7pMTFoKsQ1o1irShtKNr/STHSxYwJLaYyi5K1uzyhNvsRIB+t
         GmneOFlCNqt6+D5k8U9urB6oYaTV70HwxQqPey79vYIYg2VXQBvVhwTPKie/2bAcGEen
         yw0Omtgx2d7PvTH+1z372LtMBDGvi4yvNRQ3516OqK89vTJfmn98v81FAVz13FI/gcb0
         FMOYaSUSX8sDJ4F/5NY/WaHzV00pF8Aw3qeWDHuBihAGUcaxx+SaNk6vPwupm8BgvMUt
         YT9pjc7hdVJFH6fBi0ci5quzkscOsEQIKLLvKn6WqvEuBmzO92jF8ncfBNTNQJv6r1rA
         c1fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JDThRSqN0byFLKsQYI89Co7AKmuBCHnME5v6WomODDw=;
        b=LTtB4B/ZcHlW4ZNr7zyby3SFoYWHUajBS6V1Ojg0Sy1f+tvdREaXYLPl3mZkCBTU0t
         z4gk4VE9oy4iijvzN0GgNAf/hi04HucFjxaJYRg4K8YqiVb1Jdwmo39gIsrpVhIzlFsG
         AmkM7Wk5v1a+6P0Ct/WUPgDmb+EMJe0r+nolw1LTC84Ou3iV47OShKQejoUvYBrv8QJN
         0/aBLnBHBPLhXBP7f4hFmdurTzxW88EOBhs70LLg2OcmUqIA8G9FH7YPS0Dc/fUwfUVz
         /MsWxuPZzroI5zyMDRKCmZQhg25i2krj0EUIPYxsqQgjX2R8yKkbe7ez+3zaHovQ+Hm/
         xlJA==
X-Gm-Message-State: AOAM5323HkOs/kfqw/qX9ENkva20Ln9wzZP31XZs/DomYQG09FCEV1jg
        mtY2JZVBEil7fUwssUfCRSw+tQ6QguY=
X-Google-Smtp-Source: ABdhPJyDXjmJG5ubpBBt2IByek7X49XHlU8cpZNg0E33OFPw7Jkh1SIZ8sqLHR0uUVnkCt9UJDZ4mM68s6g=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:b906:b0:14f:76a0:ad48 with SMTP id
 bf6-20020a170902b90600b0014f76a0ad48mr9902830plb.79.1645834584804; Fri, 25
 Feb 2022 16:16:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:32 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-15-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 14/28] KVM: x86/mmu: Skip remote TLB flush when zapping all
 of TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

Don't flush the TLBs when zapping all TDP MMU pages, as the only time KVM
uses the slow version of "zap everything" is when the VM is being
destroyed or the owning mm has exited.  In either case, KVM_RUN is
unreachable for the VM, i.e. the guest TLB entries cannot be consumed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c231b60e1726..87706e9cc6f3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -874,14 +874,15 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
-	bool flush = false;
 	int i;
 
+	/*
+	 * A TLB flush is unnecessary, KVM zaps everything if and only the VM
+	 * is being destroyed or the userspace VMM has exited.  In both cases,
+	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
+	 */
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, flush);
-
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
+		(void)kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, false);
 }
 
 /*
-- 
2.35.1.574.g5d30c73bfb-goog

