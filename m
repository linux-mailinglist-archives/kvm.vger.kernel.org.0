Return-Path: <kvm+bounces-71494-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Hr2H2WBnGnIIgQAu9opvQ
	(envelope-from <kvm+bounces-71494-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:33:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2336E179DA5
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:33:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3A26C3078144
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756F1313E38;
	Mon, 23 Feb 2026 16:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b99W0qSZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A044B313E01;
	Mon, 23 Feb 2026 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864279; cv=none; b=DXkQyHMjlkJPDol3iveC5DxKaldO25gyncrX7/XdGF6CRTPiWSm+yj/73Jk+MFnVQndbZQP5IXZMuHFms3xlbHwl/VNHdL/pekv0yKGDrFd6wTl0jqVyN00L5Jv+VEVeGTcATsr2lBJ3nWfZVfysWIddiW8edXN2GAOs5+FkTE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864279; c=relaxed/simple;
	bh=uuaG1+35nzjKYKeAcl5WM3Rz2Y1FHB1m2vHOyxf+ISs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UhzMTPbq4PqG0NyxK5ZIM1jRguFWih2hTOyJ7b8A7stc7nnXnQ4/eRLJayRxo8SQTyu5RXZMYgHuiT7/DH6GnKZ8nX+Sd2CGeXiuVa8xGShYnF8rYvqG2HW7MbIHhvq0xXC8HNs3Gs7PjhB1eW0od+aSGgVczVkOPXsiulKZm1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b99W0qSZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A74C116C6;
	Mon, 23 Feb 2026 16:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771864279;
	bh=uuaG1+35nzjKYKeAcl5WM3Rz2Y1FHB1m2vHOyxf+ISs=;
	h=From:To:Cc:Subject:Date:From;
	b=b99W0qSZjSHcF7gPMKTJtPLuZ/DxMbs3zKjGpzHr8sQMLAal8d22Ue1YgHeyrp6cF
	 +CSJzjtSLIkyQYmBJ0NpGUZPzUmuly5fKelK6ak6FFF7snTiYtpycDeYHYtMrkvAnX
	 5bVKBQbXOjYhvKBXmYvd5MlwAlybbOcLvap2qzdUXfMzrWRuqePjEnu7POm5/Y1pQY
	 890BLaSqRXrR49tVgpTndiL3yMFDOc7e5v6InL/FGWxd53eZeT1ap62cOCNgzoqveR
	 DNFBbyqqSwRxmfqxfi2clypo7Z+PHUhy4o+KJT9rHq4ItK7LaTMJFD3wkt+wuL99uS
	 SDEL5CgjJcKUQ==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 0/4] Allow setting RAPL_DIS during SNP_INIT_EX
Date: Mon, 23 Feb 2026 09:28:56 -0700
Message-ID: <20260223162900.772669-1-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
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
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71494-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tycho@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2336E179DA5
X-Rspamd-Action: no action

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

There was support for setting the policy bit, but not the flag during
SNP_INIT_EX, which meant VM creation would always fail. Plumb a module
parameter for setting the flag during SNP_INIT_EX.

Also clean up some selftests and add a smoke test for RAPL_DISABLE
when the module parameter is set appropriately.

Tycho Andersen (AMD) (4):
  selftests/kvm: allow retrieving underlying SEV firmware error
  selftests/kvm: check that SEV-ES VMs are allowed in SEV-SNP mode
  crypto/ccp: support setting RAPL_DIS in SNP_INIT_EX
  selftests/kvm: smoke test support for RAPL_DIS

 drivers/crypto/ccp/sev-dev.c                  | 14 +++++
 tools/testing/selftests/kvm/include/x86/sev.h |  7 ++-
 .../selftests/kvm/x86/sev_migrate_tests.c     |  2 +-
 .../selftests/kvm/x86/sev_smoke_test.c        | 61 ++++++++++++++++++-
 4 files changed, 79 insertions(+), 5 deletions(-)


base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
-- 
2.53.0


