Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774397B40AC
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 15:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbjI3N6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Sep 2023 09:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjI3N6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Sep 2023 09:58:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22269E;
        Sat, 30 Sep 2023 06:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:Date:Cc:To:
        From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=1vPpvqCVinL9fzTjTNGUlj4myey3yl6y2SPFrWu6ih4=; b=HcEf01AHydDrE8pxRYZKHdPTmx
        Z9qHuAeBAYxa+TPzHviQ3l2Aen5HCg1wvmHrcVsCcVU0MzmRBrpxtdaJA3QaRjWFYSB+234GW253T
        8zkAiDx+e1zSNUL+7FEQGFoaIyhyyjSqtdHbINFSaClgzbqNt06j13VXFG/3qPV87Kf63EcHtgu/r
        dIrMltvvNLRgD91KeJLUiPGteycM0IXLW9B3Ar+hRsCkB5sB7RA35JCc6U4CKf8g3DZCXLDnROJVh
        iUAlgPa+hWYItb2kTsqhRKpKE0A8UTdPAv12jm0gGKAoG8m5wmwQTcGTH8VPFk4O8k7ppUMXVvl82
        ABNR1tJw==;
Received: from 54-240-197-238.amazon.com ([54.240.197.238] helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qmaUP-00FEqW-Rx; Sat, 30 Sep 2023 13:58:38 +0000
Message-ID: <f21ee3bd852761e7808240d4ecaec3013c649dc7.camel@infradead.org>
Subject: [PATCH v3] KVM: x86: Use fast path for Xen timer delivery
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm <kvm@vger.kernel.org>
Cc:     Paul Durrant <paul@xen.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Date:   Sat, 30 Sep 2023 14:58:35 +0100
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-7O1krAcrKpuOyM+gWZH9"
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


--=-7O1krAcrKpuOyM+gWZH9
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
was first added. The current code holds vcpu->mutex for all operations
on the kvm->arch.timer_expires field, and the fast path introduces a
potential race condition. Avoid that race by ensuring the hrtimer is
(temporarily) cancelled before making changes in kvm_xen_start_timer(),
and also when reading the values out for KVM_XEN_VCPU_ATTR_TYPE_TIMER.

=C2=B9 https://lore.kernel.org/kvm/846caa99-2e42-4443-1070-84e49d2f11d2@red=
hat.com/

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 =E2=80=A2 v2: Remember, and deal with, those races.=20

 =E2=80=A2 v3: Drop the assertions for vcpu being loaded; those can be done
       separately if at all.

       Reorder the code in xen_timer_callback() to make it clearer
       that kvm->arch.xen.timer_expires is being cleared in the case
       where the event channel delivery is *complete*, as opposed to
       the -EWOULDBLOCK deferred path.

       Drop the 'pending' variable in kvm_xen_vcpu_get_attr() and
       restart the hrtimer if (kvm->arch.xen.timer_expires), which
       ought to be exactly the same thing (that's the *point* in
       cancelling the timer, to make it truthful as we return its
       value to userspace).      =20

       Improve comments.

 arch/x86/kvm/xen.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 40edf4d1974c..75586da134b3 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -134,9 +134,23 @@ static enum hrtimer_restart xen_timer_callback(struct =
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
+	e.vcpu_id =3D vcpu->vcpu_id;
+	e.vcpu_idx =3D vcpu->vcpu_idx;
+	e.port =3D vcpu->arch.xen.timer_virq;
+	e.priority =3D KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
+
+	rc =3D kvm_xen_set_evtchn_fast(&e, vcpu->kvm);
+	if (rc !=3D -EWOULDBLOCK) {
+		vcpu->arch.xen.timer_expires =3D 0;
+		return HRTIMER_NORESTART;
+	}
+
 	atomic_inc(&vcpu->arch.xen.timer_pending);
 	kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
 	kvm_vcpu_kick(vcpu);
@@ -146,6 +160,14 @@ static enum hrtimer_restart xen_timer_callback(struct =
hrtimer *timer)
=20
 static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, s64 =
delta_ns)
 {
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
@@ -1019,9 +1041,36 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, str=
uct kvm_xen_vcpu_attr *data)
 		break;
=20
 	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
+		/*
+		 * Ensure a consistent snapshot of state is captured, with a
+		 * timer either being pending, or the event channel delivered
+		 * to the corresponding bit in the shared_info. Not still
+		 * lurking in the timer_pending flag for deferred delivery.
+		 * Purely as an optimisation, if the timer_expires field is
+		 * zero, that means the timer isn't active (or even in the
+		 * timer_pending flag) and there is no need to cancel it.
+		 */
+		if (vcpu->arch.xen.timer_expires) {
+			hrtimer_cancel(&vcpu->arch.xen.timer);
+			kvm_xen_inject_timer_irqs(vcpu);
+		}
+
 		data->u.timer.port =3D vcpu->arch.xen.timer_virq;
 		data->u.timer.priority =3D KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
 		data->u.timer.expires_ns =3D vcpu->arch.xen.timer_expires;
+
+		/*
+		 * The hrtimer may trigger and raise the IRQ immediately,
+		 * while the returned state causes it to be set up and
+		 * raised again on the destination system after migration.
+		 * That's fine, as the guest won't even have had a chance
+		 * to run and handle the interrupt. Asserting an already
+		 * pending event channel is idempotent.
+		 */
+		if (vcpu->arch.xen.timer_expires)
+			hrtimer_start_expires(&vcpu->arch.xen.timer,
+					      HRTIMER_MODE_ABS_HARD);
+
 		r =3D 0;
 		break;
=20
--=20
2.40.1



--=-7O1krAcrKpuOyM+gWZH9
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwOTMwMTM1ODM1WjAvBgkqhkiG9w0BCQQxIgQgaluScEEg
2ERxGxkAMexOivoEtcilBNM1KbKc2Y5/tOMwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgA7+f+JR9lbxZoL/06qyulYfXNp70iOmvnS
qGBU5/OXPcz+IkLkBRAHrJpFl2nKTTZ5gP+UhayVQZAcqVIH6EJnPdwG3ybE9rkD9Z/WvyGWLgVX
e+pF0dZs77/WI0+AtWMFZ+gZfmRk1AJ1kgwyq3I/AbjxpcybtoTzZaCo37CcHwQInCkciFtkaHnv
zP97+38aoFb752aMNRN4xk7nx86ES94bzMX56xJwAga/nbJF2zJHRXnWLC13VWLKayf1OkRJ1aS0
AqdEn0z+sd8l17i6CpXbCA7r8lRUfJmxg635LymBGn2P8dRK3/nIs+yX4PsbjEWqIvxoRU3d3RBz
M5rXUdXaESTjVYYXaAvoCyHWp32HRd6DqpAUyHyQAaViJv5ZKgkNq0TIldLkKKeGTyRlhu+GPpSD
P482k6kdecMvla20KvIefGuhUQb18fVQ1QKL2V7nzSBa7BXA9HYyJC30ovbImrqorIK4GClcOp8s
yf3h3BpaHVCScBIUx5wOP1fiwlmau3jGK9Z4nVfG1nCjP2Fo4gb13cF7xqD/Oz7Bvcseu+pjwZ5P
Qi/h/RpjK+dNIzN1vgARKy0m6TkXlbhKWDTSdwqcxQBWGvntz9T+wQZLxZ+V77d4rXhO6NGD34Uj
Ej52wBIMEIk/0gOUFFjq6bPDS1tQ6juFvxQT90/GrgAAAAAAAA==


--=-7O1krAcrKpuOyM+gWZH9--
