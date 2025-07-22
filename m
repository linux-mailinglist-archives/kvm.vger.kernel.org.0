Return-Path: <kvm+bounces-53081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78A3BB0D226
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 08:55:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63F261AA1F95
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 06:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EADC2C1583;
	Tue, 22 Jul 2025 06:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="HNjUCpzO";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="5FvV19kY"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3942BE65A;
	Tue, 22 Jul 2025 06:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753167304; cv=none; b=RSJZ3M8oHZw1w28HjywrHN952okeoTxgdElcQ2bh9uOjRH+bGYSCa2jfpOQPNhwYggu/MXFXUokTFS7b6+zwgeowW0f14C1nTcPuvdkGXu+ABlk8hyurkQC1BLxWuilbnqFOMMxS/PewaoJtZmaM92vmNqKiJnoFukJ5cOg7tdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753167304; c=relaxed/simple;
	bh=SYRZmFM3Ioa0y0H9EeRaz2/V19DLQSJh6KQlg7ks8hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQwkh6FUfFxDYzV6pQ8AqhoUCHzSvUNGwkGIbh04mQDqLDDU5pgNERpZoiWiv23xQmQPxRkGycOckoF7dbObf+Qy98WYTVaFHmswD2YuypIWmOQrNRmKHQc+0Xqapw0UAOEiRS+tfO7ccMrTrBWBEbAISwkpqFLwqjGLd1aeuts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=HNjUCpzO; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=5FvV19kY; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: "Ahmed S. Darwish" <darwi@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753167301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d8Xp1mFPuuaOTq+ytYDakiRoJMAib8ShAL5vVh6jiIQ=;
	b=HNjUCpzOOioYZCdMTLci1nbZM8oeCG6SSuPiAsN8UccDWgoETYODcQ7NjP1FD3eOwlSOQ6
	TyLvY3p3n/WRTIh/Ek+ofOyy8VZ3tZZAutCcoxXmP8C0nFkdM1yeRWyMqfaNUE7OwLcRuG
	hZ32jhAS9Xt37FAOPo7v3SuHB+Uxnp1b2Tf03rEry8J56NF22GKSkiYFu5Y/Nnc/kGMnwe
	bBrdXv4k2I4Yvb1zQkggp7waXAtjBVMK3HXb9qS0J8kiBsnpT4Tkx0ih4fFxYfCiPa5We+
	zrWbAG6O02wwJ+DUQK8W2WsbxEV/K0XLjsfTz35tnoUeohiZa3qVkKT/gZMcXA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753167301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d8Xp1mFPuuaOTq+ytYDakiRoJMAib8ShAL5vVh6jiIQ=;
	b=5FvV19kYF6VmAJOTrrtW21MdyhFwDyYvQuQ5I2jPdZtaoqFaokybrSOiAY2dk/XUAFHQvm
	/t3x43uJvneYW8Bg==
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
Subject: [PATCH v3 1/6] x86/cpuid: Remove transitional <asm/cpuid.h> header
Date: Tue, 22 Jul 2025 08:54:26 +0200
Message-ID: <20250722065448.413503-2-darwi@linutronix.de>
In-Reply-To: <20250722065448.413503-1-darwi@linutronix.de>
References: <20250722065448.413503-1-darwi@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All CPUID call sites were updated at commit:

    968e30006807 ("x86/cpuid: Set <asm/cpuid/api.h> as the main CPUID header")

to include <asm/cpuid/api.h> instead of <asm/cpuid.h>.

The <asm/cpuid.h> header was still retained as a wrapper, just in case
some new code in -next started using it.  Now that everything is merged
to Linus' tree, remove the header.

Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
---
 arch/x86/include/asm/cpuid.h | 8 --------
 1 file changed, 8 deletions(-)
 delete mode 100644 arch/x86/include/asm/cpuid.h

diff --git a/arch/x86/include/asm/cpuid.h b/arch/x86/include/asm/cpuid.h
deleted file mode 100644
index d5749b25fa10..000000000000
--- a/arch/x86/include/asm/cpuid.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-
-#ifndef _ASM_X86_CPUID_H
-#define _ASM_X86_CPUID_H
-
-#include <asm/cpuid/api.h>
-
-#endif /* _ASM_X86_CPUID_H */
-- 
2.50.1


