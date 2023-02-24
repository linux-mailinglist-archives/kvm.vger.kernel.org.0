Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374CF6A203C
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjBXRDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjBXRDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:03:34 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E22839CF0
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:03:22 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id bh1so106442plb.11
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YhtBb89nOsK8vMV5FLn5GLV4Y9PvKk5nrBq2eua1ZQQ=;
        b=e9tp0eUH0VpJXlp6I8slYqRmoD66QhY2GidzFBryqo0fmqNGhXvEpg5Awm9vMT6aSM
         ETKYkFU9m+PE5kz5q0CxIjpWn2PkLTs0SOmQ1dLBupc/EUbPBf9SVbLq6yskE4AsDtop
         kWKs2jOmIy9RcWDxFqYaxAL/CpK+es7RihysURnKQK2wPhftkINFlC+SnbgeCrFYLGiN
         Sh3QsA5BotnYOpwWNPxZcm4duNYmxWx4pBbdqu8DRHdKCuLyhReKwm3HlKmhoAyOYjjP
         EsGwf56ARuyQuwkV6rzmiu4zaIs20bA79KvUls+bUHUy/JqJV5BqIKN+hsNvNu7g1nrn
         qxXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YhtBb89nOsK8vMV5FLn5GLV4Y9PvKk5nrBq2eua1ZQQ=;
        b=12TDRqQeaPPZEzbNED5VYR5mMjO+aGL4rVQLKSG/33NYFNRuAvtiufh4hiRpDCSEcX
         MrMNkVSXy9K/OPDAn4PW5p+oIl5O1SMB0d15OCXqdDtJieDmRNn1jd4Atx/A+AlSVj7Q
         I3H7SnuIRDz594hpxSmk02SfpuZfuh05C+WI0XNp4MfalijzkhxwYeZeuES6HC6PoQep
         Oyu22rEfjAUvXa5eBZAmU+8aNCVdh9JNiesTCVvgULC19BlE5OMIoiWQIQZg6mlRqhdj
         zc+anxm/nRrcFkIhEJ58Sv7tD+lVbaIYIMmfr90t4AqKbkr/K7yWJou0dfbbXoRi3vJI
         MrIA==
X-Gm-Message-State: AO0yUKVkMbH6iTvFH5+jgykkVY0HE9vON/Q/JNiKc5NR08rwtYH1zVp2
        TULZaoXHRcjDdq7XDbY1PfIpmA==
X-Google-Smtp-Source: AK7set8hYBn6Bl6fkiAJavukNy4SdPO2tgwvfzCYBpoAWBin6Lr2TtJ8a0nudLP6vMHi4qPMB1dBEg==
X-Received: by 2002:a17:903:32cf:b0:19a:b092:b31a with SMTP id i15-20020a17090332cf00b0019ab092b31amr17326037plr.8.1677258201509;
        Fri, 24 Feb 2023 09:03:21 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902b60c00b0019472226769sm9234731pls.251.2023.02.24.09.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:03:20 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v14 17/19] riscv: kvm: Add V extension to KVM ISA
Date:   Fri, 24 Feb 2023 17:01:16 +0000
Message-Id: <20230224170118.16766-18-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230224170118.16766-1-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
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

