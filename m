Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BE277D53F
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 23:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240332AbjHOVgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 17:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240341AbjHOVgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 17:36:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892131BC3
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d62858b0914so12070241276.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692135356; x=1692740156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XKYtflVs6x0P0nG2XmReTxoXGzhm2UoHQdfpKsYPPNY=;
        b=gTV6SCMN5bJtw7ZipgqQ/Ha6xtnuyOxIzI9hPVU/IHJWYusADTAXSdZSEjqrdDvKFC
         H24by3+WRSsHD8ktrTbPXqbnVMsshBgkR7Qtizb5ozlvhvguhcV4O6Dy0UQmPrlGU5q1
         kmSjTHik0kFE+ree6QrqFLChvoY0qLuwjy7n00kwpKgzKsukZuE4WZc3RJXjeBegfnzN
         QNCzsgylSTpei/Dpc2l18J7ku3sZgSKl1oRWYeP8ytJcXPe6azd0ac2ZUKTf/E1wzsiS
         0J/cMrZ1DN4bFw9uLJVz7hyOkGRqhVejQvIy1/z+gDrAaxhs9P9+pI0332AplAir6Vx2
         orYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692135356; x=1692740156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XKYtflVs6x0P0nG2XmReTxoXGzhm2UoHQdfpKsYPPNY=;
        b=XT7k/6/1/4SlUddDTzegnaKRjeuE//aKSPqSVFcztoQp9+JX6QlfSB78Ln1WEoqC4C
         MeIQgHVLIomiiwxZT6C4Ns2u6GrKmoeuuE/EkKG0N/QXGmruM7tSbEFg/5QN55ZlZn1s
         VTjdObnvpyy/E60prGC7bjgJOkGGXL7f0Lpe4DCklFcBzLrIaKtKUm0jqr6gQ8ACzbjR
         SMy4iiaoG795aF8/BmYWw1WhRW+Pi9sZbt4h+7denmt+tulaZEbcbB88/MQfZVlsrIkQ
         76WIO2QYz3FgocNiKHyms1HTfyyNi64jfMMc60YsYzQi6ongDbHU+cSt9SBcSsr5dfZ6
         EfRA==
X-Gm-Message-State: AOJu0Ywe82WyPz/QLvXqG9gG0/yiy6i8vdmfS92B2XWXp+MEHWpsMrkj
        5YYLGmMfCAbxd7pQE8Z2BiLfwUw5iy8=
X-Google-Smtp-Source: AGHT+IErNwqVt6Ll9LVDM795Zz4F0y53aJAzMjQ8Os681uzsdutwM4dp6vSZf6bhQDOx24qg7MUvE1zlle0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1021:b0:d2c:649:f848 with SMTP id
 x1-20020a056902102100b00d2c0649f848mr4288ybt.1.1692135355855; Tue, 15 Aug
 2023 14:35:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 14:35:32 -0700
In-Reply-To: <20230815213533.548732-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230815213533.548732-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815213533.548732-10-seanjc@google.com>
Subject: [PATCH 09/10] KVM: SVM: Drop redundant check in AVIC code on ID
 during vCPU creation
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

Drop avic_get_physical_id_entry()'s compatibility check on the incoming
ID, as its sole caller, avic_init_backing_page(), performs the exact same
check.  Drop avic_get_physical_id_entry() entirely as the only remaining
functionality is getting the address of the Physical ID table, and
accessing the array without an immediate bounds check is kludgy.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3b2d00d9ca9b..6803e2d7bc22 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -263,26 +263,12 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 		avic_deactivate_vmcb(svm);
 }
 
-static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
-				       unsigned int index)
-{
-	u64 *avic_physical_id_table;
-	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
-
-	if ((!x2avic_enabled && index > AVIC_MAX_PHYSICAL_ID) ||
-	    (index > X2AVIC_MAX_PHYSICAL_ID))
-		return NULL;
-
-	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
-
-	return &avic_physical_id_table[index];
-}
-
 static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 {
-	u64 *entry, new_entry;
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 *table, new_entry;
 	int id = vcpu->vcpu_id;
-	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
 	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
@@ -318,15 +304,13 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	}
 
 	/* Setting AVIC backing page address in the phy APIC ID table */
-	entry = avic_get_physical_id_entry(vcpu, id);
-	if (!entry)
-		return -EINVAL;
+	table = page_address(kvm_svm->avic_physical_id_table_page);
 
 	new_entry = avic_get_backing_page_address(svm) |
 		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
-	WRITE_ONCE(*entry, new_entry);
+	WRITE_ONCE(table[id], new_entry);
 
-	svm->avic_physical_id_cache = entry;
+	svm->avic_physical_id_cache = &table[id];
 
 	return 0;
 }
-- 
2.41.0.694.ge786442a9b-goog

