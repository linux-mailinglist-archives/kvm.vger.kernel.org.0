Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C91A438500
	for <lists+kvm@lfdr.de>; Sat, 23 Oct 2021 21:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhJWTgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Oct 2021 15:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhJWTgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Oct 2021 15:36:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB98CC061714;
        Sat, 23 Oct 2021 12:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FP1igdZubOueDpKQDfn29wr1f9ZoyROfQDGc2rVNauI=; b=pSYV34nno6suvgJobPKKHSNe0C
        madJmN3aPHj6/lPW2Y7CoNOCboxPiPQCHBnygC0RaBzsyJ+UvflcrW0DWGnZ+Uw7WAwG36gOSNGu6
        n4qXGS/D85IfIoMFx7qOcoRfa4tLLLnmHn067fHh1SX5My4N0rt16NqKeLH5sxiRDATNSTj+I4Mfz
        EwpBriYMGzqK9eRHn2lqCHSByVrbzqhOX1vi8oCFIIvuUYnBkQWEshIrZ9pspWMk5rGr/JpU+/2+7
        71+kZ/DcdXFTQCoJzCaFlT3IJqSb5yRndctqVKgG/SXlqwDrk3weOg66s6NK/2ZH/dpHWkcSH2A6x
        He2sVIhA==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1meMmC-00DBGr-KE; Sat, 23 Oct 2021 19:33:57 +0000
Message-ID: <a836f7c1235079f666321e194fe6a6dcc894b197.camel@infradead.org>
Subject: Re: [EXTERNAL] [PATCH 2/2] KVM: x86: disable interrupts while
 pvclock_gtod_sync_lock is taken
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     mtosatti@redhat.com, vkuznets@redhat.com,
        syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com
Date:   Sat, 23 Oct 2021 20:33:53 +0100
In-Reply-To: <20210330165958.3094759-3-pbonzini@redhat.com>
References: <20210330165958.3094759-1-pbonzini@redhat.com>
         <20210330165958.3094759-3-pbonzini@redhat.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-v+ZcfzCvQ+a1ciKLO7t6"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-v+ZcfzCvQ+a1ciKLO7t6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-03-30 at 12:59 -0400, Paolo Bonzini wrote:
> pvclock_gtod_sync_lock can be taken with interrupts disabled if the
> preempt notifier calls get_kvmclock_ns to update the Xen
> runstate information:
>=20
>    spin_lock include/linux/spinlock.h:354 [inline]
>    get_kvmclock_ns+0x25/0x390 arch/x86/kvm/x86.c:2587
>    kvm_xen_update_runstate+0x3d/0x2c0 arch/x86/kvm/xen.c:69
>    kvm_xen_update_runstate_guest+0x74/0x320 arch/x86/kvm/xen.c:100
>    kvm_xen_runstate_set_preempted arch/x86/kvm/xen.h:96 [inline]
>    kvm_arch_vcpu_put+0x2d8/0x5a0 arch/x86/kvm/x86.c:4062
>=20
> So change the users of the spinlock to spin_lock_irqsave and
> spin_unlock_irqrestore.

Apologies, I didn't spot this at the time. Looks sane enough (if we
ignore the elephant in the room that kvm_xen_update_runstate_guest() is
also writing to userspace with interrupts disabled on this preempted
code path, but I have a fix for that in the works=C2=B9).

However, in 5.15-rc5 I'm still seeing the warning below when I run
xen_shinfo_test. I confess I'm not entirely sure what it's telling me.


[   89.138354] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   89.138356] [ BUG: Invalid wait context ]
[   89.138358] 5.15.0-rc5+ #834 Tainted: G S        I E   =20
[   89.138360] -----------------------------
[   89.138361] xen_shinfo_test/2575 is trying to lock:
[   89.138363] ffffa34a0364efd8 (&kvm->arch.pvclock_gtod_sync_lock){....}-{=
3:3}, at: get_kvmclock_ns+0x1f/0x130 [kvm]
[   89.138442] other info that might help us debug this:
[   89.138444] context-{5:5}
[   89.138445] 4 locks held by xen_shinfo_test/2575:
[   89.138447]  #0: ffff972bdc3b8108 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vc=
pu_ioctl+0x77/0x6f0 [kvm]
[   89.138483]  #1: ffffa34a03662e90 (&kvm->srcu){....}-{0:0}, at: kvm_arch=
_vcpu_ioctl_run+0xdc/0x8b0 [kvm]
[   89.138526]  #2: ffff97331fdbac98 (&rq->__lock){-.-.}-{2:2}, at: __sched=
ule+0xff/0xbd0
[   89.138534]  #3: ffffa34a03662e90 (&kvm->srcu){....}-{0:0}, at: kvm_arch=
_vcpu_put+0x26/0x170 [kvm]
[   89.138576] stack backtrace:
[   89.138577] CPU: 27 PID: 2575 Comm: xen_shinfo_test Tainted: G S        =
I E     5.15.0-rc5+ #834
[   89.138580] Hardware name: Intel Corporation S2600CW/S2600CW, BIOS SE5C6=
10.86B.01.01.0008.021120151325 02/11/2015
[   89.138582] Call Trace:
[   89.138585]  dump_stack_lvl+0x6a/0x9a
[   89.138592]  __lock_acquire.cold+0x2ac/0x2d5
[   89.138597]  ? __lock_acquire+0x578/0x1f80
[   89.138604]  lock_acquire+0xc0/0x2d0
[   89.138608]  ? get_kvmclock_ns+0x1f/0x130 [kvm]
[   89.138648]  ? find_held_lock+0x2b/0x80
[   89.138653]  _raw_spin_lock_irqsave+0x48/0x60
[   89.138656]  ? get_kvmclock_ns+0x1f/0x130 [kvm]
[   89.138695]  get_kvmclock_ns+0x1f/0x130 [kvm]
[   89.138734]  kvm_xen_update_runstate+0x14/0x90 [kvm]
[   89.138783]  kvm_xen_update_runstate_guest+0x15/0xd0 [kvm]
[   89.138830]  kvm_arch_vcpu_put+0xe6/0x170 [kvm]
[   89.138870]  kvm_sched_out+0x2f/0x40 [kvm]
[   89.138900]  __schedule+0x5de/0xbd0
[   89.138904]  ? kvm_mmu_topup_memory_cache+0x21/0x70 [kvm]
[   89.138937]  __cond_resched+0x34/0x50
[   89.138941]  kmem_cache_alloc+0x228/0x2e0
[   89.138946]  kvm_mmu_topup_memory_cache+0x21/0x70 [kvm]
[   89.138979]  mmu_topup_memory_caches+0x1d/0x70 [kvm]
[   89.139024]  kvm_mmu_load+0x2d/0x750 [kvm]
[   89.139070]  ? kvm_cpu_has_extint+0x15/0x90 [kvm]
[   89.139113]  ? kvm_cpu_has_injectable_intr+0xe/0x50 [kvm]
[   89.139155]  vcpu_enter_guest+0xc77/0x1210 [kvm]
[   89.139195]  ? kvm_arch_vcpu_ioctl_run+0x146/0x8b0 [kvm]
[   89.139235]  kvm_arch_vcpu_ioctl_run+0x146/0x8b0 [kvm]
[   89.139274]  kvm_vcpu_ioctl+0x279/0x6f0 [kvm]
[   89.139306]  ? find_held_lock+0x2b/0x80
[   89.139312]  __x64_sys_ioctl+0x83/0xb0
[   89.139316]  do_syscall_64+0x3b/0x90
[   89.139320]  entry_SYSCALL_64_after_hwframe+0x44/0xae

=C2=B9 https://git.infradead.org/users/dwmw2/linux.git/commitdiff/ec22c0825=
8

--=-v+ZcfzCvQ+a1ciKLO7t6
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
MDIzMTkzMzUzWjAvBgkqhkiG9w0BCQQxIgQgpHxXM/FqEHG4vbhUuW//tlxofd/kFy+yyxRdkwwF
LbQwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAFtzCLY2kD1OMwrwCawY6jQ4vbt9dZt5CTmD5roSM8Z+Cw6KtTEhkD1FQsD9dj3F
hm4YTLwtOEneBYtg6s39rUjfmKUaWvhrocl40llNr0jvKCRdzi4YdOoZ5B7Wrfl7ddoFdP0PWVbg
90QuzcvX+1evSSB9mXyf2qgYYYUNy8GPq9ZFIx0foRLWUYKyL/lBHjtlJKHSd4uep8CUO1TvfFKs
NmFkNv5RCzFdt5r/StO1luj0m2o5jNt/p2Td58jLbVVKuqMN3zVNQF1Yk/cNkDQOUJSNSCBFVJY9
9yEoklvPnE1AmXtHwNe/kgXrAFQ+m8hNVBlJOuNlw8Z9E/CvniAAAAAAAAA=


--=-v+ZcfzCvQ+a1ciKLO7t6--

