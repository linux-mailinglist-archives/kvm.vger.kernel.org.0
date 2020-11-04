Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4932A6778
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730767AbgKDPWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:22:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730757AbgKDPWB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:22:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PIZZ5Hi8D4fcT+xa9s+gZYl3zzMRkTliQG4Od6XVvZo=;
        b=Xk9+vFx2dlVzYSejS1mWRbuhGc39Wc90bHH1i2H3Kq3cx/OvnxIFItBspAJtQWTMRsBPvu
        WQEwrLjSwKOy2J3WlZL3iUbIIwbiYuutC0AqKRiHCxT7VGeVGO8/pH/dSdJn5sMqrUc23p
        E3bvG9dEJ4Th730jx/5i9P+KnYn0hOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-DiWugDmTNjK3oZpa5F_aCw-1; Wed, 04 Nov 2020 10:21:52 -0500
X-MC-Unique: DiWugDmTNjK3oZpa5F_aCw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4930879519;
        Wed,  4 Nov 2020 15:21:50 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 748FA73672;
        Wed,  4 Nov 2020 15:21:50 +0000 (UTC)
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
Subject: [PULL 30/33] util/vfio-helpers: Trace where BARs are mapped
Date:   Wed,  4 Nov 2020 15:18:25 +0000
Message-Id: <20201104151828.405824-31-stefanha@redhat.com>
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
YnVnZ2luZyBwdXJwb3NlLCB0cmFjZSB3aGVyZSBhIEJBUiBpcyBtYXBwZWQuCgpSZXZpZXdlZC1i
eTogRmFtIFpoZW5nIDxmYW1AZXVwaG9uLm5ldD4KUmV2aWV3ZWQtYnk6IFN0ZWZhbiBIYWpub2N6
aSA8c3RlZmFuaGFAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogUGhpbGlwcGUgTWF0aGlldS1E
YXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgpNZXNzYWdlLWlkOiAyMDIwMTEwMzAyMDczMy4yMzAz
MTQ4LTUtcGhpbG1kQHJlZGhhdC5jb20KU2lnbmVkLW9mZi1ieTogU3RlZmFuIEhham5vY3ppIDxz
dGVmYW5oYUByZWRoYXQuY29tPgpUZXN0ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVk
aGF0LmNvbT4KLS0tCiB1dGlsL3ZmaW8taGVscGVycy5jIHwgMiArKwogdXRpbC90cmFjZS1ldmVu
dHMgICB8IDEgKwogMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQg
YS91dGlsL3ZmaW8taGVscGVycy5jIGIvdXRpbC92ZmlvLWhlbHBlcnMuYwppbmRleCBjZDYyODdj
M2E5Li4yNzhjNTQ5MDJlIDEwMDY0NAotLS0gYS91dGlsL3ZmaW8taGVscGVycy5jCisrKyBiL3V0
aWwvdmZpby1oZWxwZXJzLmMKQEAgLTE2Niw2ICsxNjYsOCBAQCB2b2lkICpxZW11X3ZmaW9fcGNp
X21hcF9iYXIoUUVNVVZGSU9TdGF0ZSAqcywgaW50IGluZGV4LAogICAgIHAgPSBtbWFwKE5VTEws
IE1JTihzaXplLCBzLT5iYXJfcmVnaW9uX2luZm9baW5kZXhdLnNpemUgLSBvZmZzZXQpLAogICAg
ICAgICAgICAgIHByb3QsIE1BUF9TSEFSRUQsCiAgICAgICAgICAgICAgcy0+ZGV2aWNlLCBzLT5i
YXJfcmVnaW9uX2luZm9baW5kZXhdLm9mZnNldCArIG9mZnNldCk7CisgICAgdHJhY2VfcWVtdV92
ZmlvX3BjaV9tYXBfYmFyKGluZGV4LCBzLT5iYXJfcmVnaW9uX2luZm9baW5kZXhdLm9mZnNldCAs
CisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNpemUsIG9mZnNldCwgcCk7CiAgICAg
aWYgKHAgPT0gTUFQX0ZBSUxFRCkgewogICAgICAgICBlcnJvcl9zZXRnX2Vycm5vKGVycnAsIGVy
cm5vLCAiRmFpbGVkIHRvIG1hcCBCQVIgcmVnaW9uIik7CiAgICAgICAgIHAgPSBOVUxMOwpkaWZm
IC0tZ2l0IGEvdXRpbC90cmFjZS1ldmVudHMgYi91dGlsL3RyYWNlLWV2ZW50cwppbmRleCAwNzUz
ZTRhMGVkLi41MmQ0M2NkYTNmIDEwMDY0NAotLS0gYS91dGlsL3RyYWNlLWV2ZW50cworKysgYi91
dGlsL3RyYWNlLWV2ZW50cwpAQCAtODgsMyArODgsNCBAQCBxZW11X3ZmaW9fZG1hX3VubWFwKHZv
aWQgKnMsIHZvaWQgKmhvc3QpICJzICVwIGhvc3QgJXAiCiBxZW11X3ZmaW9fcGNpX3JlYWRfY29u
ZmlnKHZvaWQgKmJ1ZiwgaW50IG9mcywgaW50IHNpemUsIHVpbnQ2NF90IHJlZ2lvbl9vZnMsIHVp
bnQ2NF90IHJlZ2lvbl9zaXplKSAicmVhZCBjZmcgcHRyICVwIG9mcyAweCV4IHNpemUgMHgleCAo
cmVnaW9uIGFkZHIgMHglIlBSSXg2NCIgc2l6ZSAweCUiUFJJeDY0IikiCiBxZW11X3ZmaW9fcGNp
X3dyaXRlX2NvbmZpZyh2b2lkICpidWYsIGludCBvZnMsIGludCBzaXplLCB1aW50NjRfdCByZWdp
b25fb2ZzLCB1aW50NjRfdCByZWdpb25fc2l6ZSkgIndyaXRlIGNmZyBwdHIgJXAgb2ZzIDB4JXgg
c2l6ZSAweCV4IChyZWdpb24gYWRkciAweCUiUFJJeDY0IiBzaXplIDB4JSJQUkl4NjQiKSIKIHFl
bXVfdmZpb19yZWdpb25faW5mbyhjb25zdCBjaGFyICpkZXNjLCB1aW50NjRfdCByZWdpb25fb2Zz
LCB1aW50NjRfdCByZWdpb25fc2l6ZSwgdWludDMyX3QgY2FwX29mZnNldCkgInJlZ2lvbiAnJXMn
IGFkZHIgMHglIlBSSXg2NCIgc2l6ZSAweCUiUFJJeDY0IiBjYXBfb2ZzIDB4JSJQUkl4MzIKK3Fl
bXVfdmZpb19wY2lfbWFwX2JhcihpbnQgaW5kZXgsIHVpbnQ2NF90IHJlZ2lvbl9vZnMsIHVpbnQ2
NF90IHJlZ2lvbl9zaXplLCBpbnQgb2ZzLCB2b2lkICpob3N0KSAibWFwIHJlZ2lvbiBiYXIjJWQg
YWRkciAweCUiUFJJeDY0IiBzaXplIDB4JSJQUkl4NjQiIG9mcyAweCV4IGhvc3QgJXAiCi0tIAoy
LjI4LjAKCg==

