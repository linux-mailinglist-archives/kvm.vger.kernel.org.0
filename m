Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29F4688661
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjBBS2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbjBBS2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:28:39 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205E2410B3
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:21 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 201-20020a6300d2000000b004ccf545f44fso1373118pga.12
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VxkR2t/soCZeC9eyZl1mM8b7dI9FSV2mUjQI7FtOHrA=;
        b=bRIm91U6CXHVWLtrnVZHyCbrrPa45LPwdl416lNZtl+FS4NbZUA/w8w3xI7dR3QaUJ
         uzEyVHHOYRIhLTQG+2FeNkgmc+azanymGtl1QjsMyWScmGGcZ4ulvAEN2hHl11MQnb5J
         eOl35AxgHUpuLLm/0yUkZ6/NrKDsh0/x+qZEWGU+6030SYpFKtDTj64pHtPMMmbY3Djo
         hurVP9eX5Osf7WNhIL0csIDXWHRBcJu+1F20CketRewTixj85Jz2/ph8G9qDLLd45WEW
         kk/bY69JhozRJVuKnj5DtXaDcPI7Ke+YuN+juZuw+du57/vbwq2+6mu5fKeeVzoB0WdE
         jUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VxkR2t/soCZeC9eyZl1mM8b7dI9FSV2mUjQI7FtOHrA=;
        b=gvQdKu7aXV+c5cAur93IbbEqDrY8IED85Bb0zfj2kb20LxoC+IxbxD9xXMDIME/ocA
         FaRdO7rkaXJKB9Y1gjKFOkUi1EV09g/alLHTM5N56i5ebUodMeZspHui0dx2oKu64gre
         nj+G+iaQFqpmlQz5koPkb03I2ZKgaGQbKvf5D4+qPVVXfMLvCRIFKklrRDoOFcPwYMGJ
         mtX/w0uU+uhLkTR6XkGDn/cBKDW22UiRKuKFfHyQmfyqiTdxNBzYj6EjDlcyeKUO/VbL
         mKIqxOCM+Q2V1uFYUA8Wfukdzmpo1sE6Z/goYqKQBTsAd5T1qHTM0uLwlX0HCKJ0a9Bj
         i9HA==
X-Gm-Message-State: AO0yUKU2ct2WoIimXQGY7DvWduGEk0JKCuvoMpSJZ61UQ5GQuxQpfZLQ
        gBPWeDiQGQZIpKqmwx6hNIxcK3VlUbvf
X-Google-Smtp-Source: AK7set+1EwIWWN59ZsHJFSU/7CoS97kInlt4PpAcX4d1vE0ypK/nvM2RzsVDAjRyGd2Upc/MT14gL5GycZ0t
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:aa7:9f51:0:b0:58b:c29a:87a6 with SMTP id
 h17-20020aa79f51000000b0058bc29a87a6mr1724887pfr.13.1675362500951; Thu, 02
 Feb 2023 10:28:20 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:27:54 +0000
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-7-bgardon@google.com>
Subject: [PATCH 06/21] KVM: x86/mmu: Get rid of is_cpuid_PSE36()
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

is_cpuid_PSE36() always returns 1 and is never overridden, so just get
rid of the function. This saves having to export it in a future commit
in order to move the include of paging_tmpl.h out of mmu.c.

No functional change intended.

Suggested-by: David Matlack <dmatlack@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 13 ++-----------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 12d38a8772a80..35cb59737c0a3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -304,11 +304,6 @@ static bool check_mmio_spte(struct kvm_vcpu *vcpu, u64 spte)
 	return likely(kvm_gen == spte_gen);
 }
 
-static int is_cpuid_PSE36(void)
-{
-	return 1;
-}
-
 #ifdef CONFIG_X86_64
 static void __set_spte(u64 *sptep, u64 spte)
 {
@@ -4661,12 +4656,8 @@ static void __reset_rsvds_bits_mask(struct rsvd_bits_validate *rsvd_check,
 			break;
 		}
 
-		if (is_cpuid_PSE36())
-			/* 36bits PSE 4MB page */
-			rsvd_check->rsvd_bits_mask[1][1] = rsvd_bits(17, 21);
-		else
-			/* 32 bits PSE 4MB page */
-			rsvd_check->rsvd_bits_mask[1][1] = rsvd_bits(13, 21);
+		/* 36bits PSE 4MB page */
+		rsvd_check->rsvd_bits_mask[1][1] = rsvd_bits(17, 21);
 		break;
 	case PT32E_ROOT_LEVEL:
 		rsvd_check->rsvd_bits_mask[0][2] = rsvd_bits(63, 63) |
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e5662dbd519c4..730b413eebfde 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -426,7 +426,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	gfn += (addr & PT_LVL_OFFSET_MASK(walker->level)) >> PAGE_SHIFT;
 
 #if PTTYPE == 32
-	if (walker->level > PG_LEVEL_4K && is_cpuid_PSE36())
+	if (walker->level > PG_LEVEL_4K)
 		gfn += pse36_gfn_delta(pte);
 #endif
 
-- 
2.39.1.519.gcb327c4b5f-goog

