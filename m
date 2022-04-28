Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B87513CEF
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 22:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351994AbiD1Uyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 16:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351955AbiD1Uym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 16:54:42 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F56BC0E65;
        Thu, 28 Apr 2022 13:51:26 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id iy15so4063600qvb.9;
        Thu, 28 Apr 2022 13:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Xw3/FRUnNxzv2Vp5MuedmA5I6QJHauY+6s7D5TgPLEg=;
        b=G/eBNBoGIlKglYC+2XQOUPkYpfxoynz2J3BYBsv+O4lkvCcEz0pbzICvG1htRTn9T2
         12e8ZExY8T0BJ1g5Ty5IgSjNDi+TYqskSD4VWWjYXs1SUy+6hBnhJcZQJGOVABORrsdc
         u/N24Md3p/ik3a7QGIL5+uNw1dNYrrUhFJyTdzro2Fs68fUvAA9cIJ+XjKnwJkLBhCdB
         Kg1ymQa+abuIf55Ath6HhSjSoI3kfnF+dPCeqC+CXjNwFDKHbw+lSl51Mya4manDcfVg
         v0KtQv+OE/DdfnK1uqur71YLQAhRPlyA1WrPtxReF9eBojO+EyIdWzQirHVkYc9pE6wN
         SJQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xw3/FRUnNxzv2Vp5MuedmA5I6QJHauY+6s7D5TgPLEg=;
        b=TSqt7znqXCQAFyUnHrDrre1GGVv+BA4rxeiW9l+wSltrUrOmkQ5YwkJtVVT40G+1sV
         eLZF1BI/C19RzIqSRoV4T2TxGVx536Ra+Td6N9EVC1Vdrmoc8RcNfsZmCR49eCRyeCG1
         d35e0iId1FC+7RAviL1QOcIlMVFmqYR3QrZiSA9hKCCIrddR6cjfWjRU4ycmzyLUV2gY
         GgfIt3sn8J4XZz9h/TnLs5H6E08l2eiDlj3ceYSRDgunv++/BrgdI8Uzwl6DfDA2O+5Q
         sPN5bSU4LXbNTHi53AGE7+TI7EuRrbhrDzmq4vbB9f10utEoBIGgmHrY37NwoZvKXe2d
         G7Ag==
X-Gm-Message-State: AOAM530FWU5hDG37avGHIzU+0Q2Wsl8vutu1M7DM9Uffj2YvPwHq2HhH
        0m5je82aZGVDYPZYXtIuyEeUWXEN0og=
X-Google-Smtp-Source: ABdhPJzGfrwpXemQ16feyGynDUbhkxBE1tDjYowkDP+R2bhH8PI1LM1Xz6l8jaeKjg5l/FTBJ5MYVQ==
X-Received: by 2002:a05:6214:224f:b0:43f:cd6a:1d6b with SMTP id c15-20020a056214224f00b0043fcd6a1d6bmr25886639qvc.12.1651179084896;
        Thu, 28 Apr 2022 13:51:24 -0700 (PDT)
Received: from localhost ([2601:c4:c432:4da:fa85:340e:2244:1d8c])
        by smtp.gmail.com with ESMTPSA id 186-20020a3707c3000000b0069f9a8cbec2sm455491qkh.131.2022.04.28.13.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 13:51:24 -0700 (PDT)
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
Subject: [PATCH 4/5] KVM: s390: replace bitmap_copy with bitmap_{from,to}_arr64 where appropriate
Date:   Thu, 28 Apr 2022 13:51:15 -0700
Message-Id: <20220428205116.861003-5-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220428205116.861003-1-yury.norov@gmail.com>
References: <20220428205116.861003-1-yury.norov@gmail.com>
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
on 32-bit BE machines. Use designated functions instead.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/kvm/kvm-s390.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 76ad6408cb2c..8fcb56141689 100644
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

