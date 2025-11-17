Return-Path: <kvm+bounces-63350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A05FC637CD
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 11:19:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AFD04353DDE
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBA673271F0;
	Mon, 17 Nov 2025 10:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="iTonU8BO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602CC31987B;
	Mon, 17 Nov 2025 10:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763374321; cv=none; b=Tjix8/oP6IxMSBIkiHTCVPg0wetEOjRWMgoWHZvld+vkzsLdUWi8FAIyPUXZgjRI0y9YaNYKec1tekJcCq5Aeso4wsELLzk0jUFamzISrI0OcIf77KO2C7ISKHxKeDj4+Cs1g0c2MaSPjC/AjebqDBirqbgeR1U1CEv1GA0trrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763374321; c=relaxed/simple;
	bh=a32IPbQO1Mgl/oSPLb6qxxdCXXZLqY9DSskcM01V2KA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LsXjaQzRMJl5oYX9JKUSjtap9Jyyj2NFBfb0XotZzIIm08SZhilvNZ9iKewbf7WLX4qpZ1+MDsu1VJ7b04xAJ8Triwvwv5v/bRM7Az6TUqspifBAI5SkKzSvN37miL/+q/RTPbUU1EGh0gNDiJiTSpvosIWKdAqU/3xOlRNpwLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=iTonU8BO; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8D2D040E0219;
	Mon, 17 Nov 2025 10:11:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id mnX7Jc-uYqfr; Mon, 17 Nov 2025 10:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1763374309; bh=HN0R0aJupgW53096iWjC4OxwThJjtFzlar3yJ8+c0oM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iTonU8BOip2eVRNpLHuUtiSexqZOoIDZMzDX5hovQjximsTjUilrrucT5bxojJJo2
	 o4ySYJeHxKctFBKWEZ4k0sd6RvLrKSRbzR8ex2mZXEdabkJtFwN/hfiOHcbYRHpXVM
	 1Fz981YL+Dh6gD2JztHyj2Y+CR2ZCPKhwuUnNWKkTGtpVjOZGp59VfJBz87w555pkX
	 HJpBZH9HozINpgwf5yQqDQNoPU/uES+zGn8I7fKG2JcDpCEsS9SKzyjTYIPz7P6bvN
	 teuoTOa7UUrlGZx1B+ndAijXCH5nVV9Hl4AnStkPIunUqJTDh5EhomSKUC+WF/sQm6
	 wuLgTuUa8IcBHe14m/3FZMvEaR7pXo58vXGZv5zIVOicaIl2bYFPw5ve/VquHw7znT
	 8X1NTR+XdyfGpLxb4gj1lmtFXBZ1nlfwQFKXft9f/IEMudcEciaXl1tcYzRhhLVrfd
	 W9jQyuUUq5/TQu6B5kxt8aBBn4ix2VrGoZEROHDKo0mtdiy187Y5MjVcXjrAVv3jyq
	 mklfdg9F0XSMBYZzJCEEwHYuREDUqFwx4lyTfcR9hHEY2wJa0azc/nQ1WAR/XSf9RK
	 peqLK4UgBSA32PnZLmBoujtNw3ojs//qZMA2AKt5dhrj04/xa5xb+GCkGzG3Y2N7zH
	 Iqn+lqh194ZRbhP2faepyBNs=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id F0A4B40E022E;
	Mon, 17 Nov 2025 10:11:39 +0000 (UTC)
Date: Mon, 17 Nov 2025 11:11:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v5 3/9] x86/bugs: Decouple ALTERNATIVE usage from VERW
 macro definition
Message-ID: <20251117101129.GGaRr00XgEln3XzR5N@fat_crate.local>
References: <20251113233746.1703361-1-seanjc@google.com>
 <20251113233746.1703361-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251113233746.1703361-4-seanjc@google.com>

On Thu, Nov 13, 2025 at 03:37:40PM -0800, Sean Christopherson wrote:
> +#define __CLEAR_CPU_BUFFERS	__stringify(VERW)

Let's get rid of one indirection level pls:

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 8b4885a1b2ef..59945cb5e5f9 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -309,23 +309,21 @@
  * Note: Only the memory operand variant of VERW clears the CPU buffers.
  */
 #ifdef CONFIG_X86_64
-#define VERW	verw x86_verw_sel(%rip)
+#define VERW	__stringify(verw x86_verw_sel(%rip))
 #else
 /*
  * In 32bit mode, the memory operand must be a %cs reference. The data segments
  * may not be usable (vm86 mode), and the stack segment may not be flat (ESPFIX32).
  */
-#define VERW	verw %cs:x86_verw_sel
+#define VERW	__stringify(verw %cs:x86_verw_sel)
 #endif
 
-#define __CLEAR_CPU_BUFFERS	__stringify(VERW)
-
 /* If necessary, emit VERW on exit-to-userspace to clear CPU buffers. */
 #define CLEAR_CPU_BUFFERS \
-	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF
+	ALTERNATIVE "", VERW, X86_FEATURE_CLEAR_CPU_BUF
 
 #define VM_CLEAR_CPU_BUFFERS \
-	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
+	ALTERNATIVE "", VERW, X86_FEATURE_CLEAR_CPU_BUF_VM
 
 #ifdef CONFIG_X86_64
 .macro CLEAR_BRANCH_HISTORY

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

