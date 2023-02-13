Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10E3694CE1
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 17:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjBMQbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 11:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjBMQbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 11:31:47 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEEEDBEE
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 08:31:39 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id m10so3950668wrn.4
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 08:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3qVJ0bF2LOwR9FYE4JKJYonbraLFt3EzjvQr+HEt5I=;
        b=liepqDU8BjQRRlqGydEYdx93GNpUuRUB4f8PDXBkqBGH0W6S0XWpBVYCZsc9iErDlS
         fF+K4LR1GHvjQnpF97bj/CVsvnrKoJ523VRQayK+4FQ7p1fY2/qYxbtJBsMNefPNWGKN
         XA13eaXGPssEhfaDk12KteXLktoHVOBNblEcY/nfGVKsN2sGa9yaPvAtmd/psdS1iQAT
         E2sx58UlnbcY1v+x8cApav0t2D/1s4vjuSakMZuzpx9Mys26KSYeBriJ9kqLXl5Xgw67
         oNYZqiPvoHBjCx4Xivs0PRtVRLTvZt6YolFwluFRmg/D3UgEr1RSKjW/o2UsOVlxLsIc
         /z6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3qVJ0bF2LOwR9FYE4JKJYonbraLFt3EzjvQr+HEt5I=;
        b=SVjqgNR7qtq85PyZaVXbp1XeoHhxCi5lz8mBZNaE1KPoa6F+F0Dqb/iJvlG9mB7dzl
         IT1DSAPGSVLZ8AMWhP3dEtwEq9KZ86kkm9iwR0xgr2TPXLY3C0GG8x4n7qVoOtNM1uKd
         livp0gtxRHrOf4fiUT9LIQN5/hMgFdornnXLArKLQU90j/0MwO9wz7wydcEizBiyYMGI
         LQvdwkgpvcn70KNl3RX0dgz26ltxVAfGaEq/7DHiLZWoanFddGydgagHDddu/ioqEBcD
         9QqKH09ZqBbK3hwm2l2sPzGdrfYLeWvWYBK+M4u+dsSJMZ0BORrDnItzDWIMkdMHvN6V
         7v6w==
X-Gm-Message-State: AO0yUKVYMCO/qUA7BB+JrvkHKZDAxTDFXYYcl774wgO7rd4Fj0UEPnms
        U3tHO/JT/CaeJsGoY2jaoVoqDSB7exbscdyW
X-Google-Smtp-Source: AK7set+FMQGnQbionigXPOFcaopns6mx0RcJpp4eRSZlla6ji1UnvYJa5YnaE4tdUCm9h95vyrTvRw==
X-Received: by 2002:a5d:42c9:0:b0:2c5:4f29:c103 with SMTP id t9-20020a5d42c9000000b002c54f29c103mr7902079wrr.52.1676305898353;
        Mon, 13 Feb 2023 08:31:38 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af2efd00225e3e97da45b943.dip0.t-ipconnect.de. [2003:f6:af2e:fd00:225e:3e97:da45:b943])
        by smtp.gmail.com with ESMTPSA id s7-20020a5d5107000000b002c556a4f1casm3877993wrt.42.2023.02.13.08.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:31:38 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 1/5] KVM: x86: Shrink struct kvm_pmu
Date:   Mon, 13 Feb 2023 17:33:47 +0100
Message-Id: <20230213163351.30704-2-minipli@grsecurity.net>
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

Move the 'version' member to the beginning of the structure to reuse an
existing hole instead of introducing another one.

This allows us to save 8 bytes for 64 bit builds.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6aaae18f1854..43329c60a6b5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -516,6 +516,7 @@ struct kvm_pmc {
 #define KVM_PMC_MAX_FIXED	3
 #define KVM_AMD_PMC_MAX_GENERIC	6
 struct kvm_pmu {
+	u8 version;
 	unsigned nr_arch_gp_counters;
 	unsigned nr_arch_fixed_counters;
 	unsigned available_event_types;
@@ -528,7 +529,6 @@ struct kvm_pmu {
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
 	u64 raw_event_mask;
-	u8 version;
 	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
 	struct irq_work irq_work;
-- 
2.39.1

