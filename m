Return-Path: <kvm+bounces-53086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28C3AB0D232
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 08:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 589417ACD4D
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 06:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086842D663F;
	Tue, 22 Jul 2025 06:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="wFVuq1Rl";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="PtMabs/E"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4B62D2389;
	Tue, 22 Jul 2025 06:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753167328; cv=none; b=ZkT6DE8xMNcz2lyEm3p62pzh1QY/QNytfgI4xoq0L4NiGaAJQbgb2+Dh/4Zbs+PC6Qd+Sh3jD0mXk4KfySqRPXK/iE2t/WHFtdIoSOjgsBLn10O4PgXLk1yiQ7HU2ZNXAKeX0f8djgsm/oJpkCII83pp5GFZ6oEjypIwNG5jm38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753167328; c=relaxed/simple;
	bh=NqhvlfUYaDV/+2XHHooAozZ1Ma4TP4Tc6co3ykPUrHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHm95cYxg/VgBveUNqmzHEQ0ZkN+NALsUNaKnTnW4SUS9P4Ur9B2eGTXiBysRrVHfhAUH9XyFGU4GHoieCMG6wj9OSshHrNDGF8m9DUcuRIx/2fSGBbWP1lL8MAZnsE/SPowAE2yTrBpZXEIdT8Ai33WsGAvOdWuNYIlbywUAW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=wFVuq1Rl; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=PtMabs/E; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: "Ahmed S. Darwish" <darwi@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753167324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OAEsC2skIOSaWZt2MlflxtyQsbT7+BYF8vFWwagm9QY=;
	b=wFVuq1RlZ9EhF3ZESkS5xyCw/isPhZWRpn7wAs3EZEw/DlDTvB1K2YM2/nIq9JwklUlUEH
	cd93jVGKiw0WNCMkqcxdnZ5Aya4PaC4NsOzdDkiVIEvMC3LT/7UVDMTELKawxbjc9lKQYa
	vdOdZMJVMsVlpDxl9sSpjtyNqMbubAJzLH5Q+cMfu99oe/KNELVgCmY0F8W5PN1On1+hFh
	+/pNS0iK1MdtcvVPJfh8m5sVvY3hYZuoQ1SoHLXxRy3sGBUvrVCObgNSUUlOBZyz2lLYIx
	ZDgO0GPY5BbLpvnu8SuCNz6axYmfLRTWcm+nkgQTtsbrpzmXswaQk7bQ/FK3dQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753167324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OAEsC2skIOSaWZt2MlflxtyQsbT7+BYF8vFWwagm9QY=;
	b=PtMabs/ERXmh0j/GTQsszoqS1OApT61wCf6tI0oUEfAJXpmWJtAXCDCDW2ch4pRe90Rxza
	OZEHAZygLCoYqMBw==
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
Subject: [PATCH v3 6/6] x86/cpu: <asm/processor.h>: Do not include the CPUID API header
Date: Tue, 22 Jul 2025 08:54:31 +0200
Message-ID: <20250722065448.413503-7-darwi@linutronix.de>
In-Reply-To: <20250722065448.413503-1-darwi@linutronix.de>
References: <20250722065448.413503-1-darwi@linutronix.de>
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


