Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115177D9D90
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 17:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346248AbjJ0Pzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 11:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346242AbjJ0Pzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 11:55:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A75121
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 08:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RXKhZA7iQ0+heNNq5t3M7K5fJDZur4QQ75Qni6SdEEE=; b=b05WEAHFHWDhKN4rXSx1VOpKbZ
        BNa7iP/DQE6mRkudAkF+zMdB1SvgHWMcUAXfmZWGOOCW3UK9QUVvOkM7IdXrsTUHJTRV9HBRvB0Dq
        g4N8p+ImBs7iyo43Q8WVVxtopk1MMNT34MZuZJMEh17cAVIezC1lRVtd9ZB1Utj3A1DYRpFFh2gvR
        BgqmP40DkkMZrVdZTQWD3z1HI6uO7sRxuE5Sdmortmb3UZjSZwyB/g11mNf0WZm0CNWEUHvl57dpo
        FGmZZMSZGpiXN/JpidMamWnNtFSP0Edyn/iaEMOkNL2xinbCsbM8xtrFlMkQUZSerot7Z/rCTDuNQ
        h04UoDvA==;
Received: from [2001:8b0:10b:5:8f9a:f53a:1a74:1a12] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qwPBX-004FMk-ON; Fri, 27 Oct 2023 15:55:43 +0000
Message-ID: <b5a974bdc330be91c2356f5bb2cc68ef1cc7ed40.camel@infradead.org>
Subject: Re: [RFC PATCH] KVM: x86/xen: don't use broken get_kvmclock_ns()
 for Xen timers
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paul Durrant <paul@xen.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dongli Zhang <dongli.zhang@oracle.com>
Date:   Fri, 27 Oct 2023 16:55:42 +0100
In-Reply-To: <79c1d7fca9aba762b9e97d3abd9b93e5f9045230.camel@infradead.org>
References: <79c1d7fca9aba762b9e97d3abd9b93e5f9045230.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-uEaNanLZ2Wqf9/iQiKHI"
User-Agent: Evolution 3.44.4-0ubuntu2 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-uEaNanLZ2Wqf9/iQiKHI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-10-27 at 14:57 +0100, David Woodhouse wrote:
> As well as fixing kvmclock properly, I also want to rework some of the
> timer code to remove all concept of "now" from it. The guest tells us a
> time in (its) kvmclock nanoseconds at which it wants the timer to go
> off. We subtract its kvmclock "now" from that, call ktime_get() at a
> slightly different "now", then set an hrtimer for that now + the delta.
>=20
> It'd be much nicer to just calculate the host CLOCK_MONOTONIC_RAW time
> at which the guest's kvmclock will be the value that it asked for,
> without any of that sloppiness or ever using the word "now".

Actually, with the slight wrinkle that we can't use CLOCK_MONOTONIC_RAW
with hrtimers, that actually works out fairly simple and even makes the
"don't use get_kvmclock_ns()" part a little less blatant.

From: David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH] KVM: x86/xen: improve accuracy of Xen timers

A test program such as http://david.woodhou.se/timerlat.c confirms user
reports that timers are increasingly inaccurate as the lifetime of a
guest increases. Reporting the actual delay observed when asking for
100=C2=B5s of sleep, it starts off OK on a newly-launched guest but gets
worse over time:

root@ip-10-0-193-21:~# ./timerlat -c -n 5
00000000 latency 103243/100000 (3.2430%)
00000001 latency 103243/100000 (3.2430%)
00000002 latency 103242/100000 (3.2420%)
00000003 latency 103245/100000 (3.2450%)
00000004 latency 103245/100000 (3.2450%)

The biggest problem is that get_kvmclock_ns() returns inaccurate values
when the guest TSC is scaled. The guest sees a TSC value scaled from the
host TSC by a mul/shift conversion (hopefully done in hardware). It then
converts that guest TSC value into nanoseconds using the mul/shift
conversion given to it by the KVM pvclock information.

But get_kvmclock_ns() performs only a single conversion directly from
host TSC to nanoseconds, giving a different result. A test program at
http://david.woodhou.se/tsdrift.c demonstrates the cumulative error
over a day.

It's non-trivial to fix get_kvmclock_ns(), although I'll come back to
that. The actual guest hv_clock is per-CPU, and *theoretically* each
vCPU could be running at a *different* frequency.

The other issue with Xen timers was that the code would snapshot the
host CLOCK_MONOTONIC at some point in time, and then... after a few
interrupts may have occurred, some preemption perhaps... would also read
the guest's kvmclock. Then it would proceed under the false assumption
that those two happened at the *same* time. Any time which *actually*
elapsed between reading the two clocks was introduced as inaccuracies
in the time at which the timer fired.

Fix it to use a variant of kvm_get_time_and_clockread(), which reads the
host TSC just *once*, then use the returned TSC value to calculate the
kvmclock (making sure to do that the way the guest would instead of
making the same mistake get_kvmclock_ns() does.

Sadly, the kernel doesn't let us have hrtimers on CLOCK_MONOTONIC_RAW,
so use CLOCK_MONOTONIC. In practice the slight difference between the
two won't matter over the timescales involved, as we don't care about
the *absolute* values; just the delta.

This does mean a new variant of kvm_get_time_and_clockread() is needed;
called kvm_get_monotonic_and_clockread() because that's what it does.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 30 ++++++++++++++
 arch/x86/kvm/x86.h |  1 +
 arch/x86/kvm/xen.c | 99 ++++++++++++++++++++++++++++++----------------
 3 files changed, 97 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f18b06bbda6..5b706b05f64c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2863,6 +2863,25 @@ static int do_monotonic_raw(s64 *t, u64 *tsc_timesta=
mp)
 	return mode;
 }
=20
+static int do_monotonic(s64 *t, u64 *tsc_timestamp)
+{
+	struct pvclock_gtod_data *gtod =3D &pvclock_gtod_data;
+	unsigned long seq;
+	int mode;
+	u64 ns;
+
+	do {
+		seq =3D read_seqcount_begin(&gtod->seq);
+		ns =3D gtod->clock.base_cycles;
+		ns +=3D vgettsc(&gtod->clock, tsc_timestamp, &mode);
+		ns >>=3D gtod->clock.shift;
+		ns +=3D ktime_to_ns(ktime_add(gtod->clock.offset, gtod->offs_boot));
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
+	*t =3D ns;
+
+	return mode;
+}
+
 static int do_realtime(struct timespec64 *ts, u64 *tsc_timestamp)
 {
 	struct pvclock_gtod_data *gtod =3D &pvclock_gtod_data;
@@ -2895,6 +2914,17 @@ static bool kvm_get_time_and_clockread(s64 *kernel_n=
s, u64 *tsc_timestamp)
 						      tsc_timestamp));
 }
=20
+/* returns true if host is using TSC based clocksource */
+bool kvm_get_monotonic_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp)
+{
+	/* checked again under seqlock below */
+	if (!gtod_is_based_on_tsc(pvclock_gtod_data.clock.vclock_mode))
+		return false;
+
+	return gtod_is_based_on_tsc(do_monotonic(kernel_ns,
+						 tsc_timestamp));
+}
+
 /* returns true if host is using TSC based clocksource */
 static bool kvm_get_walltime_and_clockread(struct timespec64 *ts,
 					   u64 *tsc_timestamp)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1e7be1f6ab29..c08c6f729965 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -293,6 +293,7 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm,=
 u64 quirk)
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc=
_eip);
=20
 u64 get_kvmclock_ns(struct kvm *kvm);
+bool kvm_get_monotonic_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp);
=20
 int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
 	gva_t addr, void *val, unsigned int bytes,
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 0ea6016ad132..46d68a30ec84 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -24,6 +24,7 @@
 #include <xen/interface/sched.h>
=20
 #include <asm/xen/cpuid.h>
+#include <asm/pvclock.h>
=20
 #include "cpuid.h"
 #include "trace.h"
@@ -144,17 +145,75 @@ static enum hrtimer_restart xen_timer_callback(struct=
 hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
=20
-static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, s64 =
delta_ns)
+static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
+				bool linux_wa)
 {
+	uint64_t guest_now, host_tsc, guest_tsc;
+	int64_t kernel_now, delta;
+
+	/*
+	 * The guest provides the requested timeout in absolute nanoseconds
+	 * of the KVM clock =E2=80=94 as *it* sees it, based on the scaled TSC an=
d
+	 * the pvclock information provided by KVM.
+	 *
+	 * The kernel doesn't support hrtimers based on CLOCK_MONOTONIC_RAW
+	 * so use CLOCK_MONOTONIC. In the timescales covered by timers, the
+	 * difference won't matter much as there is no cumulative effect.
+	 *
+	 * Calculate the time for some arbitrary point in time around "now"
+	 * in terms of both kvmclock and CLOCK_MONOTONIC. Calculate the
+	 * delta between the kvmclock "now" value and the guest's requested
+	 * timeout, apply the "Linux workaround" described below, and add
+	 * the resulting delta to the CLOCK_MONOTONIC "now" value, to get
+	 * the absolute CLOCK_MONOTONIC time at which the timer should
+	 * fire.
+	 */
+	if (!kvm_get_monotonic_and_clockread(&kernel_now, &host_tsc)) {
+		/*
+		 * Even in this case, don't fall back to get_kvmclock_ns()
+		 * because it's broken; it has a systemic error in its
+		 * results because it scales directly from host TSC to
+		 * nanoseconds, and doesn't scale first to guest TSC and
+		 * *then* to nanoseconds as the guest does.
+		 *
+		 * There is a small error introduced here because time
+		 * continues to elapse between the ktime_get() and the
+		 * subsequent rdtsc().
+		 */
+		kernel_now =3D ktime_get(); /* This is CLOCK_MONOTONIC */
+		host_tsc =3D rdtsc();
+	}
+
+	/* Calculate the guest kvmclock as the guest would do it. */
+	guest_tsc =3D kvm_read_l1_tsc(vcpu, host_tsc);
+	guest_now =3D __pvclock_read_cycles(&vcpu->arch.hv_clock, guest_tsc);
+	delta =3D guest_abs - guest_now;
+
+	/* Xen has a 'Linux workaround' in do_set_timer_op() which
+	 * checks for negative absolute timeout values (caused by
+	 * integer overflow), and for values about 13 days in the
+	 * future (2^50ns) which would be caused by jiffies
+	 * overflow. For those cases, it sets the timeout 100ms in
+	 * the future (not *too* soon, since if a guest really did
+	 * set a long timeout on purpose we don't want to keep
+	 * churning CPU time by waking it up).
+	 */
+	if (linux_wa) {
+		if ((unlikely((int64_t)guest_abs < 0 ||
+			      (delta > 0 && (uint32_t) (delta >> 50) !=3D 0)))) {
+			delta =3D 100 * NSEC_PER_MSEC;
+			guest_abs =3D guest_now + delta;
+		}
+	}
+
 	atomic_set(&vcpu->arch.xen.timer_pending, 0);
 	vcpu->arch.xen.timer_expires =3D guest_abs;
=20
-	if (delta_ns <=3D 0) {
+	if (delta <=3D 0) {
 		xen_timer_callback(&vcpu->arch.xen.timer);
 	} else {
-		ktime_t ktime_now =3D ktime_get();
 		hrtimer_start(&vcpu->arch.xen.timer,
-			      ktime_add_ns(ktime_now, delta_ns),
+			      ktime_add_ns(kernel_now, delta),
 			      HRTIMER_MODE_ABS_HARD);
 	}
 }
@@ -923,8 +982,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct=
 kvm_xen_vcpu_attr *data)
 		/* Start the timer if the new value has a valid vector+expiry. */
 		if (data->u.timer.port && data->u.timer.expires_ns)
 			kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
-					    data->u.timer.expires_ns -
-					    get_kvmclock_ns(vcpu->kvm));
+					    false);
=20
 		r =3D 0;
 		break;
@@ -1340,7 +1398,6 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vc=
pu, bool longmode, int cmd,
 {
 	struct vcpu_set_singleshot_timer oneshot;
 	struct x86_exception e;
-	s64 delta;
=20
 	if (!kvm_xen_timer_enabled(vcpu))
 		return false;
@@ -1374,13 +1431,7 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *v=
cpu, bool longmode, int cmd,
 			return true;
 		}
=20
-		delta =3D oneshot.timeout_abs_ns - get_kvmclock_ns(vcpu->kvm);
-		if ((oneshot.flags & VCPU_SSHOTTMR_future) && delta < 0) {
-			*r =3D -ETIME;
-			return true;
-		}
-
-		kvm_xen_start_timer(vcpu, oneshot.timeout_abs_ns, delta);
+		kvm_xen_start_timer(vcpu, oneshot.timeout_abs_ns, false);
 		*r =3D 0;
 		return true;
=20
@@ -1404,25 +1455,7 @@ static bool kvm_xen_hcall_set_timer_op(struct kvm_vc=
pu *vcpu, uint64_t timeout,
 		return false;
=20
 	if (timeout) {
-		uint64_t guest_now =3D get_kvmclock_ns(vcpu->kvm);
-		int64_t delta =3D timeout - guest_now;
-
-		/* Xen has a 'Linux workaround' in do_set_timer_op() which
-		 * checks for negative absolute timeout values (caused by
-		 * integer overflow), and for values about 13 days in the
-		 * future (2^50ns) which would be caused by jiffies
-		 * overflow. For those cases, it sets the timeout 100ms in
-		 * the future (not *too* soon, since if a guest really did
-		 * set a long timeout on purpose we don't want to keep
-		 * churning CPU time by waking it up).
-		 */
-		if (unlikely((int64_t)timeout < 0 ||
-			     (delta > 0 && (uint32_t) (delta >> 50) !=3D 0))) {
-			delta =3D 100 * NSEC_PER_MSEC;
-			timeout =3D guest_now + delta;
-		}
-
-		kvm_xen_start_timer(vcpu, timeout, delta);
+		kvm_xen_start_timer(vcpu, timeout, true);
 	} else {
 		kvm_xen_stop_timer(vcpu);
 	}
--=20
2.41.0



--=-uEaNanLZ2Wqf9/iQiKHI
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkQw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhQwggT8oAMCAQICEQDGvhmWZ0DEAx0oURL6O6l+MA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3GpC2bomUqk+91wLYBzDMcCj5C9m6
oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZHh7htyAkWYVoFsFPrwHounto8xTsy
SSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT9YgcBqKCo65pTFmOnR/VVbjJk4K2
xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNjP+qDrh0db7PAjO1D4d5ftfrsf+kd
RR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy2U+eITZ5LLE5s45mX2oPFknWqxBo
bQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3BgBEmfsYWlBXO8rVXfvPgLs32VdV
NZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/7auNVRmPB3v5SWEsH8xi4Bez2V9U
KxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmdlFYhAflWKQ03Ufiu8t3iBE3VJbc2
5oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9aelIl6vtbhMA+l0nfrsORMa4kobqQ5
C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMBAAGjggHMMIIByDAfBgNVHSMEGDAW
gBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeDMcimo0oz8o1R1Nver3ZVpSkwDgYD
VR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGln
by5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUFBwEB
BH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50
QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0B
AQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQvQ/fzPXmtR9t54rpmI2TfyvcKgOXp
qa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvIlSPrzIB4Z2wyIGQpaPLlYflrrVFK
v9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9ChWFfgSXvrWDZspnU3Gjw/rMHrGnql
Htlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0whpBtXdyDjzBtQTaZJ7zTT/vlehc/
tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9IzCCBhQwggT8oAMCAQICEQDGvhmW
Z0DEAx0oURL6O6l+MA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTIyMDEwNzAwMDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJ
ARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3
GpC2bomUqk+91wLYBzDMcCj5C9m6oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZH
h7htyAkWYVoFsFPrwHounto8xTsySSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT
9YgcBqKCo65pTFmOnR/VVbjJk4K2xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNj
P+qDrh0db7PAjO1D4d5ftfrsf+kdRR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy
2U+eITZ5LLE5s45mX2oPFknWqxBobQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3
BgBEmfsYWlBXO8rVXfvPgLs32VdVNZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/
7auNVRmPB3v5SWEsH8xi4Bez2V9UKxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmd
lFYhAflWKQ03Ufiu8t3iBE3VJbc25oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9ae
lIl6vtbhMA+l0nfrsORMa4kobqQ5C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMB
AAGjggHMMIIByDAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeD
Mcimo0oz8o1R1Nver3ZVpSkwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9j
cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1h
aWxDQS5jcmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdv
LmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAj
BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQv
Q/fzPXmtR9t54rpmI2TfyvcKgOXpqa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvI
lSPrzIB4Z2wyIGQpaPLlYflrrVFKv9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9Ch
WFfgSXvrWDZspnU3Gjw/rMHrGnqlHtlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0w
hpBtXdyDjzBtQTaZJ7zTT/vlehc/tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9
IzGCBMcwggTDAgEBMIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMT
NVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA
xr4ZlmdAxAMdKFES+jupfjANBglghkgBZQMEAgEFAKCCAeswGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMxMDI3MTU1NTQyWjAvBgkqhkiG9w0BCQQxIgQgwdMbLi+9
5PKXDc3XRXeZagwROuQHU8Mn/lTqdmG7UMwwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAGDElBy/NEX2b1JTL1nGRLfRD3To4TMzfr
30/Q6qhMS1uAakrN7tx/gQrDPWBgFHxRbDXzqw/zQaHy2L30UIwXB+5UTa4/afciOuk+UtZB5DYL
fFbbOiolM/a5amjUrlNkmmUICDD/sGDVhw+JktxhHqvHenSytZUqonuDglkm1krbl9AleXIRZ96j
H8CxM10+fYdNAny05s1txyAhiDGsdGh6pPbVRzyfvdxkMz5XAaFQsYRVavAmL98gXhLQ5Bt0wSt+
XvvILa1EuUHGGkWOmZ6fnlz0x3j+1jvYv2vul38CYv3D1dlv8hiYO/qD92JCrqezxOLCjXCuoDw5
uKN0W16S4VfQp2I7YDl5c1bRyncwJ4tTV9LLpos2TLmIzennUqgtaQokDL4nf3pco1ttVRJTz1Fu
xBukl/QW/90IBLOkmi1hiyoL3Pxp4vc4tZNhayBcTtLam5r3PAqSTFWstBRd9Z1FbzLPlwGiLPVt
crArOijH2ONCXOCFFtfuFt7QYQhbPwNWPNRQh4VN+NNzPA3nsPrFnwWivV8RToNDO+fmBTcJsJ8I
2HNvRn/xy2IKyNfTeYisGa104L64RwUMGSEEVvwvdNhb1yvdzDREr+N0Y3LEkw/jvrsK1i21a0EX
TbBMKLNN0318Krrpz72EYiuPuuWZhsBu51vytRW24AAAAAAAAA==


--=-uEaNanLZ2Wqf9/iQiKHI--
