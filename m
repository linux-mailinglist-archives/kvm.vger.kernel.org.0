Return-Path: <kvm+bounces-39113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7068A4415A
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 14:52:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C3EF189669B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 13:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEDF26A0AD;
	Tue, 25 Feb 2025 13:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q8+hFLgF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B5C2698A2
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 13:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740491553; cv=none; b=LVysOqgv4pO+liHtPoQa54jxb0d/VmGUmG+5EZZSua2Tu9vXq+XmsNdqHxGcEpejmYEXD8UEeCM8ccPe5x+FkDuQ1xmTGa8KjLExrl1QA4bpGi5NnzpEZwVedHBRhGgNaiF4XLJVsDy+ce16klcEYgOpPA03wg269iAVlgFXiRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740491553; c=relaxed/simple;
	bh=4M9YtIWRYkhNFPRkpSeuIwBeyPnax1SxZlBHkaST38w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUSXw9nM+adD7NkytKsUdCQh4IRqgT3w1Z4uodGQ2t2B4xdYqFb2LiiDU+FI6ZmudHAjOq5g86Fs0CstYKN2MAMzemiogT9R2inl5iSw409i0M3RFMHZxHppAwU0tCSN6TWAVbzH7mgCRoQ1r3TNqJdFMg+B8HHzVJ+k/gScF2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q8+hFLgF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357B4C4CEDD;
	Tue, 25 Feb 2025 13:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740491552;
	bh=4M9YtIWRYkhNFPRkpSeuIwBeyPnax1SxZlBHkaST38w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8+hFLgF20WjqI8XL8yvN9zjDu+E7zvJ/oE50FBtqfrEHvL60Ky3yQJ6qXXKa42jr
	 Z3EI4qy+OuLUzFipEnoR+nWakXQ8PNJ7vpN3gcFvrpVegCdtFD+94fV3FnxS4RPph6
	 8GI4/ttE/BmZj0CbxPKOMbE5aeyvMk/DnekHSYgyNZlzTPutJej8uPWjX0l1ZG+8/x
	 JXnedqcJwGOA/sJQvAm97ePU4Z3Rj16PHXCryRGVjsZbdIBge6ymuNpSX9ACVPbUKr
	 C0mc45zlu2Hb1qqB06Ziq8Ik7/1ulagnR2/80uo/eEtI2CXYHnmoyUbTUOT3NwSpqU
	 fBf9BR1GHwVtA==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFC kvm-unit-tests PATCH 3/4] x86/apic: Disable PIT for ioapic test to allow SVM AVIC to be tested
Date: Tue, 25 Feb 2025 16:10:51 +0530
Message-ID: <7dfb12588b6e0a5d91be0bdca4a64b222b5be2ae.1740479886.git.naveen@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740479886.git.naveen@kernel.org>
References: <cover.1740479886.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SVM AVIC is inhibited if kvm-pit is present in the default reinject
mode. Disable PIT so that AVIC is exercized with the ioapic test.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 35fb88c3cb79..b057b59b1e30 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -42,7 +42,7 @@ groups = apic
 [ioapic]
 file = ioapic.flat
 smp = 4
-extra_params = -cpu qemu64,+x2apic
+extra_params = -cpu qemu64,+x2apic -machine pit=off
 arch = x86_64
 groups = apic
 
-- 
2.48.1


