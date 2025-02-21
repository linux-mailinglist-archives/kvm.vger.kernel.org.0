Return-Path: <kvm+bounces-38878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD7FA3FBCD
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 17:46:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07103881E5E
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 16:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5119821149F;
	Fri, 21 Feb 2025 16:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k/jmITgm"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CDA21128D
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 16:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740155654; cv=none; b=iXu8GecwvWMeDKOu2+ANOJWxT3aM2JGS81ILa5biIEaSYrr3yUGMNfbGkH1UjGukIwOmBA3ZPVvhIEpdXAdxM+nBjXvhFydlvfblwOc7YBM5fr42CkVwzyJhP79HPQTREps8hTmN+idrMLVIKakTuW65abAx2LxD5AdXhmHnhGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740155654; c=relaxed/simple;
	bh=YXp7VZBdS3IyMkWci8sv6ipPQLiGOAkk2P8v6sqOrS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V++Sjz5305Ak0IjwrMl+XW1F+dRlCiFocVUIwObW+9H3dnN2Wp+v5ZOu3vQfy2MooC/KDJ1qAx82lmbSNlOtf0/BXleO5JYrSzm7eN5gWwUGQgWqkRghm4pKHcw+xJjzgu/Rcm+MvSxDdngbop8EsI14wYMWVKB6vUlwjmH6A8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k/jmITgm; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740155650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kJ4r4UkNHVRp0o1mave86XFAreLgoybFLmy+ftaGobA=;
	b=k/jmITgmEj30FvHYDBUb5/TklLz/pGUrveHxVGS2lN6Z+2AlvJUDKMs3YDAJl9fgPkfjCM
	GDc2jvzwKMiFOT4fbr6dm7rgaztqF3H4HnsOFW4uLmvIYe61rEuvUSHh2uFwbuKKb1p8MI
	8qOYjO05xoqHB5vvfp3dGsn4fvK5uaU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: x86@kernel.org,
	Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	"Kaplan, David" <David.Kaplan@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 2/3] KVM: x86: Propagate AMD's IbrsSameMode to the guest
Date: Fri, 21 Feb 2025 16:33:51 +0000
Message-ID: <20250221163352.3818347-3-yosry.ahmed@linux.dev>
In-Reply-To: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
References: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If IBRS provides same mode (kernel/user or host/guest) protection on the
host, then by definition it also provides same mode protection in the
guest. In fact, all different modes from the guest's perspective are the
same mode from the host's perspective anyway.

Propagate IbrsSameMode to the guests.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/cpuid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index edef30359c198..05d7bbfbb8885 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1103,6 +1103,7 @@ void kvm_set_cpu_caps(void)
 		F(AMD_SSB_NO),
 		F(AMD_STIBP),
 		F(AMD_STIBP_ALWAYS_ON),
+		F(AMD_IBRS_SAME_MODE),
 		F(AMD_PSFD),
 		F(AMD_IBPB_RET),
 	);
-- 
2.48.1.601.g30ceb7b040-goog


