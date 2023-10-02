Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7F57B5B5D
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 21:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238861AbjJBTdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 15:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjJBTds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 15:33:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67AFA9;
        Mon,  2 Oct 2023 12:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PR6P3AHgME2xp/86LQk0U8HJnsQwyxZ69ZF5Vg5SzyU=; b=ftuGncLMie+EE9v00gSa/Hhq7Q
        4wuq/5zaQQ6qapTl8ywdKYu7OLIK8kL7XuF+vfuYmuVfY8YnzPF6SZz2bQbY1l/MU0AU81v79A4vw
        QshJRzvGISYY5vnZfaHKxTw8nYPFITeVggn7er0WNjaFRrYKVvLkE7qJzeUcRhHowNfxHmw9HtrCS
        1np5c5SmWM2PYdO36tgDCBzZKK5CuzOju+YyHoiDDYPKQrE41r4x/RM43e7DcfqPLAksffWCZCDtp
        YALnF0CM08Y7l3BY8PQKweaMgPKDyn3oWvH0vLsRbYv7juDnvKzoUZDJNHEInUk3UoOQK/kCCRWc0
        5i3Gl7Cw==;
Received: from [2001:8b0:10b:5:5205:71fd:de0:52fd] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qnOfl-00Anqu-Mx; Mon, 02 Oct 2023 19:33:41 +0000
Message-ID: <b50afadea577065d90ae3dc8ca2aa67dcffcc50e.camel@infradead.org>
Subject: Re: [PATCH v2] KVM: x86: Use fast path for Xen timer delivery
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Date:   Mon, 02 Oct 2023 20:33:41 +0100
In-Reply-To: <ZRsP5cvyqLaihb76@google.com>
References: <a3989e7ff9cca77f680f9bdfbaee52b707693221.camel@infradead.org>
         <ZRbolEa6RI3IegyF@google.com>
         <ee679de20e3a53772f9d233b9653fdc642781577.camel@infradead.org>
         <ZRsAvYecCOpeHvPY@google.com>
         <ac097a26e96ded73e19200066b9063354096a8fd.camel@infradead.org>
         <ZRsP5cvyqLaihb76@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-q4kMllPbnP65tdh2LrUv"
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


--=-q4kMllPbnP65tdh2LrUv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2023-10-02 at 11:45 -0700, Sean Christopherson wrote:
> On Mon, Oct 02, 2023, David Woodhouse wrote:
> > On Mon, 2023-10-02 at 10:41 -0700, Sean Christopherson wrote:
> > > On Fri, Sep 29, 2023, David Woodhouse wrote:
> > > > On Fri, 2023-09-29 at 08:16 -0700, Sean Christopherson wrote:
> > > > > On Fri, Sep 29, 2023, David Woodhouse wrote:
> > > > > > From: David Woodhouse <dwmw@amazon.co.uk>
> > > > > >=20
> > > > > > Most of the time there's no need to kick the vCPU and deliver t=
he timer
> > > > > > event through kvm_xen_inject_timer_irqs(). Use kvm_xen_set_evtc=
hn_fast()
> > > > > > directly from the timer callback, and only fall back to the slo=
w path
> > > > > > when it's necessary to do so.
> > > > >=20
> > > > > It'd be helpful for non-Xen folks to explain "when it's necessary=
".=C2=A0 IIUC, the
> > > > > only time it's necessary is if the gfn=3D>pfn cache isn't valid/f=
resh.
> > > >=20
> > > > That's an implementation detail.
> > >=20
> > > And?=C2=A0 The target audience of changelogs are almost always people=
 that care about
> > > the implementation.
> > >=20
> > > > Like all of the fast path functions that can be called from
> > > > kvm_arch_set_irq_inatomic(), it has its own criteria for why it mig=
ht return
> > > > -EWOULDBLOCK or not. Those are *its* business.
> > >=20
> > > And all of the KVM code is the business of the people who contribute =
to the kernel,
> > > now and in the future.=C2=A0 Yeah, there's a small chance that a deta=
iled changelog can
> > > become stale if the patch races with some other in-flight change, but=
 even *that*
> > > is a useful data point.=C2=A0 E.g. if Paul's patches somehow broke/de=
graded this code,
> > > then knowing that what the author (you) intended/observed didn't matc=
h reality when
> > > the patch was applied would be extremely useful information for whoev=
er encountered
> > > the hypothetical breakage.
> >=20
> > Fair enough, but on this occasion it truly doesn't matter. It has
> > nothing to do with the implementation of *this* patch. This code makes
> > no assumptions and has no dependency on *when* that fast path might
> > return -EWOULDBLOCK. Sometimes it does, sometimes it doesn't. This code
> > just doesn't care one iota.
> >=20
> > If this code had *dependencies* on the precise behaviour of
> > kvm_xen_set_evtchn_fast() that we needed to reason about, then sure,
> > I'd have written those explicitly into the commit comment *and* tried
> > to find some way of enforcing them with runtime warnings etc.
> >=20
> > But it doesn't. So I am no more inclined to document the precise
> > behaviour of kvm_xen_set_evtchn_fast() in a patch which just happens to
> > call it, than I am inclined to document hrtimer_cancel() or any other
> > function called from the new code :)
>=20
> Just because some bit of code doesn't care/differentiate doesn't mean the=
 behavior
> of said code is correct.=C2=A0 I agree that adding a comment to explain t=
he gory details
> is unnecessary and would lead to stale code.=C2=A0 But changelogs essenti=
ally capture a
> single point in a time, and a big role of the changelog is to help review=
ers and
> readers understand (a) the *intent* of the change and (b) whether or not =
that change
> is correct.
>=20
> E.g. there's an assumption that -EWOULDBLOCK is the only non-zero return =
code where
> the correct response is to go down the slow path.
>=20
> I'm not asking to spell out every single condition, I'm just asking for c=
larification
> on what the intended behavior is, e.g.
>=20
> =C2=A0 Use kvm_xen_set_evtchn_fast() directly from the timer callback, an=
d fall
> =C2=A0 back to the slow path if the event is valid but fast delivery isn'=
t
> =C2=A0 possible, which currently can only happen if delivery needs to blo=
ck,
> =C2=A0 e.g. because the gfn=3D>pfn cache is invalid or stale.
>=20
> instead of simply saying "when it's necessary to do so" and leaving it up=
 to the
> reader to figure what _they_ think that means, which might not always ali=
gn with
> what the author actually meant.


Fair enough. There's certainly scope for something along the lines of


+	rc =3D kvm_xen_set_evtchn_fast(&e, vcpu->kvm);
+	if (rc !=3D -EWOULDBLOCK) {

   /*
    * If kvm_xen_set_evtchn_fast() returned -EWOULDBLOCK, then set the
    * timer_pending flag and kick the vCPU, to defer delivery of the=C2=A0
    * event channel to a context which can sleep. If it fails for any
    * other reasons, just let it fail silently. The slow path fails=C2=A0
    * silently too; a warning in that case may be guest triggerable,
    * should never happen anyway, and guests are generally going to
    * *notice* timers going missing.
    */

+		vcpu->arch.xen.timer_expires =3D 0;
+		return HRTIMER_NORESTART;
+	}

That's documenting *this* code, not the function it happens to call.
It's more verbose than I would normally have bothered to be, but I'm
all for improving the level of commenting in our code as long as it's
adding value.=20


--=-q4kMllPbnP65tdh2LrUv
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMxMDAyMTkzMzQxWjAvBgkqhkiG9w0BCQQxIgQg/Rer/Jg8
1aUMnJrBciRMjmZOb6nFkeIlwD06nXn9nXQwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCh3xT4S1O78g3P60YkgPcwTWOxwow/yQGz
kVcM9A5LsZ44F2juclAXynLf9soOD6ksOQHf4Ea0ErC67bH+3Il0mvnahx46+v5Y0ewy+T1uuHqP
NnpaUzsj6PWNMehMkFotC5bMZyfO+1SwREt3PvGlfofCOz1lfdleDnBxsgoaH1LloasacTepgTUz
49iH55d8V3ZcLbAT+Z+CFUdfQtbW6v/UYSWMyzpYT9efrC8cDH8YXixCvlx5y89c3l9Yq12xC+7o
FEZumlMrhZeDZ+7VcY5lhCZw4XRa/hTygnmsk78gIA+zu7zfu6C2xOjX7QSt5kKbCorgm4wxfn71
mc9NeVC31garS39j7rzexagcfDSqGrQeGZ22brM5GdMUC4gp74puAOC1iS9YOck6txYTr2ISYKO7
LRNmSMKNdt/9KtngtUU+W8KAzLIKRdvPCCLyUVaZWAwwGTV/OeU90ClYISB/1fYQRZqc3Tr0G4IK
7t2d2EE9UCKlHMyh0RJtdinI05EK3j/ZnbibwBB08nBqeqfaNEvN8YOTk+F01yf7FoYLd1GPmMEw
qhsKjHH3lvirIU1ZHyLFouHHnazsRXc0a7tDu10KW2wSp2lmMOcRGyuTUFTE65hh1C6JHoKIYZlb
qOKs8D6dqa0TQIj1WzSzxOWUtu7bHkjI7V+G0HOH1AAAAAAAAA==


--=-q4kMllPbnP65tdh2LrUv--
