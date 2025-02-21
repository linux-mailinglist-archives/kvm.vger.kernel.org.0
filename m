Return-Path: <kvm+bounces-38896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D3D8A4013D
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 21:42:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04F9716F6D6
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 20:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A231253B61;
	Fri, 21 Feb 2025 20:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EmKWX55z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343BE253B5C
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 20:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740170516; cv=none; b=H85gzEfgNUtcrWq6ktBeVhAZ4Vn5b602a23n+1oP0Wly+F3KhR1VyzLNPRAcjFQ+UQto93pGWsqKxbuyCnbUQbwtAUuvvi+An4+BAj7JmIVDmNzhH+W7+44sIrsD3V8P7C5P7o9FrO7v9JbVKfsuLUjEuNQNR61JAOMNbtomMqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740170516; c=relaxed/simple;
	bh=h0UTbwCTtBcxXbN6/EMpCnpIzbGhwia3RDuw+0Bqhfk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KmBAxlz/o/g4sjTFjXNq8kNiAlnXvhnaonaDDXcA+5kLYurjFvqhKtpQUabsqb5iCSN+lYos3gqQgRzqh3LAG1dAVrzU7RhIkP9KqGym+U63Ow91l2r5fgZr9OdBEmjm+yTnH0w2b9c5S86iGnLlusLWrqt81DA6zUhaBLWPNeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EmKWX55z; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc3e239675so8248384a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 12:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740170513; x=1740775313; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kQTuI5u9xZAw8gufVySKU9ez7b76fmE34UDDGxXsSK4=;
        b=EmKWX55zBMUFbed/bSptuOI2O9YtR+MbeYUc72Ckp1QHgCQRXCwitOfAuTbuR4uG/P
         2nVcTSf0heQGFwuBpZj2jjpkeANliPUWlZDf/P6LqDwFypf7YPzZxTSfEC94Dwl1gBi9
         ymuriL9uyA5bub6dMCJn3McygGYEeM+FwHVL8WlNEwWn6jThZoBr3zODkkUYUEOnzEZJ
         0XDiCcUPYIo+I19rQjh2bwQBVwByGrhV5H23V2GdRHXuo7ikmM7Anpsa01rViInkAjMW
         UCmdFl671gqDClujf2BmNQDUVglxwXIqONMAd/DCch8sypN4nebkCaQGSJU2HdglX/TU
         snng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740170513; x=1740775313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kQTuI5u9xZAw8gufVySKU9ez7b76fmE34UDDGxXsSK4=;
        b=TTHNNSq0luaNPOteRi536SwiM8BQC9hlbA/vvFW5qGEzozWfqYqOfniyNkN61H/CxX
         tbFv5ITS+XYifarEbFhXdCSBgNK+6Z1572nQtToyoPF8HTa09OdLSURP44b8SFR6Pi3v
         +StCOlKz63rNuPhYBF/tsEksi6XV7xzkqpUtDDF2Qe3gBtu/abWnumeJTIO99Mh8/OFE
         /7H5Kd5504ZGh72ojfjijrS9L7zX/ziH+qwNaauja4IZbPJMCrbBVFo8ue7Eco0nJlii
         1FXIX1CSt2rv2lVTm3XPfseUhlu9h7lMI3hAGHcEJvpgsuyU1SA+0feW0us4qYDh2Sl5
         VE4g==
X-Gm-Message-State: AOJu0YyRoqF+y/v4tlXL2rQCQ+BmwnnMh1MWEPK7+OmcTHLCAvIyLWmY
	DMvftNSY9XZaTG/uUFdek+tFXK/iSVS9hvsTGjVRpD5Pg6lVs+V4O3ZKLHnJkYTM9abTbMNH5ld
	EcQ==
X-Google-Smtp-Source: AGHT+IE57mYJQEUmc12S3wFnaqa4+XsxBRh2RKTu6W+2Bq+uZJcK9JWokk3V2MxI4xv1leK8vDyEDOTogsA=
X-Received: from pjg16.prod.google.com ([2002:a17:90b:3f50:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:180e:b0:2ee:c91a:acf7
 with SMTP id 98e67ed59e1d1-2fce868c1d2mr6528901a91.4.1740170513511; Fri, 21
 Feb 2025 12:41:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Feb 2025 12:41:48 -0800
In-Reply-To: <20250221204148.2171418-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221204148.2171418-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250221204148.2171418-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/2] x86/debug: Add a split-lock #AC / bus-lock
 #DB testcase
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a testcase to the debug test to verify that a split-lock in the guest
does NOT result in an #AC or #DB (and that the test isn't killed).  While
KVM may run the guest with split-lock #AC enabled, KVM should never inject
an #AC into the guest.  And Bus Lock Detect/Trap should flat out never be
enabled while KVM is running the guest.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219787
Link: https://lore.kernel.org/all/bug-219787-28872@https.bugzilla.kernel.org%2F
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/debug.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/x86/debug.c b/x86/debug.c
index f493567c..09f06ef5 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -10,6 +10,7 @@
  */
 #include <asm/debugreg.h>
 
+#include "atomic.h"
 #include "libcflat.h"
 #include "processor.h"
 #include "desc.h"
@@ -81,6 +82,12 @@ static void handle_ud(struct ex_regs *regs)
 	got_ud = 1;
 }
 
+static bool got_ac;
+static void handle_ac(struct ex_regs *regs)
+{
+	got_ac = true;
+}
+
 typedef unsigned long (*db_test_fn)(void);
 typedef void (*db_report_fn)(unsigned long, const char *);
 
@@ -409,6 +416,41 @@ static noinline unsigned long singlestep_with_sti_hlt(void)
 	return start_rip;
 }
 
+static noinline uint64_t bus_lock(uint64_t magic)
+{
+	uint8_t buffer[128] __attribute__((aligned(64))) = { };
+	atomic64_t *val = (atomic64_t *)&buffer[60];
+
+	atomic64_cmpxchg(val, 0, magic);
+	return READ_ONCE(*(uint64_t *)val);
+}
+
+static void bus_lock_test(void)
+{
+	const uint64_t magic = 0xdeadbeefdeadbeefull;
+	bool bus_lock_db = false;
+	uint64_t val;
+
+	/*
+	 * Generate a bus lock (via a locked access that splits cache lines)
+	 * in CPL0 and again in CPL3 (Bus Lock Detect only affects CPL3), and
+	 * verify that no #AC or #DB is generated (the relevant features are
+	 * not enabled).
+	 */
+	val = bus_lock(magic);
+	report(!got_ac && !n && val == magic,
+	       "CPL0 Split Lock #AC = %u (#DB = %u), val = %lx (wanted %lx)",
+	       got_ac, n, val, magic);
+
+	val = run_in_user((usermode_func)bus_lock, DB_VECTOR, magic, 0, 0, 0, &bus_lock_db);
+	report(!bus_lock_db && val == magic,
+	       "CPL3 Bus Lock #DB = %u, val = %lx (wanted %lx)",
+	       bus_lock_db, val, magic);
+
+	n = 0;
+	got_ac = false;
+}
+
 int main(int ac, char **av)
 {
 	unsigned long cr4;
@@ -416,6 +458,9 @@ int main(int ac, char **av)
 	handle_exception(DB_VECTOR, handle_db);
 	handle_exception(BP_VECTOR, handle_bp);
 	handle_exception(UD_VECTOR, handle_ud);
+	handle_exception(AC_VECTOR, handle_ac);
+
+	bus_lock_test();
 
 	/*
 	 * DR4 is an alias for DR6 (and DR5 aliases DR7) if CR4.DE is NOT set,
-- 
2.48.1.601.g30ceb7b040-goog


