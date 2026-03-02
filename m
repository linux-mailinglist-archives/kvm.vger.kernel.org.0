Return-Path: <kvm+bounces-72379-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GDFBDOejpWngCwAAu9opvQ
	(envelope-from <kvm+bounces-72379-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 15:51:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 29D281DB2FA
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 15:51:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4818C3049C97
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 14:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A09401493;
	Mon,  2 Mar 2026 14:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="lHWAxzpB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47D83E0C7C;
	Mon,  2 Mar 2026 14:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772462611; cv=none; b=cHAWI28B5UpAzkdvTjpoUPFr0ccaIE9+xF+6MVQV0MLW4sLSI3mVRdyDRnmdEU/ie/UG4XODFbPrFEBe44FE04APquGXXz6FkxRGqkXzeewnfZxCNAMN9E5VIRckaArousfvcxkHnBHb/4ERHT+QnBlMt4/4P6iSgVk4KdNbfx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772462611; c=relaxed/simple;
	bh=pBNHnYeTr5bMbtVN0pOp2JWteLH8/cK0PbgI1wwB2U8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BXbGJ1d2kqgDYm5G5dAalsKHMliluhFoxK38S7s7ihRdBfokvvtcEunaAUuVKNjfC2yMemkBiznN69X63Y7jS4Okp5VtDfQXAJ1TkKxKqH6Axiy2oINTzeYuhuCwkp8tCfOQeIUUP/g6MUL/4wJBqVgdAk5z8HQlcdWCzusByX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=lHWAxzpB; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1772462190; bh=pBNHnYeTr5bMbtVN0pOp2JWteLH8/cK0PbgI1wwB2U8=;
	h=From:To:Cc:Subject;
	b=lHWAxzpBbh3m4K8KboMCxSukIicUQlNqUbPyWPCxGXrre2PoGt0T217k+zjoYl/4+
	 A1FRa5vvggEgwkV4BCNCeJs8MbHPFiN/rCbOxW4RH8kw2EAcfx+YsN17RZlrLflaJd
	 zP9mc27m4Cd5KF2zGKdwujD9BiB6Hv4CN4Co+T/Ea1oWWXSrByzPMVESoMRmqIeMQ4
	 d1rPBDN2fSTgnwFSvBA5cTHlLHZYMRBfzIDAvaxVae8sjGVp9PMl/cV1FECQ13syuX
	 UteuVe0ch6iWO6o6ZlPD+SohM0URwHoWWZ0HZt06K+0I8Ue9R0jG8yBFn0XrIDuHWa
	 aGjnxAPpYr1Uw==
From: Thomas Courrege <thomas.courrege@thorondor.fr>
To: ashish.kalra@amd.com,
	corbet@lwn.net,
	herbert@gondor.apana.org.au,
	john.allen@amd.com,
	nikunj@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	thomas.lendacky@amd.com
Cc: kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Thomas Courrege <thomas.courrege@thorondor.fr>
Subject: [PATCH v7 0/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
Date: Mon,  2 Mar 2026 15:36:23 +0100
Message-ID: <20260302143626.289792-1-thomas.courrege@thorondor.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 29D281DB2FA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[thorondor.fr,quarantine];
	R_DKIM_ALLOW(-0.20)[thorondor.fr:s=mail];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72379-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.courrege@thorondor.fr,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[thorondor.fr:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,thorondor.fr:dkim,thorondor.fr:mid]
X-Rspamd-Action: no action


Overview
========
The SEV-SNP Firmware ABI allows the hypervisor to request an
attestation report via the SEV_CMD_SNP_HV_REPORT_REQ firmware command.

This allow KVM to expose more of AMD’s SEV‑SNP features.

It also allow developers to easily request attestation.
It could maybe be use by some cloud provider to easily provide an
attestation report through their API, in case the Guest doesn't respond
fast enough or even to compare the reports.

Testing
=======
For testing this via QEMU, please use the following tree:
        https://github.com/Th0rOnDoR/qemu

Patch History
=============
v6 -> v7:
Rebase after 7.0 merge window

v5 -> v6:
Fix typos issues in documentation

v4 -> v5:
Set variables in reverse christmas tree order
Fix and clean the rsp_size logic

v3 -> v4:
Add newline in documentation to avoid a warning
Add base commit

v2 -> v3:
Add padding to structure, code format
Write back the full MSG_REPORT_RSP structure
Remove the memzero_explicit for the report

v1 -> v2:
Renaming, code format
Zeroes the report before returning


Any feedback is appreciated.

Thanks,
Thomas

Thomas Courrege (1):
  KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command

 .../virt/kvm/x86/amd-memory-encryption.rst    | 27 ++++++++
 arch/x86/include/uapi/asm/kvm.h               |  9 +++
 arch/x86/kvm/svm/sev.c                        | 63 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 31 +++++++++
 5 files changed, 131 insertions(+)


base-commit: 55365ab85a93edec22395547cdc7cbe73a98231b
-- 
2.53.0


