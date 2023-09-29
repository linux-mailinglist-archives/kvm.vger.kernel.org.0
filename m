Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FEC7B3180
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 13:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbjI2LgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 07:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjI2LgW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 07:36:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D334994;
        Fri, 29 Sep 2023 04:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:Date:Cc:To:
        From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=I2cLa0h+lpUltv1ermPtkAdKnpzp55fdUDyoi6QPbL8=; b=YX+nwm42ViiId2g8DvolBSNKhe
        1mFEo5ozSU7REOu5JV2XHxXH1BwQotm8rybzbCRx0WeWNYGXsG0bcj9R9G9zgtKJZQHDS0j2xhbW5
        yZygqM+EdPDQYIhJMb2EsCSL7jaPfO3LxZhYwsxTauiZQeZeGIOdtwoqeDSZ+gGs74HdyJfa5TWka
        8S//UM4YOE0mVyM8YVWQDGoCmJyqmitho6rgtJtWLbLxRqZ8Pr5No0aqG+RmVdUc8xoiC4Y2l0UFN
        lpp0cl9nZilJ7mpfnfoMsh7nx4Jxj0iFYlu7d2mRckJiEBki+E21CTfgAShE7R3kTwPAV3EIl91zg
        xYicVcew==;
Received: from [2001:8b0:10b:5:379a:6ec5:d16c:614] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qmBn3-008VwF-Ke; Fri, 29 Sep 2023 11:36:15 +0000
Message-ID: <a3989e7ff9cca77f680f9bdfbaee52b707693221.camel@infradead.org>
Subject: [PATCH v2] KVM: x86: Use fast path for Xen timer delivery
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm <kvm@vger.kernel.org>
Cc:     David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Date:   Fri, 29 Sep 2023 12:36:11 +0100
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-JOnWxlw7bvKzdu4tv5HM"
User-Agent: Evolution 3.44.4-0ubuntu2 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-JOnWxlw7bvKzdu4tv5HM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

Most of the time there's no need to kick the vCPU and deliver the timer
event through kvm_xen_inject_timer_irqs(). Use kvm_xen_set_evtchn_fast()
directly from the timer callback, and only fall back to the slow path
when it's necessary to do so.

This gives a significant improvement in timer latency testing (using
nanosleep() for various periods and then measuring the actual time
elapsed).

However, there was a reason=C2=B9 the fast path was dropped when this suppo=
rt
was first added. The current code holds vcpu->mutex for all operations on
the kvm->arch.timer_expires field, and the fast path introduces potential
race conditions. So... ensure the hrtimer is *cancelled* before making
changes in kvm_xen_start_timer(), and also when reading the values out
for KVM_XEN_VCPU_ATTR_TYPE_TIMER.

Add some sanity checks to ensure the truth of the claim that all the
other code paths are run with the vcpu loaded. And use hrtimer_cancel()
directly from kvm_xen_destroy_vcpu() to avoid a false positive from the
check in kvm_xen_stop_timer().

=C2=B9 https://lore.kernel.org/kvm/846caa99-2e42-4443-1070-84e49d2f11d2@red=
hat.com/

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---

 =E2=80=A2 v2: Remember, and deal with, those races.

 arch/x86/kvm/xen.c | 64 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index fb1110b2385a..9d0d602a2466 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -117,6 +117,8 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gf=
n_t gfn)
=20
 void kvm_xen_inject_timer_irqs(struct kvm_vcpu *vcpu)
 {
+	WARN_ON_ONCE(vcpu !=3D kvm_get_running_vcpu());
+
 	if (atomic_read(&vcpu->arch.xen.timer_pending) > 0) {
 		struct kvm_xen_evtchn e;
=20
@@ -136,18 +138,41 @@ static enum hrtimer_restart xen_timer_callback(struct=
 hrtimer *timer)
 {
 	struct kvm_vcpu *vcpu =3D container_of(timer, struct kvm_vcpu,
 					     arch.xen.timer);
+	struct kvm_xen_evtchn e;
+	int rc;
+
 	if (atomic_read(&vcpu->arch.xen.timer_pending))
 		return HRTIMER_NORESTART;
=20
-	atomic_inc(&vcpu->arch.xen.timer_pending);
-	kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
-	kvm_vcpu_kick(vcpu);
+	e.vcpu_id =3D vcpu->vcpu_id;
+	e.vcpu_idx =3D vcpu->vcpu_idx;
+	e.port =3D vcpu->arch.xen.timer_virq;
+	e.priority =3D KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
+
+	rc =3D kvm_xen_set_evtchn_fast(&e, vcpu->kvm);
+	if (rc =3D=3D -EWOULDBLOCK) {
+		atomic_inc(&vcpu->arch.xen.timer_pending);
+		kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
+		kvm_vcpu_kick(vcpu);
+	} else {
+		vcpu->arch.xen.timer_expires =3D 0;
+	}
=20
 	return HRTIMER_NORESTART;
 }
=20
 static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, s64 =
delta_ns)
 {
+	WARN_ON_ONCE(vcpu !=3D kvm_get_running_vcpu());
+
+	/*
+	 * Avoid races with the old timer firing. Checking timer_expires
+	 * to avoid calling hrtimer_cancel() will only have false positives
+	 * so is fine.
+	 */
+	if (vcpu->arch.xen.timer_expires)
+		hrtimer_cancel(&vcpu->arch.xen.timer);
+
 	atomic_set(&vcpu->arch.xen.timer_pending, 0);
 	vcpu->arch.xen.timer_expires =3D guest_abs;
=20
@@ -163,6 +188,8 @@ static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, =
u64 guest_abs, s64 delta_
=20
 static void kvm_xen_stop_timer(struct kvm_vcpu *vcpu)
 {
+	WARN_ON_ONCE(vcpu !=3D kvm_get_running_vcpu());
+
 	hrtimer_cancel(&vcpu->arch.xen.timer);
 	vcpu->arch.xen.timer_expires =3D 0;
 	atomic_set(&vcpu->arch.xen.timer_pending, 0);
@@ -1019,13 +1046,38 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, st=
ruct kvm_xen_vcpu_attr *data)
 		r =3D 0;
 		break;
=20
-	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
+	case KVM_XEN_VCPU_ATTR_TYPE_TIMER: {
+		bool pending =3D false;
+
+		/*
+		 * Ensure a consistent snapshot of state is captures, with a
+		 * timer either being pending, or fully delivered. Not still
+		 * lurking in the timer_pending flag for deferred delivery.
+		 */
+		if (vcpu->arch.xen.timer_expires) {
+			pending =3D hrtimer_cancel(&vcpu->arch.xen.timer);
+			kvm_xen_inject_timer_irqs(vcpu);
+		}
+
 		data->u.timer.port =3D vcpu->arch.xen.timer_virq;
 		data->u.timer.priority =3D KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
 		data->u.timer.expires_ns =3D vcpu->arch.xen.timer_expires;
+
+		/*
+		 * The timer may be delivered immediately, while the returned
+		 * state causes it to be set up and delivered again on the
+		 * destination system after migration. That's fine, as the
+		 * guest will not even have had a chance to run and process
+		 * the interrupt by that point, so it won't even notice the
+		 * duplicate IRQ.
+		 */
+		if (pending)
+			hrtimer_start_expires(&vcpu->arch.xen.timer,
+					      HRTIMER_MODE_ABS_HARD);
+
 		r =3D 0;
 		break;
-
+	}
 	case KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR:
 		data->u.vector =3D vcpu->arch.xen.upcall_vector;
 		r =3D 0;
@@ -2085,7 +2137,7 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 {
 	if (kvm_xen_timer_enabled(vcpu))
-		kvm_xen_stop_timer(vcpu);
+		hrtimer_cancel(&vcpu->arch.xen.timer);
=20
 	kvm_gpc_deactivate(&vcpu->arch.xen.runstate_cache);
 	kvm_gpc_deactivate(&vcpu->arch.xen.runstate2_cache);
--=20
2.40.1



--=-JOnWxlw7bvKzdu4tv5HM
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwOTI5MTEzNjExWjAvBgkqhkiG9w0BCQQxIgQgW3ZqYIsI
u8FX0vtcoB4JZMKsa+RcBaQPZA9+81M+7Cswgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgA5l2KsfjN952xtnJ1OqkKDoOjHP7Xnpouc
ZPBPApWZ8M5cacW8ZkTXIiyC9tj3AinEmSSB4v+Wmy7ry9mEuXVsdCodzzlsFjx5a+5JEkfxvkVa
6PK7lZq+rhrQcO1oPRLS1gLMgv4qReCeLZafcZyJOcflA2M15FEVxeHNONA9ia/pt1U4jmZjsmVM
U3BJBJEn30I2AL7qxTmfNZX6aK/fRtkRWSnBYs9MSrhpl+I2+zN+ObppkoAKiSpG74Wx+dVbIfLp
w+8qIh4/bI+M5psHLD1NEkRzCzcraMEGIHjeNbikE2Gx1brqL85TXLR8dNAdKMV/pcvypzRIBlp9
V36am4+puf0yTgUenKgcp0OzFY6YkjpKaBsNp7+DeJfeMLEcWU1Vr+cVUdJCmGM3SqrY4SXaZwh1
NxcAhVWeoc7K86ngrPu+Dtx7sgfFvIX6E52jcbVTzCRkTtUQp0DB0Ymvba/Y/1o38juwQsYtWY9x
V18YEGfUreeaGXAlgZ7SNeCVUo5mEeiFKZ9IwqLjpm8Y3km1+O6Uo485ukTzPB9Dk43KchPpX+9z
OZFmmB07E1uONFOEnviyZHG+tB7HtIvHQUdcSri+TRhk432E5uivSt+u+Ik+Tpgs/llzj3te3rNY
Ci7eI1DU74A8sj6pU4zt5fdvLq2Jv+lF4/K8eq27nQAAAAAAAA==


--=-JOnWxlw7bvKzdu4tv5HM--
