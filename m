Return-Path: <kvm+bounces-72530-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UPwVL7PvpmlKaQAAu9opvQ
	(envelope-from <kvm+bounces-72530-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:26:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B0521F16E0
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:26:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2C06430BC1DA
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 14:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6A73C2768;
	Tue,  3 Mar 2026 14:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b="G/X50Yg2"
X-Original-To: kvm@vger.kernel.org
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974603E51E9;
	Tue,  3 Mar 2026 14:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547597; cv=none; b=lhuBjGEppNfTiqccUZ6K1p9ZuwVMl62Gg2zNdOcYfQScOxqhtfXX8ZiBRcmh3XC30VHjeh/LkKGY7MxYdVXOypUXQecizkAKNZv/3lQFxOEtGHWsmoNHutC56wWsrRHjY56h5gRnRoHMS7ZhVt4YBVCervmO75rxiX/HA78UF5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547597; c=relaxed/simple;
	bh=TvGiCrPJ5gB7ACBx6XkfQjs2TuYKmp071Y3ILmNLpS0=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=XPJi88wab/EPiYmLwNIUV/WYNYofWvIXr5xStkKYcxD3jlRMu9xeW0Cl7oOWEl0Tjf9c3IIayYteNA8hp+XEenbUDahtH7Sg+/zhS6kjNh+EEeb5h32cBU/Z1+IEIaKwAH9mq/9NCwucal+BmzsTsOdO4K12K+3lHPqvgIV4F68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de; spf=pass smtp.mailfrom=cispa.de; dkim=pass (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b=G/X50Yg2; arc=none smtp.client-ip=134.76.10.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=CC:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-ID:Date:Subject:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Yk82U+KWKNBJrJErXLIwO/U/S9eC+6zTWy0oWkG4+U4=; b=G/X50Yg2QttbkXpWRAy/Gurn9r
	zl2DC3ZgCG84DKKNEuZ19k3oRwrGlsArhHbu4Laryc1uyzYxxWRIiU+1o3Cl8u3RH4Js29eRaIpBB
	Wh8q1BkMO5pzgJ6etzc9cikEMrSTmN8FRlHzee3WrH1qe7pNIIolJIvbH6q1TxuyscnTgVRlKRc+3
	//27EvAWVYhMhTbou86owUHkCGc/kmgJVaEv2l8IerNOHfcYIF+C4z4sY+Le5S1PCsWS5WkzI5YgU
	OT9KEli6uXJCHmwFng7T9QkEtZb5EZ8npaBy016/XoHpXTHID7xlBfFEbmaILESsAkC4wljdZD3p1
	eAKZdU1Q==;
Received: from mailer.gwdg.de ([134.76.10.26]:42647)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vxQb7-00850E-2q;
	Tue, 03 Mar 2026 15:19:42 +0100
Received: from mbx19-sub-05.um.gwdg.de ([10.108.142.70] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vxQb8-0006k0-25;
	Tue, 03 Mar 2026 15:19:42 +0100
Received: from lukass-mbp-7.lan (10.250.9.200) by MBX19-SUB-05.um.gwdg.de
 (10.108.142.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Tue, 3 Mar
 2026 15:19:42 +0100
From: Lukas Gerlach <lukas.gerlach@cispa.de>
Subject: [PATCH v2 0/4] KVM: riscv: Fix Spectre-v1 vulnerabilities in
 register access
Date: Tue, 3 Mar 2026 15:19:40 +0100
Message-ID: <20260303-kvm-riscv-spectre-v1-v2-0-192caab8e0dc@cispa.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNTQrCMBCFr1Jm7UgSa7CuvId0EZKpHcS2zJSgl
 Nzd2AsIb/M93s8GSsKkcG02EMqsPE8V3KGBOIbpQcipMjjjvHHO4zO/UFhjRl0orkKYLbbJtCn
 6S6wJqNVFaOD3PnvvK4+s6yyf/SXbn/tnsMrgeehOhoL1vrO3yLqEYyLoSylfvYoXFbcAAAA=
X-Change-ID: 20260226-kvm-riscv-spectre-v1-4d04dc68c226
To: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert
 Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones
	<ajones@ventanamicro.com>
CC: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <radim.krcmar@oss.qualcomm.com>,
	<kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, Daniel
 Weber <daniel.weber@cispa.de>, Michael Schwarz <michael.schwarz@cispa.de>,
	Marton Bognar <marton.bognar@kuleuven.be>, Jo Van Bulck
	<jo.vanbulck@kuleuven.be>, Lukas Gerlach <lukas.gerlach@cispa.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1070;
 i=lukas.gerlach@cispa.de; h=from:subject:message-id;
 bh=TvGiCrPJ5gB7ACBx6XkfQjs2TuYKmp071Y3ILmNLpS0=;
 b=owGbwMvMwCGWoTIjqP/42kTG02pJDJnL3v6V+iDzwOlfkeXPiGve/rvOGf4ujki/cPWizUJF3
 RvzJqVM6ChlYRDjYJAVU2SZKviasW+PA09S5uFzMHNYmUCGMHBxCsBERJkZ/mfvPhJgcfZpQDXX
 z03fE08Zrq/aV3g0xHP6yiVf22U+2Exg+O/B2mQ6demek9s6es1YL9jP/dJqdboxTOi4x5GzD5S
 XTeIFAA==
X-Developer-Key: i=lukas.gerlach@cispa.de; a=openpgp;
 fpr=9511EB018EBC400C6269C3CE682498528FC7AD61
X-ClientProxiedBy: MBX19-SUB-05.um.gwdg.de (10.108.142.70) To
 MBX19-SUB-05.um.gwdg.de (10.108.142.70)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -
X-Rspamd-Queue-Id: 5B0521F16E0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_REJECT(1.00)[cispa.de:s=2023-rsa];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[cispa.de : SPF not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lukas.gerlach@cispa.de,kvm@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.978];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72530-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[cispa.de:-]
X-Rspamd-Action: no action

This series adds array_index_nospec() to RISC-V KVM to prevent
speculative out-of-bounds access to kernel memory.

Similar fixes exist for x86 (ioapic, lapic, PMU) and arm64 (vgic).

Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
---
Changes in v2:
Add array_index_nospec() to four additional sites in vcpu_pmu.c
(Radim Krčmář)

---
Lukas Gerlach (4):
      KVM: riscv: Fix Spectre-v1 in ONE_REG register access
      KVM: riscv: Fix Spectre-v1 in AIA CSR access
      KVM: riscv: Fix Spectre-v1 in floating-point register access
      KVM: riscv: Fix Spectre-v1 in PMU counter access

 arch/riscv/kvm/aia.c         | 11 +++++++++--
 arch/riscv/kvm/vcpu_fp.c     | 17 +++++++++++++----
 arch/riscv/kvm/vcpu_onereg.c | 36 ++++++++++++++++++++++++++++--------
 arch/riscv/kvm/vcpu_pmu.c    | 14 +++++++++++---
 4 files changed, 61 insertions(+), 17 deletions(-)
---
base-commit: f4d0ec0aa20d49f09dc01d82894ce80d72de0560
change-id: 20260226-kvm-riscv-spectre-v1-4d04dc68c226

Best regards,
-- 
Lukas Gerlach <lukas.gerlach@cispa.de>


