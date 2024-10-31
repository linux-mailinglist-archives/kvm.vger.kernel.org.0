Return-Path: <kvm+bounces-30184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 352909B7CBF
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:22:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE837281771
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 14:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11BBB1A3056;
	Thu, 31 Oct 2024 14:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="imO88o/y";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="TC7Bdeih";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="z4inUp5d";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="QTvKxQNY"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD3D1A0718;
	Thu, 31 Oct 2024 14:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730384529; cv=none; b=qekfN0s1JzDBV/6v/46OTx3M2rjrCGmOcib7Mv3DjCzbOGxdj6n05WA7HFSzGQ2T2DhW6Hc1BwtnS/1WUWAk0QMxKBefCyGc0BLjUPD5b75W+SZ1MWQmVHjZcG+nSOgWnqM/5WCNakYwzi+/T983w8BWzFyTBXahgPpXNJqOELw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730384529; c=relaxed/simple;
	bh=etgE3izXSiLkddyBtcyglLIYMWGizE5LD0WpiyyVMco=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=eSkEk3BQGH1y2IYdl/+TNxuRLGgV0g93cyvzYZVSDJ6BZ5tPc5idd9U4Iker0bL2lv7SX9QEb75OUlcEgBSjYsTFDGLMSVJBNpdAz8C7QjqqdkDddvMMujSguyPKLlvAoTaZIkaqnPvVAAsarxwa88P0eAhFEtBl/E06jWyj9DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=imO88o/y; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=TC7Bdeih; dkim=fail (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=z4inUp5d reason="signature verification failed"; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=QTvKxQNY; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1730384517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R7vOaJqgRV5DMd7ehGld0+MjD00sARx0fKoxOtfItm0=;
	b=imO88o/y0XVN6kdToHVMViXMRUk0cuBXo74W1Q/jLdQS/fSyb1mE7rrdtKszHKYJk4mwYp
	xKB+HTzDiMLGMAxmvOoIs7Ezq4wqzxY1joPy06QGqDGS5h7IB8pY+fd14FIiiyHPQQ5jEn
	+kRqynflD+2Ki0AJZrm+cNSeOEaEze0NeVw648ZZiWTmO0HAzpCVYzASbwd46rJUM1PVrJ
	0/bRrtPWJc7bBQreuSKLFPsxY0OhyNO970EbplqzVKMSK48Ba4yAcvOA3z38CdpBGWUCEQ
	lqkMLP3Z19n46zpXzDCbPy6/4soTeTE6dYIWW9WYElSdV6p3ah/Nt8iDooqOfA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1730384517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R7vOaJqgRV5DMd7ehGld0+MjD00sARx0fKoxOtfItm0=;
	b=TC7BdeihIW5XV4aaoNEyVInfQhW2BG0q5+AS3lEUVFct/hE3jLvzM9jDENqQh2vbJLNYxl
	itaDDCS2WULo9dBw==
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org
Cc: Nam Cao <namcao@linutronix.de>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	intel-gfx@lists.freedesktop.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Kalle Valo <kvalo@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	John Stultz <jstultz@google.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 00/19] hrtimers: Consolidate hrtimer initialization - Part 1
Date: Thu, 31 Oct 2024 15:19:21 +0100
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de; s=2020; t=1730357378; h=from:from:reply-to:subject:subject:date:date:message-id:message-id: to:to:cc:cc:mime-version:mime-version:content-type:content-type: content-transfer-encoding:content-transfer-encoding; bh=I8wtw/HtQVPpoZ+xdIpGlIz4pHbw619bvfWfK0qjbEY=; b=z4inUp5dIlviaMA0ilIMg1r3Wg887s0wq70vQLQA4h+YYh09sTCrh/tTQ4396QwOvDdZ0e SKqjs5VdfgBd3k0qMBTJwcQWS1Hj5itUE4MzYV/Ymvzsp6QL8X31rtZr8sb8moFlqNDrir mbDJy2IDYSvFmqx/Lp9lEPpFO6ojydIxSG3GuikuFHKGnp/ZwOrZeoaq/shuHp2UGI79Z8 ceHQIIleDz2XCwQN3O37mDeI9q+mr7IWzQfmlhwBj2S5txfA22eDQMQ3jXi6jqaRetvejj SdX18VKh74Qu6DnDsZhYnK5HywFvgjbqI1TwCQK0ZbYwHO7NP7VvbHFDTxV/cg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de; s=2020e; t=1730357378; h=from:from:reply-to:subject:subject:date:date:message-id:message-id: to:to:cc:cc:mime-version:mime-version:content-type:content-type: content-transfer-encoding:content-transfer-encoding; bh=I8wtw/HtQVPpoZ+xdIpGlIz4pHbw619bvfWfK0qjbEY=; b=QTvKxQNY73n06PZINa661hFYsJRXgyOH6WpwJevcy1LruABl4pbMeCJknE4R2b8wI1Hdlp XEyP0ZdHqKWlkMAw==
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20241029-hrtimer_setup_p1_v2-0396321bee07
Status: RO
Lines: 89
Content-Transfer-Encoding: quoted-printable

This is a follow up to version 1, which can be found here:

    https://lore.kernel.org/lkml/cover.1729864615.git.namcao@linutronix.de/

hrtimers must be initialized with a hrtimer_init() variant, and after that
the timer's callback function must be setup separately.

This seperate initialization is error prone and awkward to use. The
seperate initialization is also problematic for a clean Rust abstraction.

A combined setup function like timer_setup() is less error prone and
simpler to use.

This first part of the conversion provides:

  - a set of hrtimer_setup*() variants, which take the function pointer as
    argument.

  - hrtimer_update_function() which allows to change the callback function
    after initialization with the proper safety checks in place.

  - conversion of the hrtimer_init*_on_stack() variants

  - some minor cleanups

The remaining users will be converted in follow up series.

Most conversions were done with Coccinelle. See sematic patch below.

Changes versus v1:
  - Open code kvm_xen_init_vcpu() (Sean)
  - Drop the can/bcm patch (Oliver)
  - Folded the removal of hrtimer_init_sleeper() (tglx)
  - Update change logs and cover letter

The series applies on top of:

    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core

and is also available from git:

    git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git hrtimer-se=
tup-part1-v2

Best regards,

Nam

---
virtual patch
@@ expression timer, clock, mode, func; @@
- hrtimer_init(timer, clock, mode);
  ...
- timer->function =3D func;
+ hrtimer_setup(timer, func, clock, mode);

@@ expression timer, clock, mode, func; @@
- hrtimer_init(&timer, clock, mode);
  ...
- timer.function =3D func;
+ hrtimer_setup(&timer, func, clock, mode);

@@ expression timer, clock, mode, func; @@
- hrtimer_init_on_stack(&timer, clock, mode);
  ...
- timer.function =3D func;
+ hrtimer_setup_on_stack(&timer, func, clock, mode);

@@ expression timer, clock, mode; @@
- hrtimer_init_sleeper_on_stack(timer, clock, mode);
+ hrtimer_setup_sleeper_on_stack(timer, clock, mode);

---
 arch/x86/kvm/xen.c                             |  12 +--
 drivers/gpu/drm/i915/i915_request.c            |  17 ++--
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c |   2 -
 fs/aio.c                                       |   2 +-
 include/linux/hrtimer.h                        |  51 +++++++-----
 include/linux/wait.h                           |   4 +-
 io_uring/io_uring.c                            |   7 +-
 io_uring/timeout.c                             |   1 -
 kernel/futex/core.c                            |   6 +-
 kernel/sched/idle.c                            |   4 +-
 kernel/time/alarmtimer.c                       |   9 +-
 kernel/time/hrtimer.c                          | 110 ++++++++++++++++++---=
----
 kernel/time/sleep_timeout.c                    |   2 +-
 net/core/pktgen.c                              |   2 +-
 14 files changed, 136 insertions(+), 93 deletions(-)
---
base-commit: 875cf0b1f0eb4fcd9007a0ac0891125d2ce9766b


From namcao@linutronix.de Thu Oct 31 07:49:39 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id 4DQ6C4MoI2cuEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:39 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357379;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DSlWulzgnMEFh94QnWgZOC3I74EHL27xJhw0Iun1RM+E=3D;
	b=3DpOzt0e+Oz6noqitNHk3WKiQL1mwQoPhrKkrRkHSGNyT6bzDGbPTlXcrjE4Jy7F9e7lRV7I
	E8Hhu7hVAtLq4S0ORRjVlynGmHRCP/yPnR1r1tpY/VAAonxY0HkTSOBPmaoTp3r6v9rbzP
	f5vXlvZSsNPLMriNPgjm7et93OVk1mBxwVQFazaIANbmIdK0B22f9oBeBEC7oXUJ1l38F6
	0J3eXt8ZJihIL4+R6i+mLKhpNjKYd6oQ0x39Shyp+sO7GBxc1cm/VYbt8KcdfxAaEN5+Wm
	Ct8AEV2wMXL5Tyy9qOnoVQOiXmay9QTg+cfnHnhiglI3e+0UH7hx51npbA4ICw=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357379;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DSlWulzgnMEFh94QnWgZOC3I74EHL27xJhw0Iun1RM+E=3D;
	b=3DkkrvwcWFuoGuMm0lpq9mhWZsxY3tJ1zyo6GyzkRrN51jPYWfs/IMmidfmZYn20y/cbvluA
	Ytc6J2O1mB4XxdDw=3D=3D
Date: Thu, 31 Oct 2024 06:49:24 +0000
Subject: [PATCH v2 01/19] hrtimers: Add missing hrtimer_init() trace points
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-1-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 6512
Lines: 179

hrtimer_init*_on_stack() is not covered by tracing when
CONFIG_DEBUG_OBJECTS_TIMERS=3Dy.

Rework the functions similar to hrtimer_init() and hrtimer_init_sleeper()
so that the hrtimer_init() tracepoint is unconditionally available.

The rework makes hrtimer_init_sleeper() unused. Delete it.

Signed-off-by: Nam Cao <namcao@linutronix.de>
---
 include/linux/hrtimer.h | 19 +--------------
 kernel/time/hrtimer.c   | 65 +++++++++++++++++++++++++++------------------=
----
 2 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index aa1e65ccb6158414fed519c984e8b0ca8dc11dcf..5aa9d57528c4b691defbd99e66d=
200cca18a2dd6 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -228,32 +228,15 @@ static inline void hrtimer_cancel_wait_running(struct=
 hrtimer *timer)
 /* Initialize timers: */
 extern void hrtimer_init(struct hrtimer *timer, clockid_t which_clock,
 			 enum hrtimer_mode mode);
-extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, clockid_t clo=
ck_id,
-				 enum hrtimer_mode mode);
-
-#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
 extern void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t which_c=
lock,
 				  enum hrtimer_mode mode);
 extern void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *sl,
 					  clockid_t clock_id,
 					  enum hrtimer_mode mode);
=20
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
 extern void destroy_hrtimer_on_stack(struct hrtimer *timer);
 #else
-static inline void hrtimer_init_on_stack(struct hrtimer *timer,
-					 clockid_t which_clock,
-					 enum hrtimer_mode mode)
-{
-	hrtimer_init(timer, which_clock, mode);
-}
-
-static inline void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *s=
l,
-						 clockid_t clock_id,
-						 enum hrtimer_mode mode)
-{
-	hrtimer_init_sleeper(sl, clock_id, mode);
-}
-
 static inline void destroy_hrtimer_on_stack(struct hrtimer *timer) { }
 #endif
=20
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 04f7d8a392c3979504a42c2a907d06ba3b55e13a..4b0507cf38ea07dccc40dd67e65=
1fd40e5adfef7 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -417,6 +417,11 @@ static inline void debug_hrtimer_init(struct hrtimer *=
timer)
 	debug_object_init(timer, &hrtimer_debug_descr);
 }
=20
+static inline void debug_hrtimer_init_on_stack(struct hrtimer *timer)
+{
+	debug_object_init_on_stack(timer, &hrtimer_debug_descr);
+}
+
 static inline void debug_hrtimer_activate(struct hrtimer *timer,
 					  enum hrtimer_mode mode)
 {
@@ -428,28 +433,6 @@ static inline void debug_hrtimer_deactivate(struct hrt=
imer *timer)
 	debug_object_deactivate(timer, &hrtimer_debug_descr);
 }
=20
-static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
-			   enum hrtimer_mode mode);
-
-void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t clock_id,
-			   enum hrtimer_mode mode)
-{
-	debug_object_init_on_stack(timer, &hrtimer_debug_descr);
-	__hrtimer_init(timer, clock_id, mode);
-}
-EXPORT_SYMBOL_GPL(hrtimer_init_on_stack);
-
-static void __hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
-				   clockid_t clock_id, enum hrtimer_mode mode);
-
-void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *sl,
-				   clockid_t clock_id, enum hrtimer_mode mode)
-{
-	debug_object_init_on_stack(&sl->timer, &hrtimer_debug_descr);
-	__hrtimer_init_sleeper(sl, clock_id, mode);
-}
-EXPORT_SYMBOL_GPL(hrtimer_init_sleeper_on_stack);
-
 void destroy_hrtimer_on_stack(struct hrtimer *timer)
 {
 	debug_object_free(timer, &hrtimer_debug_descr);
@@ -459,6 +442,7 @@ EXPORT_SYMBOL_GPL(destroy_hrtimer_on_stack);
 #else
=20
 static inline void debug_hrtimer_init(struct hrtimer *timer) { }
+static inline void debug_hrtimer_init_on_stack(struct hrtimer *timer) { }
 static inline void debug_hrtimer_activate(struct hrtimer *timer,
 					  enum hrtimer_mode mode) { }
 static inline void debug_hrtimer_deactivate(struct hrtimer *timer) { }
@@ -472,6 +456,13 @@ debug_init(struct hrtimer *timer, clockid_t clockid,
 	trace_hrtimer_init(timer, clockid, mode);
 }
=20
+static inline void debug_init_on_stack(struct hrtimer *timer, clockid_t cl=
ockid,
+				       enum hrtimer_mode mode)
+{
+	debug_hrtimer_init_on_stack(timer);
+	trace_hrtimer_init(timer, clockid, mode);
+}
+
 static inline void debug_activate(struct hrtimer *timer,
 				  enum hrtimer_mode mode)
 {
@@ -1600,6 +1591,23 @@ void hrtimer_init(struct hrtimer *timer, clockid_t c=
lock_id,
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
=20
+/**
+ * hrtimer_init_on_stack - initialize a timer in stack memory
+ * @timer:	The timer to be initialized
+ * @clock_id:	The clock to be used
+ * @mode:       The timer mode
+ *
+ * Similar to hrtimer_init(), except that this one must be used if struct =
hrtimer is in stack
+ * memory.
+ */
+void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t clock_id,
+			   enum hrtimer_mode mode)
+{
+	debug_init_on_stack(timer, clock_id, mode);
+	__hrtimer_init(timer, clock_id, mode);
+}
+EXPORT_SYMBOL_GPL(hrtimer_init_on_stack);
+
 /*
  * A timer is active, when it is enqueued into the rbtree or the
  * callback function is running or it's in the state of being migrated
@@ -1944,7 +1952,7 @@ void hrtimer_sleeper_start_expires(struct hrtimer_sle=
eper *sl,
 	 * Make the enqueue delivery mode check work on RT. If the sleeper
 	 * was initialized for hard interrupt delivery, force the mode bit.
 	 * This is a special case for hrtimer_sleepers because
-	 * hrtimer_init_sleeper() determines the delivery mode on RT so the
+	 * __hrtimer_init_sleeper() determines the delivery mode on RT so the
 	 * fiddling with this decision is avoided at the call sites.
 	 */
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && sl->timer.is_hard)
@@ -1987,19 +1995,18 @@ static void __hrtimer_init_sleeper(struct hrtimer_s=
leeper *sl,
 }
=20
 /**
- * hrtimer_init_sleeper - initialize sleeper to the given clock
+ * hrtimer_init_sleeper_on_stack - initialize a sleeper in stack memory
  * @sl:		sleeper to be initialized
  * @clock_id:	the clock to be used
  * @mode:	timer mode abs/rel
  */
-void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, clockid_t clock_id,
-			  enum hrtimer_mode mode)
+void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *sl,
+				   clockid_t clock_id, enum hrtimer_mode mode)
 {
-	debug_init(&sl->timer, clock_id, mode);
+	debug_init_on_stack(&sl->timer, clock_id, mode);
 	__hrtimer_init_sleeper(sl, clock_id, mode);
-
 }
-EXPORT_SYMBOL_GPL(hrtimer_init_sleeper);
+EXPORT_SYMBOL_GPL(hrtimer_init_sleeper_on_stack);
=20
 int nanosleep_copyout(struct restart_block *restart, struct timespec64 *ts)
 {

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:39 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id iNuiF4MoI2cwEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:39 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357379;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3D7o6iz9WZPOSmxfH4/hB47mM++q620ntmdDoeyZiVTqQ=3D;
	b=3Dee/2ULxU8zXOadI31irSpt9ECkgDttc+1vIIJksMWhKjoopu9rU3AVBtAWwaiE6n+zMYwH
	iU22bTKpBeB9WuVMVV2QyEpFF18e1WImJRBe57j9MNATFn8fUaTWwk46hdyGmTcv8rlA//
	yOWhnlAfoLkl6CWyIDFSm/cUSnWSHnmcFyJMBooXmGAmqouB/dmy5uzJ2gtdvE3d8PS1+S
	Rqeq1mnUfBOKOKIl8BTPQqO0t6Y+5CHgO4Aktzw1zHjguTfXCBgDiYHWwWFR+VDHTL4YC2
	/5oHX9rEWtOdvU6HhuHcgOLbuziP1/CuHbhN824/l3l35XesbJTfzFU6ph5uVA=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357379;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3D7o6iz9WZPOSmxfH4/hB47mM++q620ntmdDoeyZiVTqQ=3D;
	b=3DoQnS96gO8UFgPFDfLVRUhPzsSHvxbdV3QPUcXiJLHpU2Z/pcJbf3D4zCcflU1PpDo59r2/
	vi+cJRJcnaw7RYAw=3D=3D
Date: Thu, 31 Oct 2024 06:49:25 +0000
Subject: [PATCH v2 02/19] drm/i915/request: Remove unnecessary modification
 of hrtimer::function
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-2-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 2694
Lines: 76

When a request is created, the hrtimer is not initialized and only its
'function' field is set to NULL. The hrtimer is only initialized when the
request is enqueued. The point of setting 'function' to NULL is that, it
can be used to check whether hrtimer_try_to_cancel() should be called while
retiring the request.

This "trick" is unnecessary, because hrtimer_try_to_cancel() already does
its own check whether the timer is armed. If the timer is not armed,
hrtimer_try_to_cancel() returns 0.

Fully initialize the timer when the request is created, which allows to
make the hrtimer::function field private once all users of hrtimer_init()
are converted to hrtimer_setup(), which requires a valid callback function
to be set.

Because hrtimer_try_to_cancel() returns 0 if the timer is not armed, the
logic to check whether to call i915_request_put() remains equivalent.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
---
 drivers/gpu/drm/i915/i915_request.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i91=
5_request.c
index 519e096c607cd8b1943dbc8e5bff14ccf48822db..8f62cfa23fb768bbaac58955186=
8a2749f8c7e79 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -273,11 +273,6 @@ i915_request_active_engine(struct i915_request *rq,
 	return ret;
 }
=20
-static void __rq_init_watchdog(struct i915_request *rq)
-{
-	rq->watchdog.timer.function =3D NULL;
-}
-
 static enum hrtimer_restart __rq_watchdog_expired(struct hrtimer *hrtimer)
 {
 	struct i915_request *rq =3D
@@ -294,6 +289,14 @@ static enum hrtimer_restart __rq_watchdog_expired(stru=
ct hrtimer *hrtimer)
 	return HRTIMER_NORESTART;
 }
=20
+static void __rq_init_watchdog(struct i915_request *rq)
+{
+	struct i915_request_watchdog *wdg =3D &rq->watchdog;
+
+	hrtimer_init(&wdg->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	wdg->timer.function =3D __rq_watchdog_expired;
+}
+
 static void __rq_arm_watchdog(struct i915_request *rq)
 {
 	struct i915_request_watchdog *wdg =3D &rq->watchdog;
@@ -304,8 +307,6 @@ static void __rq_arm_watchdog(struct i915_request *rq)
=20
 	i915_request_get(rq);
=20
-	hrtimer_init(&wdg->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	wdg->timer.function =3D __rq_watchdog_expired;
 	hrtimer_start_range_ns(&wdg->timer,
 			       ns_to_ktime(ce->watchdog.timeout_us *
 					   NSEC_PER_USEC),
@@ -317,7 +318,7 @@ static void __rq_cancel_watchdog(struct i915_request *r=
q)
 {
 	struct i915_request_watchdog *wdg =3D &rq->watchdog;
=20
-	if (wdg->timer.function && hrtimer_try_to_cancel(&wdg->timer) > 0)
+	if (hrtimer_try_to_cancel(&wdg->timer) > 0)
 		i915_request_put(rq);
 }
=20

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:39 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id a2JAIIMoI2dDEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:39 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357379;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DsZl3RkO/dCw6pWs/KFGEaEj4mICdMH2sXunBd/7ALZ8=3D;
	b=3DoOB4VNG0xqH+TthUxEZ8gbXzrPVyesC4izzlYW/mp8pjMd2rt1Dgue4H015/ydfGns6cwV
	hjif7kAmMh7Q+I1K/1LKQVDLJWPZ6pDfYr6y1ZE+5jduWn07FUF7RyxLIyoWqVa5eveSte
	Y3jOU9H0FuKsweSK65/t+mmcGqWwiAkWwujoMZuCIfIe/fVAdRwR6Wi6OC7ec8zMQqKlzU
	PyFh0GQ2ixkQcFkmOAPHCCmDw7We4nZwcVU+RYKcSNboBgRoNfeyS93gwAPdciyOR6koWQ
	UoOeRfl9v/CQhZ76tssPtczuxoqI2dHawG1O/qSOMSNPJl+7bsju6xgYRLwROg=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357379;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DsZl3RkO/dCw6pWs/KFGEaEj4mICdMH2sXunBd/7ALZ8=3D;
	b=3DWIRg7jdNKDvN2c17LwRqwRTL8B8IGL10ssbPKdNExa/Et8MpbzkDcAfSUaEwA+lPOnhxX1
	AioNoqQUYRNaUlBw=3D=3D
Date: Thu, 31 Oct 2024 06:49:26 +0000
Subject: [PATCH v2 03/19] KVM: x86/xen: Initialize hrtimer in
 kvm_xen_init_vcpu()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-3-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 2250
Lines: 61

The hrtimer is initialized in the KVM_XEN_VCPU_SET_ATTR ioctl. That caused
problem in the past, because the hrtimer can be initialized multiple times,
which was fixed by commit af735db31285 ("KVM: x86/xen: Initialize Xen timer
only once"). This commit avoids initializing the timer multiple times by
checking the field 'function' of struct hrtimer to determine if it has
already been initialized.

This is not required and in the way to make the function field private.

Move the hrtimer initialization into kvm_xen_init_vcpu() so that it will
only be initialized once.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Acked-by: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
---
v2: drop kvm_xen_init_timer() and open code its content
---
 arch/x86/kvm/xen.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 622fe24da910646ced4300a84ab92fce4ac8e00a..a909b817b9c0da1714169d937c1=
35474e8a9cf7d 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -263,13 +263,6 @@ static void kvm_xen_stop_timer(struct kvm_vcpu *vcpu)
 	atomic_set(&vcpu->arch.xen.timer_pending, 0);
 }
=20
-static void kvm_xen_init_timer(struct kvm_vcpu *vcpu)
-{
-	hrtimer_init(&vcpu->arch.xen.timer, CLOCK_MONOTONIC,
-		     HRTIMER_MODE_ABS_HARD);
-	vcpu->arch.xen.timer.function =3D xen_timer_callback;
-}
-
 static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 {
 	struct kvm_vcpu_xen *vx =3D &v->arch.xen;
@@ -1070,9 +1063,6 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, stru=
ct kvm_xen_vcpu_attr *data)
 			break;
 		}
=20
-		if (!vcpu->arch.xen.timer.function)
-			kvm_xen_init_timer(vcpu);
-
 		/* Stop the timer (if it's running) before changing the vector */
 		kvm_xen_stop_timer(vcpu);
 		vcpu->arch.xen.timer_virq =3D data->u.timer.port;
@@ -2235,6 +2225,8 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 	vcpu->arch.xen.poll_evtchn =3D 0;
=20
 	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
+	hrtimer_init(&vcpu->arch.xen.timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HAR=
D);
+	vcpu->arch.xen.timer.function =3D xen_timer_callback;
=20
 	kvm_gpc_init(&vcpu->arch.xen.runstate_cache, vcpu->kvm);
 	kvm_gpc_init(&vcpu->arch.xen.runstate2_cache, vcpu->kvm);

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:39 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id gMNcKIMoI2cuEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:39 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357379;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DqxetqWETKPRS/EosOKw7DR7D7Elqj1yonxarUw92zuI=3D;
	b=3Dn9jTzaHwuO+cWLQ2V9h9syWzhES+vpNPoxjLcC0KKBeQVND7hm4FaMVk07N6nN9Olg9v+K
	r+hcGNXjIB9qxhYJ1nuqDs9Imvvg4o+Q7tmzm/MjR930+F9Dx8sauRpzuIGJ6jLxiUpsV+
	c0kw4UyxXFpVQX+O93rPB2a1jP2bWq39jShjN0Fh/i6aCQ0fWy+FU50p6iMgUXcR+JmiGo
	5oL5HcOTLqEqlKvgFMcovmIpeph6JGIEI+hK35ukUcmAcFLROcZ+eZ/DxRs6mHJKjNU/xB
	sscd7qLU+LAAN8txnQXS04IIqDL3P188neHACZCPeTn8730GFO+FIzFByJU5fw=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357379;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DqxetqWETKPRS/EosOKw7DR7D7Elqj1yonxarUw92zuI=3D;
	b=3DGEEli77n25Ra3B1bBasav1g/B8SQIQQIjdJYa6EQ4xInnAa4uAkV9zZaHXnTDr5uh12xry
	EBBj4J91a2zVWYBg=3D=3D
Date: Thu, 31 Oct 2024 06:49:27 +0000
Subject: [PATCH v2 04/19] wifi: rt2x00: Remove redundant hrtimer_init()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-4-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 1044
Lines: 28

rt2x00usb_probe() executes a hrtimer_init() for txstatus_timer. Afterwards,
rt2x00lib_probe_dev() is called which also initializes this txstatus_timer
with the same settings.

Remove the redundant hrtimer_init() call in rt2x00usb_probe().

Signed-off-by: Nam Cao <namcao@linutronix.de>
Acked-by: Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/w=
ireless/ralink/rt2x00/rt2x00usb.c
index 8fd22c69855fa463c1a794eb26368a5fc4aa5696..a6d50149e0c3eb4f379f1964986=
d102c7e6ca659 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -823,8 +823,6 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
=20
 	INIT_WORK(&rt2x00dev->rxdone_work, rt2x00usb_work_rxdone);
 	INIT_WORK(&rt2x00dev->txdone_work, rt2x00usb_work_txdone);
-	hrtimer_init(&rt2x00dev->txstatus_timer, CLOCK_MONOTONIC,
-		     HRTIMER_MODE_REL);
=20
 	retval =3D rt2x00usb_alloc_reg(rt2x00dev);
 	if (retval)

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:40 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id fngmNIMoI2dFEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:39 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357379;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DekeK5Vx/mEvxlQz/WIkRnnnDrgTBFmkjwLIFiYmCI/o=3D;
	b=3DvToVyyWaB7Z8DjFqxAadYUvRNeB/UY7hRO4Oa0D5oDEACX5fNmMZwqMVXo+D0albFjLSH0
	agEOLoF1OjrzXM8ETgXaivRSsqdDETu0xlUM+ryJVsS2yB4I4yUHbCvJTAxd7lDi5BvrA+
	Stgv7KdTTuk50rsRkWVSrHLaktDeJi00bP48Y0z9nSv7OhLC/7raRWavIHW2CmxuYcWy9L
	bw8pcVsdOuVjLSsE8Sw6BypKmbhOAoTEk44GiRSm01SuBO0muTxBdcWUiSoCmm3ffcaAyO
	tYr5lo9tckG59/56C5sRr/l9eXjMjDw08anM9qae6aJ294vfAXOHdM82rZwQrA=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357379;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DekeK5Vx/mEvxlQz/WIkRnnnDrgTBFmkjwLIFiYmCI/o=3D;
	b=3D0eY+mxT2R0zhK64BG73V2LvjwDAC3KrYalALuu5G//59SZTKoP1a2JxYvssHY9xc0oLqSP
	pI3GmOjLWDgMptBw=3D=3D
Date: Thu, 31 Oct 2024 06:49:28 +0000
Subject: [PATCH v2 05/19] io_uring: Remove redundant hrtimer's callback
 function setup
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-5-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 997
Lines: 28

The IORING_OP_TIMEOUT command uses hrtimer underneath. The timer's callback
function is setup in io_timeout(), and then the callback function is setup
again when the timer is rearmed.

Since the callback function is the same for both cases, the latter setup is
redundant, therefore remove it.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: Jens Axboe <axboe@kernel.dk>
---
 io_uring/timeout.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 9973876d91b0ef32010691e60b249988a76bdbe9..2ffe5e1dc68aeb92aa7bc5c4dc3=
ba28cafe03c09 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -76,7 +76,6 @@ static void io_timeout_complete(struct io_kiocb *req, str=
uct io_tw_state *ts)
 			/* re-arm timer */
 			spin_lock_irq(&ctx->timeout_lock);
 			list_add(&timeout->list, ctx->timeout_list.prev);
-			data->timer.function =3D io_timeout_fn;
 			hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), data->mode);
 			spin_unlock_irq(&ctx->timeout_lock);
 			return;

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:40 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id ToWmAoQoI2dIEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:40 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357379;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DVHVkMLFiIiICwk5zJUEefXOVMFBq3qj9ujpVe1+PqII=3D;
	b=3DUltjtuwgigL/kXdFGIuuXD3ehVCd5B1upWlJex3nCHF+nht+DDGmf8ystq21w6HjCKYma5
	UIkMCpL44FXuvipvZ8ceNHNov/lMOn/1UMz/ezfo4mV613d7EXVxFoiTFZFU8Ozvaxrkxy
	bG6GM57YzG+lIPuYy4qyUPaoayznoQvH7uCtRZXZNKjfUPF5K6idq/MS4xyG7xPwKkz1Gq
	EA1TPFOSxGp5h39iyfiD0SqvIEjhffltBroB1JW9Dp4C+lD0vMm0K1h2Km5xAZI7uEsB0g
	WsY4JPkKVBJZero3hEmyECwBq/pbxBvU5ntUlEG9HeYeII/zoyd7V1uLwtTaeg=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357379;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DVHVkMLFiIiICwk5zJUEefXOVMFBq3qj9ujpVe1+PqII=3D;
	b=3D12SrmnVaYZXeqneA0PY7EarxqHcZfIV5xvYxJjPyyQcJm7yLMLyzvsJc6JCG3Ht7VBlbBZ
	KCkXaOJ/4gqi9nBg=3D=3D
Date: Thu, 31 Oct 2024 06:49:29 +0000
Subject: [PATCH v2 06/19] hrtimers: Introduce hrtimer_setup() to replace
 hrtimer_init()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-6-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 3627
Lines: 98

To initialize hrtimer, hrtimer_init() needs to be called and also
hrtimer::function must be set. This is error-prone and awkward to use.

Introduce hrtimer_setup() which does both of these things, so that users of
hrtimer can be simplified.

The new setup function also has a sanity check for the provided function
pointer. If NULL, a warning is emitted and a dummy callback installed.

hrtimer_init() will be removed as soon as all of its users have been
converted to the new function.

Signed-off-by: Nam Cao <namcao@linutronix.de>
---
 include/linux/hrtimer.h |  2 ++
 kernel/time/hrtimer.c   | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 5aa9d57528c4b691defbd99e66d200cca18a2dd6..bcc0715c59a84165402480d0245=
4716f5ea68f42 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -228,6 +228,8 @@ static inline void hrtimer_cancel_wait_running(struct h=
rtimer *timer)
 /* Initialize timers: */
 extern void hrtimer_init(struct hrtimer *timer, clockid_t which_clock,
 			 enum hrtimer_mode mode);
+extern void hrtimer_setup(struct hrtimer *timer, enum hrtimer_restart (*fu=
nction)(struct hrtimer *),
+			  clockid_t clock_id, enum hrtimer_mode mode);
 extern void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t which_c=
lock,
 				  enum hrtimer_mode mode);
 extern void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *sl,
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 4b0507cf38ea07dccc40dd67e651fd40e5adfef7..a5ef67edcda92f5a810ba20020d=
032f985cda88f 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1535,6 +1535,11 @@ static inline int hrtimer_clockid_to_base(clockid_t =
clock_id)
 	return HRTIMER_BASE_MONOTONIC;
 }
=20
+static enum hrtimer_restart hrtimer_dummy_timeout(struct hrtimer *unused)
+{
+	return HRTIMER_NORESTART;
+}
+
 static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 			   enum hrtimer_mode mode)
 {
@@ -1571,6 +1576,18 @@ static void __hrtimer_init(struct hrtimer *timer, cl=
ockid_t clock_id,
 	timerqueue_init(&timer->node);
 }
=20
+static void __hrtimer_setup(struct hrtimer *timer,
+			    enum hrtimer_restart (*function)(struct hrtimer *),
+			    clockid_t clock_id, enum hrtimer_mode mode)
+{
+	__hrtimer_init(timer, clock_id, mode);
+
+	if (WARN_ON_ONCE(!function))
+		timer->function =3D hrtimer_dummy_timeout;
+	else
+		timer->function =3D function;
+}
+
 /**
  * hrtimer_init - initialize a timer to the given clock
  * @timer:	the timer to be initialized
@@ -1591,6 +1608,27 @@ void hrtimer_init(struct hrtimer *timer, clockid_t c=
lock_id,
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
=20
+/**
+ * hrtimer_setup - initialize a timer to the given clock
+ * @timer:	the timer to be initialized
+ * @function:	the callback function
+ * @clock_id:	the clock to be used
+ * @mode:       The modes which are relevant for initialization:
+ *              HRTIMER_MODE_ABS, HRTIMER_MODE_REL, HRTIMER_MODE_ABS_SOFT,
+ *              HRTIMER_MODE_REL_SOFT
+ *
+ *              The PINNED variants of the above can be handed in,
+ *              but the PINNED bit is ignored as pinning happens
+ *              when the hrtimer is started
+ */
+void hrtimer_setup(struct hrtimer *timer, enum hrtimer_restart (*function)=
(struct hrtimer *),
+		   clockid_t clock_id, enum hrtimer_mode mode)
+{
+	debug_init(timer, clock_id, mode);
+	__hrtimer_setup(timer, function, clock_id, mode);
+}
+EXPORT_SYMBOL_GPL(hrtimer_setup);
+
 /**
  * hrtimer_init_on_stack - initialize a timer in stack memory
  * @timer:	The timer to be initialized

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:40 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id 6OcnCIQoI2cwEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:40 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357380;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DpeW09FFbPjPf6IH9VA6OF97Ue7Nm9rs4HTBmBMQiZgo=3D;
	b=3Dr/dKH+vi+Pkacu4fAM7NKrVfZsDbg+KuQxmxuUGs2BhXmBJZK1Zia4bJj3xcCj1rs4JBM0
	K8+/5dWh7fhC9JYlLhnyj7K916bjm0DKvC+foqK8p2cCpljUn9soatmUUUFoV1XVSrxrhe
	gILDNEAVYkr4zoVViOtN77vvSflvx7TPKTGLmmDl7L/liB6kmqG+FXcpXe2KmzPPOEwnhW
	BCXHJ9DsDyWvlqcEd8I+pAuQFkjsl2bmsnzq2yz2XVuS4zaUKgwjtQKPImOiS1DhafbDK5
	gt8DngATjaV+B5Hw8GPNfx484D8ir4Hqo+Qf+yqG/1/uAqlpbNv0R4HHuXmwnw=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357380;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DpeW09FFbPjPf6IH9VA6OF97Ue7Nm9rs4HTBmBMQiZgo=3D;
	b=3DeTQUM02Dd4QVLoA7QwZwb/iBFhhOvWYwjF87UptbIy130elVrTHRDR72SiDIU+dbhdzv3L
	3fxyiHWMK7du9QCA=3D=3D
Date: Thu, 31 Oct 2024 06:49:30 +0000
Subject: [PATCH v2 07/19] hrtimers: Introduce hrtimer_setup_on_stack()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-7-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 2634
Lines: 67

To initialize hrtimer on stack, hrtimer_init_on_stack() needs to be called
and also hrtimer::function must be set. This is error-prone and awkward to
use.

Introduce hrtimer_setup_on_stack() which does both of these things, so that
users of hrtimer can be simplified.

The new setup function also has a sanity check for the provided function
pointer. If NULL, a warning is emitted and a dummy callback installed.

hrtimer_init_on_stack() will be removed as soon as all of its users have
been converted to the new function.

Signed-off-by: Nam Cao <namcao@linutronix.de>
---
 include/linux/hrtimer.h |  3 +++
 kernel/time/hrtimer.c   | 19 +++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index bcc0715c59a84165402480d02454716f5ea68f42..2da513f8d66acc628ac420c93da=
e2cbed5680a27 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -232,6 +232,9 @@ extern void hrtimer_setup(struct hrtimer *timer, enum h=
rtimer_restart (*function
 			  clockid_t clock_id, enum hrtimer_mode mode);
 extern void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t which_c=
lock,
 				  enum hrtimer_mode mode);
+extern void hrtimer_setup_on_stack(struct hrtimer *timer,
+				   enum hrtimer_restart (*function)(struct hrtimer *),
+				   clockid_t clock_id, enum hrtimer_mode mode);
 extern void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *sl,
 					  clockid_t clock_id,
 					  enum hrtimer_mode mode);
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index a5ef67edcda92f5a810ba20020d032f985cda88f..daee4e27f839509236c35b867dd=
d979733d1170d 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1646,6 +1646,25 @@ void hrtimer_init_on_stack(struct hrtimer *timer, cl=
ockid_t clock_id,
 }
 EXPORT_SYMBOL_GPL(hrtimer_init_on_stack);
=20
+/**
+ * hrtimer_setup_on_stack - initialize a timer on stack memory
+ * @timer:	The timer to be initialized
+ * @function:	the callback function
+ * @clock_id:	The clock to be used
+ * @mode:       The timer mode
+ *
+ * Similar to hrtimer_setup(), except that this one must be used if struct=
 hrtimer is in stack
+ * memory.
+ */
+void hrtimer_setup_on_stack(struct hrtimer *timer,
+			    enum hrtimer_restart (*function)(struct hrtimer *),
+			    clockid_t clock_id, enum hrtimer_mode mode)
+{
+	debug_init_on_stack(timer, clock_id, mode);
+	__hrtimer_setup(timer, function, clock_id, mode);
+}
+EXPORT_SYMBOL_GPL(hrtimer_setup_on_stack);
+
 /*
  * A timer is active, when it is enqueued into the rbtree or the
  * callback function is running or it's in the state of being migrated

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:40 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id sHGfEYQoI2cuEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:40 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357380;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DJxNyqU0anoavs2ukgZNM8gi0nXQw57bANXcy5SuK+Eo=3D;
	b=3D0R5ElHJ7BFCffCrDvkcLk5LvQLxdHzEBF+WoFp46TOqcBr4amUxk/Jluog5QKGes7QaHEh
	s/wxsg+ZOjw7romb4nHtukL9p19QEaQtDixOqPoRIqvjGuy0194wX8Ll5cg40/F9vzr/sR
	f1rmDIA7YSKCLChGHxMM/4tw89Xyn2YVt90IkmPzfr7yNYXHWYbYg6PsdppTNaudW4AVRY
	z3Y+uq0FRXIjMn0R4z7gPYiBVSHEbp+gl+JDoAEIcxOrcub9vFmlhR2M9eOUzBWQ8WETjI
	/AAoFE6ZWj+VxJCyj2ETgHJr8Ercvw6Aa0/bopMs+gAfoDks/X9QTUYUF4Sx2A=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357380;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DJxNyqU0anoavs2ukgZNM8gi0nXQw57bANXcy5SuK+Eo=3D;
	b=3D92OgkfubgCG0MkhI8IypELn5bmLOQkjpmohXk4SSwt70knAvx+XaMQWPPC7KUtKUh2K28x
	04Jx4h6FyBAcflCg=3D=3D
Date: Thu, 31 Oct 2024 06:49:31 +0000
Subject: [PATCH v2 08/19] hrtimers: Introduce
 hrtimer_setup_sleeper_on_stack()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-8-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 2208
Lines: 58

The hrtimer_init*() API is replaced by hrtimer_setup*() variants to
initialize the timer including the callback function at once.

hrtimer_init_sleeper_on_stack() does not need user to setup the callback
function separately, so a new variant would not be strictly necessary.

Nonetheless, to keep the naming convention consistent, introduce
hrtimer_setup_sleeper_on_stack(). hrtimer_init_on_stack() will be removed
once all users are converted.

Signed-off-by: Nam Cao <namcao@linutronix.de>
---
 include/linux/hrtimer.h |  2 ++
 kernel/time/hrtimer.c   | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 2da513f8d66acc628ac420c93dae2cbed5680a27..48872a2b40718cc7d0c18936517=
67a3c992483b9 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -238,6 +238,8 @@ extern void hrtimer_setup_on_stack(struct hrtimer *time=
r,
 extern void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *sl,
 					  clockid_t clock_id,
 					  enum hrtimer_mode mode);
+extern void hrtimer_setup_sleeper_on_stack(struct hrtimer_sleeper *sl, clo=
ckid_t clock_id,
+					   enum hrtimer_mode mode);
=20
 #ifdef CONFIG_DEBUG_OBJECTS_TIMERS
 extern void destroy_hrtimer_on_stack(struct hrtimer *timer);
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index daee4e27f839509236c35b867ddd979733d1170d..1d1f5c03673cef90474e54c09e1=
6ba840d91a19c 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2065,6 +2065,20 @@ void hrtimer_init_sleeper_on_stack(struct hrtimer_sl=
eeper *sl,
 }
 EXPORT_SYMBOL_GPL(hrtimer_init_sleeper_on_stack);
=20
+/**
+ * hrtimer_setup_sleeper_on_stack - initialize a sleeper in stack memory
+ * @sl:		sleeper to be initialized
+ * @clock_id:	the clock to be used
+ * @mode:	timer mode abs/rel
+ */
+void hrtimer_setup_sleeper_on_stack(struct hrtimer_sleeper *sl,
+				    clockid_t clock_id, enum hrtimer_mode mode)
+{
+	debug_init_on_stack(&sl->timer, clock_id, mode);
+	__hrtimer_init_sleeper(sl, clock_id, mode);
+}
+EXPORT_SYMBOL_GPL(hrtimer_setup_sleeper_on_stack);
+
 int nanosleep_copyout(struct restart_block *restart, struct timespec64 *ts)
 {
 	switch(restart->nanosleep.type) {

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:40 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id qEahGoQoI2dDEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:40 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357380;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DTnLuBLEZcGHPhBkTIHXa3HWi2nu5vBAHhmyfApw0/do=3D;
	b=3DZfqZCwxU7unK0wTAISGC2C7DaUIvb5uI7bjYdj8YPEvniuXkFyTHfrrFpaZgq50ImsOX/i
	uizGrMKX1+dV8wmYIWLC9pYEybCTyAp/TtiLD0AzdVrenz+V4zskVnL/lhKObzj+qlp3SP
	XLQ7Vu3GBjXfR1Qg2ANKkICQVq2SQ0koU7kytEGPUWZEE698pAhblHKQUs1v7XTvaC7Ot6
	87628Brx3qFx7Y6AzLF2PSCGrvsZKNg8egt3im5jiDiK/TOAHlGkvuOlT8yrFuDYT5oLcH
	N/NYhwcCsTY5fXpLsp3Eda7z2cOUUwleY5Au/GdqoQ1+Bm6UX3aUvXqmW3JdDg=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357380;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DTnLuBLEZcGHPhBkTIHXa3HWi2nu5vBAHhmyfApw0/do=3D;
	b=3DHdWmkCNuPmrT2AvJWjEhHannlbzUJ5EjFpDLWrVZ5ho0BT/e2N+Gv5yPiT1bkT+3e2dgfe
	9pL/83Qjtn1QkECQ=3D=3D
Date: Thu, 31 Oct 2024 06:49:32 +0000
Subject: [PATCH v2 09/19] hrtimers: Introduce hrtimer_update_function()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-9-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 1767
Lines: 53

Some users of hrtimer need to change the callback function after the
initial setup. They write to hrtimer::function directly.

That's not safe under all circumstances as the write is lockless and a
concurrent timer expiry might end up using the wrong function pointer.

Introduce hrtimer_update_function(), which also performs runtime checks
whether it is safe to modify the callback.

This allows to make hrtimer::function private once all users are converted.

Signed-off-by: Nam Cao <namcao@linutronix.de>
---
 include/linux/hrtimer.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 48872a2b40718cc7d0c1893651767a3c992483b9..6e026730e80392d9640e8de6fd1=
a2490f5640581 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -327,6 +327,28 @@ static inline int hrtimer_callback_running(struct hrti=
mer *timer)
 	return timer->base->running =3D=3D timer;
 }
=20
+/**
+ * hrtimer_update_function - Update the timer's callback function
+ * @timer:	Timer to update
+ * @function:	New callback function
+ *
+ * Only safe to call if the timer is not enqueued. Can be called in the ca=
llback function if the
+ * timer is not enqueued at the same time (see the comments above HRTIMER_=
STATE_ENQUEUED).
+ */
+static inline void hrtimer_update_function(struct hrtimer *timer,
+					   enum hrtimer_restart (*function)(struct hrtimer *))
+{
+	guard(raw_spinlock_irqsave)(&timer->base->cpu_base->lock);
+
+	if (WARN_ON_ONCE(hrtimer_is_queued(timer)))
+		return;
+
+	if (WARN_ON_ONCE(!function))
+		return;
+
+	timer->function =3D function;
+}
+
 /* Forward a hrtimer so it expires after now: */
 extern u64
 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:40 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id +LSCJYQoI2dFEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:40 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357380;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DfyN9KPwpunCt2TejiBEKMAsujKnatYfcy9dQM5Jx9mg=3D;
	b=3DvEtBVEl3vsVU4ZKvhGBQgPKbnhNRVcbQ4BYoDzIo7bNWEzgDEtFAuy+7T/brz/iThzxobp
	vnm+2YYEPFgcEgU0qBirXamRvlnoX2V8IOKsmokiuyMWqR8Rh6P65nojzwYFVvuTJUJpFV
	5iE/g0MupI5siU2Q6Dz1a8OQKabmvqTdd6my0ovivYa/4hobNNB3IcmO8FKcPuvuCizB2U
	zZuwAm7DfjuRUGZVAt+NSBXx0kojQnwo57ys7GvofuVpqk94ARQEqb4OGM97orgLzuI+vT
	JLMRL3Kk1i3YzgVruVuWyHW1HVMXj6hvAsCDWNXbOmWukN6OXs5jb4MHI8j94g=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357380;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DfyN9KPwpunCt2TejiBEKMAsujKnatYfcy9dQM5Jx9mg=3D;
	b=3DZM67cTblvIjkukb6s35To+LE4Td0ED0nG6T4D1cMEQH3G4aDuK/auFph9clwxuS+oB4n/Q
	W3/2cG8fedvsG8Cw=3D=3D
Date: Thu, 31 Oct 2024 06:49:33 +0000
Subject: [PATCH v2 10/19] fs/aio: Switch to use
 hrtimer_setup_sleeper_on_stack()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-10-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 979
Lines: 27

hrtimer_setup_sleeper_on_stack() replaces hrtimer_init_sleeper_on_stack()
to keep the naming convention consistent.

Convert the usage site over to it. The conversion was done with Coccinelle.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: Christian Brauner <brauner@kernel.org>
---
 fs/aio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index e8920178b50f73267306a6da8f177785267f0c15..a5d331f29943226a17916fbff00=
948eb0f49a07a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1335,7 +1335,7 @@ static long read_events(struct kioctx *ctx, long min_=
nr, long nr,
 	if (until =3D=3D 0 || ret < 0 || ret >=3D min_nr)
 		return ret;
=20
-	hrtimer_init_sleeper_on_stack(&t, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_setup_sleeper_on_stack(&t, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	if (until !=3D KTIME_MAX) {
 		hrtimer_set_expires_range_ns(&t.timer, until, current->timer_slack_ns);
 		hrtimer_sleeper_start_expires(&t, HRTIMER_MODE_REL);

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:41 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id IGvwLoQoI2cwEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:40 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357380;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DVwH2lm2fQbgh8TkHVkU0HIxCHwKkhedZRqVurQrog5o=3D;
	b=3Dzs6zow8IpSTN2OJfAba508fLms56qNGnOXKuJe1aILvILfVboGgtyGLzfb6nD0/OMyJ70+
	9eMIbvX9G7W1mhQZzZUsHSD6XTA9sBvOJHxPzh213MTp4jNY7e5gv8CDgpmKRvlU1oRlzY
	F5K0Y/t2zD5QpRCGlTvg8MSrOV4NkWfgUSv9+QBJnpGIf2WfhqhzW7EQ72aFV1fregLpbE
	hQ7MXCkklY6YZ9lA7jchqnXxLVIsbavE/jOxJSS1dUwR5C9dUPGy9U7zYjRSAcydgpa48+
	pTj3fjE6ESYXl4g6hj1ZgApHVvGiNN2LtW4bCnv5gsIHEpMTyfZdhKKzaSrTcA=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357380;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DVwH2lm2fQbgh8TkHVkU0HIxCHwKkhedZRqVurQrog5o=3D;
	b=3DKP3XmD81yPhJnHnCuDOQXSEDHfkeNYdE3tYlP3YqH8ePATg0EWiTsiHf9WnL2kJEnaW91r
	Ze4f/QbuHsPdlmDg=3D=3D
Date: Thu, 31 Oct 2024 06:49:34 +0000
Subject: [PATCH v2 11/19] futex: Switch to use
 hrtimer_setup_sleeper_on_stack()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-11-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 1118
Lines: 31

hrtimer_setup_sleeper_on_stack() replaces hrtimer_init_sleeper_on_stack()
to keep the naming convention consistent.

Convert the usage site over to it. The conversion was done with Coccinelle.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/futex/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 136768ae26375fafcebf8815ae965f13a3161adf..fb7214c7a36f7377b7fd2dc8a23=
2bc96b1d0d953 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -140,9 +140,9 @@ futex_setup_timer(ktime_t *time, struct hrtimer_sleeper=
 *timeout,
 	if (!time)
 		return NULL;
=20
-	hrtimer_init_sleeper_on_stack(timeout, (flags & FLAGS_CLOCKRT) ?
-				      CLOCK_REALTIME : CLOCK_MONOTONIC,
-				      HRTIMER_MODE_ABS);
+	hrtimer_setup_sleeper_on_stack(timeout,
+				       (flags & FLAGS_CLOCKRT) ? CLOCK_REALTIME : CLOCK_MONOTONIC,
+				       HRTIMER_MODE_ABS);
 	/*
 	 * If range_ns is 0, calling hrtimer_set_expires_range_ns() is
 	 * effectively the same as calling hrtimer_set_expires().

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:41 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id YBWJOIQoI2dIEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:40 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357380;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DHxHIzP9qMm1kJpF85XCGAjs4+UOr4o5SoYMkBDy3Iac=3D;
	b=3DXYXBDkUybJJLCfmRytIY52rLcke0sEL982MrtFglYikQ+5cMCd0ksjrynsbhVXzU8W8ipW
	GDsFNemiz9+tRJ9CIK7Twpm3Dic1gs0Q1bu2DFgeTy6gwOistlx3V5zPE7XAUmCf10zKUi
	27Lxj7mWESsrjd5Rn1J8HpF3zZUJNVoGp/HDhlWvCXO2mTWBDVpqzMlLNuhAH20NXUqrvZ
	18a/A+JnlEst1n6al80nveu9BdLdIketrQWBCPeDmPuXAuWGbkEpsaJZ/iO2/AcMxvN01i
	rK7rJybrefLCoyZOueVfzGuQnYK+F05gA1om+tqNElxpjm1FpKSlUrAtc43SAw=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357380;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DHxHIzP9qMm1kJpF85XCGAjs4+UOr4o5SoYMkBDy3Iac=3D;
	b=3DTG64FwexHhpTBeQTpLyc5Ny7Yy++5CeioRbF1r2JWWU5TAPJJnVe7FA4CgDCYa1mhm2CrR
	6gTz02YKgMNF7BBw=3D=3D
Date: Thu, 31 Oct 2024 06:49:35 +0000
Subject: [PATCH v2 12/19] net: pktgen: Switch to use
 hrtimer_setup_sleeper_on_stack()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-12-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 953
Lines: 27

hrtimer_setup_sleeper_on_stack() replaces hrtimer_init_sleeper_on_stack()
to keep the naming convention consistent.

Convert the usage site over to it. The conversion was done with Coccinelle.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/core/pktgen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 34f68ef74b8f2cd2dbf8ba497b1e323d0636124b..7e23cacbe66e4ad8185a32e9eb5=
e005070a8ab1c 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2285,7 +2285,7 @@ static void spin(struct pktgen_dev *pkt_dev, ktime_t =
spin_until)
 	s64 remaining;
 	struct hrtimer_sleeper t;
=20
-	hrtimer_init_sleeper_on_stack(&t, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	hrtimer_setup_sleeper_on_stack(&t, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	hrtimer_set_expires(&t.timer, spin_until);
=20
 	remaining =3D ktime_to_ns(hrtimer_expires_remaining(&t.timer));

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:41 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id wD9eBoUoI2cuEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:41 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357381;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DiwJQWZBJsv5nf8IPFheER53FrbWd2biEMZzodjj8yss=3D;
	b=3DsB26+aDhL1Pfn/R0rAp3xe2UVX0IGqAiD4JfNC2E/JNeVhZNWfqohCmU8bKgu3m1wyJ9sA
	GZ36ueIyc1vrA60BoWmhn+r2cK0hZkpjCqhtlnGAFVlaAxskrb6VVWREw8LMQsQwfCIIq1
	98LpljkbBdZEVpDtMo1PC9zjQ7VDyoFpbubAAnRQf85q0t8UTg7BX6s2XsdUhvgNs0HBmL
	2S9Xv4Tdf41Cz0PP/AtCaBO3JKmbEcqORc6RQlqOmEglS34CXqsqISoz7wIJDrXW/ohmP9
	Fn1E73hD8qP673Bz95FCnJgZSv8wY+8t0vyna/u99lw2ePa2D8M9YfRGg6FMjQ=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357381;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DiwJQWZBJsv5nf8IPFheER53FrbWd2biEMZzodjj8yss=3D;
	b=3DnkPle7eB7VJ4X2trLwWshonLsRndKwwYLAI/iResoi9R2569fq8dS59ij9Y+P9V+uJScPh
	mVDn9MvCdJju6wBA=3D=3D
Date: Thu, 31 Oct 2024 06:49:36 +0000
Subject: [PATCH v2 13/19] timers: Switch to use
 hrtimer_setup_sleeper_on_stack()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-13-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 2004
Lines: 52

hrtimer_setup_sleeper_on_stack() replaces hrtimer_init_sleeper_on_stack()
to keep the naming convention consistent.

Convert the usage sites over to it. The conversion was done with
Coccinelle.

Signed-off-by: Nam Cao <namcao@linutronix.de>
---
 kernel/time/hrtimer.c       | 5 ++---
 kernel/time/sleep_timeout.c | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 1d1f5c03673cef90474e54c09e16ba840d91a19c..69430467a17dbd8eafc9bcb611f=
a33e0c573c855 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2138,8 +2138,7 @@ static long __sched hrtimer_nanosleep_restart(struct =
restart_block *restart)
 	struct hrtimer_sleeper t;
 	int ret;
=20
-	hrtimer_init_sleeper_on_stack(&t, restart->nanosleep.clockid,
-				      HRTIMER_MODE_ABS);
+	hrtimer_setup_sleeper_on_stack(&t, restart->nanosleep.clockid, HRTIMER_MO=
DE_ABS);
 	hrtimer_set_expires_tv64(&t.timer, restart->nanosleep.expires);
 	ret =3D do_nanosleep(&t, HRTIMER_MODE_ABS);
 	destroy_hrtimer_on_stack(&t.timer);
@@ -2153,7 +2152,7 @@ long hrtimer_nanosleep(ktime_t rqtp, const enum hrtim=
er_mode mode,
 	struct hrtimer_sleeper t;
 	int ret =3D 0;
=20
-	hrtimer_init_sleeper_on_stack(&t, clockid, mode);
+	hrtimer_setup_sleeper_on_stack(&t, clockid, mode);
 	hrtimer_set_expires_range_ns(&t.timer, rqtp, current->timer_slack_ns);
 	ret =3D do_nanosleep(&t, mode);
 	if (ret !=3D -ERESTART_RESTARTBLOCK)
diff --git a/kernel/time/sleep_timeout.c b/kernel/time/sleep_timeout.c
index 3054e5232d208fdb9d782d196a95ca389ae4de45..dfe939f6e4ecf2845919199d8c5=
578f81e01b27c 100644
--- a/kernel/time/sleep_timeout.c
+++ b/kernel/time/sleep_timeout.c
@@ -208,7 +208,7 @@ int __sched schedule_hrtimeout_range_clock(ktime_t *exp=
ires, u64 delta,
 		return -EINTR;
 	}
=20
-	hrtimer_init_sleeper_on_stack(&t, clock_id, mode);
+	hrtimer_setup_sleeper_on_stack(&t, clock_id, mode);
 	hrtimer_set_expires_range_ns(&t.timer, *expires, delta);
 	hrtimer_sleeper_start_expires(&t, mode);
=20

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:41 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id wDbfEIUoI2dFEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:41 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357381;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3D/8VTE/SliaJLbLlZSwIFR6dqx4nYT1RPW4jziqApoIA=3D;
	b=3DxK3Hs1x7jRTFyQwl9OkCfuKT5JU4rPcdXBjgm9iCkshRcXS5VBA6cy7ZyH/311KnFMEia6
	kLGBAYHsrHdQNhEGaQ969cRHnQ6uGwivQipqntipMnoZkw6/Z79pyWyprO3EVDMm4VDqLA
	SMLgCDsvzlpMDnTlhNmyPpl7MLkUDLvNMVFvq6J9snGebcKWOeqXb/oQU3XPNq4k36CXUl
	thNk0FaDUzeY8haCY7RDz3bM1nsA6rFuGyZ0NZo3PcpmZQ262SDd434RuglQ++p0gkXHS9
	Cg//6W4SlXtN35E71vIitHed6ZSILh8Dq9lktMENUBH4m+qSQs8lb80swC2btg=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357381;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3D/8VTE/SliaJLbLlZSwIFR6dqx4nYT1RPW4jziqApoIA=3D;
	b=3DMa/uQv6vTg98W/K3c1MK/SSAy1ET9PhT16gxR91P1OFRBjAsnM0+YczBoVRgLO0Zp9wDYw
	T9FVe+dumvBUHNCg=3D=3D
Date: Thu, 31 Oct 2024 06:49:37 +0000
Subject: [PATCH v2 14/19] wait: Switch to use
 hrtimer_setup_sleeper_on_stack()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-14-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 976
Lines: 29

hrtimer_setup_sleeper_on_stack() replaces hrtimer_init_sleeper_on_stack()
to keep the naming convention consistent.

Convert the usage site over to it.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/wait.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 8aa3372f21a080caf2738799700bd965fbd2198f..643b7c7bf376a42b546f1abfab2=
0068b72cf9c81 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -541,8 +541,8 @@ do {										\
 	int __ret =3D 0;								\
 	struct hrtimer_sleeper __t;						\
 										\
-	hrtimer_init_sleeper_on_stack(&__t, CLOCK_MONOTONIC,			\
-				      HRTIMER_MODE_REL);			\
+	hrtimer_setup_sleeper_on_stack(&__t, CLOCK_MONOTONIC,			\
+				       HRTIMER_MODE_REL);			\
 	if ((timeout) !=3D KTIME_MAX) {						\
 		hrtimer_set_expires_range_ns(&__t.timer, timeout,		\
 					current->timer_slack_ns);		\

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:41 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id GCG6G4UoI2dDEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:41 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357381;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DFOgmfXXck2l4TZk6Q/VKQVLacF0gp4JnsCVX7G8quZU=3D;
	b=3DfIUffKc7+U4H+kUg94YJM9ZSh4JrL5bWQNIdbBabiK7Oj2U/V2J0fhQROI8XSs8mEIYTaf
	Bdys6ewiqBvsfjY1IMJXG0w2wHHw7+lLF4fgROBNP3maLjSf82guban7+y3Rr2vSFkgHKv
	xJGbuFf5HencCtYHeAVGJ0uuotEZWfSWecKSHDnIIg/TClBufE8s78KAkWDGXH9WjNjMMG
	IGzkBB2ASHuwvMTzsfnWdmqp3n5YSbb+C2L+X3IpKKnr1VArlGoEK3xDBp8W0+/vlQrqgM
	gSo0F/kddIDyVh4zvn7cIC2uZEAqyfUsEhAvGfz9Ws2q1sjl3YeU8+POiKwvbg=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357381;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DFOgmfXXck2l4TZk6Q/VKQVLacF0gp4JnsCVX7G8quZU=3D;
	b=3DyImj2zBa7d4BdmXmKxXv+xsLSXORGjeRrkfcxJqR+BNLgcgPn33tZ7TluQ+2dQ8t4kq6wI
	jxfxtUNyGsGhhmAA=3D=3D
Date: Thu, 31 Oct 2024 06:49:38 +0000
Subject: [PATCH v2 15/19] hrtimers: Delete hrtimer_init_sleeper_on_stack()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-15-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 1883
Lines: 51

hrtimer_init_sleeper_on_stack() is now unused. Delete it.

Signed-off-by: Nam Cao <namcao@linutronix.de>
---
 include/linux/hrtimer.h |  3 ---
 kernel/time/hrtimer.c   | 14 --------------
 2 files changed, 17 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 6e026730e80392d9640e8de6fd1a2490f5640581..4e4f04b3c0c20c9b1ffac2108ac=
f7b4a9008027d 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -235,9 +235,6 @@ extern void hrtimer_init_on_stack(struct hrtimer *timer=
, clockid_t which_clock,
 extern void hrtimer_setup_on_stack(struct hrtimer *timer,
 				   enum hrtimer_restart (*function)(struct hrtimer *),
 				   clockid_t clock_id, enum hrtimer_mode mode);
-extern void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *sl,
-					  clockid_t clock_id,
-					  enum hrtimer_mode mode);
 extern void hrtimer_setup_sleeper_on_stack(struct hrtimer_sleeper *sl, clo=
ckid_t clock_id,
 					   enum hrtimer_mode mode);
=20
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 69430467a17dbd8eafc9bcb611fa33e0c573c855..376b8182b72e4327c4a99b105fe=
4ba40991687f9 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2051,20 +2051,6 @@ static void __hrtimer_init_sleeper(struct hrtimer_sl=
eeper *sl,
 	sl->task =3D current;
 }
=20
-/**
- * hrtimer_init_sleeper_on_stack - initialize a sleeper in stack memory
- * @sl:		sleeper to be initialized
- * @clock_id:	the clock to be used
- * @mode:	timer mode abs/rel
- */
-void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *sl,
-				   clockid_t clock_id, enum hrtimer_mode mode)
-{
-	debug_init_on_stack(&sl->timer, clock_id, mode);
-	__hrtimer_init_sleeper(sl, clock_id, mode);
-}
-EXPORT_SYMBOL_GPL(hrtimer_init_sleeper_on_stack);
-
 /**
  * hrtimer_setup_sleeper_on_stack - initialize a sleeper in stack memory
  * @sl:		sleeper to be initialized

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:41 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id 2NuhJ4UoI2cwEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:41 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357381;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DHW9STkMcXc5XEKLv2at0C6ak9fVb7uWJfrgsYsckmwU=3D;
	b=3DWcoyP8IBaIqYSV+qsGe+x3Ri3l+hEH1QO6F6DlUj7nyqnjrQbWt3ObDaM1SGAZRf0JviaK
	rpkcQJE5Bvijd/weTKdxuJD9ORvSRfmwx0vwaV1tDaQmkPZ/t/JCALG3RN0M5qE2GrJcTQ
	ihCte+4YU3F5pKZ06vFgcxWf95vPxGAA2g4w3Zq98+iGFQUW1VY+ZtQWzQPCnklMTprj6S
	5UMHHloqPBcmwBR/Gv8PqUmaV0bEh+tUTw9sY7JeHPFV8DffB9tMgFDr5+6FJntWUhnCHX
	YbAOok0ILr3j9DFGZmIkUGCaPyILkjr5f1aIItNz8iXdi6jS8Ghz9cjUhWC2eQ=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357381;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DHW9STkMcXc5XEKLv2at0C6ak9fVb7uWJfrgsYsckmwU=3D;
	b=3Dh0RLgitb/gznsMKLZ7feVJBppuGMP3E2V4K27L7DegPr/Uq8G9eIcCTW/NlqUtbA8uFLGE
	f1A6D5997qR3bdBQ=3D=3D
Date: Thu, 31 Oct 2024 06:49:39 +0000
Subject: [PATCH v2 16/19] sched/idle: Switch to use
 hrtimer_setup_on_stack()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-16-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 1119
Lines: 32

hrtimer_setup_on_stack() takes the callback function pointer as argument
and initializes the timer completely.

Replace hrtimer_init_on_stack() and the open coded initialization of
hrtimer::function with the new setup mechanism.

The conversion was done with Coccinelle.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index d2f096bb274c3f42390ccf0ba6d0d14dccb0b816..631e428029259a6f5094a7c0544=
2c22689883687 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -399,8 +399,8 @@ void play_idle_precise(u64 duration_ns, u64 latency_ns)
 	cpuidle_use_deepest_state(latency_ns);
=20
 	it.done =3D 0;
-	hrtimer_init_on_stack(&it.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_HARD);
-	it.timer.function =3D idle_inject_timer_fn;
+	hrtimer_setup_on_stack(&it.timer, idle_inject_timer_fn, CLOCK_MONOTONIC,
+			       HRTIMER_MODE_REL_HARD);
 	hrtimer_start(&it.timer, ns_to_ktime(duration_ns),
 		      HRTIMER_MODE_REL_PINNED_HARD);
=20

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:41 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id UL8uMIUoI2dIEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:41 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357381;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3D9LGPfnUbT+OyazUp5Eo2cVJJXFsXzyW6wswHN13y5ew=3D;
	b=3DF3M6+awSWtsDVdFJQ6+M3U67c6moX/SwnVUOcOPb3lggkLpg0u/lXuoLWC7cCVDTHpDt/R
	CIktSqU13JOWfjcbIZaalBjXXTPkq0R9ky6H35LI4vaTUgznUX0Hsbhq0i1btoyEK6itq0
	uqQkNEqLaoVfxGg+EgfIGous1yXJlwjk6qFynZChehAvNpKye9gjIv8GNzxASNXSDVmcwK
	BDk1t1EtMFJ6bn6xuyGj78JePO5RSM+NGY0z+ccfu8WKcSjXrFQNuTFcq3o3fVhTCAoOVj
	WLn4+DM9xmr1wuYF+wEdT8dxKtHSR23fELaU1+PMeA3iz7QI34/B2ZTgdc/zfA=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357381;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3D9LGPfnUbT+OyazUp5Eo2cVJJXFsXzyW6wswHN13y5ew=3D;
	b=3DOiMGhoRxUKfg+qlQYJsvE8ZlPswzj4byg4Gdq2riui2dXa3OEtRUPZHTqt9xnXECRQnZLo
	1GqtP41/dZNeOvCQ=3D=3D
Date: Thu, 31 Oct 2024 06:49:40 +0000
Subject: [PATCH v2 17/19] io_uring: Switch to use hrtimer_setup_on_stack()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-17-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 1275
Lines: 37

hrtimer_setup_on_stack() takes the callback function pointer as argument
and initializes the timer completely.

Replace hrtimer_init_on_stack() and the open coded initialization of
hrtimer::function with the new setup mechanism.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index feb61d68dca68e6f71461af9b7c293d05f7ecd7f..0842aa3f60e7a53e682bb61392b=
1ab23a9b275b0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2435,13 +2435,14 @@ static int io_cqring_schedule_timeout(struct io_wai=
t_queue *iowq,
 {
 	ktime_t timeout;
=20
-	hrtimer_init_on_stack(&iowq->t, clock_id, HRTIMER_MODE_ABS);
 	if (iowq->min_timeout) {
 		timeout =3D ktime_add_ns(iowq->min_timeout, start_time);
-		iowq->t.function =3D io_cqring_min_timer_wakeup;
+		hrtimer_setup_on_stack(&iowq->t, io_cqring_min_timer_wakeup, clock_id,
+				       HRTIMER_MODE_ABS);
 	} else {
 		timeout =3D iowq->timeout;
-		iowq->t.function =3D io_cqring_timer_wakeup;
+		hrtimer_setup_on_stack(&iowq->t, io_cqring_timer_wakeup, clock_id,
+				       HRTIMER_MODE_ABS);
 	}
=20
 	hrtimer_set_expires_range_ns(&iowq->t, timeout, 0);

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:42 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id iGEIO4UoI2dDEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:41 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357381;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DqqSxTgxTBXm23RWr0LdlivKq9i+M3qnIKLtAIMbZhXA=3D;
	b=3DB0WHZTU2zwqc3WwQYzkYHO8KEs+Z5HIu4fOL/J/PR0xoUsCBvLFBDDIOdMKBZYhjUPekxZ
	1zoHj1ckL1zG6LhLt0bvY2ls40Gh6mXfgJj6e2hpheBMy0SXVXxcJmY1+6J49zxfIK41nj
	YstbgN86ph3JysURVYZNiLZYHWnMPtzs8jK48WlIsfOKfEdMjYL6T5+l+6IQbylHEwQ8Et
	nirl8ipdfzFInabEV28Awp64kRAg5TqI6nqkvLEkkge6zfHqYeEY57jRkEnpqSlRnNaiJN
	SgiYhlbK0Llr0eoOh7jEHZjzkZsaAJc4Aj8i+K/dtCVYzSkHdQMMgNpJVyWZ9w=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357381;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DqqSxTgxTBXm23RWr0LdlivKq9i+M3qnIKLtAIMbZhXA=3D;
	b=3DKWfxUkhOAfOYn7PLIkZ/nWR9kOVn2eCTMS1iPNtu4+hdSuQZY5TEwams4KbiecZ1hEQ4c2
	xSSwJ0n0fSbYHICA=3D=3D
Date: Thu, 31 Oct 2024 06:49:41 +0000
Subject: [PATCH v2 18/19] alarmtimer: Switch to use hrtimer_setup() and
 hrtimer_setup_on_stack()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-18-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 1949
Lines: 51

hrtimer_setup() and hrtimer_setup_on_stack() take the callback function
pointer as argument and initialize the timer completely.

Replace the hrtimer_init*() variants and the open coded initialization of
hrtimer::function with the new setup mechanism.

Switch to use the new functions.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: John Stultz <jstultz@google.com>
---
 kernel/time/alarmtimer.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 452d8aa2f6e0133fc7afe058d2102c4f28f38c91..f581868e1b3e596b847490198a3=
5c6997ad795ad 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -337,7 +337,6 @@ __alarm_init(struct alarm *alarm, enum alarmtimer_type =
type,
 	     enum alarmtimer_restart (*function)(struct alarm *, ktime_t))
 {
 	timerqueue_init(&alarm->node);
-	alarm->timer.function =3D alarmtimer_fired;
 	alarm->function =3D function;
 	alarm->type =3D type;
 	alarm->state =3D ALARMTIMER_STATE_INACTIVE;
@@ -352,8 +351,8 @@ __alarm_init(struct alarm *alarm, enum alarmtimer_type =
type,
 void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
 		enum alarmtimer_restart (*function)(struct alarm *, ktime_t))
 {
-	hrtimer_init(&alarm->timer, alarm_bases[type].base_clockid,
-		     HRTIMER_MODE_ABS);
+	hrtimer_setup(&alarm->timer, alarmtimer_fired, alarm_bases[type].base_clo=
ckid,
+		      HRTIMER_MODE_ABS);
 	__alarm_init(alarm, type, function);
 }
 EXPORT_SYMBOL_GPL(alarm_init);
@@ -816,8 +815,8 @@ static void
 alarm_init_on_stack(struct alarm *alarm, enum alarmtimer_type type,
 		    enum alarmtimer_restart (*function)(struct alarm *, ktime_t))
 {
-	hrtimer_init_on_stack(&alarm->timer, alarm_bases[type].base_clockid,
-			      HRTIMER_MODE_ABS);
+	hrtimer_setup_on_stack(&alarm->timer, alarmtimer_fired, alarm_bases[type]=
.base_clockid,
+			       HRTIMER_MODE_ABS);
 	__alarm_init(alarm, type, function);
 }
=20

--=20
2.45.2


From namcao@linutronix.de Thu Oct 31 07:49:42 2024
Return-Path: <namcao@linutronix.de>
Received: from galois.linutronix.de
	by Galois.linutronix.de with LMTP
	id KP35CIYoI2dFEAAAEMDZNw
	(envelope-from <namcao@linutronix.de>); Thu, 31 Oct 2024 07:49:42 +0100
From: Nam Cao <namcao@linutronix.de>
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dlinutronix.=
de;
	s=3D2020; t=3D1730357382;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DHx2vs6gncUvuDlyYXH9CTSqfSa9NhktAI9RFz1ZC2zA=3D;
	b=3DsOU4h1r/PntxblDlPA78aBkuRYyXYKHKwKLeP/wDBnrKVPQKDVxQDD+41D+2VzHED3sSAH
	X1a3xa0eL/OU6uXFKTA9qk2HomTPkuBhPu5SmDPsDO3+mVr/o4y8vlObOVRXIwILZNw+ZY
	5y+Jq5gIoTEAmeGOnXieXsg1rJNrpz3dwqC3ev02uChq0WN6fzhQvmlpK/YE1wukDcRIsP
	Ejz11ZxUM3L21y2n4YouTaLibJ7H3eN/teiQa+g8DmhuLir/lLCbZjglfF/mmoFzXedtCQ
	4ENM/6vfh0jI7abWqNfIe4TOR/5olqDXF1tLufnxheXalebH46H/pfhx1c0HjQ=3D=3D
DKIM-Signature: v=3D1; a=3Ded25519-sha256; c=3Drelaxed/relaxed; d=3Dlinutro=
nix.de;
	s=3D2020e; t=3D1730357382;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DHx2vs6gncUvuDlyYXH9CTSqfSa9NhktAI9RFz1ZC2zA=3D;
	b=3DN84dTMeFM1Rj1OcJ24onssa5LjfAyJcvFXL23rUhJokChK8K7OuDeJKkSbWlHF3ERgGKbC
	BU9imWFZm+rPbHDA=3D=3D
Date: Thu, 31 Oct 2024 06:49:42 +0000
Subject: [PATCH v2 19/19] hrtimers: Delete hrtimer_init_on_stack()
MIME-Version: 1.0
Content-Type: text/plain; charset=3D"utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241031-hrtimer_setup_p1_v2-v2-19-23400656575a@linutronix.de>
References: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
In-Reply-To: <20241031-hrtimer_setup_p1_v2-v2-0-23400656575a@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,=20
 Frederic Weisbecker <frederic@kernel.org>,=20
 Thomas Gleixner <tglx@linutronix.de>,=20
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com=
>,=20
 Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>,=20
 linux-kernel@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>,=20
 intel-gfx@lists.freedesktop.org, Sean Christopherson <seanjc@google.com>,=
=20
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,=20
 Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,=20
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,=20
 Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>,=20
 Nam Cao <namcao@linutronix.de>
Status: RO
Content-Length: 2004
Lines: 53

hrtimer_init_on_stack() is now unused. Delete it.

Signed-off-by: Nam Cao <namcao@linutronix.de>
---
 include/linux/hrtimer.h |  2 --
 kernel/time/hrtimer.c   | 17 -----------------
 2 files changed, 19 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 4e4f04b3c0c20c9b1ffac2108acf7b4a9008027d..7ef5f7ef31a911cd213e971cf1f=
13ebe2db8c512 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -230,8 +230,6 @@ extern void hrtimer_init(struct hrtimer *timer, clockid=
_t which_clock,
 			 enum hrtimer_mode mode);
 extern void hrtimer_setup(struct hrtimer *timer, enum hrtimer_restart (*fu=
nction)(struct hrtimer *),
 			  clockid_t clock_id, enum hrtimer_mode mode);
-extern void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t which_c=
lock,
-				  enum hrtimer_mode mode);
 extern void hrtimer_setup_on_stack(struct hrtimer *timer,
 				   enum hrtimer_restart (*function)(struct hrtimer *),
 				   clockid_t clock_id, enum hrtimer_mode mode);
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 376b8182b72e4327c4a99b105fe4ba40991687f9..55e9ffbcd49ad466c0f02279e6e=
624e15f58613d 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1629,23 +1629,6 @@ void hrtimer_setup(struct hrtimer *timer, enum hrtim=
er_restart (*function)(struc
 }
 EXPORT_SYMBOL_GPL(hrtimer_setup);
=20
-/**
- * hrtimer_init_on_stack - initialize a timer in stack memory
- * @timer:	The timer to be initialized
- * @clock_id:	The clock to be used
- * @mode:       The timer mode
- *
- * Similar to hrtimer_init(), except that this one must be used if struct =
hrtimer is in stack
- * memory.
- */
-void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t clock_id,
-			   enum hrtimer_mode mode)
-{
-	debug_init_on_stack(timer, clock_id, mode);
-	__hrtimer_init(timer, clock_id, mode);
-}
-EXPORT_SYMBOL_GPL(hrtimer_init_on_stack);
-
 /**
  * hrtimer_setup_on_stack - initialize a timer on stack memory
  * @timer:	The timer to be initialized

--=20
2.45.2



