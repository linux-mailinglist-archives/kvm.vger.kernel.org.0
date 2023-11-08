Return-Path: <kvm+bounces-1268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EBCAB7E5E70
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63E78B20AC5
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 19:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0DD37145;
	Wed,  8 Nov 2023 19:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sYPSTtoK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47D336AF6
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 19:14:52 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A482110;
	Wed,  8 Nov 2023 11:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6wTXP6ZCRqr3YxY3G22TR8aYFSHkKqoyb0H2bbknYvc=; b=sYPSTtoK9FTeSkthtt1erbmQ4w
	FULcOlL3ADvmYDTVQEJ/80Ark19/JjyKr2+P7pq+ODL3X3whKVv2tyjdEI4hX/v+eBEmBGlgePns1
	8CKn1AoXvUvoRkteBoUDoZpYzfR+85pvMkwh3RyHr4+aei39zd3xrxn6SptFKsDbE0Z4dISsBPXZz
	Rlf0ZivgaU+ogv+70KQ0kzbdZJXOJFVl1wRq8sWchVyIv3wr9uI03IubzE+Odv2RAV8EptEVme7/h
	OCzc1JuSaiyOl2IBFTtMheXSwZoCIyxAFPKLibM68gD9mvG8EV3CzY2tdMnSu9T5ML0hWs3yF++bS
	iPhuk8pQ==;
Received: from [2001:8b0:10b:5:4cc7:6419:1e03:2f3f] (helo=u3832b3a9db3152.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r0o0l-002js8-Em; Wed, 08 Nov 2023 19:14:48 +0000
Message-ID: <dab33a11bdc327ca08481af31cc25688f0b0323b.camel@infradead.org>
Subject: Re: [PATCH v2] KVM: x86/xen: improve accuracy of Xen timers
From: David Woodhouse <dwmw2@infradead.org>
To: Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Paul Durrant <paul@xen.org>, Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>,  Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>
Date: Wed, 08 Nov 2023 19:14:46 +0000
In-Reply-To: <c6cfae1a-e687-ae7d-12ae-38fb97923082@oracle.com>
References: <96da7273adfff2a346de9a4a27ce064f6fe0d0a1.camel@infradead.org>
	 <74f32bfae7243a78d0e74b1ba3a2d1ea4a4a7518.camel@infradead.org>
	 <2bd5d543-08a0-a0f6-0f59-b8724a2d8d75@oracle.com>
	 <12e8ade22fe6c1e6bec74e60e8213302a7da635e.camel@infradead.org>
	 <19f8de0a-17f7-1a25-f2e9-adbf00ecb035@oracle.com>
	 <37225cb2ab45c842275c2b5b5d84d1bb514a8640.camel@infradead.org>
	 <33907a83-4e1a-f121-74f3-bde1e68b047c@oracle.com>
	 <5e0598c86361570674401f43191c3f819a6b32d2.camel@infradead.org>
	 <c6cfae1a-e687-ae7d-12ae-38fb97923082@oracle.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-z7bthhsWfluzB29CsTEV"
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-z7bthhsWfluzB29CsTEV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-11-08 at 10:22 -0800, Dongli Zhang wrote:
>=20
> Thank you very much for the explanation.
>=20
> I understand you may use different methods to obtain the 'expire' under
> different cases.
>=20
> Maybe add some comments in the KVM code of xen timer emulation? E.g.:
>=20
> - When the TSC is reliable, follow the standard/protocol that xen timer i=
s
> per-vCPU pvclock based: that is, to always scale host_tsc with kvm_read_l=
1_tsc().
>=20
> - However, sometimes TSC is not reliable. Use the legacy method get_kvmcl=
ock_ns().

After the patch we're discussing here, kvm_xen_start_timer() is *more*
comment than code. I think it covers both of the points you mention
above, and more.


static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
				bool linux_wa)
{
	uint64_t guest_now;
	int64_t kernel_now, delta;

	/*
	 * The guest provides the requested timeout in absolute nanoseconds
	 * of the KVM clock =E2=80=94 as *it* sees it, based on the scaled TSC and
	 * the pvclock information provided by KVM.
	 *
	 * The kernel doesn't support hrtimers based on CLOCK_MONOTONIC_RAW
	 * so use CLOCK_MONOTONIC. In the timescales covered by timers, the
	 * difference won't matter much as there is no cumulative effect.
	 *
	 * Calculate the time for some arbitrary point in time around "now"
	 * in terms of both kvmclock and CLOCK_MONOTONIC. Calculate the
	 * delta between the kvmclock "now" value and the guest's requested
	 * timeout, apply the "Linux workaround" described below, and add
	 * the resulting delta to the CLOCK_MONOTONIC "now" value, to get
	 * the absolute CLOCK_MONOTONIC time at which the timer should
	 * fire.
	 */
	if (vcpu->arch.hv_clock.version && vcpu->kvm->arch.use_master_clock &&
	    static_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
		uint64_t host_tsc, guest_tsc;

		if (!IS_ENABLED(CONFIG_64BIT) ||
		    !kvm_get_monotonic_and_clockread(&kernel_now, &host_tsc)) {
			/*
			 * Don't fall back to get_kvmclock_ns() because it's
			 * broken; it has a systemic error in its results
			 * because it scales directly from host TSC to
			 * nanoseconds, and doesn't scale first to guest TSC
			 * and then* to nanoseconds as the guest does.
			 *
			 * There is a small error introduced here because time
			 * continues to elapse between the ktime_get() and the
			 * subsequent rdtsc(). But not the systemic drift due
			 * to get_kvmclock_ns().
			 */
			kernel_now =3D ktime_get(); /* This is CLOCK_MONOTONIC */
			host_tsc =3D rdtsc();
		}

		/* Calculate the guest kvmclock as the guest would do it. */
		guest_tsc =3D kvm_read_l1_tsc(vcpu, host_tsc);
		guest_now =3D __pvclock_read_cycles(&vcpu->arch.hv_clock,
						  guest_tsc);
	} else {
		/*
		 * Without CONSTANT_TSC, get_kvmclock_ns() is the only option.
		 *
		 * Also if the guest PV clock hasn't been set up yet, as is
		 * likely to be the case during migration when the vCPU has
		 * not been run yet. It would be possible to calculate the
		 * scaling factors properly in that case but there's not much
		 * point in doing so. The get_kvmclock_ns() drift accumulates
		 * over time, so it's OK to use it at startup. Besides, on
		 * migration there's going to be a little bit of skew in the
		 * precise moment at which timers fire anyway. Often they'll
		 * be in the "past" by the time the VM is running again after
		 * migration.
		 */
		guest_now =3D get_kvmclock_ns(vcpu->kvm);
		kernel_now =3D ktime_get();
	}

	delta =3D guest_abs - guest_now;

	/* Xen has a 'Linux workaround' in do_set_timer_op() which
	 * checks for negative absolute timeout values (caused by
	 * integer overflow), and for values about 13 days in the
	 * future (2^50ns) which would be caused by jiffies
	 * overflow. For those cases, it sets the timeout 100ms in
	 * the future (not *too* soon, since if a guest really did
	 * set a long timeout on purpose we don't want to keep
	 * churning CPU time by waking it up).
	 */
	if (linux_wa) {
		if ((unlikely((int64_t)guest_abs < 0 ||
			      (delta > 0 && (uint32_t) (delta >> 50) !=3D 0)))) {
			delta =3D 100 * NSEC_PER_MSEC;
			guest_abs =3D guest_now + delta;
		}
	}

	/*
	 * Avoid races with the old timer firing. Checking timer_expires
	 * to avoid calling hrtimer_cancel() will only have false positives
	 * so is fine.
	 */
	if (vcpu->arch.xen.timer_expires)
		hrtimer_cancel(&vcpu->arch.xen.timer);

	atomic_set(&vcpu->arch.xen.timer_pending, 0);
	vcpu->arch.xen.timer_expires =3D guest_abs;

	if (delta <=3D 0) {
		xen_timer_callback(&vcpu->arch.xen.timer);
	} else {
		hrtimer_start(&vcpu->arch.xen.timer,
			      ktime_add_ns(kernel_now, delta),
			      HRTIMER_MODE_ABS_HARD);
	}
}



> This may help developers understand the standard/protocol used by xen tim=
er. The
> core idea will be: the implementation is trying to following the xen time=
r
> nanoseconds definition (per-vCPU pvclock), and it may use other legacy so=
lution
> under special case, in order to improve the accuracy.

This isn't special to the Xen timers. We really are just using the
kvmclock for this. It's the same thing.

> TBH, I never think about what the definition of nanosecond is in xen time=
r (even
> I used to and I am still working on some xen issue).

You never had to think about it before because it was never quite so
catastrophically broken as it is under KVM. Nanoseconds were
nanoseconds and we didn't have problems because we scale and calculate
them three *different* ways and periodically clamp the guest-visible
one to a fourth. :)

--=-z7bthhsWfluzB29CsTEV
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMxMTA4MTkxNDQ2WjAvBgkqhkiG9w0BCQQxIgQgvMYx84OA
2QDC1z9jDJvTAqVChgfk05AkJ/68E1W5qtQwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAnV6BLG9q6V3H8XUJennW1p1hD1tznE9nM
IGMw/gsoxmyMyTNn8sCHZS8NDfKchjIWu97RlL9pOOUyqOhEqRicz7Lrt749/OyVP0LmoroZBTen
GVvtlI8lAYjpJaNndqBu0fhw0rZhBfpixsE5u3DCaYxl9za7eowzPV+NtDkbzMyWrhDx5uajgBtv
z5bVOxjYb+PCPboMVjbrJzeY8cCcEnvP+b8+nDinYcbHVPB/rA9S/2LXI/6KQCk+P2ze+rtf4vZn
MTiuq51f1/rDlRtzE2YxiM/Wadi/JMmOP6RTIspVYtSrofpbU7UecgMDQoJYCtdi6bBid6VYh3Rk
pKV+gaFZSdlxgZ1rrYpjWp+1DHtcHoxPXbHRrjtbGrR2P+0IaJTiSubQFfyXKhixYkDn1JZKhoQ5
+yOHoP+/j/SC5C4z+ki4PedbHVBjLkhSOhxj9TLLDZhvvCEwLWdU2B3M1EhS9hfTg4kwrbayDFiD
hdhPCb91H34VGIA1lrsH6CtfihNk62RObTN0nyMYC+ai4KenFQYFkz7JRVOydPlp7Os9y0STGYQQ
HxhZzORRvA/Xw+UC1F2dsEOWamCgr7voBioGDUmUCT13647Dewt9E8tjxWqn1Bvls5UQgFg+jup5
R2ZKzsu3r8LmE2D0HXGwyVcRKToaZGeKwPuZyOF7PgAAAAAAAA==


--=-z7bthhsWfluzB29CsTEV--

