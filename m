Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC096617EB4
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 15:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiKCOAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 10:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiKCN7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 09:59:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4DA15717
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 06:59:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9C44D1F385;
        Thu,  3 Nov 2022 13:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667483971; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=NtpfY5nBBj+78aUvosgFmxuhoR+/czCn3MlxCb3sVb8=;
        b=awpxsCGrfRuq2Nkwe0ipgPORtS/qaJBOPPYt6RX+wdX/phonZUOpnMDZOHTRcddpe4iHPo
        b+nT34CTv6ZvFg9Om0N8EtiQeTN5E+Ji2DIREJ4EUh6m/FBi7qJ4MlpCydwvsKfGoT5qpE
        U1gCP6ZxKxwQBzXFh5JZWbu6OMH2GYg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667483971;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=NtpfY5nBBj+78aUvosgFmxuhoR+/czCn3MlxCb3sVb8=;
        b=U12AonoNbUXme8SI84NrTZBupIbUabdjxMCNVsztOUbxJvpnCay3zssxUBGzR++0jlDxB/
        8tW4sIJHWF4Lc1BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 93DB213480;
        Thu,  3 Nov 2022 13:59:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id At0NJEPJY2P6bQAAMHmgww
        (envelope-from <mgerstner@suse.de>); Thu, 03 Nov 2022 13:59:31 +0000
From:   Matthias Gerstner <matthias.gerstner@suse.de>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH] tools/kvm_stat: fix attack vector with user controlled FUSE mounts
Date:   Thu,  3 Nov 2022 14:59:27 +0100
Message-Id: <20221103135927.13656-1-matthias.gerstner@suse.de>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first field in /proc/mounts can be influenced by unprivileged users
through the widespread `fusermount` setuid-root program. Example:

```
user$ mkdir ~/mydebugfs
user$ export _FUSE_COMMFD=0
user$ fusermount ~/mydebugfs -ononempty,fsname=debugfs
user$ grep debugfs /proc/mounts
debugfs /home/user/mydebugfs fuse rw,nosuid,nodev,relatime,user_id=1000,group_id=100 0 0
```

If there is no debugfs already mounted in the system then this can be
used by unprivileged users to trick kvm_stat into using a user
controlled file system location for obtaining KVM statistics.

To exploit this also a race condition has to be won, since the code
checks for the existence of the 'kvm' subdirectory of the resulting
path. This doesn't work on a FUSE mount, because the root user is not
allowed to access non-root FUSE mounts for security reasons. If an
attacker manages to unmount the FUSE mount in time again then kvm_stat
would be using the resulting path, though.

The impact if winning the race condition is mostly a denial-of-service
or damaged information integrity. The files in debugfs are only opened
for reading. So the attacker can cause very large data to be read in by
kvm_stat or fake data to be processed by kvm_stat. I don't see any
viable way to turn this into a privilege escalation.

The fix is simply to use the file system type field instead. Whitespace
in the mount path is escaped in /proc/mounts thus no further safety
measures in the parsing should be necessary to make this correct.
---
 tools/kvm/kvm_stat/kvm_stat | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 9c366b3a676d..88a73999aa58 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -1756,7 +1756,7 @@ def assign_globals():
 
     debugfs = ''
     for line in open('/proc/mounts'):
-        if line.split(' ')[0] == 'debugfs':
+        if line.split(' ')[2] == 'debugfs':
             debugfs = line.split(' ')[1]
             break
     if debugfs == '':
-- 
2.37.3

