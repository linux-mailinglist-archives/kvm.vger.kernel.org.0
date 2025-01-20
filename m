Return-Path: <kvm+bounces-36030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 032CEA16FFB
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:19:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB9B93A90BA
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ECC61EBA09;
	Mon, 20 Jan 2025 16:18:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528BC1E9B33
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737389918; cv=none; b=g/cKQxHJHNgbASMMwB6//eliqZNo7Ie/iqHjp0ZLSxQ8kHs6xwMdcyrqFld39IeZiypbFWb5k1YvLPZ4d52w97wWyfAwJBLkjbLHiirBrkwWAfzI8khWuJ+IVMfUsHLB12AOCYl/m4aYG4SvLMMP53rAGV2sTgdcT1Dx+pqxiwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737389918; c=relaxed/simple;
	bh=z+vQqh7pwTAsF9RkwsAn/t9oMzJjPX+0U290heMAJu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hG4ZcRw1DGWxMIlP9YnN21Xp72iEqrfs3i2sm59onsoK5tCTjssj+VQCJlsLEp1FY60sAElLXZofDU5Ppf5t9fUUiv0qwQBGN3qWwYjsZx3dDsQSDKwuTdmdOiYEPIZAzUWoXWJNe7bekKvAQarpw1OATEX6jR6nthTO2qvpE6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DE021688;
	Mon, 20 Jan 2025 08:19:03 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4D383F5A1;
	Mon, 20 Jan 2025 08:18:33 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: apatel@ventanamicro.com,
	andrew.jones@linux.dev,
	andre.przywara@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH kvmtool v1 2/2] Do not a print a warning on failing host<->guest address translation
Date: Mon, 20 Jan 2025 16:18:00 +0000
Message-ID: <20250120161800.30270-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250120161800.30270-1-alexandru.elisei@arm.com>
References: <20250120161800.30270-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

guest_flat_to_host() and host_to_guest_flat return NULL, respectively 0,
when the address is not found in the existing memslots. It is expected that
the calling code will handle this error.

However, both functions also print an error message containing the
offending address. This can be redundant, if the calling code also prints
the address, or even misleading, if the calling code can gracefully handle
the failure, like is the case in kvm__dump_mem().

Change the warning to a debug, since knowing the address might still be
useful for those call sites where the address isn't printed, or if the
error isn't handled at all.

Before, when running the PMU test from kvm-unit-tests using the test
runner, which redirects stdout (where kvm__dump_mem() writes) and stderr
(where pr_warning() writes):

  Error: KVM exit reason: 9 ("KVM_EXIT_FAIL_ENTRY")
  Warning: unable to translate guest address 0x0 to host

 Registers:

<snip>

*lr:
 0x00000000: <unknown>
 0x00000008: <unknown>
 0x00000010: <unknown>
 0x00000018: <unknown>

The error is caused by the VCPU migrating to a physical CPU with a
different PMU. In the example, the warning not only is unnecessary, but is
quite a distance away from the offending address and can confuse the person
looking at the code, like it happened to the patch author.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kvm.c b/kvm.c
index 42b881217df6..07089cf1b332 100644
--- a/kvm.c
+++ b/kvm.c
@@ -354,7 +354,7 @@ void *guest_flat_to_host(struct kvm *kvm, u64 offset)
 			return bank->host_addr + (offset - bank_start);
 	}
 
-	pr_warning("unable to translate guest address 0x%llx to host",
+	pr_debug("unable to translate guest address 0x%llx to host",
 			(unsigned long long)offset);
 	return NULL;
 }
@@ -371,7 +371,7 @@ u64 host_to_guest_flat(struct kvm *kvm, void *ptr)
 			return bank->guest_phys_addr + (ptr - bank_start);
 	}
 
-	pr_warning("unable to translate host address %p to guest", ptr);
+	pr_debug("unable to translate host address %p to guest", ptr);
 	return 0;
 }
 
-- 
2.34.1


