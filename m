Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E2E696D3F
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 19:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjBNSqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 13:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbjBNSqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 13:46:38 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF39E303DD
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 10:46:30 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id y9-20020a1709027c8900b00195e237dc8bso9611240pll.13
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 10:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6RZ7TspMKDDk7tmMAFyvIRoGpdz/k0McGOaNtuOXScs=;
        b=mHLMbcVVgMDEwYayJ9YUqi2Dw/jj0GYAjAZKWXI4WKsLDy/gyCPJJ0nf7Qy2PNmSyp
         k6KjMqwph6digoMqvido6AvIDuV+z+trxmm7HluclADFe1vYGJfovo80iN7x5D3Ni8aj
         RncvhqsMaqT+sRK+wYRVHs8u94Y6vhKS4jWU3AHQmyXPGprS0/tuVqk08DitnA0wlGWg
         VSfm0DI1b1QvgzpNC7HkBN6EaboH9RGMY5tCaCfxK3sq0IOjGdLvYMfEtrW7q0L9ADrb
         rNGLC+ah7weJiVsJSeqmbOjqWuXkrRTroxPUja7wHZgIxhi2NRChj/KcnUDNyRnb9GNe
         aQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6RZ7TspMKDDk7tmMAFyvIRoGpdz/k0McGOaNtuOXScs=;
        b=XcWyFBtyRtSijq/MiCSeeJMKOjRD6PBij0DU7HnW7BlmdxrVDLMWDju4Rcz9tJqtRd
         r5ypOnnjIJG6JdXgMJJaAfXbvfveIJz3xRVG/2QPzRIcXoh25RHHzn+ydylOO3MqSJ9i
         dvwqrEBTql1vNPBlG0Yh/Q4ZpiVM2mCH8YFmVu8QsnNKRUDp/Cwe2zSFV55galYK9ghv
         QkhNqhunbPxiwIdSJeQGnxtuWhVxREIrMBC6+KPhDiOFCAC8PIxCxmNCXZjYNtUvyPqM
         WHIOqd9O7bTQJS/rfxx8qfErqFGcEmqas2GU9qNTWzPZqIkzoZR+O4jlNxyPaEyY7rLx
         xX2w==
X-Gm-Message-State: AO0yUKWgDO6XQAnRi/TJNzyk4+Ks0WaYkrCEeV7Wv1TDW97or+JqMZDo
        I1E1bgD9GlN8bheaD0gOA9az05H19DLl
X-Google-Smtp-Source: AK7set/dCoOrkzvEF9g82ilEvxmu8NS4Fkw+W9zyWTu/n8cDaqHWmQp5aPVWu/ReyfWEMU8QXVaMyzvYJTPx
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a63:3855:0:b0:4fb:d300:c637 with SMTP id
 h21-20020a633855000000b004fbd300c637mr63299pgn.6.1676400389768; Tue, 14 Feb
 2023 10:46:29 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 14 Feb 2023 18:46:05 +0000
In-Reply-To: <20230214184606.510551-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230214184606.510551-1-mizhang@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230214184606.510551-7-mizhang@google.com>
Subject: [PATCH v2 6/7] KVM: selftests: x86: Enable checking on xcomp_bv in amx_test
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>
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

After tilerelease instruction, AMX tiles are in INIT state. According to
Intel SDM vol 1. 13.10: "If RFBM[i] = 1, XSTATE_BV[i] is set to the
value of XINUSE[i].", XSTATE_BV[18] should be cleared after xsavec.

On the other hand, according to Intel SDM vol 1. 13.4.3: "If XCOMP_BV[i] =
1, state component i is located at a byte offset locationI from the base
address of the XSAVE area". Since at the time of xsavec, XCR0[18] is set
indicating AMX tile data component is still enabled, xcomp_bv[18] should be
set.

Complete the checks by adding the assert to xcomp_bv[18] after xsavec.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index bd8bd9936f8e..0e4c65f9e2f2 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -197,6 +197,7 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	xstate->header.xstate_bv = XFEATURE_MASK_XTILEDATA;
 	__xsavec(xstate, XFEATURE_MASK_XTILEDATA);
 	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILEDATA));
+	GUEST_ASSERT((xstate->header.xcomp_bv & XFEATURE_MASK_XTILEDATA));
 
 	/* xfd=0x40000, disable amx tiledata */
 	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILEDATA);
-- 
2.39.1.581.gbfd45094c4-goog

