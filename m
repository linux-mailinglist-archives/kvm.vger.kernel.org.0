Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9FD634B5B
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 00:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbiKVXtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 18:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234795AbiKVXs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 18:48:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9015A99EB0;
        Tue, 22 Nov 2022 15:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lmGohJj66nPFQTv8KI2oW03ej4qUZZTvnzWNbm/ev5g=; b=mwUqYMSIDySUujK1IGxQs/gg8h
        tm29PtYkQDiyQqZHWx+AVELRvYWcc63gKOL+PxVM6ou7aj/im1tA9REU2Y95F9+AJ3WUNo3hkmhes
        VY+8SR9gCyriQI9FenJuM0gwkgKh4B79a4+26b7f24LTOLnPG08wdJthARoOmTUkn5mk8Oohe9nxR
        rAcXTxrvAUapVqeW+iEyfXY2s3goyKImFoHOGMC66qW8TQZ/0Wsi5jgFPgXbpHUKQ1QuR+UkC1pmW
        bCyXYCBPgjguyadE2zHR2YRArqDPebqBeRJIHwJy5APoSuJklte6oQ6zyZ2TXb+wfmtNK4LA+UJ9c
        7AAvvAAg==;
Received: from [2001:8b0:10b:5:e11d:803:4f3f:5f70] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxd0d-006t07-0u; Tue, 22 Nov 2022 23:48:59 +0000
Message-ID: <9d0e54e248c740eb52bcaa63764afb99a4dfcde9.camel@infradead.org>
Subject: Re: [PATCH] KVM: x86/xen: Make number of event channels defines
 less magical
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Durrant <paul@xen.org>
Date:   Tue, 22 Nov 2022 23:48:51 +0000
In-Reply-To: <Y30xm/y2CKPchObi@google.com>
References: <20221114181632.3279119-1-seanjc@google.com>
         <629d6d90ce95b9db74f0101a4428be1119c4bfc7.camel@infradead.org>
         <Y3KZVUCCH+YQDbqu@google.com>
         <fde14caa0cf774b2b46f1124644a3b326a0a8f09.camel@infradead.org>
         <Y30xm/y2CKPchObi@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-ridgL50A4ZoqtPatZZE5"
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


--=-ridgL50A4ZoqtPatZZE5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-11-22 at 20:31 +0000, Sean Christopherson wrote:
> EVTCHN_2L_NR_CHANNELSOn Mon, Nov 14, 2022, David Woodhouse wrote:
> > On Mon, 2022-11-14 at 19:39 +0000, Sean Christopherson wrote:
> > > Ugh.  I worried that might be the case.  An alternative approach to h=
elp document
> > > things from a KVM perspective would be something like:
> > >=20
> > > diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> > > index 93c628d3e3a9..7769f3b98af0 100644
> > > --- a/arch/x86/kvm/xen.c
> > > +++ b/arch/x86/kvm/xen.c
> > > @@ -1300,6 +1300,9 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
> > > =20
> > >  static inline int max_evtchn_port(struct kvm *kvm)
> > >  {
> > > +       BUILD_BUG_ON(EVTCHN_2L_NR_CHANNELS !=3D
> > > +                    (sizeof_field(struct shared_info, evtchn_pending=
) * BITS_PER_BYTE));
> > > +
> > >         if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
> > >                 return EVTCHN_2L_NR_CHANNELS;
> > >         else
> >=20
> > Not really sure I see the point of that.
> >=20
> > There are two main reasons for that kind of BUILD_BUG_ON(). I've added
> > a few of them asserting that the size of the structure and its compat
> > variant are identical, and thus documenting *why* the code lacks compat
> > handling. For example...
> >=20
> > 	/*
> > 	 * Next, write the new runstate. This is in the *same* place
> > 	 * for 32-bit and 64-bit guests, asserted here for paranoia.
> > 	 */
> > 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=3D
> > 		     offsetof(struct compat_vcpu_runstate_info, state));
> >=20
> > The second reason is to prevent accidental screwups where our local
> > definition of a structure varies from the official ABI. Like these:
> >=20
> > 	/* Paranoia checks on the 32-bit struct layout */
> > 	BUILD_BUG_ON(offsetof(struct compat_shared_info, wc) !=3D 0x900);
> > 	BUILD_BUG_ON(offsetof(struct compat_shared_info, arch.wc_sec_hi) !=3D =
0x924);
> > 	BUILD_BUG_ON(offsetof(struct pvclock_vcpu_time_info, version) !=3D 0);
> >=20
> > I don't really see the above fulfilling either of those use cases.
> >=20
> > Given that the definition of the evtchn_pending field is:
> >=20
> >         xen_ulong_t evtchn_pending[sizeof(xen_ulong_t) * 8];
> >=20
> > It's fairly tautological that the number of event channels supported is
> > BITS_PER_ULONG * BITS_PER_ULONG. Which is sizeof(xen_ulong_t)=C2=B2 * 6=
4 as
> > defined in the official Xen headers.
> >=20
> > I don't know that we really need to add our own sanity check on the
> > headers we imported from Xen. It doesn't seem to add much.
>=20
> The goal isn't to add a sanity check, it's to document what EVTCHN_2L_NR_=
CHANNELS
> actually represents.  My frustration with=20
>=20
>   sizeof(xen_ulong_t) * sizeof(xen_ulong_t) * 64
>=20
> is that there's nothing there that connects it back to evtchn_pending or =
evtchn_mask.

Heh, welcome to Xen code :)

We could submit patches to Xen which make that clearer.=20

> E.g. ideally the code would be something like
>=20
>   #define COMPAT_EVTCHN_2L_NR_CHANNELS	256
>=20
>   #ifdef CONFIG_X86_64
>   #define EVTCHN_2L_NR_CHANNELS		512
>   #else
>   #define EVTCHN_2L_NR_CHANNELS		COMPAT_EVTCHN_2L_NR_CHANNELS
>=20
>=20
>   DECLARE_BITMAP(evtchn_pending, EVTCHN_2L_NR_CHANNELS);
>   DECLARE_BITMAP(evtchn_mask, EVTCHN_2L_NR_CHANNELS);
>=20
> which is much more self-documenting and doesn't require the reader to do =
math to
> grok the basics.

For the *compat* case that's entirely within arch/x86/kvm/xen.h so we
really *can* flip it to '#define COMPAT_EVTCHN_2L_NR_CHANNELS 1024' and
then use DECLARE_BITMAP in the struct itself. And I believe that I have
enough BUILD_BUG_ON() sanity checks that if you try that with 256
channels it would kick you in the teeth for it.

The fact that the official definition is an array of uint32_t is
irrelevant in our code, as we always cast to (unsigned long *) when
accessing the bitmaps anyway. DECLARE_BITMAP() is fine.

> Anyways, we can drop this patch, it was written mostly out of frustration=
 with
> how long it took me to understand what is actually a very simple concept =
that's
> written in an unnecessarily obscure way.

Your experience is valid. This should be as understandable as possible
for people who aren't intimately familiar with the Xen ABIs, and I
certainly can't have an opinion on that.

How's something like this? I did start typing that comment in the
max_evtchn_port() function in xen.c but moved it over.

Still not utterly convinced, as it's still somewhat circular =E2=80=94 we n=
ow
define NR_CHANNELS as (32*32) with a big comment explaining *why* that
is, and the reason is basically "because that's the number of bits in
an array of uint32_t[32]".

Which might perhaps have been expressed in C instead of prose, as

#define COMPAT_EVTCHN_2L_NR_CHANNELS (BITS_PER_BYTE * \
           sizeof_field(struct compat_shared_info,evtchn_pending))


Signed-off-by-if-you-want-it: David Woodhouse <dwmw@amazon.co.uk>

diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 8503d2c6891e..96735c8ad03f 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -190,17 +190,24 @@ struct compat_arch_shared_info {
 	uint32_t wc_sec_hi;
 };
=20
+/*
+ * EVTCHN_2L_NR_CHANNELS is the number of event channels supported,
+ * corresponding to bits in the shinfo->evtchn_pending (and _mask)
+ * bitmaps. Those bitmaps are an array of
+ *     unsigned long evtchn_pending[BITS_PER_LONG];
+ * giving 1024 (32*32) or 4096 (64*64) event channels for 32-bit and
+ * 64-bit guests respectively.
+ */
+#define COMPAT_EVTCHN_2L_NR_CHANNELS (32 * 32)
+
 struct compat_shared_info {
 	struct compat_vcpu_info vcpu_info[MAX_VIRT_CPUS];
-	uint32_t evtchn_pending[32];
-	uint32_t evtchn_mask[32];
+	DECLARE_BITMAP(evtchn_pending, COMPAT_EVTCHN_2L_NR_CHANNELS);
+	DECLARE_BITMAP(evtchn_mask, COMPAT_EVTCHN_2L_NR_CHANNELS);
 	struct pvclock_wall_clock wc;
 	struct compat_arch_shared_info arch;
 };
=20
-#define COMPAT_EVTCHN_2L_NR_CHANNELS (8 *				\
-				      sizeof_field(struct compat_shared_info, \
-						   evtchn_pending))
 struct compat_vcpu_runstate_info {
     int state;
     uint64_t state_entry_time;


--=-ridgL50A4ZoqtPatZZE5
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIxMTIyMjM0ODUxWjAvBgkqhkiG9w0BCQQxIgQgG2a1CKj5
cN43vQ/9uNV/dxJWBAH7/lR2sN/zXmPXB3owgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCfQwNUdvpXJUH478zrztP0wIKnL9jIDraA
Bmxd/f4hH0/b6ni943AaTn0Qx4533pYYJd32XK7nlE6u02ytakZNo/wJ3SJMuNmbM9jjKaEwYca5
cP+cbS4mi1strqLWSJKhz+JMo/J7037fbS45MfxJfA4wYT5Xpk7KkcyJi8JROtnQhVS+UGOQ/KOo
KSWMryVXZvN4cBT7k8KBbWYUAQaAMha/MP7u8woM18AosWxQVA4IUcSB231kaEdb8p5ICNaZWy/Q
cmfSRHin2mUjTz1O/khokFgGSu5dz5lsfseLVtMMWh/2BUmbznz1qau3qFL9ZggrTCqQyhsrIvDK
Rp0IaBjKzAmxR45sHvwlSGodhPCrqJcwURfram/bN9BcjRyUG3GgAyBXcuND6nZzqLd3Q9TY6Cb8
ZQQh29DLN5Bff7uCRf24GG53oLa80upKW4eiKiZgSz74giRDOO6+zeBSl6MuU8+5JFd77ZgROzlg
pjoakWNRdDiJhcqFeok6m4Kahxg0vnqvalHHY+RHfOZi+IwBoDOFayF3dyur/MVcnwfxmzfM4ZuO
pZc+Uvx+h3EMCi6S9OQFAW/GdEkhTBKbZv4pWRoKCsKpoto3EZ2vdf4byP0Cpc/Mwa/3xJi9qv16
b6rg62E7bIOMMhMbpJHvGpCHcwj62YxYfaDpT8nUVgAAAAAAAA==


--=-ridgL50A4ZoqtPatZZE5--

