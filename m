Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF3F4C38A8
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 23:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbiBXWSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 17:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiBXWSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 17:18:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFBD125538
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 14:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:Date:Cc:To:
        From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=1wBCfsx8spw1U5YsfaGXQrf7XTZr980qDhyqopqg9/A=; b=K8ebae31sADujY2jzRFQMZSscO
        o8x8k8djXNdheeo3OepfB836kmqBbL+iJStAp3hpsIuvkb2Ocj9bkWq7T8cQ8VlyaZ0f7LD/5FLTN
        nvn0N4DS80Q/AOX2AYlnavP/Qw7cwoy4zygJLpwjupdrICyGvKrZhQAjrTWvbNYIK0W1gxdIaPtak
        Cap/ntpMz2San8gAKQ6Hmk4MZP+a4iyRkYM/LMe40fr02RNnXt2krZcXv0paRawSstSPGX4AGevN7
        MT2YIdjFJ8nMIx8amn52VCWEDIJs1aoRt260D6kQJRTONDIchK55ZMtn5hBA8/orbiTSCLfQPNM8m
        A9DQCAaA==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNMR1-005Bne-FQ; Thu, 24 Feb 2022 22:18:03 +0000
Message-ID: <e7be32b06676c7ebf415d9deea5faf50aa8c0785.camel@infradead.org>
Subject: [RFC PATCH] KVM: x86: (Failing) test case for TSC scaling and
 offset sync
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Stamatis, Ilias" <ilstam@amazon.com>
Cc:     Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Graf <graf@amazon.com>,
        =?ISO-8859-1?Q?Sch=F6nherr=2C?= "Jan H." <jschoenh@amazon.de>
Date:   Thu, 24 Feb 2022 22:18:02 +0000
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-pAz3AAo4mrVUpulVIrLv"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-pAz3AAo4mrVUpulVIrLv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here's a fun test case. Create a VM, then spawn a bunch of threads each
of which creates its own vCPU and then sets the TSC frequency and
value. The guest vCPUs then run a stupidly na=C3=AFve loop checking for TSC
monotonicity.

It dies horribly. Even if you use its "nice" mode where it actually
serializes everything and the startup effectively isn't threaded at
all.

I can fix the serialized and "first CPU is scaled before the others are
created" modes, by making new vCPUs get created with the same frequency
of the last TSC sync. That is, in kvm_arch_vcpu_create() I make it do:
kvm_set_tsc_khz(READ_ONCE(vcpu->kvm->arch.last_tsc_khz) ? : max_tsc_khz)
instead of just using max_tsc_khz unconditionally.

The free-for-all mode of all threads just running freely and creating
their vCPU, then setting its frequency and its TSC value, remains
hosed. We end up with kvm->arch.last_tsc_khz *alternating* between the
default startup frequency and the user-configured one. I wonder if the
answer here might be for new vCPUs not to get kvm->arch.last_tsc_khz
from the last sync, but for them to inherit the last *explicitly* set
TSC frequency, which we'd have to store separately?

There are still potential race conditions between the initial frequency
being set in kvm_arch_vcpu_create(), and the first TSC sync which
happens later in kvm_arch_vcpu_postcreate(). It's possible that another
vCPU has explicitly set its frequency in between those two being called
for a newly-created vCPU, and the new one would still not sync
correctly because of the apparent mismatch.

A KVM-wide setting for the default frequency, instead of inferring it
from an explicit setting on a vCPU, might address that... ?

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/tsc_scaling_sync.c   | 143 ++++++++++++++++++
 2 files changed, 144 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests=
/kvm/Makefile
index 06c3a4602bcc..33b57f8c6251 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -65,6 +65,7 @@ TEST_GEN_PROGS_x86_64 +=3D x86_64/state_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/svm_int_ctl_test
+TEST_GEN_PROGS_x86_64 +=3D x86_64/tsc_scaling_sync
 TEST_GEN_PROGS_x86_64 +=3D x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/userspace_io_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/userspace_msr_exit_test
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/=
testing/selftests/kvm/x86_64/tsc_scaling_sync.c
new file mode 100644
index 000000000000..f4a68b709a2c
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * tsc_scaling_sync.c
+ *
+ * Copyright =C2=A9 2022 Amazon.com, Inc. or its affiliates.
+ *
+ * TSC scaling / sync test
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#include <stdint.h>
+#include <time.h>
+#include <sched.h>
+#include <signal.h>
+#include <pthread.h>
+
+#define NR_TEST_VCPUS 20
+
+static struct kvm_vm *vm;
+pthread_spinlock_t create_lock;
+
+#define TEST_TSC_KHZ    2987654UL
+#define TEST_TSC_OFFSET 200000000
+
+uint64_t tsc_sync;
+static void guest_code(void)
+{
+	uint64_t start_tsc, local_tsc, tmp;
+
+	GUEST_SYNC(0);
+
+	start_tsc =3D rdtsc();
+	do {
+		tmp =3D READ_ONCE(tsc_sync);
+		local_tsc =3D rdtsc();
+		WRITE_ONCE(tsc_sync, local_tsc);
+		if (unlikely(local_tsc < tmp))
+			GUEST_SYNC_ARGS(1, local_tsc, tmp, 0, 0);
+		//GUEST_ASSERT(local_tsc <=3D tmp);
+	} while (local_tsc - start_tsc < 5000 * TEST_TSC_KHZ);
+
+	GUEST_DONE();
+}
+
+
+enum {
+      ALL_SERIALIZED,
+      FIRST_SERIALIZED,
+      NONE_SERIALIZED
+} serialize_mode =3D FIRST_SERIALIZED;
+
+
+static void *run_vcpu(void *_cpu_nr)
+{
+	unsigned long cpu =3D (unsigned long)_cpu_nr;
+	unsigned long failures =3D 0;
+	static bool first_cpu_scaled;
+	bool this_cpu_scaled =3D false;
+
+	pthread_spin_lock(&create_lock);
+
+	vm_vcpu_add_default(vm, cpu, guest_code);
+
+	if (serialize_mode =3D=3D ALL_SERIALIZED ||
+	    (serialize_mode =3D=3D FIRST_SERIALIZED && !first_cpu_scaled)) {
+		vcpu_ioctl(vm, cpu, KVM_SET_TSC_KHZ, (void *) TEST_TSC_KHZ);
+		vcpu_set_msr(vm, cpu, MSR_IA32_TSC, TEST_TSC_OFFSET);
+		this_cpu_scaled =3D first_cpu_scaled =3D true;
+	}
+
+	pthread_spin_unlock(&create_lock);
+
+	if (!this_cpu_scaled) {
+		vcpu_ioctl(vm, cpu, KVM_SET_TSC_KHZ, (void *) TEST_TSC_KHZ);
+		vcpu_set_msr(vm, cpu, MSR_IA32_TSC, TEST_TSC_OFFSET);
+	}
+
+	for (;;) {
+		volatile struct kvm_run *run =3D vcpu_state(vm, cpu);
+                struct ucall uc;
+
+                vcpu_run(vm, cpu);
+                TEST_ASSERT(run->exit_reason =3D=3D KVM_EXIT_IO,
+                            "Got exit_reason other than KVM_EXIT_IO: %u (%=
s)\n",
+                            run->exit_reason,
+                            exit_reason_str(run->exit_reason));
+
+                switch (get_ucall(vm, cpu, &uc)) {
+                case UCALL_DONE:
+			goto out;
+
+                case UCALL_SYNC:
+			switch(uc.args[1]) {
+			case 0:
+				//printf("set TSC\n");
+				//	vcpu_set_msr(vm, cpu, MSR_IA32_TSC, 0);
+				break;
+
+			case 1:
+				printf("Guest %ld sync %lx %lx %ld\n", cpu, uc.args[2], uc.args[3], uc=
.args[2] - uc.args[3]);
+				failures++;
+				break;
+			}
+			break;
+
+                default:
+                        TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+ out:
+	return (void *)failures;
+}
+
+int main(int argc, char *argv[])
+{
+        if (!kvm_check_cap(KVM_CAP_TSC_CONTROL)) {
+		print_skip("KVM_CAP_TSC_CONTROL not available");
+		exit(KSFT_SKIP);
+	}
+
+	vm =3D vm_create_default_with_vcpus(0, DEFAULT_STACK_PGS * NR_TEST_VCPUS,=
 0, guest_code, NULL);
+
+	pthread_spin_init(&create_lock, PTHREAD_PROCESS_PRIVATE);
+	pthread_t cpu_threads[NR_TEST_VCPUS];
+	unsigned long cpu;
+	for (cpu =3D 0; cpu < NR_TEST_VCPUS; cpu++)
+		pthread_create(&cpu_threads[cpu], NULL, run_vcpu, (void *)cpu);
+
+	unsigned long failures =3D 0;
+	for (cpu =3D 0; cpu < NR_TEST_VCPUS; cpu++) {
+		void *this_cpu_failures;
+		pthread_join(cpu_threads[cpu], &this_cpu_failures);
+		failures +=3D (unsigned long)this_cpu_failures;
+	}
+
+	TEST_ASSERT(!failures, "TSC sync failed");
+	pthread_spin_destroy(&create_lock);
+	kvm_vm_free(vm);
+	return 0;
+}



--=-pAz3AAo4mrVUpulVIrLv
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIwMjI0MjIxODAyWjAvBgkqhkiG9w0BCQQxIgQgAno3Cpvh
Y37HH2T2BNdsVTr3+zlT3+wNMpEyyQ6N1Yowgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgBoCatOyFpg/K7v71cXlDofmVngMq+PTIVX
paMYNxkWPiKu0ijepIoQmjel3K07IFGcvLT8qRV9mpdGUYJCTyL0nKCz0i7A0y/G5noUt2MN93nK
GohzH0dxE3LJrNRBknmKrYSDNidnwnOzM1fofuE77L7wjP9J/3QeaIZr17lWM0GWhmrptMJdqP/e
26OZC5BJpNJ9xve+WvAl8ItbtE74kq+wpAmKbE7t9ddB3ypV2fFMNnyYg2PFV8z3vOTS4cRAgxfh
5MH0xpZDeHjej5EJYgs7+87Zqo5kEPlehFjuhtv9a+AhFcryREzVtQr7N3ZYSFzATXGWYxXkUptL
BzWUlq62okY+ZDAXhqMND6g37zA6YlBM9SSrEKxJl8CGuJSDIJt3ah2Ji6fSaq9zcdzBZr/KoL/K
VLzHr1wa9R1br4O8/rjvGYKIUaX3jC0X4wz2Y4ZoFaT9qMHHCXDNSV5y5yM9uK09PrjLG1juc3g6
xvcVew6y671QcXpZ+79fgG2TxcJRu1Cf1TMjJaVMhp8N/MhApUtQU6rCDNOBuxGt++qtq3NmVFU6
ELsS0StW/VbhXilNwoDP5TTtxDNC1lT46MKqHLo6ZrAyIf327GPPbk106KRv8LnDyPc1altRWvii
V65lF4GOLqs31izZMtLp7kAwYdP9ddlHDMM6mKRlfwAAAAAAAA==


--=-pAz3AAo4mrVUpulVIrLv--

