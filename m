Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE2F394B32
	for <lists+kvm@lfdr.de>; Sat, 29 May 2021 11:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhE2JOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 May 2021 05:14:53 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44556 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhE2JOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 May 2021 05:14:53 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3B9051FD2E;
        Sat, 29 May 2021 09:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622279596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=gPpdHYqexkhpJFPtrzISl3ZCy+/VkvXUx1iUIIDxOXU=;
        b=yR+GnwjsEP5S2mMaWNKRE72b8cZO/yLRgVslrxi7s0XuLVWP+zDiznJX25lY+g/tC3Jzou
        yCBOve0M+zmzvxPY6m8SKJd1ENdzBM1KbnLOgsQC0dCDWEcsIF7/ixeb6AgvHIa456ar6K
        D52o2IoeD58yHvIjKJITa8bEVkeWZ8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622279596;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=gPpdHYqexkhpJFPtrzISl3ZCy+/VkvXUx1iUIIDxOXU=;
        b=if68VALKHVsXGXOK5ONp0YH12ivWQRLfkZYQg18UodmQ50cCHfsZqJyxlTgL7/3JZr1n0J
        uEnliR5KY744vtBw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 94043118DD;
        Sat, 29 May 2021 09:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622279596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=gPpdHYqexkhpJFPtrzISl3ZCy+/VkvXUx1iUIIDxOXU=;
        b=yR+GnwjsEP5S2mMaWNKRE72b8cZO/yLRgVslrxi7s0XuLVWP+zDiznJX25lY+g/tC3Jzou
        yCBOve0M+zmzvxPY6m8SKJd1ENdzBM1KbnLOgsQC0dCDWEcsIF7/ixeb6AgvHIa456ar6K
        D52o2IoeD58yHvIjKJITa8bEVkeWZ8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622279596;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=gPpdHYqexkhpJFPtrzISl3ZCy+/VkvXUx1iUIIDxOXU=;
        b=if68VALKHVsXGXOK5ONp0YH12ivWQRLfkZYQg18UodmQ50cCHfsZqJyxlTgL7/3JZr1n0J
        uEnliR5KY744vtBw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id Y3i9IasFsmCbEwAALh3uQQ
        (envelope-from <cfontana@suse.de>); Sat, 29 May 2021 09:13:15 +0000
From:   Claudio Fontana <cfontana@suse.de>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     Claudio Fontana <cfontana@suse.de>,
        "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-devel@nongnu.org
Subject: [PATCH 0/2] Fixes for broken commit 48afe6e4eabf, Windows fails to boot
Date:   Sat, 29 May 2021 11:13:11 +0200
Message-Id: <20210529091313.16708-1-cfontana@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: imap.suse.de;
        none
X-Spam-Level: *****
X-Spam-Score: 5.00
X-Spamd-Result: default: False [5.00 / 100.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         RCPT_COUNT_TWELVE(0.00)[13];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2]
X-Spam-Flag: NO
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit ("i386: split cpu accelerators from cpu.c, using AccelCPUClass")
introduced two bugs that break cpu max and host in the refactoring,
by running initializations in the wrong order.

This small series of two patches is an attempt to correct the situation.

Please provide your test results and feedback, thanks!

Claudio

Claudio Fontana (2):
  i386: reorder call to cpu_exec_realizefn in x86_cpu_realizefn
  i386: run accel_cpu_instance_init as instance_post_init

 target/i386/cpu.c | 66 +++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

-- 
2.26.2

