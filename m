Return-Path: <kvm+bounces-42915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F213A7FD7C
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1E2E424EF1
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 10:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE0BB26FD8C;
	Tue,  8 Apr 2025 10:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XkaEMeWL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB91D26F472;
	Tue,  8 Apr 2025 10:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109561; cv=none; b=NRfqKT4gVgkT52J2BI2iqnVMT1NmaVgxHD44SZdKX2lK7W7oThWVPtfQiv+mo7IdPrYZ9qtFlX24kSQk9ga/O+2FoYiFIFhT+DX6maszrynO1HLdmPpHN3UkWwYCV19uI96TWlTswyGOoXfao9Kdz7LoiCF9SzzvUTBWjoBVTuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109561; c=relaxed/simple;
	bh=6xnfxO24XeMhZUOFnH7AZVi9lO940gonY1iIvv10IoA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cW6wpju3MWAKrNyAJkSDvImta46iaPEcFmf9zXCA2DtbSw4CJ1XnaRf4DzYNVP5HTlVYP/+NEeGpPUaRzEuyZU5GOaLawaGaN9L8SWbRoJDSJVlalU3SY1YaaQJ9IGra1MA/M+v6hNQnLh7DZobu4r1QL4fM3FMYyuiUnjsv93I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XkaEMeWL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E056C4CEEC;
	Tue,  8 Apr 2025 10:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744109561;
	bh=6xnfxO24XeMhZUOFnH7AZVi9lO940gonY1iIvv10IoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkaEMeWL7T3raAwIOg9GQo3401h7UNEQWGsIrXyJHpCrTVkmLEhvqwrmDHI0oHx3m
	 Yjn5/CtG1hefl7Ihm50qVNiHYbR+w7dGSPuRtR0Dq4SeRXOfTz2ExoX8q1/ZKpITFg
	 xwjy0dTnCjxqE2jdgJd1n+N1KmT7MxxBkujgvNAQrEIUEQtFTdJpbbZ2JqHAlOV1sV
	 lQHkdjloCOY0xI5r1Fq6YqBg8oAHrOE5ijoJ8MkvT74qg42pP5gkLexZnWv4v50z6Q
	 bbv7F9FbpS4h8MPUakE0RVnUmuDNUugDrI+3smd8Qf6RXdDbZ6ZTOaJsLAGkLUbwn9
	 B6q05JjDWsWPw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u26ZL-003QX2-UZ;
	Tue, 08 Apr 2025 11:52:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 15/17] KVM: arm64: nv: Remove dead code from ERET handling
Date: Tue,  8 Apr 2025 11:52:23 +0100
Message-Id: <20250408105225.4002637-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250408105225.4002637-1-maz@kernel.org>
References: <20250408105225.4002637-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Cleanly, this code cannot trigger, since we filter this from the
caller. Drop it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 0fcfcc0478f94..5e9fec251684d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2471,13 +2471,6 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 {
 	u64 spsr, elr, esr;
 
-	/*
-	 * Forward this trap to the virtual EL2 if the virtual
-	 * HCR_EL2.NV bit is set and this is coming from !EL2.
-	 */
-	if (forward_hcr_traps(vcpu, HCR_NV))
-		return;
-
 	spsr = vcpu_read_sys_reg(vcpu, SPSR_EL2);
 	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
 
-- 
2.39.2


