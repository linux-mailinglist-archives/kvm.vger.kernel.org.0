Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316E37B48FC
	for <lists+kvm@lfdr.de>; Sun,  1 Oct 2023 19:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbjJARy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Oct 2023 13:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbjJARyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Oct 2023 13:54:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D01A7;
        Sun,  1 Oct 2023 10:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:Date:Cc:To:
        From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=fgC78h+iS4mzDakS0xyY7EGKjinZxb9su59hNHGZ2Xg=; b=GTewsJDE85KagLi/skFFKy4D3y
        1jEEdrfVeYZdijKYF8IuRivODwgdUUluA7pwRnUPU2l4ZGI7tnm5HjAq6M06ShM2EGK0H5o3nYJxo
        +oAwWZn223hvI68Ffx9CD+S0arywX1PThzKMm6rR2jMxio4R5BWfwDaLcyRw0hlreOxPz5XPa3x54
        1pQ57XASDDFto0fMWDvWf6gYZZLaipa7ssSC685fydhjPqIF6iLyzoasQRrnnYwxOf7m3MaCeHtxj
        avhjX6KmkAuPTHAo1IJu2/ejFCZM7HtLRo1klhYwQdsd1rye4WaG5rKR8uAivPnhNpKiTutsgOsZS
        WQa3o+DQ==;
Received: from [2001:8b0:10b:5::bb3] (helo=u3832b3a9db3152.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qn0e1-004YLN-3r; Sun, 01 Oct 2023 17:54:17 +0000
Message-ID: <ee446c823002dc92c8ea525f21d00a9f5d27de59.camel@infradead.org>
Subject: [PATCH] KVM: x86: Refine calculation of guest wall clock to use a
 single TSC read
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, sveith@amazon.de
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>,
        inux-kernel@vger.kernel.org
Date:   Sun, 01 Oct 2023 18:54:16 +0100
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-yGt/cGcobzebLM+1F5oq"
User-Agent: Evolution 3.44.4-0ubuntu2 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-yGt/cGcobzebLM+1F5oq
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
Tested by sticking a printk into it and comparing the values calculated
by the old and new methods, while running the xen_shinfo_test which
keeps relocating the shared info and thus rewriting the PV wall clock
information to it.

They look sane enough but there's still skew over time (in both of
them) as the KVM values get adjusted in presumably similarly sloppy
ways. But we'll get to this. This patch is just the first low hanging
fruit in a quest to eliminate such sloppiness and get to the point
where we can do live update (pause guests, kexec and resume them again)
with a *single* cycle of skew. After all, the host TSC is still just as
trustworthy so there's no excuse for *anything* changing over the
kexec. Every other clock in the guest should have precisely the *same*
relationship to the host TSC as it did before the kexec.

 arch/x86/kvm/x86.c | 60 ++++++++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/x86.h |  2 ++
 arch/x86/kvm/xen.c |  4 ++--
 3 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04b57a336b34..625ec4d9281b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2317,14 +2317,9 @@ static void kvm_write_wall_clock(struct kvm *kvm, gp=
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
@@ -3229,6 +3224,57 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	return 0;
 }
=20
+uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm)
+{
+	/*
+	 * The guest calculates current wall clock time by adding
+	 * system time (updated by kvm_guest_time_update below) to the
+	 * wall clock specified here.  We do the reverse here.
+	 */
+#ifdef CONFIG_X86_64
+	struct pvclock_vcpu_time_info hv_clock;
+	struct kvm_arch *ka =3D &kvm->arch;
+	unsigned long seq, local_tsc_khz =3D 0;
+	struct timespec64 ts;
+	uint64_t host_tsc;
+
+	do {
+		seq =3D read_seqcount_begin(&ka->pvclock_sc);
+
+		if (!ka->use_master_clock)
+			break;
+
+		/* It all has to happen on the same CPU */
+		get_cpu();
+
+		local_tsc_khz =3D get_cpu_tsc_khz();
+
+		if (local_tsc_khz &&
+		    !kvm_get_walltime_and_clockread(&ts, &host_tsc))
+			local_tsc_khz =3D 0; /* Fall back to old method */
+
+		hv_clock.tsc_timestamp =3D ka->master_cycle_now;
+		hv_clock.system_time =3D ka->master_kernel_ns + ka->kvmclock_offset;
+
+		put_cpu();
+	} while (read_seqcount_retry(&ka->pvclock_sc, seq));
+
+	/*
+	 * If the conditions were right, and obtaining the wallclock+TSC was
+	 * successful, calculate the KVM clock at the corresponding time and
+	 * subtract one from the other to get the epoch in nanoseconds.
+	 */
+	if (local_tsc_khz) {
+		kvm_get_time_scale(NSEC_PER_SEC, local_tsc_khz * 1000LL,
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
index c544602d07a3..b21743526011 100644
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
index 75586da134b3..6bab715be428 100644
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



--=-yGt/cGcobzebLM+1F5oq
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMxMDAxMTc1NDE2WjAvBgkqhkiG9w0BCQQxIgQgB7DQXU39
WTC0uiWG3fec4/0vlN5pqcRvMSMhKbJigOMwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAqfxyPxsHlnGBKj3tWZL5OZqeirPZ/SGJV
I5s/Lvs9lXsaQZPFlaxXsg5R9lcgXLk160plDicCnkL7+XbAzHHc/JaC5j9cG9dkXIKsfMxHUNYS
WA4agFn6hf9SGXEAeRJDcmXPL3yQ3NojWHSMARWCP2/TdchWe3NMW509lHs7ISQHEG+Wt9yoktTf
togVpZYWF8gM31Vq0XFClT/EiEo96zHBZxBs2eAiM8yWH3zdwXOG7msv8y4BthMTBx4BUQXr07ZW
b4YyMFKt1s7gUg2y9CNnqy+bOjbhKxqPFmxiKwnpELBztpzxfU5eCJOimphahemycnt2wNGVYb9Z
+9fuUYg6HKKQAIMsWXHrPnbdSlwluD8Jz8aBqScnOVkAMkLhB3P1j+QodpeOK7Q5xHEWPJR295hg
HAKordKgBt6AK/YCk4aQpRqiF7+Bi+I65Fy8+fTURv0zV4fDpZ33JzuM+4O05+EsNHqRGiIb4cXM
F1rYe1Cl64SjCorbOKrwAhm00+CQt1mKHJpToY+xFiDsle8Xr386shN+yPsA9AJu+Mse01gXVllj
fx/RzHW7WSexqpFzDTQURa/mNwzWlHWKXh1BAebwqTKjm9s99l7aIbi0lgcMJ9oXdvHpZf8fO6lP
z0JJ3qxhBDBdxtpATDgUaRlyzSnXBBQWYl8Iq5ruSwAAAAAAAA==


--=-yGt/cGcobzebLM+1F5oq--
