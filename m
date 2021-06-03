Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB1939A0E2
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhFCMbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:31:49 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47932 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhFCMbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:31:48 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6BFB51FD5C;
        Thu,  3 Jun 2021 12:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622723403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=3uMdkzMw1KNWFmkp5TDgOr4+NxSoov+sUKA8B8+ulqI=;
        b=TcIN+EV9riNOgld2I7+jC7kHRJjBFnsoy/lk96yz/2Y4U8lgYPJScVfgPxvf+7Alvp5I22
        WOIHaMCGtxv7bU3nzHjuEPsiON/GQC9Wc7e/+nyMYTVdrR7GRjYr9bVYX6WctHDJj4rrNb
        x7FyBL1+dGE/Q7F8uVZFtz5nUCQuo3c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622723403;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=3uMdkzMw1KNWFmkp5TDgOr4+NxSoov+sUKA8B8+ulqI=;
        b=hDY/gHFSys2PUUQWFRmDDYZF7pPyc3r++DwMnhT9OpN7OaMKyO5sAP8aJUJr7UtIATrPRk
        jitLWRggC9OGGnAQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id A588D118DD;
        Thu,  3 Jun 2021 12:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622723403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=3uMdkzMw1KNWFmkp5TDgOr4+NxSoov+sUKA8B8+ulqI=;
        b=TcIN+EV9riNOgld2I7+jC7kHRJjBFnsoy/lk96yz/2Y4U8lgYPJScVfgPxvf+7Alvp5I22
        WOIHaMCGtxv7bU3nzHjuEPsiON/GQC9Wc7e/+nyMYTVdrR7GRjYr9bVYX6WctHDJj4rrNb
        x7FyBL1+dGE/Q7F8uVZFtz5nUCQuo3c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622723403;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=3uMdkzMw1KNWFmkp5TDgOr4+NxSoov+sUKA8B8+ulqI=;
        b=hDY/gHFSys2PUUQWFRmDDYZF7pPyc3r++DwMnhT9OpN7OaMKyO5sAP8aJUJr7UtIATrPRk
        jitLWRggC9OGGnAQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id gsBMJUrLuGCiFwAALh3uQQ
        (envelope-from <cfontana@suse.de>); Thu, 03 Jun 2021 12:30:02 +0000
From:   Claudio Fontana <cfontana@suse.de>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Claudio Fontana <cfontana@suse.de>,
        "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-devel@nongnu.org
Subject: [PATCH v2 0/2] Fixes for "Windows fails to boot"
Date:   Thu,  3 Jun 2021 14:29:59 +0200
Message-Id: <20210603123001.17843-1-cfontana@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
 * moved hyperv realizefn call before cpu expansion (Vitaly)
 * added more comments (Eduardo)
 * fixed references to commit ids (Eduardo)

The combination of Commits:
f5cc5a5c ("i386: split cpu accelerators from cpu.c"...)                                                                              
30565f10 ("cpu: call AccelCPUClass::cpu_realizefn in"...) 

introduced two bugs that break cpu max and host in the refactoring,
by running initializations in the wrong order.

This small series of two patches is an attempt to correct the situation.

Please provide your test results and feedback, thanks!

Claudio

Claudio Fontana (2):
  i386: reorder call to cpu_exec_realizefn in x86_cpu_realizefn
  i386: run accel_cpu_instance_init as instance_post_init

 target/i386/cpu.c         | 89 +++++++++++++++++++++++++--------------
 target/i386/kvm/kvm-cpu.c | 12 +++++-
 2 files changed, 68 insertions(+), 33 deletions(-)

-- 
2.26.2

