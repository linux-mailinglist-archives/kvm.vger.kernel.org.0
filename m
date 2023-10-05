Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7AC7BAB5E
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 22:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjJEUTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 16:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjJEUTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 16:19:21 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052E195
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 13:19:19 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2bfed7c4e6dso16002051fa.1
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 13:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philjordan-eu.20230601.gappssmtp.com; s=20230601; t=1696537157; x=1697141957; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JBhwjUtmTsu54oLIUjL7IJbTy4WB5R85F1nTnZF+FHQ=;
        b=zo3Pf03AyIqIsc2LD+w+cdKDUfy3rJBJrZdTjEmVT17c9zswnbqTF28vfegqJSAY75
         2TOJN5ABTP37Q7raiu4QAYpateA9roJiOWYs/+xZn75fuspPXpBzIeJ6yTUPHV1BGfoS
         fl8Mt02Hj1n+nSB157nT7WpJOzrtPY2gFuSbtEBn0i6rRim0TPJbyNkFLZSsMwHZqSJ1
         eYESFKn0gUnTlD5oUD2N7YJMBkbOT8jYnnSgYXA5IXmA61682VUkeJs9QjsHz0st6s0N
         w5PgWu/yCyNJE3xCIzHW9LQrjb3sgVMfHyT/Jh175dY+VqnLnH8XXWwXkk8FrSPx5kPl
         LwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696537157; x=1697141957;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JBhwjUtmTsu54oLIUjL7IJbTy4WB5R85F1nTnZF+FHQ=;
        b=obNI5TewtI3c5xBr28Sdtbnc+0W1ezc2QB5UZrlMKPKJz5n3RUSynhfwAEQucnMxFQ
         /OLewj1H8pjuO77sUVsXpaA566WYA2TbNJCqwUFxhB0k/blyDyT4fJJxkut3m0Q5DzwH
         PhT4QKixCoVoH2E0qrnWEOqJiiRwzuB4gwcuCoVGGkIZJwN68M2lAjdLtIdWmfGHI+iY
         9V7Ts4Mrl5UyG/7SLzh1b5wOplAO3PZhWi2JrQxqktMhxFxRVVW60eysu/KFMY6eKrGK
         Y4UEvDkfK0/pau7XHYIeaCnY1nXYCnCVX3mqtfTDQS5ZgfPk0V+wJp7wCv4kFizsLTEx
         K3fQ==
X-Gm-Message-State: AOJu0YyOjoGlIThj//iYeJVk09K5LPaEeV8s01kpDVY3lqInS6GIVYAK
        xSIfypN2vRjAmVOnF43ChOh2NVqPeh7fFrMAofzG+IXxWXAZkOVH24UGmA==
X-Google-Smtp-Source: AGHT+IEmX7Y1bZ91pWbbNgnFPLS5F2K89S5VZcXzICyAUUxRbjFhh9gTsq2dQXpwTYZOsFszMC96WVW7Tg71dzRZCnE=
X-Received: by 2002:a19:7903:0:b0:503:1775:fc1 with SMTP id
 u3-20020a197903000000b0050317750fc1mr4786597lfc.31.1696537157077; Thu, 05 Oct
 2023 13:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230923102019.29444-1-phil@philjordan.eu> <ZRGkqY+2QQgt2cVq@google.com>
 <CAGCz3vve7RJ+HE8sHOvq1p5-Wc4RpgZwqp0DiCXiSWq0vUpEVw@mail.gmail.com>
 <ZRMB9HUIBcWWHtwK@google.com> <CAGCz3vuieUoD0UombFzxKYygm8uS4Gr=qkUAKR7oR0Tg+mEnYQ@mail.gmail.com>
 <ZRQ5r0kn5RzDpf0C@google.com>
In-Reply-To: <ZRQ5r0kn5RzDpf0C@google.com>
From:   Phil Dennis-Jordan <lists@philjordan.eu>
Date:   Thu, 5 Oct 2023 22:19:05 +0200
Message-ID: <CAGCz3vsQ9hUkgX5dyy9er8y4_y1rM2eWrfLHkWV0xv6aJwNzeQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86/apic: Gates test_pv_ipi on KVM cpuid,
 not test device
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: multipart/mixed; boundary="00000000000098b7970606fdd6db"
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NEUTRAL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--00000000000098b7970606fdd6db
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 27, 2023 at 4:18=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> Gah, sorry.  This is why I usually inline patches, I forget to actually a=
tt=3D
> ach
> the darn things 50% of the time.

Thanks for that, and apologies for only just getting around to taking
a closer look. Out of the box, this doesn't build on macOS at least,
as that's missing <linux/types.h>. I tried going down the rabbit hole
of pulling that header and its various transitive dependencies in from
the Linux tree, but ended up in a horrible mess where those headers
try to define things like bool, which libcflat has already pulled in
from the standard system headers (on Linux I suspect the libc #include
guards match up with the stuff in <linux/*>, so there's no issue).
On macOS, the problem is easy to resolve via a cut-down types.h with a
minimal set of definitions:

#include <libcflat.h>
typedef u8  __u8;
typedef u32 __u32;
typedef u64 __u64;
typedef s64 __s64;

=E2=80=A6but I assume that breaks things on Linux. I'm thinking something l=
ike
this might work:

#if __LINUX__
#include_next <linux/types.h>
#else
[minimal types.h definitions]
#endif

But I'm unsure if that's really the direction you'd want to go with
this? (And I still need to set myself up with a dev environment on a
physical Linux box that I can test this all on.)

Another option might be a symlinked linux/types.h created by
./configure if not running on Linux?


On the substance of the patch itself:

>         unsigned long a0 =3D 0xFFFFFFFF, a1 =3D 0, a2 =3D 0xFFFFFFFF, a3 =
=3D 0x0;
> -       if (!test_device_enabled())
> +       if (!this_cpu_has(X86_FEATURE_KVM_PV_SEND_IPI))

So this check will (erroneously IMO) succeed if we're running on a
non-KVM hypervisor which happens to expose a flag at bit 11 of ecx on
CPUID leaf 0x40000001 page 0, right? With this in mind, your earlier
idea seems better:

        if (!is_hypervisor_kvm() ||
!this_cpu_has(X86_FEATURE_KVM_PV_SEND_IPI)) {

So I've gone ahead and made an attempt at fixing up your draft
implementation of is_hypervisor_kvm() below.

The partial struct memcmp in get_hypervisor_cpuid_base is a bit icky;
I'm not sure if that's worth fixing up at the cost of readability.


Thoughts?

(I've attached the full set of WIP changes on top of yours as another
patch. Feel free to squash it all into one if you decide to run with
it.)

Thanks,
Phil


diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 7a7048f9..3d3930c8 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -240,6 +240,7 @@ static inline bool is_intel(void)
 #define    X86_FEATURE_XSAVE        (CPUID(0x1, 0, ECX, 26))
 #define    X86_FEATURE_OSXSAVE        (CPUID(0x1, 0, ECX, 27))
 #define    X86_FEATURE_RDRAND        (CPUID(0x1, 0, ECX, 30))
+#define    X86_FEATURE_HYPERVISOR        (CPUID(0x1, 0, ECX, 31))
 #define    X86_FEATURE_MCE            (CPUID(0x1, 0, EDX, 7))
 #define    X86_FEATURE_APIC        (CPUID(0x1, 0, EDX, 9))
 #define    X86_FEATURE_CLFLUSH        (CPUID(0x1, 0, EDX, 19))
@@ -286,7 +287,8 @@ static inline bool is_intel(void)
 #define X86_FEATURE_VNMI        (CPUID(0x8000000A, 0, EDX, 25))
 #define    X86_FEATURE_AMD_PMU_V2        (CPUID(0x80000022, 0, EAX, 0))

-#define X86_FEATURE_KVM_PV_SEND_IPI    (CPUID(KVM_CPUID_FEATURES, 0,
EAX, KVM_FEATURE_PV_SEND_IPI))
+#define X86_FEATURE_KVM_PV_SEND_IPI \
+    (CPUID(KVM_CPUID_FEATURES, 0, EAX, KVM_FEATURE_PV_SEND_IPI))

 static inline bool this_cpu_has(u64 feature)
 {
@@ -303,6 +305,40 @@ static inline bool this_cpu_has(u64 feature)
     return ((*(tmp + (output_reg % 32))) & (1 << bit));
 }

+static inline u32 get_hypervisor_cpuid_base(const char *sig)
+{
+    u32 base;
+    struct cpuid signature;
+
+    if (!this_cpu_has(X86_FEATURE_HYPERVISOR))
+        return 0;
+
+    for (base =3D 0x40000000; base < 0x40010000; base +=3D 0x100) {
+        signature =3D cpuid(base);
+
+        if (!memcmp(sig, &signature.b, 12))
+            return base;
+    }
+
+    return 0;
+}
+
+static inline bool is_hypervisor_kvm(void)
+{
+    u32 base =3D get_hypervisor_cpuid_base(KVM_SIGNATURE);
+
+    if (!base)
+        return false;
+
+    /*
+     * Require that KVM be placed at its default base so that macros can b=
e
+     * used to query individual KVM feature bits.
+     */
+    assert_msg(base =3D=3D KVM_CPUID_SIGNATURE,
+           "Expect KVM at its default cpuid base (now at: 0x%x)", base);
+    return true;
+}
+
 struct far_pointer32 {
     u32 offset;
     u16 selector;

--00000000000098b7970606fdd6db
Content-Type: application/octet-stream; 
	name="0002-x86-apic-test_pv_ipi-cpuid-check-refinements.patch"
Content-Disposition: attachment; 
	filename="0002-x86-apic-test_pv_ipi-cpuid-check-refinements.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lndm1cgf0>
X-Attachment-Id: f_lndm1cgf0

RnJvbSAxNGJmMTlmM2RkYTJlZGQyMjU1YmEzODc3YWY3MjU5OTc0ZThhOThiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQaGlsIERlbm5pcy1Kb3JkYW4gPHBoaWxAcGhpbGpvcmRhbi5l
dT4KRGF0ZTogVGh1LCA1IE9jdCAyMDIzIDIxOjQ5OjQ4ICswMjAwClN1YmplY3Q6IFtrdm0tdW5p
dC10ZXN0cyBQQVRDSCAyLzRdIHg4Ni9hcGljOiB0ZXN0X3B2X2lwaSBjcHVpZCBjaGVjawogcmVm
aW5lbWVudHMKTUlNRS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFy
c2V0PVVURi04CkNvbnRlbnQtVHJhbnNmZXItRW5jb2Rpbmc6IDhiaXQKCkJlZm9yZSBjaGVja2lu
ZyBmb3IgdGhlIEtWTSBJUEkgaHlwZXJjYWxsIENQVUlEIGZsYWcsIHRlc3RzIHRoYXQgd2XigJly
ZQphY3R1YWxseSBvbiBLVk0sIG9yIHRoZSBmbGFnIG1pZ2h0IG1lYW4gYW55dGhpbmcuCgpBbHNv
IGZpeGVzIGJ1aWxkIG9uIG5vbi1MaW51eCBtYWNoaW5lcyBieSBhZGRpbmcgbWluaW1hbCA8bGlu
dXgvdHlwZXMuaD4KClNpZ25lZC1vZmYtYnk6IFBoaWwgRGVubmlzLUpvcmRhbiA8cGhpbEBwaGls
am9yZGFuLmV1PgotLS0KIGxpYi9saW51eC90eXBlcy5oICAgfCAxNSArKysrKysrKysrKysrKysK
IGxpYi94ODYvcHJvY2Vzc29yLmggfCAzOCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrLQogeDg2L2FwaWMuYyAgICAgICAgICB8ICA0ICsrKy0KIDMgZmlsZXMgY2hhbmdlZCwg
NTUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0NCBsaWIv
bGludXgvdHlwZXMuaAoKZGlmZiAtLWdpdCBhL2xpYi9saW51eC90eXBlcy5oIGIvbGliL2xpbnV4
L3R5cGVzLmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAuLmY4NmNkNzFhCi0t
LSAvZGV2L251bGwKKysrIGIvbGliL2xpbnV4L3R5cGVzLmgKQEAgLTAsMCArMSwxNSBAQAorI2lm
bmRlZiBfTElCX0xJTlVYX1RZUEVTX0hfCisjaWZkZWYgX19saW51eF9fCisvKiBPbiBMaW51eCwg
dXNlIHRoZSByZWFsIHRoaW5nICovCisjaW5jbHVkZV9uZXh0IDxsaW51eC90eXBlcy5oPgorCisj
ZWxzZSAvKiAhZGVmaW5lZChfX2xpbnV4X18pICovCisvKiBUaGlzIGlzICpqdXN0KiBlbm91Z2gg
Zm9yIHRoZSBoZWFkZXJzIHdlJ3ZlIHB1bGxlZCBpbiBmcm9tIExpbnV4IHRvIGNvbXBpbGUgKi8K
KyNpbmNsdWRlIDxsaWJjZmxhdC5oPgordHlwZWRlZiB1OCAgX191ODsKK3R5cGVkZWYgdTMyIF9f
dTMyOwordHlwZWRlZiB1NjQgX191NjQ7Cit0eXBlZGVmIHM2NCBfX3M2NDsKKyNlbmRpZgorCisj
ZW5kaWYKZGlmZiAtLWdpdCBhL2xpYi94ODYvcHJvY2Vzc29yLmggYi9saWIveDg2L3Byb2Nlc3Nv
ci5oCmluZGV4IDdhNzA0OGY5Li4zZDM5MzBjOCAxMDA2NDQKLS0tIGEvbGliL3g4Ni9wcm9jZXNz
b3IuaAorKysgYi9saWIveDg2L3Byb2Nlc3Nvci5oCkBAIC0yNDAsNiArMjQwLDcgQEAgc3RhdGlj
IGlubGluZSBib29sIGlzX2ludGVsKHZvaWQpCiAjZGVmaW5lCVg4Nl9GRUFUVVJFX1hTQVZFCQko
Q1BVSUQoMHgxLCAwLCBFQ1gsIDI2KSkKICNkZWZpbmUJWDg2X0ZFQVRVUkVfT1NYU0FWRQkJKENQ
VUlEKDB4MSwgMCwgRUNYLCAyNykpCiAjZGVmaW5lCVg4Nl9GRUFUVVJFX1JEUkFORAkJKENQVUlE
KDB4MSwgMCwgRUNYLCAzMCkpCisjZGVmaW5lCVg4Nl9GRUFUVVJFX0hZUEVSVklTT1IJCShDUFVJ
RCgweDEsIDAsIEVDWCwgMzEpKQogI2RlZmluZQlYODZfRkVBVFVSRV9NQ0UJCQkoQ1BVSUQoMHgx
LCAwLCBFRFgsIDcpKQogI2RlZmluZQlYODZfRkVBVFVSRV9BUElDCQkoQ1BVSUQoMHgxLCAwLCBF
RFgsIDkpKQogI2RlZmluZQlYODZfRkVBVFVSRV9DTEZMVVNICQkoQ1BVSUQoMHgxLCAwLCBFRFgs
IDE5KSkKQEAgLTI4Niw3ICsyODcsOCBAQCBzdGF0aWMgaW5saW5lIGJvb2wgaXNfaW50ZWwodm9p
ZCkKICNkZWZpbmUgWDg2X0ZFQVRVUkVfVk5NSQkJKENQVUlEKDB4ODAwMDAwMEEsIDAsIEVEWCwg
MjUpKQogI2RlZmluZQlYODZfRkVBVFVSRV9BTURfUE1VX1YyCQkoQ1BVSUQoMHg4MDAwMDAyMiwg
MCwgRUFYLCAwKSkKIAotI2RlZmluZSBYODZfRkVBVFVSRV9LVk1fUFZfU0VORF9JUEkJKENQVUlE
KEtWTV9DUFVJRF9GRUFUVVJFUywgMCwgRUFYLCBLVk1fRkVBVFVSRV9QVl9TRU5EX0lQSSkpCisj
ZGVmaW5lIFg4Nl9GRUFUVVJFX0tWTV9QVl9TRU5EX0lQSSBcCisJKENQVUlEKEtWTV9DUFVJRF9G
RUFUVVJFUywgMCwgRUFYLCBLVk1fRkVBVFVSRV9QVl9TRU5EX0lQSSkpCiAKIHN0YXRpYyBpbmxp
bmUgYm9vbCB0aGlzX2NwdV9oYXModTY0IGZlYXR1cmUpCiB7CkBAIC0zMDMsNiArMzA1LDQwIEBA
IHN0YXRpYyBpbmxpbmUgYm9vbCB0aGlzX2NwdV9oYXModTY0IGZlYXR1cmUpCiAJcmV0dXJuICgo
Kih0bXAgKyAob3V0cHV0X3JlZyAlIDMyKSkpICYgKDEgPDwgYml0KSk7CiB9CiAKK3N0YXRpYyBp
bmxpbmUgdTMyIGdldF9oeXBlcnZpc29yX2NwdWlkX2Jhc2UoY29uc3QgY2hhciAqc2lnKQorewor
CXUzMiBiYXNlOworCXN0cnVjdCBjcHVpZCBzaWduYXR1cmU7CisKKwlpZiAoIXRoaXNfY3B1X2hh
cyhYODZfRkVBVFVSRV9IWVBFUlZJU09SKSkKKwkJcmV0dXJuIDA7CisKKwlmb3IgKGJhc2UgPSAw
eDQwMDAwMDAwOyBiYXNlIDwgMHg0MDAxMDAwMDsgYmFzZSArPSAweDEwMCkgeworCQlzaWduYXR1
cmUgPSBjcHVpZChiYXNlKTsKKworCQlpZiAoIW1lbWNtcChzaWcsICZzaWduYXR1cmUuYiwgMTIp
KQorCQkJcmV0dXJuIGJhc2U7CisJfQorCisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbmxpbmUg
Ym9vbCBpc19oeXBlcnZpc29yX2t2bSh2b2lkKQoreworCXUzMiBiYXNlID0gZ2V0X2h5cGVydmlz
b3JfY3B1aWRfYmFzZShLVk1fU0lHTkFUVVJFKTsKKworCWlmICghYmFzZSkKKwkJcmV0dXJuIGZh
bHNlOworCisJLyoKKwkgKiBSZXF1aXJlIHRoYXQgS1ZNIGJlIHBsYWNlZCBhdCBpdHMgZGVmYXVs
dCBiYXNlIHNvIHRoYXQgbWFjcm9zIGNhbiBiZQorCSAqIHVzZWQgdG8gcXVlcnkgaW5kaXZpZHVh
bCBLVk0gZmVhdHVyZSBiaXRzLgorCSAqLworCWFzc2VydF9tc2coYmFzZSA9PSBLVk1fQ1BVSURf
U0lHTkFUVVJFLAorCQkgICAiRXhwZWN0IEtWTSBhdCBpdHMgZGVmYXVsdCBjcHVpZCBiYXNlIChu
b3cgYXQ6IDB4JXgpIiwgYmFzZSk7CisJcmV0dXJuIHRydWU7Cit9CisKIHN0cnVjdCBmYXJfcG9p
bnRlcjMyIHsKIAl1MzIgb2Zmc2V0OwogCXUxNiBzZWxlY3RvcjsKZGlmZiAtLWdpdCBhL3g4Ni9h
cGljLmMgYi94ODYvYXBpYy5jCmluZGV4IDYxMzM0NTQzLi43ODNmYjc0MCAxMDA2NDQKLS0tIGEv
eDg2L2FwaWMuYworKysgYi94ODYvYXBpYy5jCkBAIC02NTgsOCArNjU4LDEwIEBAIHN0YXRpYyB2
b2lkIHRlc3RfcHZfaXBpKHZvaWQpCiAJaW50IHJldDsKIAl1bnNpZ25lZCBsb25nIGEwID0gMHhG
RkZGRkZGRiwgYTEgPSAwLCBhMiA9IDB4RkZGRkZGRkYsIGEzID0gMHgwOwogCi0JaWYgKCF0aGlz
X2NwdV9oYXMoWDg2X0ZFQVRVUkVfS1ZNX1BWX1NFTkRfSVBJKSkKKwlpZiAoIWlzX2h5cGVydmlz
b3Jfa3ZtKCkgfHwgIXRoaXNfY3B1X2hhcyhYODZfRkVBVFVSRV9LVk1fUFZfU0VORF9JUEkpKSB7
CisJCXJlcG9ydF9za2lwKCJQViBJUElzIHRlc3RpbmciKTsKIAkJcmV0dXJuOworCX0KIAogCWFz
bSB2b2xhdGlsZSgidm1jYWxsIiA6ICI9YSIocmV0KSA6ImEiKEtWTV9IQ19TRU5EX0lQSSksICJi
IihhMCksICJjIihhMSksICJkIihhMiksICJTIihhMykpOwogCXJlcG9ydCghcmV0LCAiUFYgSVBJ
cyB0ZXN0aW5nIik7Ci0tIAoyLjM2LjEKCg==
--00000000000098b7970606fdd6db--
