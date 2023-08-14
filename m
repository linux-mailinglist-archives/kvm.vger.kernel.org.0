Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4745177B5E4
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 12:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbjHNKC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 06:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235731AbjHNKCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 06:02:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCEBE6A;
        Mon, 14 Aug 2023 03:02:44 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5E0C81FD5F;
        Mon, 14 Aug 2023 10:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692007363; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=IyKh5jauTYrhx4587vKnoX3MH5O7mJ8qY3Jx2CEtlAY=;
        b=LBi4WPhTJEUgWt3frmet2IQi5mawNGqzLrFq0pNFhUTyREGho0NX1Bm0aWeF3kyRSBrlJU
        +1LMjKZ9rr8NcmXs/XWIGxXkQZ1Wi/GA5NEmbyVTKzVtbOSIy/FsdcoWgyKtNHJOgYObPL
        +Y6IOJneFshthL7a55kWN7K3R4AKQ18=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692007363;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=IyKh5jauTYrhx4587vKnoX3MH5O7mJ8qY3Jx2CEtlAY=;
        b=9rxNXdttJwvs9OpKw1bcLCb3ybe4RAZlSCd9SekIT8srjzIr2+VR4Ir3VieOXKFMuUMHO6
        jgzb8eFNBDr9jWDA==
Received: from hawking.nue2.suse.org (unknown [10.168.4.181])
        by relay2.suse.de (Postfix) with ESMTP id 4F3BE2C143;
        Mon, 14 Aug 2023 10:02:43 +0000 (UTC)
Received: by hawking.nue2.suse.org (Postfix, from userid 17005)
        id 41F824AB2CC; Mon, 14 Aug 2023 12:02:43 +0200 (CEST)
From:   Andreas Schwab <schwab@suse.de>
To:     kvm-riscv@lists.infradead.org
Subject: [PATCH] tools/kvm_stat: add support for riscv
CC:     linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Yow:  We are now enjoying total mutual interaction in an imaginary hot tub...
Date:   Mon, 14 Aug 2023 12:02:43 +0200
Message-ID: <mvmbkfadjr0.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andreas Schwab <schwab@suse.de>
---
 tools/kvm/kvm_stat/kvm_stat | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 15bf00e79e3f..05220b9d07dc 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -320,6 +320,8 @@ class Arch(object):
             return ArchA64()
         elif machine.startswith('s390'):
             return ArchS390()
+        elif machine.startswith('riscv'):
+            return ArchRISCV()
         else:
             # X86_64
             for line in open('/proc/cpuinfo'):
@@ -396,6 +398,18 @@ class ArchS390(Arch):
             return 'exit_instruction'
 
 
+class ArchRISCV(Arch):
+    def __init__(self):
+        self.sc_perf_evt_open = 241
+        self.ioctl_numbers = IOCTL_NUMBERS
+        self.exit_reason_field = None
+        self.exit_reasons = None
+
+    def debugfs_is_child(self, field):
+        """ Returns name of parent if 'field' is a child, None otherwise """
+        return None
+
+
 ARCH = Arch.get_arch()
 
 
-- 
2.41.0


-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
