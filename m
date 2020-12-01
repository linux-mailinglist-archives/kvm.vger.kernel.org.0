Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B122CA125
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 12:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgLALUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 06:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727908AbgLALUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 06:20:17 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF98C0613CF;
        Tue,  1 Dec 2020 03:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VrM3/SrloQBIFbcbGmudy/X3SIAzMxDcWpaHm5/8+V4=; b=1CuId1eCU40M7M80NHZ12W4XHm
        BGZ6giCufAmBu/JznKpY9zIW20Lf4IFYVg5aoWCWI2Z8MfTfIqxCxM+BvOr95ZWWUVrLGyiZNNUu3
        lQq8w3MBFvjJH3+ger1A9rSg2L8dV1WlfCXKXThhIwl7qc5HRvFNZLy5v03YkhXjlocnh5CiAqE++
        ePKFATovKmelJwZtT3Efn1rBVxYwdHteyN6SODDXV7q3xq+XD6awVZpbM/EcvA3tZmayL9uLPiAA+
        ZqhNwQOPtwcI8I3gxAmgYd5b3auKKKjFH49VbAhaFzIVG0RD/Nt5DfiV6VFGR3BcbbwVJKlJP0f1v
        v6vFZnAw==;
Received: from [54.239.6.187] (helo=freeip.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk3gz-00077n-CD; Tue, 01 Dec 2020 11:19:33 +0000
Message-ID: <85c49b9c31f6b74f23ad58f93ec73786b7d48391.camel@infradead.org>
Subject: Re: [PATCH RFC 02/39] KVM: x86/xen: intercept xen hypercalls if
 enabled
From:   David Woodhouse <dwmw2@infradead.org>
To:     Joao Martins <joao.m.martins@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Date:   Tue, 01 Dec 2020 11:19:30 +0000
In-Reply-To: <b56f763e6bf29a65a11b7a36c4d7bfa79b2ec1b2.camel@infradead.org>
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
         <20190220201609.28290-3-joao.m.martins@oracle.com>
         <b56f763e6bf29a65a11b7a36c4d7bfa79b2ec1b2.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-NzAHaU1phxl2OGSDwjBZ"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-NzAHaU1phxl2OGSDwjBZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-12-01 at 09:48 +0000, David Woodhouse wrote:
> So I switched it to generate the hypercall page directly from the
> kernel, just like we do for the Hyper-V hypercall page.

Speaking of Hyper-V... I'll post this one now so you can start heckling
it.

I won't post the rest as I go; not much of the rest of the series when
I eventually post it will be very new and exciting. It'll just be
rebasing and tweaking your originals and perhaps adding some tests.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=46rom db020c521c3a96b698a78d4e62cdd19da3831585 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw@amazon.co.uk>
Date: Tue, 1 Dec 2020 10:59:26 +0000
Subject: [PATCH] KVM: x86: Fix coexistence of Xen and Hyper-V hypercalls

Disambiguate Xen vs. Hyper-V calls by adding 'orl $0x80000000, %eax'
at the start of the Hyper-V hypercall page when Xen hypercalls are
also enabled.

That bit is reserved in the Hyper-V ABI, and those hypercall numbers
will never be used by Xen (because it does precisely the same trick).

Switch to using kvm_vcpu_write_guest() while we're at it, instead of
open-coding it.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/hyperv.c                         | 40 ++++++++++++++-----
 arch/x86/kvm/xen.c                            |  6 +++
 .../selftests/kvm/x86_64/xen_vmcall_test.c    | 39 +++++++++++++++---
 3 files changed, 68 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 5c7c4060b45c..347ff9ad70b3 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -23,6 +23,7 @@
 #include "ioapic.h"
 #include "cpuid.h"
 #include "hyperv.h"
+#include "xen.h"
=20
 #include <linux/cpu.h>
 #include <linux/kvm_host.h>
@@ -1139,9 +1140,9 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u=
32 msr, u64 data,
 			hv->hv_hypercall &=3D ~HV_X64_MSR_HYPERCALL_ENABLE;
 		break;
 	case HV_X64_MSR_HYPERCALL: {
-		u64 gfn;
-		unsigned long addr;
-		u8 instructions[4];
+		u8 instructions[9];
+		int i =3D 0;
+		u64 addr;
=20
 		/* if guest os id is not set hypercall should remain disabled */
 		if (!hv->hv_guest_os_id)
@@ -1150,16 +1151,33 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu,=
 u32 msr, u64 data,
 			hv->hv_hypercall =3D data;
 			break;
 		}
-		gfn =3D data >> HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_SHIFT;
-		addr =3D gfn_to_hva(kvm, gfn);
-		if (kvm_is_error_hva(addr))
-			return 1;
-		kvm_x86_ops.patch_hypercall(vcpu, instructions);
-		((unsigned char *)instructions)[3] =3D 0xc3; /* ret */
-		if (__copy_to_user((void __user *)addr, instructions, 4))
+
+		/*
+		 * If Xen and Hyper-V hypercalls are both enabled, disambiguate
+		 * the same way Xen itself does, by setting the bit 31 of EAX
+		 * which is RsvdZ in the 32-bit Hyper-V hypercall ABI and just
+		 * going to be clobbered on 64-bit.
+		 */
+		if (kvm_xen_hypercall_enabled(kvm)) {
+			/* orl $0x80000000, %eax */
+			instructions[i++] =3D 0x0d;
+			instructions[i++] =3D 0x00;
+			instructions[i++] =3D 0x00;
+			instructions[i++] =3D 0x00;
+			instructions[i++] =3D 0x80;
+		}
+
+		/* vmcall/vmmcall */
+		kvm_x86_ops.patch_hypercall(vcpu, instructions + i);
+		i +=3D 3;
+
+		/* ret */
+		((unsigned char *)instructions)[i++] =3D 0xc3;
+
+		addr =3D data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
+		if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
 			return 1;
 		hv->hv_hypercall =3D data;
-		mark_page_dirty(kvm, gfn);
 		break;
 	}
 	case HV_X64_MSR_REFERENCE_TSC:
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 6400a4bc8480..c3426213a970 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -8,6 +8,7 @@
=20
 #include "x86.h"
 #include "xen.h"
+#include "hyperv.h"
=20
 #include <linux/kvm_host.h>
=20
@@ -99,6 +100,11 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
=20
 	input =3D (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
=20
+	/* Hyper-V hypercalls get bit 31 set in EAX */
+	if ((input & 0x80000000) &&
+	    kvm_hv_hypercall_enabled(vcpu->kvm))
+		return kvm_hv_hypercall(vcpu);
+
 	longmode =3D is_64_bit_mode(vcpu);
 	if (!longmode) {
 		params[0] =3D (u32)kvm_rbx_read(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
index 3f1dd93626e5..24f279e1a66b 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -15,6 +15,7 @@
=20
 #define HCALL_REGION_GPA	0xc0000000ULL
 #define HCALL_REGION_SLOT	10
+#define PAGE_SIZE		4096
=20
 static struct kvm_vm *vm;
=20
@@ -22,7 +23,12 @@ static struct kvm_vm *vm;
 #define ARGVALUE(x) (0xdeadbeef5a5a0000UL + x)
 #define RETVALUE 0xcafef00dfbfbffffUL
=20
-#define XEN_HYPERCALL_MSR 0x40000000
+#define XEN_HYPERCALL_MSR	0x40000200
+#define HV_GUEST_OS_ID_MSR	0x40000000
+#define HV_HYPERCALL_MSR	0x40000001
+
+#define HVCALL_SIGNAL_EVENT		0x005d
+#define HV_STATUS_INVALID_ALIGNMENT	4
=20
 static void guest_code(void)
 {
@@ -30,6 +36,7 @@ static void guest_code(void)
 	unsigned long rdi =3D ARGVALUE(1);
 	unsigned long rsi =3D ARGVALUE(2);
 	unsigned long rdx =3D ARGVALUE(3);
+	unsigned long rcx;
 	register unsigned long r10 __asm__("r10") =3D ARGVALUE(4);
 	register unsigned long r8 __asm__("r8") =3D ARGVALUE(5);
 	register unsigned long r9 __asm__("r9") =3D ARGVALUE(6);
@@ -41,18 +48,38 @@ static void guest_code(void)
 			     "r"(r10), "r"(r8), "r"(r9));
 	GUEST_ASSERT(rax =3D=3D RETVALUE);
=20
-	/* Now fill in the hypercall page */
+	/* Fill in the Xen hypercall page */
 	__asm__ __volatile__("wrmsr" : : "c" (XEN_HYPERCALL_MSR),
 			     "a" (HCALL_REGION_GPA & 0xffffffff),
 			     "d" (HCALL_REGION_GPA >> 32));
=20
-	/* And invoke the same hypercall that way */
+	/* Set Hyper-V Guest OS ID */
+	__asm__ __volatile__("wrmsr" : : "c" (HV_GUEST_OS_ID_MSR),
+			     "a" (0x5a), "d" (0));
+
+	/* Hyper-V hypercall page */
+	u64 msrval =3D HCALL_REGION_GPA + PAGE_SIZE + 1;
+	__asm__ __volatile__("wrmsr" : : "c" (HV_HYPERCALL_MSR),
+			     "a" (msrval & 0xffffffff),
+			     "d" (msrval >> 32));
+
+	/* Invoke a Xen hypercall */
 	__asm__ __volatile__("call *%1" : "=3Da"(rax) :
 			     "r"(HCALL_REGION_GPA + INPUTVALUE * 32),
 			     "a"(rax), "D"(rdi), "S"(rsi), "d"(rdx),
 			     "r"(r10), "r"(r8), "r"(r9));
 	GUEST_ASSERT(rax =3D=3D RETVALUE);
=20
+	/* Invoke a Hyper-V hypercall */
+	rax =3D 0;
+	rcx =3D HVCALL_SIGNAL_EVENT;	/* code */
+	rdx =3D 0x5a5a5a5a;		/* ingpa (badly aligned) */
+	__asm__ __volatile__("call *%1" : "=3Da"(rax) :
+			     "r"(HCALL_REGION_GPA + PAGE_SIZE),
+			     "a"(rax), "c"(rcx), "d"(rdx),
+			     "r"(r8));
+	GUEST_ASSERT(rax =3D=3D HV_STATUS_INVALID_ALIGNMENT);
+
 	GUEST_DONE();
 }
=20
@@ -73,11 +100,11 @@ int main(int argc, char *argv[])
 	};
 	vm_ioctl(vm, KVM_XEN_HVM_CONFIG, &hvmc);
=20
-	/* Map a region for the hypercall page */
+	/* Map a region for the hypercall pages */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
                                     HCALL_REGION_GPA,
HCALL_REGION_SLOT,
-				    getpagesize(), 0);
-	virt_map(vm, HCALL_REGION_GPA, HCALL_REGION_GPA, 1, 0);
+				    2 * getpagesize(), 0);
+	virt_map(vm, HCALL_REGION_GPA, HCALL_REGION_GPA, 2, 0);
=20
 	for (;;) {
 		volatile struct kvm_run *run =3D vcpu_state(vm, VCPU_ID);
--=20
2.17.1


--=-NzAHaU1phxl2OGSDwjBZ
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAx
MjAxMTExOTMwWjAvBgkqhkiG9w0BCQQxIgQgeM/hzCWWaBKWat1s+PnG5bkS98rO0qBBNiTXTjhG
v3cwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAAE2OxQrhre6ZMDXJiTfiuPoND/HwhrDeQg45o6QXBQTomvpVJ0WMThnvKoxwf2Z
3qob+2CO5l04Tf6MJtJfV4Xk/sYoOPVmMcimNRyS6LvmS6vy1c9UF3mEo8XK21WpqUxnEd6jibfo
Ho21MKHBHQcqcFQDxqwsOps7lRu6Ty6z3hCjJE8c1BKcHmaWaR8Oj5sNblFyxkiZ8gBFhVui+zpQ
qIjV0LERdKcmk4f5no3WaS3RGeDG7euayVCPyyhG5CG8iO69xX0vNdrjJyKrXDF8PLQ7URefPrsi
CDXkb2ASLCdagnzfUgY6hKUFzlFpJFecB/4QukXh3b/mc3unIN0AAAAAAAA=


--=-NzAHaU1phxl2OGSDwjBZ--

