Return-Path: <kvm+bounces-3313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0765802EE7
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 10:40:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D7121C209CB
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC1C200BF;
	Mon,  4 Dec 2023 09:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KZgSgwnT"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB672100;
	Mon,  4 Dec 2023 01:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Subject:Cc:To:From:Date:Message-Id:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=nS5Rsn93xMSfaJg6MM0BWPbjMY5lqaSHh/D+5cLgBSs=; b=KZgSgwnTG8TS45KxWg/Qe0QAGx
	S+34NCEOBngCbOpSj7+auXP7eiVr79GdtW398KNCL3lIuJLSySrzlgdkCg6sNzIiuKtDmZ0SYY39q
	M+rgoMNia0m2QPZcsBgg6LUHsPIODKSFmfbtgEuSQycJJQaHxMz3k5+NuCUA5UkhTMJF54/Gq3S6o
	Iznve1IATn3RQctDMIrKI/Bo+Uo+Ya+9zucQpSTAhanXVqQYusoHZTOD7Q9XYJft/cnyvUc8TouBk
	KGpLmypXP1Dbuw/D2XrVy0rYsOLq5AVYeLwfVlLYbPMMf0BK4K/U1LxiZy5g5/Z6w+2BHfCZ3+Vqn
	dBwcYMoQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rA5QY-000X0M-GC; Mon, 04 Dec 2023 09:39:46 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id 876743003F0; Mon,  4 Dec 2023 10:39:45 +0100 (CET)
Message-Id: <20231204093702.989848513@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 04 Dec 2023 10:37:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Josh Poimboeuf <jpoimboe@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
 peterz@infradead.org,
 x86@kernel.org,
 kvm@vger.kernel.org
Subject: [PATCH 00/11] x86/kvm/emulate: Avoid RET for FASTOPs
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Hi!

Because I needed a new objtool annotation, and I'd promised Josh I'd clean all
that up a while ago, now with a healy sprinking of objtool patches...

Anyway... FASTOP is special in that it relies on RET to preserve FLAGS, while
normal C calling convention does not. This has been a problem before, see
ba5ca5e5e6a1 ("x86/retpoline: Don't clobber RFLAGS during srso_safe_ret()") but
is also a problem for call depth tracking.

Fixing the call-depth tracking return thunk would be significantly harder (and
more expensive), so instead change fastops to not use return.

There are two separate instances, test_cc() and fastop(). The first is
basically a SETCC wrapper, which seems like a very complicated (and somewhat
expensive) way to read FLAGS. Instead use the code we already have to emulate
JCC to fully emulate the instruction.

That then leaves fastop(), which when marked noinline is guaranteed to exist
only once. As such, CALL+RET isn't needed, because we'll always be RETurning to
the same location, as such replace with JMP+JMP.


---
 arch/x86/include/asm/alternative.h   |  14 +-
 arch/x86/include/asm/nospec-branch.h |  45 ++++--
 arch/x86/include/asm/text-patching.h |  20 ++-
 arch/x86/kvm/emulate.c               |  54 +++----
 include/linux/instrumentation.h      |  11 +-
 include/linux/objtool.h              |  62 +++++----
 include/linux/objtool_types.h        |  12 ++
 tools/include/linux/objtool_types.h  |  12 ++
 tools/objtool/check.c                | 263 +++++++++++------------------------
 9 files changed, 208 insertions(+), 285 deletions(-)



