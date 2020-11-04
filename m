Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8620C2A6777
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbgKDPV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:21:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31149 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730754AbgKDPV4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:21:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n/OR/Joj1lfC3YR1bSF0Av5jtRi+lNka4XhjiATL/DU=;
        b=GRHcwRU1hOWKdPVsrn825t55+sBz0Q8wBE+p+tT+22xF12sC0/iPeu1lo6R/cZuzC4gdMd
        O2ZJZGqm8IwuQ13earD2onuMAIvtKWzVihEh0vvcb4AZyppx7Pso48nCpBIhDiOVtmo4uY
        cVxXW0Na3s8s7yWsaVfJ//Hx7wx1Ofc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-VGrwqsxeMauHQ9gEV0mu1Q-1; Wed, 04 Nov 2020 10:21:50 -0500
X-MC-Unique: VGrwqsxeMauHQ9gEV0mu1Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F153387951B;
        Wed,  4 Nov 2020 15:21:48 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EB8C6EF7E;
        Wed,  4 Nov 2020 15:21:41 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>, Fam Zheng <fam@euphon.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Keith Busch <kbusch@kernel.org>, Max Reitz <mreitz@redhat.com>,
        qemu-block@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Coiby Xu <Coiby.Xu@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Klaus Jensen <its@irrelevant.dk>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PULL 29/33] util/vfio-helpers: Trace PCI BAR region info
Date:   Wed,  4 Nov 2020 15:18:24 +0000
Message-Id: <20201104151828.405824-30-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKRm9yIGRl
YnVnIHB1cnBvc2UsIHRyYWNlIEJBUiByZWdpb25zIGluZm8uCgpSZXZpZXdlZC1ieTogRmFtIFpo
ZW5nIDxmYW1AZXVwaG9uLm5ldD4KUmV2aWV3ZWQtYnk6IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFu
aGFAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBo
aWxtZEByZWRoYXQuY29tPgpNZXNzYWdlLWlkOiAyMDIwMTEwMzAyMDczMy4yMzAzMTQ4LTQtcGhp
bG1kQHJlZGhhdC5jb20KU2lnbmVkLW9mZi1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUBy
ZWRoYXQuY29tPgpUZXN0ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4K
LS0tCiB1dGlsL3ZmaW8taGVscGVycy5jIHwgOCArKysrKysrKwogdXRpbC90cmFjZS1ldmVudHMg
ICB8IDEgKwogMiBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS91
dGlsL3ZmaW8taGVscGVycy5jIGIvdXRpbC92ZmlvLWhlbHBlcnMuYwppbmRleCAxZDRlZmFmY2Fh
Li5jZDYyODdjM2E5IDEwMDY0NAotLS0gYS91dGlsL3ZmaW8taGVscGVycy5jCisrKyBiL3V0aWwv
dmZpby1oZWxwZXJzLmMKQEAgLTEzNiw2ICsxMzYsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgYXNz
ZXJ0X2Jhcl9pbmRleF92YWxpZChRRU1VVkZJT1N0YXRlICpzLCBpbnQgaW5kZXgpCiAKIHN0YXRp
YyBpbnQgcWVtdV92ZmlvX3BjaV9pbml0X2JhcihRRU1VVkZJT1N0YXRlICpzLCBpbnQgaW5kZXgs
IEVycm9yICoqZXJycCkKIHsKKyAgICBnX2F1dG9mcmVlIGNoYXIgKmJhcm5hbWUgPSBOVUxMOwog
ICAgIGFzc2VydF9iYXJfaW5kZXhfdmFsaWQocywgaW5kZXgpOwogICAgIHMtPmJhcl9yZWdpb25f
aW5mb1tpbmRleF0gPSAoc3RydWN0IHZmaW9fcmVnaW9uX2luZm8pIHsKICAgICAgICAgLmluZGV4
ID0gVkZJT19QQ0lfQkFSMF9SRUdJT05fSU5ERVggKyBpbmRleCwKQEAgLTE0NSw2ICsxNDYsMTAg
QEAgc3RhdGljIGludCBxZW11X3ZmaW9fcGNpX2luaXRfYmFyKFFFTVVWRklPU3RhdGUgKnMsIGlu
dCBpbmRleCwgRXJyb3IgKiplcnJwKQogICAgICAgICBlcnJvcl9zZXRnX2Vycm5vKGVycnAsIGVy
cm5vLCAiRmFpbGVkIHRvIGdldCBCQVIgcmVnaW9uIGluZm8iKTsKICAgICAgICAgcmV0dXJuIC1l
cnJubzsKICAgICB9CisgICAgYmFybmFtZSA9IGdfc3RyZHVwX3ByaW50ZigiYmFyWyVkXSIsIGlu
ZGV4KTsKKyAgICB0cmFjZV9xZW11X3ZmaW9fcmVnaW9uX2luZm8oYmFybmFtZSwgcy0+YmFyX3Jl
Z2lvbl9pbmZvW2luZGV4XS5vZmZzZXQsCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHMtPmJhcl9yZWdpb25faW5mb1tpbmRleF0uc2l6ZSwKKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgcy0+YmFyX3JlZ2lvbl9pbmZvW2luZGV4XS5jYXBfb2Zmc2V0KTsKIAogICAgIHJl
dHVybiAwOwogfQpAQCAtNDE2LDYgKzQyMSw5IEBAIHN0YXRpYyBpbnQgcWVtdV92ZmlvX2luaXRf
cGNpKFFFTVVWRklPU3RhdGUgKnMsIGNvbnN0IGNoYXIgKmRldmljZSwKICAgICAgICAgcmV0ID0g
LWVycm5vOwogICAgICAgICBnb3RvIGZhaWw7CiAgICAgfQorICAgIHRyYWNlX3FlbXVfdmZpb19y
ZWdpb25faW5mbygiY29uZmlnIiwgcy0+Y29uZmlnX3JlZ2lvbl9pbmZvLm9mZnNldCwKKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgcy0+Y29uZmlnX3JlZ2lvbl9pbmZvLnNpemUsCisg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHMtPmNvbmZpZ19yZWdpb25faW5mby5jYXBf
b2Zmc2V0KTsKIAogICAgIGZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHMtPmJhcl9yZWdpb25f
aW5mbyk7IGkrKykgewogICAgICAgICByZXQgPSBxZW11X3ZmaW9fcGNpX2luaXRfYmFyKHMsIGks
IGVycnApOwpkaWZmIC0tZ2l0IGEvdXRpbC90cmFjZS1ldmVudHMgYi91dGlsL3RyYWNlLWV2ZW50
cwppbmRleCA4ZDM2MTVlNzE3Li4wNzUzZTRhMGVkIDEwMDY0NAotLS0gYS91dGlsL3RyYWNlLWV2
ZW50cworKysgYi91dGlsL3RyYWNlLWV2ZW50cwpAQCAtODcsMyArODcsNCBAQCBxZW11X3ZmaW9f
ZG1hX21hcCh2b2lkICpzLCB2b2lkICpob3N0LCBzaXplX3Qgc2l6ZSwgYm9vbCB0ZW1wb3Jhcnks
IHVpbnQ2NF90ICppbwogcWVtdV92ZmlvX2RtYV91bm1hcCh2b2lkICpzLCB2b2lkICpob3N0KSAi
cyAlcCBob3N0ICVwIgogcWVtdV92ZmlvX3BjaV9yZWFkX2NvbmZpZyh2b2lkICpidWYsIGludCBv
ZnMsIGludCBzaXplLCB1aW50NjRfdCByZWdpb25fb2ZzLCB1aW50NjRfdCByZWdpb25fc2l6ZSkg
InJlYWQgY2ZnIHB0ciAlcCBvZnMgMHgleCBzaXplIDB4JXggKHJlZ2lvbiBhZGRyIDB4JSJQUkl4
NjQiIHNpemUgMHglIlBSSXg2NCIpIgogcWVtdV92ZmlvX3BjaV93cml0ZV9jb25maWcodm9pZCAq
YnVmLCBpbnQgb2ZzLCBpbnQgc2l6ZSwgdWludDY0X3QgcmVnaW9uX29mcywgdWludDY0X3QgcmVn
aW9uX3NpemUpICJ3cml0ZSBjZmcgcHRyICVwIG9mcyAweCV4IHNpemUgMHgleCAocmVnaW9uIGFk
ZHIgMHglIlBSSXg2NCIgc2l6ZSAweCUiUFJJeDY0IikiCitxZW11X3ZmaW9fcmVnaW9uX2luZm8o
Y29uc3QgY2hhciAqZGVzYywgdWludDY0X3QgcmVnaW9uX29mcywgdWludDY0X3QgcmVnaW9uX3Np
emUsIHVpbnQzMl90IGNhcF9vZmZzZXQpICJyZWdpb24gJyVzJyBhZGRyIDB4JSJQUkl4NjQiIHNp
emUgMHglIlBSSXg2NCIgY2FwX29mcyAweCUiUFJJeDMyCi0tIAoyLjI4LjAKCg==

