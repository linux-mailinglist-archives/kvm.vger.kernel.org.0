Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CC569B529
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 23:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjBQWAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 17:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjBQWAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 17:00:19 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169FD59736
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:00:18 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536587ff9e1so18719277b3.21
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XyL5Bx8sLnyrbUv2Ja89Nz0/VW7yUTYVKDiYHW4EV4g=;
        b=pdpWancJNNWBQwlIi1TswPWWLHJFMi64yUqtvb+TTPHpfMJxSeyHsiUtfXMTyPVflF
         oZx/NJIDKjJfDcoSOKrOZ9/EReZy8yr3Rv39vLFIYBSZawrJ8Vudso1LgeafLNKUfBR8
         d3s6PKwGShQYU/Y6o3hQIj6jEBtpQGklNVy0ckdWKJd3D0L7Y3cZZrDyyzTokiwU0FiG
         IFZRbg1EK4rkfnHoQKqRVeJGFUG+8FrwiTOGgyHrZ8iiS0Ull87kHJaV6Fe57HY/BMKz
         iYue+YIE9JfGTb4OqiD3ZoyjGFamZc1dfVROb1s/v722Mn0wv9wC90nr9+Sx/tHjySTP
         Jiow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XyL5Bx8sLnyrbUv2Ja89Nz0/VW7yUTYVKDiYHW4EV4g=;
        b=tRHpfQ3X7ve0G189D7xtiQjOXTYw3UCx9SuwVzD+GrGSsxriXNBSSVHvO//9UE2oe/
         d8rQ3aDDIRZv64IsUc3Qp2RySZW0VZkd/kz2+gm8Mbo+9ma7Xt36m3DjzkzD9gyTkYtR
         FrPs08/0faWXJkY0FxywJcLnmAq/9nChIXog6m8dfnIkxo8VMyJPqarn5OCYwDILvj8t
         2lJEcuiS7maeUa5k3nLSCIQ3kdm/CEMfEqecLoub5yq8YWZyJurhvxBfOLjuZBp7FbBH
         mKfBTMlNhwV7spBtmkxeWHugM1exXbD+OyNve+JnehPm2ZcOxnb8PRUyzF4eRsj+vU5H
         OQUQ==
X-Gm-Message-State: AO0yUKX0zO1gNe8x8+F5zEG6Qu31pDjQQqgKo10DUFVeUKAY8/bR8wFr
        vIhbTd1q2mTb+Jq+4BLqoO+lDRhAcoMgBfMft0JTOlqEKpq4czffFuHlYMF0j7xLFniFAbnP3u9
        HLHiIDv5CSc5Gu2yK8kPai+58+v40LtBOy6tuCEnZJtp/gyPC5W2GQECnVBvVWz1hQRNA
X-Google-Smtp-Source: AK7set93DCd+2lLh0TGvk09rvo2bqSwP2j1Vr54YGm/qlGS6hWySCohHtd9xUtGLoi5sAKJL3LfHffsTVqvT9s6f
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a5b:108:0:b0:8e3:bd3:3674 with SMTP id
 8-20020a5b0108000000b008e30bd33674mr215730ybx.8.1676671217149; Fri, 17 Feb
 2023 14:00:17 -0800 (PST)
Date:   Fri, 17 Feb 2023 21:59:58 +0000
In-Reply-To: <20230217215959.1569092-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230217215959.1569092-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217215959.1569092-5-aaronlewis@google.com>
Subject: [PATCH 4/5] KVM: selftests: Check that the palette table exists
 before using it
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

The maximum number of AMX palette tables is enumerated by
CPUID.1DH:EAX.  Assert that the palette used in amx_test, CPUID.1DH.1H,
does not exceed that maximum.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 1 +
 tools/testing/selftests/kvm/x86_64/amx_test.c          | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index c5d062cf919d0..8211b9de6e7b9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -208,6 +208,7 @@ struct kvm_x86_cpu_property {
 #define X86_PROPERTY_XSTATE_MAX_SIZE		KVM_X86_CPU_PROPERTY(0xd,  0, ECX,  0, 31)
 #define X86_PROPERTY_XSTATE_TILE_SIZE		KVM_X86_CPU_PROPERTY(0xd, 18, EAX,  0, 31)
 #define X86_PROPERTY_XSTATE_TILE_OFFSET		KVM_X86_CPU_PROPERTY(0xd, 18, EBX,  0, 31)
+#define X86_PROPERTY_AMX_MAX_PALETTE_TABLES	KVM_X86_CPU_PROPERTY(0x1d, 0, EAX,  0, 31)
 #define X86_PROPERTY_AMX_TOTAL_TILE_BYTES	KVM_X86_CPU_PROPERTY(0x1d, 1, EAX,  0, 15)
 #define X86_PROPERTY_AMX_BYTES_PER_TILE		KVM_X86_CPU_PROPERTY(0x1d, 1, EAX, 16, 31)
 #define X86_PROPERTY_AMX_BYTES_PER_ROW		KVM_X86_CPU_PROPERTY(0x1d, 1, EBX, 0,  15)
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 9772b9fb6a15f..ab66a51228fff 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -30,6 +30,7 @@
 #define XSAVE_SIZE			((NUM_TILES * TILE_SIZE) + PAGE_SIZE)
 
 /* Tile configuration associated: */
+#define PALETTE_TABLE_INDEX		1
 #define MAX_TILES			16
 #define RESERVED_BYTES			14
 
@@ -124,6 +125,10 @@ static void check_xtile_info(void)
 	GUEST_ASSERT(xtile.xsave_size == 8192);
 	GUEST_ASSERT(sizeof(struct tile_data) >= xtile.xsave_size);
 
+	GUEST_ASSERT(this_cpu_has_p(X86_PROPERTY_AMX_MAX_PALETTE_TABLES));
+	GUEST_ASSERT(this_cpu_property(X86_PROPERTY_AMX_MAX_PALETTE_TABLES) >=
+		     PALETTE_TABLE_INDEX);
+
 	GUEST_ASSERT(this_cpu_has_p(X86_PROPERTY_AMX_NR_TILE_REGS));
 	xtile.max_names = this_cpu_property(X86_PROPERTY_AMX_NR_TILE_REGS);
 	GUEST_ASSERT(xtile.max_names == 8);
-- 
2.39.2.637.g21b0678d19-goog

