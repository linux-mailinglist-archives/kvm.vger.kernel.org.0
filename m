Return-Path: <kvm+bounces-15004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B337E8A8C54
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 21:51:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E978B2223D
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 19:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857A637703;
	Wed, 17 Apr 2024 19:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GyqwR6g+"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B50208CA;
	Wed, 17 Apr 2024 19:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713383467; cv=none; b=EV8umAIyCcomxlF7Da1hddj2Z0vNrGQZNokWWxsSNjP0AwL9Jh2P0ydaa+lOkN5SW5uIqhrwVklB9RvcQxitqdhLzEz9gaxSgns8cTAKZ3EloqmnfQGM3GeMiExyy4XAXwlZTu00zwRR2jVqq1elhpGoXFgbSKCmkkcpaq6kI5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713383467; c=relaxed/simple;
	bh=ZCLFM1XEEuuFmUAe7SJagx3mKc6IzOET9CEBX1qFgYk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ivgm63FOlt5ytxukCqkcA3BvwTBCnRWdPQtrBnxcg/QdZjlWhfT7HO1AttangrxHDX+YFAEXfVFYcYB484M7d6/c/cd0PozHQQkOOUHf4p90YPsCnTAPtNodBp9VrJjKk2CFnokLjFfkRox8JTouSGZkp6cpCmz8yLdTyTxltMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GyqwR6g+; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MsTxLu9RHPhw/thGEnZGvo7FrnvKRgbspW6v13+n3ls=; b=GyqwR6g+gUSvazRgla7fJxpgQn
	oRM3M/A8k7Zb8O/dSJdRj31eFZXIG+xt6q6riU+8tQtsuxYFZoS/D+TPfipKiU/FprijOF4q8x5Rq
	ZOyQwwI1Tqjwb/ZUmbzQKlBjo26m0mTQu/fu14Kpa57YvQlL9vGL33U06kmf8LlF+5uL84/9vCwz1
	jMVXmpqVed4sByehjtOvdugq+6F28m2YTgIIMhi8hSWXmCvu8KFeWKhArR0pQZfEKdf4Fs2DkCmdQ
	Mwhf2zpuaPmjgrFnuaQC7tEocIQhwA7/lhgu3zeqmrrfLM9H6ZTBaY9Am4t/tlrxx0rvySU5pFMnX
	ZtEilr1w==;
Received: from [2001:8b0:10b:5:d733:4072:dba6:7bf6] (helo=u3832b3a9db3152.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxBIs-00000003eD5-0OPR;
	Wed, 17 Apr 2024 19:50:46 +0000
Message-ID: <c582ce58f3b13528b8d9c1f28cdac6fbd41cb775.camel@infradead.org>
Subject: Re: [PATCH v2 1/2] KVM: x86: Add KVM_[GS]ET_CLOCK_GUEST for
 accurate KVM clock migration
From: David Woodhouse <dwmw2@infradead.org>
To: paul@xen.org, Paul Durrant <xadimgnik@gmail.com>, Jack Allister
	 <jalliste@amazon.com>
Cc: bp@alien8.de, corbet@lwn.net, dave.hansen@linux.intel.com,
 hpa@zytor.com,  kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org,  mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de,  x86@kernel.org, Dongli Zhang
 <dongli.zhang@oracle.com>
Date: Wed, 17 Apr 2024 20:50:43 +0100
In-Reply-To: <26bfe5ec-e583-458d-8e43-e5ecdc5883cc@xen.org>
References: <20240408220705.7637-1-jalliste@amazon.com>
	 <20240410095244.77109-1-jalliste@amazon.com>
	 <20240410095244.77109-2-jalliste@amazon.com>
	 <005911c5-7f9d-4397-8145-a1ad4494484d@xen.org>
	 <ED45576F-F1F4-452F-80CF-AACC723BFE7E@infradead.org>
	 <26bfe5ec-e583-458d-8e43-e5ecdc5883cc@xen.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-OnCFNsZx/TdH16wNm+XH"
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-OnCFNsZx/TdH16wNm+XH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2024-04-10 at 13:43 +0100, Paul Durrant wrote:
> On 10/04/2024 13:09, David Woodhouse wrote:
> > On 10 April 2024 11:29:13 BST, Paul Durrant <xadimgnik@gmail.com>
> > wrote:
> > > On 10/04/2024 10:52, Jack Allister wrote:
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * It's possible that th=
is vCPU doesn't have a HVCLOCK
> > > > configured
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * but the other vCPUs m=
ay. If this is the case
> > > > calculate based
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * upon the time gathere=
d in the seqcount but do not
> > > > update the
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * vCPU specific PVTI. I=
f we have one, then use that.
> > >=20
> > > Given this is a per-vCPU ioctl, why not fail in the case the vCPU
> > > doesn't have HVCLOCK configured? Or is your intention that a
> > > GET/SET should always work if TSC is stable?
> >=20
> > It definitely needs to work for SET even when the vCPU hasn't been
> > run yet (and doesn't have a hvclock in vcpu->arch.hv_clock).
>=20
> So would it make sense to set up hvclock earlier?

Yeah, and I think we can do so just by calling kvm_guest_time_update().

The GET function can look like this:

static int kvm_vcpu_ioctl_get_clock_guest(struct kvm_vcpu *v, void __user *=
argp)
{
	struct pvclock_vcpu_time_info *hv_clock =3D &v->arch.hv_clock;

	/*
	 * If KVM_REQ_CLOCK_UPDATE is already pending, or if the hv_clock has
	 * never been generated at all, call kvm_guest_time_update() to do so.
	 * Might as well use the PVCLOCK_TSC_STABLE_BIT as the check for ever
	 * having been written.
	 */
	if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, v) ||
	    !(hv_clock->flags & PVCLOCK_TSC_STABLE_BIT)) {
		if (kvm_guest_time_update(v))
			return -EINVAL;
	}

	/*
	 * PVCLOCK_TSC_STABLE_BIT is set in use_master_clock mode where the
	 * KVM clock is defined in terms of the guest TSC. Otherwise, it is
	 * is defined by the host CLOCK_MONOTONIC_RAW, and userspace should
	 * use the legacy KVM_[GS]ET_CLOCK to migrate it.
	 */
	if (!(hv_clock->flags & PVCLOCK_TSC_STABLE_BIT))
		return -EINVAL;

	if (copy_to_user(argp, hv_clock, sizeof(*hv_clock)))
		return -EFAULT;

	return 0;
}

And the SET function doesn't even *need* the existing vCPU's hv_clock,
because we know damn well that the number of TSC cycles elapsed between
the reference time point and... erm... the reference time point... is
zero.

And everything *else* the hv_clock was being used for, either in Jack's
version or my own (where I used it for checking PVCLOCK_TSC_STABLE_BIT
and even used my new hvclock_to_hz() on it), can be done differently
too.

https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/clocks
(Try not to look at the 'Improve accuracy of KVM clock' one. It'll just
make you sad. Let Jack and me get to the end of the TODO list and you
can have all the sadness in one go like pulling a band-aid off.)

static int kvm_vcpu_ioctl_set_clock_guest(struct kvm_vcpu *v, void __user *=
argp)
{
	struct pvclock_vcpu_time_info user_hv_clock;
	struct kvm *kvm =3D v->kvm;
	struct kvm_arch *ka =3D &kvm->arch;
	uint64_t curr_tsc_hz, user_tsc_hz;
	uint64_t user_clk_ns;
	uint64_t guest_tsc;
	int rc =3D 0;

	if (copy_from_user(&user_hv_clock, argp, sizeof(user_hv_clock)))
		return -EFAULT;

	if (!user_hv_clock.tsc_to_system_mul)
		return -EINVAL;

	user_tsc_hz =3D hvclock_to_hz(user_hv_clock.tsc_to_system_mul,
				    user_hv_clock.tsc_shift);


	kvm_hv_request_tsc_page_update(kvm);
	kvm_start_pvclock_update(kvm);
	pvclock_update_vm_gtod_copy(kvm);

	/*
	 * If not in use_master_clock mode, do not allow userspace to set
	 * the clock in terms of the guest TSC. Userspace should either
	 * fail the migration (to a host with suboptimal TSCs), or should
	 * knowingly restore the KVM clock using KVM_SET_CLOCK instead.
	 */
	if (!ka->use_master_clock) {
		rc =3D -EINVAL;
		goto out;
	}

	curr_tsc_hz =3D get_cpu_tsc_khz() * 1000LL;
	if (unlikely(curr_tsc_hz =3D=3D 0)) {
		rc =3D -EINVAL;
		goto out;
	}

	if (kvm_caps.has_tsc_control)
		curr_tsc_hz =3D kvm_scale_tsc(curr_tsc_hz,
					    v->arch.l1_tsc_scaling_ratio);

	/*
	 * The scaling factors in the hv_clock do not depend solely on the
	 * TSC frequency *requested* by userspace. They actually use the
	 * host TSC frequency that was measured/detected by the host kernel,
	 * scaled by kvm_scale_tsc() with the vCPU's l1_tsc_scaling_ratio.
	 *
	 * So a sanity check that they *precisely* match would have false
	 * negatives. Allow for a discrepancy of 1 kHz either way.
	 */
	if (user_tsc_hz < curr_tsc_hz - 1000 ||
	    user_tsc_hz > curr_tsc_hz + 1000) {
		rc =3D -ERANGE;
		goto out;
	}

	/*
	 * The call to pvclock_update_vm_gtod_copy() has created a new time
	 * reference point in ka->master_cycle_now and ka->master_kernel_ns.
	 *
	 * Calculate the guest TSC at that moment, and the corresponding KVM
	 * clock value according to user_hv_clock. The value according to the
	 * current hv_clock will of course be ka->master_kernel_ns since no
	 * TSC cycles have elapsed.
	 *
	 * Adjust ka->kvmclock_offset to the delta, so that both definitions
	 * of the clock give precisely the same reading at the reference time.
	 */
	guest_tsc =3D kvm_read_l1_tsc(v, ka->master_cycle_now);
	user_clk_ns =3D __pvclock_read_cycles(&user_hv_clock, guest_tsc);
	ka->kvmclock_offset =3D user_clk_ns - ka->master_kernel_ns;

out:
	kvm_end_pvclock_update(kvm);
	return rc;
}


--=-OnCFNsZx/TdH16wNm+XH
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjQwNDE3MTk1MDQzWjAvBgkqhkiG9w0BCQQxIgQgJEV0UVuO
xFdZWoPv7Puw7iEKU6vgJNTAIOOTHhglI7Ewgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAjDLeEg+LGu4BnfuP9gJfQVaZoP4T4Ozhm
u2zw/xnf2WN0QzIsh/o6oUEhd28zSW94r0DCAZzGBLUoCajHknh85QehEKfpWFDtXKuFbF+sUxFy
BdhVWM6tbmbOw7HoB1sDeCrecmfSPQyylYFXeTekr51h9yLEsp+akKQiLAaX8I5DfFwrY9LISwJD
YiykmtUGiztT/XvdyGs748AeQUj3IwcrJa95Ohh/eWqvlDOdM0jawjn4FlZ1rvbuqRq4/QhPowvk
tkgXdyGcqUOW6DoQzmHW/vJfE0vlFWZdxKDP5+xs2n2FhNSITIJKDuO160FkT6y1k5EtRlOnujBS
l9cRHydyKlVEKVUwdZx+zDIirNkiCr/MXn+vOAhd8+lqv9fRrinfhbjAECuMGk7ImW+BjRFPNnom
lkQ8kCMC/jF914BgBWLTfw7tOhxz3YpUO9Ff+VTOBVT5jRbCWvGcipiidZrayFw/UlCFoYzdcH6Z
Qdi6E0ua4fPRnxp0k5gD9spxAAREDhaaGT1qH1iz4CipUbGtOMb4J2rRqRt8D9YhEbFfssD34vCL
QoPd4PP8kr17sdQh9E+M0u6me+sFnyQALHZy2KMohkIk94b2rA5v7Gz8uRZAxa6yq0umaIHaR3fH
FHr7OsTuDFd+7+SkKvzDQq1k9FR/4QvqYmWIQh5pqQAAAAAAAA==


--=-OnCFNsZx/TdH16wNm+XH--

