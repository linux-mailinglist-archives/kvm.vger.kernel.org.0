Return-Path: <kvm+bounces-18898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DCBD8FCE1E
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:01:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E66E1F2A39C
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE8401B29B1;
	Wed,  5 Jun 2024 12:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="TdXZ+kdV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D361B151F
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 12:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717589752; cv=none; b=R41zTNu0tV/hjwb6C61XE+HTU9XcwfV3Q/e9jWGzAvOsAAoF/7F0SU5OAdiNMLn2YHxyfieJZ9ZCcsY3v7X3DnwJ4V++0GEGFhVLKvIOPHB6HlTBrlkTA+lW1O3VtK5x10QGq5pNlN5NO0rdXJmbM2BuHOQdsSRxwm/Xrfo5yb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717589752; c=relaxed/simple;
	bh=CRu+PRCiIUbcgK7k+OALzNd3CLHlGYyDDJJ1/w/c3G0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=IlcVgViUHlQM1mr/H3CG9lmO1mY8hrQPJsPBhVMxxC9clc2ooOAuWOsxJWOcHqOMJuW5p5IvlX2tBGmiYifH6GLFnP7u97XU3dUwlauUUZMZ9pnASdoytgC5WNm48Rhvv8ZSI7iNnlszlDixhfKOFH/02qMdzbvWCPOTKdx+0zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=TdXZ+kdV; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7025b253f64so3097544b3a.3
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 05:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1717589750; x=1718194550; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C9yGW+vb+251DuCHvQ6eWHokjrDaPZ1CHdh15Wr7+D4=;
        b=TdXZ+kdVAYeqgf6FzrHoOcCipHaldgDwM/fSwuj5BsxAeA3j2UOuE6q55DCelFKbjh
         Lp97yCa0oHXKisVjjsxb5p/4OuM/weATVjS7bJmlCyakg8R/Lq3MELYNB7yfAeo9resh
         EnGTAFRW6KQQIRk6ImmTYvV6l/D1aYljinGQO23JG6qBsxKBoGJHFKwrxQr5ekrIIMcH
         /cTiTVl7HUD9an23rhSAWyXx2BfH3dZAE/JgUdP9M7cBtJKoQ9//GqyQLBJmM6Scf9R0
         UHn9PIgtmTxvPKO2lAm+56eUrk3B4QWgtCSdMpX5rPZ+TZaIw8yonyS1h8sXXh6I9+Ri
         IuoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717589750; x=1718194550;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C9yGW+vb+251DuCHvQ6eWHokjrDaPZ1CHdh15Wr7+D4=;
        b=iLH4IT/JgiqhM5glowfuHWHmugFROU3CzgYjfVVA82tfrYm6gNWnvd1Mst2X9g93Gm
         4STgnD2veTmhdbi2oBTgwoFUUt7kc9voBwksd1TZAj90V8oVLanf7pfHvAh5e2Xl4X1g
         bgiHxebHjJ9LDQxX6+wsqDXlbDuUL3ozpvDSMeCDDUyYC1cvli978WV/p7z3HbVpiuyx
         pIzKRcyFSJZwNTKQ/SDEFGuMKeGtttnLOJxY3nHCQ5JBIs3eh6ICPw58eBUA5mPwTBkM
         UjgxJi4H9OttckG6vU7c8LB1YJobD7kch6x1BGzh9Wr8kHHNZhUAGzJg+m4d2ptihh+Q
         Z9cQ==
X-Forwarded-Encrypted: i=1; AJvYcCXF758MDZi9XvBAfEICnHu3t0PvkG5PTE9sX7ffORNjohXSKwfX8OyO6r3x/AnBfcJhRW4WSvxSf6Lo5X5l2Y+WYWg4
X-Gm-Message-State: AOJu0Yw+pevfy6zjVkmDgFPHDNAFn/szw3Q4y4JciAbSIuq7oiRUMHgy
	vWpOhdIzVB2fPfQSjzlSFwYeMhg7Z1myocXxZgWHboQCzrRbTDqPzi4FW2CPi4k=
X-Google-Smtp-Source: AGHT+IHuMhXVgloS9T7u/eogW1nwS9cEhCJiBxA9pyATWrWX01kMIqq28iggOkL5AgJrH0kuilEjvg==
X-Received: by 2002:a05:6a00:18a0:b0:6e6:98bf:7b62 with SMTP id d2e1a72fcca58-703e594abe7mr2644243b3a.8.1717589749923;
        Wed, 05 Jun 2024 05:15:49 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-703ee672fb3sm885379b3a.216.2024.06.05.05.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 05:15:49 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: apatel@ventanamicro.com,
	alex@ghiti.fr,
	ajones@ventanamicro.com,
	greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH v5 3/4] RISC-V: KVM: Add Svade and Svadu Extensions Support for Guest/VM
Date: Wed,  5 Jun 2024 20:15:09 +0800
Message-Id: <20240605121512.32083-4-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240605121512.32083-1-yongxuan.wang@sifive.com>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

We extend the KVM ISA extension ONE_REG interface to allow VMM tools to
detect and enable Svade and Svadu extensions for Guest/VM. Since the
henvcfg.ADUE is read-only zero if the menvcfg.ADUE is zero, the Svadu
extension is available for Guest/VM only when arch_has_hw_pte_young()
is true.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 2 ++
 arch/riscv/kvm/vcpu.c             | 6 ++++++
 arch/riscv/kvm/vcpu_onereg.c      | 6 ++++++
 3 files changed, 14 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index e878e7cc3978..a5e0c35d7e9a 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -168,6 +168,8 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZTSO,
 	KVM_RISCV_ISA_EXT_ZACAS,
 	KVM_RISCV_ISA_EXT_SSCOFPMF,
+	KVM_RISCV_ISA_EXT_SVADE,
+	KVM_RISCV_ISA_EXT_SVADU,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 17e21df36cc1..21edd60c4756 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -540,6 +540,12 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
 	if (riscv_isa_extension_available(isa, ZICBOZ))
 		cfg->henvcfg |= ENVCFG_CBZE;
 
+	if (riscv_isa_extension_available(isa, SVADU))
+		cfg->henvcfg |= ENVCFG_ADUE;
+
+	if (riscv_isa_extension_available(isa, SVADE))
+		cfg->henvcfg &= ~ENVCFG_ADUE;
+
 	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN)) {
 		cfg->hstateen0 |= SMSTATEEN0_HSENVCFG;
 		if (riscv_isa_extension_available(isa, SSAIA))
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index c676275ea0a0..06e930f1e206 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -15,6 +15,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/kvm_vcpu_vector.h>
+#include <asm/pgtable.h>
 #include <asm/vector.h>
 
 #define KVM_RISCV_BASE_ISA_MASK		GENMASK(25, 0)
@@ -38,6 +39,8 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(SSAIA),
 	KVM_ISA_EXT_ARR(SSCOFPMF),
 	KVM_ISA_EXT_ARR(SSTC),
+	KVM_ISA_EXT_ARR(SVADE),
+	KVM_ISA_EXT_ARR(SVADU),
 	KVM_ISA_EXT_ARR(SVINVAL),
 	KVM_ISA_EXT_ARR(SVNAPOT),
 	KVM_ISA_EXT_ARR(SVPBMT),
@@ -105,6 +108,9 @@ static bool kvm_riscv_vcpu_isa_enable_allowed(unsigned long ext)
 		return __riscv_isa_extension_available(NULL, RISCV_ISA_EXT_SSAIA);
 	case KVM_RISCV_ISA_EXT_V:
 		return riscv_v_vstate_ctrl_user_allowed();
+	case KVM_RISCV_ISA_EXT_SVADU:
+		/* The henvcfg.ADUE is read-only zero if menvcfg.ADUE is zero. */
+		return arch_has_hw_pte_young();
 	default:
 		break;
 	}
-- 
2.17.1


