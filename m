Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DD169E4DC
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 17:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbjBUQiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 11:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234780AbjBUQh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 11:37:59 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E3B2DE4C
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 08:37:36 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id lm13-20020a170903298d00b0019a8c8a13dfso2603024plb.16
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 08:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zK45IqxP1dNnwcbmnxiq3xISvws3WCC9xNptFeG9RGY=;
        b=Gat5zcpIdqxDUUs9rI3U/ZnYNeRDCgoLyPWphjHiI0NoTTfVzwEtdYFnegIry5t6Bp
         whgGCn3+2SGGQhoJ/Ak0JM25nAjVuGShFnUeP746rfB5ELk7VYHyBlGXNw+bWuGAbNpU
         Z525o6MWE7QbLXs3z2fVNZ4J51w6z4iKnak8a42nQwmn1v8qeLPWnihkqbYvcUxT7vhr
         giL415jit6jUW/p7Vpsl22Ngx/8PNouqTuGxAAKzF7lGNpwMdmK+XhAKYNCUkyIcIerb
         qLTyR4Yo/3lE6VnJT37dMOAG6/ZJdYn60tzqrpczNKX16BB4mcEUoWRZAguwPrJANmUd
         Ry7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zK45IqxP1dNnwcbmnxiq3xISvws3WCC9xNptFeG9RGY=;
        b=jOFNYO4fZuZqNS3slpqfL+3XKSSE8MRZaR+hwCxrbbdlKUxqfN6NK5rKU7hO8udj2i
         1JvJrd8UTQ9BpsxKWKalrCwccbunPrZmTFeJCS65Td1Coxnsw5vw3OQdqzG0WhnCGELw
         fnbP26zYctiIjZka5606HSeD2qKbQrHPO3nxCUvBt3K14LUQL0du7IeH00J/tcODgtrb
         rT68+OUxBrHErT8QibAyZYze/jMZnNf1PLWU5edmSrkK9md2tJDea0K+oHEMhrST8mU4
         wxzepfOa+CdFDuALESH9oJJLVZRFW5hEQXf2Sqkptni1K1uy7V3bCsIEKWLm1d4Lmuv7
         qC0w==
X-Gm-Message-State: AO0yUKUPsTSmtxAow6kvktWGygMzHuAfgdMDkViDXSO1z6vHXYHfzSK2
        nTNdCcrCEsFckpd/t5LBn1+kExOLhafZ
X-Google-Smtp-Source: AK7set+x/m6cFFW80guHk8IlWuUdvUqC/N4oLPQVmmgR4cwzKWJ2ArdlnfautVAaiE3SLYGPvp+vL45F6igz
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:450a:b0:593:d27e:10e0 with SMTP
 id cw10-20020a056a00450a00b00593d27e10e0mr792249pfb.3.1676997455081; Tue, 21
 Feb 2023 08:37:35 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 21 Feb 2023 16:36:52 +0000
In-Reply-To: <20230221163655.920289-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230221163655.920289-1-mizhang@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230221163655.920289-11-mizhang@google.com>
Subject: [PATCH v3 10/13] KVM: selftests: x86: Assert that both
 XTILE{CFG,DATA} are XSAVE-enabled
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Chao Gao <chao.gao@intel.com>
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

From: Aaron Lewis <aaronlewis@google.com>

Assert that both XTILE{CFG,DATA} are XSAVE-enabled.  The original check in
amx_test only ensures at least one of the XTILE bits are set, XTILECFG or
XTILEDATA, when it really should be checking that both are set.

Assert that both XTILECFG and XTILEDATA a set.

Fixes: bf70636d9443 ("selftest: kvm: Add amx selftest")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index d1fbf8936192..1a1565126255 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -161,7 +161,7 @@ static void init_regs(void)
 	xcr0 = __xgetbv(0);
 	xcr0 |= XFEATURE_MASK_XTILE;
 	__xsetbv(0x0, xcr0);
-	GUEST_ASSERT(__xgetbv(0) & XFEATURE_MASK_XTILE);
+	GUEST_ASSERT((__xgetbv(0) & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE);
 }
 
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
-- 
2.39.2.637.g21b0678d19-goog

