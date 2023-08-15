Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44F577D538
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 23:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240306AbjHOVgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 17:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240308AbjHOVf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 17:35:56 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280321FE1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:48 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-56477bea06fso6297295a12.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692135347; x=1692740147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CHnuPfUXbmZWu5F2MvTRaFvjEQfMFtfyp4fO+JPGxbI=;
        b=kVAV3xXrMTAbLQ3rPVK4qegv5MzcfS8e5dljWpr6AvcDuBCLiIlKECoYWD0XJVho2d
         jGHvwxgZljxFQgu9npgxS0x58JZUu5bU6WNjVCyPnO35SrWnCN2H+7CpCT70QXB8cRcr
         Pm68+mIdMG7Vl/qw6lSltNtd2pWdOLis+Zl8fjgJ6ApWsU6cxkl4XOtNCEDxY2oiqK5g
         eHSIZrYlahQWr00vrJsklrB6UFyfC5BbaAtr0DMTu0XBUvY5RFq/76/YBxjT4ujsAS2m
         vAqC/DTBbvrhK664IFPuNgeJmAz/J50Ejod+21zKsCGZ5Otsf7bOl91ky9QfiCR7/JOz
         00ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692135347; x=1692740147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CHnuPfUXbmZWu5F2MvTRaFvjEQfMFtfyp4fO+JPGxbI=;
        b=iFwB4TFHNkkE3dNdkNlBtCg/PAMbWla2X1JadCS334je2ALaSzDG5HgbLFBrpWbbO/
         bK77cDySxxZMbBGH13Mze7jbxCViWQ6J3Fy79AJnVXBBlZRw5zQIS8DaN1TuZT6Nwi3I
         4HtA1kIQmcEaCwRiMZAw54YTBlluC99A1o4kk1CrXP3o7CzIl/eop//mgH6WRAyA7oFr
         8ZESL39xHT7m/r1MRTqSx6w0CEuqM1HG9iFLmjxqS4Tvi8o0v70AQ5tC9mkoligmkN3L
         ipbFg/5c5c1n5B4P29+xQ19Zezb3vuPf6Y6c4enZOFR0r2y74Q3yVk+BdLd6ADlXNzhJ
         mK3Q==
X-Gm-Message-State: AOJu0YyOL213+AEs2F+LEdBMy/9He/0QhdVR8RlI/iz0J5Rk+/oxoYJm
        XMd5NYkoZot5nFMaQ7yI3sEIutm6L88=
X-Google-Smtp-Source: AGHT+IGZpFTzWg3Yj6yV3ARgS1gRpt4WlnLvCCsXQ6y9zKKLCPAYed5RzAVM7pWLFGE752cW0iko5FNITv0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1c3:b0:1b5:2496:8c0d with SMTP id
 e3-20020a17090301c300b001b524968c0dmr24608plh.3.1692135347694; Tue, 15 Aug
 2023 14:35:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 14:35:28 -0700
In-Reply-To: <20230815213533.548732-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815213533.548732-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815213533.548732-6-seanjc@google.com>
Subject: [PATCH 05/10] KVM: SVM: Drop vcpu_svm's pointless avic_backing_page field
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop vcpu_svm's avic_backing_page pointer and instead grab the physical
address of KVM's vAPIC page directly from the source.  Getting a physical
address from a kernel virtual address is not an expensive operation, and
getting the physical address from a struct page is *more* expensive for
CONFIG_SPARSEMEM=y kernels.  Regardless, none of the paths that consume
the address are hot paths, i.e. shaving cycles is not a priority.

Eliminating the "cache" means KVM doesn't have to worry about the cache
being invalid, which will simplify a future fix when dealing with vCPU IDs
that are too big.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 4 +---
 arch/x86/kvm/svm/svm.h  | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 954bdb45033b..e49b682c8469 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -243,7 +243,7 @@ int avic_vm_init(struct kvm *kvm)
 
 static phys_addr_t avic_get_backing_page_address(struct vcpu_svm *svm)
 {
-	return __sme_set(page_to_phys(svm->avic_backing_page));
+	return __sme_set(__pa(svm->vcpu.arch.apic->regs));
 }
 
 void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
@@ -305,8 +305,6 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	svm->avic_backing_page = virt_to_page(vcpu->arch.apic->regs);
-
 	/* Setting AVIC backing page address in the phy APIC ID table */
 	entry = avic_get_physical_id_entry(vcpu, id);
 	if (!entry)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2237230aad98..a9fde1bb85ee 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -261,7 +261,6 @@ struct vcpu_svm {
 
 	u32 ldr_reg;
 	u32 dfr_reg;
-	struct page *avic_backing_page;
 	u64 *avic_physical_id_cache;
 
 	/*
-- 
2.41.0.694.ge786442a9b-goog

