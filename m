Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D1643FBE4
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 13:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhJ2L7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 07:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhJ2L7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 07:59:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18DBC061570
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 04:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lhgdYAA/F7t3UUWIB+JlExzUOeE0B/iAhq0qC/YpBy0=; b=VTGxg+yHNY4yjyipmtub1CJ0zh
        /xFmPuxAMbiU1C7SdIhvgM/CAPFe6QWQQIqgXGXxCTjB7NprROG2cOS2EREIMPEsNYjbvA2bC4Au9
        K53/fZYxu3u6HYrr1mlYJlYT3JR3kdXnG4AvIX0QFLgFMsOQUBGin5XiiNoSiFH+UBZOHHoPSLC99
        UzvABCSfAJytg3XGosS1CM0+T6MC0bvoxUDTO1COJL8mtw3AXrsJF5OLhVXbz3dUQV70Ya7WdmSxb
        uYTBqbzisy7PF27VYPr+bqzDy4A41r2B5wTY5dZLopfd3ZNYa76LS1lHO75GRPMl/asNRj4ED4cjm
        yjxftd0Q==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mgQUZ-00Apwk-2U; Fri, 29 Oct 2021 11:56:15 +0000
Message-ID: <33b564a9d394a1b189f36f2415465cb445ca2d2a.camel@infradead.org>
Subject: Re: [EXTERNAL] [PATCH] KVM: x86/xen: Fix runstate updates to be
 atomic when preempting vCPU
From:   David Woodhouse <dwmw2@infradead.org>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raslan, KarimAllah" <karahmed@amazon.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
Date:   Fri, 29 Oct 2021 12:56:11 +0100
In-Reply-To: <99c7d806-4642-c329-79d4-0ff9f04d56ce@oracle.com>
References: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
         <09f4468b-0916-cf2c-1cef-46970a238ce4@redhat.com>
         <a0906628f31e359deb9e9a6cdf15eb72920c5960.camel@infradead.org>
         <2e7bcafe1077d31d8af6cc0cd120a613cc070cfb.camel@infradead.org>
         <1d5f4755ea6be5c7eb8f59dea2daef30fc16b173.camel@infradead.org>
         <99c7d806-4642-c329-79d4-0ff9f04d56ce@oracle.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-pcvVOEGT5WZWel5fVDIs"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-pcvVOEGT5WZWel5fVDIs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-10-29 at 12:31 +0100, Joao Martins wrote:
> On 10/28/21 23:22, David Woodhouse wrote:
> > On Mon, 2021-10-25 at 13:19 +0100, David Woodhouse wrote:
> > > On Mon, 2021-10-25 at 11:39 +0100, David Woodhouse wrote:
> > > > > One possible solution (which I even have unfinished patches for) =
is to
> > > > > put all the gfn_to_pfn_caches on a list, and refresh them when th=
e MMU
> > > > > notifier receives an invalidation.
> > > >=20
> > > > For this use case I'm not even sure why I'd *want* to cache the PFN=
 and
> > > > explicitly kmap/memremap it, when surely by *definition* there's a
> > > > perfectly serviceable HVA which already points to it?
> > >=20
> > > That's indeed true for *this* use case but my *next* use case is
> > > actually implementing the event channel delivery.
> > >=20
> > > What we have in-kernel already is everything we absolutely *need* in
> > > order to host Xen guests, but I really do want to fix the fact that
> > > even IPIs and timers are bouncing up through userspace.
> >=20
> > Here's a completely untested attempt, in which all the complexity is
> > based around the fact that I can't just pin the pages as Jo=C3=A3o and
> > Ankur's original did.
> >=20
> > It adds a new KVM_IRQ_ROUTING_XEN_EVTCHN with an ABI that allows for us
> > to add FIFO event channels, but for now only supports 2 level.
> >=20
> > In kvm_xen_set_evtchn() I currently use kvm_map_gfn() *without* a cache
> > at all, but I'll work something out for that. I think I can use a
> > gfn_to_hva_cache (like the one removed in commit 319afe685) and in the
> > rare case that it's invalid, I can take kvm->lock to revalidate it.
> >=20
> > It sets the bit in the global shared info but doesn't touch the target
> > vCPU's vcpu_info; instead it sets a bit in an *in-kernel* shadow of the
> > target's evtchn_pending_sel word, and kicks the vCPU.
> >=20
> > That shadow is actually synced to the guest's vcpu_info struct in
> > kvm_xen_has_interrupt(). There's a little bit of fun asm there to set
> > the bits in the userspace struct and then clear the same set of bits in
> > the kernel shadow *if* the first op didn't fault. Or such is the
> > intent; I didn't hook up a test yet.
> >=20
> > As things stand, I should be able to use this for delivery of PIRQs
> > from my VMM, where things like passed-through PCI MSI gets turned into
> > Xen event channels. As well as KVM unit tests, of course.
> >=20
> Cool stuff!! I remember we only made IPIs and timers work but not PIRQs
> event channels.

PIRQs turn out to be fairly trivial in the end, once you get your head
around the fact that Xen guests don't actually *unmask* MSI-X when
they're routed to PIRQ; they rely on Xen to do that for them!

If you already have a virtual IOMMU doing interrupt remapping, hooking
it up to remap from the magic Xen MSI 'this is really a PIRQ' message
is fairly simple. Right now I fail that translation and inject the
evtchn manually from userspace, but this will allow me to translate
to KVM_IRQ_ROUTING_XEN_EVTCHN and hook the vfio eventfd directly up to
it.

> > The plan is then to hook up IPIs and timers =E2=80=94 again based on th=
e Oracle
> > code from before, but using eventfds for the actual evtchn delivery.=
=20
> >=20
> I recall the eventfd_signal() was there should the VMM choose supply an
> eventfd. But working without one was mainly for IPI/timers due to
> performance reasons (avoiding the call to eventfd_signal()). We saw some
> slight overhead there -- but I can't find the data right now :(
>=20

Hm, there shouldn't have been *much* additional overhead, since you did
hook up the evtchn delivery from kvm_arch_set_irq_inatomic() so you
weren't incurring the workqueue latency every time. I'll play.

Given that we can't pin pages, I spent a while lying awake at night
pondering *how* we defer the evtchn delivery, if we take a page fault
when we can't just sleep. I was pondering a shadow of the whole
evtchn_pending bitmap, perhaps one per vCPU because the deferred
delivery would need to know *which* vCPU to deliver it to. And more
complexity about whether it was masked or not, too (what if we set the
pending bit but then take a fault when reading whether it was masked?)

Then I remembered that irqfd_wakeup() will *try* the inatomic version
and then fall back to a workqueue, and the whole horridness just went
away :)

Perhaps as an optimisation I can do the same kind of thing =E2=80=94 when I=
PI
or timer wants to raise an evtchn, it can *try* to do so atomically but
fall back to the eventfd if it needs to wait.

I think I've just conceded that I have to map/unmap the page at a
kernel virtual address from the MMU notifier when it becomes
present/absent, so I might get *some* of the benefits of pinning from
that (at least if I protect it with a spinlock it can't go away
*between* two consecutive accesses).

> Perhaps I am not reading it right (or I forgot) but don't you need to use=
 the shared info
> vcpu info when the guest hasn't explicitly registered for a *separate* vc=
pu info, no?

We can't, because we don't know the *Xen* CPU numbering scheme. It may
differ from both kvm_vcpu->vcpu_id and kvm_vcpu->idx. I lost a week or
so of my life to that, delivering interrupts to the wrong vCPUs :)

> Or maybe this relies on the API contract (?) that VMM needs to register t=
he vcpu info in
> addition to shared info regardless of Xen guest explicitly asking for a s=
eparate vcpu
> info. If so, might be worth a comment...

Indeed, I washed my hands of that complexity in the kernel and left it
entirely up to the VMM. From Documentation/virt/kvm/api.rst:

KVM_XEN_ATTR_TYPE_SHARED_INFO
  Sets the guest physical frame number at which the Xen "shared info"
  page resides. Note that although Xen places vcpu_info for the first
  32 vCPUs in the shared_info page, KVM does not automatically do so
  and instead requires that KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO be used
  explicitly even when the vcpu_info for a given vCPU resides at the
  "default" location in the shared_info page. This is because KVM is
  not aware of the Xen CPU id which is used as the index into the
  vcpu_info[] array, so cannot know the correct default location.


> > +static inline int max_evtchn_port(struct kvm *kvm)
> > +{
> > +	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
> > +		return 4096;
> > +	else
> > +		return 1024;
> > +}
> > +
>=20
> Maybe worth using Xen ABI interface macros that help tieing this in
> to Xen guest ABI. Particular the macros in include/xen/interface/event_ch=
annel.h
>=20
> #define EVTCHN_2L_NR_CHANNELS (sizeof(xen_ulong_t) * sizeof(xen_ulong_t) =
* 64)
>=20
> Sadly doesn't cover 32-bit case :( given the xen_ulong_t.

Yeah, that's a bit of a placeholder and wants cleanup but only after
I've made it *work*. :)

For KVM I have definitions of the compat stuff in arch/x86/kvm/xen.h so
could add it there.


--=-pcvVOEGT5WZWel5fVDIs
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEx
MDI5MTE1NjExWjAvBgkqhkiG9w0BCQQxIgQgGqAthx6vUdRbb2Q3ikSAgClyx9sptnvD/JJQt/50
8dswgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAFZKUVLtfGZMvsylalOQwn9/UJ6DR4BwxZc4cMW/f6FeZMZe6XVa3aja1+EouW0c
xgM4ZDdmJy4KOnqpfZKgGOPYozYgVBOXOLAJPiq3+kiY6p5wFGRwhvoheqZ1FYfuDM8g9Yvov/6e
VIBv4xn2s/g6YfLxzZSVjEgJLOr8AOdZZ3hbrH6up8a2FyE4luXKqSREIXJX13GmxlfrU7gcGo+v
U/Y9qLIQOBpYxvhmgl8KCj2yHzzoaPUe8cek5kUK8Lc5o4DFoN+LZWY8CEue2OuPZBQ4XID29xYy
wPuUGk39/f8hafUCZNsxHuHNDUmP/sAVUqPQfzHn+cBaU6ULt/8AAAAAAAA=


--=-pcvVOEGT5WZWel5fVDIs--

