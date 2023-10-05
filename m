Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B479E7BA69F
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbjJEQjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjJEQiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:38:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445EEA24A;
        Thu,  5 Oct 2023 02:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:Date:Cc:To:
        From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=QfAI7m6yJa+TxGdvW87/6sjYsbBMYOvFikYd7o63kLs=; b=H8S27kV4xK2GZATwUFX//mwM3U
        bQaqOI3oPpERVhfWhJNAne0pnSoJ+/JOzpP1Q8ve2YJiKg0a4xhtFDJjm39mGafuSLyw/PATGxZwf
        GVzjMN3Mv4sKtKhZ1PuD7u4dyg12S9x0p4By1JgREWsqiiFTeUvPL3aArz9QI13MHhI69mcuCEZmj
        G2GNtBC8UHrOrutJizokg/f4wMFBn2b212beZkhGwZYZVL9tgLzR4wc1hczedeUSPRGPBA0wK0UQA
        0/CzsB9MkVQoM9hiw4JOrTT9L5RqhD7SwmQNwvcLhey4I3zg/toT9VdwxKYQQV2aYi4Oad07cz5vo
        cm50EGNw==;
Received: from [2001:8b0:10b:5:ac17:af40:f98e:776c] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qoKSp-008YhI-66; Thu, 05 Oct 2023 09:16:11 +0000
Message-ID: <bfc6d3d7cfb88c47481eabbf5a30a264c58c7789.camel@infradead.org>
Subject: [PATCH v2] KVM: x86: Refine calculation of guest wall clock to use
 a single TSC read
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Thu, 05 Oct 2023 10:16:10 +0100
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-cY2yXwKyBS3Zp7H1PSvf"
User-Agent: Evolution 3.44.4-0ubuntu2 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-cY2yXwKyBS3Zp7H1PSvf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

When populating the guest's PV wall clock information, KVM currently does
a simple 'kvm_get_real_ns() - get_kvmclock_ns(kvm)'. This is an antipattern
which should be avoided; when working with the relationship between two
clocks, it's never correct to obtain one of them "now" and then the other
at a slightly different "now" after an unspecified period of preemption
(which might not even be under the control of the kernel, if this is an
L1 hosting an L2 guest under nested virtualization).

Add a kvm_get_wall_clock_epoch() function to return the guest wall clock
epoch in nanoseconds using the same method as __get_kvmclock() =E2=80=94 by=
 using
kvm_get_walltime_and_clockread() to calculate both the wall clock and KVM
clock time from a *single* TSC reading.

The condition using get_cpu_tsc_khz() is equivalent to the version in
__get_kvmclock() which separately checks for the CONSTANT_TSC feature or
the per-CPU cpu_tsc_khz. Which is what get_cpu_tsc_khz() does anyway.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 =E2=80=A2 v2: Improve comments, zero local_tsc_khz each time round the loo=
p,
       move put_cpu() a little earlier.

 arch/x86/kvm/x86.c | 85 ++++++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.h |  2 ++
 arch/x86/kvm/xen.c |  4 +--
 3 files changed, 82 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a3a02d62aa6a..14267bacd5db 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2331,14 +2331,9 @@ static void kvm_write_wall_clock(struct kvm *kvm, gp=
a_t wall_clock, int sec_hi_o
 	if (kvm_write_guest(kvm, wall_clock, &version, sizeof(version)))
 		return;
=20
-	/*
-	 * The guest calculates current wall clock time by adding
-	 * system time (updated by kvm_guest_time_update below) to the
-	 * wall clock specified here.  We do the reverse here.
-	 */
-	wall_nsec =3D ktime_get_real_ns() - get_kvmclock_ns(kvm);
+	wall_nsec =3D kvm_get_wall_clock_epoch(kvm);
=20
-	wc.nsec =3D do_div(wall_nsec, 1000000000);
+	wc.nsec =3D do_div(wall_nsec, NSEC_PER_SEC);
 	wc.sec =3D (u32)wall_nsec; /* overflow in 2106 guest time */
 	wc.version =3D version;
=20
@@ -3243,6 +3238,82 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	return 0;
 }
=20
+/*
+ * The pvclock_wall_clock ABI tells the guest the wall clock time at
+ * which it started (i.e. its epoch, when its kvmclock was zero).
+ *
+ * In fact those clocks are subtly different; wall clock frequency is
+ * adjusted by NTP and has leap seconds, while the kvmclock is a
+ * simple function of the TSC without any such adjustment.
+ *
+ * Perhaps the ABI should have exposed CLOCK_TAI and a ratio between
+ * that and kvmclock, but even that would be subject to change over
+ * time.
+ *
+ * Attempt to calculate the epoch at a given moment using the *same*
+ * TSC reading via kvm_get_walltime_and_clockread() to obtain both
+ * wallclock and kvmclock times, and subtracting one from the other.
+ *
+ * Fall back to using their values at slightly different moments by
+ * calling ktime_get_real_ns() and get_kvmclock_ns() separately.
+ */
+uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm)
+{
+#ifdef CONFIG_X86_64
+	struct pvclock_vcpu_time_info hv_clock;
+	struct kvm_arch *ka =3D &kvm->arch;
+	unsigned long seq, local_tsc_khz;
+	struct timespec64 ts;
+	uint64_t host_tsc;
+
+	do {
+		seq =3D read_seqcount_begin(&ka->pvclock_sc);
+
+		local_tsc_khz =3D 0;
+		if (!ka->use_master_clock)
+			break;
+
+		/*
+		 * The TSC read and the call to get_cpu_tsc_khz() must happen
+		 * on the same CPU.
+		 */
+		get_cpu();
+
+		local_tsc_khz =3D get_cpu_tsc_khz();
+
+		if (local_tsc_khz &&
+		    !kvm_get_walltime_and_clockread(&ts, &host_tsc))
+			local_tsc_khz =3D 0; /* Fall back to old method */
+
+		put_cpu();
+
+		/*
+		 * These values must be snapshotted within the seqcount loop.
+		 * After that, it's just mathematics which can happen on any
+		 * CPU at any time.
+		 */
+		hv_clock.tsc_timestamp =3D ka->master_cycle_now;
+		hv_clock.system_time =3D ka->master_kernel_ns + ka->kvmclock_offset;
+
+	} while (read_seqcount_retry(&ka->pvclock_sc, seq));
+
+	/*
+	 * If the conditions were right, and obtaining the wallclock+TSC was
+	 * successful, calculate the KVM clock at the corresponding time and
+	 * subtract one from the other to get the guest's epoch in nanoseconds
+	 * since 1970-01-01.
+	 */
+	if (local_tsc_khz) {
+		kvm_get_time_scale(NSEC_PER_SEC, local_tsc_khz * NSEC_PER_USEC,
+				   &hv_clock.tsc_shift,
+				   &hv_clock.tsc_to_system_mul);
+		return ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec -
+			__pvclock_read_cycles(&hv_clock, host_tsc);
+	}
+#endif
+	return ktime_get_real_ns() - get_kvmclock_ns(kvm);
+}
+
 /*
  * kvmclock updates which are isolated to a given vcpu, such as
  * vcpu->cpu migration, should not allow system_timestamp from
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1e7be1f6ab29..ed1a69942347 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -290,6 +290,8 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm,=
 u64 quirk)
 	return !(kvm->arch.disabled_quirks & quirk);
 }
=20
+uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm);
+
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc=
_eip);
=20
 u64 get_kvmclock_ns(struct kvm *kvm);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index c539f18e0b60..e53fad915a62 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -59,7 +59,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_=
t gfn)
 		 * This code mirrors kvm_write_wall_clock() except that it writes
 		 * directly through the pfn cache and doesn't mark the page dirty.
 		 */
-		wall_nsec =3D ktime_get_real_ns() - get_kvmclock_ns(kvm);
+		wall_nsec =3D kvm_get_wall_clock_epoch(kvm);
=20
 		/* It could be invalid again already, so we need to check */
 		read_lock_irq(&gpc->lock);
@@ -98,7 +98,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_=
t gfn)
 	wc_version =3D wc->version =3D (wc->version + 1) | 1;
 	smp_wmb();
=20
-	wc->nsec =3D do_div(wall_nsec,  1000000000);
+	wc->nsec =3D do_div(wall_nsec, NSEC_PER_SEC);
 	wc->sec =3D (u32)wall_nsec;
 	*wc_sec_hi =3D wall_nsec >> 32;
 	smp_wmb();
--=20
2.40.1



--=-cY2yXwKyBS3Zp7H1PSvf
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMxMDA1MDkxNjEwWjAvBgkqhkiG9w0BCQQxIgQglgbdYBKZ
xeoW5Cs27vkIJfjnO0v7qN7A/o+3QGWa4+Mwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgBm+7AJ/zXnE9avdj95S8odxcdserz1uLqO
pCGJ9UWuyXc2Az1PRXyTpqNEkgSmQ2uNLPJp6hpLt/OqzgsbMT0yCJ+QumHD2jLguFxdWZXT18c2
AUyT9dyZdONmYqSK6/acvxcaQSZgVpAdlIXc3TpnmFL2IjQ9zfJO8Sl5pU8WKGGAZt7QZzpXfJaZ
fd0h0NcQyhuGMwq5TEB5p9U/LwgXF4Ft7JxQaBM7X2ynmE9BoC+DP+YfK0c2l5UjAFERe8+awKd0
B+2KTYWh8dW/gIQo7q73iKrcIsNiGySi1S1EgZPHo7GkFUMiQeyeChCEDJNs4/P3FDYxUrukx/1I
53g1xTGTZDbCsvnhzkC1yA5MY++zRj/iNS/AaEbixCx0pNzzRWxB2HJSTcb7/ZsEBPEx5+f9l/vv
vIPLgQSHvZVxzFxajed2yy5hwbAydrbBx610yr0nnH1FEFimGPWAPXtF4XBZZsr3+SXe4vnwZDI0
KaqPb1+dVA0JOWVAKJ33rpLGFHZ7OFX73WGlccM9iwXpbs5pnx60A3al2fbjz3QEVkezyuR3BcIa
DjsV9UGVp22vTYU/2b7lRTdr+EeG/O7E2n2WbLktCoXDRCHGALUq+EQlWEG0V+tyhXlE26uZyXAa
TH9nlXPRH74vpaONor9l6N2Onj6Lc9UtBLO9kii81wAAAAAAAA==


--=-cY2yXwKyBS3Zp7H1PSvf--
