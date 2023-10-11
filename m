Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F5F7C4CF5
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 10:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjJKIVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 04:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjJKIVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 04:21:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5948A9B
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 01:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OR3S4Ljx7tBCT7qrKqJO4HVEkEuAUFUOJDpi1flQ388=; b=Ke11j3eu+zSEYd8lHEQN+sPFad
        YmLC5q4lLSPRav9OQbES4JbgyrbTSzx+n44YVxRg8TAvlUktl5uA93K1fx5/cLu/f+0Amep6Zvxv+
        X6yK/eDdcKhVLJ/B8Mb13ABxkAxNt/tkpszKseN4qKkqjeH3vO+gf5PZr84YURiz2QUL5nlqrXC89
        47dwbFdw0BEbKiBILKkN/wmLUPTTMgZC/O9kJvC+LE39ypaOtoqYxUVJ1hgNBT3gj3dQBNaYJ5O05
        MNlrrRYItZGsrd9gCITHylmAG+Xx4ZeCDyF+Te+qX/R20ThRkPgA7v9ITDBnzAXt8M46/TPguxKIT
        h4nCpSaQ==;
Received: from [2001:8b0:10b:5:2db5:a8b2:de2d:f60d] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qqUSh-009hW6-FO; Wed, 11 Oct 2023 08:20:59 +0000
Message-ID: <7fba6d8fc3de0bcb86bf629a4f5b0217552fe999.camel@infradead.org>
Subject: Re: [RFC] KVM: x86: Don't wipe TDP MMU when guest sets %cr4
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Bartosz Szczepanek <bsz@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Wed, 11 Oct 2023 09:20:58 +0100
In-Reply-To: <ZSXdYcMUds-DrHAd@google.com>
References: <b46ee4de968733a69117458e9f8f9d2a6682376f.camel@infradead.org>
         <ZSXdYcMUds-DrHAd@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-adplqpOv4rCpWzsTtBLX"
User-Agent: Evolution 3.44.4-0ubuntu2 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-adplqpOv4rCpWzsTtBLX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-10-10 at 16:25 -0700, Sean Christopherson wrote:
> On Tue, Oct 10, 2023, David Woodhouse wrote:
> > If I understand things correctly, the point of the TDP MMU is to use
> > page tables such as EPT for GPA =E2=86=92 HPA translations, but let the
> > virtualization support in the CPU handle all of the *virtual*
> > addressing and page tables, including the non-root mode %cr3/%cr4.
> >=20
> > I have a guest which loves to flip the SMEP bit on and off in %cr4 all
> > the time. The guest is actually Xen, in its 'PV shim' mode which
> > enables it to support a single PV guest, while running in a true
> > hardware virtual machine:
> > https://lists.xenproject.org/archives/html/xen-devel/2018-01/msg00497.h=
tml
> >=20
> > The performance is *awful*, since as far as I can tell, on every flip
> > KVM flushes the entire EPT. I understand why that might be necessary
> > for the mode where KVM is building up a set of shadow page tables to
> > directly map GVA =E2=86=92 HPA and be loaded into %cr3 of a CPU that do=
esn't
> > support native EPT translations. But I don't understand why the TDP MMU
> > would need to do it. Surely we don't have to change anything in the EPT
> > just because the stuff in the non-root-mode %cr3/%cr4 changes?
> >=20
> > So I tried this, and it went faster and nothing appears to have blown
> > up.
> >=20
> > Am I missing something? Is this stupidly wrong?
>=20
> Heh, you're in luck, because regardless of what your darn pronoun "this" =
refers
> to, the answer is yes, "this" is stupidly wrong.

Hehe. Thought that might be the case. Thank you for the coherent
explanation and especially for the references.

(I hadn't got the PV shim working in qemu yet. I shall bump that up my
TODO list by a few quanta, as it would have let me run this test on a
newer kernel.)

> The below is stupidly wrong.=C2=A0 KVM needs to at least reconfigure the =
guest's paging
> metadata that is used to translate GVAs to GPAs during emulation.
>=20
> But the TDP MMU behavior *was* also stupidly wrong.=C2=A0 The reason that=
 two vCPUs
> suck less is because KVM would zap SPTEs (EPT roots) if and only if *both=
* vCPUs
> unloaded their roots at the same time.
>=20
> Commit edbdb43fc96b ("KVM: x86: Preserve TDP MMU roots until they are exp=
licitly
> invalidated") should fix the behavior you're seeing.
>=20
> And if we want to try and make SMEP blazing fast on Intel, we can probabl=
y let
> the guest write it directly, i.e. give SMEP the same treatment as CR0.WP.=
=C2=A0 See
> commits cf9f4c0eb169 ("KVM: x86/mmu: Refresh CR0.WP prior to checking for=
 emulated
> permission faults") and fb509f76acc8 ("KVM: VMX: Make CR0.WP a guest owne=
d bit").

Thanks. In fact, looking at __kvm_mmu_refresh_passthrough_bits() in
commit cf9f4c0eb169 ("KVM: x86/mmu: Refresh CR0.WP=E2=80=A6"), shouldn't it=
 be
looking at the SMEP bit in %cr4 anyway?

In kvm_calc_cpu_role() the value of ____is_cr0_wp() is used *three*
times. For setting role.base.{cr0_wp,smep_andnot_wp,smap_andnot_wp}.

But __kvm_mmu_refresh_passthrough_bits() only refreshes
role.base.cr0_wp and not the other two. Do we need this?

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5159,6 +5159,8 @@ void __kvm_mmu_refresh_passthrough_bits(struct kvm_vc=
pu *vcpu,
                return;
=20
        mmu->cpu_role.base.cr0_wp =3D cr0_wp;
+       mmu->cpu_role.base.smep_andnot_wp =3D mmu->cpu_role.ext.cr4_smep &&=
 !cr0_wp;
+       mmu->cpu_role.base.smap_andnot_wp =3D mmu->cpu_role.ext.cr4_smap &&=
 !cr0_wp;
        reset_guest_paging_metadata(vcpu, mmu);
 }
=20
But I'm confused here. Even if I don't go as far as actually making
CR4.SMEP a guest-owned bit, and KVM still ends up handling it in
kvm_post_load_cr4()... why does KVM need to completely unload and
reinit the MMU? Would it not be sufficient just to refresh the role
bits, much like __kvm_mmu_refresh_passthrough_bits() does for CR0.WP?

(And what about flushing the hardware TLB, as Jim mentioned. I guess if
it's guest-owned we trust the CPU to do that, and if it's trapped then
KVM is required to do so)?

> Oh, and if your userspace is doing something silly like constantly creati=
ng and
> deleting memslots, see commit 0df9dab891ff ("KVM: x86/mmu: Stop zapping i=
nvalidated
> TDP MMU roots asynchronously").

Oooh, I'll play with that. Thanks! Although I bristle at 'silly' :)

Userspace only wants to add and remove single overlay pages. That's not
so silly, that's explicitly requested by the guest and required for PV
drivers to work.

AIUI it's the KVM API which means that userspace needs to stop all
vCPUs, *remove* the original memslot, add back the two halves of the
original memslot with the newly overlaid page in the middle, and then
let all the vCPUs run again. We don't need an atomic way to change
*all* the memslots at once, but a way to atomically overlay a *single*
range would make the whole enterprise feel less 'silly'.





--=-adplqpOv4rCpWzsTtBLX
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMxMDExMDgyMDU4WjAvBgkqhkiG9w0BCQQxIgQgn3yx7zC5
mhHxtTtgqYWDCxLbj/72mRM16lEhwVkWBSIwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCnuhA/QDqExtL2rsMyAIPf+lm5E9eDRMSu
VuKRnkMVxIaVkq2Slx7H7mYvhtZMSbIEzyzXswAxEoFhI46K/nReDtlRyMKMTAQZmy/aD0sd7szB
SyJn04X0zM+0N08bwMF0y8y3WTyDHmhB3q9hJ5NugNd+If+6os01UgEzp+uStG/UMEAfBl0QE8r/
nUrd2S1PZo26mjdEyju+JVW7dfzjBpDkAVFAU4mJ02sU13aCq5MJ/P9h8m+BXGIiXjiUDrENhWF+
VT2k5xy9/rVW1c+glcdkRyHwLxFl16lk5iTVgk4xBJBeaI28Em4vR9356/b7cmL4MLHkQ8pRnhgZ
wmsWEeZjCIjOFEMyv+QLj5wGRyZhUez9R8MnNbVIrmzceBrhhm9b4SXwV71Z6PMG7tWmwQAYcVX6
MrtNSIdLkaOpQaF/uhKYK/5ZKedIjnJs3/si8SUMX9NdAI1WLxWhvGjO3VtYW+bdDvY8wNDhKIi/
UyR2NGQZdSxfeqPMLH6og3oEmhxFQO1t9LsnUv0fPBnaJNUea3fI21tsT09ScS0ZqFewjBNnTY5Z
bKlvmpnm/Boqtn3DlPQ2UxAlol5BjgVCwuQW1aqrfuoZZE7HoEYyJiJUqQw1RIv3KB2ryACkrjWI
NoogUb6DBo/iENKa0HVAm5aUOVC85Siil1E4OdSkfQAAAAAAAA==


--=-adplqpOv4rCpWzsTtBLX--
