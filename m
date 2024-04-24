Return-Path: <kvm+bounces-15781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C97608B076F
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 12:34:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA9FE1C2213E
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 10:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5616159580;
	Wed, 24 Apr 2024 10:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z7L7Vv2W";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7ntG99+Z";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z7L7Vv2W";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7ntG99+Z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480A413DBB2;
	Wed, 24 Apr 2024 10:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713954873; cv=none; b=rijDjOMpuZXEzoLQft0F1bVAlz3FXXqwaRU7FHaD2xZIsq2+H9dpxX9AlDdtnI2YQl149X3SPACuG1dvg/7tu7xc4yM0NDW3l0H+HeBSggEePf5UuDoEhqJDhqrKyuoZx+4Gfx6jLZ2/MzXiO03ltzJoHM3716nmpkvQD/xO7rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713954873; c=relaxed/simple;
	bh=kcJ56fsa/PMFsPSqACtQFZlurMUAdbmI1ttj5bfikVM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=fEOfXEYeU6s6zT1L9kWdUwwsYZpq23o/5P0J0QDctVd8CE50KWSnkWLfcNrBsKFjC+n6T2korISLL91FpTTIM14AkiZwVbpLWyAI7PMePYFwyTXUrobiBKKs+LmnJcB0Nq6/jlO4N6kTyWbOI3V0neaXKQOIAFBnoV8OISnaEy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z7L7Vv2W; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7ntG99+Z; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z7L7Vv2W; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7ntG99+Z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 767C3613F2;
	Wed, 24 Apr 2024 10:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713954870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lClhB2Lx5EF0SugdSw87bUnROejaSI8p6PH1P+TqX3s=;
	b=Z7L7Vv2W7CLL9VMxKrr1on+J8hyAT76nbbvz35Dw5Jorq6mpHanLXSh1c9aBsRI16Hvbrw
	nTsAR22V3fSWsadfnRYFwLHJc6NmSHMYywNCXiA7YuaXWISHxU+UV8qU0uiCRqYRTnjfOF
	kcN+JXj5uCcbpMFL/19nl+OO8Ao5u8Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713954870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lClhB2Lx5EF0SugdSw87bUnROejaSI8p6PH1P+TqX3s=;
	b=7ntG99+Zuc6fCcwdsPn+3q3HFP/MOJMDX5B93jon/FP3EBHZm89pXT5UDw/T5hPewoQEtw
	nH6f/Q75Dd3SAFCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z7L7Vv2W;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7ntG99+Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713954870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lClhB2Lx5EF0SugdSw87bUnROejaSI8p6PH1P+TqX3s=;
	b=Z7L7Vv2W7CLL9VMxKrr1on+J8hyAT76nbbvz35Dw5Jorq6mpHanLXSh1c9aBsRI16Hvbrw
	nTsAR22V3fSWsadfnRYFwLHJc6NmSHMYywNCXiA7YuaXWISHxU+UV8qU0uiCRqYRTnjfOF
	kcN+JXj5uCcbpMFL/19nl+OO8Ao5u8Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713954870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lClhB2Lx5EF0SugdSw87bUnROejaSI8p6PH1P+TqX3s=;
	b=7ntG99+Zuc6fCcwdsPn+3q3HFP/MOJMDX5B93jon/FP3EBHZm89pXT5UDw/T5hPewoQEtw
	nH6f/Q75Dd3SAFCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB61D1393C;
	Wed, 24 Apr 2024 10:34:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +ZsKNjXgKGauTAAAD6G6ig
	(envelope-from <clopez@suse.de>); Wed, 24 Apr 2024 10:34:29 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] KVM: fix documentation for KVM_CREATE_GUEST_MEMFD
Date: Wed, 24 Apr 2024 12:33:16 +0200
Message-Id: <20240424103317.28522-1-clopez@suse.de>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -1.95
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 767C3613F2
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-1.95 / 50.00];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MIXED_CHARSET(0.56)[subject];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]

The KVM_CREATE_GUEST_MEMFD ioctl returns a file descriptor, and is
documented as such in the description. However, the "Returns" field
in the documentation states that the ioctl returns 0 on success.
Update this to match the description.

Signed-off-by: Carlos López <clopez@suse.de>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..57bd2b2b1532 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6316,7 +6316,7 @@ The "flags" field is reserved for future extensions and must be '0'.
 :Architectures: none
 :Type: vm ioctl
 :Parameters: struct kvm_create_guest_memfd(in)
-:Returns: 0 on success, <0 on error
+:Returns: A file descriptor on success, <0 on error
 
 KVM_CREATE_GUEST_MEMFD creates an anonymous file and returns a file descriptor
 that refers to it.  guest_memfd files are roughly analogous to files created
-- 
2.35.3


