Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539B72CEA86
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 10:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgLDJMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 04:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgLDJMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 04:12:14 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D05C061A4F
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 01:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rwD73xv1BxQiBy2g9od9iRiQskWTqOUNEcdlEWBPNF4=; b=zuh8E/IXrUyjjrlNZX33cTCZYb
        aBAa7S0QgY3msvTjXeArdmSRrp76jbKfxT0YMssxjMtNw9RDLZz2IzJ0hYHfRr3Jyur7BgouLvCNp
        OlLU/P28zVb4YM8Wy3J9LtV+myH66LMAFtrDUdYhkwRKa503Dkv6WdIDxlpFmKOLeyWyyqarG1Bn6
        8kUngoG/TVYXFX5aiSrjj9ZlCen5OnZR1VBGSHfkO1NBurqZ/BnnnLi6+sEOalIy3snZ5C0I3KtSD
        xZOi0s9DOxW4r7FUCnX0GPK+G6LExN8tY+MJVnxHRyntGr8Wo9LsZckMlaObbMNTce+662/pNAkEs
        8FZJIp7Q==;
Received: from 54-240-197-230.amazon.com ([54.240.197.230] helo=freeip.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kl77i-0003iA-9z; Fri, 04 Dec 2020 09:11:30 +0000
Message-ID: <72dad534cf158fe70c0f98ba72c4b9cf476c7b62.camel@infradead.org>
Subject: [PATCH 16/15]  KVM: Add documentation for Xen hypercall and
 shared_info updates
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Fri, 04 Dec 2020 09:11:27 +0000
In-Reply-To: <20201204011848.2967588-1-dwmw2@infradead.org>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-odan5JpmbIdqH3eajdJH"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-odan5JpmbIdqH3eajdJH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst | 119 +++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index e00a66d72372..d98c2ff90880 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -944,6 +944,13 @@ memory.
 	__u8 pad2[30];
   };
=20
+If the KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL flag is returned from the
+KVM_CAP_XEN_HVM check, it may be set in the flags field of this ioctl.
+This requests KVM to generate the contents of the hypercall page
+automatically, and also to intercept hypercalls with KVM_EXIT_XEN.
+In this case, all of the blob size and address fields must be zero.
+
+No other flags are currently valid.
=20
 4.29 KVM_GET_CLOCK
 ------------------
@@ -4807,6 +4814,67 @@ into user space.
 If a vCPU is in running state while this ioctl is invoked, the vCPU may
 experience inconsistent filtering behavior on MSR accesses.
=20
+4.127 KVM_XEN_HVM_SET_ATTR
+--------------------------
+
+:Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_xen_hvm_attr
+:Returns: 0 on success, < 0 on error
+
+::
+
+  struct kvm_xen_hvm_attr {
+	__u16 type;
+
+	union {
+		__u8 long_mode;
+		struct {
+			__u64 gfn;
+		} shared_info;
+		struct {
+			__u32 vcpu;
+			__u64 gpa;
+		} vcpu_attr;
+		__u64 pad[4];
+	} u;
+  };
+
+type values:
+
+KVM_XEN_ATTR_TYPE_LONG_MODE
+  Sets the ABI mode of the VM to 32-bit or 64-bit (long mode). This
+  determines the layout of the shared info pages exposed to the VM.
+
+KVM_XEN_ATTR_TYPE_SHARED_INFO
+  Sets the guest physical frame number at which the Xen "shared info"
+  page resides. It is the default location for the vcpu_info for the
+  first 32 vCPUs, and contains other VM-wide data structures shared
+  between the VM and the host.
+
+KVM_XEN_ATTR_TYPE_VCPU_INFO
+  Sets the guest physical address of the vcpu_info for a given vCPU.
+
+KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO
+  Sets the guest physical address of an additional pvclock structure
+  for a given vCPU. This is typically used for guest vsyscall support.
+
+KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE
+  Sets the guest physical address of the vcpu_runstate_info for a given
+  vCPU. This is how a Xen guest tracks CPU state such as steal time.
+
+4.128 KVM_XEN_HVM_GET_ATTR
+--------------------------
+
+:Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_xen_hvm_attr
+:Returns: 0 on success, < 0 on error
+
+Allows Xen VM attributes to be read. For the structure and types,
+see KVM_XEN_HVM_SET_ATTR above.
=20
 5. The kvm_run structure
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
@@ -5303,6 +5371,34 @@ wants to write. Once finished processing the event, =
user space must continue
 vCPU execution. If the MSR write was unsuccessful, user space also sets th=
e
 "error" field to "1".
=20
+::
+
+
+		struct kvm_xen_exit {
+  #define KVM_EXIT_XEN_HCALL          1
+			__u32 type;
+			union {
+				struct {
+					__u32 longmode;
+					__u32 cpl;
+					__u64 input;
+					__u64 result;
+					__u64 params[6];
+				} hcall;
+			} u;
+		};
+		/* KVM_EXIT_XEN */
+                struct kvm_hyperv_exit xen;
+
+Indicates that the VCPU exits into userspace to process some tasks
+related to Xen emulation.
+
+Valid values for 'type' are:
+
+  - KVM_EXIT_XEN_HCALL -- synchronously notify user-space about Xen hyperc=
all.
+    Userspace is expected to place the hypercall result into the appropria=
te
+    field before invoking KVM_RUN again.
+
 ::
=20
 		/* Fix the size of the union. */
@@ -6390,3 +6486,26 @@ When enabled, KVM will disable paravirtual features =
provided to the
 guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
 (0x40000001). Otherwise, a guest may use the paravirtual features
 regardless of what has actually been exposed through the CPUID leaf.
+
+8.29 KVM_CAP_XEN_HVM
+--------------------
+
+:Architectures: x86
+
+This capability indicates the features that Xen supports for hosting Xen
+PVHVM guests. Valid flags are::
+
+  #define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
+  #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+  #define KVM_XEN_HVM_CONFIG_SHARED_INFO	(1 << 2)
+
+The KVM_XEN_HVM_CONFIG_HYPERCALL_MSR flag indicates that the KVM_XEN_HVM_C=
ONFIG
+ioctl is available, for the guest to set its hypercall page.
+
+If KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL is also set, the same flag may also =
be
+provided in the flags to KVM_XEN_HVM_CONFIG, without providing hypercall p=
age
+contents, to request that KVM generate hypercall page content automaticall=
y
+and also enable interception of guest hypercalls with KVM_EXIT_XEN.
+
+The KVM_XEN_HVM_CONFIG_SHARED_INFO flag indicates the availability of the
+KVM_XEN_HVM_SET_ATTR and KVM_XEN_HVM_GET_ATTR ioctls.
--=20
2.17.1


--=-odan5JpmbIdqH3eajdJH
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
MjA0MDkxMTI3WjAvBgkqhkiG9w0BCQQxIgQg70F+aO17IZNBKLNiTQFgeo2h5w5O1wlnQhfkN3su
Ec0wgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBALAP/aIx6fI6uuQ/PczLuh7zTL6bo5MjIbxFILLjRo/uqOT+McKUaVrW4Jt94bq/
OgIbtmnKAhq/hPViA0ZoSY4NlcYxRBM6S7SFsTbPXxDhbpOa++pGr+nUsLX1n/e/4dzSHeAw5Wi/
9J8t3qzjCUJS6yGaVzo+I5b41T0kAfZQo15SQqbibEKln3+wy8t1TDEn/JJdghvRq7N11LPjfmfm
sddLugjQp7CjUivDNAHYWaHemLQPfG/2n4q5yIik6Xsh/koQJuWJn1CBL3bk0YBXjTyvmh7ijo31
5H1kU6n23BJDXlNBYm7DDgqxpvudEy7iBHLUSz9Ito9PCT9cS9gAAAAAAAA=


--=-odan5JpmbIdqH3eajdJH--

