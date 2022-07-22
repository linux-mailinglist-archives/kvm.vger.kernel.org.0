Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60A557D828
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 03:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiGVBvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 21:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbiGVBvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 21:51:13 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C77E9748F
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 18:51:11 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31e65a848daso28851777b3.20
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 18:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cXHHG5JyJT6/zfSdYwcZ5hplI/Zwtw5pce4ngWT2RP0=;
        b=B/196tHwJZGxwdFpPDFtGgET20t1oaPOi+B7MforGvjteQqAubrBbnDQDcEDABfdFN
         3DK9BLo4bXahlAM1Zsxz6zcxuz6ugGDvcoav9uuevoCJW5/jGeVxKgcMDWkvWNt+YlYE
         YGooogCFEZU+f/gGBwXExbBhTXJG7xpnwCN4d1QjLWLCX6p/euCGwNgqngATINfEafUZ
         vmxSUdXRy8210cbejvc/kzSbNqREBTwRlsnUJ3CeOb7E82yXcf7pGch9UX8WepzcpJGw
         gVDLrfHbXsI5qYh6TeA8MbgK6BZW4I+5FNvZUO3QAWxqrGa639qAV9IpgKC4MjSspDJg
         W3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cXHHG5JyJT6/zfSdYwcZ5hplI/Zwtw5pce4ngWT2RP0=;
        b=5/uT7CIdw46moqnQSLENg/71EsFSA6RN+DagO4pRL26Oy8kiZlaH9SVkkK4+0ZxIJy
         tF/vkOG5DDNCc4fS0LLJ/5rcrtxBYyd3E+EC4U5Ho5QpRCqAlA3fZSZcGubQO8a86qfo
         PejyWt3DmYSRDV0qNDQXe53T7LOcnLf3UgiM5P37njkoOw+lgmBKu3exGAp4mTTy6s8f
         oOt/g28VH5YO/99doXY8vuhSM2NFkQJcduixlH6Hw8sX+PmZIB+PRG8JksSOxto1kgD+
         2ytSE5/Pn2N4wE5meh6xqQGuR8MA63xEZ1+Okqg9YFeF3Vzqv+A6CSAFZp8tnWB9ZIeg
         SDWQ==
X-Gm-Message-State: AJIora+k9KIiftAfcvDaBs5Btnx6w8jqadA1b/QTIiaTjucw63iC9w3V
        mk30EiU3jy45BzwAk+JEyDClBm4=
X-Google-Smtp-Source: AGRyM1uyeQgFMIiL2ECknr9YM3j6WFlHrejpaFbSL4QcZoqTrnLYKShMPao1gximyv/6/63IGwrd5rM=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:7ed4:5864:d5e1:ffe1])
 (user=pcc job=sendgmr) by 2002:a81:124b:0:b0:31c:fc99:d4de with SMTP id
 72-20020a81124b000000b0031cfc99d4demr1273232yws.348.1658454670287; Thu, 21
 Jul 2022 18:51:10 -0700 (PDT)
Date:   Thu, 21 Jul 2022 18:50:32 -0700
In-Reply-To: <20220722015034.809663-1-pcc@google.com>
Message-Id: <20220722015034.809663-7-pcc@google.com>
Mime-Version: 1.0
References: <20220722015034.809663-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 6/7] KVM: arm64: permit all VM_MTE_ALLOWED mappings with
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
2.37.1.359.gd136c6c3e2-goog

