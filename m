Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E35672043
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 15:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbjAROy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 09:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbjAROyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 09:54:03 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CB01C318
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:48:53 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id w14so32609163edi.5
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 06:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6W0pZJ6ERcXnvSOd8zNWpB3EIqXZWM69qX+jHbVTMc=;
        b=IBT0qj/RPtCvkxVkBIfHYd7QteXzIP67i647IqhTBlkd71McZh+opt3wap1cZCAih3
         qyu/DTKBwBL6nJT2BGjW5K+gPq+wjvxNqGY4YPXwZLTySKFOF+VSovv5xJ7QsXwxK3y8
         Q4c1c+jL2v1+8AQPHNvhgpgZInBCLehbKZ/7FKuYASFL00ghpeud/Qriwg/I3m+4SBAg
         AM57y1MJKZI7tIx14X5KraP3NJ0/u8reJ3vBvZhwAfMvVJ8PPRnegZh9Na9R6sWEuY0Y
         TiIys37zs94rkWlC81Vy9Hk1Sl/tH8OJSvrxfjuhAjZ2t0PaqTX3Ke3cW1I7Uw0NweEg
         E4Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6W0pZJ6ERcXnvSOd8zNWpB3EIqXZWM69qX+jHbVTMc=;
        b=L4X/G4yqPrGODviqmrPivhrZEymBn/eXcr6RVXECgnZ0SnkHByRyI0vuyCaDXFn0Nr
         mqcdQrP1Z6OZ49K6dAW2lFTsQGPCH2yV6W+Z12ZanKbQXE5mTzTCRjzoKT0JsShgUtPi
         UH7lcx4/lShqKnf22HD8mrzxGtIiDNdWazk2suIPBsJykUxXNlI1oE6rKsA75WrudXfo
         OOddcm/nrLqPwcxpuVhusN0wty6iI/3+KZ8pd46sxo6AvJiG2RpHESMYtM1nrlan8/Fq
         h4wxZGL1sCZZif0anHC26MG4BMoye87iMeWUUkw2Q2NGuoIMdmGlSyInvfkv2avmSMP0
         L4lw==
X-Gm-Message-State: AFqh2kqgH6h7fOQMa2S7PbfzJtEpZVKbdzI/k/3TwrB48Yoszt2kKaTm
        Er3W9hla7eghJ2XtsS6Zc9Fpbaha9I0l/oMv
X-Google-Smtp-Source: AMrXdXtppojCwB78sS5kdfJaEsCFQeirzrmEFUA3pTLC71BZn/8fPScn2OIOm+zqjicgcf0NIlV1yw==
X-Received: by 2002:aa7:cb01:0:b0:495:fa3d:1d72 with SMTP id s1-20020aa7cb01000000b00495fa3d1d72mr7477248edt.8.1674053332042;
        Wed, 18 Jan 2023 06:48:52 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af03d2006e0fc0b921f9db5c.dip0.t-ipconnect.de. [2003:f6:af03:d200:6e0f:c0b9:21f9:db5c])
        by smtp.gmail.com with ESMTPSA id p11-20020a05640243cb00b0049e19136c22sm3627509edc.95.2023.01.18.06.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 06:48:51 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v2 2/3] KVM: VMX: avoid retpoline call for control register caused exits
Date:   Wed, 18 Jan 2023 15:50:29 +0100
Message-Id: <20230118145030.40845-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118145030.40845-1-minipli@grsecurity.net>
References: <20230118145030.40845-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Complement commit 4289d2728664 ("KVM: retpolines: x86: eliminate
retpoline from vmx.c exit handlers") and avoid a retpoline call for
control register accesses as well.

This speeds up guests that make heavy use of it, like grsecurity
kernels toggling CR0.WP to implement kernel W^X.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
SVM may gain from a similar change as well, however, I've no AMD box to
test this on.

 arch/x86/kvm/vmx/vmx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c788aa382611..c8198c8a9b55 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6538,6 +6538,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		return handle_external_interrupt(vcpu);
 	else if (exit_reason.basic == EXIT_REASON_HLT)
 		return kvm_emulate_halt(vcpu);
+	else if (exit_reason.basic == EXIT_REASON_CR_ACCESS)
+		return handle_cr(vcpu);
 	else if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG)
 		return handle_ept_misconfig(vcpu);
 #endif
-- 
2.39.0

