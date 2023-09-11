Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFE079AF21
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 01:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbjIKUtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243921AbjIKSUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 14:20:23 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF25A110
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:20:18 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5958487ca15so50274897b3.1
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694456418; x=1695061218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=e5q7QeTDTh+6acKqzFBJ3jiuxGQHZkZjsinQYVFGBwg=;
        b=FWEJrXbJM8qT874cqQdxmKuujsneI6o4+ked8YGPMuEuoRZxUQKC9PZ0QW8TsvXleq
         PkIlRXRCojG20C3c+eGb0gkTeGLg97/Ul4bEqMqSlJybEPm7ZASk6xqCfr+Obai44RDm
         NrqI0kd12wmjnclhz9b00dl2eugp1DWPteOkNIIJXxgqvh+KG+izU1x6RpyNA3EEoWsS
         PTapzb0Aacv2ZVeBTFGyG06iOZQ1Onb3SkYYcByu6d6+jYRwuk1WAPvLozvEdK9a1/b6
         aupte9waK5A/rAdf61LGr+xlKFmPBdqLMOAp8VXEosxYlOaSKMzFtyioFML1/RBxuqni
         2zdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694456418; x=1695061218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e5q7QeTDTh+6acKqzFBJ3jiuxGQHZkZjsinQYVFGBwg=;
        b=TEDTxkScuEmMyW7sA7NerGLwZ5CCWlFk9nrIt7VgmthnmYMYtWxVpNPWnd0yTXcD4N
         4A58yW2ioatPVPJXgKW1ZaOrYhmz/Q+AB/5jzGhCQBkybZ9TBlzVTqV2qz1izYxe6fow
         H8ARCahk7PfjJs5iMRkfSGo3wKccJdN1cTPR3rnbr7GI//giOZxxChjAZNnlPQEwojEg
         M0AXC58LBfwHsCRni5XaCbIavBpAzhLW9YssOtFtDhEG0UaS38OVvAd1Rtm9xa+do0Z0
         T8a7FxqxuvkiKOR09fdkfbfZfBttSrmnwUrJ8CLRkUje6bwAr5AbkDeyog+H+vahk4YA
         VOvg==
X-Gm-Message-State: AOJu0YyquU+SqODx5REUijNYLXQGJS0PXgmGxBMIm3nthLmTTvwG567i
        R44DAwOVDS1a+W6EWqxAYdnaMljDP9s=
X-Google-Smtp-Source: AGHT+IH+jeBWxodEy4Tz164fqYgl2rIoxmZNFN0ixvwfFhfIj+sohrfat1CiRWAIYmn3MkrpPYm4EvMC9xw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a705:0:b0:56c:e0c5:de88 with SMTP id
 e5-20020a81a705000000b0056ce0c5de88mr255283ywh.1.1694456417974; Mon, 11 Sep
 2023 11:20:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 11 Sep 2023 11:20:11 -0700
In-Reply-To: <20230911182013.333559-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230911182013.333559-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230911182013.333559-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/3] nVMX: Use helpers to check for WB memtype
 and 4-level EPT support
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
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

Use is_ept_memtype_supported() and is_4_level_ept_supported() to check for
basic EPT support instead of open coding checks on ept_vpid.val.

Opportunstically add a report() failure if 4-level EPT isn't supported, as
support for 4-level paging is mandatory in any sane configuration.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index c1540d39..907cbe1c 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1039,11 +1039,14 @@ static int __setup_ept(u64 hpa, bool enable_ad)
 		printf("\tEPT is not supported\n");
 		return 1;
 	}
-	if (!(ept_vpid.val & EPT_CAP_WB)) {
+	if (!is_ept_memtype_supported(EPT_MEM_TYPE_WB)) {
 		printf("\tWB memtype for EPT walks not supported\n");
 		return 1;
 	}
-	if (!(ept_vpid.val & EPT_CAP_PWL4)) {
+
+	if (!is_4_level_ept_supported()) {
+		/* Support for 4-level EPT is mandatory. */
+		report(false, "4-level EPT support check");
 		printf("\tPWL4 is not supported\n");
 		return 1;
 	}
-- 
2.42.0.283.g2d96d420d3-goog

