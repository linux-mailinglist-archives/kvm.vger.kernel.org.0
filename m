Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874F0616D0A
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbiKBSrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiKBSrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:47:08 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3462CE27
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:47:07 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-36fc0644f51so165662597b3.17
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3kR62HSIiTQCzwGmQgs5HY6YJRVWbPr3ykoc+jji2yw=;
        b=q5DQoPzrYWPMyKqVo1p7fe42p1gFesUoA0SbdaAzEHPMfWMQYOsQtlQUppP9XvLEQ/
         tZ0H8d2Azp17sw6x/LWkhKmx770K+fHmREw+0gPtt+zV2jUV/icvoL5tVVND7cgQ1TsM
         uG/oldWXppmgBts7lzQaFL+QnHf5V6Yh3llW+NhQhNWBpw3W7SnXjTQy4XYODmtHD/K3
         nCfYHNy2o8FT6rSG1l/To4WShg7NPGtwDGSrRJjb9QX403y9Z5sJHSlcY2OPf3rx2meE
         eD7+HqgcqC6NfT117EUE+ujUcqZKv+4YX8UOaAkWPfOAUuod+Hh3skEOHXvFmEMdKpY/
         YXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3kR62HSIiTQCzwGmQgs5HY6YJRVWbPr3ykoc+jji2yw=;
        b=flx9Kz6/rug8TAZgFXu4lTybdiUpSMneRTnNujaqxr0UtSHj/MVilHTrAbJVUpN4xW
         4+tb4thjLF4Dn6vix/bi2k3YaZXiBut51+UhJsexAew7GKOIaeT4ktwnJ9KwcGT0ugmp
         bB0P/houeN+gTscMxK32rSZAcF7L8HrCyxcwszmWxbCOes37dxplbmFnaZeiqJT9afJr
         U/u4un/jpIlfc9ev5GKf+lhXu81Oylke44zVduTn71rgr5Icm1MwPYCd83jkANjLIX4c
         PxktsaGf5NHJCvVeYrxbytuGk/0+igCs917Xbrdg+cZnzMPoO70UY3oIkxG3NKPUVm7a
         drlg==
X-Gm-Message-State: ACrzQf0MyP23blP0qX8VD1tGjD2pztQtXgLZVKxOo9q98J102RFWI40d
        4FOzXI+OZSz3gyw5MBrIAw7y6mDvfEC2lg==
X-Google-Smtp-Source: AMsMyM4CTD6h0hiYzEZTXKWUZW2tL3Y5DhoZKaapI828Ce/Kz9P/BgOTzVbndv8TZmPXKfphxjQ6Q6P9Aqz9EA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:348:b0:6be:b67e:8c24 with SMTP
 id e8-20020a056902034800b006beb67e8c24mr26065847ybs.112.1667414827708; Wed,
 02 Nov 2022 11:47:07 -0700 (PDT)
Date:   Wed,  2 Nov 2022 11:46:50 -0700
In-Reply-To: <20221102184654.282799-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221102184654.282799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102184654.282799-7-dmatlack@google.com>
Subject: [PATCH v4 06/10] KVM: selftests: Copy KVM PFERR masks into selftests
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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

Copy KVM's macros for page fault error masks into processor.h so they
can be used in selftests.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e8ca0d8a6a7e..f7249cb27e0d 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -882,4 +882,27 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 #define XSTATE_XTILE_DATA_MASK		(1ULL << XSTATE_XTILE_DATA_BIT)
 #define XFEATURE_XTILE_MASK		(XSTATE_XTILE_CFG_MASK | \
 					XSTATE_XTILE_DATA_MASK)
+
+#define PFERR_PRESENT_BIT 0
+#define PFERR_WRITE_BIT 1
+#define PFERR_USER_BIT 2
+#define PFERR_RSVD_BIT 3
+#define PFERR_FETCH_BIT 4
+#define PFERR_PK_BIT 5
+#define PFERR_SGX_BIT 15
+#define PFERR_GUEST_FINAL_BIT 32
+#define PFERR_GUEST_PAGE_BIT 33
+#define PFERR_IMPLICIT_ACCESS_BIT 48
+
+#define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
+#define PFERR_WRITE_MASK	BIT(PFERR_WRITE_BIT)
+#define PFERR_USER_MASK		BIT(PFERR_USER_BIT)
+#define PFERR_RSVD_MASK		BIT(PFERR_RSVD_BIT)
+#define PFERR_FETCH_MASK	BIT(PFERR_FETCH_BIT)
+#define PFERR_PK_MASK		BIT(PFERR_PK_BIT)
+#define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
+#define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
+#define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
+#define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.38.1.273.g43a17bfeac-goog

