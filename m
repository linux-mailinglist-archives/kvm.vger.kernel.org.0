Return-Path: <kvm+bounces-2078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B25F7F13FC
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 849D01C2166E
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8C11C6AA;
	Mon, 20 Nov 2023 13:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ALnCOGDk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517F91B28E;
	Mon, 20 Nov 2023 13:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC950C43391;
	Mon, 20 Nov 2023 13:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485852;
	bh=w/cC4wrPEWgF7zFsEcck2/daDxUl4VG5N9SlOfFWNgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALnCOGDkgOHTerIRlDYJ15bw6xYIK1Pm8I/71GpSQmVDvLyvboC385fLnShGOL4mE
	 HC6sdxNRAWrU8al467DM3u7d7y+kjZV+n92rBhg8C/2jRPnDH1F9apM1cEA1aR01RC
	 SaSAUaNhPARCNGvw1JFO2le4A4bfuSyzmcqAvlHNeX0zKkWnnZ3VXXjqUC3a9fevWM
	 aRwAIvxWtHLiUH02fkf89a6uX2gMoP3KJn+RTf2r6TSgqxDzNz0yAubZeE232Co42H
	 2iT8czuw+vWT9gxliNjz+/8kyjB4n2K++mTy+AC24xEHYzp4O6sXvdvMII2Nc3n48I
	 xu0aLcja77P0w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r5438-00EjnU-Pt;
	Mon, 20 Nov 2023 13:10:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 07/43] KVM: arm64: Introduce a bad_trap() primitive for unexpected trap handling
Date: Mon, 20 Nov 2023 13:09:51 +0000
Message-Id: <20231120131027.854038-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to ease the debugging of NV, it is helpful to have the kernel
shout at you when an unexpected trap is handled. We already have this
in a couple of cases. Make this a more generic infrastructure that we
will make use of very shortly.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6405d9ebc28a..a529ce5ba987 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -45,24 +45,31 @@ static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val);
 
-static bool read_from_write_only(struct kvm_vcpu *vcpu,
-				 struct sys_reg_params *params,
-				 const struct sys_reg_desc *r)
+static bool bad_trap(struct kvm_vcpu *vcpu,
+		     struct sys_reg_params *params,
+		     const struct sys_reg_desc *r,
+		     const char *msg)
 {
-	WARN_ONCE(1, "Unexpected sys_reg read to write-only register\n");
+	WARN_ONCE(1, "Unexpected %s\n", msg);
 	print_sys_reg_instr(params);
 	kvm_inject_undefined(vcpu);
 	return false;
 }
 
+static bool read_from_write_only(struct kvm_vcpu *vcpu,
+				 struct sys_reg_params *params,
+				 const struct sys_reg_desc *r)
+{
+	return bad_trap(vcpu, params, r,
+			"sys_reg read to write-only register");
+}
+
 static bool write_to_read_only(struct kvm_vcpu *vcpu,
 			       struct sys_reg_params *params,
 			       const struct sys_reg_desc *r)
 {
-	WARN_ONCE(1, "Unexpected sys_reg write to read-only register\n");
-	print_sys_reg_instr(params);
-	kvm_inject_undefined(vcpu);
-	return false;
+	return bad_trap(vcpu, params, r,
+			"sys_reg write to read-only register");
 }
 
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
-- 
2.39.2


