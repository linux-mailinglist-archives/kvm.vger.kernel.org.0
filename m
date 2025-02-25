Return-Path: <kvm+bounces-39111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C4B4A44158
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 14:52:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19AC016CF8F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 13:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE64269B01;
	Tue, 25 Feb 2025 13:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sGsyAtdD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28842EB1D
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 13:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740491544; cv=none; b=RBr33zSwkRZ8KlhWE5zbc3pI1Eso8W//JUH9ZwAnpfDKrGHAi/QdnUMK1hs+8YkiTYgVQ2PsatSMF97VC9g0UGzR0tL0WHxz/DI9Eec77w2/YiqbjFp5YIAwRXVSjddaEZ6PtJBmYMaeFwT8X0ZX592t0b6+J6/kATR6k11z9rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740491544; c=relaxed/simple;
	bh=JdtgCdRzgUGa5LvjtGaNVDWHm+xAg2yTsDZXi1K2ml4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HQKzEEVqFLJj0E6gZ18O/8Lausy5VzGuirffeVym79JCS9Tk4Y/iQcar80nbrfCrGBQ+/zfWYlpW9xe//yl6Ht9mWJ8ktaW8OSUCJ9s/CtZ/MPTGTcykYlpMax/iAKBsR53q5Wncvu6iArMB3D1r7gchX0Nvq9zbf+PexcQK91w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sGsyAtdD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B95C4CEDD;
	Tue, 25 Feb 2025 13:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740491544;
	bh=JdtgCdRzgUGa5LvjtGaNVDWHm+xAg2yTsDZXi1K2ml4=;
	h=From:To:Cc:Subject:Date:From;
	b=sGsyAtdDag9O0yA3XIbhSyGc7hHpxqDgMOoa0K5LyTQo4O8w1qXEuvAKsQFLM0hRR
	 1M0cbjAKHMzY+VcAXWJWUDmh0aT1vQNSPOrGKDpCPOrxTyRVZ3YL18/5eIYoeESJaq
	 LRu9PPa7HpfnkBaUCYGeuEIo3GEf1jZA8NtoVcft1Jr9VCajQ2I3JvMsOI4Ky7R1Fv
	 5YKO6K+otRseJ9WHDsiLcffO6EKbQ+XgHY28k+mVNF0QLgpHfs9D5NZ/B1VMg/lM1I
	 8RppIbn+77PpvWNU4h940jW8DVmvuVhFka2MO1CIv1oBzmGfqDlvRTe3Lk9wX5/jkz
	 uUm1GhfQ/xt1Q==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFC kvm-unit-tests PATCH 0/4] x86/apic: SVM AVIC tests and some cleanups
Date: Tue, 25 Feb 2025 16:10:48 +0530
Message-ID: <cover.1740479886.git.naveen@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first patch is a small cleanup. The next two patches update tests to 
disable PIT so that SVM AVIC can be exercized. The last patch adds a 
test for x1apic-split.

The last patch causes aliased apic_id ipi test to fail with older qemu 
versions. Qemu v6.2 and before used to enable 
KVM_X2APIC_API_USE_32BIT_IDS KVM quirk in some scenarios, and this was 
changed in commit dc89f32d92bb ("target/i386: Fix sanity check on max 
APIC ID / X2APIC enablement") to be enabled only if there are > 255 
vcpus. The KUT test does talk about this assumption in a comment:
  /*
   * By default, KVM doesn't follow the x86 APIC architecture for aliased
   * APIC IDs if userspace has enabled KVM_X2APIC_API_USE_32BIT_IDS.
   * If x2APIC is supported, assume the userspace VMM has enabled 32-bit
   * IDs and thus activated KVM's quirk.  Delete this code to run the
   * aliasing test on x2APIC CPUs, e.g. to run it on bare metal.
   */

That looks to suggest that this is an expected failure, but it would be 
good to get confirmation on the same.


Thanks,
Naveen



Naveen N Rao (AMD) (4):
  x86/apic: Move ioapic tests together and add them to apic test group
  x86/apic: Disable PIT for x2apic test to allow SVM AVIC to be tested
  x86/apic: Disable PIT for ioapic test to allow SVM AVIC to be tested
  x86/apic: Add test for xapic-split

 x86/unittests.cfg | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)


base-commit: 699264f5ef8129c60e9db7c281e572016ad41a45
-- 
2.48.1


