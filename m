Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6295464CB73
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 14:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbiLNNiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 08:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238029AbiLNNiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 08:38:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F84326496
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 05:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:Date:Cc:To:
        From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=xdTA+SLOx6R/kGt+Qr2XXkNYr7GIxi31HinR0g33OPM=; b=fGuc5zUKGx7qC6NvptT9B0RETs
        lNIFambGphvCwCsOw8vmOIR2RTGpeRgglEj2OdOsMpf3U4B9ljzD7CrcSlx9L7UjLccoMKgYf/Yt0
        XLsnFkInQKpXQJjTBWHDUviwf4ICZPO37yNprLNO63y5zK/kZ0wWF/S9WNZd4xMhFNAYzXWY8Uu/p
        4fwO/r21LayDG/d8vgRxNSUYfjBWo9NfMgy3pVA4WKoTlZv5ZvurWPCsXkiBIT5SKabS5jum/cUSA
        Q4eXCe4gcy78vo1INtnar29hN/Q45f8YcDdUn27ua3jvNDA2Tj4rg/MPCYD+yQnKbApcJVmB74lAq
        1RWDxwww==;
Received: from [2001:8b0:10b:5::bb3] (helo=u3832b3a9db3152.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p5Rxh-00DHbY-B8; Wed, 14 Dec 2022 13:38:17 +0000
Message-ID: <d52040a8d46e68efd86273be66808fe4a8c70e1d.camel@infradead.org>
Subject: [PATCH] KVM: x86/xen: Use kvm_read_guest_virt() instead of
 open-coding it badly
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paul Durrant <paul@xen.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Date:   Wed, 14 Dec 2022 13:38:07 +0000
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-lGnA83EN7EVnOl3lJxxg"
User-Agent: Evolution 3.36.5-0ubuntu1 
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


--=-lGnA83EN7EVnOl3lJxxg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

In particular, we shouldn't assume that being contiguous in guest virtual
address space means being contiguous in guest *physical* address space.

In dropping the manual calls to kvm_mmu_gva_to_gpa_system(), also drop
the srcu_read_lock() that was around them. All call sites are reached
from kvm_xen_hypercall() which is called from the handle_exit function
with the read lock already held.

Fixes: 2fd6df2f2 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
       536395260 ("KVM: x86/xen: handle PV timers oneshot mode")
       1a65105a5 ("KVM: x86/xen: handle PV spinlocks slowpath")

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
Spotted the same issue in the QEMU patches while working through them:
https://git.infradead.org/users/dwmw2/qemu.git/shortlog/refs/heads/xenfv
Then realised it was like that in the kernel too.

 arch/x86/kvm/xen.c | 56 +++++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d7af40240248..5be1090b2317 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1183,30 +1183,22 @@ static bool wait_pending_event(struct kvm_vcpu *vcp=
u, int nr_ports,
 static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, bool longmode,
 				 u64 param, u64 *r)
 {
-	int idx, i;
 	struct sched_poll sched_poll;
 	evtchn_port_t port, *ports;
-	gpa_t gpa;
+	struct x86_exception e;
+	int i;
=20
 	if (!lapic_in_kernel(vcpu) ||
 	    !(vcpu->kvm->arch.xen_hvm_config.flags & KVM_XEN_HVM_CONFIG_EVTCHN_SE=
ND))
 		return false;
=20
-	idx =3D srcu_read_lock(&vcpu->kvm->srcu);
-	gpa =3D kvm_mmu_gva_to_gpa_system(vcpu, param, NULL);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	if (!gpa) {
-		*r =3D -EFAULT;
-		return true;
-	}
-
 	if (IS_ENABLED(CONFIG_64BIT) && !longmode) {
 		struct compat_sched_poll sp32;
=20
 		/* Sanity check that the compat struct definition is correct */
 		BUILD_BUG_ON(sizeof(sp32) !=3D 16);
=20
-		if (kvm_vcpu_read_guest(vcpu, gpa, &sp32, sizeof(sp32))) {
+		if (kvm_read_guest_virt(vcpu, param, &sp32, sizeof(sp32), &e)) {
 			*r =3D -EFAULT;
 			return true;
 		}
@@ -1220,8 +1212,8 @@ static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcp=
u, bool longmode,
 		sched_poll.nr_ports =3D sp32.nr_ports;
 		sched_poll.timeout =3D sp32.timeout;
 	} else {
-		if (kvm_vcpu_read_guest(vcpu, gpa, &sched_poll,
-					sizeof(sched_poll))) {
+		if (kvm_read_guest_virt(vcpu, param, &sched_poll,
+					sizeof(sched_poll), &e)) {
 			*r =3D -EFAULT;
 			return true;
 		}
@@ -1243,18 +1235,13 @@ static bool kvm_xen_schedop_poll(struct kvm_vcpu *v=
cpu, bool longmode,
 	} else
 		ports =3D &port;
=20
+	if (kvm_read_guest_virt(vcpu, (gva_t)sched_poll.ports, ports,
+				sched_poll.nr_ports * sizeof(*ports), &e)) {
+		*r =3D -EFAULT;
+		return true;
+	}
+
 	for (i =3D 0; i < sched_poll.nr_ports; i++) {
-		idx =3D srcu_read_lock(&vcpu->kvm->srcu);
-		gpa =3D kvm_mmu_gva_to_gpa_system(vcpu,
-						(gva_t)(sched_poll.ports + i),
-						NULL);
-		srcu_read_unlock(&vcpu->kvm->srcu, idx);
-
-		if (!gpa || kvm_vcpu_read_guest(vcpu, gpa,
-						&ports[i], sizeof(port))) {
-			*r =3D -EFAULT;
-			goto out;
-		}
 		if (ports[i] >=3D max_evtchn_port(vcpu->kvm)) {
 			*r =3D -EINVAL;
 			goto out;
@@ -1330,9 +1317,8 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vc=
pu, bool longmode, int cmd,
 				  int vcpu_id, u64 param, u64 *r)
 {
 	struct vcpu_set_singleshot_timer oneshot;
+	struct x86_exception e;
 	s64 delta;
-	gpa_t gpa;
-	int idx;
=20
 	if (!kvm_xen_timer_enabled(vcpu))
 		return false;
@@ -1343,9 +1329,6 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vc=
pu, bool longmode, int cmd,
 			*r =3D -EINVAL;
 			return true;
 		}
-		idx =3D srcu_read_lock(&vcpu->kvm->srcu);
-		gpa =3D kvm_mmu_gva_to_gpa_system(vcpu, param, NULL);
-		srcu_read_unlock(&vcpu->kvm->srcu, idx);
=20
 		/*
 		 * The only difference for 32-bit compat is the 4 bytes of
@@ -1363,9 +1346,8 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vc=
pu, bool longmode, int cmd,
 		BUILD_BUG_ON(sizeof_field(struct compat_vcpu_set_singleshot_timer, flags=
) !=3D
 			     sizeof_field(struct vcpu_set_singleshot_timer, flags));
=20
-		if (!gpa ||
-		    kvm_vcpu_read_guest(vcpu, gpa, &oneshot, longmode ? sizeof(oneshot) =
:
-					sizeof(struct compat_vcpu_set_singleshot_timer))) {
+		if (kvm_read_guest_virt(vcpu, param, &oneshot, longmode ? sizeof(oneshot=
) :
+					sizeof(struct compat_vcpu_set_singleshot_timer), &e)) {
 			*r =3D -EFAULT;
 			return true;
 		}
@@ -2002,14 +1984,12 @@ static bool kvm_xen_hcall_evtchn_send(struct kvm_vc=
pu *vcpu, u64 param, u64 *r)
 {
 	struct evtchnfd *evtchnfd;
 	struct evtchn_send send;
-	gpa_t gpa;
-	int idx;
+	struct x86_exception e;
=20
-	idx =3D srcu_read_lock(&vcpu->kvm->srcu);
-	gpa =3D kvm_mmu_gva_to_gpa_system(vcpu, param, NULL);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	/* Sanity check: this structure is the same for 32-bit and 64-bit */
+	BUILD_BUG_ON(sizeof(send) !=3D 4);
=20
-	if (!gpa || kvm_vcpu_read_guest(vcpu, gpa, &send, sizeof(send))) {
+	if (kvm_read_guest_virt(vcpu, param, &send, sizeof(send), &e)) {
 		*r =3D -EFAULT;
 		return true;
 	}
--=20
2.25.1


--=-lGnA83EN7EVnOl3lJxxg
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIxMjE0MTMzODA3WjAvBgkqhkiG9w0BCQQxIgQguD4udYgW
pCwxYXxjjq/nN3CnR58LDUblojdeNAK9xwwwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgACAVmaS3+DA1DkzJpHNKrVJkPe+StavJns
dq/xn7vfOEfVxl3D7X34WGng/6267IYDE7+NQcVQ/sr1RpWefhu5kwkAz/YU/3sA0fsyqV3Nv1FH
ecydTU/APOrQVxi5oL5rkQTfF95r7ctW5BCUOe0Mi+6F5EUTkd//OsuTr/5Gtr8MO2hBkPg+5f2Q
LC6apcKV1NSw1t7q0UKz9zP/7fq8d/gNhPWGPEVO5h0/+6S6ipKrYcopm/BXJncAJxhgBldgW1z0
Upi+cA3pUEfVi8nfvMuLzT9PVJM5GAPMsIcTsxtTD1ywpvHScFSL7VxUzDeRHgl01xPiK4jk3wmh
rxKyDnB8cjTNmFjBQ+9yqcnVp6SovdKmYXTU53ewetYUGs/n4zEtl/J6pElL3inGDMMXQk8shFjm
UlBFYtJJ0S1VRyeOquy2hYiQKcowvjSu4w8K6yYh17ZFiknER6Tk4sP3asjv58Tc3k1NFiWikpPx
B52e5wZXZ8Jwd0dADx8rwQZUgNh3pPreYXLjAOrrWQ/CDPEi3eV/w8PHvwXAvcoIbpniXjDALyXD
2HRWDdaIipDeXsnTiXYKKeusk4VqcJ95cefbr0B+5/RWEYuWZsyBhzCow4+G9d9dQFTfVfzGtkWz
TOLbCrXYIGLm76vjhtUlDkhyfieLjPmt4QQxvA0tawAAAAAAAA==


--=-lGnA83EN7EVnOl3lJxxg--

