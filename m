Return-Path: <kvm+bounces-37458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CDCDA2A402
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:19:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A08A81885D1A
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 09:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D7DB225A5A;
	Thu,  6 Feb 2025 09:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YYrtI+xO"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BF6225A34;
	Thu,  6 Feb 2025 09:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738833528; cv=none; b=oFiBGlAqK5gqb7DvASuRhyiuhVuX9Y5uc4JQrQccDOY6DhBzP6K3l0LAPbb0C0zw2ildOwGECBVeC+nJ1/Y7NxP52cGD6uOuIZCVGpm9kwjZ5TfOKfZDcLLs/OlgGDasjT4XiMxZOCqJiyi0x6eGCMCj8glLUkoZnqAuOlO+GlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738833528; c=relaxed/simple;
	bh=buqUevpkAbmw2Axm3WWW9ag7jE8QxW3gGF+wrl8mVi4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SRye/kNdTAFQ0fVCH35CubY1S+LWN7hRCpmkoAU9FkUitzF50LmpF8V4LfAdhS1KtQAHTEp4vu4pB+l6BF97F3RVmnCLv6lGJ9MT3at8DAEtVZ+Vog7fKkOwRlxqfDLDFVAm6AH7SRCNQKurJTSdYCuK7aziR/Z2HxFlL6+dHbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YYrtI+xO; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5qsTAhc6RE8E+MYme7EC9JGCOg6eHbWY6mqBwoD7sng=; b=YYrtI+xOnWyXo/PAW4ra23sbCq
	OLrNdGvvegGZMXbSnVnVGyWT22aM6zaX58mFJQV8QXUMqEJT24t9CnoQs+ywafENsx6GiDU2sedTr
	B45Wt6EvvuA6e1EY8RqMl6sV8K2GMmXNO0PbHf8d4ditVRHrtiyfmvjeBICo1ZyorktFfoQn1K7iR
	G23vq1/RTx0+AKYBAS224Ki9LP2Me3CALe8LsCFW3HAbCpdJQI2amrQCT4qIAVQN34OY7aINkIctC
	JO4KQESoPr2RiLIOBw38b3ClEWm7EUs8Woh5JlMMAGa07JDlSueA18oUIq358rjxADk7lRFh9sdcU
	jw6W72EA==;
Received: from [54.239.6.187] (helo=freeip.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfy1p-00000005l3J-2Low;
	Thu, 06 Feb 2025 09:18:33 +0000
Message-ID: <8701dbe884d98de8860f04c4174d81d8373be274.camel@infradead.org>
Subject: Re: [PATCH 1/5] KVM: x86/xen: Restrict hypercall MSR to unofficial
 synthetic range
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Paul Durrant <paul@xen.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com, Joao Martins
	 <joao.m.martins@oracle.com>
Date: Thu, 06 Feb 2025 09:18:31 +0000
In-Reply-To: <Z6OI5VMDlgLbqytM@google.com>
References: <20250201011400.669483-1-seanjc@google.com>
	 <20250201011400.669483-2-seanjc@google.com>
	 <43f702b383fb99d435f2cdb8ef35cc1449fe6c23.camel@infradead.org>
	 <Z6N-kn1-p6nIWHeP@google.com>
	 <cd3fb8dd79d7766f383748ec472de3943021eb39.camel@infradead.org>
	 <Z6OI5VMDlgLbqytM@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-Yf5OXb3b9uSFFHymr9q9"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-Yf5OXb3b9uSFFHymr9q9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-02-05 at 07:51 -0800, Sean Christopherson wrote:
>=20
> > Those two happen in reverse chronological order, don't they? And in the
> > lower one the comment tells you that hyperv_enabled() doesn't work yet.
> > When the higher one is called later, it calls kvm_xen_init() *again* to
> > put the MSR in the right place.
> >=20
> > It could be prettier, but I don't think it's broken, is it?
>=20
> Gah, -ENOCOFFEE.

I trust this version would require less coffee to parse...

=46rom a90c2df0bd9589609085dd42f94b61de1bf48eb7 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw@amazon.co.uk>
Date: Thu, 6 Feb 2025 08:52:52 +0000
Subject: [PATCH] i386/xen: Move KVM_XEN_HVM_CONFIG ioctl to
 kvm_xen_init_vcpu()

At the time kvm_xen_init() is called, hyperv_enabled() doesn't yet work, so
the correct MSR index to use for the hypercall page isn't known.

Rather than setting it to the default and then shifting it later for the
Hyper-V case with a confusing second call to kvm_init_xen(), just do it
once in kvm_xen_init_vcpu().

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 target/i386/kvm/kvm.c     | 16 +++++---------
 target/i386/kvm/xen-emu.c | 44 ++++++++++++++++++++-------------------
 target/i386/kvm/xen-emu.h |  4 ++--
 3 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6c749d4ee8..b4deec6255 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2129,6 +2129,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cs->kvm_state->xen_version) {
 #ifdef CONFIG_XEN_EMU
         struct kvm_cpuid_entry2 *xen_max_leaf;
+        uint32_t hypercall_msr =3D
+            hyperv_enabled(cpu) ? XEN_HYPERCALL_MSR_HYPERV : XEN_HYPERCALL=
_MSR;
=20
         memcpy(signature, "XenVMMXenVMM", 12);
=20
@@ -2150,13 +2152,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         c->function =3D kvm_base + XEN_CPUID_HVM_MSR;
         /* Number of hypercall-transfer pages */
         c->eax =3D 1;
-        /* Hypercall MSR base address */
-        if (hyperv_enabled(cpu)) {
-            c->ebx =3D XEN_HYPERCALL_MSR_HYPERV;
-            kvm_xen_init(cs->kvm_state, c->ebx);
-        } else {
-            c->ebx =3D XEN_HYPERCALL_MSR;
-        }
+        c->ebx =3D hypercall_msr;
         c->ecx =3D 0;
         c->edx =3D 0;
=20
@@ -2194,7 +2190,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
             }
         }
=20
-        r =3D kvm_xen_init_vcpu(cs);
+        r =3D kvm_xen_init_vcpu(cs, hypercall_msr);
         if (r) {
             return r;
         }
@@ -3245,9 +3241,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
             error_report("kvm: Xen support only available in PC machine");
             return -ENOTSUP;
         }
-        /* hyperv_enabled() doesn't work yet. */
-        uint32_t msr =3D XEN_HYPERCALL_MSR;
-        ret =3D kvm_xen_init(s, msr);
+        ret =3D kvm_xen_init(s);
         if (ret < 0) {
             return ret;
         }
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index e81a245881..1144a6efcd 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -108,15 +108,11 @@ static inline int kvm_copy_to_gva(CPUState *cs, uint6=
4_t gva, void *buf,
     return kvm_gva_rw(cs, gva, buf, sz, true);
 }
=20
-int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
+int kvm_xen_init(KVMState *s)
 {
     const int required_caps =3D KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
         KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL | KVM_XEN_HVM_CONFIG_SHARED_INF=
O;
-    struct kvm_xen_hvm_config cfg =3D {
-        .msr =3D hypercall_msr,
-        .flags =3D KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
-    };
-    int xen_caps, ret;
+    int xen_caps;
=20
     xen_caps =3D kvm_check_extension(s, KVM_CAP_XEN_HVM);
     if (required_caps & ~xen_caps) {
@@ -130,20 +126,6 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
             .u.xen_version =3D s->xen_version,
         };
         (void)kvm_vm_ioctl(s, KVM_XEN_HVM_SET_ATTR, &ha);
-
-        cfg.flags |=3D KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
-    }
-
-    ret =3D kvm_vm_ioctl(s, KVM_XEN_HVM_CONFIG, &cfg);
-    if (ret < 0) {
-        error_report("kvm: Failed to enable Xen HVM support: %s",
-                     strerror(-ret));
-        return ret;
-    }
-
-    /* If called a second time, don't repeat the rest of the setup. */
-    if (s->xen_caps) {
-        return 0;
     }
=20
     /*
@@ -185,10 +167,14 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
     return 0;
 }
=20
-int kvm_xen_init_vcpu(CPUState *cs)
+int kvm_xen_init_vcpu(CPUState *cs, uint32_t hypercall_msr)
 {
     X86CPU *cpu =3D X86_CPU(cs);
     CPUX86State *env =3D &cpu->env;
+    struct kvm_xen_hvm_config cfg =3D {
+        .msr =3D hypercall_msr,
+        .flags =3D KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
+    };
     int err;
=20
     /*
@@ -210,6 +196,22 @@ int kvm_xen_init_vcpu(CPUState *cs)
                          strerror(-err));
             return err;
         }
+
+        cfg.flags |=3D KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
+    }
+
+    /*
+     * This is a per-KVM setting, but hyperv_enabled() can't be used
+     * when kvm_xen_init() is called from kvm_arch_init(), so do it
+     * when the BSP is initialized.
+     */
+    if (cs->cpu_index =3D=3D 0) {
+        err =3D kvm_vm_ioctl(cs->kvm_state, KVM_XEN_HVM_CONFIG, &cfg);
+        if (err) {
+            error_report("kvm: Failed to enable Xen HVM support: %s",
+                         strerror(-err));
+            return err;
+        }
     }
=20
     env->xen_vcpu_info_gpa =3D INVALID_GPA;
diff --git a/target/i386/kvm/xen-emu.h b/target/i386/kvm/xen-emu.h
index fe85e0b195..7a7c72eee5 100644
--- a/target/i386/kvm/xen-emu.h
+++ b/target/i386/kvm/xen-emu.h
@@ -23,8 +23,8 @@
=20
 #define XEN_VERSION(maj, min) ((maj) << 16 | (min))
=20
-int kvm_xen_init(KVMState *s, uint32_t hypercall_msr);
-int kvm_xen_init_vcpu(CPUState *cs);
+int kvm_xen_init(KVMState *s);
+int kvm_xen_init_vcpu(CPUState *cs, uint32_t hypercall_msr);
 int kvm_xen_handle_exit(X86CPU *cpu, struct kvm_xen_exit *exit);
 int kvm_put_xen_state(CPUState *cs);
 int kvm_get_xen_state(CPUState *cs);
--=20
2.48.1



--=-Yf5OXb3b9uSFFHymr9q9
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCD9Aw
ggSOMIIDdqADAgECAhAOmiw0ECVD4cWj5DqVrT9PMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yNDAxMzAwMDAwMDBaFw0zMTEx
MDkyMzU5NTlaMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYDVQQDExdWZXJv
a2V5IFNlY3VyZSBFbWFpbCBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjvgLKj
jfhCFqxYyRiW8g3cNFAvltDbK5AzcOaR7yVzVGadr4YcCVxjKrEJOgi7WEOH8rUgCNB5cTD8N/Et
GfZI+LGqSv0YtNa54T9D1AWJy08ZKkWvfGGIXN9UFAPMJ6OLLH/UUEgFa+7KlrEvMUupDFGnnR06
aDJAwtycb8yXtILj+TvfhLFhafxroXrflspavejQkEiHjNjtHnwbZ+o43g0/yxjwnarGI3kgcak7
nnI9/8Lqpq79tLHYwLajotwLiGTB71AGN5xK+tzB+D4eN9lXayrjcszgbOv2ZCgzExQUAIt98mre
8EggKs9mwtEuKAhYBIP/0K6WsoMnQCcCAwEAAaOCAVwwggFYMBIGA1UdEwEB/wQIMAYBAf8CAQAw
HQYDVR0OBBYEFIlICOogTndrhuWByNfhjWSEf/xwMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
IZ3zbcgPMA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIweQYI
KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYB
BQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
QS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQELBQADggEB
ACiagCqvNVxOfSd0uYfJMiZsOEBXAKIR/kpqRp2YCfrP4Tz7fJogYN4fxNAw7iy/bPZcvpVCfe/H
/CCcp3alXL0I8M/rnEnRlv8ItY4MEF+2T/MkdXI3u1vHy3ua8SxBM8eT9LBQokHZxGUX51cE0kwa
uEOZ+PonVIOnMjuLp29kcNOVnzf8DGKiek+cT51FvGRjV6LbaxXOm2P47/aiaXrDD5O0RF5SiPo6
xD1/ClkCETyyEAE5LRJlXtx288R598koyFcwCSXijeVcRvBB1cNOLEbg7RMSw1AGq14fNe2cH1HG
W7xyduY/ydQt6gv5r21mDOQ5SaZSWC/ZRfLDuEYwggWbMIIEg6ADAgECAhAH5JEPagNRXYDiRPdl
c1vgMA0GCSqGSIb3DQEBCwUAMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYD
VQQDExdWZXJva2V5IFNlY3VyZSBFbWFpbCBHMjAeFw0yNDEyMzAwMDAwMDBaFw0yODAxMDQyMzU5
NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZeYAS/SRV6zmfXlXaZ
sNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2zkC9S7/yHDYnqegqt
w4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qGpgFdZEk2/c//ZvUN
i12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41vav1RhZJzYan4a1gU0
kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0cvnO8FM6PTqsnSbcc
0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PWPU6zfQTOMZ9uLQRR
ci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXtREF5lLXxp+CJ6KKS
blPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQrlR0gO3lBzuyPPArV
hvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7IqaAovAX0d+f1YjbmC
VsAwjhLmveFjNwIDAQABo4IBsDCCAawwHwYDVR0jBBgwFoAUiUgI6iBOd2uG5YHI1+GNZIR//HAw
HQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3bXcyQGluZnJhZGVh
ZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEBMA4GA1UdDwEB/wQE
AwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwewYDVR0fBHQwcjA3oDWgM4YxaHR0
cDovL2NybDMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDA3oDWgM4YxaHR0
cDovL2NybDQuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDB2BggrBgEFBQcB
AQRqMGgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBABggrBgEFBQcwAoY0
aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNydDANBgkq
hkiG9w0BAQsFAAOCAQEAQXc4FPiPLRnTDvmOABEzkIumojfZAe5SlnuQoeFUfi+LsWCKiB8Uextv
iBAvboKhLuN6eG/NC6WOzOCppn4mkQxRkOdLNThwMHW0d19jrZFEKtEG/epZ/hw/DdScTuZ2m7im
8ppItAT6GXD3aPhXkXnJpC/zTs85uNSQR64cEcBFjjoQDuSsTeJ5DAWf8EMyhMuD8pcbqx5kRvyt
JPsWBQzv1Dsdv2LDPLNd/JUKhHSgr7nbUr4+aAP2PHTXGcEBh8lTeYea9p4d5k969pe0OHYMV5aL
xERqTagmSetuIwolkAuBCzA9vulg8Y49Nz2zrpUGfKGOD0FMqenYxdJHgDCCBZswggSDoAMCAQIC
EAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQELBQAwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoT
B1Zlcm9rZXkxIDAeBgNVBAMTF1Zlcm9rZXkgU2VjdXJlIEVtYWlsIEcyMB4XDTI0MTIzMDAwMDAw
MFoXDTI4MDEwNDIzNTk1OVowHjEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBANqWLse95HW2F7FhfH9bugyT/danKmmXrbMnz5GZNAfj
Jl5gBL9JFXrOZ9eVdpmw04Tp6aDxZctFLoEDvSWKi367Q7Sg+ci+fH4KwwfQ8Pi0IpIKx2n5emEg
nbOQL1Lv/IcNiep6Cq3DiyaSpSp/RZf+CAfUNySHS8eWmhLU6jGpSD6hxTpYKye7PmrmvMWwfGEP
WoamAV1kSTb9z/9m9Q2LXa89aKmTxNwnAfD3Ohn9mtU3JukwILRMewn9QRXK7KzM+01h5hkCE4nj
W9q/VGFknNhqfhrWBTSQoE9CSVylASGrjzCgS7XmKy/BaH3/7mOOHQv5g1o3Qj/+cdKnpT0I5Qb1
nRy+c7wUzo9OqydJtxzSP4ZyHA4dELto/a3m/ay1XHcpum1pgTOLgxAfGb/T4dCkwRUstSKLMmpL
g9Y9TrN9BM4xn24tBFFyL5znGG0wQGzOVAM68RBzIQb6Fz758fjsr4yZnPbVsU1+gHEs/puNHrG0
9e1EQXmUtfGn4InoopJuU8p5VGD9S3Ikd4UoBlc7xl5yjtNlQxUeYrRlnUSmdlucCEoTX1n4UmtA
9CuVHSA7eUHO7I88CtWG9bGOU7tLgOZoSEvNqtaL/N7sQbBZK4jZ4Rr/zNTQg1SwYjjLB7u96lDP
sipoCi8BfR35/ViNuYJWwDCOEua94WM3AgMBAAGjggGwMIIBrDAfBgNVHSMEGDAWgBSJSAjqIE53
a4blgcjX4Y1khH/8cDAdBgNVHQ4EFgQUXGIam3Bs59Y60yTmWgfDu6pZQ6cwMAYDVR0RBCkwJ4ET
ZHdtdzJAaW5mcmFkZWFkLm9yZ4EQZGF2aWRAd29vZGhvdS5zZTAUBgNVHSAEDTALMAkGB2eBDAEF
AQEwDgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDB7BgNVHR8E
dDByMDegNaAzhjFodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMDegNaAzhjFodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMHYGCCsGAQUFBwEBBGowaDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
MEAGCCsGAQUFBzAChjRodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVt
YWlsRzIuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBBdzgU+I8tGdMO+Y4AETOQi6aiN9kB7lKWe5Ch
4VR+L4uxYIqIHxR7G2+IEC9ugqEu43p4b80LpY7M4KmmfiaRDFGQ50s1OHAwdbR3X2OtkUQq0Qb9
6ln+HD8N1JxO5nabuKbymki0BPoZcPdo+FeRecmkL/NOzzm41JBHrhwRwEWOOhAO5KxN4nkMBZ/w
QzKEy4PylxurHmRG/K0k+xYFDO/UOx2/YsM8s138lQqEdKCvudtSvj5oA/Y8dNcZwQGHyVN5h5r2
nh3mT3r2l7Q4dgxXlovERGpNqCZJ624jCiWQC4ELMD2+6WDxjj03PbOulQZ8oY4PQUyp6djF0keA
MYIDuzCCA7cCAQEwVTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMX
VmVyb2tleSBTZWN1cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJYIZIAWUDBAIBBQCg
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDIwNjA5MTgz
MVowLwYJKoZIhvcNAQkEMSIEIFkqUfW+n9L31K7c+iYI/8G92n9wbliU3EHdBsA1ne9eMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAFK5we2DWAMGg
GEHFyg/4aj1QH9A0KKvJ6B2R+NJ7luxZCG+De8K0bi4YqGlbHmu7ZZq+3SsBeSxEgiD7Cu82cWYV
04O2OCWOxwBXHttc1Y8dbpgRZOH40cCwq+d6dijNvLJv98GPxyIPJj3gtjGfa4BdIxXtqQYKXyHe
Ndhx7b/KCSVKbFLA3oyeya4So3NXvUPX18d0u/ByUnRM5O8FMCTR2V+JqKa6B1LlYxB4n0AOduGQ
P9wRV8XsRyH2vfX/M8Z7xDqwzXN52xtvvNg/G7SPC24P0WwTSoOvlgS5JZrrdMUsz4/KOFL1+58s
ZDo22o0szGTMsE2pidmaWZsMFM2eZOvL4Pt1WIT8ZnvKJ7Evc6FPQhI+D2319TyM8b5NY5rU4Y1B
+BT51r2CyZV1phHeg1DZFB1djqWIX3iHyotAMw3iK/JLTatexlFXATmGKFRr6zAXZZgIoSSCoIKd
0YVpfP1dJijqCGc0qQtUFn2iPKvF4I8DDav7h9QFMmkLah15ahRoVKRSiFpxjcmXVNAgiQVWobgw
0ClM+w6VgHWupzBnZL27lKoFHrKQvW0q4zgfwq8Hn2omWNHVnJm8XXpKHHd9dU6epMuuUNqQ14+D
Ms+aevrMpmc5w1kRIK1Ku10G9f2My+nPYFWNeJg6XJ02iIG0bd40YAzS91eiW30AAAAAAAA=


--=-Yf5OXb3b9uSFFHymr9q9--

