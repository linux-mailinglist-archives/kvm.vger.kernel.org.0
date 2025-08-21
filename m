Return-Path: <kvm+bounces-55334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF581B301EF
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:23:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4F7B568492
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 18:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024BF3469E0;
	Thu, 21 Aug 2025 18:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNoLslh3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F792343D82;
	Thu, 21 Aug 2025 18:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755800590; cv=none; b=J4ht90YivgdC34QG8OYpjyeR0J0vZ5aES8ipiFul+0erwI+cryew+uo+Hw64ONtw9zW9nQgiVRV6q9Z/S3LlT4nlEw8/G4ib0SXEHn6QHnhjifEMQtdnKNg5YmCVY4lxGEL+6C9zf9yu0OmZy0vgbj1ZPx8Dmjfa3nXBcJucQ/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755800590; c=relaxed/simple;
	bh=FJElYwFWMkHBmKZmwX5ZW0wOgAGaF8KcxGG+//Rl2Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJAlPyOvQWd1GbNcO8mjE4nzM/X3X8ZAe3s1ClRkuy/XWrrRKYchjlfBnpLebs2K065qN33hcwMTsEFGzyBOHLrg8KRQW3nqI9jZ3bAJstNzFwR+YJvJe2OSXZBcay+h/vFah7MUh9eRtLTHBAzshVjzItNRWnvjD+DZWzq8VoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNoLslh3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D51C4CEEB;
	Thu, 21 Aug 2025 18:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755800589;
	bh=FJElYwFWMkHBmKZmwX5ZW0wOgAGaF8KcxGG+//Rl2Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNoLslh3T0lXIAOdCatK5wSh7IrThadZeDBkN2PXdGFwGS0uxzXA5KMJ7yNeaxCdI
	 goIX2UnCOVpnTvKfOf8ZDB4hqLlTQ6AFgQ4fCMWFJUznvWnJb1PZDsAsPTfwa9y1SR
	 llNEjDr0BWOUZF/FfHDowGe50d8a+TGnkxv1lOHphyJDXMk0zY7v51pAgpaj3rJfXH
	 QzZkCVfFj7q+pyIn7h0+CKXLfVV/0A9OC90lnGvMMk0YPysWEcAWaVuEqazFvwj6lI
	 3yu9vyCcSbf5N0qAD1/BHqGvYsTRaS6FvLdwKMIRaa6McRkxWECxXCbXaPX3SiECPn
	 QGT3Uyyyt/SZA==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH v4 4/7] KVM: SVM: Expand AVIC_PHYSICAL_MAX_INDEX_MASK to be a 12-bit field
Date: Thu, 21 Aug 2025 23:48:35 +0530
Message-ID: <a464adcfbe48e4d2febf2b0e480231f1f1a56162.1755797611.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755797611.git.naveen@kernel.org>
References: <cover.1755797611.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the latest APM describing AVIC support for 4k vCPUs, VMCB
AVIC_PHYSICAL_MAX_INDEX (Offset 0xF8) and EXITINFO2.Index are both
updated from 9-bit wide to 12-bit wide fields unconditionally (i.e.,
regardless of AVIC support for 4k vCPUs). Expand
AVIC_PHYSICAL_MAX_INDEX_MASK accordingly.

While AVIC_PHYSICAL_MAX_INDEX_MASK is updated to a 12-bit field, KVM
will limit the max vCPU/APIC ID based on the maximum supported on a
specific processor and enforce that limit during vCPU creation. I.e.,
we don't need to rely on the mask to ensure that the max APIC ID being
programmed in the VMCB is in range. The additional bits (11:9) were
previously marked reserved and were never set/read by older processors.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/include/asm/svm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..58c10991521c 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -279,7 +279,7 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_IPI_VECTOR,
 };
 
-#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(8, 0)
+#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(11, 0)
 
 /*
  * For AVIC, the max index allowed for physical APIC ID table is 0xfe (254), as
-- 
2.50.1


