Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD4B4D377F
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbiCIQv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 11:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236048AbiCIQqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 11:46:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CABB1017D1
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 08:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yAU7nj+t/e+cuIq6A3PyePlQneRj/+qOxTa586BTfPc=; b=Q2biUWdr6mSeyaqs0XkFb8x0pc
        GTu5tQWrvuV/VoTBs2hCEv9cDO973AzAz6SSDLJLFm0sQn4fSozy/4Px4hRX6pzBO9rlDtzmjJmsW
        zm6w8jr4Sn2ue07h398V4sw8dPmyG+1q2sHMdwiZLpCK62sL6jj15v9WSHZ0CS04FtX24IsnAJKAW
        yNdgblwGSeOUvxGl6Uok1J7tMplUnDGHcINCkTCXJ/VyM1ic+pd59l9yrYzKsdq70HgTTsBkiT4Wf
        nOycUIulPpL450eZDqWmFfpRXK4Vjq/n7K9JnCzl1Jr10agSziekBii576cYx3fjrcxBDyryicG7K
        g4GgO+7Q==;
Received: from [54.239.6.184] (helo=u3832b3a9db3152.drs11.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRzNa-00HIyA-EH; Wed, 09 Mar 2022 16:41:38 +0000
Message-ID: <0709ac62f664c0f3123fcdeabed3b79038cef3b6.camel@infradead.org>
Subject: [PATCH v2 1/2] KVM: x86/xen: PV oneshot timer fixes
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Date:   Wed, 09 Mar 2022 17:41:37 +0100
In-Reply-To: <846caa99-2e42-4443-1070-84e49d2f11d2@redhat.com>
References: <20220309143835.253911-1-dwmw2@infradead.org>
         <20220309143835.253911-2-dwmw2@infradead.org>
         <846caa99-2e42-4443-1070-84e49d2f11d2@redhat.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-fACWAyRzrdBEGxxl+Cdx"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-fACWAyRzrdBEGxxl+Cdx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

Fix the case where a restored timer is supposed to have triggered not
just in the past, but before this kernel even booted. The resulting
integer wrap caused the timer to be set a very long time into the future,
and thus effectively never trigger. Trigger timers immediately when
delta_ns <=3D 0 to avoid that situation.

Also switch to using HRTIMER_MODE_ABS_HARD, following the changes in the
local APIC timer in commits 2c0d278f3293f ("KVM: LAPIC: Mark hrtimer to
expire in hard interrupt context") and 4d151bf3b89e7 ("KVM: LAPIC: Make
lapic timer unpinned"). Since we only support the Xen oneshot timer and
not the periodic timer, we also don't need to bother with migrating it
from one physical CPU to another when the vCPU moves; it'll get started
again soon enough anyway.

When the timer fires, set the recorded expiry time to zero so that when
userspace queries the state it correctly sees zero in the expires_ns to
indicate that the timer isn't active, and avoid duplicate events after
live migration / live update.

Finally, fix the 'delta' in kvm_xen_hcall_set_timer_op() to explicitly
use 'int64_t' instead of 'long' to make the sanity check shift by 50
bits work correctly in the 32-bit build. That last one was

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---

On Wed, 2022-03-09 at 16:39 +0100, Paolo Bonzini wrote:
> This is still racy.

Thanks for the review! Better?


 arch/x86/kvm/irq.c |  1 -
 arch/x86/kvm/xen.c | 44 +++++++++++++-------------------------------
 arch/x86/kvm/xen.h |  1 -
 3 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index af2d26fc5458..f371f1292ca3 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -156,7 +156,6 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 {
 	__kvm_migrate_apic_timer(vcpu);
 	__kvm_migrate_pit_timer(vcpu);
-	__kvm_migrate_xen_timer(vcpu);
 	static_call_cond(kvm_x86_migrate_timers)(vcpu);
 }
=20
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 8c85a71aa8ca..7e7c8a5bff52 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -122,6 +122,8 @@ void kvm_xen_inject_timer_irqs(struct kvm_vcpu *vcpu)
 		e.priority =3D KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
=20
 		kvm_xen_set_evtchn(&e, vcpu->kvm);
+
+		vcpu->arch.xen.timer_expires =3D 0;
 		atomic_set(&vcpu->arch.xen.timer_pending, 0);
 	}
 }
@@ -130,19 +132,9 @@ static enum hrtimer_restart xen_timer_callback(struct =
hrtimer *timer)
 {
 	struct kvm_vcpu *vcpu =3D container_of(timer, struct kvm_vcpu,
 					     arch.xen.timer);
-	struct kvm_xen_evtchn e;
-
 	if (atomic_read(&vcpu->arch.xen.timer_pending))
 		return HRTIMER_NORESTART;
=20
-	e.vcpu_id =3D vcpu->vcpu_id;
-	e.vcpu_idx =3D vcpu->vcpu_idx;
-	e.port =3D vcpu->arch.xen.timer_virq;
-	e.priority =3D KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
-
-	if (kvm_xen_set_evtchn_fast(&e, vcpu->kvm) !=3D -EWOULDBLOCK)
-		return HRTIMER_NORESTART;
-
 	atomic_inc(&vcpu->arch.xen.timer_pending);
 	kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
 	kvm_vcpu_kick(vcpu);
@@ -150,29 +142,19 @@ static enum hrtimer_restart xen_timer_callback(struct=
 hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
=20
-void __kvm_migrate_xen_timer(struct kvm_vcpu *vcpu)
-{
-	struct hrtimer *timer;
-
-	if (!kvm_xen_timer_enabled(vcpu))
-		return;
-
-	timer =3D &vcpu->arch.xen.timer;
-	if (hrtimer_cancel(timer))
-		hrtimer_start_expires(timer, HRTIMER_MODE_ABS_PINNED);
-}
-
-static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, u64 =
delta_ns)
+static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, s64 =
delta_ns)
 {
-	ktime_t ktime_now;
-
 	atomic_set(&vcpu->arch.xen.timer_pending, 0);
 	vcpu->arch.xen.timer_expires =3D guest_abs;
=20
-	ktime_now =3D ktime_get();
-	hrtimer_start(&vcpu->arch.xen.timer,
-		      ktime_add_ns(ktime_now, delta_ns),
-		      HRTIMER_MODE_ABS_PINNED);
+	if (delta_ns <=3D 0) {
+		xen_timer_callback(&vcpu->arch.xen.timer);
+	} else {
+		ktime_t ktime_now =3D ktime_get();
+		hrtimer_start(&vcpu->arch.xen.timer,
+			      ktime_add_ns(ktime_now, delta_ns),
+			      HRTIMER_MODE_ABS_HARD);
+	}
 }
=20
 static void kvm_xen_stop_timer(struct kvm_vcpu *vcpu)
@@ -185,7 +167,7 @@ static void kvm_xen_stop_timer(struct kvm_vcpu *vcpu)
 static void kvm_xen_init_timer(struct kvm_vcpu *vcpu)
 {
 	hrtimer_init(&vcpu->arch.xen.timer, CLOCK_MONOTONIC,
-		     HRTIMER_MODE_ABS_PINNED);
+		     HRTIMER_MODE_ABS_HARD);
 	vcpu->arch.xen.timer.function =3D xen_timer_callback;
 }
=20
@@ -1204,7 +1186,7 @@ static bool kvm_xen_hcall_set_timer_op(struct kvm_vcp=
u *vcpu, uint64_t timeout,
=20
 	if (timeout) {
 		uint64_t guest_now =3D get_kvmclock_ns(vcpu->kvm);
-		long delta =3D timeout - guest_now;
+		int64_t delta =3D timeout - guest_now;
=20
 		/* Xen has a 'Linux workaround' in do_set_timer_op() which
 		 * checks for negative absolute timeout values (caused by
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index ad0876a7c301..2bbbc1a3953e 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -75,7 +75,6 @@ static inline int kvm_xen_has_pending_timer(struct kvm_vc=
pu *vcpu)
 	return 0;
 }
=20
-void __kvm_migrate_xen_timer(struct kvm_vcpu *vcpu);
 void kvm_xen_inject_timer_irqs(struct kvm_vcpu *vcpu);
 #else
 static inline int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 =
data)
--=20
2.33.1


--=-fACWAyRzrdBEGxxl+Cdx
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIwMzA5MTY0MTM3WjAvBgkqhkiG9w0BCQQxIgQgjLrUIc7a
mAtIjtrp1DovOr6KIYapxgvcDkZd745zle4wgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgB5AjEEFUDKBHu9kHl6mw+DLFDuHkuILrFZ
mItTwlQpqVQzRs9x4//BWPSZnnn7i4QdYMz8JUbD64Fu2QZbESSkCdUUaEdlNf/9hWmm7LxFY1Nx
W0pDv6Z8h2X6RBr7yiQGG4njX38guRNPa3J0htqH5Sqlxsp77iiXnvdAnjng5ru5+1HP1y6aHSv6
+E3nkeIc0Yi/GI1ZxVYnk/quNu76GT3fHX9devAcaVXLS5Br+UlMGhJJbvbwjdGCeuFbZ4KIDwIw
S/vEMf1JJP6LcekLC9pHAxRqj4SrU6tUzghxl/fdss5NlwfhC23wYYQxyOOP6yZpSa0DSgynKHvd
hvz6t2rz8K1vk5vLKEJ11wOl9Ite7DCrP9YZJpXwsSR2G25QUw18dYehtxJnNTl4VYPcsQBvYa+n
aWGJlxclCrSM9g1afmd1LIkRJt3Yqh/BD896XmqbwJjE73xLHI6jMzJURs4BZ20AdIVjHtRhVhgW
metL1pawJcK5NhY7h8988tmJvY+xOi+aLk9XwALd15xiPD4SR8peywGt1Ne+WwNYl4thbtvvK1fk
J0WDZhKKjV43fbYriT8g8WdLmKjeLbsDr9NLdm97ZFdEENtgTBCCGlbpmQYwfMdXbRmj8t2jeN2u
ofHuGPV3Taxnfg8a59e/aHx+DxB+SOKXrokjC8ul3gAAAAAAAA==


--=-fACWAyRzrdBEGxxl+Cdx--

