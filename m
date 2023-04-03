Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B892A6D40A9
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 11:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbjDCJd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 05:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbjDCJdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 05:33:51 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6785D65B9
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 02:33:37 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-17997ccf711so30115795fac.0
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 02:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680514416; x=1683106416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XgGBfD1W6b+btvEiU+YcKALiNsxE4ZvieFO4n+dcEoQ=;
        b=SJM6TQ68C68jxCQMu1sVZMERVeg2y5HELtR8dUqkPn9CNxFRSSWP7bABC2PPHLTRUq
         /RZxhVdmJZJbUV95LK+SkHdKE8GeQuUKSjRhqDQw1xjVV5ixCviTff5KIYHWSGUhjsQm
         LEIqKBPPlZ06vz4kMpLRCXag9a3aheyT1K5fiXo28KCgyRA5DToOJ+aptwyTTUd2EIUe
         0wB8cK59oHnFwBVaKnd9o3icPmWgrCFCff3jS0FemEfC70g+jDYZ5EzImJfP9vuTvG7u
         ZzPo5vGb1lxzy20SMrEbWBgjlNxsJQkgwAOQ1i3Eaw57pg6ozm7IqMpyxF3yLtbZsvPz
         4nhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680514416; x=1683106416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XgGBfD1W6b+btvEiU+YcKALiNsxE4ZvieFO4n+dcEoQ=;
        b=eyq6OlhXl5E681rmWBT7O0/+9Eaa1L1wxsd7IVO+grC/rYD6LHrv9TOUV65SkJ2EjA
         UNAItufxWuFdJA8tGaigw0JhQyp+xsb0Jo6fEDk2K8V0o7eztiqI6Xvpcs1w0BQV6dJy
         LWo9k/yKV/LpM5nkGa6chHWMG0/MdJWGdcQ6UbX4/sYOlQpAqVlqy9gm2JPBTtt4hH3x
         Nu16mLgTEhjjafTJ9v5n//e1OGSBdsEcPYuFYar6PQHJDQUL3nNwKY2Tt7RdBPC1V9PC
         Zq50LZroL+6iY54HposAlP7Vf8fCFW48rmelB0EookAJWCylzZymFHeU6eVuvCelyj44
         wFpA==
X-Gm-Message-State: AAQBX9fHCj5jckwq1i0r/j5C5jE4hnc6nnMlYvkhq8kL4benzxYnbQeZ
        9FDF0UDSRFpQRFLmyjGJDYD3H4IwQSdKIbP7kvs=
X-Google-Smtp-Source: AK7set+ltL2X5guCtdTgJstf6Dn50g2Ksxi76SfvWGtGURX2OaR9ISpgLg9Bp+05N0nhVsw99aEzOw==
X-Received: by 2002:a05:6870:14d3:b0:17a:58ba:dbcc with SMTP id l19-20020a05687014d300b0017a58badbccmr19968566oab.59.1680514416574;
        Mon, 03 Apr 2023 02:33:36 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id f5-20020a9d6c05000000b006a154373578sm3953953otq.39.2023.04.03.02.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 02:33:36 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v3 2/8] RISC-V: Detect AIA CSRs from ISA string
Date:   Mon,  3 Apr 2023 15:03:04 +0530
Message-Id: <20230403093310.2271142-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403093310.2271142-1-apatel@ventanamicro.com>
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have two extension names for AIA ISA support: Smaia (M-mode AIA CSRs)
and Ssaia (S-mode AIA CSRs).

We extend the ISA string parsing to detect Smaia and Ssaia extensions.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 2 ++
 arch/riscv/kernel/cpu.c        | 2 ++
 arch/riscv/kernel/cpufeature.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 6263a0de1c6a..9c8ae4399565 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -42,6 +42,8 @@
 #define RISCV_ISA_EXT_ZBB		30
 #define RISCV_ISA_EXT_ZICBOM		31
 #define RISCV_ISA_EXT_ZIHINTPAUSE	32
+#define RISCV_ISA_EXT_SSAIA		33
+#define RISCV_ISA_EXT_SMAIA		34
 
 #define RISCV_ISA_EXT_MAX		64
 #define RISCV_ISA_EXT_NAME_LEN_MAX	32
diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
index 8400f0cc9704..7d20036bcc6c 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -188,8 +188,10 @@ static struct riscv_isa_ext_data isa_ext_arr[] = {
 	__RISCV_ISA_EXT_DATA(zicbom, RISCV_ISA_EXT_ZICBOM),
 	__RISCV_ISA_EXT_DATA(zihintpause, RISCV_ISA_EXT_ZIHINTPAUSE),
 	__RISCV_ISA_EXT_DATA(zbb, RISCV_ISA_EXT_ZBB),
+	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
 	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
+	__RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
 	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
 	__RISCV_ISA_EXT_DATA("", RISCV_ISA_EXT_MAX),
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 59d58ee0f68d..1b13a5823b90 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -221,8 +221,10 @@ void __init riscv_fill_hwcap(void)
 				}
 			} else {
 				/* sorted alphabetically */
+				SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EXT_SSAIA);
 				SET_ISA_EXT_MAP("sscofpmf", RISCV_ISA_EXT_SSCOFPMF);
 				SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
+				SET_ISA_EXT_MAP("smaia", RISCV_ISA_EXT_SMAIA);
 				SET_ISA_EXT_MAP("svinval", RISCV_ISA_EXT_SVINVAL);
 				SET_ISA_EXT_MAP("svpbmt", RISCV_ISA_EXT_SVPBMT);
 				SET_ISA_EXT_MAP("zbb", RISCV_ISA_EXT_ZBB);
-- 
2.34.1

