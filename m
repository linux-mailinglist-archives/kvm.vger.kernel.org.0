Return-Path: <kvm+bounces-68532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EA5BDD3B5CD
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 19:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 869343042FF2
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 18:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126DF36A016;
	Mon, 19 Jan 2026 18:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="adGq2lDw";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="adGq2lDw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA7136BCE0
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 18:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768847201; cv=none; b=eDKsRqjyHBAXoNsQzGXPKvHpwrSwsNRjrdnUManfF2YmgJ+g+Osetdrdew+ICMsfCcz5G7xfwnjGQkr9mm5aJelamyD98KzULJAw5rGdAb3oWWv8FUCPLus1XBgakpzlbrXBDuUCwUa3w0609rkIgYe/OuIxJI1N6bXT0VsQPQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768847201; c=relaxed/simple;
	bh=tr7TfSRZl/vr1EMw55Y8Odfg8JIqcA+4106PISBo9Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G8Lx06q3zG4UmEmvwVQYe6rcFxqLV3gLgvdrJWvy/5t0N63PogOSD2DmJcb2QYp5VMp+JFT5wdyZG2kTbxXYBR4rMVYWSXEMhOmZ9EibmQkWcfS3R7QVtnppcEoRr7ZyRp87FxS9VZanpX9bdIvqfVcL3ErE+qKek9R57Sfs9ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=adGq2lDw; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=adGq2lDw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CDD235BCCE;
	Mon, 19 Jan 2026 18:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768847195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=es6/9iazupCDI6/7lXEp32/GJOPok2cUpRLmpWvKLkM=;
	b=adGq2lDw/ziTP/sy6wRsMUsI9ByF14hQ6d0dKFUjC3IKDHScmmeOQqchV3ghgQzs6QqArp
	7Rq6Rh1gvW5LvZjxrzfFc2chPq5Ak1+BhW51vLfvoPWnTdC1j+0l05Ln6G2pjOcrIqPmr7
	oNCARBaKZXFCT2zf+k1qE+41DTi8lMs=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=adGq2lDw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768847195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=es6/9iazupCDI6/7lXEp32/GJOPok2cUpRLmpWvKLkM=;
	b=adGq2lDw/ziTP/sy6wRsMUsI9ByF14hQ6d0dKFUjC3IKDHScmmeOQqchV3ghgQzs6QqArp
	7Rq6Rh1gvW5LvZjxrzfFc2chPq5Ak1+BhW51vLfvoPWnTdC1j+0l05Ln6G2pjOcrIqPmr7
	oNCARBaKZXFCT2zf+k1qE+41DTi8lMs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 266903EA63;
	Mon, 19 Jan 2026 18:26:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1xrIB1t3bmmpaAAAD6G6ig
	(envelope-from <jgross@suse.com>); Mon, 19 Jan 2026 18:26:35 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-block@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	xen-devel@lists.xenproject.org,
	Denis Efremov <efremov@linux.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v4 0/6] x86: Cleanups around slow_down_io()
Date: Mon, 19 Jan 2026 19:26:26 +0100
Message-ID: <20260119182632.596369-1-jgross@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	FROM_HAS_DN(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: CDD235BCCE
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

While looking at paravirt cleanups I stumbled over slow_down_io() and
the related REALLY_SLOW_IO define.

Do several cleanups, resulting in a deletion of REALLY_SLOW_IO and the
io_delay() paravirt function hook.

Patch 4 is removing the config options for selecting the default delay
mechanism and sets the default to "no delay". This is in preparation of
removing the io_delay() functionality completely, as suggested by Ingo
Molnar.

Patch 5 is adding an additional config option allowing to avoid
building io_delay.c (default is still to build it).

Changes in V2:
- patches 2 and 3 of V1 have been applied
- new patches 4 and 5

Changes in V3:
- rebase to tip/master kernel branch

Changes in V4:
- add patch 1 as prereq patch to the series

Juergen Gross (6):
  x86/irqflags: Fix build failure
  x86/paravirt: Replace io_delay() hook with a bool
  block/floppy: Don't use REALLY_SLOW_IO for delays
  x86/io: Remove REALLY_SLOW_IO handling
  x86/io_delay: Switch io_delay() default mechanism to "none"
  x86/io_delay: Add config option for controlling build of io_delay.

 arch/x86/Kconfig                      |  8 +++
 arch/x86/Kconfig.debug                | 30 ----------
 arch/x86/include/asm/floppy.h         | 31 ++++++++--
 arch/x86/include/asm/io.h             | 19 ++++---
 arch/x86/include/asm/irqflags.h       |  6 +-
 arch/x86/include/asm/paravirt-base.h  |  6 ++
 arch/x86/include/asm/paravirt.h       | 11 ----
 arch/x86/include/asm/paravirt_types.h |  2 -
 arch/x86/kernel/Makefile              |  3 +-
 arch/x86/kernel/cpu/vmware.c          |  2 +-
 arch/x86/kernel/io_delay.c            | 81 +--------------------------
 arch/x86/kernel/kvm.c                 |  8 +--
 arch/x86/kernel/paravirt.c            |  3 +-
 arch/x86/kernel/setup.c               |  4 +-
 arch/x86/xen/enlighten_pv.c           |  6 +-
 drivers/block/floppy.c                |  2 -
 16 files changed, 63 insertions(+), 159 deletions(-)

-- 
2.52.0


