Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8072D7D3A7D
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 17:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjJWPQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 11:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjJWPQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 11:16:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F0FDD
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 08:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=a7KCwc6kpWICvbr3wDa3gXSFSI8zZxkI0fbSpfd2dW0=; b=ZWTRKa4H264HFM+Wbyam6/OMfC
        hw9IbWnFhI07e3rr6k9Kh9yBgFkm2K3Fdc3pgF6V0ZCrzNuBv9q5PVUNJGOZzEjI/n0TD5mnlo4Y5
        /Ot3JFYMvfQDtXzlZ5y+PsmwwPMV0U0osA/zoVbcmW3fw84V0xtE086Mwrk6xahzQfg+uEpBFP9ND
        7Lw5wu4d294DnDdYyqqE2yNHMLorW7HyGoBM5I53ejKso1PwONfdcYmxVzfk0mFyQr2ZwKY9BRKYr
        EZd2OBEl/49j+M3SfhKDgszJMUDrjIRsfsQTxh3h1K/moa7bYPXljdGDiTTLv29DlTFuXSONgHqOI
        0FYo6V7w==;
Received: from [2001:8b0:10b:5:545e:5208:5de0:9d33] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1quwbt-00EUbh-SS; Mon, 23 Oct 2023 15:12:53 +0000
Message-ID: <c6e43893a5c8661aced1685fb97adf63ab224689.camel@infradead.org>
Subject: Re: [RFC PATCH 01/19] cpus: Add argument to qemu_get_cpu() to
 filter CPUs by QOM type
From:   David Woodhouse <dwmw2@infradead.org>
To:     Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        qemu-arm@nongnu.org, qemu-riscv@nongnu.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        qemu-ppc@nongnu.org, Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-s390x@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Zhao Liu <zhao1.liu@intel.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Leif Lindholm <quic_llindhol@quicinc.com>,
        Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Song Gao <gaosong@loongson.cn>,
        Thomas Huth <huth@tuxfamily.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Dr. David Alan Gilbert" <dave@treblig.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org
Date:   Mon, 23 Oct 2023 16:12:52 +0100
In-Reply-To: <20231020163643.86105-2-philmd@linaro.org>
References: <20231020163643.86105-1-philmd@linaro.org>
         <20231020163643.86105-2-philmd@linaro.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-FWRpaywbbUZVahT/LGYI"
User-Agent: Evolution 3.44.4-0ubuntu2 
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


--=-FWRpaywbbUZVahT/LGYI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-10-20 at 18:36 +0200, Philippe Mathieu-Daud=C3=A9 wrote:
> Heterogeneous machines have different type of CPU.
> qemu_get_cpu() returning unfiltered CPUs doesn't make
> sense anymore. Add a 'type' argument to filter CPU by
> QOM type.
>=20
> Type in "hw/core/cpu.h" and implementation in cpu-common.c
> modified manually, then convert all call sites by passing
> a NULL argument using the following coccinelle script:
>=20
> =C2=A0 @@
> =C2=A0 expression index;
> =C2=A0 @@
> =C2=A0 -=C2=A0=C2=A0 qemu_get_cpu(index)
> =C2=A0 +=C2=A0=C2=A0 qemu_get_cpu(index, NULL)
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
> RFC: Is this hot path code? What is the cost of this QOM cast check?

A bunch of them in the Xen emulation code are during interrupt
delivery. So yes, kind of hot path :)

In hw/i386/kvm/xen_evtchn.c I they're almost all just looking up a CPU
with qemu_get_cpu() so that they can call kvm_arch_vcpu_id() to get its
APIC ID. Mostly to send an MSI there or otherwise talk to the kernel
about it.

Perhaps it could keep a simple array of { vCPU ID, APIC ID } instead.

There's one case in valid_vcpu() where it's checking that a given vCPU
does exist, which could use that same array.

In target/i386/kvm/xen-emu.c there are some slow paths which are less
interesting (xen_set_shared_info(), kvm_xen_has_vcpu_callback_vector(),
kvm_xen_set_vcpu_virq(), kvm_xen_hcall_evtchn_upcall_vector()

kvm_xen_hcall_vcpu_op() does have a fast path (the singleshot timer
handling, although most guests seem to use a different hypercall for
that). But it doesn't actually call qemu_get_cpu() for that fast path
anyway, since it'll use the CPU it was *called* on.

kvm_xen_get_vcpu_info_hva() wants a pointer stored in cpu->env, and is
called in *one* fast path in xen_evtchn.c, again interrupt delivery (in
set_port_pending). But only in the case where we're running on an old
kernel and don't just ask the kernel to deliver the event. So I can
live with not optimising that.

kvm_xen_set_callback_asserted() is only for the case where event
channels are being delivered to the guest via emulated GSI, so not the
high-performance case. And I still do want to hook that up properly to
the ack on the *interrupt controllers* anyway (qv=C2=B9).

Finally, kvm_xen_injecft_vcpu_callback_vector() is also only for older
kernels where we don't ask the kernel to deliver the event.=20

tl;dr: we don't care about anything in xen.emu.c. So I think we could
live with just a fast lookup from vCPU# =E2=86=92 APIC ID for the cases in
xen_evtchn.c.



=C2=B9 https://lore.kernel.org/all/70eb35a08a7c48993812b7f088fa9ae3f2c8b925=
.camel@infradead.org/T/




--=-FWRpaywbbUZVahT/LGYI
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMxMDIzMTUxMjUyWjAvBgkqhkiG9w0BCQQxIgQgIv3CZ76u
2/r9mAoYBtfKA6O0vaPiFLcbhh7sJPQJ+Zswgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgBKCfm5iQxlcFVw4K4ywllFvuy+f+wRIjBc
c+9bPah35+tZrLAOsAWSbx8Fs5eqWhfYH+uLDlsguHvrT54cEN6/PShl+ktiL/dVRrpFkS5XF266
U1MUA/pxxunsx7UOAkSyjipqVqnWRWvole2ABcSxOyTtLer1ucTGIFeIXrdQ02JmuM71b0v62Cul
HPquYwp3JJnyf0XDqZOGignvJiI4Uip+Mx11VsOge6xrKKqSWUlIro9QD82LPZtS3OQfeecn/evi
ntVQgVIqPdQklCEQHE22r25K0ak7my6SXhtWu7W4XonWc8H/i5cOVb1hbQy1oABYTOCwHmLEE5N8
72ZRhTxxcVl5Puu30ul2P1SsX/6vxU/oFNm4kzyWPauEbPkjettJtOJS6d36W1bC8K3+Q/I3kCCk
fZ4M5Tw1qo4eFUNVOtMeRIfPu9+y3FqFWU520sKTXnRj8nhTeWc3mXvfYsOFuK4/JRvwOCXM2uhW
VVr8tP62iO6F1pgJ1gWB0QyYuFPG+hgBf+ocuxj9gV2ick4lyGcE0J/2s3XQ9sztfKz+Ir0QdJcV
rJZksLKF4eVIfom395rS6pH6qxMbYsoWPEmQ3tmn1AXbgU3U5ycSeL9UegkOo3q/KE0JANs6S/rB
wXj0hayuC1q2laDYL1vSwEnXwr6LrkjSbwYPICyxMQAAAAAAAA==


--=-FWRpaywbbUZVahT/LGYI--
