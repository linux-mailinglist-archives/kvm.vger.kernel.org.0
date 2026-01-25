Return-Path: <kvm+bounces-69060-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id h8SkJ1P5dWmwKAEAu9opvQ
	(envelope-from <kvm+bounces-69060-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 12:06:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F7CD80240
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 12:06:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E6DA330073F1
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 11:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD584319877;
	Sun, 25 Jan 2026 11:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="wLeDDtfu"
X-Original-To: kvm@vger.kernel.org
Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B2AE55C;
	Sun, 25 Jan 2026 11:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769339214; cv=none; b=l8AACTD+LvCtSGDdII5q1xWn0r50f4La99fdt5aUErsF27yFqV2ENUyC+iIeN4KZyvP1SxFb+OkwDhKnYoxD3HKKSrtwgCZIEO8GWHOQKdLFFn8Jbvl+lv2CQroJlnVBi4jCJ9mn7/ig8cH0m24Oz/q2NndUBtw5vtawg6sB/iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769339214; c=relaxed/simple;
	bh=U/ajKVtouNzP2s42JzTs7DtJ2K4Utw3zz67CrSntjYU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZKNEguZqf7d1En9svzj67MqBdeRPwHTp/8+xy4R5XwsfbLst7wk7fXqmT34O5T3Xrr0Pf4vOcbYCTnQObg841KOnO5EKqdvUnjK1bB5PvmU0YZ4c4EykTjBT0DHj7KNKuwXOmuWb8OJf6zjSMBMpBRh+3zsGAJvqCz9AL13tQ8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=wLeDDtfu; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1769339210; bh=U/ajKVtouNzP2s42JzTs7DtJ2K4Utw3zz67CrSntjYU=;
	h=From:To:Cc:Subject;
	b=wLeDDtfuyIRi/CbYy5RT+pTHRB6aWff3xR0lGlBhcMzTvludXmZePDr736tGgAkmi
	 iZhw/px6WVHo4mHESelewTun1IxgO4C0XVh9SWO87UR7Rloh55H715eDrmtnkUs3UO
	 Tckdv/ZxIZA8U/Bk3+v+u9wC117v99ha1w9IRSUN0+Lgx9uCFMx5+hBi3APh13UK+J
	 Cytoh+K5ad6eVL3a77IwfDq2GJzBwBaNI1Ll9zqo/wY8pnHC+ygp36YUhDFsYSvkjj
	 tRpXI+QxkZ9tbsHd8O3J3+ZPiAM/J0RY08p2K0XapbfaV8mtScutGSovc0Ya1LGx/K
	 4KKBim1+d1Gfw==
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
Subject: [PATCH v5 0/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
Date: Sun, 25 Jan 2026 12:06:28 +0100
Message-ID: <20260125110629.43096-1-thomas.courrege@thorondor.fr>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[thorondor.fr:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69060-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0F7CD80240
X-Rspamd-Action: no action

For testing this via QEMU, please use the following tree:
        https://github.com/Th0rOnDoR/qemu

Any feedback is appreciated.

Thanks,
Thomas

Patch History
==============

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


Thomas Courrege (1):
  KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command

 .../virt/kvm/x86/amd-memory-encryption.rst    | 29 +++++++++
 arch/x86/include/uapi/asm/kvm.h               |  9 +++
 arch/x86/kvm/svm/sev.c                        | 62 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 31 ++++++++++
 5 files changed, 132 insertions(+)


base-commit: e89f0e9a0a007e8c3afb8ecd739c0b3255422b00
-- 
2.52.0


