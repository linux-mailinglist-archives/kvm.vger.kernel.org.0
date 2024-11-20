Return-Path: <kvm+bounces-32126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BACAD9D3419
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 08:28:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 810C2283403
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 07:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA2A315B543;
	Wed, 20 Nov 2024 07:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KzSSG0bn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164C9200CB;
	Wed, 20 Nov 2024 07:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732087674; cv=none; b=uqwvy3uzuB++mDMzl2Aold1OgBsiegupQQz5rjTVo7gR2WEGOin0jVaA+ztwypOkyXImtKaDs7wYa9jIz6AweqfA6mD5A2dR+DNwKLNQS4faOpCGozlIPSXBrpp5aUU5OzvEVxU9pAE98Ajy66Vs7S6Qp8qi4xg3sUNMiCLSK1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732087674; c=relaxed/simple;
	bh=ihy9wY/FIJOxmtptMVLWSWjxyBuudhtyB6vZBrlC0Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HX0Joi8qdE4X5L6L1B11hfraDLK+3BprGqDjwWf5cbyO++an7/XSy79MeFVgIhutWt9ppZF7BcNgWvKrtiEnxGahq4VMI2y/PMSOUMHsilcWR+tG8VIuoDqmgLrPYcyT7++FIEeZG+qN/3SzMvRD26kL0OUJv4eMtP4wH1xFtYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KzSSG0bn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB76EC4CECD;
	Wed, 20 Nov 2024 07:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732087673;
	bh=ihy9wY/FIJOxmtptMVLWSWjxyBuudhtyB6vZBrlC0Uc=;
	h=From:To:Cc:Subject:Date:From;
	b=KzSSG0bnwKF6H7jItX5ZfWx8EL58nrejUbu1BcqgtuMOMkqK2kmH0rfLO0L4Bab55
	 zZivOJdIuZxGF9z1qNoBaJpdhlgfGb/H8D6LpdqVyYhk7P+sGkRzX/Ugl2OLK8Tpd7
	 YZ86IMMDMKz3H90jED8l/XCnlo0L+qk6y1o7ejVw9Ea+N/JXRAv/uRtYGaZsn1eCWF
	 CVW1y9oSR+UyH8SPBY9umr9mK6g8Jbp8X14h69cJ4KYB8CqsX+sClzSVJ+HpWEUirp
	 kXf9/hY44Ee4vSr6t7icVke6q6TFIYM1EBFc3rP7MJl0NowVMq3htALhjuXXRHUCyp
	 hFMSPW5ULZvdg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	amit@kernel.org,
	kvm@vger.kernel.org,
	amit.shah@amd.com,
	thomas.lendacky@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com,
	kai.huang@intel.com,
	sandipan.das@amd.com,
	boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com,
	david.kaplan@amd.com,
	dwmw@amazon.co.uk,
	andrew.cooper3@citrix.com
Subject: [PATCH 0/2] x86/bugs: RSB tweaks
Date: Tue, 19 Nov 2024 23:27:49 -0800
Message-ID: <cover.1732087270.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some RSB filling tweaks as discussed in the following thread:

  [RFC PATCH v2 0/3] Add support for the ERAPS feature
  https://lore.kernel.org/20241111163913.36139-1-amit@kernel.org

Josh Poimboeuf (2):
  x86/bugs: Don't fill RSB on VMEXIT with eIBRS+retpoline
  x86/bugs: Don't fill RSB on context switch with eIBRS

 arch/x86/kernel/cpu/bugs.c | 97 +++++++++++++++-----------------------
 arch/x86/mm/tlb.c          |  2 +-
 2 files changed, 38 insertions(+), 61 deletions(-)

-- 
2.47.0


