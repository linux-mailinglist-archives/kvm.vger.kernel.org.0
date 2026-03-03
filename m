Return-Path: <kvm+bounces-72577-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qFawHro0p2k9fwAAu9opvQ
	(envelope-from <kvm+bounces-72577-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:21:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15AF71F5E88
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:21:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5799531B16D2
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A405337268E;
	Tue,  3 Mar 2026 19:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0sXClsp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF6F389116;
	Tue,  3 Mar 2026 19:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772565353; cv=none; b=kUT9lIZzIBifnIllOQZAhawOjSKrCs943va2vcjVrLRsbTufio3z7gb8zttnclXTS//HGFcwsDKbtu0tauXr0dHrHsvTO+VJXXJskqrERixMscdTaZDObPM6FdOjGPucmZ8iZwtJ7ddnrpMQTIODVvDRUpFIYHQa+Xx6Yowpu9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772565353; c=relaxed/simple;
	bh=kveI5NdoYoIPiQcLw4KGZAcgSTGkk3UJZOxqHb0xznI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsadcVwS2efrtEsJz489yljzAe/g2BiKu08zd3OwlX54bUU2OiZraqLaUN7qH9YT4AQ4FDp46QTCGlDvvLpcqEd2jL1t3BLo0ApnAWfjONcCYUcD+ufNO5T/3EyNG+uj6ykwNBFQ1QsRHnyn2wVe7WLZdxOB001LCBhaLR8fF1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0sXClsp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D902C2BC87;
	Tue,  3 Mar 2026 19:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772565353;
	bh=kveI5NdoYoIPiQcLw4KGZAcgSTGkk3UJZOxqHb0xznI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0sXClspFtHY3XbFdqQrUUCHWxpbkkh2dvqIz+IwyRrZsfIyVB5Meb3fZhlvLekdd
	 zWqLceVOwjhYcCYdWSWGWxYqF4Li+dDCfXdg6/KOElpVI3NhKO6fXbAqQ5wy3YgyM0
	 Y/3oXio5DHunahkRExUl+u0r6MXNDABpw29r1EiV2jedB+Ie2TtRnhnuNTsuAP99ie
	 cKaJkn5OeS8DZ5xEENTw/BfWqx79cxP8J+MOjVyf1pIfyORKRpZrwhRJKyFwmSXSN6
	 I493ITnNim3fGebXVSp055CztwuyxaA3fcaIU6TrEJLHhbbHFnPgrlRubSw78nHFLO
	 1wcMmZsaIwGBw==
From: Tycho Andersen <tycho@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Shuah Khan <shuah@kernel.org>
Cc: Kim Phillips <kim.phillips@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 4/5] kvm/sev: mask off firmware unsupported vm types
Date: Tue,  3 Mar 2026 12:15:08 -0700
Message-ID: <20260303191509.1565629-5-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260303191509.1565629-1-tycho@kernel.org>
References: <20260303191509.1565629-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 15AF71F5E88
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72577-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tycho@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

In some configurations not all VM types are supported by the firmware.
Reflect this information in the supported_vm_types that KVM exports.

Link: https://lore.kernel.org/all/aZyLIWtffvEnmtYh@google.com/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f941d48626d3..eeae39af63a9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2976,6 +2976,8 @@ void __init sev_set_cpu_caps(void)
 		supported_vm_types |= BIT(KVM_X86_SNP_VM);
 	}
 
+	supported_vm_types &= sev_firmware_supported_vm_types();
+
 	kvm_caps.supported_vm_types |= supported_vm_types;
 }
 
-- 
2.53.0


