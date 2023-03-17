Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366A16BE86B
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjCQLjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjCQLi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:38:57 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBE7B370C
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:38:19 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so4854739pjp.1
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679053080;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/AAqGu3Y2tE6PwERzlxgF8pRZFhzabNc8FHDT4FhM8k=;
        b=nj5v12IcZMYNHjmFVH++QzKHCWs0GKMkGrliIDsjFKLUFGeE2RCDK+RjZ5DRrTwUUx
         JajHVOQBuSP1SMTwN3vWgVLdAauo0PNs3uv3y8b/mZGBt+tgGNVd8Tev564nCvj9Is5I
         IT1yBCOFgAhIFT5osnX8bAPerR45dOIWzRT9/0KOoWX2YbjaeDhVJ0f4JtZ5vMmq3Zp5
         BOxtfyf56eMGmwR8+KWuCZiRIFAPIOoVmhAwQG9QAs+qZt9DkEzZbiImgCLWHDbYEFg4
         ttgWyB98rPq8kgActV9328vzs0a0BZe9nBhiOss2mE6788zyQL4OphU5blrQu61yibFE
         sCyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679053080;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/AAqGu3Y2tE6PwERzlxgF8pRZFhzabNc8FHDT4FhM8k=;
        b=ZiTwN9/2P5QqJo6PYw+reqfLoc9045Q61KqLQ8zDCzfBdvh0hJR42oiMkTNzlcvlu6
         phX3DkklEWfWuS1BWeNE74jO2xpAA7WWMLa+3mg3A1ZhDUitOhtgOYEqPBeni92J3L9U
         R2Zv3+AP2+ZTxE0F/YfLBu3AEcmAAIba9vhV5ck/ks0wORq6Pb+4/+8T1xkRguRXVEVg
         BTrWYiZkcR0MRfDXEBl+MBOIGOlILbGFQboNpMRXzrCLzQgqFiHRbYoP/lwtX2pnRWYO
         stK9Kok+l+4+TvSJKGAUW0RaesM//1xKge53habTuLsp+Ib4nWds13o0ZrkAi3bKpOGU
         4OvA==
X-Gm-Message-State: AO0yUKWEueWOxLIZoLXGDEvGVZ+RvZbGgnnnviCzz/2EGZgEp/O95WKV
        F20FJ63k2JfPKuoSO6iyZbqOtA==
X-Google-Smtp-Source: AK7set+DAvC6Q7FfJrmAD5sAzOxXleg1aj0ZYT15Rx6xTjJu9mqsLBNLrtb03zlBd55lzQi5lBKhLQ==
X-Received: by 2002:a17:90a:1950:b0:234:d78:9b4c with SMTP id 16-20020a17090a195000b002340d789b4cmr7573916pjh.18.1679053080110;
        Fri, 17 Mar 2023 04:38:00 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:37:59 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v15 17/19] riscv: kvm: Add V extension to KVM ISA
Date:   Fri, 17 Mar 2023 11:35:36 +0000
Message-Id: <20230317113538.10878-18-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230317113538.10878-1-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu.c             | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 92af6f3f057c..3e3de7d486e1 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -105,6 +105,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_SVINVAL,
 	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
 	KVM_RISCV_ISA_EXT_ZICBOM,
+	KVM_RISCV_ISA_EXT_V,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 7d010b0be54e..a7ddb7cf813e 100644
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

