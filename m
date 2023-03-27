Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1056CADDD
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 20:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjC0Sti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 14:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjC0St1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 14:49:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FE54EEF;
        Mon, 27 Mar 2023 11:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xJDdnVqhqfr9cZzXjBgqzehbDyNxphp+BxbaTB3XXqI=; b=piacN6K5WMEj/TK0yJ+UcJUsf6
        /XWboIWsuj/G+f9TcsnOhhb9nP8r0GmSji3qj5cWQvCUIPIox5UTx+GlrioYN+BY3zzKIgXdzoWXb
        rgkzOHoa+f5b/1Dr+CfDcHJ1G5HMMr55+te6jpLcNWo8fAYPNhLHCmZiDFCTcmovQRDCP11vcidxh
        Q0kcDUxo6Agp+0JjLiDr0znOJfYpBgR/4rmewpqZBwM+eQtsVvo7eGH6lF0DpltUcxIYOsTqiNr6X
        yNZd8Mcb+NaX5sv7P/o3PXBXz8zYfgfXBqEeuSPowp9VossEuJoLHGZ1EUwHGWsWgtkENFUWwhpZT
        sR1uBMEw==;
Received: from [2001:8b0:10b:5:bd73:4bc:634b:34b] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pgrtL-007eCb-5h; Mon, 27 Mar 2023 18:48:27 +0000
Message-ID: <09f9f70abce36830e770ded83c20141411675971.camel@infradead.org>
Subject: Re: [PATCH v16 3/8] cpu/hotplug: Add dynamic parallel bringup
 states before CPUHP_BRINGUP_CPU
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com
Date:   Mon, 27 Mar 2023 19:48:25 +0100
In-Reply-To: <871qlf83wj.ffs@tglx>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
         <20230321194008.785922-4-usama.arif@bytedance.com> <874jqb8588.ffs@tglx>
         <871qlf83wj.ffs@tglx>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-ZRPtdOAoXpFJFN/Y9dRG"
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-ZRPtdOAoXpFJFN/Y9dRG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-03-24 at 00:05 +0100, Thomas Gleixner wrote:
>=20
> > There is no point in special casing this. All architectures can invoke
> > the CPUHP_BP_* states before CPUHP_BRINGUP_CPU for each to be brought u=
p
> > CPU first. So this can be made unconditional and common exercised
> > code.
>=20
> Bah. There is. We discussed that before. Architectures need to opt in to
> make sure that there are no implicit dependencies on the full
> serialization.
>=20
> Still the rest can be simplified as below.

Ack.

Full series at https://git.infradead.org/users/dwmw2/linux.git/shortlog/ref=
s/heads/parallel-6.2-v17

From: David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 3/8] cpu/hotplug: Add CPUHP_BP_PARALLEL_STARTUP state befor=
e
 CPUHP_BRINGUP_CPU

There is often significant latency in the early stages of CPU bringup,
and time is wasted by waking each CPU (e.g. with SIPI/INIT/INIT on x86)
and then waiting for it to make its way through hardware powerup and
through firmware before finally reaching the kernel entry point and
moving on through its startup.

Allow a platform to register a pre-bringup CPUHP state to which each
CPU can be stepped in parallel, thus absorbing some of that latency.

There is a subtlety here: even with an empty CPUHP_BP_PARALLEL_STARTUP
step, this means that *all* CPUs are brought through the prepare states
all the way to CPUHP_BP_PARALLEL_STARTUP before any of them are taken
to CPUHP_BRINGUP_CPU and then are allowed to run for themselves to
CPUHP_ONLINE.

So any combination of prepare/start calls which depend on A-B ordering
for each CPU in turn would explore horribly. As an example, the X2APIC
code prior to commit cefad862f238 ("x86/apic/x2apic: Allow CPU
cluster_mask to be populated in parallel") would allocate a new cluster
mask "just in case" and store it in a global variable in the prep stage,
then the AP would potentially consume that preallocated structure and set
the global pointer to NULL to be reallocated in CPUHP_X2APIC_PREPARE for
the next CPU. Which doesn't work at all if the prepare step is run for
all the CPUs first.

Any platform enabling the CPUHP_BP_PARALLEL_STARTUP step must be
reviewed and tested to ensure that such issues do not exist, and the
existing behaviour of each AP through to CPUHP_BP_PREPARE_DYN and then
immediately to CPUHP_BRINGUP_CPU and CPUHP_ONLINE only one at a time
does not change unless such a state is registered.

Note that this does *not* yet bring each AP to the CPUHP_BRINGUP_CPU
state at the same time, only to the new CPUHP_BP_PARALLEL_STARTUP state.
The final loop in bringup_nonboot_cpus() remains the same, bringing each
AP in turn from the CPUHP_BP_PARALLEL_STARTUP (or all the way from
CPUHP_OFFLINE) to CPUHP_BRINGUP_CPU and then waiting for that AP to do
its own processing and reach CPUHP_ONLINE before releasing the next.

Parallelising that part by bringing them all to CPUHP_BRINGUP_CPU and
then waiting for them all to run to CPUHP_ONLINE at the same time is a
more complicated exercise for the future.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com> [arm64]
---
 include/linux/cpuhotplug.h | 22 ++++++++++++++++++++++
 kernel/cpu.c               | 38 +++++++++++++++++++++++++++++++++++---
 2 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index c6fab004104a..84efd33ed3a3 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -133,6 +133,28 @@ enum cpuhp_state {
 	CPUHP_MIPS_SOC_PREPARE,
 	CPUHP_BP_PREPARE_DYN,
 	CPUHP_BP_PREPARE_DYN_END		=3D CPUHP_BP_PREPARE_DYN + 20,
+	/*
+	 * This is an optional state if the architecture supports parallel
+	 * startup. It's used to start bringing the CPU online (e.g. send
+	 * the startup IPI) so that the APs can run in parallel through
+	 * the low level startup code instead of waking them one by one in
+	 * CPUHP_BRINGUP_CPU. This avoids waiting for the AP to react and
+	 * shortens the serialized phase of the bringup.
+	 *
+	 * If the architecture registers this state, all APs will be taken
+	 * to it (and thus through all prior states) before any is taken
+	 * to the subsequent CPUHP_BRINGUP_CPU state.
+	 */
+	CPUHP_BP_PARALLEL_STARTUP,
+
+	/*
+	 * This step brings the AP online and takes it to the point where it
+	 * manages its own state from here on. For the time being, the rest
+	 * of the AP bringup is fully serialized despite running on the AP.
+	 * If the architecture doesn't use the CPUHP_BP_PARALLEL_STARTUP
+	 * state, this step also does all the work of bringing the CPU
+	 * online.
+	 */
 	CPUHP_BRINGUP_CPU,
=20
 	/*
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 43e0a77f21e8..6be5b60db51b 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1504,13 +1504,45 @@ int bringup_hibernate_cpu(unsigned int sleep_cpu)
=20
 void bringup_nonboot_cpus(unsigned int setup_max_cpus)
 {
-	unsigned int cpu;
+	unsigned int cpu, n =3D num_online_cpus();
=20
+	/*
+	 * On architectures which have setup the CPUHP_BP_PARALLEL_STARTUP
+	 * state, this invokes all BP prepare states and the parallel
+	 * startup state sends the startup IPI to each of the to be onlined
+	 * APs. This avoids waiting for each AP to respond to the startup
+	 * IPI in CPUHP_BRINGUP_CPU. The APs proceed through the low level
+	 * bringup code and then wait for the control CPU to release them
+	 * one by one for the final onlining procedure in the loop below.
+	 *
+	 * For architectures which do not support parallel bringup all
+	 * states are fully serialized in the loop below.
+	 */
+	if (!cpuhp_step_empty(true, CPUHP_BP_PARALLEL_STARTUP)) {
+		for_each_present_cpu(cpu) {
+			if (n++ >=3D setup_max_cpus)
+				break;
+			cpu_up(cpu, CPUHP_BP_PARALLEL_STARTUP);
+		}
+	}
+
+	/* Do the per CPU serialized bringup to ONLINE state */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >=3D setup_max_cpus)
 			break;
-		if (!cpu_online(cpu))
-			cpu_up(cpu, CPUHP_ONLINE);
+
+		if (!cpu_online(cpu)) {
+			struct cpuhp_cpu_state *st =3D per_cpu_ptr(&cpuhp_state, cpu);
+			int ret =3D cpu_up(cpu, CPUHP_ONLINE);
+
+			/*
+			 * Due to the above preparation loop a failed online attempt
+			 * might have only rolled back to CPUHP_BP_PARALLEL_STARTUP. Do the
+			 * remaining cleanups. NOOP for the non parallel case.
+			 */
+			if (ret && can_rollback_cpu(st))
+				WARN_ON(cpuhp_invoke_callback_range(false, cpu, st, CPUHP_OFFLINE));
+		}
 	}
 }
=20
--=20
2.34.1



--=-ZRPtdOAoXpFJFN/Y9dRG
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwMzI3MTg0ODI1WjAvBgkqhkiG9w0BCQQxIgQgwM5xZUNq
08781QJ5oqqkaPM6aTbUe7fk0F+2sk6iaUAwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgB6Qr97dGUXKDQMosAjvQkN7d9ceLev0Ih+
HrbeUarhVmAPehNyZJhLqoTQdcdLmYdCSZB/d1KDsYkx1Qvijz7Azrmu5V4HVRrxuSLJ8p5xQOHS
gi28mgaV0erBvQXWNk4ArrYvyS7qwTrFcEh5+mfqqLix534BMYcg7IRBurO2ri5N66RLC6EapaEV
/gDvJlE+ZqElSLiqFwOmAFs4M4QjZGX0ZBSQbY2YU79B9GxyZHI4opiqJFKVdiivJB32CD2bzEaf
GZAczy9/gVm5cvTEZbiCnSNY4e3nTitMU3S+rw2oHK5dUngVr6dnCqi66nGpesjPsVxLRdK965ZU
J17y7WEOpwIPA73aI+4n9vH1TWQSgFbUOR7kFHrQY7j0jX2zOoe/XRGA/HcZJHLiaq0brWz3ObfI
thWCvtDOs3RY+dYasvMsB/jfy74u2K2Ev/Az0I138tNN4cairuCEYjKrA1UBYtTRQg7FChegA2Th
hMY5ERwpCgU/Sl+uUX4arMPjk8258BTqpH3XPP/4TyewVkoydEMR2okTuwrrhyKq6uVIxNGMR6N+
SmhBN112yD0SRCgu6Tts2m4YfYN5svI7F+83lwXRwYiqqyxWcjXmNq6RYcnqHuWE+BSKoDft3Zfa
rZOzEottbR1qpPgWHwsLHS87RYlln2lsqz1Lw+pFOAAAAAAAAA==


--=-ZRPtdOAoXpFJFN/Y9dRG--
