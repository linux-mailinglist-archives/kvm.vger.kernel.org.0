Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4DCD124F63
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 18:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfLRRdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 12:33:11 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55124 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfLRRdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 12:33:10 -0500
Received: by mail-wm1-f65.google.com with SMTP id b19so2705562wmj.4
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 09:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EmdiTCSW+qdLJ/ySNcC4RyYfPANbZi6YQbRb8xQ8Z9k=;
        b=IN7ZaFQKqm+QJkmujj6Eyh8YgFEWNfI28U/PzJSYn2XoC/H5LVlsKVR5YuzerCHLCM
         AQAGtqdFAANK0EvvHoOj+3LJLbTkC2/zbHm29N11eqkjgGma3tCkl6wAnymLGw8RPeCb
         WmXvFvUei0rdolwayKXKwzyfLIWfmDEPSdUu7/FCbyqeLLfz637ISmSgMBBwuKRx4wQX
         oEQhheGMxkRylC9owL9uu7tynVXI0pP1nmrGeBePj0qm11ThQCE+7QU/gdeLoSU+WXYP
         YP6l93XYQp4oDac9DHjevtT3gWsv4yZnUsx5xmLVI7ZmOX0WNBCgaVgMRKFoWEOeian7
         J8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=EmdiTCSW+qdLJ/ySNcC4RyYfPANbZi6YQbRb8xQ8Z9k=;
        b=j1g27t/H2VCXl6iIaoi4k/3J6onS9brCLnnhFe3AbRQLh6iPSStR4OcTHVJFMCqwMt
         2hQNucfpmZT34J6wsFrwEpDB5RG2RyawJWWQ1aVCPrgUaoop7H4RohrcKJkmv8JQUV7p
         TcqrpucwHheGWgOUTQY6Iq1PUA5t2WSF4Q2hIRdTnWWN7X4oklajxKdDOAMBIMJAtgB1
         0WJv0wg+/cUKd8T/rIpnHWdCnkPwOj6O0D2Nb/IiG55dhns1pqEDjmsHVlWm/ytnaU9m
         YCJD2bvFqNDJvoi05BQEhQLz2UH6J/LXUNoVzohFpqhXKe3gcvnTKKUNGE0bRtQovQrG
         KMdQ==
X-Gm-Message-State: APjAAAUWFHcVwUsdKads0uZHsulYY4s01/GQjcHplV1Vir/xd/DdTygu
        UMmYCa6cjNBL4BZKZWpuLcDVmbRS
X-Google-Smtp-Source: APXvYqzUzPy0ZLI43KNS+s1BkT58j8fkpfLRnQpI7H3/oqkqFxh9MsPDaF3cS/yFtcVr07EBB7xcMg==
X-Received: by 2002:a1c:a513:: with SMTP id o19mr4298785wme.156.1576690387890;
        Wed, 18 Dec 2019 09:33:07 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id u22sm3411362wru.30.2019.12.18.09.33.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 09:33:07 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     cavery@redhat.com
Subject: [PATCH kvm-unit-tests 2/2] svm: replace set_host_if with prepare_gif_clear callback
Date:   Wed, 18 Dec 2019 18:33:03 +0100
Message-Id: <1576690383-16170-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576690383-16170-1-git-send-email-pbonzini@redhat.com>
References: <1576690383-16170-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of setting a flag in the prepare callback, override the
default value of the host IF flag in the prepare_gif_clear
callback.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 63fda65..2cbd9fd 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -44,8 +44,6 @@ u64 runs;
 u8 *io_bitmap;
 u8 io_bitmap_area[16384];
 
-u8 set_host_if;
-
 #define MSR_BITMAP_SIZE 8192
 
 u8 *msr_bitmap;
@@ -261,7 +259,6 @@ static void test_run(struct test *test, struct vmcb *vmcb)
 
     irq_disable();
     test->vmcb = vmcb;
-    set_host_if = 1;
     test->prepare(test);
     vmcb->save.rip = (ulong)test_thunk;
     vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
@@ -325,8 +322,6 @@ static void default_prepare(struct test *test)
 
 static void default_prepare_gif_clear(struct test *test)
 {
-    if (!set_host_if)
-        asm("cli");
 }
 
 static bool default_finished(struct test *test)
@@ -1412,8 +1407,6 @@ static void pending_event_prepare_vmask(struct test *test)
 
     pending_event_ipi_fired = false;
 
-    set_host_if = 0;
-
     handle_irq(0xf1, pending_event_ipi_isr);
 
     apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
@@ -1422,6 +1415,11 @@ static void pending_event_prepare_vmask(struct test *test)
     set_test_stage(test, 0);
 }
 
+static void pending_event_prepare_gif_clear_vmask(struct test *test)
+{
+    asm("cli");
+}
+
 static void pending_event_test_vmask(struct test *test)
 {
     if (pending_event_ipi_fired == true) {
@@ -1575,7 +1573,7 @@ static struct test tests[] = {
       default_prepare_gif_clear,
       pending_event_test, pending_event_finished, pending_event_check },
     { "pending_event_vmask", default_supported, pending_event_prepare_vmask,
-      default_prepare_gif_clear,
+      pending_event_prepare_gif_clear_vmask,
       pending_event_test_vmask, pending_event_finished_vmask,
       pending_event_check_vmask },
 };
-- 
1.8.3.1

