Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D6B694CE8
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 17:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjBMQbw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 11:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjBMQbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 11:31:48 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849251DB9B
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 08:31:41 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id by3so11547538wrb.10
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 08:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M1IcDb7o/gYGclSpaFMTR0Z6rRoV6K10f7w16ZZ0sHg=;
        b=EAEv2qg0oPGOf8z7OLWgmMYZJNXgIakX8VzrnhYE0qmI1XNlgtTc3jEmA/zL/eEPvH
         7uzW8RC5fI5YNdFUjtulJwA6m35Izs+lVhJxM/E8UMzi3lyI6YMUOFRNvq2PbHDWM0pj
         xXOjGoHkZVrFDnR9XkCG60Za8tTWfWHE74nnFCoMMmUoauismMhg5jDSCdbB5/cg2VP5
         MnyEV8WBnfel0PY3ANXLB8kBPhRREzFAekvWpOJBxyuVg6LuDGsJP3PTun0H+P59/vuT
         GanQZqrhhBygyaIs/m/PiJyxCUa68RmyjaVB/daFvEcM2qIdrXvadBqvFIWCtjqb13TJ
         pSNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M1IcDb7o/gYGclSpaFMTR0Z6rRoV6K10f7w16ZZ0sHg=;
        b=LSbl+E5QtRlyjW7iZ6OopiVz+1LWWU8DKWJ+X9vN2is077Zp9JpUC8Iccv5loWNzX4
         lOPVN/M2i5Dd110lolemUlaRzIPEcFVoBQYMS+zA1Uok+o2cgTYvtMKEeOm7THMtB2hV
         D9O4a7g6W+5NuDYaruRX/bbjzJi/FIT3H22u1WJG6e/8CuTv34a3CD0WpdzCBRTMF/Wv
         gNwhg2ZzA7OUF8VyxOVQruW3eLU/VFxUWomJpIYva1CzjhEBtDzkpuy4VCUgykysysus
         u2CvKf1CeX/fRmvcVgF1sYueGOJn5+6cDw+QbWa88KqeYgb+0gfv2siEvRaxH0UfaKAj
         0Vjg==
X-Gm-Message-State: AO0yUKX8abo6O1pUQXHvIcaxS4fgCdgSple2tbdcFkG/URQDt3LIfJ0p
        NxAaI5P4DNTsl8irYk/Q3/kiPzRPGEn4pi4z
X-Google-Smtp-Source: AK7set8Be25w1kAQrFs/TZMjM7YKuMUvrTyRkn7GIaX1YpI8Knwb5rHxJB2D8ZxX12VEmSt4OEc2NA==
X-Received: by 2002:adf:fa04:0:b0:2c5:59e8:30cd with SMTP id m4-20020adffa04000000b002c559e830cdmr2574422wrr.9.1676305899993;
        Mon, 13 Feb 2023 08:31:39 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af2efd00225e3e97da45b943.dip0.t-ipconnect.de. [2003:f6:af2e:fd00:225e:3e97:da45:b943])
        by smtp.gmail.com with ESMTPSA id s7-20020a5d5107000000b002c556a4f1casm3877993wrt.42.2023.02.13.08.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:31:39 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 3/5] KVM: Shrink struct kvm_mmu_memory_cache
Date:   Mon, 13 Feb 2023 17:33:49 +0100
Message-Id: <20230213163351.30704-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213163351.30704-1-minipli@grsecurity.net>
References: <20230213163351.30704-1-minipli@grsecurity.net>
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

Move the 'capacity' member around to make use of the padding hole on 64
bit systems instead of introducing yet another one.

This allows us to save 8 bytes per instance for 64 bit builds of which,
e.g., x86's struct kvm_vcpu_arch has a few.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 include/linux/kvm_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 76de36e56cdf..8e4f8fa31457 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -92,10 +92,10 @@ struct gfn_to_pfn_cache {
  */
 struct kvm_mmu_memory_cache {
 	int nobjs;
+	int capacity;
 	gfp_t gfp_zero;
 	gfp_t gfp_custom;
 	struct kmem_cache *kmem_cache;
-	int capacity;
 	void **objects;
 };
 #endif
-- 
2.39.1

