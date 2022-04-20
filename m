Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B675092C0
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 00:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382805AbiDTW2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 18:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380305AbiDTW2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 18:28:30 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C2C41983;
        Wed, 20 Apr 2022 15:25:34 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id o18so2063223qtk.7;
        Wed, 20 Apr 2022 15:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yGEzNjv26fUZkerJN19S5j+uBluuftoVLyPl8tEFVgI=;
        b=YlCDfZY2WsSellZ8sQtSwQunudrhtcHkFKK+m/ZwcQkS6RJcjiVBiw3oSQ+gm9fKLN
         CvRZVyb5dUJpfrYqqVWSF8pwKamYZ5KdcjBcp1HAJvLS3IqBSPKWjUMNU34au8gAZKdE
         nhRq381Nzg/1DJBs/R93/lWTCxz9FxgaP0ExNuU7Ek4xoVsSzR5skz+YAf57U1OgMSgY
         oTV4GwCZYBVn1KCCQiUT9WME1TepygE1l8b/orAvgVnLyhGPz09blXq2D2yOIe8aNRMj
         dsu1+PoxPDHFPNT2r47/dXwyR3S3VmmWz1QbOy3dMiIbPMbB4knAs9pxB7ejRjlhjZXZ
         iXeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yGEzNjv26fUZkerJN19S5j+uBluuftoVLyPl8tEFVgI=;
        b=GHnXkfemlbgYorjRjqqWpXykQGJnW7wxc6A67hInNDVr3+uxiuxCR+7x2wsnIOyf78
         MRprrM9hwYwTu86p88+Y5+G2UcGOYQHtbkV1Ier99gKiXvW9AqXxkPyjzRIv4Y+4+Tcj
         Ol3ahBOPg1lVF/iAv1OpxN7xl0GN/KLp6hJALmpnxPuYTVGN5poBtwP2hX0GxRUevmUA
         YVT8YVD0fvPoqfci4ihK2jEGflX3iyr+da7wxGSnbaWa9ouayo2kJGjkeeNSVPWwQ8Rm
         nMAawWH2ChrHmN/L/Fs3QCul2KKrdLWqw0eww9ZCnfhRimj0uY2bNskJyv+/F2UWKYvo
         Et8w==
X-Gm-Message-State: AOAM531EYGPfTDcHMTkhuXFieI8mTnxj5e7Fk6JaKfBlXWhRk2Ribhol
        mfP+97RZxHZ1xxKvibDI31Sl2rFaQRc=
X-Google-Smtp-Source: ABdhPJwfFcdGuS18mNampYGWiv7LRnVZ9031WCdOaVOFiEYbn/Qn8DVd01wYt/CZUyf4eCwjpnjfZw==
X-Received: by 2002:ac8:58d2:0:b0:2e1:c5d9:9060 with SMTP id u18-20020ac858d2000000b002e1c5d99060mr15012558qta.168.1650493533822;
        Wed, 20 Apr 2022 15:25:33 -0700 (PDT)
Received: from localhost ([2601:c4:c432:60a:188a:94a5:4e52:4f76])
        by smtp.gmail.com with ESMTPSA id p13-20020a05622a048d00b002e1ce0c627csm2652151qtx.58.2022.04.20.15.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 15:25:33 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Yury Norov <yury.norov@gmail.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 3/4] KVM: s390: replace bitmap_copy with bitmap_{from,to}_arr64 where appropriate
Date:   Wed, 20 Apr 2022 15:25:29 -0700
Message-Id: <20220420222530.910125-4-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220420222530.910125-1-yury.norov@gmail.com>
References: <20220420222530.910125-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Copying bitmaps from/to 64-bit arrays with bitmap_copy is not safe
in general case. Use designated functions instead.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 arch/s390/kvm/kvm-s390.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 156d1c25a3c1..a353bb43ee48 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1332,8 +1332,7 @@ static int kvm_s390_set_processor_feat(struct kvm *kvm,
 		mutex_unlock(&kvm->lock);
 		return -EBUSY;
 	}
-	bitmap_copy(kvm->arch.cpu_feat, (unsigned long *) data.feat,
-		    KVM_S390_VM_CPU_FEAT_NR_BITS);
+	bitmap_from_arr64(kvm->arch.cpu_feat, data.feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
 	mutex_unlock(&kvm->lock);
 	VM_EVENT(kvm, 3, "SET: guest feat: 0x%16.16llx.0x%16.16llx.0x%16.16llx",
 			 data.feat[0],
@@ -1504,8 +1503,7 @@ static int kvm_s390_get_processor_feat(struct kvm *kvm,
 {
 	struct kvm_s390_vm_cpu_feat data;
 
-	bitmap_copy((unsigned long *) data.feat, kvm->arch.cpu_feat,
-		    KVM_S390_VM_CPU_FEAT_NR_BITS);
+	bitmap_to_arr64(data.feat, kvm->arch.cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
 	if (copy_to_user((void __user *)attr->addr, &data, sizeof(data)))
 		return -EFAULT;
 	VM_EVENT(kvm, 3, "GET: guest feat: 0x%16.16llx.0x%16.16llx.0x%16.16llx",
@@ -1520,9 +1518,7 @@ static int kvm_s390_get_machine_feat(struct kvm *kvm,
 {
 	struct kvm_s390_vm_cpu_feat data;
 
-	bitmap_copy((unsigned long *) data.feat,
-		    kvm_s390_available_cpu_feat,
-		    KVM_S390_VM_CPU_FEAT_NR_BITS);
+	bitmap_to_arr64(data.feat, kvm_s390_available_cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
 	if (copy_to_user((void __user *)attr->addr, &data, sizeof(data)))
 		return -EFAULT;
 	VM_EVENT(kvm, 3, "GET: host feat:  0x%16.16llx.0x%16.16llx.0x%16.16llx",
-- 
2.32.0

