Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0AC7085F4
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjERQW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjERQWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:22:18 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CE210EF
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:01 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6439f186366so1638988b3a.2
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426921; x=1687018921;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2CmyEkggETxM6j+XfIPwTDc2gU78hVyVqaTRQMELVN4=;
        b=AHgrGM3jlPNTSTiBOZXW97pWonk960v7FCpKkUSFO/Y9Nn3G9p9ifI4xumGalBeD8a
         ye8dx3J5sseaWNgTc1TBQ7/a6nk7QMlGOlqzMw6kg+gxxAkK+3l1DMvdTf1vk6fhg6OG
         oztqOYqxmsS2pUFQlHThd3wa/fD7Q3CCR6R3K8I57MHd5LkfVpOv+ruiHpZujgdrEUbC
         3gWDPmYGpAEeAgbphIJo5F1qtYBcSAxzbpC0GNT/QYDn7G9FDXkdkW8XdeZDPkJOyVEF
         bikoNET83RWv57aiVG/MG45EkIUd7gwBDGYmy5weNCoTa90jf9OSsIgefh06scr1ZJhc
         zGTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426921; x=1687018921;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2CmyEkggETxM6j+XfIPwTDc2gU78hVyVqaTRQMELVN4=;
        b=KwUTlaJ8I+lEnoirj+liwQUb8eI4Cp/wWUxHE/6izQ5tlYCBjfgCgaibR9rb8Yc9Ix
         RJYq/4x7459rYj2Fam9ZAo3pNOA5ds5mY1DJPPOnLRoATSMVkmn/mMvdNQWoQdBv8cgo
         M8yK8snJfEBkW9foh+mhrCrtmOsaxXqLLMpoVd35TGdB3PRaSSjzZm22AgrMlJ8sfu7r
         itGyqvk3KfDaa/JdxjDtG8hbw1X1w4x+srU2FjVPorWxnULJFAFRrqNu7eOamiCMZjiA
         IHJpfkI1htN5Q3BU2lxvvMBW1MnfPVOKLbWjZmAqS3uODaXiSXoBBNTtPnNb5G74lIOi
         v50w==
X-Gm-Message-State: AC+VfDzZyx7XOdRgCERWMX+2VDZ3m0S2X9QXiB9EXBiOH7aqgobY6iQK
        LQVN77d58/XoBYhRXd4/ay7b3A==
X-Google-Smtp-Source: ACHHUZ6zEjYzMrp4gF79neLgZkrJ+BeVeXYBeUFIHe55QmvShuoHFiUoi5uBX6k4SWgM8gl2g1pynQ==
X-Received: by 2002:a05:6a00:21ca:b0:64c:ecf7:f49a with SMTP id t10-20020a056a0021ca00b0064cecf7f49amr6056402pfj.21.1684426920701;
        Thu, 18 May 2023 09:22:00 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:22:00 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v20 18/26] riscv: kvm: Add V extension to KVM ISA
Date:   Thu, 18 May 2023 16:19:41 +0000
Message-Id: <20230518161949.11203-19-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230518161949.11203-1-andy.chiu@sifive.com>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

Add V extension to KVM isa extension list to enable supporting of V
extension on VCPUs.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu.c             | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index f92790c9481a..8feb57c4c2e8 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -121,6 +121,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICBOZ,
 	KVM_RISCV_ISA_EXT_ZBB,
 	KVM_RISCV_ISA_EXT_SSAIA,
+	KVM_RISCV_ISA_EXT_V,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 8bd9f2a8a0b9..f3282ff371ca 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -57,6 +57,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	[KVM_RISCV_ISA_EXT_H] = RISCV_ISA_EXT_h,
 	[KVM_RISCV_ISA_EXT_I] = RISCV_ISA_EXT_i,
 	[KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
+	[KVM_RISCV_ISA_EXT_V] = RISCV_ISA_EXT_v,
 
 	KVM_ISA_EXT_ARR(SSAIA),
 	KVM_ISA_EXT_ARR(SSTC),
-- 
2.17.1

