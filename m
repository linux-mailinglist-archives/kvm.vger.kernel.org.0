Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1972B6D698A
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjDDQy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjDDQyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:54:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C935BA9
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:53:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id c193-20020a25c0ca000000b00b868826cdfeso7867679ybf.0
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680627235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RnnzwpD7ekp5ug/hWhu+eOuOwV02XJRjpC2JXxN8n0Y=;
        b=mWJR24xIRVaK7QGl5u1uiP6+hbrrpd6pnE7swWB28dIiXUcABWAKdzmqIncWUxyCBE
         HViCVfmC4GPpYlBMya4XHFwX5dyPgOqprh84KP7dTbxhxodPizY0mwQ5h7oP/0KhppOT
         60mK0vdHCh7BPF7RUbrWrIvMqapm7x23JXnUa0f0Ca9BhKIx1hIh3SjeraQ3hHhG3mP1
         hLUhHeGm2j+W1IcKnIhZfJJ50taVXAbawoG0p00hMZe6pXNU/uuE/yHNly/B6hzXMf7f
         fGVzgKsxMYV66V4JsldbtsGQdrscOoEmnk3e8k3DDN+Ztls4ZfEeWvgeBZyNke1fLbCx
         OdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680627235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RnnzwpD7ekp5ug/hWhu+eOuOwV02XJRjpC2JXxN8n0Y=;
        b=Ycy/RrF4u1ogfiVAviitNaR3eNAUPFb4CnXSY9Ovkk2C1+nyGWNW2VVydcWuq5n8bT
         +BnZE8VJu2YsU01W/9q/fL1KBxYVlsj4yYcwAyI+VzHwbnOVZs4a1HBe2aJ5P2r5Dah5
         bMAgy7Zn12aMr2c0T3mibOwGbtC7W7y4z3kE7YoVPYuWzhI/q9bf8XqJ+44Z6x3zLnNq
         o6ozui8zfBQjdxSLcCtktrXoiAw5v09WTR3PTeacXY7Aueq+2ypD72DnMJBlOIPDM5cX
         YqSVHuWgul2J2eivTx/eEeHKWLqBGxWEOZmTZPKE3LI+sIVSPqSjVs3iK5G3+jkltPEl
         AU1w==
X-Gm-Message-State: AAQBX9fIVisfYEat1uDBZJbQi3LHQaTXc5qzgD+2bttQq5+dA5/7dI8+
        ifOgINi92UcdXXG/TpcCP9skhdTsyx4=
X-Google-Smtp-Source: AKy350Y89i7B4KhfG5EnFrd/+TVi76E51e8cSRFd4LuqJFtntSdHObYz44ZMtUBCxHxlNMY2JlHeo+Oc7cw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:28c:b0:542:927b:1c79 with SMTP id
 bf12-20020a05690c028c00b00542927b1c79mr36738ywb.3.1680627235418; Tue, 04 Apr
 2023 09:53:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 09:53:37 -0700
In-Reply-To: <20230404165341.163500-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404165341.163500-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 6/9] x86/access: Try forced emulation for
 CR0.WP test as well
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mathias Krause <minipli@grsecurity.net>

Enhance the CR0.WP toggling test to do additional tests via the emulator
as forcing KVM to emulate page protections exercises different flows than
shoving the correct bits into hardware, e.g. KVM has had at least one bug
when CR0.WP is guest owned.

Link: https://lore.kernel.org/kvm/ea3a8fbc-2bf8-7442-e498-3e5818384c83@grsecurity.net
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
[sean: check AC_FEP_MASK instead of fep_available()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 4a3ca265..70d81bf0 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -1108,8 +1108,9 @@ static int do_cr0_wp_access(ac_test_t *at, int flags)
 	set_efer_nx(0);
 
 	if (!ac_test_do_access(at)) {
-		printf("%s: supervisor write with CR0.WP=%d did not %s\n",
-		       __FUNCTION__, cr0_wp, cr0_wp ? "FAULT" : "SUCCEED");
+		printf("%s: %ssupervisor write with CR0.WP=%d did not %s\n",
+		       __FUNCTION__, (flags & AC_FEP_MASK) ? "emulated " : "",
+		       cr0_wp, cr0_wp ? "FAULT" : "SUCCEED");
 		return 1;
 	}
 
@@ -1127,6 +1128,10 @@ static int check_toggle_cr0_wp(ac_pt_env_t *pt_env)
 
 	err += do_cr0_wp_access(&at, 0);
 	err += do_cr0_wp_access(&at, AC_CPU_CR0_WP_MASK);
+	if (!(invalid_mask & AC_FEP_MASK)) {
+		err += do_cr0_wp_access(&at, AC_FEP_MASK);
+		err += do_cr0_wp_access(&at, AC_FEP_MASK | AC_CPU_CR0_WP_MASK);
+	}
 
 	return err == 0;
 }
-- 
2.40.0.348.gf938b09366-goog

