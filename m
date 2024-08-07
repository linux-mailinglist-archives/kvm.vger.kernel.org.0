Return-Path: <kvm+bounces-23569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82FE094AECE
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 19:24:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 056791F22034
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 17:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E226513C9CF;
	Wed,  7 Aug 2024 17:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gwbI1u6t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sReSfxiL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gwbI1u6t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sReSfxiL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6251E7D08F
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 17:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723051445; cv=none; b=ZbagQLuyWskDZ41FM+rvZFApfOkvSgU3eKBy91GuYkcbDB6rz2oq+VjG36G8Whakr9HgDxUXaK3utP5HlldpduHcVyLK+Ss6Qb0QvYwFbmKkcF0b2LjAhSBJCcWvVGpiEBc9jlbmcO8WAT4FoDmPkFT7r4gZ4RaRbcDw1mq4hKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723051445; c=relaxed/simple;
	bh=I6OSm4FIlGG5plBnNuxYzhN+ICozJCgrqsThFehPrIM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hyWjXvaaN2xwcMet+ndGNzaoas+PQcVVFk4cFxSUQqiEtc4el9QtVkWq1CnBzKUdxP1Ke6XwIGwG8FGwkUx0qfKwlkKN6PybivU91GVU9ZmJGag5OMl+wfxKtACw+u+b/XwJZ77p98p4GScPdyxxP/ml09duVtbx3L0hSpYCQFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gwbI1u6t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sReSfxiL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gwbI1u6t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sReSfxiL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A1BCC21CA3;
	Wed,  7 Aug 2024 17:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723051441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9R2QwzdqSfsHhZEdXvPCXjRM5kllkSXFreOeNNMrPO4=;
	b=gwbI1u6tiaqOrRD38hJOSE6ESsIPzXlINMLfvJqAYnjnjSFeTaq3mekRN2wDSt9dedYwng
	wtK7hTFvtHq1R+CxM48puPIx8BC4m1l5VJcO9v3wF2o5z4yARgVIC0gRaED5VA7CY6sVTS
	+FvmzfKKpObND5JWdNOVGzLwW3DOhVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723051441;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9R2QwzdqSfsHhZEdXvPCXjRM5kllkSXFreOeNNMrPO4=;
	b=sReSfxiLxAooTseXs2LGKH/vZPM+PHmI3Nx67lL4IbBv4OrpWqJIO97NSPJPdZGNfRfDus
	mM/Zsh5QHxK10QDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723051441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9R2QwzdqSfsHhZEdXvPCXjRM5kllkSXFreOeNNMrPO4=;
	b=gwbI1u6tiaqOrRD38hJOSE6ESsIPzXlINMLfvJqAYnjnjSFeTaq3mekRN2wDSt9dedYwng
	wtK7hTFvtHq1R+CxM48puPIx8BC4m1l5VJcO9v3wF2o5z4yARgVIC0gRaED5VA7CY6sVTS
	+FvmzfKKpObND5JWdNOVGzLwW3DOhVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723051441;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9R2QwzdqSfsHhZEdXvPCXjRM5kllkSXFreOeNNMrPO4=;
	b=sReSfxiLxAooTseXs2LGKH/vZPM+PHmI3Nx67lL4IbBv4OrpWqJIO97NSPJPdZGNfRfDus
	mM/Zsh5QHxK10QDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66F1B13297;
	Wed,  7 Aug 2024 17:24:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id F++JF7Gts2ZCIQAAD6G6ig
	(envelope-from <cfontana@suse.de>); Wed, 07 Aug 2024 17:24:01 +0000
From: Claudio Fontana <cfontana@suse.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Claudio Fontana <cfontana@suse.de>,
	Dario Faggioli <dfaggioli@suse.com>,
	Fabiano Rosas <farosas@suse.de>
Subject: [PATCH] tools/kvm_stat: fix termination behavior when not on a terminal
Date: Wed,  7 Aug 2024 19:23:34 +0200
Message-Id: <20240807172334.1006-1-cfontana@suse.de>
X-Mailer: git-send-email 2.26.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.com:email]
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spam-Level: 

For the -l and -L options (logging mode), replace the use of the
KeyboardInterrupt exception to gracefully terminate in favor
of handling the SIGINT and SIGTERM signals.

This allows the program to be run from scripts and still be
signaled to gracefully terminate without an interactive terminal.

Before this change, something like this script:

kvm_stat -p 85896 -d -t -s 1 -c -L kvm_stat_85896.csv &
sleep 10
pkill -TERM -P $$

would yield an empty log:
-rw-r--r-- 1 root root     0 Aug  7 16:17 kvm_stat_85896.csv

after this commit:
-rw-r--r-- 1 root root 13466 Aug  7 16:57 kvm_stat_85896.csv

Signed-off-by: Claudio Fontana <cfontana@suse.de>
Cc: Dario Faggioli <dfaggioli@suse.com>
Cc: Fabiano Rosas <farosas@suse.de>
---
 tools/kvm/kvm_stat/kvm_stat     | 64 ++++++++++++++++-----------------
 tools/kvm/kvm_stat/kvm_stat.txt | 12 +++++++
 2 files changed, 44 insertions(+), 32 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 15bf00e79e3f..2cf2da3ed002 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -297,8 +297,6 @@ IOCTL_NUMBERS = {
     'RESET':       0x00002403,
 }
 
-signal_received = False
-
 ENCODING = locale.getpreferredencoding(False)
 TRACE_FILTER = re.compile(r'^[^\(]*$')
 
@@ -1598,7 +1596,19 @@ class CSVFormat(object):
 
 def log(stats, opts, frmt, keys):
     """Prints statistics as reiterating key block, multiple value blocks."""
-    global signal_received
+    signal_received = defaultdict(bool)
+
+    def handle_signal(sig, frame):
+        nonlocal signal_received
+        signal_received[sig] = True
+        return
+
+
+    signal.signal(signal.SIGINT, handle_signal)
+    signal.signal(signal.SIGTERM, handle_signal)
+    if opts.log_to_file:
+        signal.signal(signal.SIGHUP, handle_signal)
+
     line = 0
     banner_repeat = 20
     f = None
@@ -1624,39 +1634,31 @@ def log(stats, opts, frmt, keys):
     do_banner(opts)
     banner_printed = True
     while True:
-        try:
-            time.sleep(opts.set_delay)
-            if signal_received:
-                banner_printed = True
-                line = 0
-                f.close()
-                do_banner(opts)
-                signal_received = False
-            if (line % banner_repeat == 0 and not banner_printed and
-                not (opts.log_to_file and isinstance(frmt, CSVFormat))):
-                do_banner(opts)
-                banner_printed = True
-            values = stats.get()
-            if (not opts.skip_zero_records or
-                any(values[k].delta != 0 for k in keys)):
-                do_statline(opts, values)
-                line += 1
-                banner_printed = False
-        except KeyboardInterrupt:
+        time.sleep(opts.set_delay)
+        # Do not use the KeyboardInterrupt exception, because we may be running without a terminal
+        if (signal_received[signal.SIGINT] or signal_received[signal.SIGTERM]):
             break
+        if signal_received[signal.SIGHUP]:
+            banner_printed = True
+            line = 0
+            f.close()
+            do_banner(opts)
+            signal_received[signal.SIGHUP] = False
+        if (line % banner_repeat == 0 and not banner_printed and
+            not (opts.log_to_file and isinstance(frmt, CSVFormat))):
+            do_banner(opts)
+            banner_printed = True
+        values = stats.get()
+        if (not opts.skip_zero_records or
+            any(values[k].delta != 0 for k in keys)):
+            do_statline(opts, values)
+            line += 1
+            banner_printed = False
 
     if opts.log_to_file:
         f.close()
 
 
-def handle_signal(sig, frame):
-    global signal_received
-
-    signal_received = True
-
-    return
-
-
 def is_delay_valid(delay):
     """Verify delay is in valid value range."""
     msg = None
@@ -1869,8 +1871,6 @@ def main():
         sys.exit(0)
 
     if options.log or options.log_to_file:
-        if options.log_to_file:
-            signal.signal(signal.SIGHUP, handle_signal)
         keys = sorted(stats.get().keys())
         if options.csv:
             frmt = CSVFormat(keys)
diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
index 3a9f2037bd23..4a99a111a93c 100644
--- a/tools/kvm/kvm_stat/kvm_stat.txt
+++ b/tools/kvm/kvm_stat/kvm_stat.txt
@@ -115,6 +115,18 @@ OPTIONS
 --skip-zero-records::
         omit records with all zeros in logging mode
 
+
+SIGNALS
+-------
+when kvm_stat is running in logging mode (either with -l or with -L),
+it handles the following signals:
+
+SIGHUP - closes and reopens the log file (-L only), then continues.
+
+SIGINT - closes the log file and terminates.
+SIGTERM - closes the log file and terminates.
+
+
 SEE ALSO
 --------
 'perf'(1), 'trace-cmd'(1)
-- 
2.26.2


