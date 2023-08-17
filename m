Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909E97801B2
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 01:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356095AbjHQXep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 19:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356094AbjHQXej (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 19:34:39 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7C830C6
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:34:38 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5646e695ec1so544077a12.1
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692315278; x=1692920078;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YpFMVDLsowSmpGWrptrxFQAXS4ajKEvJ2WJs4xhDDoI=;
        b=YhhQT8Lv8ANNNhYui/aJrAkfGeBj2c/dOfAdg2WRXptW2ITBe5CyUtscAkjyj2fxc4
         7bNfYQ8NEIH/nUt83jDhbSYtDgCVvw9zMSNVaPwUXjJsD0r4pF4Lk0wMB0XgABSejUh0
         4n0bFDToRA6Dz1vKaq6xm/ZKkznSnA5I597y4MUymv8nAlYP0eWunOfKpGrpXYTCHSiD
         QYE6m3jofRj++In4Kai4b0FqvGnItsyjlac6xBZo1d/JWba4ZWfCdn9EThyQH7MAjmnb
         jIc2ILIA3EDtcIK/n56lRDj0yO7N3tnwPgeJDcofjjg/A8vmTALZFXVz3YV/8QGR8m1B
         WHmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692315278; x=1692920078;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YpFMVDLsowSmpGWrptrxFQAXS4ajKEvJ2WJs4xhDDoI=;
        b=MOweoPLCccyrZyDleRLS6vGM0rFZ/T2eRFV5+RKTAtqikVXAVXGUtUu0FXcaUaTvM7
         7CF17MkiIqct+3qBoQtAATmLn8wP8gLpIk/XcozVaY6mjd1UKsbZqxKzSZ73LNLgJNGp
         /YPrz/1IYQDk7Pd4f4l0o7xbHLWRiwgPPrGFTWrQXuzqRXBdWWnsVj1Ycp2KdWVFqVgs
         02CSuRWKmCniUE8z2EHLTItn7/tEpz8TkYDIXjVTEJQXI47U4d0qO2YRBcKvHyBWAUTK
         HDxavuB3PEQUJP7VtfK4VoPecCj+TJLUnCX0zmZSfH5Bnmdx3v6Id1AJKMTHugxxjkBx
         tf5A==
X-Gm-Message-State: AOJu0YyLfD7Lx8VVvkow1a4Tq8tlv5T7MiYsO8glLECSj1fDBI3AXqP0
        84E6V3h5HVuVdyWRjGebAU/u6N8KZwE=
X-Google-Smtp-Source: AGHT+IEa+4IbiOaMkbL+znRevOCe3T15GMNjBwaL4EWX4Nf/t8zYxIVwGhKwNoi2vZANROkAJu/VIv8ow3s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:715b:0:b0:567:c791:ce64 with SMTP id
 b27-20020a63715b000000b00567c791ce64mr122102pgn.8.1692315277840; Thu, 17 Aug
 2023 16:34:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 17 Aug 2023 16:34:30 -0700
In-Reply-To: <20230817233430.1416463-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230817233430.1416463-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230817233430.1416463-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: selftests: Explicit set #UD when *potentially*
 injecting exception
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly set the exception vector to #UD when potentially injecting an
exception in sync_regs_test's subtests that try to detect TOCTOU bugs
in KVM's handling of exceptions injected by userspace.  A side effect of
the original KVM bug was that KVM would clear the vector, but relying on
KVM to clear the vector (i.e. make it #DE) makes it less likely that the
test would ever find *new* KVM bugs, e.g. because only the first iteration
would run with a legal vector to start.

Explicitly inject #UD for race_events_inj_pen() as well, e.g. so that it
doesn't inherit the illegal 255 vector from race_events_exc(), which
currently runs first.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/sync_regs_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index 21e99dae2ff2..00965ba33f73 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -91,6 +91,8 @@ static void *race_events_inj_pen(void *arg)
 	struct kvm_run *run = (struct kvm_run *)arg;
 	struct kvm_vcpu_events *events = &run->s.regs.events;
 
+	WRITE_ONCE(events->exception.nr, UD_VECTOR);
+
 	for (;;) {
 		WRITE_ONCE(run->kvm_dirty_regs, KVM_SYNC_X86_EVENTS);
 		WRITE_ONCE(events->flags, 0);
@@ -115,6 +117,7 @@ static void *race_events_exc(void *arg)
 	for (;;) {
 		WRITE_ONCE(run->kvm_dirty_regs, KVM_SYNC_X86_EVENTS);
 		WRITE_ONCE(events->flags, 0);
+		WRITE_ONCE(events->exception.nr, UD_VECTOR);
 		WRITE_ONCE(events->exception.pending, 1);
 		WRITE_ONCE(events->exception.nr, 255);
 
-- 
2.42.0.rc1.204.g551eb34607-goog

