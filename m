Return-Path: <kvm+bounces-64688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1B0C8AED8
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BAE764EC31D
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6876F33DEC5;
	Wed, 26 Nov 2025 16:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kIa4u0in";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kIa4u0in"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D2C30CDA1
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 16:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764174024; cv=none; b=jolHtNCb4KH28XlftHF8zvb22ly2HRkD13mQSd3CVOOq6forG5wGBP/5BgUzWqfgOs0IErSlFx4UWvl+mRS7l/kWpuwSY2nzQbCTkpAZXjyGhktSYXApIkdt6uOeaZPSxJREWnt2WhQIG0jVkzhhT4k8Kvy5eGsBMp5sDzXAPBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764174024; c=relaxed/simple;
	bh=wXjGUZeMOz1hGLe5c+VRMASjy7GTN2NrGP86qqIgpX8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JAYN4g6BmiRdZnv5KwsbLEuqeZOKvce0l3pGCk6xeB8Dt015bhZhCF9MNwNruQvWdv7JMiQWz3v7h5mB5uR3sQpMwqh0PmxuVAQeMA+0BOkdJtRC0dlMrnCa2op73xoXLrcklJ06KCFoX/0JPjWvsd8G68fxv2Aza+toBmQ2RR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kIa4u0in; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kIa4u0in; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CFF0022D57;
	Wed, 26 Nov 2025 16:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764174020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Edyr3JIcssZPzLUBYOKLIR47asUKGoc/LXSm51c/xFM=;
	b=kIa4u0inAxEFPkTeqGZCkDZ4D2vt01np+F6+w+3qFtF+GGEHwE9ugJfZ6Z3Yo6AjO61FjP
	3v9F9272z8Wn2iVrpu9JGA1rtfCfw9Nhmk6iBUbyc1P5Bz5G/72+JtiyzYyEz22PWWq8SE
	T15t07/DIftfkmL6PisqLwrZhtKDMks=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764174020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Edyr3JIcssZPzLUBYOKLIR47asUKGoc/LXSm51c/xFM=;
	b=kIa4u0inAxEFPkTeqGZCkDZ4D2vt01np+F6+w+3qFtF+GGEHwE9ugJfZ6Z3Yo6AjO61FjP
	3v9F9272z8Wn2iVrpu9JGA1rtfCfw9Nhmk6iBUbyc1P5Bz5G/72+JtiyzYyEz22PWWq8SE
	T15t07/DIftfkmL6PisqLwrZhtKDMks=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3572C3EA63;
	Wed, 26 Nov 2025 16:20:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6YWpC8QoJ2lbLQAAD6G6ig
	(envelope-from <jgross@suse.com>); Wed, 26 Nov 2025 16:20:20 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-block@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>,
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
	Jean Delvare <jdelvare@suse.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Denis Efremov <efremov@linux.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 0/5] x86: Cleanups around slow_down_io()
Date: Wed, 26 Nov 2025 17:20:13 +0100
Message-ID: <20251126162018.5676-1-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[23];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO

While looking at paravirt cleanups I stumbled over slow_down_io() and
the related REALLY_SLOW_IO define.

Especially REALLY_SLOW_IO is a mess, which is proven by 2 completely
wrong use cases.

Do several cleanups, resulting in a deletion of REALLY_SLOW_IO and the
io_delay() paravirt function hook.

Patches 2 and 3 are not changing any functionality, but maybe they
should? As the potential bug has been present for more than a decade
now, I went with just deleting the useless "#define REALLY_SLOW_IO".
The alternative would be to do something similar as in patch 5.

Juergen Gross (5):
  x86/paravirt: Replace io_delay() hook with a bool
  hwmon/lm78: Drop REALLY_SLOW_IO setting
  hwmon/w83781d: Drop REALLY_SLOW_IO setting
  block/floppy: Don't use REALLY_SLOW_IO for delays
  x86/io: Remove REALLY_SLOW_IO handling

 arch/x86/include/asm/floppy.h         | 27 ++++++++++++++++++++++-----
 arch/x86/include/asm/io.h             | 12 +++++-------
 arch/x86/include/asm/paravirt.h       | 11 +----------
 arch/x86/include/asm/paravirt_types.h |  3 +--
 arch/x86/kernel/cpu/vmware.c          |  2 +-
 arch/x86/kernel/kvm.c                 |  8 +-------
 arch/x86/kernel/paravirt.c            |  3 +--
 arch/x86/xen/enlighten_pv.c           |  6 +-----
 drivers/block/floppy.c                |  2 --
 drivers/hwmon/lm78.c                  |  5 +++--
 drivers/hwmon/w83781d.c               |  5 +++--
 11 files changed, 39 insertions(+), 45 deletions(-)

-- 
2.51.0


