Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1110267B43B
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbjAYOX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235705AbjAYOXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:23:10 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6F559756
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:22:33 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d9so17987974pll.9
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g9JZvEgc3t7qPHF5cXlDhMN5hpagVMZC9pMsAoNPQHU=;
        b=Z80E2gJ10aNEcbbtfGBocYqrqwwdq/5WOi8QAKgRWOxJXMcjnIowdDw6W9v3dwV93l
         ode8s+PQ7EE83o2idPCgt0+PNZCmEKgMVBt64j1esoeF00QAMIIeUvq02YE3bQnRclH/
         8jRt4POVT8xyxMOmCIBZCEpfX+jEfjDyRn0FBuCfzOZaXyB8zj1finphTxGIztgfAn3U
         kQIXCPWQnyQ9S94SlRiuv/20G/PvcOHIy9x8thpZ4SxdCzwq44DVLNLMlDErpkttdGSZ
         9f6ybVgQi7XVb/9af2YzJwseuQRH5XPhmMm0dCXauHiSjBiliuVmfCPA8TOQFHX2HNx4
         EjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g9JZvEgc3t7qPHF5cXlDhMN5hpagVMZC9pMsAoNPQHU=;
        b=iWETeo8kik24D24poWB+DE6RDaLRYMfNEai7xZ8D/LUzAutdeimi2hfceqfJd3Rtqr
         PXy306VHaqSEnX9O1mh/M4lAOkkpa5X6LdWchw3D8bjDSa+5kn0TLBRi2LqWL1T/nC7A
         WaQCTVx2A8+aYZML1C2AfkfAs7PcqrUN4pTf5Ef5q/omhCIKImyre5CLanlppCIGZ/Fq
         hJ+shqnh30k2Pg0BhmqsyiW1lyH8k1HycgqqLtycEW8i3doqNmPkcS+FilrZlr74iWS5
         6yeYI4FRY2PlUl2f+ltMlBIvdtjzwOxDwlvx3YL7za3xsNZkHztmXAcP7HXrjumG6zbU
         WV6Q==
X-Gm-Message-State: AFqh2koiwA2gnsa4c70loQLCYLPIXfqhIefkDAXC+WTi3PEQ08GSbru0
        EXLs0t764L6S9Gl4pxZdNIwkPA==
X-Google-Smtp-Source: AMrXdXub9jcHo12sPl2id1IhPSk+pfQ9Gyt0ur1hAXKR1AcxccpzQIFjQ953qUhUJTULJyodLBxP8A==
X-Received: by 2002:a05:6a20:9f95:b0:b9:478f:9720 with SMTP id mm21-20020a056a209f9500b000b9478f9720mr24628451pzb.42.1674656552695;
        Wed, 25 Jan 2023 06:22:32 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id bu11-20020a63294b000000b004a3510effa5sm3203520pgb.65.2023.01.25.06.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:22:32 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v13 16/19] riscv: Add V extension to KVM ISA
Date:   Wed, 25 Jan 2023 14:20:53 +0000
Message-Id: <20230125142056.18356-17-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230125142056.18356-1-andy.chiu@sifive.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu.c             | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 92af6f3f057c..e7c9183ad4af 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -100,6 +100,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_H,
 	KVM_RISCV_ISA_EXT_I,
 	KVM_RISCV_ISA_EXT_M,
+	KVM_RISCV_ISA_EXT_V,
 	KVM_RISCV_ISA_EXT_SVPBMT,
 	KVM_RISCV_ISA_EXT_SSTC,
 	KVM_RISCV_ISA_EXT_SVINVAL,
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 7c08567097f0..b060d26ab783 100644
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

