Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371AA7B59C8
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 20:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbjJBSJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 14:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjJBSJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 14:09:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B839E;
        Mon,  2 Oct 2023 11:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xRxV8h6rdz6K6cFZgLZZ6o8bxTWhdijjWkOntbWqQCM=; b=h+7JSw+JYEH90+ILDXh+0kyRAB
        9BEvky5UQXJeECAOmx0sHeXjH7gRhjDlAAmypWlUWCWy4DrAKZxXuqYeWiaw2RRQaDIE9Snl/VNK/
        qtqkeeOeqshq14P/6BoWSv5svfNNSETIaKS1Kzq3qKHf12D0EI8RoYLUUcP2PhNidTXRMjXkiCF3f
        LrArseTYRl12WPMBw5h1bGqKy43n7iXn4i75YegcN+YgK9ANUwr/XIMsSFF75pVFs9D8GxbaBWXRJ
        4RUOZ15/5yNx6DrMRgG1j059B8pRmToDDQlXcduywOJvD4fwwg+SP3XyNgJnZ684KA2bKmKhwWiKJ
        V6rk45wA==;
Received: from [2001:8b0:10b:5:5205:71fd:de0:52fd] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qnNM7-00AQuS-Cj; Mon, 02 Oct 2023 18:09:19 +0000
Message-ID: <ac097a26e96ded73e19200066b9063354096a8fd.camel@infradead.org>
Subject: Re: [PATCH v2] KVM: x86: Use fast path for Xen timer delivery
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Date:   Mon, 02 Oct 2023 19:09:18 +0100
In-Reply-To: <ZRsAvYecCOpeHvPY@google.com>
References: <a3989e7ff9cca77f680f9bdfbaee52b707693221.camel@infradead.org>
         <ZRbolEa6RI3IegyF@google.com>
         <ee679de20e3a53772f9d233b9653fdc642781577.camel@infradead.org>
         <ZRsAvYecCOpeHvPY@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-NQeMivtfMykEP/nMeozY"
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


--=-NQeMivtfMykEP/nMeozY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2023-10-02 at 10:41 -0700, Sean Christopherson wrote:
> On Fri, Sep 29, 2023, David Woodhouse wrote:
> > On Fri, 2023-09-29 at 08:16 -0700, Sean Christopherson wrote:
> > > On Fri, Sep 29, 2023, David Woodhouse wrote:
> > > > From: David Woodhouse <dwmw@amazon.co.uk>
> > > >=20
> > > > Most of the time there's no need to kick the vCPU and deliver the t=
imer
> > > > event through kvm_xen_inject_timer_irqs(). Use kvm_xen_set_evtchn_f=
ast()
> > > > directly from the timer callback, and only fall back to the slow pa=
th
> > > > when it's necessary to do so.
> > >=20
> > > It'd be helpful for non-Xen folks to explain "when it's necessary".=
=C2=A0 IIUC, the
> > > only time it's necessary is if the gfn=3D>pfn cache isn't valid/fresh=
.
> >=20
> > That's an implementation detail.
>=20
> And?=C2=A0 The target audience of changelogs are almost always people tha=
t care about
> the implementation.
>
> > Like all of the fast path functions that can be called from
> > kvm_arch_set_irq_inatomic(), it has its own criteria for why it might r=
eturn
> > -EWOULDBLOCK or not. Those are *its* business.
>=20
> And all of the KVM code is the business of the people who contribute to t=
he kernel,
> now and in the future.=C2=A0 Yeah, there's a small chance that a detailed=
 changelog can
> become stale if the patch races with some other in-flight change, but eve=
n *that*
> is a useful data point.=C2=A0 E.g. if Paul's patches somehow broke/degrad=
ed this code,
> then knowing that what the author (you) intended/observed didn't match re=
ality when
> the patch was applied would be extremely useful information for whoever e=
ncountered
> the hypothetical breakage.

Fair enough, but on this occasion it truly doesn't matter. It has
nothing to do with the implementation of *this* patch. This code makes
no assumptions and has no dependency on *when* that fast path might
return -EWOULDBLOCK. Sometimes it does, sometimes it doesn't. This code
just doesn't care one iota.

If this code had *dependencies* on the precise behaviour of
kvm_xen_set_evtchn_fast() that we needed to reason about, then sure,
I'd have written those explicitly into the commit comment *and* tried
to find some way of enforcing them with runtime warnings etc.

But it doesn't. So I am no more inclined to document the precise
behaviour of kvm_xen_set_evtchn_fast() in a patch which just happens to
call it, than I am inclined to document hrtimer_cancel() or any other
function called from the new code :)

> > And in fact one of Paul's current patches is tweaking them subtly, but =
that
> > isn't relevant here. (But yes, you are broadly correct in your
> > understanding.)
> >=20
> > > > This gives a significant improvement in timer latency testing (usin=
g
> > > > nanosleep() for various periods and then measuring the actual time
> > > > elapsed).
> > > >=20
> > > > However, there was a reason=C2=B9 the fast path was dropped when th=
is support
> > >=20
> > > Heh, please use [1] or [*] like everyone else.=C2=A0 I can barely see=
 that tiny little =C2=B9.
> >=20
> > Isn't that the *point*? The reference to the footnote isn't supposed to
> > detract from the flow of the main text. It's exactly how you'll see it
> > when typeset properly.
> =C2=A0
> Footnotes that are "typeset properly" have the entire footnote in a diffe=
rent
> font+size.=C2=A0 A tiny number next to normal sized text just looks weird=
 to me.
>=20
> And I often do a "reverse lookup" when I get to footnotes that are links,=
 e.g. to
> gauge whether or not it's worth my time to follow the link.=C2=A0 Trying =
to find the
> tiny =C2=B9 via a quick visual scan is an exercise in frustration, at lea=
st for the
> monospace font I use for reading mail, e.g. it's much more readable on my=
 end in
> an editor using a different font.
>=20
> Which is a big benefit to sticking to the old and kludgly ASCII: it provi=
des a
> fairly consistent experience regardless of what client/font/etc each read=
er is
> using.=C2=A0 I'm not completely against using unicode characters, e.g. fo=
r names with
> characters not found in the Latin alphabet, but for code and things like =
this,
> IMO simpler is better.
>=20
> > I've always assumed the people using [1] or [*] just haven't yet realis=
ed
> > that it's the 21st century and we are no longer limited to 7-bit ASCII.=
 Or
> > haven't worked out how to type anything but ASCII.
>=20
> Please don't devolve into ad hominem attacks against other reviews and co=
ntributors.
> If you want to argue that using footnote notation unicode is superior in =
some way,
> then by all means, present your arguments.

Hey, you started the logical fallacies with the ad populum when you
said "everyone else" :)

Not that that was true; there are examples of =C2=B9 being used in the
kernel changelog going back decades.

I can just drop the footnote; there's not a huge amount of benefit in
referring back to the old mail thread anyway. The gist of it was
covered in the commit comment.

--=-NQeMivtfMykEP/nMeozY
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMxMDAyMTgwOTE4WjAvBgkqhkiG9w0BCQQxIgQg+5t8hYlC
jOw3JqInKJfKrtvvZZ/VNxoWGNSn8n22OrQwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgBVeruOd4QTpSFj9ynMsh44xo6A8nku2TFw
G1fKLwuOvWaxB6kTFfpapf+GJ7Y/hP5dp8lXddCkyD445QuuDwr2ceIFxMtEoYbB31gZgxmMoHGF
mPXSAoZ/teANcXfN01HTJzX2ovY38noyskW+d+Qweil4q6W+MqNz0JL0QTx09KVmw2a9m0qAUYkK
dwDb3sdbuA2lakM4QtZDcxf5qsMFgLn7clbNkPtgJwF8pYD3pmTZ7EDJQMTo7qVCVHQwnqrRIMMk
DJ9T795M6gpZnOqZ23d/bflcnO5MLQ0JnNFMq+tqHv9S6r38G32uP9udjXXOOnxOwcFqX2BVr6B2
hiLeFCtfMl0Uk4E9E1qflLkeiUQLoAKmJcHFZzRlHR5wORT7oUcsUhcj+297EI613Sjk/5R6Aay2
yFm+SfgZ88EWrfpeFfZpnQMp6Y0wEzT5EzYtlHtm9xU2PUphUW7fs9x8+b3Ws1IdIdfNA9meJ5pz
+o0QiEhfs+is4AdnYhSr6DVi3K0YjDWrE9Ep9SK49TipmeXivUwRKJBR+tiZmeAS3IZQbqPNyPfU
Zv6BAEYjyrzybdbEjF7AE36jiZdNfY1dE/dlXq3VY4lWaQDDeGlQucPDFHgrPeUedb4p4OSGM5g8
jC3OpzQ9TLMjc+EhTZX9FUt5K28O6mNi2RQbZsWBvQAAAAAAAA==


--=-NQeMivtfMykEP/nMeozY--
