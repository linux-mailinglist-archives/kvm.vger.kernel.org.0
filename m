Return-Path: <kvm+bounces-9907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DDCF867918
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:53:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6D37294647
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902E413B288;
	Mon, 26 Feb 2024 14:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h8iXLUvI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADBA13AA55;
	Mon, 26 Feb 2024 14:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958223; cv=none; b=o7vaJGNlJJ9myNoKvP5xdZ5NgLXnSqjHcXIzK3FBfPICpc1VE5jbshMNBVVJ85gGSy7gBHlR33V5YjQB7rHEYdSP0YWdsDTK9WeA8GT0TVD4QyXpFtKwt0g2y2CootFXrINvIaOhu3npxKAuHiWsCYx2FPhvt6j/j5RIICLJnmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958223; c=relaxed/simple;
	bh=pm5GaYpbz831lvo3EsBoWH68tqICveycrA1gNbHXH1s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DO6e1iQf2iov/558qXi2Z9W6UswjkkeV+F4e7FUtmzC7tdr8EuFi+t2Mu1ty8Ji6DTA8XOpPpqIXcg6IW7UcHTppaBl3tRPaGQ3odGL9bdznr0HODJtccKmeR55HClh+xRWxU9zNckS2MmaKbPFOjXRgE0Nb/vHFHRwikNVztxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h8iXLUvI; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dca3951ad9so8755425ad.3;
        Mon, 26 Feb 2024 06:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958221; x=1709563021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8DBgCM0VR+4taDSV316Rvjx7ITFdXhliPm7c//LFBQ=;
        b=h8iXLUvIRO5li2pYiZFKEzAua2YKKYTkPPe+BRz2UfN9d5vkKW9WG93pGWCy0+iRnk
         3651d4pQnJre8ilR753yrqsdxPClzD6CJH2K4SkAqDRusvjZm+QEIwwTcyU926CUBVP3
         mRTnYfD+Hveovooy+bv0ddJNxtT+31W22c9JEa47BdTXUP7vx/Yuxu7S5gshNdXNzJHB
         kCO26oXnfz4x+3Y4G4naCq/aUDJxUFzr4T63I/bpybPT8oUKPc1papXfaFJQczCf9BQK
         tB7IfRbV7v1R0yAMvNkFAV5sOdk/jDKirS9eCHdN97OZojStH5jGtSPKLnw4OaU3kEu7
         KQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958221; x=1709563021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e8DBgCM0VR+4taDSV316Rvjx7ITFdXhliPm7c//LFBQ=;
        b=QjEqtjjQyHgZQnX/KoZ9U4cSmuJX+zHw5+oXa+gRvNNFxSHqQ1MggisSy11BVrsjbU
         2oYqgr5PYnk7J0W8gxC5aBAoG8tTIfZn7TJ5S1LfrPqLj8OJEJd/G4eQjaJJ8/zhvlAa
         qflIAPiCZTSGkpDhpGjwPNHbuhvHre+v0orhlo2JXlIj1SKvXRT1roBRhhCxCdL1pw8F
         xahyCZOQx8BQWTYwm/iWx0S3J5pusIRvlvoFtURiugHVHKss59hbYKoCppPut64iBUo+
         VIjIERnMs0fWzE3RcjvwHrFv6Gy/QMRaNWg8v+o2+R5ANQPHTBGuCkSbl8ULBTN1XOmJ
         qMTg==
X-Forwarded-Encrypted: i=1; AJvYcCXBLBlP3yibu1hw1uWm955eFhkHWyinzoA1sqvQsWc7G61eYb2KJGMdy/6ID38f2B3aiVCV1Z8BAfGr78JJYJx+WDZi
X-Gm-Message-State: AOJu0YyIRCrRRQVNZd7u52UykNr70yQzWeW2gSzK1CptosjBA3ijCtKw
	GyT/Gfario8lVuSwRGx66ruWUR2Pe1p7qxEl4wpUFPcytc7X6bwJcO+uoBIS
X-Google-Smtp-Source: AGHT+IGL0ddPeVRaBmwnCUkeiVCWzHNiZRsnUe1vOCNit47W2YeMz73kMlfrCnSL7E7+/jE0C1y/Rg==
X-Received: by 2002:a17:902:e841:b0:1db:37b1:b1a3 with SMTP id t1-20020a170902e84100b001db37b1b1a3mr10296670plg.17.1708958221380;
        Mon, 26 Feb 2024 06:37:01 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id ko4-20020a17090307c400b001dbcf653024sm3994437plb.293.2024.02.26.06.37.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:37:00 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 44/73] KVM: x86/PVM: Implement TSC related callbacks
Date: Mon, 26 Feb 2024 22:36:01 +0800
Message-Id: <20240226143630.33643-45-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Without hardware assistance, TSC offset and TSC multiplier are not
supported in PVM. Therefore, the guest uses the host TSC directly, which
means the TSC offset is 0. Although it currently works correctly, a
proper ABI is needed to describe it.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 138d0c255cb8..f2cd1a1c199d 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -725,6 +725,28 @@ static int pvm_check_intercept(struct kvm_vcpu *vcpu,
 	return X86EMUL_CONTINUE;
 }
 
+static u64 pvm_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
+static u64 pvm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
+static void pvm_write_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	// TODO: add proper ABI and make guest use host TSC
+	vcpu->arch.tsc_offset = 0;
+	vcpu->arch.l1_tsc_offset = 0;
+}
+
+static void pvm_write_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	// TODO: add proper ABI and make guest use host TSC
+}
+
 static void pvm_set_msr_linear_address_range(struct vcpu_pvm *pvm,
 					     u64 pml4_i_s, u64 pml4_i_e,
 					     u64 pml5_i_s, u64 pml5_i_e)
@@ -2776,6 +2798,10 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
+	.get_l2_tsc_offset = pvm_get_l2_tsc_offset,
+	.get_l2_tsc_multiplier = pvm_get_l2_tsc_multiplier,
+	.write_tsc_offset = pvm_write_tsc_offset,
+	.write_tsc_multiplier = pvm_write_tsc_multiplier,
 	.check_emulate_instruction = pvm_check_emulate_instruction,
 	.disallowed_va = pvm_disallowed_va,
 	.vcpu_gpc_refresh = pvm_vcpu_gpc_refresh,
-- 
2.19.1.6.gb485710b


