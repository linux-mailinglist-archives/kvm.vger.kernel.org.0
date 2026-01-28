Return-Path: <kvm+bounces-69411-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8O1oIptoemmB5gEAu9opvQ
	(envelope-from <kvm+bounces-69411-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:50:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F0593A8459
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:50:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A5E93042095
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113A0374741;
	Wed, 28 Jan 2026 19:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="DAWeqGzH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63E025DB12;
	Wed, 28 Jan 2026 19:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769629826; cv=none; b=ZdbAn+kJ9cn77Qghrz0eNpNkMrZ3lmmcUGBhDqzLJP8T7iMQy2sE5POxlwSpLRaNybiuskvnpgeYsTwHzylmVC90fvPwRWU4+3v0+poMmouujtV41KxjGXH09dQZZ6tAPy+on6BVwkfHHpYnBVL0+uwQgRR9APN15yNW/qyVY9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769629826; c=relaxed/simple;
	bh=m62tXWRWuYy8yrGSHppsuWL22LgI0zC5/hPwWv0H/Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lugnbu9pgOyGJumFNWjej9rDVqWCDmPsAbzl0rt6enABjUHOOo10veqrZFDDGmcmy5sy5OYQarHBx8/ygUbbPEbcoG+SzS6141ChZcNZm7LP4xFHIXBkFhRfzlDk73BqH+iJLZXDOB2NejDQJjwxWMlfqixlNPcCebeheTktjNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=DAWeqGzH; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1769629816; bh=m62tXWRWuYy8yrGSHppsuWL22LgI0zC5/hPwWv0H/Xk=;
	h=From:To:Cc:Subject;
	b=DAWeqGzHp31BCnnrgqHh0YhRaxtMFSQcN6IWD07GRiWaFdfqCLaxL0QdMAD/Lj+zE
	 VWULY4VoYtYxSRBtCPfiUP5TMhtRV6KvLfZ1R1lt/5xTdaoIfc/QfKRZ1KEaiJ8Y3b
	 kThdb6wII8IGg5r4fLHZHjpm0KSTHIndNNzK+BUQOvKqaWX3R1mZ25DuTh73Wec6Ye
	 1mkwT87hYbi75eWX9CgRYpMs/FvMdJDidFUau7bgu0dA5S8lXgMf+rwa7TLIKPoIfo
	 c5jUxmLDPExQV1DsGSk7WeP3dt3w9WqZJYRtNhmtNeTf/GsFDRvCANF2LloVNN4cJT
	 nXh4HmA+j/dOQ==
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
Subject: [PATCH v6 0/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
Date: Wed, 28 Jan 2026 20:49:55 +0100
Message-ID: <20260128194956.314678-1-thomas.courrege@thorondor.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[thorondor.fr,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[thorondor.fr:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69411-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.courrege@thorondor.fr,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[thorondor.fr:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,thorondor.fr:mid,thorondor.fr:dkim]
X-Rspamd-Queue-Id: F0593A8459
X-Rspamd-Action: no action

Overview
--------
The SEV-SNP Firmware ABI allows the hypervisor to request an
attestation report via the SEV_CMD_SNP_HV_REPORT_REQ firmware command.

Testing
-------
For testing this via QEMU, please use the following tree:
        https://github.com/Th0rOnDoR/qemu

Patch History
-------------
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

 .../virt/kvm/x86/amd-memory-encryption.rst    | 28 +++++++++
 arch/x86/include/uapi/asm/kvm.h               |  9 +++
 arch/x86/kvm/svm/sev.c                        | 63 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 31 +++++++++
 5 files changed, 132 insertions(+)


base-commit: e89f0e9a0a007e8c3afb8ecd739c0b3255422b00
-- 
2.52.0


