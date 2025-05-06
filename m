Return-Path: <kvm+bounces-45568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD7BAABF26
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:21:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 958DC5222AC
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB442673A3;
	Tue,  6 May 2025 09:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kriZpqdh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kriZpqdh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E1924CEEA
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 09:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746523233; cv=none; b=lY7J92LHbmm1d0TiSNba8aw34zkxOYUFyrZ4fsQJDJGPccKTfoQ50cKB2Ses2S4tWWxsrJ6Otx9jHh/AD2vnBPy+FdGN2iSPv6IURpkFEf+u2D58NEqI0gVMsFGd3J8FkzabG4s/gA5PX7T+dMPVCpl8viAxnbXTGqUIck0jDg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746523233; c=relaxed/simple;
	bh=ux1z0JCif5I2LLQ4PLNWZ9wDQp7Ekq9j/K7Xj7ZgSZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qam+kto1ruy4c6/ce/Y31BjJpri38gwj469Z7MnefTFUPqpYTN0UWj07s7vjEOtDoFxddDAU4PKpU1M3g4YZm28YKWsYSMyU/v2TJCHFAPEa59frdY6E5EV2/KqFzEDEI01mDFg3t5qZOMLxHrcoviVwn66O9KASf5tkxvLe2kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kriZpqdh; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kriZpqdh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3906C1F395;
	Tue,  6 May 2025 09:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746523223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SOSwn+O7fzFgeK18tfEQyq0imvcETcUg8KBVasQSn4w=;
	b=kriZpqdhOLBPPcruOud6UNmVzlEUq2xRjIwz8bZZFAG+0IQ5YwsePmFs/IObVQ5uX+3Bte
	GWUV+IhgDAcRFRchqFV+riec8rrlg/N9toymI+5EMWGjsxZHeP5YYMLN1WlStdR21cnlWk
	LAaqaoRE1YHJp6Eh3MpIfn/2a8tqxB8=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746523223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SOSwn+O7fzFgeK18tfEQyq0imvcETcUg8KBVasQSn4w=;
	b=kriZpqdhOLBPPcruOud6UNmVzlEUq2xRjIwz8bZZFAG+0IQ5YwsePmFs/IObVQ5uX+3Bte
	GWUV+IhgDAcRFRchqFV+riec8rrlg/N9toymI+5EMWGjsxZHeP5YYMLN1WlStdR21cnlWk
	LAaqaoRE1YHJp6Eh3MpIfn/2a8tqxB8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 67499137CF;
	Tue,  6 May 2025 09:20:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aNu9F1bUGWgBbAAAD6G6ig
	(envelope-from <jgross@suse.com>); Tue, 06 May 2025 09:20:22 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	virtualization@lists.linux.dev
Cc: xin@zytor.com,
	Juergen Gross <jgross@suse.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
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
	Alexey Makhalov <alexey.amakhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Subject: [PATCH 0/6] x86/msr: let paravirt inline rdmsr/wrmsr instructions
Date: Tue,  6 May 2025 11:20:09 +0200
Message-ID: <20250506092015.1849-1-jgross@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLfdszjqhz8kzzb9uwpzdm8png)];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Flag: NO

When building a kernel with CONFIG_PARAVIRT_XXL the paravirt
infrastructure will always use functions for reading or writing MSRs,
even when running on bare metal.

Switch to inline RDMSR/WRMSR instructions in this case, reducing the
paravirt overhead.

In order to make this less intrusive, some further reorganization of
the MSR access helpers is done in the first 4 patches.

This series has been tested to work with Xen PV and on bare metal.

There has been another approach by Xin Li, which used dedicated #ifdef
and removing the MSR related paravirt hooks instead of just modifying
the paravirt code generation.

Please note that I haven't included the use of WRMSRNS or the
immediate forms of WRMSR and RDMSR, because I wanted to get some
feedback on my approach first. Enhancing paravirt for those cases
is not very complicated, as the main base is already prepared for
that enhancement.

This series is based on the x86/msr branch of the tip tree.

Juergen Gross (6):
  coco/tdx: Rename MSR access helpers
  x86/kvm: Rename the KVM private read_msr() function
  x86/msr: minimize usage of native_*() msr access functions
  x86/msr: Move MSR trace calls one function level up
  x86/paravirt: Switch MSR access pv_ops functions to instruction
    interfaces
  x86/msr: reduce number of low level MSR access helpers

 arch/x86/coco/tdx/tdx.c                   |   8 +-
 arch/x86/hyperv/ivm.c                     |   2 +-
 arch/x86/include/asm/kvm_host.h           |   2 +-
 arch/x86/include/asm/msr.h                | 116 ++++++++++-------
 arch/x86/include/asm/paravirt.h           | 152 ++++++++++++++--------
 arch/x86/include/asm/paravirt_types.h     |  13 +-
 arch/x86/include/asm/qspinlock_paravirt.h |   5 +-
 arch/x86/kernel/kvmclock.c                |   2 +-
 arch/x86/kernel/paravirt.c                |  26 +++-
 arch/x86/kvm/svm/svm.c                    |  16 +--
 arch/x86/kvm/vmx/vmx.c                    |   4 +-
 arch/x86/xen/enlighten_pv.c               |  60 ++++++---
 arch/x86/xen/pmu.c                        |   4 +-
 13 files changed, 262 insertions(+), 148 deletions(-)

-- 
2.43.0


