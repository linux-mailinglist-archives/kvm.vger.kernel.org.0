Return-Path: <kvm+bounces-8481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B1F784FD41
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 20:57:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D5201C213AE
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 19:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A9085C65;
	Fri,  9 Feb 2024 19:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="LZhlomEb"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7FD84A50;
	Fri,  9 Feb 2024 19:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707508663; cv=none; b=hVFEhc6c6abapdFPOwjIvRVdRYAT2fa7JCwkOZLDEKDcA0Av/89NlzKlbyNOX6/WIiAApB+Mds/lBNjHfZreaKoWddrpc1iYp+Ffx0M9dcw8zZ8V3qd3r7dXb4VRDhCaE3BX/4bgy8GLIcoHx4FpytU0mC4CMrlODBDJpwxbCP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707508663; c=relaxed/simple;
	bh=FsBb6B2wa3yPeH8I5VZIx7o8owuEkmIHTsHqHQ3wjh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q16lB/0iSY+SypJs8tHR7i5LgviB2YEnil3V5G0YFq/626kryYJpz+Bmj1QTYyszDGIj+1ELf7XjbJPOi0vVGoI4i5OoQfcLuct7rr2mR3Rapjqcr3qOHzKvww2t5KMQ8F/AU1GqS/JhBbs7R5ZpB87YSsv0QLSex+d9e701pO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=LZhlomEb; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5335A40E01A9;
	Fri,  9 Feb 2024 19:57:37 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TgbeWiLRVUwY; Fri,  9 Feb 2024 19:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1707508655; bh=iW9U2ooZEMeuKAa64COmmNOJFLMhQU+pVbKHtxLkfFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LZhlomEbisqMj5X32Kwmu9a8PaI36q6p5jqAhfQGt8XkrpJPf51+8difz1IKJXdrv
	 YdxoRIF/M1FwKldOPRYPvvrFMRzL93G4TlSlYisfT4w3tpHsn9wFi42EKPEqpU8x8z
	 kKch9DkqJOccxKa05NN1BS83qWzwSzGz/0UBt0i+gBS2WfoG2sVObiW68EQEw7ovQd
	 wNIYlC43Y3SVuFwNtcHYpitYgRl4i7KO/NGlbmQCpOTqxVXOH1mRQyVhswj67/rkzr
	 +7q3n3awhX/obCg9N7IEJZJzC13o+O1BDwlOeDBLtTT5AjiWai+pfyx208vwGoAPrE
	 BIiLI8Oi4xbTZOVCAffjpiT6v+XxTg9SPR4o+NWhqx0AjXgTWXLa0/OXIJlCrpgkUR
	 pF5za3LKbelxUOR6iDM/XuUafFZPa4equKzoQeWz1gj0EDuhMTRd1wGL8iFyQAd9df
	 lRcIY0Cfy3Fso6G4qVh/ibzBr8V99IuvfvWhLe9EzZU6Z6dHT67bfTIv142HaXwHCG
	 QFyS98U9Rk36GjFo42q3gtU2dll+qY0+3R+GFs+V1VxCVJq/wE8t4PFOxgAZnha1wA
	 EJ8aPA4Ec9t1e/Y8gU+MoKIGztEv5TzcDBjULbkn7j/0iQOdk5LtxvlzRoUPT6Pud2
	 sQN5X+c0BkZkfhvnCGrlS9lA=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B234E40E016D;
	Fri,  9 Feb 2024 19:57:09 +0000 (UTC)
Date: Fri, 9 Feb 2024 20:57:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
	ak@linux.intel.com, tim.c.chen@linux.intel.com,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	Alyssa Milburn <alyssa.milburn@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	antonio.gomez.iglesias@linux.intel.com,
	Alyssa Milburn <alyssa.milburn@intel.com>, stable@kernel.org
Subject: Re: [PATCH  v7 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20240209195704.GEZcaDkMUR560qafaI@fat_crate.local>
References: <20240204-delay-verw-v7-0-59be2d704cb2@linux.intel.com>
 <20240204-delay-verw-v7-1-59be2d704cb2@linux.intel.com>
 <20240209172843.GUZcZgy7EktXgKZQoc@fat_crate.local>
 <20240209190602.skqahxhgbdc5b2ax@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240209190602.skqahxhgbdc5b2ax@desk>

On Fri, Feb 09, 2024 at 11:06:02AM -0800, Pawan Gupta wrote:
> (Though, there was a comment on avoiding the macro alltogether, to which
> I replied that it complicates 32-bit.)

Hmm, so this seems to build the respective entry_{32,64}.S TUs fine:

---
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index e81cabcb758f..7d1e5fe66495 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -313,12 +313,9 @@
  *
  * Note: Only the memory operand variant of VERW clears the CPU buffers.
  */
-.macro EXEC_VERW
-	verw _ASM_RIP(mds_verw_sel)
-.endm
 
 .macro CLEAR_CPU_BUFFERS
-	ALTERNATIVE "", __stringify(EXEC_VERW), X86_FEATURE_CLEAR_CPU_BUF
+	ALTERNATIVE "",  __stringify(verw _ASM_RIP(mds_verw_sel)), X86_FEATURE_CLEAR_CPU_BUF
 .endm
 
 #else /* __ASSEMBLY__ */
---

and looking at the asm:

64-bit:

# 317 "./arch/x86/include/asm/nospec-branch.h"
.macro CLEAR_CPU_BUFFERS
 ALTERNATIVE "", "verw mds_verw_sel (% rip)", ( 3*32+18)
.endm

  23:   0f 00 2d 00 00 00 00    verw   0x0(%rip)        # 2a <.altinstr_replacement+0x2a>

32-bit:

.macro CLEAR_CPU_BUFFERS
 ALTERNATIVE "", "verw mds_verw_sel", ( 3*32+18)
.endm

 13d:   0f 00 2d 00 00 00 00    verw   0x0

it makes sense.

So what complications do you mean?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

