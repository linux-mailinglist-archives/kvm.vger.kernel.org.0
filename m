Return-Path: <kvm+bounces-11730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD8487A7F2
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 13:59:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B1A8283801
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 12:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4850D433B3;
	Wed, 13 Mar 2024 12:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XOVIoRJk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01304405E6
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 12:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710334734; cv=none; b=pne0Ga1qPkee1cMlXvYeP6MepRWzCz9MhuLWRlNmAxW/uLORKWah+bHndag6pdr9K8ZbnBwTtgfSTng9QJzq5Q0vb/wwek5PdkcWot6X2DGaj19w+kKUvOxs4a2GqvMEKa984TxeQ3wfCTKmkbeOgoreX/JZoWsEq04i0nXSvqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710334734; c=relaxed/simple;
	bh=bSFQ6x++qyOcoKzfit8hgsY3myR8zf21zdavtZSurFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5IgBJmXo/6my1CtS5fYbfWshK39RWfBLPq6WxQ9XpHAGz2pxkQeUd/PmTo63tAX0oN2OSx2vRmfzmE7VF/SaTGdTgO+HqeGg2gmW+ogZ9QDP4ExD6oYMw50DuhND+qlMGh6XdVMeKsI3w9AwQDwQ5KWFJEf3k4s08xkdIVLtRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XOVIoRJk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710334732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JbI1Q06i15zBNLDlBPV6XMPyx/dQKcp3tORlZ+sJxOA=;
	b=XOVIoRJkDvTwU4EttGS3kP3N4rWAZptZKWAUiIidKUZ5wAI5/PVG9jMdkbieWv2rDOrCHZ
	OsLC9UZLefz9dSjJZQo+k0gkxwo8vF1Xf/U3mu/LcxpX/3DekOHT7aFABWP5JjcpuFtiIU
	uHwta0u+bWITVC8gqwmA0n/k8TBbX9M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-JLbUjwwnNaKfpbgL-Pza5w-1; Wed, 13 Mar 2024 08:58:47 -0400
X-MC-Unique: JLbUjwwnNaKfpbgL-Pza5w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BDE3101A5B3;
	Wed, 13 Mar 2024 12:58:46 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.160])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BEA831C060A4;
	Wed, 13 Mar 2024 12:58:45 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id CBFCC1800D6A; Wed, 13 Mar 2024 13:58:44 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: kvm@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH v4 1/2] kvm/cpuid: remove GuestPhysBits code.
Date: Wed, 13 Mar 2024 13:58:42 +0100
Message-ID: <20240313125844.912415-2-kraxel@redhat.com>
In-Reply-To: <20240313125844.912415-1-kraxel@redhat.com>
References: <20240313125844.912415-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

GuestPhysBits (cpuid leaf 80000008, eax[23:16]) is intended for software
use.  Physical CPUs do not set that field.  The current code which
propagates the host's GuestPhysBits to the guest's PhysBits does not
make sense.  Remove it.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index adba49afb5fe..3235254724cf 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1221,9 +1221,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = entry->ebx = entry->ecx = 0;
 		break;
 	case 0x80000008: {
-		unsigned g_phys_as = (entry->eax >> 16) & 0xff;
-		unsigned virt_as = max((entry->eax >> 8) & 0xff, 48U);
-		unsigned phys_as = entry->eax & 0xff;
+		unsigned int virt_as = max((entry->eax >> 8) & 0xff, 48U);
+		unsigned int phys_as;
 
 		/*
 		 * If TDP (NPT) is disabled use the adjusted host MAXPHYADDR as
@@ -1231,16 +1230,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 * reductions in MAXPHYADDR for memory encryption affect shadow
 		 * paging, too.
 		 *
-		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
-		 * provided, use the raw bare metal MAXPHYADDR as reductions to
-		 * the HPAs do not affect GPAs.
+		 * If TDP is enabled, use the raw bare metal MAXPHYADDR as
+		 * reductions to the HPAs do not affect GPAs.
 		 */
-		if (!tdp_enabled)
-			g_phys_as = boot_cpu_data.x86_phys_bits;
-		else if (!g_phys_as)
-			g_phys_as = phys_as;
+		if (!tdp_enabled) {
+			phys_as = boot_cpu_data.x86_phys_bits;
+		} else {
+			phys_as = entry->eax & 0xff;
+		}
 
-		entry->eax = g_phys_as | (virt_as << 8);
+		entry->eax = phys_as | (virt_as << 8);
 		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
 		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
-- 
2.44.0


