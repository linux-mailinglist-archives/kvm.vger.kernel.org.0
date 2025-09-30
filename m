Return-Path: <kvm+bounces-59087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8033FBABBB4
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 09:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AD987A8355
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E0F02BE7A0;
	Tue, 30 Sep 2025 07:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lI//7GrW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lI//7GrW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5617B2BE029
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 07:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759215847; cv=none; b=RfEM25M/wWvClu9WxklaWytd7pFBrhUpAQdsUB4LSpRs/xv5Q8ZHpyrvDcPkd6WCSTDWpbfD+3+hTCPS7CUEKtTCqVa/DOZCu04eQsSRHc38IeWoWhrEHGGLK013+2gdaO1qaYnv+BhMdkRR35bCs4+56/jDJGYIecchYHXZ8DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759215847; c=relaxed/simple;
	bh=JsAReLmvMZhvekg+cfPzBJaUGCBNaVOJa23lA/aZuFU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MC0mMYOY3Arf+iDAqxQnEaWkOwfQ/dqk5PqhLLzLrbgDXm1KYCYFATNDpZtj+3BKM2/Df/8AedApkuNulfu6GZsN6cWK8TIvSUEuhO9Sh5qjwF/aKkcRKZIbQoHE6DyCL1JhEu3W+Y/9P7FptTkeOo2rKUAWMBrGp5BbwqrCk9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lI//7GrW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lI//7GrW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9380133739;
	Tue, 30 Sep 2025 07:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1759215840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=si4gFV/3dYwzZCgZLBa+slIGVpI7ADvTkoM2AqYWyic=;
	b=lI//7GrWbrtZpvnC/P8xTiWG1bJbDcWhKotPPRdZuKz3ngnIcX30ietrtLWvmP1jskQdao
	4gLwLF/Cd8MQo3TpAPNLdCbc/gpChj8LWOhneF7676sm6d/4WczGF/pjpomj3dkTdfHv3r
	z05U8sTyMyF8jumPIDaPESgjn69G6tU=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="lI//7GrW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1759215840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=si4gFV/3dYwzZCgZLBa+slIGVpI7ADvTkoM2AqYWyic=;
	b=lI//7GrWbrtZpvnC/P8xTiWG1bJbDcWhKotPPRdZuKz3ngnIcX30ietrtLWvmP1jskQdao
	4gLwLF/Cd8MQo3TpAPNLdCbc/gpChj8LWOhneF7676sm6d/4WczGF/pjpomj3dkTdfHv3r
	z05U8sTyMyF8jumPIDaPESgjn69G6tU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A628E13A3F;
	Tue, 30 Sep 2025 07:03:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hWSkJt+A22hxRwAAD6G6ig
	(envelope-from <jgross@suse.com>); Tue, 30 Sep 2025 07:03:59 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	virtualization@lists.linux.dev,
	llvm@lists.linux.dev
Cc: xin@zytor.com,
	Juergen Gross <jgross@suse.com>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	xen-devel@lists.xenproject.org,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: [PATCH v2 00/12] x86/msr: Inline rdmsr/wrmsr instructions
Date: Tue, 30 Sep 2025 09:03:44 +0200
Message-ID: <20250930070356.30695-1-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[33];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[zytor.com,suse.com,kernel.org,linux.intel.com,linutronix.de,redhat.com,alien8.de,google.com,microsoft.com,oracle.com,lists.xenproject.org,broadcom.com,infradead.org,gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[lkml];
	DKIM_TRACE(0.00)[suse.com:+];
	R_RATELIMIT(0.00)[to_ip_from(RLkdkdrsxe9hqhhs5ask8616i6)];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 9380133739
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -1.51

When building a kernel with CONFIG_PARAVIRT_XXL the paravirt
infrastructure will always use functions for reading or writing MSRs,
even when running on bare metal.

Switch to inline RDMSR/WRMSR instructions in this case, reducing the
paravirt overhead.

In order to make this less intrusive, some further reorganization of
the MSR access helpers is done in the first 5 patches.

The next 5 patches are converting the non-paravirt case to use direct
inlining of the MSR access instructions, including the WRMSRNS
instruction and the immediate variants of RDMSR and WRMSR if possible.

Patch 11 removes the PV hooks for MSR accesses and implements the
Xen PV cases via calls depending on X86_FEATURE_XENPV, which results
in runtime patching those calls away for the non-XenPV case.

Patch 12 is a final little cleanup patch.

This series has been tested to work with Xen PV and on bare metal.

This series is inspired by Xin Li, who used a similar approach, but
(in my opinion) with some flaws. Originally I thought it should be
possible to use the paravirt infrastructure, but this turned out to be
rather complicated, especially for the Xen PV case in the *_safe()
variants of the MSR access functions.

Changes since V1:
- Use Xin Li's approach for inlining
- Several new patches

Juergen Gross (9):
  coco/tdx: Rename MSR access helpers
  x86/sev: replace call of native_wrmsr() with native_wrmsrq()
  x86/kvm: Remove the KVM private read_msr() function
  x86/msr: minimize usage of native_*() msr access functions
  x86/msr: Move MSR trace calls one function level up
  x86/msr: Use the alternatives mechanism for WRMSR
  x86/msr: Use the alternatives mechanism for RDMSR
  x86/paravirt: Don't use pv_ops vector for MSR access functions
  x86/msr: Reduce number of low level MSR access helpers

Xin Li (Intel) (3):
  x86/cpufeatures: Add a CPU feature bit for MSR immediate form
    instructions
  x86/opcode: Add immediate form MSR instructions
  x86/extable: Add support for immediate form MSR instructions

 arch/x86/coco/tdx/tdx.c               |   8 +-
 arch/x86/hyperv/ivm.c                 |   2 +-
 arch/x86/include/asm/cpufeatures.h    |   1 +
 arch/x86/include/asm/fred.h           |   2 +-
 arch/x86/include/asm/kvm_host.h       |  10 -
 arch/x86/include/asm/msr.h            | 409 +++++++++++++++++++-------
 arch/x86/include/asm/paravirt.h       |  67 -----
 arch/x86/include/asm/paravirt_types.h |  13 -
 arch/x86/include/asm/sev-internal.h   |   7 +-
 arch/x86/kernel/cpu/scattered.c       |   1 +
 arch/x86/kernel/kvmclock.c            |   2 +-
 arch/x86/kernel/paravirt.c            |   5 -
 arch/x86/kvm/svm/svm.c                |  16 +-
 arch/x86/kvm/vmx/vmx.c                |   4 +-
 arch/x86/lib/x86-opcode-map.txt       |   5 +-
 arch/x86/mm/extable.c                 |  39 ++-
 arch/x86/xen/enlighten_pv.c           |  24 +-
 arch/x86/xen/pmu.c                    |   5 +-
 tools/arch/x86/lib/x86-opcode-map.txt |   5 +-
 19 files changed, 383 insertions(+), 242 deletions(-)

-- 
2.51.0


