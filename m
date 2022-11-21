Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C65632D96
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 21:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbiKUUCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 15:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiKUUCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 15:02:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39633C7234;
        Mon, 21 Nov 2022 12:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3qMzMu9XTncXeyJyeHhCRO73QuvS378rzeQo1zio0/U=; b=kdtD6BSPy86QbCRffFU8FRbeZX
        fNC7r9SfEmda+MoDMa1I9Ir2licNk/4/J2QfN4wyhhfv1zvfdlscHxyHsCOYkpuWVF20lje3re/K7
        ch+uKLqKjDri16NifgQH0iA5+pvlmQQOPo3gnXbTLjqzOX2KF7jNl6tKfdJjySh1NOvRRSVXw596+
        aIRVXy7cKKQ30cOlK71duTZh9Spc1eoix0jKZNRQoVmK05R2Z79x/2GoHs40l/onDEhkuU3WQDfmX
        uN9u3w3nyRimJIih/WawTLzS1CneVU3pCCQoJKkJFPeULQPWODJC+t9jKNZZgLLIMyN5+LmJO47Ee
        JWdjDBFA==;
Received: from [2001:8b0:10b:5:48b0:3913:46a3:a988] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxCza-005YVS-HU; Mon, 21 Nov 2022 20:02:10 +0000
Message-ID: <ac74694957b5f3af46e0668ca58388eb90ecda9e.camel@infradead.org>
Subject: Re: [PATCH v2 07/16] KVM: Store gfn_to_pfn_cache length as an
 immutable property
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
Date:   Mon, 21 Nov 2022 20:02:02 +0000
In-Reply-To: <Y3vNZ0Y3KUVsrFcM@google.com>
References: <20221013211234.1318131-1-seanjc@google.com>
         <20221013211234.1318131-8-seanjc@google.com>
         <f80338c90d90fcd2ae3c592c55a591b1d46e6678.camel@infradead.org>
         <Y3vNZ0Y3KUVsrFcM@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-we4ltSZe/L0m6QhzyPba"
User-Agent: Evolution 3.36.5-0ubuntu1 
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


--=-we4ltSZe/L0m6QhzyPba
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-11-21 at 19:11 +0000, Sean Christopherson wrote:
> On Mon, Nov 21, 2022, David Woodhouse wrote:
> > On Thu, 2022-10-13 at 21:12 +0000, Sean Christopherson wrote:
> > > From: Michal Luczaj <mhal@rbox.co>
> > >=20
> > > Make the length of a gfn=3D>pfn cache an immutable property of the ca=
che
> > > to cleanup the APIs and avoid potential bugs, e.g calling check() wit=
h a
> > > larger size than refresh() could put KVM into an infinite loop.
> >=20
> > Hm, that's a strange hypothetical bug to be worried about, given the
> > pattern is usually to have the check() and refresh() within a few lines
> > of each other with just atomicity/locking stuff in between them.
>=20
> Why do you say it's strange to be worried about?  The GPC and Xen code is=
 all quite
> complex and has had multiple bugs, several of which are not exactly edge =
cases.
> I don't think it's at all strange to want to make it difficult to introdu=
ce a bug
> that would in many ways be worse than panicking the kernel.

The check() and refresh() calls are within a few lines of each other,
and it'd be really strange for them to have a *different* idea about
what the length is, surely?

> But as Paolo said, the APIs themselves are to blame[*], check() and refre=
sh()
> shouldn't be split for the common case, i.e. this particular concern shou=
ld largely
> be a non-issue in the long run.
>=20
> [*] https://lore.kernel.org/all/c61f6089-57b7-e00f-d5ed-68e62237eab0@redh=
at.com

Yeah. As I said to Paul, I've been tempted by that. I've so far not
done it because although they look broadly similar, a bunch of the
sites do end up with *different* code between the check() and the
refresh(), for various locking and atomicity reasons.

> > I won't fight for it, but I quite liked the idea that each user of a
> > GPC would know how much space *it* is going to access, and provide that
> > length as a required parameter. I do note you've added a WARN_ON to one
> > such user, and that's great =E2=80=94 but overall, this patch makes tha=
t
> > checking *optional* instead of mandatory.
>=20
> I honestly don't see a meaningful difference in this case.  The only prac=
tical
> difference is that shoving @len into the cache makes the check a one-time=
 thing.
> The "mandatory" check at use time still relies on a human to not make a m=
istake.
> If the check were derived from the actual access, a la get_user(), then I=
 would
> feel differently.
>
> Case in point, the mandatory check didn't prevent KVM from screwing up bo=
unds
> checking in kvm_xen_schedop_poll().  The PAGE_SIZE passed in for @len is =
in no
> way tied to actual access that's being performed, the code is simply regu=
rgitating
> the size of the cache.

True, but that's a different class of bug, and the human needs to make
a more *egregious* mistake.

If the function itself writes outside the size that *it* thinks *it's*
going to write, right there and then in that function, that's utterly
hosed (and the SCHEDOP_poll thing was indeed so hosed).

The mandatory check *did* save us from configuring a 32-bit runstate
area at the end of a page, then *writing* to it in 64-bit mode (where
it's larger) and running off the end of the page.

It saved us from "knowing", a few seconds ago under different
circumstances, what the size of the runstate area was... and then it
actually being different when it's written.

But that's not the common case, so again, I won't fight for it.

I've reworked the unapplied parts of this series on top of the poll and
runstate fixes in my tree, *except* for this one making the length
immutable, and I'm running some tests.

https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/gpc-fix=
es

I'm happy to reinstate the immutable length thing in some form on top.

Given that the runstate code already calculates for itself how many
bytes it can fit onto the first page, it really doesn't care about the
length field in the GPC. As a nasty hack, the runstate code could
probably even get away with setting 'len' to zero. That's kind of
awful, but maybe we could introduce a __kvm_gpc_activate() which does
take a new length, leaving kvm_gpc_activate() without it?

> > > All current (and anticipated future) users access the cache with a
> > > predetermined size, which isn't a coincidence as using a dedicated ca=
che
> > > really only make sense when the access pattern is "fixed".
> >=20
> > In fixing up the runstate area, I've made that not true. Not only does
> > the runstate area change size at runtime if the guest changes between
> > 32-bit and 64-bit mode, but it also now uses *two* GPCs to cope with a
> > region that crosses a page boundary, and the size of the first
> > therefore changes according to how much fits on the tail of the page.
> >=20
> > > Add a WARN in kvm_setup_guest_pvclock() to assert that the offset+siz=
e
> > > matches the length of the cache, both to make it more obvious that th=
e
> > > length really is immutable in that case, and to detect future bugs.
> >=20
> > ...
> > > @@ -3031,13 +3030,13 @@ static void kvm_setup_guest_pvclock(struct kv=
m_vcpu *v,
> > >  	struct pvclock_vcpu_time_info *guest_hv_clock;
> > >  	unsigned long flags;
> > > =20
> > > +	WARN_ON_ONCE(gpc->len !=3D offset + sizeof(*guest_hv_clock));
> > > +
> >=20
> > That ought to be 'gpc->len < offset + sizeof(*guest_hv_clock)' I think?
> >=20
> > In the case where we are writing a clock *within* a mapped Xen
> > vcpu_info structure, it doesn't have to be at the *end* of that
> > structure. I think the xen_shinfo_test should have caught that?
>=20
> The WARN doesn't get false positive because "struct pvclock_vcpu_time_inf=
o" is
> placed at the end of "struct vcpu_info" and "struct compat_vcpu_info".
> =20
> I don't have a strong opinion on whether it's "!=3D" of "<", my goal in a=
dding the
> WARN was primarily to show that @len really is immutable in this case.  G=
uarding
> against future overrun bugs was a bonus.

Ah right, I think I was looking at the pvclock_wall_clock field in the
shared_info, not the time field in the vcpu_info.=20


--=-we4ltSZe/L0m6QhzyPba
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIxMTIxMjAwMjAzWjAvBgkqhkiG9w0BCQQxIgQgK9lxoDZB
pyyKHzLdr5MZpJjh69h0C0KoYhjd2y2sSEEwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgA7QMS8ZPGMb/w+kjoVXxUQITAf1Lufiwlo
ANNP1lBEw5+hKLapM3XSqjqEUKn0K+QHrpLbgsEgUMP4X/4GQepl8HEORsEpJYYsOxUS3qkxJxUb
5YqNaPEGMvNIynafbGLIkgllmS6+LzS2o0RsGHAKX4ltrwe6GinTSKpn1vxIpuIalYAzfag3NQ1W
XRk2SVx3ye7ptQ3Xr5SxiVNzoEg7vRqox9ai7jL7eQeFuJRu2xEEUTWMBGM1EP5n5LMw+BYKRy5B
tkGf9CjGpSL8E1I7IqWZxKK72vtM5DAGvUNxEtpdJW+DHZVc2ZlPQ8xWV306h6YCG0toWy/RAst6
9/H9t9kNHGxrfqBEarVOYYX3V6HmgX8wpA860oovoavEJ+K72Q8WvLr1x5EnxEYEnoZntvZy7o08
P3dF8CWwTnpymb6ZKyCx5HWSCM89uAuFjimgELmJWo+iT9uTjG1BtMh/020dGm8TcVSom38VdvX5
4T9BbJNeyXzE/4tRsyyMXmq93M8m1MGz8RAlPXKMLvkPvSSW1wyyX3AJ4RVYFLZmI5MbGqTT+JaW
os+q/65ayj51JjbAJsdDZJ1smzPR5aJDElSBKZsXotmZ5fu5DgtTUjLVn3+lRrqBcVXYeliQibe0
7srLSGuIF4ALA5E8UL/DQreC/mLCvtXIiYP0GpBAvgAAAAAAAA==


--=-we4ltSZe/L0m6QhzyPba--

