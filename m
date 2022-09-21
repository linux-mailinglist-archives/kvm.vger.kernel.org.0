Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBE65BF511
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 05:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiIUDxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 23:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiIUDxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 23:53:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E323E77D
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:53:09 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v188-20020a252fc5000000b006b4c924afa8so107035ybv.20
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date;
        bh=l32Gj8DFEI8fLqucJeW2Rbzgq3dj8DyhNV3q0+UkQLg=;
        b=XuosAkkktXXWMgAJHuCQa6UGl0+k/yysrZg8b+tKU72U2p9L/09e0hmFFdbpFORH8V
         vTILz5cc/H+dABEvWXOa0Q96/hCZZqtcjG6GDq9EnJkg1HRbHUdnGMBvgxgXxkD9eVhg
         3mESCk3cMrCrJNyO444O2KjWFvhL+u7B8U8iyrT2z2rQsl/Atk7HTwqj22cvRTddvz5V
         /9XStQt610oFcuHnUCacx/6zTnRV/jgFzTs0rOpnX2VLj6/BcvNplLLaWguL+DWjExP6
         E/0WLMczgDZY2C1h/uArgrik8gj1VT8Z5HqD+l0KltnMuzSx9/uO4IE53pibPPLBUHoA
         GLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=l32Gj8DFEI8fLqucJeW2Rbzgq3dj8DyhNV3q0+UkQLg=;
        b=T/YmQqFTWAzkA+E5rvwlLUnsbpshiArR5pv1A5DsiPmkOeTrTaG+h7b20Ikgc9KiMl
         jn6qXErMaq7Pjqev+m+rTqYfd6btNc3x8S+A8jp8+yQlyzI0ODsvLW5BoL3cSROjTfQ4
         uf717FTPUJtwQGSjItK4j+loKz7rSQj0VjyEnxe1tQMKhN3xJNPhpsBPCGUeO8epPBAk
         qA12+KPZts6LFe968d3AbkMUoFYxFMgRl2KSsp6BxC3giYHVr2QigNdzvh7XRqnlpNQz
         H3I9LE9r6ffie9+onpABsoSJzbRUqHUhn4J7DD7aFgigCLjrdYRoAG9z9MDey0haDfnU
         siIA==
X-Gm-Message-State: ACrzQf1r0vsHD9Nu4Fuk/Qt3l0RhJUlosCS128jFWY6gMQddgxBKZQ5f
        2b0kQFN0wYglN60ZKEF6BGttP1g=
X-Google-Smtp-Source: AMsMyM4k2SLq+xH0pc9iLcqj7V+ZPh7OXwHnlc3w1WiBAqn/qKtC40c1YU8Rcz5OMXlTDVVr0U6HpDc=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:1b89:96f1:d30:e3c])
 (user=pcc job=sendgmr) by 2002:a25:d70b:0:b0:6b4:1ed6:24b2 with SMTP id
 o11-20020a25d70b000000b006b41ed624b2mr9467270ybg.268.1663732388240; Tue, 20
 Sep 2022 20:53:08 -0700 (PDT)
Date:   Tue, 20 Sep 2022 20:51:39 -0700
In-Reply-To: <20220921035140.57513-1-pcc@google.com>
Message-Id: <20220921035140.57513-8-pcc@google.com>
Mime-Version: 1.0
References: <20220921035140.57513-1-pcc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Subject: [PATCH v4 7/8] KVM: arm64: permit all VM_MTE_ALLOWED mappings with
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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

Note that this is a relaxation of the ABI.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/mmu.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e34fbabd8b93..996ea11fb0e5 100644
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
2.37.3.968.ga6b4b080e4-goog

