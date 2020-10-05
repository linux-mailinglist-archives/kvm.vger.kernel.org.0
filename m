Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6568283781
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 16:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgJEOS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 10:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgJEOS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 10:18:29 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7261C0613CE
        for <kvm@vger.kernel.org>; Mon,  5 Oct 2020 07:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:Date:Cc:To:
        From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=n5Aik+8HqXQo4VS8CWv9//329A+WLNWB/5I26cclU14=; b=0aenLb1Lj/2xdziVy4yUFN0a/0
        qQF6ZrTAOo6mCpeiTKOU1uyYlqPHk++o81ad2OOAKpWlKkGMWJKaggdLH8tmREOjSKbkayg945sVj
        qgYtNtey+FC0SmaXIO5RUYyddnK+M6xyqzKBW4JzHniBLfvJe3CEqbHfe47ce3IIV2b5H7pYjJkQn
        LodSR3zZ80NsS6agyjOEMe5a80yTS+Jw5UBY29Kj2+ajq/UJ+cvg3MVemxVTXZixyBE3tSX6+VI7r
        JQRTl2Azixd6jx6IzKYuKE0TQpkjZ0gHqfZGOvfqNo4H0ZJC2M/cn4gt17QjS6BS0HFiNMWz/7XOn
        ZilcNWjA==;
Received: from 54-240-197-232.amazon.com ([54.240.197.232] helo=u3832b3a9db3152.ant.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPRJl-0000Av-7o; Mon, 05 Oct 2020 14:18:21 +0000
Message-ID: <78097f9218300e63e751e077a0a5ca029b56ba46.camel@infradead.org>
Subject: [PATCH] target/i386: Support up to 32768 CPUs without IRQ remapping
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel <qemu-devel@nongnu.org>
Cc:     x86 <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 05 Oct 2020 15:18:19 +0100
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-zhygViik0d3u9bnnWDtk"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-zhygViik0d3u9bnnWDtk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The IOAPIC has an 'Extended Destination ID' field in its RTE, which maps
to bits 11-4 of the MSI address. Since those address bits fall within a
given 4KiB page they were historically non-trivial to use on real hardware.

The Intel IOMMU uses the lowest bit to indicate a remappable format MSI,
and then the remaining 7 bits are part of the index.

Where the remappable format bit isn't set, we can actually use the other
seven to allow external (IOAPIC and MSI) interrupts to reach up to 32768
CPUs instead of just the 255 permitted on bare metal.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 hw/i386/kvm/apic.c                          |  7 ++
 hw/i386/pc.c                                | 16 ++---
 include/standard-headers/asm-x86/kvm_para.h |  1 +
 target/i386/cpu.c                           |  5 +-
 target/i386/kvm.c                           | 74 +++++++++++++++------
 target/i386/kvm_i386.h                      |  2 +
 6 files changed, 75 insertions(+), 30 deletions(-)

diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
index 4eb2d77b87..aeb3366ae8 100644
--- a/hw/i386/kvm/apic.c
+++ b/hw/i386/kvm/apic.c
@@ -183,6 +183,13 @@ static void kvm_send_msi(MSIMessage *msg)
 {
     int ret;
=20
+    /*
+     * The message has already passed through interrupt remapping if enabl=
ed,
+     * but the legacy extended destination ID in low bits still needs to b=
e
+     * handled.
+     */
+    msg->address =3D kvm_swizzle_msi_ext_dest_id(msg->address);
+
     ret =3D kvm_irqchip_send_msi(kvm_state, *msg);
     if (ret < 0) {
         fprintf(stderr, "KVM: injection failed, MSI lost (%s)\n",
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index e87be5d29a..a06c091227 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -99,6 +99,7 @@
=20
 GlobalProperty pc_compat_5_1[] =3D {
     { "ICH9-LPC", "x-smi-cpu-hotplug", "off" },
+    { TYPE_X86_CPU, "kvm-msi-ext-dest-id", "off" },
 };
 const size_t pc_compat_5_1_len =3D G_N_ELEMENTS(pc_compat_5_1);
=20
@@ -807,17 +808,12 @@ void pc_machine_done(Notifier *notifier, void *data)
         fw_cfg_modify_i16(x86ms->fw_cfg, FW_CFG_NB_CPUS, x86ms->boot_cpus)=
;
     }
=20
-    if (x86ms->apic_id_limit > 255 && !xen_enabled()) {
-        IntelIOMMUState *iommu =3D INTEL_IOMMU_DEVICE(x86_iommu_get_defaul=
t());
=20
-        if (!iommu || !x86_iommu_ir_supported(X86_IOMMU_DEVICE(iommu)) ||
-            iommu->intr_eim !=3D ON_OFF_AUTO_ON) {
-            error_report("current -smp configuration requires "
-                         "Extended Interrupt Mode enabled. "
-                         "You can add an IOMMU using: "
-                         "-device intel-iommu,intremap=3Don,eim=3Don");
-            exit(EXIT_FAILURE);
-        }
+    if (x86ms->apic_id_limit > 255 && !xen_enabled() &&
+        !kvm_irqchip_in_kernel()) {
+        error_report("current -smp configuration requires kernel "
+                     "irqchip support.");
+        exit(EXIT_FAILURE);
     }
 }
=20
diff --git a/include/standard-headers/asm-x86/kvm_para.h b/include/standard=
-headers/asm-x86/kvm_para.h
index 07877d3295..215d01b4ec 100644
--- a/include/standard-headers/asm-x86/kvm_para.h
+++ b/include/standard-headers/asm-x86/kvm_para.h
@@ -32,6 +32,7 @@
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
 #define KVM_FEATURE_ASYNC_PF_INT	14
+#define KVM_FEATURE_MSI_EXT_DEST_ID	15
=20
 #define KVM_HINTS_REALTIME      0
=20
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index f37eb7b675..a93f50a6a7 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -799,7 +799,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS]=
 =3D {
             "kvmclock", "kvm-nopiodelay", "kvm-mmu", "kvmclock",
             "kvm-asyncpf", "kvm-steal-time", "kvm-pv-eoi", "kvm-pv-unhalt"=
,
             NULL, "kvm-pv-tlb-flush", NULL, "kvm-pv-ipi",
-            "kvm-poll-control", "kvm-pv-sched-yield", "kvm-asyncpf-int", N=
ULL,
+            "kvm-poll-control", "kvm-pv-sched-yield", "kvm-asyncpf-int", "=
kvm-msi-ext-dest-id",
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             "kvmclock-stable-bit", NULL, NULL, NULL,
@@ -4109,6 +4109,7 @@ static PropValue kvm_default_props[] =3D {
     { "kvm-pv-eoi", "on" },
     { "kvmclock-stable-bit", "on" },
     { "x2apic", "on" },
+    { "kvm-msi-ext-dest-id", "off" },
     { "acpi", "off" },
     { "monitor", "off" },
     { "svm", "off" },
@@ -5132,6 +5133,8 @@ static void x86_cpu_load_model(X86CPU *cpu, X86CPUMod=
el *model)
     if (kvm_enabled()) {
         if (!kvm_irqchip_in_kernel()) {
             x86_cpu_change_kvm_default("x2apic", "off");
+        } else if (kvm_irqchip_is_split() && kvm_enable_x2apic()) {
+            x86_cpu_change_kvm_default("kvm-msi-ext-dest-id", "on");
         }
=20
         x86_cpu_apply_props(cpu, kvm_default_props);
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index f6dae4cfb6..90952cae7c 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -420,6 +420,9 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint=
32_t function,
         if (!kvm_irqchip_in_kernel()) {
             ret &=3D ~(1U << KVM_FEATURE_PV_UNHALT);
         }
+        if (kvm_irqchip_is_split()) {
+            ret |=3D 1U << KVM_FEATURE_MSI_EXT_DEST_ID;
+        }
     } else if (function =3D=3D KVM_CPUID_FEATURES && reg =3D=3D R_EDX) {
         ret |=3D 1U << KVM_HINTS_REALTIME;
     }
@@ -4583,38 +4586,71 @@ int kvm_arch_irqchip_create(KVMState *s)
     }
 }
=20
+uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address)
+{
+        CPUX86State *env =3D &X86_CPU(first_cpu)->env;
+        uint64_t ext_id;
+
+        if (!first_cpu ||
+            !(env->features[FEAT_KVM] & (1 << KVM_FEATURE_MSI_EXT_DEST_ID)=
)) {
+            return address;
+        }
+
+        /*
+         * If the remappable format bit is set, or the upper bits are
+         * already set in address_hi, or the low extended bits aren't
+         * there anyway, do nothing.
+         */
+        ext_id =3D address & (0xff << MSI_ADDR_DEST_IDX_SHIFT);
+        if (!ext_id || (ext_id & (1 << MSI_ADDR_DEST_IDX_SHIFT)) ||
+            (address >> 32))
+            return address;
+
+        address &=3D ~ext_id;
+        address |=3D ext_id << 35;
+        return address;
+}
+
 int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
                              uint64_t address, uint32_t data, PCIDevice *d=
ev)
 {
     X86IOMMUState *iommu =3D x86_iommu_get_default();
=20
     if (iommu) {
-        int ret;
-        MSIMessage src, dst;
         X86IOMMUClass *class =3D X86_IOMMU_DEVICE_GET_CLASS(iommu);
=20
-        if (!class->int_remap) {
-            return 0;
-        }
+        if (class->int_remap) {
+            int ret;
+            MSIMessage src, dst;
=20
-        src.address =3D route->u.msi.address_hi;
-        src.address <<=3D VTD_MSI_ADDR_HI_SHIFT;
-        src.address |=3D route->u.msi.address_lo;
-        src.data =3D route->u.msi.data;
+            src.address =3D route->u.msi.address_hi;
+            src.address <<=3D VTD_MSI_ADDR_HI_SHIFT;
+            src.address |=3D route->u.msi.address_lo;
+            src.data =3D route->u.msi.data;
=20
-        ret =3D class->int_remap(iommu, &src, &dst, dev ? \
-                               pci_requester_id(dev) : \
-                               X86_IOMMU_SID_INVALID);
-        if (ret) {
-            trace_kvm_x86_fixup_msi_error(route->gsi);
-            return 1;
-        }
+            ret =3D class->int_remap(iommu, &src, &dst, dev ?     \
+                                   pci_requester_id(dev) :      \
+                                   X86_IOMMU_SID_INVALID);
+            if (ret) {
+                trace_kvm_x86_fixup_msi_error(route->gsi);
+                return 1;
+            }
+
+            /*
+             * Handled untranslated compatibilty format interrupt with
+             * extended destination ID in the low bits 11-5. */
+            dst.address =3D kvm_swizzle_msi_ext_dest_id(dst.address);
=20
-        route->u.msi.address_hi =3D dst.address >> VTD_MSI_ADDR_HI_SHIFT;
-        route->u.msi.address_lo =3D dst.address & VTD_MSI_ADDR_LO_MASK;
-        route->u.msi.data =3D dst.data;
+            route->u.msi.address_hi =3D dst.address >> VTD_MSI_ADDR_HI_SHI=
FT;
+            route->u.msi.address_lo =3D dst.address & VTD_MSI_ADDR_LO_MASK=
;
+            route->u.msi.data =3D dst.data;
+            return 0;
+        }
     }
=20
+    address =3D kvm_swizzle_msi_ext_dest_id(address);
+    route->u.msi.address_hi =3D address >> VTD_MSI_ADDR_HI_SHIFT;
+    route->u.msi.address_lo =3D address & VTD_MSI_ADDR_LO_MASK;
     return 0;
 }
=20
diff --git a/target/i386/kvm_i386.h b/target/i386/kvm_i386.h
index 0fce4e51d2..ede94760ae 100644
--- a/target/i386/kvm_i386.h
+++ b/target/i386/kvm_i386.h
@@ -49,4 +49,6 @@ bool kvm_has_waitpkg(void);
=20
 bool kvm_hv_vpindex_settable(void);
=20
+uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
+
 #endif


--=-zhygViik0d3u9bnnWDtk
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
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAx
MDA1MTQxODE5WjAvBgkqhkiG9w0BCQQxIgQg11i4AFiCXoDUcWGbrzT5y8MHgSEQy8SVGNYA4e0N
gcowgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAIflMTmNi2F9pqoghMu1LWyFzThiC7LVUrvCSq57lNfAw355tqR1HNfVIK88ku1D
nMC+1XOMb9OuPWdh0yRYFpruTbFaHi5w3DKrw/iImTuvcI/vlTQOH9/uiltBKFtbkZTWaB+dvm0T
O1YS3Kq3cSS0BB3GCKr7B4B3DOksppTQ9RbTYbm9YTuq3fqeSaAOYjftSL2ycVgo5LQPjSAtukBk
MLjjm3vtN/w84d3JbWmrwqQwNOuQXXsHMVxP/lh6N/sSN91VPhyMWXDE3plKzof0ie3zZ0jVu1ij
eAXDABgWA5496lTd+dhqVUUKZK42dONXJGuyQZFgr3378GVdlWQAAAAAAAA=


--=-zhygViik0d3u9bnnWDtk--

