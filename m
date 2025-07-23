Return-Path: <kvm+bounces-53280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CF14B0F97E
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:44:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C313AC4BC0
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD622246796;
	Wed, 23 Jul 2025 17:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="GxHW6wWJ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="LcHqmGVp"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F3C242927;
	Wed, 23 Jul 2025 17:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753292226; cv=none; b=VcgJkYSdzr3uZozmXej55HGA5Udgg9WgyEGekcTT8hqKtU9SmQ8jhJzq/ZS9vQUzxzAEC4XoczH9OQEf+TERwPHp96nxFT7T0V+dGtu9KGWsEUqJUIX+ZwlwZZe2qX/bcZ8WtehZuR5n7dgQgtboxXZKsjVXJ1lfZaTtktKA9Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753292226; c=relaxed/simple;
	bh=NqhvlfUYaDV/+2XHHooAozZ1Ma4TP4Tc6co3ykPUrHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcBfEvsr/xW/xPknCCL7dRoZqEbVSUiLsdz8BEtt/Wv4NgHAfMICQND0CnWz3+UeXYAtbwioT2bxrzBbnMzOMItWn7RBQCKSwd7MbI2EnJdiWveanWxH/6MImSidLZh4hPpIRqqgwkM+2K4nNoxd33dMy0FRtGG3Xt6eW2PowXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=GxHW6wWJ; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=LcHqmGVp; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: "Ahmed S. Darwish" <darwi@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753292223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OAEsC2skIOSaWZt2MlflxtyQsbT7+BYF8vFWwagm9QY=;
	b=GxHW6wWJz714/fpZVYdNfesChaLOVBzAH57+lIq8zXJLyasEsMRnDLEBHFDircybMIAMip
	Bmh9VZ96tOQ/Mhjf96DEOA+lVx3CvL5hOEwc56eFbm03DLDgxAgPxAmfisiHkDjm79RY3t
	j282S7E89Pyy1/xU5+XfWgvgsUaAb1yPOKg5HvoU5cxd/d9UYoGHC48XcVYaNevpTZv0TZ
	7oUjz1OWM3m3U3uZ5SZY4NrwsdX6r7J+cAPqE6uNmMFd/BJsYMLNuYVthkXlE9LdgPjTRc
	Lz1ttkAcl//ZFPNF78lFaSphDjUNCHWJNp40HnrPXKy+pE2IHIGEqnSoTqwnvQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753292223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OAEsC2skIOSaWZt2MlflxtyQsbT7+BYF8vFWwagm9QY=;
	b=LcHqmGVpkDxbxolp+xzEsctVegUQ/n7Ej73L98e8fNENPuB4wWaolN4RwUenEC0urIehvl
	1t/Df2nk+4jsmHCQ==
To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	John Ogness <john.ogness@linutronix.de>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	x86-cpuid@lists.linux.dev,
	LKML <linux-kernel@vger.kernel.org>,
	"Ahmed S. Darwish" <darwi@linutronix.de>
Subject: [PATCH v4 4/4] x86/cpu: <asm/processor.h>: Do not include the CPUID API header
Date: Wed, 23 Jul 2025 19:36:43 +0200
Message-ID: <20250723173644.33568-5-darwi@linutronix.de>
In-Reply-To: <20250723173644.33568-1-darwi@linutronix.de>
References: <20250723173644.33568-1-darwi@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

<asm/processor.h> includes the main CPUID API header <asm/cpuid/api.h>
but it does not need it.

Remove the include.

Note, this allows the CPUID API header to include <asm/processor.h> at a
later step, which is needed for the upcoming CPUID model and parser,
without introducing a circular dependency.

Note, all call sites which implicitly included the CPUID API header
through <asm/processor.h> have been already modified to explicitly
include the CPUID API instead.

Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
---
 arch/x86/include/asm/processor.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index bde58f6510ac..910e36b0c00d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -16,7 +16,6 @@ struct vm86;
 #include <uapi/asm/sigcontext.h>
 #include <asm/current.h>
 #include <asm/cpufeatures.h>
-#include <asm/cpuid/api.h>
 #include <asm/page.h>
 #include <asm/pgtable_types.h>
 #include <asm/percpu.h>
-- 
2.50.1


