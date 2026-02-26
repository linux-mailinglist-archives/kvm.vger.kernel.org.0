Return-Path: <kvm+bounces-72005-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yNLBDNdcoGm3igQAu9opvQ
	(envelope-from <kvm+bounces-72005-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:46:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BBB481A7D47
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:46:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 408E63066837
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB113D2FF4;
	Thu, 26 Feb 2026 14:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b="escqfQNJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E050C37474B;
	Thu, 26 Feb 2026 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772116657; cv=none; b=TgB5g/XX/amsHv7J5D0JAbLwBlLcd8REN+B93hNgIoy14CdGj8LBDt+iMDQeRATQo4ayh4/fZdm0/QcZbs3sL26yea4SQITZZQlJqXinQ5UJOVMu2eMsXMyH2qx0FB76gggXGBo0NzgCsCIyCNPlU7OZJGDv1xwQiZ3Sxx8RwMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772116657; c=relaxed/simple;
	bh=Vz58WHttVcNQG/3Jcd9G0PXWP0L7ogtzIBHgWQI8H8k=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=tDO2EYepAbjXC1O0m948bteKr1XqQnJy9v73U6+Yb38x+djTbfd/qMsaTwpjJ+1r8HyiTwgcIqeX6b1r6ibmt7S5vBSbcylBtJXSf1ZQhTQsy6kp1q23ogxIQ5kawXz8MNisFiTbv8SGuc1H38SwsUkBklhCcqCtm3o1jgPLh0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de; spf=pass smtp.mailfrom=cispa.de; dkim=pass (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b=escqfQNJ; arc=none smtp.client-ip=134.76.10.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=CC:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-ID:Date:Subject:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yfLVFM+oU/NWcIIH45tixxiV4mTmdtkw+rbkH4ApJwE=; b=escqfQNJFPMIlXL3vrUb8dEfo5
	X+GRTkPUpTHVk8PD/UbNdrYubrjlEeBHtbWGGRjRHcLK8QkYw5fTMVlWHWBR4p6y5tDvigyxhOahN
	x4rPH1zTXxmwfuVx9j6S1q+AsKukd1XRJO5R8wbLCd3lV+e5urIk4IO/Mp4xivjf2ChMiUl5ZRI60
	WZSdkj5ussdfy7woOwm7j8q1d57zLH6yQ7fTz1QsaIssYt9RNN2KxbayVYexfRhzBrw/bCYun8hlP
	5OTYp5uE0puOOlxVRa4W1+Z1ZFiCcO3qrqLTy4HohDxYaAdx/mgOgt6QaO++e/ryhxO33ymCc8cXD
	s5saVNww==;
Received: from mailer.gwdg.de ([134.76.10.26]:38446)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vvcD5-006EFl-0Q;
	Thu, 26 Feb 2026 15:19:23 +0100
Received: from mbx19-sub-05.um.gwdg.de ([10.108.142.70] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vvcD5-0009uO-28;
	Thu, 26 Feb 2026 15:19:23 +0100
Received: from
 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa
 (10.250.9.200) by MBX19-SUB-05.um.gwdg.de (10.108.142.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.37; Thu, 26 Feb 2026 15:19:12 +0100
From: Lukas Gerlach <lukas.gerlach@cispa.de>
Subject: [PATCH 0/4] KVM: riscv: Fix Spectre-v1 vulnerabilities in register
 access
Date: Thu, 26 Feb 2026 15:18:57 +0100
Message-ID: <20260226-kvm-riscv-spectre-v1-v1-0-5f930ea16691@cispa.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MSQqAMAwAvyI5G6hFivgV8SBp1CAuJFIE6d8tH
 gdm5gVjFTboqxeUk5icR4GmroDW6VgYJRYG73xw3gfc0o4qRgntYrqVMTXYRtdGCh0VA0p6Kc/
 y/NthzPkDOosoY2YAAAA=
X-Change-ID: 20260226-kvm-riscv-spectre-v1-4d04dc68c226
To: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert
 Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones
	<ajones@ventanamicro.com>
CC: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, Daniel
 Weber <daniel.weber@cispa.de>, Michael Schwarz <michael.schwarz@cispa.de>,
	Marton Bognar <marton.bognar@kuleuven.be>, Jo Van Bulck
	<jo.vanbulck@kuleuven.be>, Lukas Gerlach <lukas.gerlach@cispa.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=953; i=lukas.gerlach@cispa.de;
 h=from:subject:message-id; bh=Vz58WHttVcNQG/3Jcd9G0PXWP0L7ogtzIBHgWQI8H8k=;
 b=owGbwMvMwCGWoTIjqP/42kTG02pJDJkLwuLbsoSz4hZar4j8WX7Uckm50Llp622yPnpOm6Q21
 3rF0tmdHaUsDGIcDLJiiixTBV8z9u1x4EnKPHwOZg4rE8gQBi5OAZjInwKGv/KG3F0zchdXaFpG
 6cyt4DS9nLYjjft8cdvZewWCZd3J/gz/a7qUey7kaMbKHH3G4jOjIfy6RdZL9TVGCwQKnNhVOk1
 YAA==
X-Developer-Key: i=lukas.gerlach@cispa.de; a=openpgp;
 fpr=9511EB018EBC400C6269C3CE682498528FC7AD61
X-ClientProxiedBy: mbx19-sub-02.um.gwdg.de (10.108.142.55) To
 MBX19-SUB-05.um.gwdg.de (10.108.142.70)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_REJECT(1.00)[cispa.de:s=2023-rsa];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[cispa.de : SPF not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72005-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[cispa.de:-];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lukas.gerlach@cispa.de,kvm@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,cispa.de:mid,cispa.de:email]
X-Rspamd-Queue-Id: BBB481A7D47
X-Rspamd-Action: no action

This series adds array_index_nospec() to RISC-V KVM to prevent
speculative out-of-bounds access to kernel memory.

Similar fixes exist for x86 (ioapic, lapic, PMU) and arm64 (vgic).

Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
---
Lukas Gerlach (4):
      KVM: riscv: Fix Spectre-v1 in ONE_REG register access
      KVM: riscv: Fix Spectre-v1 in AIA CSR access
      KVM: riscv: Fix Spectre-v1 in floating-point register access
      KVM: riscv: Fix Spectre-v1 in PMU counter access

 arch/riscv/kvm/aia.c         | 11 +++++++++--
 arch/riscv/kvm/vcpu_fp.c     | 17 +++++++++++++----
 arch/riscv/kvm/vcpu_onereg.c | 36 ++++++++++++++++++++++++++++--------
 arch/riscv/kvm/vcpu_pmu.c    |  4 ++++
 4 files changed, 54 insertions(+), 14 deletions(-)
---
base-commit: f4d0ec0aa20d49f09dc01d82894ce80d72de0560
change-id: 20260226-kvm-riscv-spectre-v1-4d04dc68c226

Best regards,
-- 
Lukas Gerlach <lukas.gerlach@cispa.de>


