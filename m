Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDA558F32C
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 21:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbiHJTa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 15:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbiHJTa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 15:30:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B331F76958
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:30:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u44-20020a25ab2f000000b0067c1b3e9fceso5227057ybi.17
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=+yNPE0YtwokNPZdowqkCFFxMTcHqUO1hXxky5MuupRY=;
        b=oZ5EETOvVLFNFJcFvJs5CUWFZV2YZx1lZtCVYg3Xpam3/6hJePg2ArdHUJxsspg7R5
         kYnk9btdizwNCjiWTgj6vhaG+Ln/haQoW/pUsdjAvXGRUtwyTKhYaNbVGIqa4N0knmX5
         Y6Bf8Sp0myosiRXqgzgjzzrxNgMTvUamymRKjYhHFjm5HuDY7N2HLKT82K2ZR3tI6a2I
         TkfL2xlNiTx9SHZbWxe0/jGZ8EVR0bP+e7g+tySRt7UNKn82GSElS85ZLEZQitwkkwIT
         z43wgykSu9Orgytw+Yk5q/JCadYNjdaFTKqRIDXR1Haw0of7kw8Io57Gij0cmraUd7F0
         vpZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=+yNPE0YtwokNPZdowqkCFFxMTcHqUO1hXxky5MuupRY=;
        b=ICJHgsgKuvygMWmsDfE0cnWO4OnvTj5x2nUp5Te1uNNO8Dl12O/NzWFnZJSQsNDqwM
         hWAuNajwyhrE5cICPnKcSjuxxMsLXLrMF3srA9MtAJ9pfiTKe6th+wiznc2SAF9dc+DG
         DMy+fOEOC2OxvF/UMV9BHykSSInRvH5Rm7komklv2IkVQ2vwFxJzjZygV58mM1pr86Hn
         RcZUXKrOh9YNkrtecmsNPFCUnAzkLBfKp0oRc+ZibddtBfO5ZYNkC/lOlPdgOK79mxKx
         pD95c4rJtvZjqcQEWCGVxslYJE4B1AEVQNLv0AVwnrqeBS0xjBosTTJXT/T8k80UgT+o
         j5qA==
X-Gm-Message-State: ACgBeo3hzUSZ52ERbrzKKgD8X0gpE7rqhhUDcaWA5wZqVdr/8utxZo8S
        0zSxoKcsSSpFrC7WTqIjbQ7Z+6k=
X-Google-Smtp-Source: AA6agR6moG62zPERwU4Dk26hNOp5DcD21DJAex4OmPFxWG3fnAGG1z1V+i1T2gQ2yJV0LxVv859Fqu0=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:4d8b:fb2a:2ecb:c2bb])
 (user=pcc job=sendgmr) by 2002:a25:b951:0:b0:67b:93e9:1ff9 with SMTP id
 s17-20020a25b951000000b0067b93e91ff9mr21338230ybm.101.1660159852914; Wed, 10
 Aug 2022 12:30:52 -0700 (PDT)
Date:   Wed, 10 Aug 2022 12:30:32 -0700
In-Reply-To: <20220810193033.1090251-1-pcc@google.com>
Message-Id: <20220810193033.1090251-7-pcc@google.com>
Mime-Version: 1.0
References: <20220810193033.1090251-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 6/7] KVM: arm64: permit all VM_MTE_ALLOWED mappings with
 MTE enabled
From:   Peter Collingbourne <pcc@google.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
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

Certain VMMs such as crosvm have features (e.g. sandboxing) that depend
on being able to map guest memory as MAP_SHARED. The current restriction
on sharing MAP_SHARED pages with the guest is preventing the use of
those features with MTE. Now that the races between tasks concurrently
clearing tags on the same page have been fixed, remove this restriction.

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/kvm/mmu.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d54be80e31dd..fc65dc20655d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1075,14 +1075,6 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 
 static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 {
-	/*
-	 * VM_SHARED mappings are not allowed with MTE to avoid races
-	 * when updating the PG_mte_tagged page flag, see
-	 * sanitise_mte_tags for more details.
-	 */
-	if (vma->vm_flags & VM_SHARED)
-		return false;
-
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
-- 
2.37.1.559.g78731f0fdb-goog

