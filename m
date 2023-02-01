Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380D1686F22
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 20:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjBAToh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 14:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjBATob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 14:44:31 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2357D986
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 11:44:30 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id me3so54640618ejb.7
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 11:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4WIfgFu7sWBxHubiDa704oZ6rZ4jmUPQhefB2XMq/DY=;
        b=HWSMoT32VGWmMlCTrhxHivAlxKAAZNSvyoygy4yjRPBu0W4L15o7HIYq85B7iah+I/
         Z8PNyxMMnBzbh7df65L7txwlSvM4GY0KOAyEkXIRwH8BLecSy6HwHBBKPhcgTgPAMoXz
         o8jExm4r5vV/LZ4W32jN8QUXeTT5lPMYKcMsECiA+wYAsgkZbKBlgdHyMu5TTxk7DODO
         dPsPPeEqIoqS9WC9kReJaacLryNx8eM9ZTa6zlD5QZvG1kHwckHUNEolVKTlKaSBPWzQ
         d7qoDWqz/ZNeISAZOGJnH1tCuM7GVVaOIFg7s2fTi1gNcWU4FkXs9x4IPupNRMhT4NDM
         b8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4WIfgFu7sWBxHubiDa704oZ6rZ4jmUPQhefB2XMq/DY=;
        b=HvqChR7NgjQvhUjG3wsARhYykAM6hWvSLicyVuJG/oYI+K6UjJuWcmB0gMJO0bU8F+
         VBnNJILq+Z480iSl/G3xiQqzP7M1NTCqxvwnK73oBqnV6M+VKwCFvWT++aeAX+N5GAay
         IT9wAVDtGviQjR12/M2Wl9JglS8JA0UWMDLfu5u/kKNeWq/OLJlb6LnpCGq2t8zsUtzn
         KlBOilBh30ladynPti2A0hA0w2rC1nFKZudRv+EvatSSb4ctd7Y3Lbu8HigHOLwz/Ur4
         /lD4fL015ke8fQKGRfrfKsl0af0+xKAzbDN8ua88JkskaLRjGIlxLlti6LLM3im627Jm
         7Gag==
X-Gm-Message-State: AO0yUKVmwlfQAxVo+cfaYEJWSdqFJiCpwrbfb/bL4nG9xZVVTffj/XGp
        zMvpirnJeFV/YT6b4EHyEyYHH26S/W5zFJusHak=
X-Google-Smtp-Source: AK7set/ywQ2ewoJPFz8eXYB+A/CbDDxQByUaY0mydA0gVNfFG5Fk7tFrMcHQkPuLvpyohPEn+SX5yw==
X-Received: by 2002:a17:906:8281:b0:862:11f6:a082 with SMTP id h1-20020a170906828100b0086211f6a082mr3412157ejx.17.1675280668753;
        Wed, 01 Feb 2023 11:44:28 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af111a00277482c051eca183.dip0.t-ipconnect.de. [2003:f6:af11:1a00:2774:82c0:51ec:a183])
        by smtp.gmail.com with ESMTPSA id c23-20020a170906155700b00869f2ca6a87sm10397579ejd.135.2023.02.01.11.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 11:44:28 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v3 5/6] KVM: x86/mmu: Fix comment typo
Date:   Wed,  1 Feb 2023 20:46:03 +0100
Message-Id: <20230201194604.11135-6-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230201194604.11135-1-minipli@grsecurity.net>
References: <20230201194604.11135-1-minipli@grsecurity.net>
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

Fix a small comment typo in make_spte().

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/mmu/spte.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index fce6f047399f..95441ffdccc8 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -164,7 +164,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	/*
 	 * For simplicity, enforce the NX huge page mitigation even if not
 	 * strictly necessary.  KVM could ignore the mitigation if paging is
-	 * disabled in the guest, as the guest doesn't have an page tables to
+	 * disabled in the guest, as the guest doesn't have any page tables to
 	 * abuse.  But to safely ignore the mitigation, KVM would have to
 	 * ensure a new MMU is loaded (or all shadow pages zapped) when CR0.PG
 	 * is toggled on, and that's a net negative for performance when TDP is
-- 
2.39.1

