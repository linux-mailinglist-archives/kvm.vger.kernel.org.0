Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B606A2458
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjBXWhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBXWhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:37:07 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4E41B2D3
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:05 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id m9-20020a17090a7f8900b0023769205928so1859066pjl.6
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UK2Im1BEXAy6ijd16h4AX9V+lLFWq6BP9P20yLZbsYA=;
        b=Wlo7/9HLpKgw/3Sv1De24kjKRcv1up0BCe2hwc+CMEM0VdJuV3MSbMc5jPekFDjfxj
         JyWO3DUYJOrEPrl8i60Z8okvees7jFlhgdehTcf4gGZt8yUBdHBiPihD+J2K9qeZZeMT
         NVtQJ0ZGfM1gQZaynMBCAJxAHAvX7DZXju3u5ajh6AGNDcjFRZYU+ffxIqgxwckAGy+F
         qLUx7HXfI/RkZj8e2P+So1FhVxwd7F2GZJt5X/9PfTX992GJoFz+Z2665DY4ZdWT5HSq
         R9TZTUWTjacbD5MtHJqzb6lD46xoi6QCQlUfcVhuucnHEGOd4KXfcEf86kOzWZxx5PEO
         I5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UK2Im1BEXAy6ijd16h4AX9V+lLFWq6BP9P20yLZbsYA=;
        b=bbW5NoEiUVL6CsQtBEKIdWt9TldTKbEaARmdk6t69WRtXiX3sHLSUSwSi94LqbflXk
         OWH0iVuZDs1gpMwpHw5/skbCq6Pq4Fmx/kjXLmyEPgGWnxGArDVhalx5bJNZJLaImPn4
         ztiIkDn09CnkWyyXPD4vB+Xew/loqH/LlE9rA9XgR0ROA7j2wz9dmIDD81PvqEEgINm2
         LQW+lMEgHsc91LkRC62p0i0IwH/bEr2hb5HtpsqvIvWlWRKopqx3nID3pCojJ2cNJYkr
         kPETSJcyx2wsJvwrD5kcUuEjJaKYlq3GVP6wp0L+kjrrJqqO0GnulPXqnJhvC2644WBL
         ga5w==
X-Gm-Message-State: AO0yUKXubeF2NHFjo8hCItoWI+hlhbv2FJuwyT6cyHpsSQYMX7sZaffL
        GLgjxjoIfFneKI4n2B8qv+VESrr2hw1O0nXkQItU8YUFv0ADKz0zvL69ANlSluhvd1yM7bWmeit
        bgilOFwAVZoI6LT5qxeOCAHD+/nfIUqNj5rMBq+OCyq+QfOPlxFouubU9yZcUzzuH6h9Z
X-Google-Smtp-Source: AK7set9bXx49vs62zVddXNeWWmvc5NVRdHr8tmDVAsz42P6OZJ4nEN7bNBXowXqRZ+S6//CJUqNqZWbW1LckHTu2
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:3302:b0:19b:20a5:c18a with SMTP
 id jk2-20020a170903330200b0019b20a5c18amr3545113plb.12.1677278225236; Fri, 24
 Feb 2023 14:37:05 -0800 (PST)
Date:   Fri, 24 Feb 2023 22:36:02 +0000
In-Reply-To: <20230224223607.1580880-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230224223607.1580880-4-aaronlewis@google.com>
Subject: [PATCH v3 3/8] KVM: x86: Clear all supported AVX-512 xfeatures if
 they are not all set
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        mizhang@google.com, Aaron Lewis <aaronlewis@google.com>
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

Be a good citizen and don't allow any of the supported AVX-512
xfeatures[1] to be set if they can't all be set.  That way userspace or
a guest doesn't fail if it attempts to set them in XCR0.

[1] CPUID.(EAX=0DH,ECX=0):EAX.OPMASK[bit-5]
    CPUID.(EAX=0DH,ECX=0):EAX.ZMM_Hi256[bit-6]
    CPUID.(EAX=0DH,ECX=0):EAX.ZMM_Hi16_ZMM[bit-7]

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/cpuid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b2e7407cd114..76379a51a16d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -68,6 +68,10 @@ static u64 sanitize_xcr0(u64 xcr0)
 	if ((xcr0 & mask) != mask)
 		xcr0 &= ~mask;
 
+	mask = XFEATURE_MASK_AVX512;
+	if ((xcr0 & mask) != mask)
+		xcr0 &= ~XFEATURE_MASK_AVX512;
+
 	return xcr0;
 }
 
-- 
2.39.2.637.g21b0678d19-goog

