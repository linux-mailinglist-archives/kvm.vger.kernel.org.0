Return-Path: <kvm+bounces-39115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C54A4415B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 14:53:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6F8416D081
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 13:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66BD026A1DF;
	Tue, 25 Feb 2025 13:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QnGssGnw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463062EB1D
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 13:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740491562; cv=none; b=TUuZgQy/UWN0XRzvGduYFAexfo8ArHG4hzHfTFZd+04uOLkdQWKprmoP7ouH7N3cNitevE+lG/Pzv5kURsimj7XiJCICUa8h936kKQ9Sr6W88Sf+kzXXuNH5FdLWuOFdUtQPtP8Mg8ApxPY+Ywqd8yeToQAhbCqvJ6pjSzudm8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740491562; c=relaxed/simple;
	bh=dIXYlNSEMwdsW7HhBFNnyBxdxXgyR4yX5aThGpx/xKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oh5Uz3Isq8D6RtAsITZwtgwLXsb3gQ6m2qUaB2R+foZ8Sbmzy5grzWsWvvScU2zCHHWTHfwaepasYFPsulb53biO0F3rkOksBRMy1FX5h2lwJrWUuBSdcg143/XB+ctkE9M5/3jPQJQ9TFnznDP7KqYCSBZwSNt+7tKfKDlgKiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QnGssGnw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33374C4CEDD;
	Tue, 25 Feb 2025 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740491561;
	bh=dIXYlNSEMwdsW7HhBFNnyBxdxXgyR4yX5aThGpx/xKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnGssGnwLab5+GpcNUAoAh4FKNcReblmbn5EVhqqCTx+p1aF/LbQAqTcsi8810heX
	 8z0vYDUSgMM7ef6qVR3c2VMeKg2clwgHo/0BDLxsdP35Vb4ZIm4YnIPIM7HCwyMhgT
	 1Bd7n1bXE2F/X82G/Oiax+7QTZf7O6r22oRBKkPxcrg0mJcxzcGHuxFNWzWUm2YIqm
	 Em0JnfevDwH9ZybgRiOe3sDEqHjnbg9I+go+d5GJg9ne5JH6B/yaJhXxIfG0I3o3do
	 1NnCbirdGf29c0W7iRAI9Z4Xj77gHPoyz86vBlBEFmuirCnTb6vm2KwALfys7GtuDu
	 6bq1sUJsNlSrA==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFC kvm-unit-tests PATCH 1/4] x86/apic: Move ioapic tests together and add them to apic test group
Date: Tue, 25 Feb 2025 16:10:49 +0530
Message-ID: <c0f6648c639b50f9ee6cfaca95d67e97525c37fc.1740479886.git.naveen@kernel.org>
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

Commit f5cfdd33cb21 ("x86/apic: Add test config to allow running apic
tests against SVM's AVIC") added most of the APIC tests to the "apic"
test group, but missed adding ioapic test. Add it.

Also move ioapic-split test next to the regular ioapic test to keep the
two together.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 x86/unittests.cfg | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 6e69c50b9b0d..8d046e6d7356 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -14,12 +14,6 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -machine kernel_irqchip=split
 arch = x86_64
 groups = apic
 
-[ioapic-split]
-file = ioapic.flat
-extra_params = -cpu qemu64 -machine kernel_irqchip=split
-arch = x86_64
-groups = apic
-
 [x2apic]
 file = apic.flat
 smp = 2
@@ -38,11 +32,18 @@ arch = x86_64
 timeout = 60
 groups = apic
 
+[ioapic-split]
+file = ioapic.flat
+extra_params = -cpu qemu64 -machine kernel_irqchip=split
+arch = x86_64
+groups = apic
+
 [ioapic]
 file = ioapic.flat
 smp = 4
 extra_params = -cpu qemu64,+x2apic
 arch = x86_64
+groups = apic
 
 [cmpxchg8b]
 file = cmpxchg8b.flat
-- 
2.48.1


