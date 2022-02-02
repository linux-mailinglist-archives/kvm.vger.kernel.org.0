Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61264A715B
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 14:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344293AbiBBNQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 08:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbiBBNQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 08:16:12 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69956C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 05:16:12 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id h16so18835911qvk.10
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 05:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=79vq9TCxjR7x3uf5Z4nTfapSge2v9FIO7LTSjxZhZB4=;
        b=QDHix+y/nSaLBBh8IYeYTNNuufCKmJvJIhDP7dv8D+/PO/8ZtBffJvjZkDhexp77dD
         OrvGHZWhTFEzMMsF6HA3e4RNMx8n+RpyNPdXn8dbdJhyr6qOWJYS1Favw0ge1jR7QPrG
         kGOdZ41p76og/ctAY26ziOaU6dXln0Zi54h5pVWcAuIhyBqvLa00KseLmdOvZtkP3nYH
         UD/qF2QCRdgZyaZZ97TNQIr9HyXRU40C2Wqf8NZ259l+1vIW9DDzmTVdvmJD9Q5gPCwX
         st/15sx9OX8bZn0wgOmrbx9i4N+Or+vfl+Wu3NU35qwhUiu2LC0axBxEJRJvRAwyfkRw
         QxyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=79vq9TCxjR7x3uf5Z4nTfapSge2v9FIO7LTSjxZhZB4=;
        b=h/Qv9OqPNB2h4m1lSGD1sdvRCQmjZKX60/rbKlcliF9+YMAi5W+UNG6rMp15CBEwJF
         M1apLQSusorjsvEXzuHZEmFHPVhSjMKI7EMyz+2UNkuOf6WN1UZvNuga1qGS/FjxWZgY
         nYYJtRellBXfTK/VDHkxwgKaeHzkrmq8nsSP3l+qck9pQ7r71TK8CjbSzFOpx+BCqB5A
         J4Cl4wAQDaJjR51pdnrtURw0tVl7gBU+GzcdQ8uxCrF65zDkP4aEXIN/Kla8qY64VmuX
         oMOJHA7cMzIBkPBFy3qeOTWn0K4YYLaYF1ajFFwIGqC2QlqsH1K5A+XBtyPVGzxtAtmW
         hzog==
X-Gm-Message-State: AOAM533foLcjQbyfHSCavMzlGe1KlzC10u6etIcurCi77oKdcN4zUuLQ
        20FsBJIA9ynvSx8QSehBUi1dzkJny3+mpe8kz+GnAwNZcjfoWg==
X-Google-Smtp-Source: ABdhPJwQrVW/eHXLU/tinP93jW39NySGosYXY6Qj8WY2B67cKscAR9BA9nPxclvoiD5jA8UBJ3CtD5UAfOQDMBp6HTA=
X-Received: by 2002:a05:6214:21e4:: with SMTP id p4mr27327792qvj.31.1643807771168;
 Wed, 02 Feb 2022 05:16:11 -0800 (PST)
MIME-Version: 1.0
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Wed, 2 Feb 2022 14:15:59 +0100
Message-ID: <CAFULd4bQa-EkiTc06VysryKRb+zXBTRZFPkEJe7wCUu3RyON+g@mail.gmail.com>
Subject: [RFC/RFT PATCH] Introduce try_cmpxchg64 and use it in vmx/posted_intr.c
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: multipart/mixed; boundary="00000000000047c74f05d708d21d"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--00000000000047c74f05d708d21d
Content-Type: text/plain; charset="UTF-8"

Hello!

Attached RFC patch introduces try_cmpxchg64 and uses it in
vmx/posted_intr.c. While the resulting code improvements on x86_64 are
somehow minor (a compare and a move saved), the improvements on x86_32
are quite noticeable. The code around cmpxchg8b improves from:

  84:    89 74 24 30              mov    %esi,0x30(%esp)
  88:    89 fe                    mov    %edi,%esi
  8a:    0f b7 0c 02              movzwl (%edx,%eax,1),%ecx
  8e:    c1 e1 08                 shl    $0x8,%ecx
  91:    0f b7 c9                 movzwl %cx,%ecx
  94:    89 4c 24 34              mov    %ecx,0x34(%esp)
  98:    8b 96 24 1e 00 00        mov    0x1e24(%esi),%edx
  9e:    8b 86 20 1e 00 00        mov    0x1e20(%esi),%eax
  a4:    8b 5c 24 34              mov    0x34(%esp),%ebx
  a8:    8b 7c 24 30              mov    0x30(%esp),%edi
  ac:    89 44 24 38              mov    %eax,0x38(%esp)
  b0:    0f b6 44 24 38           movzbl 0x38(%esp),%eax
  b5:    8b 4c 24 38              mov    0x38(%esp),%ecx
  b9:    89 54 24 3c              mov    %edx,0x3c(%esp)
  bd:    83 e0 fd                 and    $0xfffffffd,%eax
  c0:    89 5c 24 64              mov    %ebx,0x64(%esp)
  c4:    8b 54 24 3c              mov    0x3c(%esp),%edx
  c8:    89 4c 24 60              mov    %ecx,0x60(%esp)
  cc:    8b 4c 24 34              mov    0x34(%esp),%ecx
  d0:    88 44 24 60              mov    %al,0x60(%esp)
  d4:    8b 44 24 38              mov    0x38(%esp),%eax
  d8:    c6 44 24 62 f2           movb   $0xf2,0x62(%esp)
  dd:    8b 5c 24 60              mov    0x60(%esp),%ebx
  e1:    f0 0f c7 0f              lock cmpxchg8b (%edi)
  e5:    89 d1                    mov    %edx,%ecx
  e7:    8b 54 24 3c              mov    0x3c(%esp),%edx
  eb:    33 44 24 38              xor    0x38(%esp),%eax
  ef:    31 ca                    xor    %ecx,%edx
  f1:    09 c2                    or     %eax,%edx
  f3:    75 a3                    jne    98 <vmx_vcpu_pi_load+0x98>

to:

  84:    0f b7 0c 02              movzwl (%edx,%eax,1),%ecx
  88:    c1 e1 08                 shl    $0x8,%ecx
  8b:    0f b7 c9                 movzwl %cx,%ecx
  8e:    8b 86 20 1e 00 00        mov    0x1e20(%esi),%eax
  94:    8b 96 24 1e 00 00        mov    0x1e24(%esi),%edx
  9a:    89 4c 24 64              mov    %ecx,0x64(%esp)
  9e:    89 c3                    mov    %eax,%ebx
  a0:    89 44 24 60              mov    %eax,0x60(%esp)
  a4:    83 e3 fd                 and    $0xfffffffd,%ebx
  a7:    c6 44 24 62 f2           movb   $0xf2,0x62(%esp)
  ac:    88 5c 24 60              mov    %bl,0x60(%esp)
  b0:    8b 5c 24 60              mov    0x60(%esp),%ebx
  b4:    f0 0f c7 0f              lock cmpxchg8b (%edi)
  b8:    75 d4                    jne    8e <vmx_vcpu_pi_load+0x8e>

The patch was only lightly tested, so I would like to ask someone to
spare a few cycles for a thorough test on 64bit and 32bit targets. As
shown above, the try_cmpxchg64 functions should be generally usable
for x86 targets, I plan to propose a patch that introduces these to
x86 maintainers.

Uros.

--00000000000047c74f05d708d21d
Content-Type: text/plain; charset="US-ASCII"; name="try_cmpxchg-4.diff.txt"
Content-Disposition: attachment; filename="try_cmpxchg-4.diff.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_kz5kozo40>
X-Attachment-Id: f_kz5kozo40

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2NtcHhjaGdfMzIuaCBiL2FyY2gveDg2
L2luY2x1ZGUvYXNtL2NtcHhjaGdfMzIuaAppbmRleCAwYTdmZTAzMjE2MTMuLmU4NzRmZjdmNzUy
OSAxMDA2NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY21weGNoZ18zMi5oCisrKyBiL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL2NtcHhjaGdfMzIuaApAQCAtNDIsNiArNDIsOSBAQCBzdGF0aWMg
aW5saW5lIHZvaWQgc2V0XzY0Yml0KHZvbGF0aWxlIHU2NCAqcHRyLCB1NjQgdmFsdWUpCiAjZGVm
aW5lIGFyY2hfY21weGNoZzY0X2xvY2FsKHB0ciwgbywgbikJCQkJCVwKIAkoKF9fdHlwZW9mX18o
KihwdHIpKSlfX2NtcHhjaGc2NF9sb2NhbCgocHRyKSwgKHVuc2lnbmVkIGxvbmcgbG9uZykobyks
IFwKIAkJCQkJICAgICAgICh1bnNpZ25lZCBsb25nIGxvbmcpKG4pKSkKKyNkZWZpbmUgYXJjaF90
cnlfY21weGNoZzY0KHB0ciwgcG8sIG4pCQkJCQlcCisJKChfX3R5cGVvZl9fKCoocHRyKSkpX190
cnlfY21weGNoZzY0KChwdHIpLCAodW5zaWduZWQgbG9uZyBsb25nICopKHBvKSwgXAorCQkJCQkg
ICAgICh1bnNpZ25lZCBsb25nIGxvbmcpKG4pKSkKICNlbmRpZgogCiBzdGF0aWMgaW5saW5lIHU2
NCBfX2NtcHhjaGc2NCh2b2xhdGlsZSB1NjQgKnB0ciwgdTY0IG9sZCwgdTY0IG5ldykKQEAgLTcw
LDYgKzczLDI1IEBAIHN0YXRpYyBpbmxpbmUgdTY0IF9fY21weGNoZzY0X2xvY2FsKHZvbGF0aWxl
IHU2NCAqcHRyLCB1NjQgb2xkLCB1NjQgbmV3KQogCXJldHVybiBwcmV2OwogfQogCitzdGF0aWMg
aW5saW5lIGJvb2wgX190cnlfY21weGNoZzY0KHZvbGF0aWxlIHU2NCAqcHRyLCB1NjQgKnBvbGQs
IHU2NCBuZXcpCit7CisJYm9vbCBzdWNjZXNzOworCXU2NCBwcmV2OworCWFzbSB2b2xhdGlsZShM
T0NLX1BSRUZJWCAiY21weGNoZzhiICUyIgorCQkgICAgIENDX1NFVCh6KQorCQkgICAgIDogQ0Nf
T1VUKHopIChzdWNjZXNzKSwKKwkJICAgICAgICI9QSIgKHByZXYpLAorCQkgICAgICAgIittIiAo
KnB0cikKKwkJICAgICA6ICJiIiAoKHUzMiluZXcpLAorCQkgICAgICAgImMiICgodTMyKShuZXcg
Pj4gMzIpKSwKKwkJICAgICAgICIxIiAoKnBvbGQpCisJCSAgICAgOiAibWVtb3J5Iik7CisKKwlp
ZiAodW5saWtlbHkoIXN1Y2Nlc3MpKQorCQkqcG9sZCA9IHByZXY7CisJcmV0dXJuIHN1Y2Nlc3M7
Cit9CisKICNpZm5kZWYgQ09ORklHX1g4Nl9DTVBYQ0hHNjQKIC8qCiAgKiBCdWlsZGluZyBhIGtl
cm5lbCBjYXBhYmxlIHJ1bm5pbmcgb24gODAzODYgYW5kIDgwNDg2LiBJdCBtYXkgYmUgbmVjZXNz
YXJ5CkBAIC0xMDgsNiArMTMwLDI3IEBAIHN0YXRpYyBpbmxpbmUgdTY0IF9fY21weGNoZzY0X2xv
Y2FsKHZvbGF0aWxlIHU2NCAqcHRyLCB1NjQgb2xkLCB1NjQgbmV3KQogCQkgICAgICAgOiAibWVt
b3J5Iik7CQkJCVwKIAlfX3JldDsgfSkKIAorI2RlZmluZSBhcmNoX3RyeV9jbXB4Y2hnNjQocHRy
LCBwbywgbikJCQkJXAorKHsJCQkJCQkJCVwKKwlib29sIHN1Y2Nlc3M7CQkJCQkJXAorCV9fdHlw
ZW9mX18oKihwdHIpKSBfX3ByZXY7CQkJCVwKKwlfX3R5cGVvZl9fKHB0cikgX29sZCA9IChfX3R5
cGVvZl9fKHB0cikpKHBvKTsJCVwKKwlfX3R5cGVvZl9fKCoocHRyKSkgX19vbGQgPSAqX29sZDsJ
CQlcCisJX190eXBlb2ZfXygqKHB0cikpIF9fbmV3ID0gKG4pOwkJCQlcCisJYWx0ZXJuYXRpdmVf
aW8oTE9DS19QUkVGSVhfSEVSRQkJCQlcCisJCQkiY2FsbCBjbXB4Y2hnOGJfZW11IiwJCQlcCisJ
CQkibG9jazsgY21weGNoZzhiICglJWVzaSkiICwJCVwKKwkJICAgICAgIFg4Nl9GRUFUVVJFX0NY
OCwJCQkJXAorCQkgICAgICAgIj1BIiAoX19wcmV2KSwJCQkJXAorCQkgICAgICAgIlMiICgocHRy
KSksICIwIiAoX19vbGQpLAkJXAorCQkgICAgICAgImIiICgodW5zaWduZWQgaW50KV9fbmV3KSwJ
CVwKKwkJICAgICAgICJjIiAoKHVuc2lnbmVkIGludCkoX19uZXc+PjMyKSkJCVwKKwkJICAgICAg
IDogIm1lbW9yeSIpOwkJCQlcCisJc3VjY2VzcyA9IChfX3ByZXYgPT0gX19vbGQpOwkJCQlcCisJ
aWYgKHVubGlrZWx5KCFzdWNjZXNzKSkJCQkJCVwKKwkJKl9vbGQgPSBfX3ByZXY7CQkJCQlcCisJ
bGlrZWx5KHN1Y2Nlc3MpOwkJCQkJXAorfSkKICNlbmRpZgogCiAjZGVmaW5lIHN5c3RlbV9oYXNf
Y21weGNoZ19kb3VibGUoKSBib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfQ1g4KQpkaWZmIC0tZ2l0
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY21weGNoZ182NC5oIGIvYXJjaC94ODYvaW5jbHVkZS9h
c20vY21weGNoZ182NC5oCmluZGV4IDA3MmU1NDU5ZmUyZi4uMjUwMTg3YWM4MjQ4IDEwMDY0NAot
LS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jbXB4Y2hnXzY0LmgKKysrIGIvYXJjaC94ODYvaW5j
bHVkZS9hc20vY21weGNoZ182NC5oCkBAIC0xOSw2ICsxOSwxMiBAQCBzdGF0aWMgaW5saW5lIHZv
aWQgc2V0XzY0Yml0KHZvbGF0aWxlIHU2NCAqcHRyLCB1NjQgdmFsKQogCWFyY2hfY21weGNoZ19s
b2NhbCgocHRyKSwgKG8pLCAobikpOwkJCQlcCiB9KQogCisjZGVmaW5lIGFyY2hfdHJ5X2NtcHhj
aGc2NChwdHIsIHBvLCBuKQkJCQkJXAorKHsJCQkJCQkJCQlcCisJQlVJTERfQlVHX09OKHNpemVv
ZigqKHB0cikpICE9IDgpOwkJCQlcCisJYXJjaF90cnlfY21weGNoZygocHRyKSwgKHBvKSwgKG4p
KTsJCQkJXAorfSkKKwogI2RlZmluZSBzeXN0ZW1faGFzX2NtcHhjaGdfZG91YmxlKCkgYm9vdF9j
cHVfaGFzKFg4Nl9GRUFUVVJFX0NYMTYpCiAKICNlbmRpZiAvKiBfQVNNX1g4Nl9DTVBYQ0hHXzY0
X0ggKi8KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvcG9zdGVkX2ludHIuYyBiL2FyY2gv
eDg2L2t2bS92bXgvcG9zdGVkX2ludHIuYwppbmRleCBhYTFmZTkwODVkNzcuLjVjZTE4NWNhYTky
YyAxMDA2NDQKLS0tIGEvYXJjaC94ODYva3ZtL3ZteC9wb3N0ZWRfaW50ci5jCisrKyBiL2FyY2gv
eDg2L2t2bS92bXgvcG9zdGVkX2ludHIuYwpAQCAtMzQsNyArMzQsNyBAQCBzdGF0aWMgaW5saW5l
IHN0cnVjdCBwaV9kZXNjICp2Y3B1X3RvX3BpX2Rlc2Moc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQog
CXJldHVybiAmKHRvX3ZteCh2Y3B1KS0+cGlfZGVzYyk7CiB9CiAKLXN0YXRpYyBpbnQgcGlfdHJ5
X3NldF9jb250cm9sKHN0cnVjdCBwaV9kZXNjICpwaV9kZXNjLCB1NjQgb2xkLCB1NjQgbmV3KQor
c3RhdGljIGludCBwaV90cnlfc2V0X2NvbnRyb2woc3RydWN0IHBpX2Rlc2MgKnBpX2Rlc2MsIHU2
NCAqcG9sZCwgdTY0IG5ldykKIHsKIAkvKgogCSAqIFBJRC5PTiBjYW4gYmUgc2V0IGF0IGFueSB0
aW1lIGJ5IGEgZGlmZmVyZW50IHZDUFUgb3IgYnkgaGFyZHdhcmUsCkBAIC00Miw3ICs0Miw3IEBA
IHN0YXRpYyBpbnQgcGlfdHJ5X3NldF9jb250cm9sKHN0cnVjdCBwaV9kZXNjICpwaV9kZXNjLCB1
NjQgb2xkLCB1NjQgbmV3KQogCSAqIHVwZGF0ZSBtdXN0IGJlIHJldHJpZWQgd2l0aCBhIGZyZXNo
IHNuYXBzaG90IGFuIE9OIGNoYW5nZSBjYXVzZXMKIAkgKiB0aGUgY21weGNoZyB0byBmYWlsLgog
CSAqLwotCWlmIChjbXB4Y2hnNjQoJnBpX2Rlc2MtPmNvbnRyb2wsIG9sZCwgbmV3KSAhPSBvbGQp
CisJaWYgKCF0cnlfY21weGNoZzY0KCZwaV9kZXNjLT5jb250cm9sLCBwb2xkLCBuZXcpKQogCQly
ZXR1cm4gLUVCVVNZOwogCiAJcmV0dXJuIDA7CkBAIC0xMTEsNyArMTExLDcgQEAgdm9pZCB2bXhf
dmNwdV9waV9sb2FkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgaW50IGNwdSkKIAkJICogZGVzY3Jp
cHRvciB3YXMgbW9kaWZpZWQgb24gInB1dCIgdG8gdXNlIHRoZSB3YWtldXAgdmVjdG9yLgogCQkg
Ki8KIAkJbmV3Lm52ID0gUE9TVEVEX0lOVFJfVkVDVE9SOwotCX0gd2hpbGUgKHBpX3RyeV9zZXRf
Y29udHJvbChwaV9kZXNjLCBvbGQuY29udHJvbCwgbmV3LmNvbnRyb2wpKTsKKwl9IHdoaWxlIChw
aV90cnlfc2V0X2NvbnRyb2wocGlfZGVzYywgJm9sZC5jb250cm9sLCBuZXcuY29udHJvbCkpOwog
CiAJbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOwogCkBAIC0xNjEsNyArMTYxLDcgQEAgc3RhdGlj
IHZvaWQgcGlfZW5hYmxlX3dha2V1cF9oYW5kbGVyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIAog
CQkvKiBzZXQgJ05WJyB0byAnd2FrZXVwIHZlY3RvcicgKi8KIAkJbmV3Lm52ID0gUE9TVEVEX0lO
VFJfV0FLRVVQX1ZFQ1RPUjsKLQl9IHdoaWxlIChwaV90cnlfc2V0X2NvbnRyb2wocGlfZGVzYywg
b2xkLmNvbnRyb2wsIG5ldy5jb250cm9sKSk7CisJfSB3aGlsZSAocGlfdHJ5X3NldF9jb250cm9s
KHBpX2Rlc2MsICZvbGQuY29udHJvbCwgbmV3LmNvbnRyb2wpKTsKIAogCS8qCiAJICogU2VuZCBh
IHdha2V1cCBJUEkgdG8gdGhpcyBDUFUgaWYgYW4gaW50ZXJydXB0IG1heSBoYXZlIGJlZW4gcG9z
dGVkCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2F0b21pYy9hdG9taWMtaW5zdHJ1bWVudGVk
LmggYi9pbmNsdWRlL2xpbnV4L2F0b21pYy9hdG9taWMtaW5zdHJ1bWVudGVkLmgKaW5kZXggNWQ2
OWIxNDNjMjhlLi43YTEzOWVjMDMwYjAgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvYXRvbWlj
L2F0b21pYy1pbnN0cnVtZW50ZWQuaAorKysgYi9pbmNsdWRlL2xpbnV4L2F0b21pYy9hdG9taWMt
aW5zdHJ1bWVudGVkLmgKQEAgLTIwMDYsNiArMjAwNiw0NCBAQCBhdG9taWNfbG9uZ19kZWNfaWZf
cG9zaXRpdmUoYXRvbWljX2xvbmdfdCAqdikKIAlhcmNoX3RyeV9jbXB4Y2hnX3JlbGF4ZWQoX19h
aV9wdHIsIF9fYWlfb2xkcCwgX19WQV9BUkdTX18pOyBcCiB9KQogCisjZGVmaW5lIHRyeV9jbXB4
Y2hnNjQocHRyLCBvbGRwLCAuLi4pIFwKKyh7IFwKKwl0eXBlb2YocHRyKSBfX2FpX3B0ciA9IChw
dHIpOyBcCisJdHlwZW9mKG9sZHApIF9fYWlfb2xkcCA9IChvbGRwKTsgXAorCWtjc2FuX21iKCk7
IFwKKwlpbnN0cnVtZW50X2F0b21pY193cml0ZShfX2FpX3B0ciwgc2l6ZW9mKCpfX2FpX3B0cikp
OyBcCisJaW5zdHJ1bWVudF9hdG9taWNfd3JpdGUoX19haV9vbGRwLCBzaXplb2YoKl9fYWlfb2xk
cCkpOyBcCisJYXJjaF90cnlfY21weGNoZzY0KF9fYWlfcHRyLCBfX2FpX29sZHAsIF9fVkFfQVJH
U19fKTsgXAorfSkKKworI2RlZmluZSB0cnlfY21weGNoZzY0X2FjcXVpcmUocHRyLCBvbGRwLCAu
Li4pIFwKKyh7IFwKKwl0eXBlb2YocHRyKSBfX2FpX3B0ciA9IChwdHIpOyBcCisJdHlwZW9mKG9s
ZHApIF9fYWlfb2xkcCA9IChvbGRwKTsgXAorCWluc3RydW1lbnRfYXRvbWljX3dyaXRlKF9fYWlf
cHRyLCBzaXplb2YoKl9fYWlfcHRyKSk7IFwKKwlpbnN0cnVtZW50X2F0b21pY193cml0ZShfX2Fp
X29sZHAsIHNpemVvZigqX19haV9vbGRwKSk7IFwKKwlhcmNoX3RyeV9jbXB4Y2hnNjRfYWNxdWly
ZShfX2FpX3B0ciwgX19haV9vbGRwLCBfX1ZBX0FSR1NfXyk7IFwKK30pCisKKyNkZWZpbmUgdHJ5
X2NtcHhjaGc2NF9yZWxlYXNlKHB0ciwgb2xkcCwgLi4uKSBcCisoeyBcCisJdHlwZW9mKHB0cikg
X19haV9wdHIgPSAocHRyKTsgXAorCXR5cGVvZihvbGRwKSBfX2FpX29sZHAgPSAob2xkcCk7IFwK
KwlrY3Nhbl9yZWxlYXNlKCk7IFwKKwlpbnN0cnVtZW50X2F0b21pY193cml0ZShfX2FpX3B0ciwg
c2l6ZW9mKCpfX2FpX3B0cikpOyBcCisJaW5zdHJ1bWVudF9hdG9taWNfd3JpdGUoX19haV9vbGRw
LCBzaXplb2YoKl9fYWlfb2xkcCkpOyBcCisJYXJjaF90cnlfY21weGNoZzY0X3JlbGVhc2UoX19h
aV9wdHIsIF9fYWlfb2xkcCwgX19WQV9BUkdTX18pOyBcCit9KQorCisjZGVmaW5lIHRyeV9jbXB4
Y2hnNjRfcmVsYXhlZChwdHIsIG9sZHAsIC4uLikgXAorKHsgXAorCXR5cGVvZihwdHIpIF9fYWlf
cHRyID0gKHB0cik7IFwKKwl0eXBlb2Yob2xkcCkgX19haV9vbGRwID0gKG9sZHApOyBcCisJaW5z
dHJ1bWVudF9hdG9taWNfd3JpdGUoX19haV9wdHIsIHNpemVvZigqX19haV9wdHIpKTsgXAorCWlu
c3RydW1lbnRfYXRvbWljX3dyaXRlKF9fYWlfb2xkcCwgc2l6ZW9mKCpfX2FpX29sZHApKTsgXAor
CWFyY2hfdHJ5X2NtcHhjaGc2NF9yZWxheGVkKF9fYWlfcHRyLCBfX2FpX29sZHAsIF9fVkFfQVJH
U19fKTsgXAorfSkKKwogI2RlZmluZSBjbXB4Y2hnX2xvY2FsKHB0ciwgLi4uKSBcCiAoeyBcCiAJ
dHlwZW9mKHB0cikgX19haV9wdHIgPSAocHRyKTsgXApAQCAtMjA0NSw0ICsyMDgzLDQgQEAgYXRv
bWljX2xvbmdfZGVjX2lmX3Bvc2l0aXZlKGF0b21pY19sb25nX3QgKnYpCiB9KQogCiAjZW5kaWYg
LyogX0xJTlVYX0FUT01JQ19JTlNUUlVNRU5URURfSCAqLwotLy8gODdjOTc0YjkzMDMyYWZkNDIx
NDM2MTM0MzRkMWE3Nzg4ZmE1OThmOQorLy8gNzY0Zjc0MWViNzdhN2FkNTY1ZGM4ZDk5Y2UyODM3
ZDU1NDJlOGFlZQpkaWZmIC0tZ2l0IGEvc2NyaXB0cy9hdG9taWMvZ2VuLWF0b21pYy1pbnN0cnVt
ZW50ZWQuc2ggYi9zY3JpcHRzL2F0b21pYy9nZW4tYXRvbWljLWluc3RydW1lbnRlZC5zaAppbmRl
eCA2OGY5MDI3MzFkMDEuLjc3YzA2NTI2YTU3NCAxMDA3NTUKLS0tIGEvc2NyaXB0cy9hdG9taWMv
Z2VuLWF0b21pYy1pbnN0cnVtZW50ZWQuc2gKKysrIGIvc2NyaXB0cy9hdG9taWMvZ2VuLWF0b21p
Yy1pbnN0cnVtZW50ZWQuc2gKQEAgLTE2Niw3ICsxNjYsNyBAQCBncmVwICdeW2Etel0nICIkMSIg
fCB3aGlsZSByZWFkIG5hbWUgbWV0YSBhcmdzOyBkbwogZG9uZQogCiAKLWZvciB4Y2hnIGluICJ4
Y2hnIiAiY21weGNoZyIgImNtcHhjaGc2NCIgInRyeV9jbXB4Y2hnIjsgZG8KK2ZvciB4Y2hnIGlu
ICJ4Y2hnIiAiY21weGNoZyIgImNtcHhjaGc2NCIgInRyeV9jbXB4Y2hnIiAidHJ5X2NtcHhjaGc2
NCI7IGRvCiAJZm9yIG9yZGVyIGluICIiICJfYWNxdWlyZSIgIl9yZWxlYXNlIiAiX3JlbGF4ZWQi
OyBkbwogCQlnZW5feGNoZyAiJHt4Y2hnfSIgIiR7b3JkZXJ9IiAiIgogCQlwcmludGYgIlxuIgo=
--00000000000047c74f05d708d21d--
