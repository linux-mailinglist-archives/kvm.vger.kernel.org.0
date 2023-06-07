Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88E7725137
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240258AbjFGAoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240172AbjFGAox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:44:53 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898E3199B
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:44:52 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-651427a2b74so2497501b3a.3
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686098692; x=1688690692;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hMS6TbY8tUGzqJGlK30/5JW8c0xokG6mdD0HyuMym4c=;
        b=bLXpMocQLVlgyJX48+fNsXuNuM9x0oWnbwgQpxhl2OGtsR0eBHw4IX2VH6y8JNS15x
         0UU/0aae9lBH4zkmKaJVAuCIqdW+hnjodM0BmN8R6pAb/81Xtc8euHbPR9HbPjVoBsH8
         WGArn1IvSJZdFeUSLZXBJDYeC0u4QeR77eSsTsDkcV8tXs7CV3szzx5mRn55gYLrbbIV
         qvwDDeu/7Ypd6FuCzo5y4CBGG20wKcNV5ghrOcnGzeM366XQEP/SErkXmlrtloHvLtOj
         UoeRaSp8dTmZdCZiOjFnO1Kgtuj3TQGmTeF0f8yOuKjZANnqTNEQY2Pj0GIpcIie0wPq
         W4Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686098692; x=1688690692;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hMS6TbY8tUGzqJGlK30/5JW8c0xokG6mdD0HyuMym4c=;
        b=kynkzc+7wUmbtsF72M5y2QFtQQqm3LEawgDtHZNbp9NALyVbuH1wH5gZwNUFqTws2G
         wr7Erq/hvPoORtK387UJS2dIi2nWCgSGZcgRRcsjW5ZRyVqmEVqsclmyBQY5deEWedPU
         yKPpiaSEtWrbIGBpO0qz2ng7lGP5WPyS7rMOfJHygt4bZh93L/0Box5SNubCvtWpF15P
         Up6udvrTve6NX+qVwz8ucQE5T7TctzLtg0Kw6HYLLfq9PmzwcRWNTd751ALxJRmYBnJC
         IUhEF757r/TzEw7iw1P+uSW2rmA2bDo6dQ6JdMThhzwj0l/CMUHH87AZ79//eB5WdErW
         nkFw==
X-Gm-Message-State: AC+VfDz6zog8SM2eXSfF1wy+HjF65Mv8ziMGkiULY7nzRK3pS+q/tupq
        dLJeLQvcNwcHjEC0VKGKlKvWhZk5oqI=
X-Google-Smtp-Source: ACHHUZ63bVDAvopqQo7+5XQ4UODLKyw0ZfkUHq2K76KIorPBH74Tdkdtu/Az4QXHRsLLr2iZnZFEEOgB4O4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:cca:b0:63a:ff2a:bf9f with SMTP id
 b10-20020a056a000cca00b0063aff2abf9fmr1626897pfv.2.1686098691939; Tue, 06 Jun
 2023 17:44:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Jun 2023 17:44:49 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607004449.1421131-1-seanjc@google.com>
Subject: [PATCH] KVM: SVM: WARN, but continue, if misc_cg_set_capacity() fails
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
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

WARN and continue if misc_cg_set_capacity() fails, as the only scenario
in which it can fail is if the specified resource is invalid, which should
never happen when CONFIG_KVM_AMD_SEV=y.  Deliberately not bailing "fixes"
a theoretical bug where KVM would leak the ASID bitmaps on failure, which
again can't happen.

If the impossible should happen, the end result is effectively the same
with respect to SEV and SEV-ES (they are unusable), while continuing on
has the advantage of letting KVM load, i.e. userspace can still run
non-SEV guests.

Reported-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d65578d8784d..07756b7348ae 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2216,9 +2216,7 @@ void __init sev_hardware_setup(void)
 	}
 
 	sev_asid_count = max_sev_asid - min_sev_asid + 1;
-	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
-		goto out;
-
+	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
 	sev_supported = true;
 
 	/* SEV-ES support requested? */
@@ -2243,9 +2241,7 @@ void __init sev_hardware_setup(void)
 		goto out;
 
 	sev_es_asid_count = min_sev_asid - 1;
-	if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
-		goto out;
-
+	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
 
 out:

base-commit: 6d1bc9754b04075d938b47cf7f7800814b8911a7
-- 
2.41.0.162.gfafddb0af9-goog

