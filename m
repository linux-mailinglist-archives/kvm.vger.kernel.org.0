Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55006546D1B
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 21:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347427AbiFJTSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 15:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243528AbiFJTSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 15:18:17 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB951582B
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 12:18:16 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id y63-20020a638a42000000b003fd47b6f280so1432pgd.12
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 12:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=y1EZXvSmEPvb6mcUcqNnwAea2ZEKw13g9a15hObG/5M=;
        b=j5Ol8gvjwBqhz1FCGnzOa9I7myBdajprl0eYTZ+G6kUBS6rutkN9NY3k/9rtRye1bq
         5rhky7E5n4gcRy8RojPyZxnwIQ8q1ptSi1dzy3Y/i20I4s/b+JMGnT55rvp16jPNuo1J
         qpI7gjpVmiB7Ra9W4owVS05GYZ+Xj7IdUvRKyoCHKD9hnkdaCv4MVdzDNyCy5KqTphQU
         1W9At+Oo2woTSGCE0NLVNGMlxiGBNcz6geY1r0gg1MKxg+YJyWY+xr7QC5G3KYaPkQN1
         dtb9K90++nmjmu7WdBfIRuoK745VE4EENDEXbSpZTZ/RlSLnEJNrjx6O2PqMrqBhRJtR
         GPPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc:content-transfer-encoding;
        bh=y1EZXvSmEPvb6mcUcqNnwAea2ZEKw13g9a15hObG/5M=;
        b=b325ObZQ32YnCnuj1UT7fMaZWVWxvqHuV9aIeqAHyxIsqYz9bobTstjXs4kHvercs/
         2m73oDwkKsPeAo/mJs7SfvTc0A76pIGu/XOHEB6uRn6G/cXz7RjbPnnnH1eHi5HwBVj2
         asqnVIuZUN61HjgshSmmX2qFMsz2yrtuYU1BAMcsldm4m7tiCdu8BYbkY34NM8MAqtJo
         3bUaYrZWTOzzW3ONCVbW/97T4q12GVfZTcBMrOnQeRSqU0B2BUDUXweLaIAhO+rHMwUt
         6Q0/nYhUAw3BQNJFFXWMn/eKzJUi1TP0a0Q1nlOgD+XzXoSb5ajA/baNm+GGuwM7Ivud
         6hjQ==
X-Gm-Message-State: AOAM532QRdrDzSIsqLSu5HInTcCzcmYx/hXf7MA6yjY3T7RMeRKzBMm8
        kxhSMOHHyoEWfAXDUFQWPOVNDvDajZc=
X-Google-Smtp-Source: ABdhPJyMSmx7IVBsg90eGIeP4sJzAfrDgpQtiK6YO/BOyTkm6qK/b/c2N1oKuSC58vea5TL9kCTYgM2xFis=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr2350pje.0.1654888695567; Fri, 10 Jun
 2022 12:18:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Jun 2022 19:18:13 +0000
Message-Id: <20220610191813.371682-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH] KVM: SVM: Fix a misplaced paranthesis in APICV inhibit mask generation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Relocate a ")" to its proper place at the end of a BIT usage, the intent
is most definitely not to have a feedback loop of BITs in the mask.

arch/x86/kvm/svm/avic.c: In function =E2=80=98avic_check_apicv_inhibit_reas=
ons=E2=80=99:
include/vdso/bits.h:7:40: error: left shift count >=3D width of type [-Werr=
or=3Dshift-count-overflow]
    7 | #define BIT(nr)                 (UL(1) << (nr))
      |                                        ^~
arch/x86/kvm/svm/avic.c:911:27: note: in expansion of macro =E2=80=98BIT=E2=
=80=99
  911 |                           BIT(APICV_INHIBIT_REASON_SEV      |
      |                           ^~~

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or=
 APIC base")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 5542d8959e11..d1bc5820ea46 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -908,9 +908,9 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_in=
hibit reason)
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
 			  BIT(APICV_INHIBIT_REASON_X2APIC) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
-			  BIT(APICV_INHIBIT_REASON_SEV      |
+			  BIT(APICV_INHIBIT_REASON_SEV)      |
 			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
-			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED));
+			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
=20
 	return supported & BIT(reason);
 }

base-commit: b23f8810c46978bc05252db03055a61fcadc07d5
--=20
2.36.1.476.g0c4daa206d-goog

