Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707716D42B5
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 12:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbjDCK4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 06:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbjDCK4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 06:56:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACE7AD04
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 03:56:37 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id l27so28881839wrb.2
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 03:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680519395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qj5ObJFyEiD8lPGnjnuXNDQhtwMJ0SLMCqhL+zNAU/Q=;
        b=gFZspbMY/cllAOmYDY/1ObHg7ar+yDqBuRkSHavHTmk/ilbCrAyF+a7WKw1bp15wLf
         Q9IYFOnsTM2q5bLyLw+TcjoCJeNTzHiT6Sox8ZadeIQ290lIew/TU9oI6AF+qICRLgcb
         cMdaoy0I6IO4dZumLLc4noN0/BCey5hXke32s0eWJGVAgjumk0MpmKo/zIZfzcxp+ibb
         iL27inZBOyipq9GTWg0j/6+EGLhDieZxclYKN1Agn4kjRiaDTaCMiUDEoRE1vHpQkZhb
         VY9Ob7K1UyycHPSbXA1N3xki4jdR14SnidPkhuTv2JIaI+/zXWuLqaVDeTf0s0lGoxJy
         EdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680519395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qj5ObJFyEiD8lPGnjnuXNDQhtwMJ0SLMCqhL+zNAU/Q=;
        b=hhnfBZleuPtyqHFvvJL+/FxampKmHMwuVBHsSHdR0v0QjjRIix/+26ip4PwlKyIrFa
         sZ/2Yxfr/Hu3DA3goLS6rLEPxNfo2qx80NNFto/mYj9MegJ435gIaTAScU+DVoWs2Mwf
         r8FfYEHZd1oSxlMBwQ9ldT8bTQ3VLXwFp5hPF5XOIgg+M2ttY3bul6TMuo1Zn9lKXZkR
         sLgoXPGAVfwxexmBCf6v/ItwjnqLUIG9P4WJ9jciAcEvFCOLyfbRJyUXsceSpmNFCnKL
         NQQz0eGD4Bbox40DPJzrbUXjeLFn8Rw7dqT+BpUpNpcMObCKUMchAhXGBiY6q+ijbBIp
         wUsw==
X-Gm-Message-State: AAQBX9dR/avizVEtJfAgM5hei2Hm48trXLLr9D/bcNNxfpvbaqqDzHjy
        qp7zqEnBtIWzM7cR8UvpnU5VXeeWzHy0mxYHnPsj7Q==
X-Google-Smtp-Source: AKy350bDo+rJBMg4rZGrT9w891XR1E4LgRGcymNnw5f7dpyRokXYo+N7eo3A2T+o42co5+sz/e3T4Q==
X-Received: by 2002:a5d:67cd:0:b0:2d7:babe:104c with SMTP id n13-20020a5d67cd000000b002d7babe104cmr25833176wrw.15.1680519395572;
        Mon, 03 Apr 2023 03:56:35 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af22160069a3c79c8928b176.dip0.t-ipconnect.de. [2003:f6:af22:1600:69a3:c79c:8928:b176])
        by smtp.gmail.com with ESMTPSA id x6-20020a5d60c6000000b002dfca33ba36sm9483671wrt.8.2023.04.03.03.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 03:56:35 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v3 4/4] x86/access: Try emulation for CR0.WP test as well
Date:   Mon,  3 Apr 2023 12:56:18 +0200
Message-Id: <20230403105618.41118-5-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230403105618.41118-1-minipli@grsecurity.net>
References: <20230403105618.41118-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enhance the CR.WP toggling test to do additional tests via the emulator
as these used to trigger bugs when CR0.WP is guest owned.

Link: https://lore.kernel.org/kvm/ea3a8fbc-2bf8-7442-e498-3e5818384c83@grsecurity.net/
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
Instead of testing 'invalid_mask', I simply added yet another call to
is_fep_available(). It's cleaner, IMO, as it's easier to grasp than
'!(invalid_mask & AC_FEP_MASK)'. The additional exception doesn't
influence the tests, as all preparation is done in do_cr0_wp_access().

 x86/access.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 674077297978..eab3959bc871 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -1107,14 +1107,17 @@ static int do_cr0_wp_access(ac_test_t *at, int flags)
 	 * Load CR0.WP with the inverse value of what will be used during
 	 * the access test and toggle EFER.NX to coerce KVM into rebuilding
 	 * the current MMU context based on the soon-to-be-stale CR0.WP.
+	 *
+	 * This used to trigger a bug in the emulator, testable via FEP.
 	 */
 	set_cr0_wp(!cr0_wp);
 	set_efer_nx(1);
 	set_efer_nx(0);
 
 	if (!ac_test_do_access(at)) {
-		printf("%s: supervisor write with CR0.WP=%d did not %s\n",
-		       __FUNCTION__, cr0_wp, cr0_wp ? "FAULT" : "SUCCEED");
+		printf("%s: %ssupervisor write with CR0.WP=%d did not %s\n",
+		       __FUNCTION__, (flags & AC_FEP_MASK) ? "emulated " : "",
+		       cr0_wp, cr0_wp ? "FAULT" : "SUCCEED");
 
 		return 1;
 	}
@@ -1133,6 +1136,10 @@ static int check_toggle_cr0_wp(ac_pt_env_t *pt_env)
 
 	err += do_cr0_wp_access(&at, 0);
 	err += do_cr0_wp_access(&at, AC_CPU_CR0_WP_MASK);
+	if (is_fep_available()) {
+		err += do_cr0_wp_access(&at, AC_FEP_MASK);
+		err += do_cr0_wp_access(&at, AC_FEP_MASK | AC_CPU_CR0_WP_MASK);
+	}
 
 	return err == 0;
 }
-- 
2.39.2

