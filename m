Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9025979EA77
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 16:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241222AbjIMOIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 10:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjIMOIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 10:08:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407B919B1
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 07:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:Date:Cc:To:
        From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=jxt9bxGK7CKorrjungcwO4FK3/65JKMsEjvBJMfHGfE=; b=CJR5y/quBvUtHuNGwcdE58puqO
        Ica5/nFJpJ7uxsvSP3pYDgjX3w2XJOa5IfRdtET1jAdXsJ8elllUZvVg1xwKOnYR5aBRpm54rO1cQ
        rCa2iqXV9F+hQc36ik1UtrYs0AInPDX5ig43Zu2EuTZs8AUVcLGIDBiB/NgHyDI0k/s6XN2DhYiEh
        mVnMH9TnmmGFElJm+mdP7SYvkGdDw0Qg4mpvrwE/OjmRLGn8YZu7UL3WiBpQ11isIvC51MrcNh648
        NLBCvK+IGR4ugpx78QxdB3vvIJclwrAELHCC5Lij2yZi5pFkI9RE3B0L/FN/LjUelfgA1BRLLJdvH
        vUwlgHZA==;
Received: from [54.239.6.187] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qgQXX-00EGyd-R0; Wed, 13 Sep 2023 14:08:24 +0000
Message-ID: <13f256ad95de186e3b6bcfcc1f88da5d0ad0cb71.camel@infradead.org>
Subject: [RFC] KVM: x86: Add KVM_VCPU_TSC_SCALE and fix the documentation on
 TSC migration
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     dff@amazon.com, jmattson@google.com, joro@8bytes.org,
        oupton@google.com, pbonzini@redhat.com, seanjc@google.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        Simon Veith <sveith@amazon.de>
Date:   Wed, 13 Sep 2023 16:08:22 +0200
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-bwLX6QE0uIzu4DGIIUUs"
User-Agent: Evolution 3.44.4-0ubuntu2 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-bwLX6QE0uIzu4DGIIUUs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

The documentation on TSC migration using KVM_VCPU_TSC_OFFSET is woefully
inadequate. It ignores TSC scaling, and ignores the fact that the host
TSC may differ from one host to the next (and in fact because of the way
the kernel calibrates it, it generally differs from one boot to the next
even on the same hardware).

Add KVM_VCPU_TSC_SCALE to extract the actual scale ratio and frac_bits,
and attempt to document the *awful* process that we're requiring userspace
to follow to merely preserve the TSC across migration.

I may have thrown up in my mouth a little when writing that documentation.
It's an awful API. If we do this, we should be ashamed of ourselves.
(I also haven't tested the documented process yet).

Let's use Simon's KVM_VCPU_TSC_VALUE instead.
https://lore.kernel.org/all/20230202165950.483430-1-sveith@amazon.de/

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/devices/vcpu.rst | 80 ++++++++++++++++++++-----
 arch/x86/include/uapi/asm/kvm.h         |  6 ++
 arch/x86/kvm/x86.c                      | 15 +++++
 3 files changed, 86 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/k=
vm/devices/vcpu.rst
index 31f14ec4a65b..b6b6e4b98744 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -216,9 +216,11 @@ Returns:
 Specifies the guest's TSC offset relative to the host's TSC. The guest's
 TSC is then derived by the following equation:
=20
-  guest_tsc =3D host_tsc + KVM_VCPU_TSC_OFFSET
+  guest_tsc =3D (( host_tsc * tsc_scale_ratio ) >> tsc_scale_bits ) + KVM_=
VCPU_TSC_OFFSET
=20
-This attribute is useful to adjust the guest's TSC on live migration,
+The value of tsc_scale_bits is 48 on Intel and 32 on AMD. You can calculat=
e
+tsc_scale_ratio as (... where you might be able to botain tsc_scale_bits f=
rom debugfs
+  if you're luckyThis attribute is useful to adjust the guest's TSC on liv=
e migration,
 so that the TSC counts the time during which the VM was paused. The
 following describes a possible algorithm to use for this purpose.
=20
@@ -234,9 +236,19 @@ From the source VMM process:
 3. Invoke the KVM_GET_TSC_KHZ ioctl to record the frequency of the
    guest's TSC (freq).
=20
+4. Read the KVM_VCPU_TSC_SCALE attribute for each vCPU to obtain the
+   src_tsc_ratio[i] and src_tsc_frac_bits[i] values.
+
+5. For each vCPU[i], calculate the guest TSC value (guest_tsc_src) at time
+   [guest_src] in guest KVM time. This is calculated by the formula:
+      guest_tsc_src[i] =3D ((tsc_src * src_tsc_ratio[i]) >> src_tsc_frac_b=
its[i]) + ofs_src[i]
+
 From the destination VMM process:
=20
-4. Invoke the KVM_SET_CLOCK ioctl, providing the source nanoseconds from
+6. Invoke the KVM_SET_TSC_KHZ ioctl to set the scaled frequency of the
+   guest's TSC (freq).
+
+7. Invoke the KVM_SET_CLOCK ioctl, providing the source nanoseconds from
    kvmclock (guest_src) and CLOCK_REALTIME (host_src) in their respective
    fields.  Ensure that the KVM_CLOCK_REALTIME flag is set in the provided
    structure.
@@ -248,20 +260,58 @@ From the destination VMM process:
    between the source pausing the VMs and the destination executing
    steps 4-7.
=20
-5. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (tsc_dest) and
+8. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (tsc_dest) and
    kvmclock nanoseconds (guest_dest).
=20
-6. Adjust the guest TSC offsets for every vCPU to account for (1) time
-   elapsed since recording state and (2) difference in TSCs between the
-   source and destination machine:
+9. Read the KVM_VCPU_TSC_SCALE attribute for each vCPU to obtain the
+   dest_tsc_ratio[i] and dest_tsc_frac_bits[i] values.
+
+10. For each vCPU[i], calculate the guest TSC value (guest_src_dest) at ti=
me
+    [guest_dest] in guest KVM time, as follows:
+       guest_tsc_dest[i] =3D guest_tsc_src[i] + (guest_dest - guest_src) /=
 (1000000 * freq)
+
+11. For each vcpu[i], calculate what KVM will use internally as the scaled
+    guest time _before_ offsetting at time [guest_dest]:
+       raw_guest_tsc_dest[i] =3D (tsc_dest * dest_tsc_ratio[i]) >> dest_ts=
c_frac_bits[i]
+
+12. Calculate the post-scaling guest TSC offsets for every vCPU to account
+    for the difference between the raw scaled value and the intended value=
:
+
+       ofs_dst[i] =3D guest_tsc_dest[i] - raw_guest_tsc_dest[i]
+
+13. Write the KVM_VCPU_TSC_OFFSET attribute for every vCPU with the
+    respective value derived in the previous step.
+
+4.2 ATTRIBUTE: KVM_VCPU_TSC_SCALE
+
+:Parameters: 64-bit fixed point TSC scale factor
+
+Returns:
+
+	 =3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+	 -EFAULT Error reading the provided parameter
+		 address.
+	 -ENXIO  Attribute not supported
+	 -EINVAL Invalid request to write the attribute
+	 =3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+This read-only attribute reports the guest's TSC scaling factor, in the fo=
rm
+of a fixed-point number represented by the following structure:
+
+    struct kvm_vcpu_tsc_scale {
+	    __u64	tsc_ratio;
+	    __u64	tsc_frac_bits;
+    };
+
=20
-   ofs_dst[i] =3D ofs_src[i] -
-     (guest_src - guest_dest) * freq +
-     (tsc_src - tsc_dest)
+The tsc_frac_bits field indicate the location of the fixed point, such tha=
t
+host TSC values are converted to guest TSC using the formula:
=20
-   ("ofs[i] + tsc - guest * freq" is the guest TSC value corresponding to
-   a time of 0 in kvmclock.  The above formula ensures that it is the
-   same on the destination as it was on the source).
+    guest_tsc =3D ( ( host_tsc * tsc_ratio ) >> tsc_frac_bits) + offset
=20
-7. Write the KVM_VCPU_TSC_OFFSET attribute for every vCPU with the
-   respective value derived in the previous step.
+Userspace generally has no need to know this, as it has set the desired
+guest TSC frequency. But since KVM only offsets the KVM_VCPU_TSC_OFFSET
+attribute as documented above, and not a KVM_VCPU_TSC_VALUE attribute
+which would have made life much easier, userspace needs to extract these
+values so that it can do for itself all the calculations that the kernel
+could have done more easily.
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 1a6a1f987949..a7b1406e7e62 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -558,6 +558,12 @@ struct kvm_pmu_event_filter {
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TS=
C) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
+#define   KVM_VCPU_TSC_SCALE  1 /* attribute for TSC scaling factor */
+
+struct kvm_vcpu_tsc_scale {
+	__u64 tsc_ratio;
+	__u64 tsc_frac_bits;
+};
=20
 /* x86-specific KVM_EXIT_HYPERCALL flags. */
 #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6b9bea62fb8..abc951f7bb95 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5462,6 +5462,7 @@ static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcp=
u,
=20
 	switch (attr->attr) {
 	case KVM_VCPU_TSC_OFFSET:
+	case KVM_VCPU_TSC_SCALE:
 		r =3D 0;
 		break;
 	default:
@@ -5487,6 +5488,17 @@ static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vc=
pu,
 			break;
 		r =3D 0;
 		break;
+	case KVM_VCPU_TSC_SCALE: {
+		struct kvm_vcpu_tsc_scale scale;
+
+		scale.tsc_ratio =3D vcpu->arch.l1_tsc_scaling_ratio;
+		scale.tsc_frac_bits =3D kvm_caps.tsc_scaling_ratio_frac_bits;
+		r =3D -EFAULT;
+		if (copy_to_user(uaddr, &scale, sizeof(scale)))
+			break;
+		r =3D 0;
+		break;
+	}
 	default:
 		r =3D -ENXIO;
 	}
@@ -5529,6 +5541,9 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcp=
u,
 		r =3D 0;
 		break;
 	}
+	case KVM_VCPU_TSC_SCALE:
+		r =3D -EINVAL; /* Read only */
+		break;
 	default:
 		r =3D -ENXIO;
 	}
--=20
2.34.1



--=-bwLX6QE0uIzu4DGIIUUs
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwOTEzMTQwODIyWjAvBgkqhkiG9w0BCQQxIgQg32FClFhD
n3xQL7uNHXpTgKUz/UHD2bDGHrasSYmt93gwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgBNrnqt18qaTsCsQUX6YTgtFo2uB3B16jlt
U6WESc6Hnjf2ISUc/0asP8f7bWTnvWeoVdOfOm3n80UQWjfUpVLVOiPevlu6Vffm4Wa6tdUUTf6K
FSnjBCxMl26PpL03obcSitAvBJ/QH2ZaqwPlVoLj6SBtvL8bG/MmLaFMSfpUC0VTESEpBHiCidfP
3DdRvLXgRWInxDIVCuhBZ4Mo1OP8I6aWeRHd53XobHsC9JdE7m76aSBvEEhNBAGiEVcgiPCNMKf5
slhjChfketUafn9qif+dbEResoh1253WbPes3DUiXu5qByCWlNscwkSOPRCj0GGyUkSFXMsNhg0Y
VCtM2BWkiTzeHtjp81M9T+LjSOrMf+aRStQYI6TE+TIi9wPPvD4oWdet3zCRCUwYs5VwxxzFqTdJ
dXZE3bA9IZKrTS0vr48IrLl40cEjJa/UX4iPUGxo3VMcp4Y8WPnqiopogUQ0Mz/fpvKZX+NO2dAd
RA3pZ5hw5bv2fanJcpGPpTS64sxjVk/vYa9yMpD7pk9PvJO1Xz2SO4AdkkG+Uxhy38C5TtIloJbc
/405RBjSWpqTSGDBC3g0Ui0Zs1nSdkPsZ5+6qjCLexahQ8BC+G9q+00S3jApjLCM2hIqMHFJ+Rvh
U8O6hZh3weRqjtf/FV/4wPdVR2Hu0FEn7iBAhEOI2wAAAAAAAA==


--=-bwLX6QE0uIzu4DGIIUUs--
