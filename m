Return-Path: <kvm+bounces-35171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F915A09FA8
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:47:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34AD1188F1E8
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF74B42069;
	Sat, 11 Jan 2025 00:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="ercxNVmS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5DDDF49
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556427; cv=none; b=tjQO+ntml+NySAafVuVI6GAVnszepgsnG1/q+2pMXLASPsh2W+G0KRRTCTa7Me/VeMB/y+hGbGOoGbckg6vinKTq/4ONUi9aknWqdn4d5Ou1dVdwOhLqJDCayGIlzc2S/FegRr8mXH62TyJmI81kLEkFwVWnIAUSVDeVqZdzDgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556427; c=relaxed/simple;
	bh=Ry+ws/fojtj8q6WFoukX8wRgqJESTrye/uo8fbwbQaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsByl9Z5NmKVq/2SFVj7qQrcsvMlkhjt+1wWJurZ0GumIt/UL7HZyzvhjs1aX5NN0Texrqi9j1mzmCLq3U4vYxu/fn/d0Y3dUWDNzuTvg3dl/XyJ6Y/UL2buRCjcMP108JAMS3cflJ6lVjoxiQZ8UiNadbYMZWdaRMI1khOJjHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=ercxNVmS; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2f13acbe29bso5687402a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1736556425; x=1737161225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mG/7mpvt2lUZ0JpSGT/sSZlaG6n67EyEdFyeasyHfcQ=;
        b=ercxNVmS/sroEkYFbNjInz/KgPaGEWjEz/Kw+7Yv/BmTn0S+UonosC9dZ0HTpcq+ks
         km+kiOglB+CY106f3QneOi2WNVJA798FCE6NXMA8ylhDRGFpqB6h7qRWKmkX7261NSUV
         N1VmGbQmXsz5NezUBV2kGf7jtt/vrNdo4ldohahbPiDd4+LHStAVelmHlCU9URalSL61
         nEhY7wPae1/ao9mOCgAr61nqYEz0UPl2T28AIUzs9veOgqHmgc1SoEGQNV2Yl3E2t1y7
         PCuHIxpioz3zud52OBt4Rn7VQ7yo+4Cy15B8Dj1NM7p/yq2222+G80q+YUTCA5IOFxSU
         3IJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556425; x=1737161225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mG/7mpvt2lUZ0JpSGT/sSZlaG6n67EyEdFyeasyHfcQ=;
        b=bTBKWaWd8XRSP//n+MZwtWWMTg2cgHDoNfk6gGYcV9bfNjcQhvUSvtlCeSBnLf52LL
         yjqiWrL0yTyfQNRtRsv/hXNd4vQw5sfDWKS3+49VJ8RBpFIw52NrJUWTmANgBwFUuBdf
         IMWqCp6P+qWNFPBtTjmF/nPv3guFoEUCitynrBKQELMf5Q8j+HsZL7K57IFpVPctmpsW
         NEi1EhvMCNnAJgUcYQwGsVEYnsaDMJkczWnmEdMqO/PtLWvKeC0dEj8tr/vJzQD4QzIQ
         Df5r06zenCQS9gtYpt0Dq3NJSBRzWfeo04JkznZn+AGY/Yv7Km7qOvoO77dIdejkyR5Q
         gkcg==
X-Forwarded-Encrypted: i=1; AJvYcCVCt0TGFmb1X6Y49uBIYmEHVPHb1Wx6fIpNxBHK4ijQch0xZz1TNFAhJowKEbccwxVAb+g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQKOaBowR5Vb8FTPd+thWX8amA5D9JpNszLzsQCpvh3+dWfyUj
	YMPT8pI7wARy9amtDjgS2vXyP8Sc0z/oU4cU44aulmjFzFce5zCEKWjgZQxyJIRWDvUe0I1R1TM
	9
X-Gm-Gg: ASbGncuYc6ytcamPhYnaIaz3EuIVvyzXiCkrAH3D4kz6pnukQ6dLODdLEBa+nrq3P6a
	GtAkPJ/cmUZCKZsVsL7IHGAuCKHMYWRpwZPKWM2I+e8hzP4p708gv2NYTa4PZefUR9zCxer7DvN
	ZuJkpNipBbbDP1CwfOILI7ZnhEFfNk1QxD/bl+WZ9acWH33/5uSKu+gWvvC0Wjeg+w9zTx+k4Tr
	2+rq/1yppHI3iV984SaKVwleEaRU2tbZNVslgimmbgpxH5IaEXn7XaQC6rqsjuqHwdZYKiqYpdv
	Lf0=
X-Google-Smtp-Source: AGHT+IESLBI5YsUnw0OyUQC27t17HSuv96bLkPw7hOOSo/oEqHzGTMFX68XVgxfF9DQh8PbXSB/mhQ==
X-Received: by 2002:a17:90a:c106:b0:2ee:7e53:bfae with SMTP id 98e67ed59e1d1-2f55836e87amr12065549a91.10.1736556425468;
        Fri, 10 Jan 2025 16:47:05 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f54a28723esm6064295a91.19.2025.01.10.16.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 16:47:05 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org
Cc: Samuel Holland <samuel.holland@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] RISC-V: KVM: Fix inclusion of Smnpm in the guest ISA bitmap
Date: Fri, 10 Jan 2025 16:46:58 -0800
Message-ID: <20250111004702.2813013-2-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250111004702.2813013-1-samuel.holland@sifive.com>
References: <20250111004702.2813013-1-samuel.holland@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Smnpm extension requires special handling because the guest ISA
extension maps to a different extension (Ssnpm) on the host side.
commit 1851e7836212 ("RISC-V: KVM: Allow Smnpm and Ssnpm extensions for
guests") missed that the vcpu->arch.isa bit is based only on the host
extension, so currently both KVM_RISCV_ISA_EXT_{SMNPM,SSNPM} map to
vcpu->arch.isa[RISCV_ISA_EXT_SSNPM]. This does not cause any problems
for the guest, because both extensions are force-enabled anyway when the
host supports Ssnpm, but prevents checking for (guest) Smnpm in the SBI
FWFT logic.

Redefine kvm_isa_ext_arr to look up the guest extension, since only the
guest -> host mapping is unambiguous. Factor out the logic for checking
for host support of an extension, so this special case only needs to be
handled in one place, and be explicit about which variables hold a host
vs a guest ISA extension.

Fixes: 1851e7836212 ("RISC-V: KVM: Allow Smnpm and Ssnpm extensions for guests")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

 arch/riscv/kvm/vcpu_onereg.c | 83 +++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 30 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 753f66c8b70a..93115abca3b8 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -23,7 +23,7 @@
 #define KVM_ISA_EXT_ARR(ext)		\
 [KVM_RISCV_ISA_EXT_##ext] = RISCV_ISA_EXT_##ext
 
-/* Mapping between KVM ISA Extension ID & Host ISA extension ID */
+/* Mapping between KVM ISA Extension ID & guest ISA extension ID */
 static const unsigned long kvm_isa_ext_arr[] = {
 	/* Single letter extensions (alphabetically sorted) */
 	[KVM_RISCV_ISA_EXT_A] = RISCV_ISA_EXT_a,
@@ -35,7 +35,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	[KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
 	[KVM_RISCV_ISA_EXT_V] = RISCV_ISA_EXT_v,
 	/* Multi letter extensions (alphabetically sorted) */
-	[KVM_RISCV_ISA_EXT_SMNPM] = RISCV_ISA_EXT_SSNPM,
+	KVM_ISA_EXT_ARR(SMNPM),
 	KVM_ISA_EXT_ARR(SMSTATEEN),
 	KVM_ISA_EXT_ARR(SSAIA),
 	KVM_ISA_EXT_ARR(SSCOFPMF),
@@ -107,6 +107,36 @@ static unsigned long kvm_riscv_vcpu_base2isa_ext(unsigned long base_ext)
 	return KVM_RISCV_ISA_EXT_MAX;
 }
 
+static int kvm_riscv_vcpu_isa_check_host(unsigned long kvm_ext, unsigned long *guest_ext)
+{
+	unsigned long host_ext;
+
+	if (kvm_ext >= KVM_RISCV_ISA_EXT_MAX ||
+	    kvm_ext >= ARRAY_SIZE(kvm_isa_ext_arr))
+		return -ENOENT;
+
+	*guest_ext = kvm_isa_ext_arr[kvm_ext];
+	switch (*guest_ext) {
+	case RISCV_ISA_EXT_SMNPM:
+		/*
+		 * Pointer masking effective in (H)S-mode is provided by the
+		 * Smnpm extension, so that extension is reported to the guest,
+		 * even though the CSR bits for configuring VS-mode pointer
+		 * masking on the host side are part of the Ssnpm extension.
+		 */
+		host_ext = RISCV_ISA_EXT_SSNPM;
+		break;
+	default:
+		host_ext = *guest_ext;
+		break;
+	}
+
+	if (!__riscv_isa_extension_available(NULL, host_ext))
+		return -ENOENT;
+
+	return 0;
+}
+
 static bool kvm_riscv_vcpu_isa_enable_allowed(unsigned long ext)
 {
 	switch (ext) {
@@ -209,13 +239,13 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 
 void kvm_riscv_vcpu_setup_isa(struct kvm_vcpu *vcpu)
 {
-	unsigned long host_isa, i;
+	unsigned long guest_ext, i;
 
 	for (i = 0; i < ARRAY_SIZE(kvm_isa_ext_arr); i++) {
-		host_isa = kvm_isa_ext_arr[i];
-		if (__riscv_isa_extension_available(NULL, host_isa) &&
-		    kvm_riscv_vcpu_isa_enable_allowed(i))
-			set_bit(host_isa, vcpu->arch.isa);
+		if (kvm_riscv_vcpu_isa_check_host(i, &guest_ext))
+			continue;
+		if (kvm_riscv_vcpu_isa_enable_allowed(i))
+			set_bit(guest_ext, vcpu->arch.isa);
 	}
 }
 
@@ -597,18 +627,15 @@ static int riscv_vcpu_get_isa_ext_single(struct kvm_vcpu *vcpu,
 					 unsigned long reg_num,
 					 unsigned long *reg_val)
 {
-	unsigned long host_isa_ext;
-
-	if (reg_num >= KVM_RISCV_ISA_EXT_MAX ||
-	    reg_num >= ARRAY_SIZE(kvm_isa_ext_arr))
-		return -ENOENT;
+	unsigned long guest_ext;
+	int ret;
 
-	host_isa_ext = kvm_isa_ext_arr[reg_num];
-	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
-		return -ENOENT;
+	ret = kvm_riscv_vcpu_isa_check_host(reg_num, &guest_ext);
+	if (ret)
+		return ret;
 
 	*reg_val = 0;
-	if (__riscv_isa_extension_available(vcpu->arch.isa, host_isa_ext))
+	if (__riscv_isa_extension_available(vcpu->arch.isa, guest_ext))
 		*reg_val = 1; /* Mark the given extension as available */
 
 	return 0;
@@ -618,17 +645,14 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
 					 unsigned long reg_num,
 					 unsigned long reg_val)
 {
-	unsigned long host_isa_ext;
-
-	if (reg_num >= KVM_RISCV_ISA_EXT_MAX ||
-	    reg_num >= ARRAY_SIZE(kvm_isa_ext_arr))
-		return -ENOENT;
+	unsigned long guest_ext;
+	int ret;
 
-	host_isa_ext = kvm_isa_ext_arr[reg_num];
-	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
-		return -ENOENT;
+	ret = kvm_riscv_vcpu_isa_check_host(reg_num, &guest_ext);
+	if (ret)
+		return ret;
 
-	if (reg_val == test_bit(host_isa_ext, vcpu->arch.isa))
+	if (reg_val == test_bit(guest_ext, vcpu->arch.isa))
 		return 0;
 
 	if (!vcpu->arch.ran_atleast_once) {
@@ -638,10 +662,10 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
 		 */
 		if (reg_val == 1 &&
 		    kvm_riscv_vcpu_isa_enable_allowed(reg_num))
-			set_bit(host_isa_ext, vcpu->arch.isa);
+			set_bit(guest_ext, vcpu->arch.isa);
 		else if (!reg_val &&
 			 kvm_riscv_vcpu_isa_disable_allowed(reg_num))
-			clear_bit(host_isa_ext, vcpu->arch.isa);
+			clear_bit(guest_ext, vcpu->arch.isa);
 		else
 			return -EINVAL;
 		kvm_riscv_vcpu_fp_reset(vcpu);
@@ -999,16 +1023,15 @@ static int copy_fp_d_reg_indices(const struct kvm_vcpu *vcpu,
 static int copy_isa_ext_reg_indices(const struct kvm_vcpu *vcpu,
 				u64 __user *uindices)
 {
+	unsigned long guest_ext;
 	unsigned int n = 0;
-	unsigned long isa_ext;
 
 	for (int i = 0; i < KVM_RISCV_ISA_EXT_MAX; i++) {
 		u64 size = IS_ENABLED(CONFIG_32BIT) ?
 			   KVM_REG_SIZE_U32 : KVM_REG_SIZE_U64;
 		u64 reg = KVM_REG_RISCV | size | KVM_REG_RISCV_ISA_EXT | i;
 
-		isa_ext = kvm_isa_ext_arr[i];
-		if (!__riscv_isa_extension_available(NULL, isa_ext))
+		if (kvm_riscv_vcpu_isa_check_host(i, &guest_ext))
 			continue;
 
 		if (uindices) {
-- 
2.47.0


