Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636176CAB0C
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbjC0QwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjC0QwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:52:01 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DF53C11
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:51:37 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so12397659pjp.1
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935889;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JozESal/Fbpp9RViTDB8Qd5//8qhpKIjNlNXSseO97c=;
        b=FQClOy8uhHD8HXTVMAkI2hlX+myS5NpsInaAGuzVF/YYHIFfXuTOPS1VgtCfdFGmnA
         I1WFAX7STgi247ygtMPXKLtDZ8dn9m5hu9wDPxrFci0BDOAuZPuhhgkRJS0TezMyOoVX
         Wm9TLKctCmM2tOs4J0i970J78Drn5D9X2Xw1307HWgR5u8+FUmGZaDGZRExs38WzuftY
         ERJyIYzz3ntEjuGwze4K4Uz6LKNB9/onC8CM1IwA05Pi0QjWvmcWkfqJUyhaYQKp4677
         /hKr/GU1XJ7Qu113/AYitD0tjnmSb+9UjBP7lZhndHmrP2VN8O6rwZu3XFaRlA4gGQ8x
         WbCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935889;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JozESal/Fbpp9RViTDB8Qd5//8qhpKIjNlNXSseO97c=;
        b=UH07VkoatxFaUWa2RmVzf6r8Q7JBckMPHqjvQ5/Qh8FWh03YNf9iFkIWA5Bc1nZglx
         ArlUy6EILiOX6loFCn33SEhOPcSfLh5JjDbUaVxCP1hQ/6PCMOtzLDIVhSCLR07PIRy2
         zY4WSjlMcGoeQG7KU0IBCLIlQX8ElWfCSIp/LVdj14A4nTNm66dNsRpeo6zTka7SCTwD
         0MpMM8wQ0oJbUsq1uvX1bWiAtLW+AR9R20NCcrN0cew18/hMIgXxXzk7MGYz9Ny3C2sG
         AOKAv7FDNmgKuew8W8J7wkVldK+RnD2mFmDEQIFfJRE+XgWcFT/eONgA8bJcIFkoN60h
         RhYw==
X-Gm-Message-State: AO0yUKULjOI9c6GqTtmEMoKDxaFEJA+LqEz0NObmi/i+sOE80R2CxKRp
        5qN+rZA/BPKLkJNY+4jRobFzHg==
X-Google-Smtp-Source: AK7set/JbltxNvnJPfxKE8YPJavwWOt3kjuVHPlOdSBNEsQuY4hrqlGsWSRZQViZSSF4uL3WPD8W0w==
X-Received: by 2002:a05:6a20:b291:b0:ce:ca9:ab56 with SMTP id ei17-20020a056a20b29100b000ce0ca9ab56mr11838514pzb.34.1679935889098;
        Mon, 27 Mar 2023 09:51:29 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:51:28 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v17 17/20] riscv: kvm: Add V extension to KVM ISA
Date:   Mon, 27 Mar 2023 16:49:37 +0000
Message-Id: <20230327164941.20491-18-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327164941.20491-1-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu.c             | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index e44c1e90eaa7..d562dcb929ea 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -107,6 +107,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
 	KVM_RISCV_ISA_EXT_ZICBOM,
 	KVM_RISCV_ISA_EXT_ZICBOZ,
+	KVM_RISCV_ISA_EXT_V,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 6adb1b6112a1..bfdd5b73d462 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -57,6 +57,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	[KVM_RISCV_ISA_EXT_H] = RISCV_ISA_EXT_h,
 	[KVM_RISCV_ISA_EXT_I] = RISCV_ISA_EXT_i,
 	[KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
+	[KVM_RISCV_ISA_EXT_V] = RISCV_ISA_EXT_v,
 
 	KVM_ISA_EXT_ARR(SSTC),
 	KVM_ISA_EXT_ARR(SVINVAL),
-- 
2.17.1

