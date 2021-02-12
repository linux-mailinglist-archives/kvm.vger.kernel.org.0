Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32043197DE
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 02:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhBLBJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 20:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhBLBHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 20:07:13 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83B9C061356
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 17:06:17 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id q104so5230690qvq.20
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 17:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=S7QHW8ZiBK6tGJi1I7cAXOJQJ+RvuKnKUK7n46X1AcY=;
        b=wQ69e+BIoW8rAIQrjAViBirPdI9jogJOg0i0tgtI54ooUPlvlC6+fYYGwqY3JxmH4J
         es6Wm5RRcC5oMGlqG1M9ZDb/P7r+3Ft3EFL92/1Py9gkbmvuUOGOPicf3KC2Logks9qT
         yRKYsWngvUkpFKPNLLs5U8+qe4c3ik9gPWQKa9n1OI8nA72YeJq3/zj8hPKmjp2mvAC2
         qUMeMyk48r9Y0kl3FpDelUrotEitYv5WYh77HNeRs0BxMv9/L+dgCwCbolQz+xT8LFds
         ozrJsWK8mQfS5uc2Hh4dVreKjS2RM6jltd81xksmWQKzT+ZjbqU7+zqI5pwwqJPPSlVT
         jkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=S7QHW8ZiBK6tGJi1I7cAXOJQJ+RvuKnKUK7n46X1AcY=;
        b=RFPVLNJ9UFlaoWjLCzjBp9QCY9HIMh5hXJMLwn16f+9D8G7mEnT2Gd8PbqxsFZsAWY
         BNG72u5F45HAXSyUEPQ4UnC5HEXbInRB7yNutKSpg3xttulr8SKEj2g6OkVYaYv6Cwo4
         PinhI84IDc59yaYwDuFEvHhwxEAL+sF0QJnAXtiIMSMYiOLFTPS9+CoAj4kLo4Yelubg
         6HWjnS6/fQvxl4I8BIAUTa0V4q6QitzOLHvDm4cOwg/VR+sZgvvEvOHZtf3J73zyqo2E
         8dCodEHutl91Q7JhLII3MCaInTzRQavmM2tAnKkrmLM2IYkowDLAGl9rGUmviLrnLyaU
         av6w==
X-Gm-Message-State: AOAM533tFbILLTksgamWps3Ekf58EXSdTvOXKbXzOcTjenRlNc9jvri0
        Mx3gMDak/VXyomTzR9bz1Uh80Vl4tAk=
X-Google-Smtp-Source: ABdhPJwT5Po3+gUb70jgaXrEPNNYP5V4Z9WmVJlEAXSbopB1f6K4SMQ4YU2U45rxmArjJv9s+UDWT2kgpUI=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f588:a708:f347:3ebb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1188:: with SMTP id
 t8mr583077qvv.51.1613091977016; Thu, 11 Feb 2021 17:06:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 Feb 2021 17:06:05 -0800
In-Reply-To: <20210212010606.1118184-1-seanjc@google.com>
Message-Id: <20210212010606.1118184-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210212010606.1118184-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [kvm-unit-tests PATCH 3/4] x86: Add a testcase for !PCID && INVPCID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an "official" testcase for a guest with PCID disabled but INVPCID
enabled, which is supported by SVM and will soon be supported by VMX.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pcid.c        | 9 +++++++--
 x86/unittests.cfg | 5 +++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/x86/pcid.c b/x86/pcid.c
index 64efd05..527a4a9 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -68,7 +68,7 @@ report:
     report(passed, "Test on PCID when disabled");
 }
 
-static void test_invpcid_enabled(void)
+static void test_invpcid_enabled(int pcid_enabled)
 {
     int passed = 0, i;
     ulong cr4 = read_cr4();
@@ -93,6 +93,10 @@ static void test_invpcid_enabled(void)
             goto report;
     }
 
+    /* Skip tests that require the PCIDE=1 if PCID isn't supported. */
+    if (!pcid_enabled)
+        goto success;
+
     if (write_cr4_checking(cr4 | X86_CR4_PCIDE) != 0)
         goto report;
 
@@ -103,6 +107,7 @@ static void test_invpcid_enabled(void)
     if (invpcid_checking(2, &desc) != 0)
         goto report;
 
+success:
     passed = 1;
 
 report:
@@ -139,7 +144,7 @@ int main(int ac, char **av)
         test_pcid_disabled();
 
     if (invpcid_enabled)
-        test_invpcid_enabled();
+        test_invpcid_enabled(pcid_enabled);
     else
         test_invpcid_disabled();
 
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index c3a4ee0..d8ef717 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -252,6 +252,11 @@ file = pcid.flat
 extra_params = -cpu qemu64,-pcid,-invpcid
 arch = x86_64
 
+[pcid-asymmetric]
+file = pcid.flat
+extra_params = -cpu qemu64,-pcid,+invpcid
+arch = x86_64
+
 [rdpru]
 file = rdpru.flat
 extra_params = -cpu max
-- 
2.30.0.478.g8a0d178c01-goog

