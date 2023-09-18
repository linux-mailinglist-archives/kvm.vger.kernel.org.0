Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A987A457F
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 11:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbjIRJGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 05:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240965AbjIRJGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 05:06:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6DDC5;
        Mon, 18 Sep 2023 02:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:Date:Cc:To:
        From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=jhKFzfaIrj2yifqprfN7tR//Lqbk6JFSdT37dJb4VL0=; b=QKabkEXGZDcccenpwlyT7dPry+
        X9cTG2wiEFPIZzCpCjycweSVM2LSkPZQHFGryCsStYAzO6U+MAoqfBZ49NbBc8+RO1tCQ6Y6EFn4A
        Y8Q62k6yEhLArtKztOidimg+lJH/bto01H+Kmhl6tATYnFIyrPblOYwamNpOeLkJfksYnpyd+gg/f
        vtDWjisOGCkCJHGhTlhrljyL3QWpoxHIE621C7ngh3m68Ao5jNDR1Q8qTF+1WA7QQUx4Zfd9yzWTx
        jL+iKq+0WZFF4aY8etkWuJU58wLB6t73fVu9ANO+eh6qnkdbVHo8t/3RCQaoXPOy9hFZsLS9xfwPr
        XoA2eJmg==;
Received: from [2001:8b0:10b:5:3cdb:35b0:ea67:aadb] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qiAD3-009yJZ-0J; Mon, 18 Sep 2023 09:06:25 +0000
Message-ID: <1b52b557beb6606007f7ec5672eab0adf1606a34.camel@infradead.org>
Subject: [RFC] KVM: x86: Allow userspace exit on HLT and MWAIT, else yield
 on MWAIT
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        graf@amazon.de, Nicolas Saenz Julienne <nsaenz@amazon.es>,
        "Griffoul, Fred" <fgriffo@amazon.com>
Date:   Mon, 18 Sep 2023 11:06:24 +0200
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-5IlqtGoL4WjBAvGoYipU"
User-Agent: Evolution 3.44.4-0ubuntu2 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URI_DOTEDU autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-5IlqtGoL4WjBAvGoYipU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

The VMM may have work to do on behalf of the guest, and it's often
desirable to use the cycles when the vCPUS are idle.

When the vCPU uses HLT this works out OK because the VMM can run its
tasks in a separate thread which gets scheduled when the in-kernel
emulation of HLT schedules away. It isn't perfect, because it doesn't
easily allow for handling both low-priority maintenance tasks when the
VMM wants to wait until the vCPU is idle, and also for higher priority
tasks where the VMM does want to preempt the vCPU. It can also lead to
noisy neighbour effects, when a host has isn't necessarily sized to
expect any given VMM to suddenly be contending for many *more* pCPUs
than it has vCPUs.=20

In addition, there are times when we need to expose MWAIT to a guest
for compatibility with a previous environment. And MWAIT is much harder
because it's very hard to emulate properly.

There were attempts at doing so based on marking the target page read-
only in MONITOR and triggering the wake when it takes a minor fault,
but so far they haven't led to a working solution:
https://www.contrib.andrew.cmu.edu/~somlo/OSXKVM/mwait.html

So when a guest executes MWAIT, either we've disabled exit-on-mwait and
the guest actually sits in non-root mode hogging the pCPU, or if we do
enable exit-on-mwait the kernel just treats it as a NOP and bounces
right back into the guest to busy-wait round its idle loop.

For a start, we can stick a yield() into that busy-loop. The yield()
has fairly poorly defined semantics, but it's better than *nothing* and
does allow a VMM's thread-based I/O and maintenance tasks to run a
*little* better.

Better still, we can bounce all the way out to *userspace* on an MWAIT
exit, and let the VMM perform some of its pending work right there and
then in the vCPU thread before re-entering the vCPU. That's much nicer
than yield(). The vCPU is still runnable, since we still don't have a
*real* emulation of MWAIT, so the vCPU thread can do a *little* bit of
work and then go back into the vCPU for another turn around the loop.

And if we're going to do that kind of task processing for MWAIT-idle
guests directly from the vCPU thread, it's neater to do it for HLT-idle
guests that way too.

For HLT, the vCPU *isn't* runnable; it'll be in KVM_MP_STATE_HALTED.
The VMM can poll the mp_state and know when the vCPU should be run
again. But not poll(), although we might want to hook up something like
that (or just a signal or eventfd) for other reasons for VSM anyway.
The VMM can also just do some work and then re-enter the vCPU without
the corresponding bit set in the kvm_run struct.

So, er, what does this patch do? Add a capability, define two bits for
exiting to userspace on HLT or MWAIT =E2=80=94 in the kvm_run struct rather
than needing a separate ioctl to turn them on or off, so that the VMM
can make the decision each time it enters the vCPU. Hook it up to
(ab?)use the existing KVM_EXIT_HLT which was previously only used when
the local APIC was emulated in userspace, and add a new KVM_EXIT_MWAIT.

Fairly much untested.

If this approach seems reasonable, of course I'll add test cases and
proper documentation before posting it for real. This is the proof of
concept before we even put it through testing to see what performance
we get out of it especially for those obnoxious MWAIT-enabled guests.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6582c1fd8b9..8f931539114a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2128,9 +2128,23 @@ static int kvm_emulate_monitor_mwait(struct kvm_vcpu=
 *vcpu, const char *insn)
 	pr_warn_once("%s instruction emulated as NOP!\n", insn);
 	return kvm_emulate_as_nop(vcpu);
 }
+
 int kvm_emulate_mwait(struct kvm_vcpu *vcpu)
 {
-	return kvm_emulate_monitor_mwait(vcpu, "MWAIT");
+	int ret =3D kvm_emulate_monitor_mwait(vcpu, "MWAIT");
+
+	if (ret && kvm_userspace_exit(vcpu, KVM_EXIT_MWAIT)) {
+		vcpu->run->exit_reason =3D KVM_EXIT_MWAIT;
+		ret =3D 0;
+	} else {
+		/*
+		 * Calling yield() has poorly defined semantics, but the
+		 * guest is in a busy loop and it's the best we can do
+		 * without a full emulation of MONITOR/MWAIT.
+		 */
+		yield();
+	}
+	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_mwait);
=20
@@ -4554,6 +4568,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
 				r |=3D KVM_X86_DISABLE_EXITS_MWAIT;
 		}
 		break;
+	case KVM_CAP_X86_USERSPACE_EXITS:
+		r =3D KVM_X86_USERSPACE_VALID_EXITS;
+		break;
 	case KVM_CAP_X86_SMM:
 		if (!IS_ENABLED(CONFIG_KVM_SMM))
 			break;
@@ -9643,11 +9660,11 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu=
, int state, int reason)
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
 		vcpu->arch.mp_state =3D state;
-		return 1;
-	} else {
-		vcpu->run->exit_reason =3D reason;
-		return 0;
+		if (!kvm_userspace_exit(vcpu, reason))
+			return 1;
 	}
+	vcpu->run->exit_reason =3D reason;
+	return 0;
 }
=20
 int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1e7be1f6ab29..ce10a809151c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -430,6 +430,19 @@ static inline bool kvm_notify_vmexit_enabled(struct kv=
m *kvm)
 	return kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_ENABLED;
 }
=20
+static inline bool kvm_userspace_exit(struct kvm_vcpu *vcpu, int reason)
+{
+	if (reason =3D=3D KVM_EXIT_HLT &&
+	    (vcpu->run->userspace_exits & KVM_X86_USERSPACE_EXIT_HLT))
+		return true;
+
+	if (reason =3D=3D KVM_EXIT_MWAIT &&
+	    (vcpu->run->userspace_exits & KVM_X86_USERSPACE_EXIT_MWAIT))
+		return true;
+
+	return false;
+}
+
 enum kvm_intr_type {
 	/* Values are arbitrary, but must be non-zero. */
 	KVM_HANDLING_IRQ =3D 1,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 13065dd96132..43d94d49fc24 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -264,6 +264,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_SBI        35
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
+#define KVM_EXIT_MWAIT            38
=20
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -283,7 +284,8 @@ struct kvm_run {
 	/* in */
 	__u8 request_interrupt_window;
 	__u8 immediate_exit;
-	__u8 padding1[6];
+	__u8 userspace_exits;
+	__u8 padding1[5];
=20
 	/* out */
 	__u32 exit_reason;
@@ -841,6 +843,11 @@ struct kvm_ioeventfd {
                                               KVM_X86_DISABLE_EXITS_PAUSE =
| \
                                               KVM_X86_DISABLE_EXITS_CSTATE=
)
=20
+#define KVM_X86_USERSPACE_EXIT_MWAIT	     (1 << 0)
+#define KVM_X86_USERSPACE_EXIT_HLT	     (1 << 1)
+#define KVM_X86_USERSPACE_VALID_EXITS        (KVM_X86_USERSPACE_EXIT_MWAIT=
 | \
+                                              KVM_X86_USERSPACE_EXIT_HLT)
+
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
 	/* in */
@@ -1192,6 +1199,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_COUNTER_OFFSET 227
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
+#define KVM_CAP_X86_USERSPACE_EXITS 230
=20
 #ifdef KVM_CAP_IRQ_ROUTING
=20


--=-5IlqtGoL4WjBAvGoYipU
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwOTE4MDkwNjI0WjAvBgkqhkiG9w0BCQQxIgQgcrHknV5F
Xlg8U5ZXj0r/K3jNHe6NSZesZzk+QabN4Ncwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCemcpN6n+q8dcNBtFci2YiiEUTGRJd8RHh
SLll/RYetImL1mg+HZ4lz6ArjhB3gM97HZMfXviz9uQhXCznr448A4YsyoN70kMuwvWILo/N7WOy
WoztvZilTNo1416CEPOipkxi4g9x+r9K+CPcrVdG78Eh2UYvyGXK5j7Wt7Sins419XKVAXLof3tF
53Y8KINSAdgUoGDUsO0/g0gsCEqQnF/wrOi7KmwUnTn1HTXjFIWn4P0Kc7W6Ei8BorBWHam4B0/k
WSyyZt/7jQl6bk+pwiyw6t8ReYN+YkoYnacOFBaPz1yA3QJ65JgHMQmr/2kG2WEAPlOC/eLCewQy
81TR0rdNxZfVGfjWJl9fgIQWDS34EdbBDrFZDGM8l+GEgqnp9OpTFybhhsA4Omlwer+jsxkBO9Fw
5DKojPestpDzLhwH1GEhFxKZ8x6jYkO2398R6u1mvKHie+mgewZkzWcFGSy/nM4QyPg2SvWWurIv
vOB3R+vg4bbSmSj67FlXdMON+T86k99G1rnweIQX0+4PDvqcRreNmsANVWHbWa6T7JyhyYsOa+9H
H8cxVBXqrm6RQFH6eVilCz20a2wWfusspNll7oR4/pFP+wBVxQCYIMFUoW46adLuvym/lvysC2tG
oFn611uMjhBmNAAQ5Ayx/cadj0oRoooHslbJUvbfMAAAAAAAAA==


--=-5IlqtGoL4WjBAvGoYipU--
