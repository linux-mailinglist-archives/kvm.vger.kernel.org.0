Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165676C6BCF
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 16:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjCWPCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 11:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjCWPCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 11:02:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A9130E8F
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:01:23 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so2220102pjp.1
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679583677;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JozESal/Fbpp9RViTDB8Qd5//8qhpKIjNlNXSseO97c=;
        b=GLZYv/aG+Ac/8djv6J4vsr0ttPd9TwjukVUqCjcfy7McPcuKFVHuqGy5w0iYCgH0ve
         YRQhpVGOmVc4RurKC+5esLk2PdcLbPPFidaAN9Hp9u7ozr0XoOlEO5YKecamglCLfr+Y
         0p75r2grShf5CGdEDVy65zHfCz86AqYD4ygkSKKuiUDhhfLFNWWY084z8ZwLFhwK7ids
         R4w6yIbHpa2CiACplfWPfzv1nDfk4gnJO6CPCZLH+NyTylJ4Hp0GCsWVP4mbvnI6d1DI
         CUTL7UkrdUSPWSfpdf1sI1Pw9RDsFBUuHaQhsOWnoxF7ZuJn3wxmIYay6txUTs3gwkO5
         hNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679583677;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JozESal/Fbpp9RViTDB8Qd5//8qhpKIjNlNXSseO97c=;
        b=EzRtU2QAXJlWeziPmK9o4lwnoznJkFfu2/ZG1u+U9+U8IBwvmUy3g7Z9bUymuRcC/h
         pnTyLhQhUE7hLK2ABG4/r7Pv1KRrUnU/IkLPE/YHpTxRuyl76yjQgLsOfZ3t6J4HfShH
         3Nbs62vyWyh0em2DjsJ0p0mg8NXyLl4hp0wF5S+bs+Wp5i25xAKoN6bCx7e4KDsubd90
         9WgW+RE/74HgE3xDiKYBuxQQYp5yzoYSzvaLxl3kFXl+L4rjT6ODY6xOLsr+xmTjH5Bk
         Nio2pojb79ohXOOO/ZDbOfbj5bqW9VMhP7ULwTZHJDjY4iBZwPFKhY3Ihy5qH52dYrqy
         FsQw==
X-Gm-Message-State: AAQBX9eqFFLkpnPu9shL13QSToU9AZ4nahiUs+e45KyKTiBOTATLL7iZ
        xGJruP3HmMmsLKtd72FkHG7QWw==
X-Google-Smtp-Source: AKy350a6Nkugs3BdGgoNETgzYze7cy/cXizByVIZO8sc3UhB/5O/9VTlWpWOJUEXeJgtEB1dDswOuQ==
X-Received: by 2002:a17:902:e5c9:b0:19a:7217:32a9 with SMTP id u9-20020a170902e5c900b0019a721732a9mr6934775plf.26.1679583676752;
        Thu, 23 Mar 2023 08:01:16 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019f53e0f136sm12503965plo.232.2023.03.23.08.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 08:01:16 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v16 17/20] riscv: kvm: Add V extension to KVM ISA
Date:   Thu, 23 Mar 2023 14:59:21 +0000
Message-Id: <20230323145924.4194-18-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230323145924.4194-1-andy.chiu@sifive.com>
References: <20230323145924.4194-1-andy.chiu@sifive.com>
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

