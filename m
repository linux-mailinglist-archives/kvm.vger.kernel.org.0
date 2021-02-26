Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6C432617C
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 11:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhBZKmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 05:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhBZKme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 05:42:34 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60836C061574;
        Fri, 26 Feb 2021 02:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=i0e5kX8gXUd+6KTfFRlLlPVuPcovz9oISb547tzO8i8=; b=wgoKhohYliNlnFTeEm6C+j/7nF
        N2kIb3tdyn3cG9Sdzyb497GBU24JvOixhpCqPTCdHq7nJkIpdST8ie6K/ZOQ5S31L9R1S5trlc7s/
        9kpcssGHSVD/u2EhBxbrtqCz04PTAlw/Xd9z6dKXnpleSDLpZr8Ctp7lm7zxnQXf+Orch7GULyOEP
        mDiyHc2zXDbVDgK8BliSWjpmMjf7Ox8huySfLHgsSEuxNJTmZeayUgA14FdMSU+dCCENutoNnhT9c
        C/uIrgNKWQ74n2yxDWE4ke2nTB5svdWEiBSHTtwFq3ffvvUy7v7x/e45tJ9ohAnWtWS+FnD0Ce3vm
        05bo/Ydw==;
Received: from 54-240-197-233.amazon.com ([54.240.197.233] helo=u3832b3a9db3152.ant.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lFaZD-0004Tz-Ly; Fri, 26 Feb 2021 10:41:52 +0000
Message-ID: <4d9b2bd1eac524335e51253d59bfd805ea691f24.camel@infradead.org>
Subject: Re: [EXTERNAL] [PATCH] KVM: x86: allow compiling out the Xen
 hypercall interface
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>
Date:   Fri, 26 Feb 2021 10:41:48 +0000
In-Reply-To: <20210226101421.81535-1-pbonzini@redhat.com>
References: <20210226101421.81535-1-pbonzini@redhat.com>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-t/iWLJKPuoSgmxsfSQpU"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-t/iWLJKPuoSgmxsfSQpU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-02-26 at 05:14 -0500, Paolo Bonzini wrote:
> The Xen hypercall interface adds to the attack surface of the hypervisor
> and will be used quite rarely.  Allow compiling it out.
>=20
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/Kconfig  |  9 ++++++++
>  arch/x86/kvm/Makefile |  3 ++-
>  arch/x86/kvm/x86.c    |  2 ++
>  arch/x86/kvm/xen.h    | 49 ++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 61 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 7ac592664c52..5a0d704581bd 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -103,6 +103,15 @@ config KVM_AMD_SEV
>           Provides support for launching Encrypted VMs (SEV) and Encrypte=
d VMs
>           with Encrypted State (SEV-ES) on AMD processors.
>=20
> +config KVM_XEN
> +       bool "Support for Xen hypercall interface"
> +       depends on KVM && IA32_FEAT_CTL
> +       help
> +         Provides KVM support for the Xen shared information page and
> +         for passing Xen hypercalls to userspace.

I'd be a bit less specific there. Just "support for hosting Xen HVM
guests" perhaps? It already includes basic event channel support, I'm
posted an RFC for the runstate stuff, and more event channel
acceleration is next...


> +         If in doubt, say "N".
> +
>  config KVM_MMU_AUDIT
>         bool "Audit KVM MMU"
>         depends on KVM && TRACEPOINTS
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index aeab168c5711..1b4766fe1de2 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -14,11 +14,12 @@ kvm-y                       +=3D $(KVM)/kvm_main.o $(=
KVM)/coalesced_mmio.o \
>                                 $(KVM)/dirty_ring.o
>  kvm-$(CONFIG_KVM_ASYNC_PF)     +=3D $(KVM)/async_pf.o
>=20
> -kvm-y                  +=3D x86.o emulate.o i8259.o irq.o lapic.o xen.o =
\
> +kvm-y                  +=3D x86.o emulate.o i8259.o irq.o lapic.o \
>                            i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr=
.o \
>                            hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o =
\
>                            mmu/spte.o
>  kvm-$(CONFIG_X86_64) +=3D mmu/tdp_iter.o mmu/tdp_mmu.o
> +kvm-$(CONFIG_KVM_XEN)  +=3D xen.o
>=20
>  kvm-intel-y            +=3D vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/=
vmcs12.o \
>                            vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bfc928495bd4..9727295b7817 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8039,8 +8039,10 @@ void kvm_arch_exit(void)
>         kvm_mmu_module_exit();
>         free_percpu(user_return_msrs);
>         kmem_cache_destroy(x86_fpu_cache);
> +#ifdef CONFIG_KVM_XEN
>         static_key_deferred_flush(&kvm_xen_enabled);
>         WARN_ON(static_branch_unlikely(&kvm_xen_enabled.key));
> +#endif

We could always just drop that. It's just paranoia.

>  }
>=20
>  static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
> diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
> index b66a921776f4..6abdbebb029b 100644
> --- a/arch/x86/kvm/xen.h
> +++ b/arch/x86/kvm/xen.h
> @@ -9,6 +9,7 @@
>  #ifndef __ARCH_X86_KVM_XEN_H__
>  #define __ARCH_X86_KVM_XEN_H__
>=20
> +#ifdef CONFIG_KVM_XEN
>  #include <linux/jump_label_ratelimit.h>
>=20
>  extern struct static_key_false_deferred kvm_xen_enabled;
> @@ -18,7 +19,6 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct=
 kvm_xen_vcpu_attr *data)
>  int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_att=
r *data);
>  int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)=
;
>  int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)=
;
> -int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
>  int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data);
>  int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
>  void kvm_xen_destroy_vm(struct kvm *kvm);
> @@ -38,6 +38,53 @@ static inline int kvm_xen_has_interrupt(struct kvm_vcp=
u *vcpu)
>=20
>         return 0;
>  }
> +#else
> +static inline int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kv=
m_xen_vcpu_attr *data)
> +{
> +       return -EINVAL;
> +}
> +
> +static inline int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kv=
m_xen_vcpu_attr *data)
> +{
> +       return -EINVAL;
> +}
> +
> +static inline int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_h=
vm_attr *data)
> +{
> +       return -EINVAL;
> +}
> +
> +static inline int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_h=
vm_attr *data)
> +{
> +       return -EINVAL;
> +}
> +
> +static inline int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u6=
4 data)
> +{
> +       return 1;
> +}
> +
> +static inline int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm=
_config *xhc)
> +{
> +       return -EINVAL;
> +}



I wonder if at least for the ioctls, it might be nicer to put the
#ifdef CONFIG_KVM_XEN around the callers for these? If we did it that
way we'd probably spot the fact that we need to stop advertising the
feature too... :)


--=-t/iWLJKPuoSgmxsfSQpU
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
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
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEw
MjI2MTA0MTQ4WjAvBgkqhkiG9w0BCQQxIgQgdiTrek9jg6V1ydeDsVAf7cMh8zqzF+0TbNSyIpgK
Kvkwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAEJ/Yf425T2bTg8Er9O4PHqjYVXyYr/3Qi80yPWsOQqYVo0pzzlVFHjR4mSkkD1B
RovtvlkS+kTu9Gttce47obFaKtKv6VvCS/0oTWh+Pv0/Y2CclzjgJYzhGkCgJqqbT+KUR15vVIBR
A9xrzDf0GgzbwyJQ+thYYo4m9dRWjKfKWc+uQi0nn4xTdHbx8Kymi4pPP5vIGhZPOUKjtMeEFQIe
PaIBbd5OyOc/ZLd5/E0T68XiK0psOlWV/fCD+WQ0Fr6fi+/bLpkHEH63e31CJmtU0tWLjKYPwmjd
2PCSzOMI9aBrnEM2nOgS0KNMi72358lR3bi+cKaoNsokyGUKSn4AAAAAAAA=


--=-t/iWLJKPuoSgmxsfSQpU--

