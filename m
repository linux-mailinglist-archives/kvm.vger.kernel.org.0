Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4392B63FC05
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 00:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiLAX2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 18:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiLAX2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 18:28:14 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BAACE402
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 15:27:21 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3d0465d32deso31866857b3.20
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cZG0yqcEStsxMCOsGsLbuxg5UhLo/05v+igNhXo+egE=;
        b=RotdmcndZEfo541ypzSPA7Gcqjp5N5B+Rvwnjgnlg21E5OPmwUUXI5ZMNxXAnzf52t
         IhdK5L/SO2/0KxmL3DKN+rfrgSmI/ZkWytNZTRoph0+fvkqxhzuuLUSw4nUmof/0Udsy
         iMa5J7R6rApimfrhjQMQ8hhXvU75Xj8K8YoDsaiXGKftndME+NVFdnVaPKbV8S2b10Fu
         6gTcApWj7SRS7ZErG2x0H9djRoGdZX/kHKFwcOvoKZCEGCwmWmx9HJ10rz6o0kkDi3Qa
         4Ehw0p1YJjZ8tWZNRYLdgtcMZUyVcpBwAuEpg09goY7gr85IH0GXMeA53TfVd4aZmVsy
         9jTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cZG0yqcEStsxMCOsGsLbuxg5UhLo/05v+igNhXo+egE=;
        b=kecgHxTwB4++awd6J4ah4WcZ7kKba8oSsemopM36BhziF3FGKwXZNjxYdjI8XBnAHm
         rnslIeELSH1v8pDvCbjuVHW3jdm4x6onah+yQ2hWnJC3EvZmoCh6ga/L+qpx21kaBu0Z
         kDBEDwuU36D2LYDGTHY7UGJlP3Sjz3kduoWAwfiiS59VlfDbX3Jq5bjRL6BMcDZJ+1eQ
         DL5TdCp1saszKgTSx0dcifA0uoJxzCzPZeNYtwIO8T5GPXuViPAkdD6ZbcWswoWPfDuR
         TfNtKoMM1WZpQDPyCitUoTqx/IhKm36TbtDiD1Z90pDGKzPPXrUtckIxyfQUXkUxxD/6
         ucsA==
X-Gm-Message-State: ANoB5pmDXYQY7EdVFToW3Vu7oMF4gCHZmM66Q2nQZ1w2dKn3Icyd1jPh
        M/zx4IJjsnxlnJHtXolNAd4XYyaKPH8=
X-Google-Smtp-Source: AA0mqf7MJWHcAG6vdTf9w1OowNCeW1uuWVIj+VLHOB6jpKtg81SgZinEw7Y+yyKEhmtsa7huiHGdgyCAcF8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ef4c:0:b0:6f5:f4bc:1327 with SMTP id
 w12-20020a25ef4c000000b006f5f4bc1327mr23058180ybm.244.1669937240562; Thu, 01
 Dec 2022 15:27:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Dec 2022 23:26:50 +0000
In-Reply-To: <20221201232655.290720-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221201232655.290720-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201232655.290720-12-seanjc@google.com>
Subject: [PATCH 11/16] KVM: SVM: Make KVM_AMD depend on CPU_SUP_AMD or CPU_SUP_HYGON
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>
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

Make building KVM SVM support depend on support for AMD or Hygon.  KVM
already effectively restricts SVM support to AMD and Hygon by virtue of
the vendor string checks in cpu_has_svm(), and KVM VMX supports depends
on one of its three known vendors (Intel, Centaur, or Zhaoxin).

Add the CPU_SUP_HYGON clause even though CPU_SUP_HYGON selects CPU_SUP_AMD
to document that KVM SVM support isn't just for AMD CPUs, and to prevent
breakage should Hygon support ever become a standalone thing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8e578311ca9d..0d403e9b6a47 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -102,7 +102,7 @@ config X86_SGX_KVM
 
 config KVM_AMD
 	tristate "KVM for AMD processors support"
-	depends on KVM
+	depends on KVM && (CPU_SUP_AMD || CPU_SUP_HYGON)
 	help
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

