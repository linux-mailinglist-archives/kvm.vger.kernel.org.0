Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD907B4C7F
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 09:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbjJBHYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 03:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235696AbjJBHYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 03:24:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBDA8E;
        Mon,  2 Oct 2023 00:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FskOF9xBDjdFnX7tiwOlI89oJRBWO/RowhKoVC1iKxU=; b=kNiojoebp73ZkVL5QcQ8Ge+VYn
        et4HBUIjY/oFldYGVQM0jSflXa9+q+M8zTjeMyLa82jPzwVV4hdt8NA7ENXg4GH6BL/fKLs9n6UtD
        3zLjNCqdQFPovn+VZXcngWL37PUo4OWDVrFlZ8V5fZApmtEjbAAczb2cjMkM8XAEOP+04R2jxPbE3
        9OtWOM1pXVx5QIfSVnZUXcj0YngomJEZNkqalBU52FNuXZM4Li9I31+frnahoBQMu1MwDyZMjIBfv
        prut+NKaP7+q5ccP6EiH36ttU/dnVPTd7+B3OuXaATUEccY/8sr0VDlTfd+CAWTKu4LTuc+w9JJJb
        HI4MWqkw==;
Received: from [2001:8b0:10b:5:5205:71fd:de0:52fd] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qnDHg-007n86-Go; Mon, 02 Oct 2023 07:24:05 +0000
Message-ID: <b9098da1db79e549afeb703839fedbbc09cd8628.camel@infradead.org>
Subject: Re: [PATCH] KVM: x86: Refine calculation of guest wall clock to use
 a single TSC read
From:   David Woodhouse <dwmw2@infradead.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>,
        inux-kernel@vger.kernel.org, kvm@vger.kernel.org, sveith@amazon.de
Date:   Mon, 02 Oct 2023 08:24:03 +0100
In-Reply-To: <00fba193-238e-49dc-fdc4-0b93f20569ec@oracle.com>
References: <ee446c823002dc92c8ea525f21d00a9f5d27de59.camel@infradead.org>
         <00fba193-238e-49dc-fdc4-0b93f20569ec@oracle.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-asTCgbZd1/xLGwa3bPta"
User-Agent: Evolution 3.44.4-0ubuntu2 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-asTCgbZd1/xLGwa3bPta
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2023-10-01 at 22:14 -0700, Dongli Zhang wrote:
> > They look sane enough but there's still skew over time (in both of
> > them) as the KVM values get adjusted in presumably similarly sloppy
> > ways. But we'll get to this. This patch is just the first low hanging
>=20
> About the "skew over time", would you mean the results of
> kvm_get_wall_clock_epoch() keeps changing over time?
>=20
> Although without testing, I suspect it is because of two reasons:
>=20
> 1. Would you mind explaining what does "as the KVM values get adjusted" m=
ean?

I hadn't quite worked it out yet. You'll note that part was below the
'---' of the patch and wasn't quite as coherent. I suspect you already
know, though.

> The kvm_get_walltime_and_clockread() call is based host monotonic clock, =
which
> may be adjusted (unlike raw monotonic).

Well, walltime has other problems too, which is why it's actually the
wrong thing to use for the KVM_CLOCK_REALTIME feature of
get_kvmclock(). When a leap second occurs, certain values of
CLOCK_REALTIME are *ambiguous* =E2=80=94 they occur twice, just like certai=
n
times between 1am and 2am on the morning when the clocks go backwards
in the winter. We should have been using CLOCK_TAI for that one. But
that's a different issue...

> 2. The host monotonic clock and kvmclock may use different mult/shift.
>=20
> The equation is A-B.
>=20
> A is the current host wall clock, while B is for how long the VM has boot=
.
>=20
> A-B will be the wallclock when VM is boot.
>=20
>=20
> A: ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 --> monotonic clock
> B: __pvclock_read_cycles(&hv_clock, host_tsc); --> raw monotonic and kvmc=
lock
>=20
>=20
> The A is from kvm_get_walltime_and_clockread() to get a pair of ns and ts=
c. It
> is based on monotonic clock, e.g., gtod->clock.shift and gtod->clock.mult=
.
>=20
> BTW, the master clock is derived from raw monotonic, which uses
> gtod->raw_clock.shift and gtod->raw_clock.mult.
>=20
> However, the incremental between host_tsc and master clock will be based =
on the
> mult/shift from kvmclock (indeed kvm_get_time_scale()).
>=20
> Ideally, we may expect A and B increase in the same speed. Due to that th=
ey may
> use different mult/shift/equation, A and B may increase in the different =
speed.

Agreed. There'll be a small drift but it seemed larger than I expected.
I attempted to post an RFC a few days ago but it didn't seem to make it
to the list.=C2=A0Quoting from it...

But... it's *drifting*. If I run the xen_shinfo_selftest, which keeps
moving the shared_info around and causing the wallclock information to
be rewritten, I see it start with...

 $ sudo dmesg -w | head -10
[  611.980957] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777068=
875 (1695916533777068623)
[  611.980995] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777068=
874 (1695916533777068743)
[  611.981007] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777068=
873 (1695916533777068787)
[  611.981017] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777068=
873 (1695916533777068784)
[  611.981027] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777068=
874 (1695916533777068786)
[  611.981036] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777068=
873 (1695916533777068786)
[  611.981046] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777068=
873 (1695916533777068786)
[  611.981055] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777068=
873 (1695916533777068786)
[  611.981065] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777068=
873 (1695916533777068786)
[  611.981075] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777068=
873 (1695916533777068782)
 $ dmesg | tail
[  615.679572] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777037=
455 (1695916533777037423)
[  615.679575] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777037=
455 (1695916533777037419)
[  615.679580] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777037=
454 (1695916533777037418)
[  615.679583] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777037=
454 (1695916533777037418)
[  615.679587] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777037=
454 (1695916533777037418)
[  615.679590] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777037=
454 (1695916533777037419)
[  615.679594] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777037=
454 (1695916533777037417)
[  615.679598] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777037=
454 (1695916533777037418)
[  615.679605] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777037=
454 (1695916533777037423)
[  615.679611] KVM 000000004ab4eef1: Calculated wall epoch 1695916533777037=
454 (1695916533777037420)

Now, I suppose it should drift a little bit, because it includes the
cumulative delta between CLOCK_REALTIME which is adjusted by NTP (and
even enjoys leap seconds), and CLOCK_MONOTONIC_RAW which has neither of
those things. But should it move by about 31=C2=B5s in the space of 4
seconds?

 $ ntpfrob  -d
time =3D 1695917599.000628357
verbose =3D "Clock synchronized, no leap second adjustment pending."
time offset (ns) =3D 0
TAI offset =3D 37
frequency offset =3D -515992
error max (us) =3D 20056
error est (us) =3D 1083
clock cmd status =3D 0
pll constant =3D 2
clock precision (us) =3D 1
clock tolerance =3D 32768000
tick (us) =3D 10000

+		printk("KVM %p: Calculated wall epoch %lld (%lld)\n", kvm,
+		       ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec - __pvclock_read_cycles(&hv=
_clock, host_tsc),
+		       ktime_get_real_ns() - get_kvmclock_ns(kvm));



> About the 2nd reason, I have a patch in progress to refresh the master cl=
ock
> periodically, for the clock drift during CPU hotplug.
>=20
> https://lore.kernel.org/all/20230926230649.67852-1-dongli.zhang@oracle.co=
m/

Yeah, that's probably related to what I'm seeing. I'm testing by using
the xen_shinfo_test which keeps relocating the Xen shared_info page,
and *does* keep triggering a master clock update. Although now I look
harder at it, I'm not sure *why* it does so.

But *why* does the kvmclock use a different mult/shift to the
monotonic_raw clock? Surely it should be the same? I thought the
*point* in using CLOCK_MONOTONIC_RAW was that it was basically just a
direct usage of the host TSC without NTP adjustments...?

We're also seeing the clocksource watchdog trigger in Xen guests,
complaining that the Xen vs. tsc clocksources are drifting w.r.t. one
another =E2=80=94 when again they're both supposed to be derived from the
*same* guest TSC without interference. I assume that's the same
problem? And your trick of adjusting what we advertise to the guest
over time won't help there, because that won't stop it actually
drifting w.r.t. the raw TSC that the guest is comparing against.

[ 7200.708099] clocksource: timekeeping watchdog on CPU3: Marking clocksour=
ce 'tsc' as unstable because the skew is too large:
[ 7200.708134] clocksource:                       'xen' wd_nsec: 508905888 =
wd_now: 68dcc1c556c wd_last: 68dadc70bcc mask: ffffffffffffffff
[ 7200.708139] clocksource:                       'tsc' cs_nsec: 511584233 =
cs_now: f12d5ec8ad3 cs_last: f128fca662b mask: ffffffffffffffff
[ 7200.708142] clocksource:                       'xen' (not 'tsc') is curr=
ent clocksource.
[ 7200.708145] tsc: Marking TSC unstable due to clocksource watchdog

--=-asTCgbZd1/xLGwa3bPta
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMxMDAyMDcyNDAzWjAvBgkqhkiG9w0BCQQxIgQgZiXyWTQu
Oij2JTZAUVqsGH73J8uJ+YrKs4WiQtPvUtUwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCBOuufZn54Tdr4CnNmdJVY3yN8K3y3Q0vX
alv95zEApI4e5U0PDS7S+hFHetiyqL56ieFW8nyR6ZpZJNpOOBKE9PIE3KCD/kbZf6CvSRNZEL8w
BKOewMOugZPoCTCty8hi07eYEASt9/R1/wwL5r+udh6+RAfzUdME8PFR6h6k3X5XfELEz/TzNVbR
ruTwFMH/0s2lmFZC+paJMMwBcvifQAaA9KzbEQCNOIjDyORIo7U+KnT58+lP+aZY5qsqzYZkC2HI
lN07J+slToIznfRztFJRyJpdzKQwk619hTPDw26dX21ji//GWLVXaUY58WO7Ewan6u34bNkwAx2b
OINb8QP5IhDJqKJnhdzbbQuUM2acGrssobCCGtKU3e3Pqjk+uCVBVyoz+/Hv/M/KfHp3/apemsNE
lXJ0Sjwl351i2mJ+BdBXoLEwP/f8o5MmVjTSgHszqT/Gy/szdNg+GkIfsG9YICR+j6VQ7W/8Z+90
17hZsEZ/gNO6M8YByMQO7aDjfBIChCaEleCdqD14VPGWj5L/EIrJl6BzR4jd5x4QmJUxe2HhiCYQ
Akzk62EXDwj5gOoXbjO1jinglU2tmDds9teAP1Tq+v0NJcFOcFu28YYdU2TqOlW5hQOgYvxAWdFl
LyA9RKMBxvNNKb1WF2Uz76aHUt1IlArQPQ3MtaFKxgAAAAAAAA==


--=-asTCgbZd1/xLGwa3bPta--
