Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B43E54BB76
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357081AbiFNUH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355067AbiFNUHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:40 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7CADFEA
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:31 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id w12-20020a170902e88c00b00168e42facf2so3195245plg.4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MksWVyw3GKJunqV2uq+ZgTGX3Mhc72udxz4fsPG/7ic=;
        b=ceLFX3rSwoTFNDpb3FVJtM503EwtikfUe8vquzqeFYvH7dUWn3SMnUwtzoAySZAVRd
         uW5iVLgtlWlREv4+00HxU/k+HFQZvCaJzoehxjcqWIKsKfgjrgJBYpN7SmfCxPjz+jr2
         fx5bggpJDLP9LaDp1qC2khQEu/G6LW9s+2fiuTcMoH/YUucVH6RTjAfEgxxBKRJGaa7z
         /qfy3Birz4V8YgtYnGSqFpel7oa4sINTQf3W4s3dDLkZiwh3mWd3ZKYKpjRBalecTF6a
         DZ8rSMXr8gE4hVIeRN4Yel8fFLAC5s0lqCOtqX1+6Ee/O83rcCfh46uQOhrb7xPXjmng
         OyJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MksWVyw3GKJunqV2uq+ZgTGX3Mhc72udxz4fsPG/7ic=;
        b=K3hQZqUNPlV0BOS7GjMH41XMIRKO9J3VPuN7drGBfIxK3ignI9r/uEnO/Vwu8qPzCB
         cbCNB+Pziqn/bKM7fYULbFa7Ap7/BEYG7KiYCYWsGl7m5eKZmnCG3z1dp+L/gnWaQ4OI
         Ibd1d9PgRECkiDcvH82K7+T/3JFGleS21U6TC77CRym2wR6i2Jln89Tu8sqCmQd7QewT
         JcoJLKigWx2ZMswHwJPTTKGIiweWe86VR9MvAlHnzncdxg8RxJEZfG2unXi5S1UiAKPG
         8zQDFIgPJ0bvBFNCZqLSCtlPHFA6GByCOX/Xa1FpSk6V0jScPcqFw9BA3LS0TcDjDtn5
         ccAA==
X-Gm-Message-State: AJIora+18DlbxSb0uBrjYrxtHCNKBgx5UNXtTS/QY0aVWdOXibTM8Alc
        Qqif3ZlJjzzB5vWYmrUU1DZTC+2YtnA=
X-Google-Smtp-Source: AGRyM1vJ5pqrJFJ3WlsZ7s7Lfko+SH25Pjb4oKs8fqrZCzpCgEirCRElDq4vbaWazbcAhcKkU0N6zUtxlF8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:544:0:b0:51b:a90d:64d3 with SMTP id
 65-20020a620544000000b0051ba90d64d3mr5966933pff.40.1655237251012; Tue, 14 Jun
 2022 13:07:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:35 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 10/42] KVM: selftests: Check for _both_ XTILE data and cfg
 in AMX test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Check for _both_ XTILE data and cfg support in the AMX test instead of
checking for _either_ feature.  Practically speaking, no sane CPU or vCPU
will support one but not the other, but the effective "or" behavior is
subtle and technically incorrect.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 7127873bb0cb..dcad838953d0 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -335,7 +335,8 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_get_cpuid_max_basic() >= 0xd);
 
 	entry = kvm_get_supported_cpuid_index(0xd, 0);
-	TEST_REQUIRE(entry->eax & XFEATURE_MASK_XTILE);
+	TEST_REQUIRE(entry->eax & XFEATURE_MASK_XTILECFG);
+	TEST_REQUIRE(entry->eax & XFEATURE_MASK_XTILEDATA);
 
 	/* Get xsave/restore max size */
 	xsave_restore_size = entry->ecx;
-- 
2.36.1.476.g0c4daa206d-goog

