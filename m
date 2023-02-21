Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E95469EB17
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 00:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjBUXTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 18:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBUXTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 18:19:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5515C1D92A;
        Tue, 21 Feb 2023 15:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jXS1lkQkZmvbjWHdrm1FdRIWIWKga2358QZjX0MZOsA=; b=oC/iqxMFVpMFLrUKoSwRvv6J5S
        Z3nkIwV+pjc5ZB9kuyi4cegapYHzBoHlA8IjPsxmv9J+1wP/fa5GWvkGrb3nxlV/aJdJTyBNAtHB1
        VFq2fGW1zdQk7vH+7mz+Mbc17VDvR5a8rkCij4KdL2tJCOzZZel8i4P6Epp/nyzpIvMVqIdemkGxA
        0vqy8wSWOOFdhyh+GQrOjvnxrsGLdY2xrRKdl1Ie4aGYJmYJ7shTFthA6zsWUTfRQWDUb80COX71Y
        B6pWebq/fUYAwisoOacu8WQoDMMo4kpXEzYbN4sysL1WPj8k02l+vZJF04wIIrZhJFsp5SrplDVjS
        NoeU1kxw==;
Received: from [2001:8b0:10b:5::bb3] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pUbuE-00Czml-6h; Tue, 21 Feb 2023 23:18:42 +0000
Message-ID: <aac036a17b1bcbabe8ee5a7c69fb2dfbc546d06e.camel@infradead.org>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Piotr Gorski <piotrgorski@cachyos.org>
Date:   Tue, 21 Feb 2023 23:18:40 +0000
In-Reply-To: <87356yofw3.ffs@tglx>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
         <2668869.mvXUDI8C0e@natalenko.name>
         <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
         <982e1d6140705414e8fd60b990bd259a@natalenko.name>
         <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
         <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com>
         <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
         <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
         <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
         <3d8ed6e157df10c5175c636de0e21849@natalenko.name>
         <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org>
         <ee0d0d971a3095d6a1e96ad4f1ba32d2@natalenko.name>
         <5b8f9c89f7015fa80c966c6c7f6fa259db6744f8.camel@infradead.org>
         <ce731b5a4a53680b4840467977b33d9a@natalenko.name>
         <85ceb3f92abf3c013924de2f025517372bed19c0.camel@infradead.org>
         <3e5944de08ef0d23584d19bad7bae66c@natalenko.name>
         <26E5DC9C-0F19-4E4F-9076-04506A197374@infradead.org>
         <f71275dc809cfb32df513023786c3faa@natalenko.name>
         <10CA27BB-ADC6-4421-86D2-A83BD7FA12E0@infradead.org>
         <9153284c37a79d303aa79dbf07c10329@natalenko.name>
         <e2e6616f691f1822035be245ec847f7c86a26367.camel@infradead.org>
         <87356yofw3.ffs@tglx>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-o274mTLIPhXV2Hx9LY6J"
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-o274mTLIPhXV2Hx9LY6J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-02-21 at 22:41 +0100, Thomas Gleixner wrote:
>=20
> @@ -57,6 +58,7 @@ asmlinkage acpi_status __visible x86_acp
> =C2=A0 */
> =C2=A0int x86_acpi_suspend_lowlevel(void)
> =C2=A0{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int __maybe_unused sa=
ved_smpboot_ctrl;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct wakeup_header *hea=
der =3D
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0(struct wakeup_header *) __va(real_mode_header->wak=
eup_header);
> =C2=A0
> @@ -115,7 +117,8 @@ int x86_acpi_suspend_lowlevel(void)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0early_gdt_descr.address =
=3D
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(un=
signed long)get_cpu_gdt_rw(smp_processor_id());
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0initial_gs =3D per_cpu_of=
fset(smp_processor_id());
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0smpboot_control =3D 0;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Force the startup into boot=
 mode */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0saved_smpboot_ctrl =3D xchg(&s=
mpboot_control, 0);
> =C2=A0#endif
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0initial_code =3D (unsigne=
d long)wakeup_long64;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 saved_magic =3D 0x123456789abc=
def0L;
> @@ -128,6 +131,9 @@ int x86_acpi_suspend_lowlevel(void)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pause_graph_tracing();
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0do_suspend_lowlevel();
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unpause_graph_tracing();
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (IS_ENABLED(CONFIG_64BIT) &=
& IS_ENABLED(CONFIG_SMP))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0smpboot_control =3D saved_smpboot_ctrl;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> =C2=A0}
> =C2=A0

But wait, why is this giving it a dedicated temp_stack anyway? Why
can't it use that CPU's idle thread stack like we usually do? I already
made idle_thread_get() accessible from here. So we could do this...

@@ -111,14 +112,16 @@ int x86_acpi_suspend_lowlevel(void)
        saved_magic =3D 0x12345678;
 #else /* CONFIG_64BIT */
 #ifdef CONFIG_SMP
-       initial_stack =3D (unsigned long)temp_stack + sizeof(temp_stack);
-       early_gdt_descr.address =3D
-                       (unsigned long)get_cpu_gdt_rw(smp_processor_id());
-       initial_gs =3D per_cpu_offset(smp_processor_id());
-       smpboot_control =3D 0;
+       if (!(smpboot_control & STARTUP_PARALLEL_MASK)) {
+               unsigned int cpu =3D smp_processor_id();
+               initial_stack =3D (unsigned long)idle_thread_get(cpu)->thre=
ad.sp;
+               early_gdt_descr.address =3D (unsigned long)get_cpu_gdt_rw(c=
pu);
+               initial_gs =3D per_cpu_offset(cpu);
+               smpboot_control =3D 0;
+       }
 #endif
        initial_code =3D (unsigned long)wakeup_long64;


But that's a whole bunch of pointless, because it can be even further
simplified to just let the find its own crap like the secondaries do,
except in the 'OMG CPUID won't tell me' case where it has to be told:

So how about we just do something more like this. I'd *quite* like to
put the actual handling of smpboot_control into a function we call in
smpboot.c. and that whole x86_acpi_suspend_lowlevel() function wants
all its horrid 64bit/smp ifdefs fixed up (and is there any reason
there's a generic part saving CR0 and IA32_MISC_ENABLE right in the
middle of some !CONFIG_64BIT parts? I don't see ordering constraints
there). But this should work, I think:

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 33c0d5fd8af6..72b9375fec7c 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -208,4 +208,6 @@ extern unsigned int smpboot_control;
 #define STARTUP_APICID_CPUID_0B	0x40000000
 #define STARTUP_APICID_CPUID_01	0x20000000
=20
+#define STARTUP_PARALLEL_MASK	0x60000000
+
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 06adf340a0f1..a1343a900caf 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -16,17 +16,14 @@
 #include <asm/cacheflush.h>
 #include <asm/realmode.h>
 #include <asm/hypervisor.h>
-
+#include <asm/smp.h>
+#include <linux/smpboot.h>
 #include <linux/ftrace.h>
 #include "../../realmode/rm/wakeup.h"
 #include "sleep.h"
=20
 unsigned long acpi_realmode_flags;
=20
-#if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
-static char temp_stack[4096];
-#endif
-
 /**
  * acpi_get_wakeup_address - provide physical address for S3 wakeup
  *
@@ -111,14 +108,11 @@ int x86_acpi_suspend_lowlevel(void)
 	saved_magic =3D 0x12345678;
 #else /* CONFIG_64BIT */
 #ifdef CONFIG_SMP
-	initial_stack =3D (unsigned long)temp_stack + sizeof(temp_stack);
-	early_gdt_descr.address =3D
-			(unsigned long)get_cpu_gdt_rw(smp_processor_id());
-	initial_gs =3D per_cpu_offset(smp_processor_id());
-	smpboot_control =3D 0;
+	if (!(smpboot_control & STARTUP_PARALLEL_MASK))
+		smpboot_control =3D STARTUP_SECONDARY | cpu_physical_id(smp_processor_id=
());
 #endif
 	initial_code =3D (unsigned long)wakeup_long64;
-       saved_magic =3D 0x123456789abcdef0L;
+	saved_magic =3D 0x123456789abcdef0L;
 #endif /* CONFIG_64BIT */
=20
 	/*



--=-o274mTLIPhXV2Hx9LY6J
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwMjIxMjMxODQwWjAvBgkqhkiG9w0BCQQxIgQgWwNkjwgj
c6DK8luZ6HP7P/FLnn7SxgPw+T1qaGCIH2Mwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCnDP+Rqkh0lwjd+h90KbZcPsRaFyE4T1ad
iu7HkqVA2V3fQXbwK2jMosRMDQx+JK0QvKAcygXY/zx1V35sRVAd5hmM/YudiDFSUu1YPUuFjb89
hC1h0D8cRDQQCCk59xM8ygCIWJ6KY3bMczylCgwWZcxAfIZNjmwxJNWAiYo74PxLwelpTckv3Aw6
+pGlTdeNh5wAUiXp6G+e0xYsh/j9S/lzX7lDUe2RI1ZP9ZcfxYJ1Wzs+yBxW6zNgJ+Wiy2u8Uqk8
8YpIl9nYOA/4CLd9MXnn5jxxOWj5EM16lQ0Q2QLjKMP2U3FMKxlHarGC2y0xWFYPmN65C4RGV05g
4h++5HXdYO53a3JDxBFkuMyNX4BRmRPVcj8afnoiRR3IrQaY0KieQ6EZ71d9WTMz3l3WgbZi11ZP
ayb7Bjo48yE3lPFu3v1X+zBPqY+esheDhv/iABKuW7U7xC51wsR9Oxj6sp/c5jfBOcf4edeqOg6x
oDVjvsPcNL/REf1bYHXzPNkHH+kE4vRKX/7+I5JSwwcO0ModSQo901nLSgZ1/ZbIHtbfFUbRxRJT
lcJpcxVNDtcn0Bq+fcQonYi6EHzcJzpKn9Yw4ln/X6UPCIWjfMWzD6gqDlIHfkBLRC+ezlOjdPH+
8k3VDG7gQYCAkBonSUdxv6B5mfUqsIlh8aPtBgm2/QAAAAAAAA==


--=-o274mTLIPhXV2Hx9LY6J--
