Return-Path: <kvm+bounces-23079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB7B694615E
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3FAF6B2175F
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 16:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C22E1804F;
	Fri,  2 Aug 2024 16:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dvZlp5k+"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B2C1A34A0;
	Fri,  2 Aug 2024 16:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722614793; cv=none; b=Mkj8+CXwFvvFwnlqpcvePrPG8BrPHoW27ukJS2wIzINpTgFwvo8XebOMPGqUHoJu9s4REY2FiqxeUx2p0gjCulYfPulJPFfHLhpFw5+5GAoj1pNpXziO/mUmOsP0Pw2+JMq2pn3Jq9rjsQeEQ8G95wJQcNtxsefU9v2LkzQMwsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722614793; c=relaxed/simple;
	bh=35BZV2Hq0JGDYT+nuNRBi9Dj9tevH08pVRP9vNAKqTQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WA4tsA8Uams4TzQcQqyifNaQ7zfvHnAB7c8nxCSH2oDMqys42HBmbZ5mm8SdirbbkLijfqmib7yAtYDQug6EfG01ocOVZqy40bfAZMesJgxClVX0Jw/ysHSU0qo+0RpK3orf/y6dFvYXDWeHGSf6CY2ev+A55xQ7k5IL+iOXJbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dvZlp5k+; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d1QQs2j9WvbjY7EOtsH3M71tofcwwHBlzkWo07sbTYw=; b=dvZlp5k+Bcyptd8d2RCa5E5prx
	c3brn5tA8EXUati41/ueUoJaR6eQHXpJ7jHy73F/S3xXCK9nV6f1GD0xFrTsx9gYmCMHXQbIRE8xw
	4iN574s9xyGbzwtGGAn6RR83llDhA7LAb3vKNkiUzL5Tubs9zu+VJroDcRftDRJzvcxvo4tdxwgpC
	Oyu3OTdlbjpseoJeaW+ohbhqVMDJUDMTCBaRQSbWhLC/5rposBlvE9YxYAjEAHmbdNPDnB4oQqzyB
	YcTTNtfeQT5A/6BMWPQeW5WsoK07nZ9/305YyDanabrydpGv9yecsrSWHtl7ZnpWOZO5kls6Sc78R
	qd6bfp7Q==;
Received: from [2001:8b0:10b:5:baa5:735b:df3b:ad66] (helo=u3832b3a9db3152.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sZunK-00000001BqP-21k4;
	Fri, 02 Aug 2024 16:06:18 +0000
Message-ID: <59f698cf899db7eecb9838069401161a06dad7b4.camel@infradead.org>
Subject: Re: [PATCH] KVM: x86: Use gfn_to_pfn_cache for steal_time
From: David Woodhouse <dwmw2@infradead.org>
To: Carsten Stollmaier <stollmc@amazon.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>
Cc: nh-open-source@amazon.com, Peter Xu <peterx@redhat.com>, Sebastian
 Biemueller <sbiemue@amazon.de>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Andrew
 Morton <akpm@linux-foundation.org>,  "linux-mm@kvack.org"
 <linux-mm@kvack.org>
Date: Fri, 02 Aug 2024 17:06:17 +0100
In-Reply-To: <b40f244f50ce3a14d637fd1769a9b3f709b0842e.camel@infradead.org>
References: <20240802114402.96669-1-stollmc@amazon.com>
	 <b40f244f50ce3a14d637fd1769a9b3f709b0842e.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-YMQ3GU6gXOn3saq1BB65"
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-YMQ3GU6gXOn3saq1BB65
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2024-08-02 at 13:03 +0100, David Woodhouse wrote:
>=20
> I'm actually tempted to make user access *interruptible* though, and
> either add copy_{from,to}_user_interruptible() or change the semantics
> of the existing ones (which I believe are already killable).
>=20
> That would require each architecture implementing interruptible
> exceptions, by doing an extable lookup before the retry. Not overly
> complex, but needs to be done for all architectures (although not at
> once; we could live with not-yet-done architectures just remaining
> killable).
>=20
> Thoughts?

Utterly untested, hasn't even built yet and would need some cleanup
(and better thoughts about how to indicate -EFAULT vs. -EINTR instead
of having the caller check signal_pending() for itself). But should
demonstrate what I was thinking, at least...

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 2bec0c89a95c..854ccd5f2342 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -229,6 +229,9 @@ register unsigned long current_stack_pointer asm(_ASM_S=
P);
 #define _ASM_EXTABLE_UA(from, to)				\
 	_ASM_EXTABLE_TYPE(from, to, EX_TYPE_UACCESS)
=20
+#define _ASM_EXTABLE_UA_INTR(from, to)				\
+	_ASM_EXTABLE_TYPE(from, to, EX_TYPE_UACCESS_INTERRUPTIBLE)
+
 #define _ASM_EXTABLE_FAULT(from, to)				\
 	_ASM_EXTABLE_TYPE(from, to, EX_TYPE_FAULT)
=20
diff --git a/arch/x86/include/asm/extable_fixup_types.h b/arch/x86/include/=
asm/extable_fixup_types.h
index 906b0d5541e8..651d42f39e9b 100644
--- a/arch/x86/include/asm/extable_fixup_types.h
+++ b/arch/x86/include/asm/extable_fixup_types.h
@@ -36,7 +36,7 @@
 #define	EX_TYPE_DEFAULT			 1
 #define	EX_TYPE_FAULT			 2
 #define	EX_TYPE_UACCESS			 3
-/* unused, was: #define EX_TYPE_COPY	 4 */
+#define	EX_TYPE_UACCESS_INTERRUPTIBLE	 4
 #define	EX_TYPE_CLEAR_FS		 5
 #define	EX_TYPE_FPU_RESTORE		 6
 #define	EX_TYPE_BPF			 7
diff --git a/arch/x86/include/asm/trapnr.h b/arch/x86/include/asm/trapnr.h
index 8d1154cdf787..9f6397bad398 100644
--- a/arch/x86/include/asm/trapnr.h
+++ b/arch/x86/include/asm/trapnr.h
@@ -41,4 +41,5 @@
 #define X86_TRAP_VC		29	/* VMM Communication Exception */
 #define X86_TRAP_IRET		32	/* IRET Exception */
=20
+#define X86_TRAP_INTERRUPTIBLE 0x40000000	/* Internal, for interruptible e=
xceptions */
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cef729a25655..ab00150d360b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3819,12 +3819,15 @@ static void record_steal_time(struct kvm_vcpu *vcpu=
)
 		asm volatile("1: xchgb %0, %2\n"
 			     "xor %1, %1\n"
 			     "2:\n"
-			     _ASM_EXTABLE_UA(1b, 2b)
+			     _ASM_EXTABLE_UA_INTR(1b, 2b)
 			     : "+q" (st_preempted),
 			       "+&r" (err),
 			       "+m" (st->preempted));
-		if (err)
+		if (err) {
+			if (signal_pending(current))
+				err =3D -EINTR;
 			goto out;
+		}
=20
 		user_access_end();
=20
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 51986e8a9d35..d2cef84042a5 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -325,6 +325,12 @@ int fixup_exception(struct pt_regs *regs, int trapnr, =
unsigned long error_code,
 	reg  =3D FIELD_GET(EX_DATA_REG_MASK,  e->data);
 	imm  =3D FIELD_GET(EX_DATA_IMM_MASK,  e->data);
=20
+	if (trapnr & X86_TRAP_INTERRUPTIBLE) {
+		trapnr &=3D ~X86_TRAP_INTERRUPTIBLE;
+		if (type !=3D EX_TYPE_UACCESS_INTERRUPTIBLE)
+			return 0;
+	}
+
 	switch (type) {
 	case EX_TYPE_DEFAULT:
 	case EX_TYPE_DEFAULT_MCE_SAFE:
@@ -333,6 +339,7 @@ int fixup_exception(struct pt_regs *regs, int trapnr, u=
nsigned long error_code,
 	case EX_TYPE_FAULT_MCE_SAFE:
 		return ex_handler_fault(e, regs, trapnr);
 	case EX_TYPE_UACCESS:
+	case EX_TYPE_UACCESS_INTERRUPTIBLE:
 		return ex_handler_uaccess(e, regs, trapnr, fault_addr);
 	case EX_TYPE_CLEAR_FS:
 		return ex_handler_clear_fs(e, regs);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index e6c469b323cc..4b32348dbb23 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1388,18 +1388,6 @@ void do_user_addr_fault(struct pt_regs *regs,
 	 */
 	fault =3D handle_mm_fault(vma, address, flags, regs);
=20
-	if (fault_signal_pending(fault, regs)) {
-		/*
-		 * Quick path to respond to signals.  The core mm code
-		 * has unlocked the mm for us if we get here.
-		 */
-		if (!user_mode(regs))
-			kernelmode_fixup_or_oops(regs, error_code, address,
-						 SIGBUS, BUS_ADRERR,
-						 ARCH_DEFAULT_PKEY);
-		return;
-	}
-
 	/* The fault is fully completed (including releasing mmap lock) */
 	if (fault & VM_FAULT_COMPLETED)
 		return;
@@ -1410,6 +1398,28 @@ void do_user_addr_fault(struct pt_regs *regs,
 	 * that we made any progress. Handle this case first.
 	 */
 	if (unlikely(fault & VM_FAULT_RETRY)) {
+		if (signal_pending(current)) {
+			if (user_mode(regs))
+				return;
+
+			if (fatal_signal_pending(current)) {
+				kernelmode_fixup_or_oops(regs, error_code, address,
+							 SIGBUS, BUS_ADRERR,
+							 ARCH_DEFAULT_PKEY);
+				return;
+			}
+
+			/*
+			 * First time round, if woken by a signal, see if there
+			 * is an interruptible exception handler. If so, do it.
+			 * Else, switch off FAULT_FLAG_INTERRUPTIBLE.
+			 */
+			if (fixup_exception(regs, X86_TRAP_INTERRUPTIBLE | X86_TRAP_PF,
+					    error_code, address))
+				return;
+			flags &=3D ~FAULT_FLAG_INTERRUPTIBLE;
+		}
+
 		flags |=3D FAULT_FLAG_TRIED;
 		goto retry;
 	}


--=-YMQ3GU6gXOn3saq1BB65
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjQwODAyMTYwNjE3WjAvBgkqhkiG9w0BCQQxIgQgOU4Vj6bt
ewTUAS2Uq1lmzyjoRwDc2rjRiE9W2T0C0Wcwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgB7Jw9KmmBRtOyhRsxGeocl+esfJuacZaaX
yBmP+ihH+i9NsDY266PzSaVYOJ+7hgAlq+M28B6JWJ+ouku0QkWzo9QtnWCHJy4tFJtFh+pKqY/2
GlA30KG07X9RDQgM6/t6tDletAUK9jTeVwgb2OoW21yH/S2t/zLizdmx3l2MFXVWDiCCpa32zFyi
trY9vCS3jM87mF+T6XzO8bsoVMDIFvSKVO4BOXjvlOOqRlK6it2q1kkR+xA1aWUrpVB0tScTAC49
u4mQfFtQ59NrQaXiq8VXNmbKlL7tFcV2U7SQD8OH+ON8+wRSWshQ10haobGdJRhi9keHx/567SkR
7Okg/CHG+QeILrgWfD3Zl8ClIOhUX0YHZxyv+i0QFFdY/8gDn9B7idvCTkMK9jPtPOcpIps+HXlX
qE0v7eloaf8Jj97ehVoWQdoUcQFlAoDZuztgUpDt072tK3fXjcr2EgXwV4nr9/rsa2GsZkx29BVZ
Al2JLij/2NFg/W90UXxTdEeke4fzFbWWZ7E6MdjZMnnBRVsxQzpKPWYIRCdiYfk9sAjvZ0rcoMf0
JfyPcSj6b/Shw9iPWkkh+4wq+H30hpWSlYibja9AbFrzkZ9P8oykM+ou2fY4kchtSQUOl32XxpRp
0GytUU6PqDomYM7lUOszmpzX4KoqseDHMHrrZSwLbgAAAAAAAA==


--=-YMQ3GU6gXOn3saq1BB65--

