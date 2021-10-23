Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8073743853D
	for <lists+kvm@lfdr.de>; Sat, 23 Oct 2021 22:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhJWUbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Oct 2021 16:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhJWUbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Oct 2021 16:31:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C85C061714;
        Sat, 23 Oct 2021 13:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GsSYDF8garT1CXCASPGB5IspvR7tuRE7qGnNeB79Okc=; b=AaC1vmzD/kgyb42huZxdznMGew
        uD48QDye/LU8chF6DR86o45knd89zHGLeZXOD5za5KMLr53yQMAdHSgsOfsaZqnwf+VbJooBOe1NJ
        Gid31VwY1Fo1y1DhXQgQhFnHVhuyDBcNy8Pu1wJ9Yb+XVCAa0ghY/gVbRayjIDE8lR/ylYEjiKlFP
        V3MfS5PymFMuchIq6LyxtEo20UX73wgMLgWWV98WAU0PICjuI63m6gMnVODZmFDjyDgIyPBQ6eRmJ
        vIIbNqs50GoaM14gb1jccx68bo1EVjCoPsAfQ7gEbUuMuhiIWzKQ6vbrhPTJPxRuQuK9Mc1E6Mmv5
        64rQnBow==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1meNdt-00DG9m-IO; Sat, 23 Oct 2021 20:29:26 +0000
Message-ID: <1b02a06421c17993df337493a68ba923f3bd5c0f.camel@infradead.org>
Subject: [PATCH] KVM: x86: switch pvclock_gtod_sync_lock to a raw spinlock
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     mtosatti@redhat.com, vkuznets@redhat.com,
        syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com
Date:   Sat, 23 Oct 2021 21:29:22 +0100
In-Reply-To: <a836f7c1235079f666321e194fe6a6dcc894b197.camel@infradead.org>
References: <20210330165958.3094759-1-pbonzini@redhat.com>
         <20210330165958.3094759-3-pbonzini@redhat.com>
         <a836f7c1235079f666321e194fe6a6dcc894b197.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-Cko+5xVL0yewozAbLF9p"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-Cko+5xVL0yewozAbLF9p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

On the preemption path when updating a Xen guest's runstate times, this
lock is taken inside the scheduler rq->lock, which is a raw spinlock.
This was shown in a lockdep warning:

[   89.138354] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   89.138356] [ BUG: Invalid wait context ]
[   89.138358] 5.15.0-rc5+ #834 Tainted: G S        I E
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
...
[   89.138695]  get_kvmclock_ns+0x1f/0x130 [kvm]
[   89.138734]  kvm_xen_update_runstate+0x14/0x90 [kvm]
[   89.138783]  kvm_xen_update_runstate_guest+0x15/0xd0 [kvm]
[   89.138830]  kvm_arch_vcpu_put+0xe6/0x170 [kvm]
[   89.138870]  kvm_sched_out+0x2f/0x40 [kvm]
[   89.138900]  __schedule+0x5de/0xbd0

Fixes: 30b5c851af79 ("KVM: x86/xen: Add support for vCPU runstate informati=
on")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
> However, in 5.15-rc5 I'm still seeing the warning below when I run
> xen_shinfo_test. I confess I'm not entirely sure what it's telling
> me.

I think this is what it was telling me...
=20
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/x86.c              | 28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index f8f48a7ec577..70771376e246 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1097,7 +1097,7 @@ struct kvm_arch {
 	u64 cur_tsc_generation;
 	int nr_vcpus_matched_tsc;
=20
-	spinlock_t pvclock_gtod_sync_lock;
+	raw_spinlock_t pvclock_gtod_sync_lock;
 	bool use_master_clock;
 	u64 master_kernel_ns;
 	u64 master_cycle_now;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aabd3a2ec1bc..f0874c3d12ce 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2542,7 +2542,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu=
, u64 data)
 	kvm_vcpu_write_tsc_offset(vcpu, offset);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
=20
-	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
+	raw_spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
 	if (!matched) {
 		kvm->arch.nr_vcpus_matched_tsc =3D 0;
 	} else if (!already_matched) {
@@ -2550,7 +2550,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu=
, u64 data)
 	}
=20
 	kvm_track_tsc_matching(vcpu);
-	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
 }
=20
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
@@ -2780,9 +2780,9 @@ static void kvm_gen_update_masterclock(struct kvm *kv=
m)
 	kvm_make_mclock_inprogress_request(kvm);
=20
 	/* no guest entries from this point */
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
+	raw_spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	pvclock_update_vm_gtod_copy(kvm);
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
=20
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
@@ -2800,15 +2800,15 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 	unsigned long flags;
 	u64 ret;
=20
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
+	raw_spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	if (!ka->use_master_clock) {
-		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+		raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
 		return get_kvmclock_base_ns() + ka->kvmclock_offset;
 	}
=20
 	hv_clock.tsc_timestamp =3D ka->master_cycle_now;
 	hv_clock.system_time =3D ka->master_kernel_ns + ka->kvmclock_offset;
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
=20
 	/* both __this_cpu_read() and rdtsc() should be on the same cpu */
 	get_cpu();
@@ -2902,13 +2902,13 @@ static int kvm_guest_time_update(struct kvm_vcpu *v=
)
 	 * If the host uses TSC clock, then passthrough TSC as stable
 	 * to the guest.
 	 */
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
+	raw_spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	use_master_clock =3D ka->use_master_clock;
 	if (use_master_clock) {
 		host_tsc =3D ka->master_cycle_now;
 		kernel_ns =3D ka->master_kernel_ns;
 	}
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
=20
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
@@ -6100,13 +6100,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		 * is slightly ahead) here we risk going negative on unsigned
 		 * 'system_time' when 'user_ns.clock' is very small.
 		 */
-		spin_lock_irq(&ka->pvclock_gtod_sync_lock);
+		raw_spin_lock_irq(&ka->pvclock_gtod_sync_lock);
 		if (kvm->arch.use_master_clock)
 			now_ns =3D ka->master_kernel_ns;
 		else
 			now_ns =3D get_kvmclock_base_ns();
 		ka->kvmclock_offset =3D user_ns.clock - now_ns;
-		spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
+		raw_spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
=20
 		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
 		break;
@@ -8139,9 +8139,9 @@ static void kvm_hyperv_tsc_notifier(void)
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		struct kvm_arch *ka =3D &kvm->arch;
=20
-		spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
+		raw_spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 		pvclock_update_vm_gtod_copy(kvm);
-		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+		raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
=20
 		kvm_for_each_vcpu(cpu, vcpu, kvm)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
@@ -11182,7 +11182,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
=20
 	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
 	mutex_init(&kvm->arch.apic_map_lock);
-	spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
+	raw_spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
=20
 	kvm->arch.kvmclock_offset =3D -get_kvmclock_base_ns();
 	pvclock_update_vm_gtod_copy(kvm);
--=20
2.25.1



--=-Cko+5xVL0yewozAbLF9p
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
MDIzMjAyOTIyWjAvBgkqhkiG9w0BCQQxIgQgJksF/Ep5CxwACKRieSPJ3iEqvJzgWmeU65mnLbF8
VqIwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAIeelj4YK4wck7R+lc+h/MEJyFA4L9gbSX1sK8FQapXyQEd80HfY+OzX3OFIaXwd
g1lL0MkA5u5n3r0caXqWfCRnN3FMd0eSsD6atQzJCyjwq9ueJqkM0R0yfZx86e6iYTHDAFbIqsDM
dviFRBl8X/Dcazr3RtApoxi0/E1w7R0DIF+Q3TWAK6Z4EGOZqkYtxqTR5aoSmAiGobPL2zs2KaYY
krjNi4md3OdLl73IR1CQbcMqc7CiRR+e7KPNO3FP4aamT3jCeUHr937MQBYmSeTnT/AIfM4WA+zT
76te9i+10S4U8tFBnN9brXuYavie012dz/Wy1RRFIEIObKAZaAwAAAAAAAA=


--=-Cko+5xVL0yewozAbLF9p--

