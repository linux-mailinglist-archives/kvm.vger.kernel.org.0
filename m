Return-Path: <kvm+bounces-8117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B507284BC63
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:42:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 626581F278C3
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 17:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE151AACF;
	Tue,  6 Feb 2024 17:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W6A7/iBX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02B713ADC
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 17:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707241208; cv=none; b=cA4GcdHlNqfXNy1sPpkbpbeDLBQGwqp1cYZM2qWFoOT3Udz3rSVQ0JZblcbu51BQIx5hajap25wnmtaYE8kPkQSs0zyqfdc03Pp6hewLYk2Zu+Du0e3RTBEmHVGW7uT9uVmE6/ulFZMm+yvSfO5HoAjd5cI73OKXo2xLC675O/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707241208; c=relaxed/simple;
	bh=OqaVifQS+nxzCD21b4s8rJ7JH6j5ozOv9bSA598QaaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1MdD/jW7K2vJ3cDbqN80TVhcisbhovA5DmNQE2tOhJIca99/GECqZXd4kz3cCVzo7kYVpoX3PZJSXJlotFs7uAnEMcBtjniY8P56Y/eAehC/UlEFEbMbo3gq+k10UIVZ3G/pYDCR3Z4w6ml1yi8aHOzFcUbslMby1cVdbaxGvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W6A7/iBX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707241205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DiAeFErACPu2Qq/VSwmzn5NIHI5rZO8DYF37cTAxg+8=;
	b=W6A7/iBXUZ326iBjbODLCbswb+Y+BITEDS5Yhco3uB9pWxOgeu6o7/mpMUPnT4RLXdDwwd
	vYgourOfqjjxgWZBhQAekTDfU/lOYpYcXLjE8G+lvjj98+NVgRMgpRIAyyd1h0U/iZUHRw
	UcWeo/3N1dv3YjTZYnuNapFOZCjy2/o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-Leok8IbMPaWMhJaxElOyGA-1; Tue, 06 Feb 2024 12:40:02 -0500
X-MC-Unique: Leok8IbMPaWMhJaxElOyGA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98959879843;
	Tue,  6 Feb 2024 17:40:00 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.39.193.2])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B9882026D06;
	Tue,  6 Feb 2024 17:39:56 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	x86@kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Feng Tang <feng.tang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	"ndesaulniers@google.com" <ndesaulniers@google.com>,
	Michael Kelley <mikelley@microsoft.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH v2 3/5] x86/kvm: Make kvm_async_pf_enabled __ro_after_init
Date: Tue,  6 Feb 2024 18:39:09 +0100
Message-ID: <20240206173911.4131670-4-vschneid@redhat.com>
In-Reply-To: <20240206173911.4131670-1-vschneid@redhat.com>
References: <20240206173911.4131670-1-vschneid@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

kvm_async_pf_enabled is only ever enabled in __init kvm_guest_init(), so
mark it as __ro_after_init.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index dfe9945b9bece..8f48ce7adfb28 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -44,7 +44,7 @@
 #include <asm/svm.h>
 #include <asm/e820/api.h>
 
-DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
+DEFINE_STATIC_KEY_FALSE_RO(kvm_async_pf_enabled);
 
 static int kvmapf = 1;
 
-- 
2.43.0


