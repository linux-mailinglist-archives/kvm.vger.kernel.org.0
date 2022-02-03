Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14BFF4A7D7C
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348831AbiBCBsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiBCBsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:48:23 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9C9C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:48:23 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id v70-20020a25c549000000b006130de5790aso2983045ybe.4
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GtZafOF62pCH7huoD9Mf+yd0DLeYABoGGaP8QcYy2Rw=;
        b=d0j444ydp+CI0bMwgBkGUvLFAgCUatXmp1budL88FZR6ft+agOpYvZ9U5VQa/EVC+N
         EiXWkPXCx5x8MA05JwxSGJD02GlDHCTdcH/MKSCooSgBtOZAYq2N9zHEz2VxfNgemy2Q
         KMtAWKMK0Eiuy1GGzpO/HSF1lg4jv97s1w6IXcjBdohtXpaW839pMrulzh8pZq9k3WST
         ZnLYHRIxb0L0AiP3dCOY5XyyNiv+d25t19TCYTczHhl3HA6v+f+g/fEIvQb57zSBylXH
         Pp0JymZpx3k5K6NWkvsQxenjEy1VvKwsaPxWXrIwG9D2OcMoUvB2az27gmD1mRZ8whcK
         zAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GtZafOF62pCH7huoD9Mf+yd0DLeYABoGGaP8QcYy2Rw=;
        b=dacyoNbJMw/L9Yp0x4T2U7eyXuCz9RNjo5oNBetH7z1VALdeBqEkkp6xvhw1y04wLr
         2hhUYazTVaZRHOSQahQFSeFzP3bolPOQYgFRecOPPI6L7XG5sXOFJ5XKqf7eZpXYT4XN
         mbWwj+inYXkAtf2ME8wz+YDG6l0bRyqkHs60MeDNKfF83PtYtAUwIjFAjqwfxVMwvqOm
         HZNggW0XdRoOw5OoYLHw8iVj6nwT+82vpAWj0L2uDXL6AmukSCRHfWgvDFzOVR9TKTqe
         eWFGvXEqteS53uXnoSf6QDnbWkcV8l8wBNfgJTSpToPVx5K5SFULJK/DA53MyPT2RzpM
         9Xfg==
X-Gm-Message-State: AOAM531GwJVr1/0S81A/lk9u9Tt+YjizIwwxtmS2UtWoMvOKqPiZQ4qJ
        YyVs+EQn//EAk2ELYhIkbW14ylOZrJPvzJhONGfo3+920JNE6qDUxS7FTlJKKlUrutk2/AxlhCh
        /i9QiToYhBsjUO2XPbqHjdVfCOVSWm2AW9Syh3AvHAp+1XI28w2FMJMgHEMmij/g=
X-Google-Smtp-Source: ABdhPJwmogZ4xZMBdwCht7hhjoDxC0HF3lO9Ja5kNPDSI6+p/M8Ysvtb+3hgdkRVaNzIEMu0u8oCCcN9LlFc1w==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a25:af87:: with SMTP id
 g7mr45291869ybh.203.1643852902279; Wed, 02 Feb 2022 17:48:22 -0800 (PST)
Date:   Wed,  2 Feb 2022 17:48:13 -0800
In-Reply-To: <20220203014813.2130559-1-jmattson@google.com>
Message-Id: <20220203014813.2130559-2-jmattson@google.com>
Mime-Version: 1.0
References: <20220203014813.2130559-1-jmattson@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH 2/2] KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD's event select is 3 nybbles, with the high nybble in bits 35:32 of
a PerfEvtSeln MSR. Don't mask off the high nybble when configuring a
RAW perf event.

Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 80f7e5bb6867..06715a4f08ec 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -221,7 +221,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	}
 
 	if (type == PERF_TYPE_RAW)
-		config = eventsel & X86_RAW_EVENT_MASK;
+		config = eventsel & AMD64_RAW_EVENT_MASK;
 
 	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
 		return;
-- 
2.35.0.263.gb82422642f-goog

