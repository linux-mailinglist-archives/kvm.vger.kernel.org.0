Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD595A91E
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2019 07:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfF2FQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Jun 2019 01:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbfF2FQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Jun 2019 01:16:23 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AE09214DA
        for <kvm@vger.kernel.org>; Sat, 29 Jun 2019 05:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561785381;
        bh=z3FyJn0RPdWPH7muJBCpqnvRwUH0LI5rqWKjeEDFOLg=;
        h=From:Date:Subject:To:From;
        b=dPBKv29OzftKoFFvlhAcyEJd99QIMLqS9R4vWd7Yoei5aL4fgOtOMRi6KGoA4iKRt
         P3z58q9Da0LD+Iz1pK/ifw9si9x/uwRIUs1i2j3g+pKUJaf8xpTDciVa9FCe9BMJC0
         kJLggiVUStOsOrFzB1o+yjvl1aavxabu3BWL7wOg=
Received: by mail-wr1-f49.google.com with SMTP id p13so8217341wru.10
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 22:16:21 -0700 (PDT)
X-Gm-Message-State: APjAAAVi81Dsyb6rOEqDHRsalxHoXUh34o2EUzV7XRJAVjdRfxQt2pu0
        b1YOa5j2AWm7pA/WYdO1HbeXwExLCQtgMJ9pxSJa+g==
X-Google-Smtp-Source: APXvYqwZprAuzRi9IWoNs7Nypmt5csVlha3XHPO27twGejUVL6amCFqCQjLM5JdTFvJLtqdqXM3k1oXD3vQTc6CAa50=
X-Received: by 2002:adf:dd0f:: with SMTP id a15mr8134667wrm.265.1561785380133;
 Fri, 28 Jun 2019 22:16:20 -0700 (PDT)
MIME-Version: 1.0
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 28 Jun 2019 22:16:09 -0700
X-Gmail-Original-Message-ID: <CALCETrU8k1mL=Uy_QNbT7fjtCLO8N3xgZb6zLyfdwHx6SUFPoA@mail.gmail.com>
Message-ID: <CALCETrU8k1mL=Uy_QNbT7fjtCLO8N3xgZb6zLyfdwHx6SUFPoA@mail.gmail.com>
Subject: KVM's SYSCALL emulation for GenuineIntel is buggy
To:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vegard Nossum <vegard.nossum@oracle.com>
Content-Type: multipart/mixed; boundary="000000000000cc98b8058c6f7ee9"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--000000000000cc98b8058c6f7ee9
Content-Type: text/plain; charset="UTF-8"

If I do SYSCALL with EFLAGS.TF set from compat mode on Intel hardware
with -cpu host and no other funny business, the guest kernel seems to
get #DB with the stored IP pointing at the SYSCALL instruction.  This
is wrong -- SYSCALL is #UD, which is a *fault*, so there shouldn't be
a single-step trap.

Unless I'm missing something in the code, emulate_ud() is mishandled
in general -- it seems to make cause inject_emulated_exception() to
return false here:

    if (ctxt->have_exception) {
        r = EMULATE_DONE;
        if (inject_emulated_exception(vcpu))
            return r;

and then we land here:

        if (r == EMULATE_DONE && ctxt->tf)
            kvm_vcpu_do_singlestep(vcpu, &r);

if TF was set, which is wrong.

You can test this by applying the attached patch, building x86
selftests, and running syscall_arg_fault_32 in a VM.  It hangs.  It
should complete successfully, and it does on bare metal.

--000000000000cc98b8058c6f7ee9
Content-Type: text/x-patch; charset="US-ASCII"; name="test.patch"
Content-Disposition: attachment; filename="test.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxh2ltaq0>
X-Attachment-Id: f_jxh2ltaq0

Y29tbWl0IGZhZThlODYwNTg0YjVhOGMyMjUzYjUyMmNiNDc4ZTkyYjhiMGMyODEKQXV0aG9yOiBB
bmR5IEx1dG9taXJza2kgPGx1dG9Aa2VybmVsLm9yZz4KRGF0ZTogICBGcmkgSnVuIDI4IDE5OjU0
OjM0IDIwMTkgLTA3MDAKCiAgICBzZWxmdGVzdHMveDg2OiBUZXN0IFNZU0NBTEwgYW5kIFNZU0VO
VEVSIG1hbnVhbGx5IHdpdGggVEYgc2V0CiAgICAKICAgIE1ha2Ugc3VyZSB0aGF0IHdlIGV4ZXJj
aXNlIGJvdGggdmFyaWFudHMgb2YgdGhlIG5hc3R5CiAgICBURi1pbi1jb21wYXQtc3lzY2FsbCBy
ZWdhcmRsZXNzIG9mIHdoYXQgdmVuZG9yJ3MgQ1BVIGlzIHJ1bm5pbmcgdGhlCiAgICB0ZXN0cy4K
ICAgIAogICAgQWxzbyBjaGFuZ2UgdGhlIGludGVudGlvbmFsIHNpZ25hbCBhZnRlciBTWVNDQUxM
IHRvIHVzZSB1ZDIsIHdoaWNoCiAgICBpcyBhIGxvdCBtb3JlIGNvbXByZWhlbnNpYmxlLgogICAg
CiAgICBUaGlzIGNyYXNoZXMgdGhlIGtlcm5lbCBkdWUgdG8gYW4gRlNHU0JBU0UgYnVnIHJpZ2h0
IG5vdy4KICAgIAogICAgUmVwb3J0ZWQtYnk6IFZlZ2FyZCBOb3NzdW0gPHZlZ2FyZC5ub3NzdW1A
b3JhY2xlLmNvbT4KICAgIENjOiAiQmFlLCBDaGFuZyBTZW9rIiA8Y2hhbmcuc2Vvay5iYWVAaW50
ZWwuY29tPgogICAgU2lnbmVkLW9mZi1ieTogQW5keSBMdXRvbWlyc2tpIDxsdXRvQGtlcm5lbC5v
cmc+CgpkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMveDg2L01ha2VmaWxlIGIv
dG9vbHMvdGVzdGluZy9zZWxmdGVzdHMveDg2L01ha2VmaWxlCmluZGV4IDE4NjUyMDE5OGRlNy4u
ZmEwN2Q1MjZmZTM5IDEwMDY0NAotLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy94ODYvTWFr
ZWZpbGUKKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMveDg2L01ha2VmaWxlCkBAIC0xMiw4
ICsxMiw5IEBAIENBTl9CVUlMRF9XSVRIX05PUElFIDo9ICQoc2hlbGwgLi9jaGVja19jYy5zaCAk
KENDKSB0cml2aWFsX3Byb2dyYW0uYyAtbm8tcGllKQogCiBUQVJHRVRTX0NfQk9USEJJVFMgOj0g
c2luZ2xlX3N0ZXBfc3lzY2FsbCBzeXNyZXRfc3NfYXR0cnMgc3lzY2FsbF9udCB0ZXN0X21yZW1h
cF92ZHNvIFwKIAkJCWNoZWNrX2luaXRpYWxfcmVnX3N0YXRlIHNpZ3JldHVybiBpb3BsIG1weC1t
aW5pLXRlc3QgaW9wZXJtIFwKLQkJCXByb3RlY3Rpb25fa2V5cyB0ZXN0X3Zkc28gdGVzdF92c3lz
Y2FsbCBtb3Zfc3NfdHJhcAotVEFSR0VUU19DXzMyQklUX09OTFkgOj0gZW50cnlfZnJvbV92bTg2
IHN5c2NhbGxfYXJnX2ZhdWx0IHRlc3Rfc3lzY2FsbF92ZHNvIHVud2luZF92ZHNvIFwKKwkJCXBy
b3RlY3Rpb25fa2V5cyB0ZXN0X3Zkc28gdGVzdF92c3lzY2FsbCBtb3Zfc3NfdHJhcCBcCisJCQlz
eXNjYWxsX2FyZ19mYXVsdAorVEFSR0VUU19DXzMyQklUX09OTFkgOj0gZW50cnlfZnJvbV92bTg2
IHRlc3Rfc3lzY2FsbF92ZHNvIHVud2luZF92ZHNvIFwKIAkJCXRlc3RfRkNNT1YgdGVzdF9GQ09N
SSB0ZXN0X0ZJU1RUUCBcCiAJCQl2ZHNvX3Jlc3RvcmVyCiBUQVJHRVRTX0NfNjRCSVRfT05MWSA6
PSBmc2dzYmFzZSBzeXNyZXRfcmlwCmRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy94ODYvc3lzY2FsbF9hcmdfZmF1bHQuYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL3g4Ni9z
eXNjYWxsX2FyZ19mYXVsdC5jCmluZGV4IDRlMjVkMzhjOGJiZC4uOTM5ZGUzYzk0OTc2IDEwMDY0
NAotLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy94ODYvc3lzY2FsbF9hcmdfZmF1bHQuYwor
KysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy94ODYvc3lzY2FsbF9hcmdfZmF1bHQuYwpAQCAt
MTUsOSArMTUsMzAgQEAKICNpbmNsdWRlIDxzZXRqbXAuaD4KICNpbmNsdWRlIDxlcnJuby5oPgog
CisjaWZkZWYgX194ODZfNjRfXworIyBkZWZpbmUgV0lEVEggInEiCisjZWxzZQorIyBkZWZpbmUg
V0lEVEggImwiCisjZW5kaWYKKwogLyogT3VyIHNpZ2FsdHN0YWNrIHNjcmF0Y2ggc3BhY2UuICov
CiBzdGF0aWMgdW5zaWduZWQgY2hhciBhbHRzdGFja19kYXRhW1NJR1NUS1NaXTsKIAorc3RhdGlj
IHVuc2lnbmVkIGxvbmcgZ2V0X2VmbGFncyh2b2lkKQoreworCXVuc2lnbmVkIGxvbmcgZWZsYWdz
OworCWFzbSB2b2xhdGlsZSAoInB1c2hmIiBXSURUSCAiXG5cdHBvcCIgV0lEVEggIiAlMCIgOiAi
PXJtIiAoZWZsYWdzKSk7CisJcmV0dXJuIGVmbGFnczsKK30KKworc3RhdGljIHZvaWQgc2V0X2Vm
bGFncyh1bnNpZ25lZCBsb25nIGVmbGFncykKK3sKKwlhc20gdm9sYXRpbGUgKCJwdXNoIiBXSURU
SCAiICUwXG5cdHBvcGYiIFdJRFRICisJCSAgICAgIDogOiAicm0iIChlZmxhZ3MpIDogImZsYWdz
Iik7Cit9CisKKyNkZWZpbmUgWDg2X0VGTEFHU19URiAoMVVMIDw8IDgpCisKIHN0YXRpYyB2b2lk
IHNldGhhbmRsZXIoaW50IHNpZywgdm9pZCAoKmhhbmRsZXIpKGludCwgc2lnaW5mb190ICosIHZv
aWQgKiksCiAJCSAgICAgICBpbnQgZmxhZ3MpCiB7CkBAIC0zNSwxMyArNTYsMjIgQEAgc3RhdGlj
IHNpZ2ptcF9idWYgam1wYnVmOwogCiBzdGF0aWMgdm9sYXRpbGUgc2lnX2F0b21pY190IG5fZXJy
czsKIAorI2lmZGVmIF9feDg2XzY0X18KKyNkZWZpbmUgUkVHX0FYIFJFR19SQVgKKyNkZWZpbmUg
UkVHX0lQIFJFR19SSVAKKyNlbHNlCisjZGVmaW5lIFJFR19BWCBSRUdfRUFYCisjZGVmaW5lIFJF
R19JUCBSRUdfRUlQCisjZW5kaWYKKwogc3RhdGljIHZvaWQgc2lnc2Vndl9vcl9zaWdidXMoaW50
IHNpZywgc2lnaW5mb190ICppbmZvLCB2b2lkICpjdHhfdm9pZCkKIHsKIAl1Y29udGV4dF90ICpj
dHggPSAodWNvbnRleHRfdCopY3R4X3ZvaWQ7CisJbG9uZyBheCA9IChsb25nKWN0eC0+dWNfbWNv
bnRleHQuZ3JlZ3NbUkVHX0FYXTsKIAotCWlmIChjdHgtPnVjX21jb250ZXh0LmdyZWdzW1JFR19F
QVhdICE9IC1FRkFVTFQpIHsKLQkJcHJpbnRmKCJbRkFJTF1cdEFYIGhhZCB0aGUgd3JvbmcgdmFs
dWU6IDB4JXhcbiIsCi0JCSAgICAgICBjdHgtPnVjX21jb250ZXh0LmdyZWdzW1JFR19FQVhdKTsK
KwlpZiAoYXggIT0gLUVGQVVMVCAmJiBheCAhPSAtRU5PU1lTKSB7CisJCXByaW50ZigiW0ZBSUxd
XHRBWCBoYWQgdGhlIHdyb25nIHZhbHVlOiAweCVseFxuIiwKKwkJICAgICAgICh1bnNpZ25lZCBs
b25nKWF4KTsKIAkJbl9lcnJzKys7CiAJfSBlbHNlIHsKIAkJcHJpbnRmKCJbT0tdXHRTZWVtcyBv
a2F5XG4iKTsKQEAgLTUwLDkgKzgwLDIxIEBAIHN0YXRpYyB2b2lkIHNpZ3NlZ3Zfb3Jfc2lnYnVz
KGludCBzaWcsIHNpZ2luZm9fdCAqaW5mbywgdm9pZCAqY3R4X3ZvaWQpCiAJc2lnbG9uZ2ptcChq
bXBidWYsIDEpOwogfQogCitzdGF0aWMgdm9pZCBzaWd0cmFwKGludCBzaWcsIHNpZ2luZm9fdCAq
aW5mbywgdm9pZCAqY3R4X3ZvaWQpCit7Cit9CisKIHN0YXRpYyB2b2lkIHNpZ2lsbChpbnQgc2ln
LCBzaWdpbmZvX3QgKmluZm8sIHZvaWQgKmN0eF92b2lkKQogewotCXByaW50ZigiW1NLSVBdXHRJ
bGxlZ2FsIGluc3RydWN0aW9uXG4iKTsKKwl1Y29udGV4dF90ICpjdHggPSAodWNvbnRleHRfdCop
Y3R4X3ZvaWQ7CisJdW5zaWduZWQgc2hvcnQgKmlwID0gKHVuc2lnbmVkIHNob3J0ICopY3R4LT51
Y19tY29udGV4dC5ncmVnc1tSRUdfSVBdOworCisJaWYgKCppcCA9PSAweDBiMGYpIHsKKwkJLyog
b25lIG9mIHRoZSB1ZDIgaW5zdHJ1Y3Rpb25zIGZhdWx0ZWQgKi8KKwkJcHJpbnRmKCJbT0tdXHRT
WVNDQUxMIHJldHVybmVkIG5vcm1hbGx5XG4iKTsKKwl9IGVsc2UgeworCQlwcmludGYoIltTS0lQ
XVx0SWxsZWdhbCBpbnN0cnVjdGlvblxuIik7CisJfQogCXNpZ2xvbmdqbXAoam1wYnVmLCAxKTsK
IH0KIApAQCAtMTIwLDkgKzE2Miw0NiBAQCBpbnQgbWFpbigpCiAJCQkibW92bCAkLTEsICUlZWJw
XG5cdCIKIAkJCSJtb3ZsICQtMSwgJSVlc3Bcblx0IgogCQkJInN5c2NhbGxcblx0IgotCQkJInB1
c2hsICQwIgkvKiBtYWtlIHN1cmUgd2Ugc2VnZmF1bHQgY2xlYW5seSAqLworCQkJInVkMiIJCS8q
IG1ha2Ugc3VyZSB3ZSByZWNvdmVyIGNsZWFubHkgKi8KKwkJCTogOiA6ICJtZW1vcnkiLCAiZmxh
Z3MiKTsKKwl9CisKKwlwcmludGYoIltSVU5dXHRTWVNFTlRFUiB3aXRoIFRGIGFuZCBpbnZhbGlk
IHN0YXRlXG4iKTsKKwlzZXRoYW5kbGVyKFNJR1RSQVAsIHNpZ3RyYXAsIFNBX09OU1RBQ0spOwor
CisJaWYgKHNpZ3NldGptcChqbXBidWYsIDEpID09IDApIHsKKwkJc2V0X2VmbGFncyhnZXRfZWZs
YWdzKCkgfCBYODZfRUZMQUdTX1RGKTsKKwkJYXNtIHZvbGF0aWxlICgKKwkJCSJtb3ZsICQtMSwg
JSVlYXhcblx0IgorCQkJIm1vdmwgJC0xLCAlJWVieFxuXHQiCisJCQkibW92bCAkLTEsICUlZWN4
XG5cdCIKKwkJCSJtb3ZsICQtMSwgJSVlZHhcblx0IgorCQkJIm1vdmwgJC0xLCAlJWVzaVxuXHQi
CisJCQkibW92bCAkLTEsICUlZWRpXG5cdCIKKwkJCSJtb3ZsICQtMSwgJSVlYnBcblx0IgorCQkJ
Im1vdmwgJC0xLCAlJWVzcFxuXHQiCisJCQkic3lzZW50ZXIiCisJCQk6IDogOiAibWVtb3J5Iiwg
ImZsYWdzIik7CisJfQorCXNldF9lZmxhZ3MoZ2V0X2VmbGFncygpICYgflg4Nl9FRkxBR1NfVEYp
OworCisJcHJpbnRmKCJbUlVOXVx0U1lTQ0FMTCB3aXRoIFRGIGFuZCBpbnZhbGlkIHN0YXRlXG4i
KTsKKwlpZiAoc2lnc2V0am1wKGptcGJ1ZiwgMSkgPT0gMCkgeworCQlzZXRfZWZsYWdzKGdldF9l
ZmxhZ3MoKSB8IFg4Nl9FRkxBR1NfVEYpOworCQlhc20gdm9sYXRpbGUgKAorCQkJIm1vdmwgJC0x
LCAlJWVheFxuXHQiCisJCQkibW92bCAkLTEsICUlZWJ4XG5cdCIKKwkJCSJtb3ZsICQtMSwgJSVl
Y3hcblx0IgorCQkJIm1vdmwgJC0xLCAlJWVkeFxuXHQiCisJCQkibW92bCAkLTEsICUlZXNpXG5c
dCIKKwkJCSJtb3ZsICQtMSwgJSVlZGlcblx0IgorCQkJIm1vdmwgJC0xLCAlJWVicFxuXHQiCisJ
CQkibW92bCAkLTEsICUlZXNwXG5cdCIKKwkJCSJzeXNjYWxsXG5cdCIKKwkJCSJ1ZDIiCQkvKiBt
YWtlIHN1cmUgd2UgcmVjb3ZlciBjbGVhbmx5ICovCiAJCQk6IDogOiAibWVtb3J5IiwgImZsYWdz
Iik7CiAJfQorCXNldF9lZmxhZ3MoZ2V0X2VmbGFncygpICYgflg4Nl9FRkxBR1NfVEYpOwogCiAJ
cmV0dXJuIDA7CiB9Cg==
--000000000000cc98b8058c6f7ee9--
