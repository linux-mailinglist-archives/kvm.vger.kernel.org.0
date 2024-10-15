Return-Path: <kvm+bounces-28927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 314C999F401
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 19:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 559A11C21931
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 17:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 295751FC7CB;
	Tue, 15 Oct 2024 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="Mfc8Y4JZ"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82011FAEFA;
	Tue, 15 Oct 2024 17:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729013156; cv=none; b=Iy6iH9aebE3xs0lJV/WWTI0pnOuws1t8wpn1ItkPyXz2cXB+1m0iosExu4pus3lw0itbTN0ZJPX1oxQ7yQNuhYr+AmDBIClcfpGtZ8Z3M1RvwFJUzxIUW1W1wfxm5aodu2CFaVJqL1qmA8qS8RJ3vhyTSBPD+YLDpuzXYv9cogk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729013156; c=relaxed/simple;
	bh=oztAA0ZEr8ALi79MZ8lt5XVT9ypqqdhFgTyRDxHAlOQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UNF2RLT9eNuS+VeVcZYZLJLsj1PVYgdvf65YhwZ8x96TZNFxOhKkxSR5WaJPUM18WaWLO17cDhlzp3GoJOo4AxRrfyflYn4qkfGQKWQ2JLOefwPOsn0AfC1QO//nN01oMJEqLY0Ta+7MonbCE15ZoWzc9Vj0HhFaxOO3aY9H3+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=Mfc8Y4JZ; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1729012633;
	bh=oztAA0ZEr8ALi79MZ8lt5XVT9ypqqdhFgTyRDxHAlOQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=Mfc8Y4JZQxrBiku2lskGuhzklrMFOH5ILuyqUjOPO2aQH5VYprpcBCZpkkgiFDzsO
	 0azy0TcH9MVMmTlrEWn23X/l7qTj3gCdj6ZQRK9FRkNZi1HuCOQ+Vb6WXdAQzzaR2u
	 s3/o7IEnIAqCPK1RDIbsucRsonzVO7deGbv9XnC4=
Received: by gentwo.org (Postfix, from userid 1003)
	id CF53D401D1; Tue, 15 Oct 2024 10:17:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id CD932400C9;
	Tue, 15 Oct 2024 10:17:13 -0700 (PDT)
Date: Tue, 15 Oct 2024 10:17:13 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org, 
    kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
    linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
    x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com, 
    vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org, 
    peterz@infradead.org, arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, 
    harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com, 
    misono.tomohiro@fujitsu.com, maobibo@loongson.cn, 
    joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
    konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-Reply-To: <Zw6dZ7HxvcHJaDgm@arm.com>
Message-ID: <1e56e83e-83b3-d4fd-67a8-0bc89f3e3d20@gentwo.org>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com> <20240925232425.2763385-2-ankur.a.arora@oracle.com> <Zw5aPAuVi5sxdN5-@arm.com> <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org> <Zw6dZ7HxvcHJaDgm@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1657094188-1729012633=:314176"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1657094188-1729012633=:314176
Content-Type: text/plain; charset=US-ASCII

On Tue, 15 Oct 2024, Catalin Marinas wrote:

> > Setting of need_resched() from another processor involves sending an IPI
> > after that was set. I dont think we need to smp_cond_load_relaxed since
> > the IPI will cause an event. For ARM a WFE would be sufficient.
>
> I'm not worried about the need_resched() case, even without an IPI it
> would still work.
>
> The loop_count++ side of the condition is supposed to timeout in the
> absence of a need_resched() event. You can't do an smp_cond_load_*() on
> a variable that's only updated by the waiting CPU. Nothing guarantees to
> wake it up to update the variable (the event stream on arm64, yes, but
> that's generic code).

Hmm... I have WFET implementation here without smp_cond modelled after
the delay() implementation ARM64 (but its not generic and there is
an additional patch required to make this work. Intermediate patch
attached)


From: Christoph Lameter (Ampere) <cl@gentwo.org>
Subject: [Haltpoll: Implement waiting using WFET

Use WFET if the hardware supports it to implement
a wait until something happens to wake up the cpu.

If WFET is not available then use the stream event
source to periodically wake up until an event happens
or the timeout expires.

The smp_cond_wait() is not necessary because the scheduler
will create an event on the targeted cpu by sending an IPI.

Without cond_wait we can simply take the basic approach
from the delay() function and customize it a bit.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 drivers/cpuidle/poll_state.c | 43 +++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

Index: linux/drivers/cpuidle/poll_state.c
===================================================================
--- linux.orig/drivers/cpuidle/poll_state.c
+++ linux/drivers/cpuidle/poll_state.c
@@ -5,48 +5,41 @@

 #include <linux/cpuidle.h>
 #include <linux/sched.h>
-#include <linux/sched/clock.h>
 #include <linux/sched/idle.h>
-
-#ifdef CONFIG_ARM64
-/*
- * POLL_IDLE_RELAX_COUNT determines how often we check for timeout
- * while polling for TIF_NEED_RESCHED in thread_info->flags.
- *
- * Set this to a low value since arm64, instead of polling, uses a
- * event based mechanism.
- */
-#define POLL_IDLE_RELAX_COUNT	1
-#else
-#define POLL_IDLE_RELAX_COUNT	200
-#endif
+#include <clocksource/arm_arch_timer.h>

 static int __cpuidle poll_idle(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
 {
-	u64 time_start;
-
-	time_start = local_clock_noinstr();
+	const cycles_t start = get_cycles();

 	dev->poll_time_limit = false;

 	raw_local_irq_enable();
 	if (!current_set_polling_and_test()) {
-		u64 limit;

-		limit = cpuidle_poll_time(drv, dev);
+		const cycles_t end = start + ARCH_TIMER_NSECS_TO_CYCLES(cpuidle_poll_time(drv, dev));

 		while (!need_resched()) {
-			unsigned int loop_count = 0;
-			if (local_clock_noinstr() - time_start > limit) {
-				dev->poll_time_limit = true;
-				break;
-			}

-			smp_cond_load_relaxed(&current_thread_info()->flags,
-					      VAL & _TIF_NEED_RESCHED ||
-					      loop_count++ >= POLL_IDLE_RELAX_COUNT);
+			if (alternative_has_cap_unlikely(ARM64_HAS_WFXT)) {
+
+				/* We can power down for a configurable interval while waiting */
+				while (!need_resched() && get_cycles() < end)
+						wfet(end);
+
+			} else if (arch_timer_evtstrm_available()) {
+				const cycles_t timer_period = ARCH_TIMER_USECS_TO_CYCLES(ARCH_TIMER_EVT_STREAM_PERIOD_US);
+
+				/* Wake up periodically during evstream events */
+				while (!need_resched() && get_cycles() + timer_period <= end)
+						wfe();
+			}
 		}
+
+		/* In case time is not up yet due to coarse time intervals above */
+		while (!need_resched() && get_cycles() < end)
+					cpu_relax();
 	}
 	raw_local_irq_disable();

--8323329-1657094188-1729012633=:314176
Content-Type: text/plain; charset=US-ASCII; name=export_nsecs_to_cycles
Content-Transfer-Encoding: BASE64
Content-ID: <8127300c-6816-9bbd-c067-979ed715171d@gentwo.org>
Content-Description: arch timr mods
Content-Disposition: attachment; filename=export_nsecs_to_cycles

RnJvbTogQ2hyaXN0b3BoIExhbWV0ZXIgKEFtcGVyZSkgPGNsQGxpbnV4LmNv
bT4NCg0KTW92ZSB0aGUgY29udmVyc2lvbiBmcm9tIHRpbWUgdG8gY3ljbGVz
IG9mIGFyY2hfdGltZXINCmludG8gYXJjaF90aW1lci5oLiBBZGQgbnNlYyBj
b252ZXJzaW9uIHNpbmNlIHdlIHdpbGwgbmVlZCB0aGF0IHNvb24uDQoNClNp
Z25lZC1vZmYtYnk6IENocmlzdG9waCBMYW1ldGVyIDxjbEBsaW51eC5jb20+
DQoNCkluZGV4OiBsaW51eC9hcmNoL2FybTY0L2xpYi9kZWxheS5jDQo9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09DQotLS0gbGludXgub3JpZy9hcmNoL2FybTY0
L2xpYi9kZWxheS5jDQorKysgbGludXgvYXJjaC9hcm02NC9saWIvZGVsYXku
Yw0KQEAgLTE1LDE0ICsxNSw2IEBADQogDQogI2luY2x1ZGUgPGNsb2Nrc291
cmNlL2FybV9hcmNoX3RpbWVyLmg+DQogDQotI2RlZmluZSBVU0VDU19UT19D
WUNMRVModGltZV91c2VjcykJCQlcDQotCXhsb29wc190b19jeWNsZXMoKHRp
bWVfdXNlY3MpICogMHgxMEM3VUwpDQotDQotc3RhdGljIGlubGluZSB1bnNp
Z25lZCBsb25nIHhsb29wc190b19jeWNsZXModW5zaWduZWQgbG9uZyB4bG9v
cHMpDQotew0KLQlyZXR1cm4gKHhsb29wcyAqIGxvb3BzX3Blcl9qaWZmeSAq
IEhaKSA+PiAzMjsNCi19DQotDQogdm9pZCBfX2RlbGF5KHVuc2lnbmVkIGxv
bmcgY3ljbGVzKQ0KIHsNCiAJY3ljbGVzX3Qgc3RhcnQgPSBnZXRfY3ljbGVz
KCk7DQpAQCAtMzksNyArMzEsNyBAQCB2b2lkIF9fZGVsYXkodW5zaWduZWQg
bG9uZyBjeWNsZXMpDQogCQkJd2ZldChlbmQpOw0KIAl9IGVsc2UgCWlmIChh
cmNoX3RpbWVyX2V2dHN0cm1fYXZhaWxhYmxlKCkpIHsNCiAJCWNvbnN0IGN5
Y2xlc190IHRpbWVyX2V2dF9wZXJpb2QgPQ0KLQkJCVVTRUNTX1RPX0NZQ0xF
UyhBUkNIX1RJTUVSX0VWVF9TVFJFQU1fUEVSSU9EX1VTKTsNCisJCQlBUkNI
X1RJTUVSX1VTRUNTX1RPX0NZQ0xFUyhBUkNIX1RJTUVSX0VWVF9TVFJFQU1f
UEVSSU9EX1VTKTsNCiANCiAJCXdoaWxlICgoZ2V0X2N5Y2xlcygpIC0gc3Rh
cnQgKyB0aW1lcl9ldnRfcGVyaW9kKSA8IGN5Y2xlcykNCiAJCQl3ZmUoKTsN
CkBAIC01Miw3ICs0NCw3IEBAIEVYUE9SVF9TWU1CT0woX19kZWxheSk7DQog
DQogaW5saW5lIHZvaWQgX19jb25zdF91ZGVsYXkodW5zaWduZWQgbG9uZyB4
bG9vcHMpDQogew0KLQlfX2RlbGF5KHhsb29wc190b19jeWNsZXMoeGxvb3Bz
KSk7DQorCV9fZGVsYXkoYXJjaF90aW1lcl94bG9vcHNfdG9fY3ljbGVzKHhs
b29wcykpOw0KIH0NCiBFWFBPUlRfU1lNQk9MKF9fY29uc3RfdWRlbGF5KTsN
CiANCkluZGV4OiBsaW51eC9pbmNsdWRlL2Nsb2Nrc291cmNlL2FybV9hcmNo
X3RpbWVyLmgNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBsaW51eC5v
cmlnL2luY2x1ZGUvY2xvY2tzb3VyY2UvYXJtX2FyY2hfdGltZXIuaA0KKysr
IGxpbnV4L2luY2x1ZGUvY2xvY2tzb3VyY2UvYXJtX2FyY2hfdGltZXIuaA0K
QEAgLTkwLDYgKzkwLDE5IEBAIGV4dGVybiB1NjQgKCphcmNoX3RpbWVyX3Jl
YWRfY291bnRlcikodm8NCiBleHRlcm4gc3RydWN0IGFyY2hfdGltZXJfa3Zt
X2luZm8gKmFyY2hfdGltZXJfZ2V0X2t2bV9pbmZvKHZvaWQpOw0KIGV4dGVy
biBib29sIGFyY2hfdGltZXJfZXZ0c3RybV9hdmFpbGFibGUodm9pZCk7DQog
DQorI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+DQorDQorc3RhdGljIGlubGlu
ZSB1bnNpZ25lZCBsb25nIGFyY2hfdGltZXJfeGxvb3BzX3RvX2N5Y2xlcyh1
bnNpZ25lZCBsb25nIHhsb29wcykNCit7DQorCXJldHVybiAoeGxvb3BzICog
bG9vcHNfcGVyX2ppZmZ5ICogSFopID4+IDMyOw0KK30NCisNCisjZGVmaW5l
IEFSQ0hfVElNRVJfVVNFQ1NfVE9fQ1lDTEVTKHRpbWVfdXNlY3MpCQkJXA0K
KwlhcmNoX3RpbWVyX3hsb29wc190b19jeWNsZXMoKHRpbWVfdXNlY3MpICog
MHgxMEM3VUwpDQorDQorI2RlZmluZSBBUkNIX1RJTUVSX05TRUNTX1RPX0NZ
Q0xFUyh0aW1lX25zZWNzKQkJCVwNCisJYXJjaF90aW1lcl94bG9vcHNfdG9f
Y3ljbGVzKCh0aW1lX25zZWNzKSAqIDB4NVVMKQ0KKw0KICNlbHNlDQogDQog
c3RhdGljIGlubGluZSB1MzIgYXJjaF90aW1lcl9nZXRfcmF0ZSh2b2lkKQ0K

--8323329-1657094188-1729012633=:314176--

