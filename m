Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF51E31E375
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 01:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhBRAXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 19:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhBRAXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 19:23:02 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1214DC061786
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:22 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id u3so607891ybj.13
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=iBNwhQlaM8S1KFWuWRJxuU1NbrN0MOkrUcLNLYh5sLs=;
        b=sg02MMxXzTGpq1vDgtcRNnNJD1FYuOEBxMfPHbJ/nVr0nyTNMTIRP4/4k/cSf9ZV5L
         WC+2IJV1Yd2B8HkDe7aQ8m1kLYomfpxtihPgttraQCbiMduP2wizuVpcj3pzuusKkbg/
         gNk66gqSVB60s22GIUkiH7IxeQuBoEku+uMugw8vNfLegF0sEK4G41tvkRwEX1b66YDW
         9re777VdX/TGeLlAOqxGjFl47RTeDjIaDdwzvCvnX9HqYlvlUu7NQofHXETuM507KVgK
         Oawsq5wnEytGSTxnSWXYz9JJXlyIWO2ioFW6mjJmI/bqKDXmzilxel7qTX6A1uTzFiFP
         O2Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=iBNwhQlaM8S1KFWuWRJxuU1NbrN0MOkrUcLNLYh5sLs=;
        b=QYjLWrfFvrZmvvc/ByCLfe3Hyt40FoW7Tx9NUJFyKq8Fm0xkv9FvR1do2VFZ7OY5UW
         fRyO1OfsmiCsfGM55e7/xigTbTxkDlLiTrn8A2m9PxKLYHCaMABPRaxfGfkPvtokrkNx
         vY9ULWe4PG2KHaq8QB4es1FnW+bHoyyZlMI0HQYyMaAphSowDlVaMUUcrP14k+47e0TD
         RBL9eatYsBRwDbN+OBnPutffP2zlsm+YjmnK9yiroaeSGUQpGbSzk47rP7bXLmza2aHX
         NTnY4DwHrHQ1gulgYZJ6HNoCSetrovXG9kIDRD1G0E/UJL8tIFXYEvnHCLvzNpgUVl4P
         DXkQ==
X-Gm-Message-State: AOAM530Z5jkATWCF9E3yp2WOzOjImwiolqBOmdgCMIiR9+74UTKrCZm+
        b+Pax86ob5pxz2+tidNkyMtl0q/2lzU=
X-Google-Smtp-Source: ABdhPJwQ50u1/ZJSKarV2fbiML4Mc4Of1uyD5gfwZZitjMpCWhMBDMY5SsRbdueg6zt93JRj4k0TzI3deoQ=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
 (user=seanjc job=sendgmr) by 2002:a05:6902:6b2:: with SMTP id
 j18mr2767325ybt.383.1613607741367; Wed, 17 Feb 2021 16:22:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 17 Feb 2021 16:22:08 -0800
In-Reply-To: <20210218002212.2904647-1-seanjc@google.com>
Message-Id: <20210218002212.2904647-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210218002212.2904647-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [kvm-unit-tests PATCH 2/6] x86: nVMX: Skip unrestricted guest (URG)
 test if URG isn't supported
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the enable_unrestricted_guest() helper to enable URG and bail if it
URG isn't supported.  EPT is also required for URG, but EPT can be
enabled independent of URG, and some hardware support EPT but not URG,
e.g. NHM.

Fixes: f441716 ("nVMX: Test vmentry of unrestricted (PG=0/PE=1) nested guest")
Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index cf42619..35463b6 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8266,12 +8266,14 @@ static void unsetup_unrestricted_guest(void)
  */
 static void vmentry_unrestricted_guest_test(void)
 {
+	if (enable_unrestricted_guest(true)) {
+		report_skip("Unrestricted guest not supported");
+		return;
+	}
+
 	test_set_guest(unrestricted_guest_main);
 	setup_unrestricted_guest();
-	if (setup_ept(false))
-		test_skip("EPT not supported");
-       vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | CPU_URG);
-       test_guest_state("Unrestricted guest test", false, CPU_URG, "CPU_URG");
+	test_guest_state("Unrestricted guest test", false, CPU_URG, "CPU_URG");
 
 	/*
 	 * Let the guest finish execution as a regular guest
-- 
2.30.0.478.g8a0d178c01-goog

