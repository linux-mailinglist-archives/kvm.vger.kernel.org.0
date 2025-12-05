Return-Path: <kvm+bounces-65322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B87A9CA75A7
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 12:22:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 72EFA374914B
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F1831A57A;
	Fri,  5 Dec 2025 07:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="F6RTOJoG";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QDT6CYCM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A13830171C
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 07:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920786; cv=none; b=Qd6R1V0sCoa+rvG0GcgQjp2GGWWUef9ZS5PbMR9CFDA9/unsIrIPsr5jyEJJ0aK0G5odEhaeGLD6S5IGVFRgiiDmzlv9rHIAaXsfR3zxsKNRT3J1LozssNe7Un1CsK89b6IVR/bq35qlkKA/7GUX5cJ9k5RJrndXgLrZIXEk6Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920786; c=relaxed/simple;
	bh=rA9HKk5moWYlnGk3Z2/vyhTRwyGgfciue+Y3OqWJrNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mvJ0paudyIHfoZKxSKBRZ/u0Q1fNvKvziTO9KtLmIasbgGqXovPglEvTg/Qdar49WG8fM96uzqll/vo27ASeUvqmvsLy6RpSuWNLGTah/V+TUfES9CcmkMD9hVFcwH2kLgE0e/NxLFjL8TveVoJEBsQ5ItF469pJYJZv/3rBStw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=F6RTOJoG; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QDT6CYCM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 67E555BD1C;
	Fri,  5 Dec 2025 07:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1UaRXttXzE4JpaLeE8PWKmnXKscH2XUyGJ6020NmSzU=;
	b=F6RTOJoGGQcQiiYcOPMUMfP9gNJdYD3tKBNBiUg8q7mgoyvRJRYnvKFko49PABnlcI6D0W
	ryMKHvuQWp/YfUMjEG4Wy+02AuT/XSQECu3xP+6MGoFrIrM2cI8ejlCwaTZPzX8jKKvyYn
	u51p/MBnTLJUx9wPJbGiVwZOgTrfo/I=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=QDT6CYCM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1UaRXttXzE4JpaLeE8PWKmnXKscH2XUyGJ6020NmSzU=;
	b=QDT6CYCMPVeogsLocEbeGk3mtoWUY7S80iKhqIn2TVd714JdhcGV4B4GKcnkvIAP7qKVvl
	HXtdC+pwiicnzQka4OeyxGzNqB5yGfexecl4duwmmA5ZfA8LMeAqtz34x0bXLN8SBHsnxc
	XU8cDeOGts1kndOX/ha9VmBVUt8T4R0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D702B3EA63;
	Fri,  5 Dec 2025 07:45:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LdwYM6ONMmnCEQAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 05 Dec 2025 07:45:39 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev
Cc: Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>
Subject: [PATCH 00/10] KVM: Avoid literal numbers as return values
Date: Fri,  5 Dec 2025 08:45:27 +0100
Message-ID: <20251205074537.17072-1-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 67E555BD1C
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

This series is the first part of replacing the use of literal numbers
(0 and 1) as return values with either true/false or with defines.

This work is a prelude of getting rid of the magic value "1" for
"return to guest". I started in x86 KVM host code doing that and soon
stumbled over lots of other use cases of the magic "1" as return value,
especially in MSR emulation where a comment even implied this "1" was
due to the "return to guest" semantics.

A detailed analysis of all related code paths revealed that there was
indeed a rather clean interface between the functions using the MSR
emulation "1" and those using the "return to guest" "1". 

A few functions just using "0" and "1" instead of bool are changed,
tooi (patches 1-4).

The rest of the series is cleaning up the MSR emulation code by using
new proper defines for return values 0 and 1.

The whole series should not result in any functional change.

Juergen Gross (10):
  KVM: Switch coalesced_mmio_in_range() to return bool
  KVM/x86: Use bool for the err parameter of kvm_complete_insn_gp()
  KVM/x86: Let x86_emulate_ops.set_cr() return a bool
  KVM/x86: Let x86_emulate_ops.set_dr() return a bool
  KVM/x86: Add KVM_MSR_RET_* defines for values 0 and 1
  KVM/x86: Use defines for APIC related MSR emulation
  KVM/x86: Use defines for Hyper-V related MSR emulation
  KVM/x86: Use defines for VMX related MSR emulation
  KVM/x86: Use defines for SVM related MSR emulation
  KVM/x86: Use defines for common related MSR emulation

 arch/x86/include/asm/kvm_host.h |  14 +-
 arch/x86/kvm/emulate.c          |   2 +-
 arch/x86/kvm/hyperv.c           | 110 +++++++-------
 arch/x86/kvm/kvm_emulate.h      |   4 +-
 arch/x86/kvm/lapic.c            |  48 +++----
 arch/x86/kvm/mtrr.c             |  12 +-
 arch/x86/kvm/pmu.c              |  12 +-
 arch/x86/kvm/smm.c              |   2 +-
 arch/x86/kvm/svm/pmu.c          |  12 +-
 arch/x86/kvm/svm/svm.c          |  54 +++----
 arch/x86/kvm/vmx/main.c         |   2 +-
 arch/x86/kvm/vmx/nested.c       |  18 +--
 arch/x86/kvm/vmx/pmu_intel.c    |  20 +--
 arch/x86/kvm/vmx/tdx.c          |  18 +--
 arch/x86/kvm/vmx/tdx.h          |   2 +-
 arch/x86/kvm/vmx/vmx.c          | 122 ++++++++--------
 arch/x86/kvm/x86.c              | 246 ++++++++++++++++----------------
 arch/x86/kvm/x86.h              |  10 +-
 arch/x86/kvm/xen.c              |  14 +-
 virt/kvm/coalesced_mmio.c       |  14 +-
 20 files changed, 372 insertions(+), 364 deletions(-)

-- 
2.51.0


