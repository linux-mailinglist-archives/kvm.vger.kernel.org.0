Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271B52A6771
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbgKDPVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:21:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730688AbgKDPV2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:21:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSFT8eKoJ5cQvPnVenZnrvLMn9Hkughdr5Pbtm2yll8=;
        b=a7bEg/lmthLKixbYltYzsWAkcqB2HUoISGaEZjqE0EGwBj+e2rUMMqo11jnPrzxfE7mJ7g
        uDdssatDgB9px2T9bjaOdMKhKozl57hSyAqFDMtt6IWlsttM2yPo0iIk7bq5N36CQytb28
        DZhgf7ldtUCcX8vP0fJ7XtUkrcbIKcc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-bkBbB6DNPnSSnH2ZIfDPwA-1; Wed, 04 Nov 2020 10:21:22 -0500
X-MC-Unique: bkBbB6DNPnSSnH2ZIfDPwA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 601CC101F012;
        Wed,  4 Nov 2020 15:21:20 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DE865C3E1;
        Wed,  4 Nov 2020 15:21:14 +0000 (UTC)
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
Subject: [PULL 25/33] block/nvme: Fix use of write-only doorbells page on Aarch64 arch
Date:   Wed,  4 Nov 2020 15:18:20 +0000
Message-Id: <20201104151828.405824-26-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKcWVtdV92
ZmlvX3BjaV9tYXBfYmFyKCkgY2FsbHMgbW1hcCgpLCBhbmQgbW1hcCgyKSBzdGF0ZXM6CgogICdv
ZmZzZXQnIG11c3QgYmUgYSBtdWx0aXBsZSBvZiB0aGUgcGFnZSBzaXplIGFzIHJldHVybmVkCiAg
IGJ5IHN5c2NvbmYoX1NDX1BBR0VfU0laRSkuCgpJbiBjb21taXQgZjY4NDUzMjM3Yjkgd2Ugc3Rh
cnRlZCB0byB1c2UgYW4gb2Zmc2V0IG9mIDRLIHdoaWNoCmJyb2tlIHRoaXMgY29udHJhY3Qgb24g
QWFyY2g2NCBhcmNoLgoKRml4IGJ5IG1hcHBpbmcgYXQgb2Zmc2V0IDAsIGFuZCBhbmQgYWNjZXNz
aW5nIGRvb3JiZWxscyBhdCBvZmZzZXQ9NEsuCgpGaXhlczogZjY4NDUzMjM3YjkgKCJibG9jay9u
dm1lOiBNYXAgZG9vcmJlbGxzIHBhZ2VzIHdyaXRlLW9ubHkiKQpSZXBvcnRlZC1ieTogRXJpYyBB
dWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogRXJpYyBBdWdlciA8ZXJp
Yy5hdWdlckByZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5o
YUByZWRoYXQuY29tPgpUZXN0ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNv
bT4KU2lnbmVkLW9mZi1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQu
Y29tPgpNZXNzYWdlLWlkOiAyMDIwMTAyOTA5MzMwNi4xMDYzODc5LTI0LXBoaWxtZEByZWRoYXQu
Y29tClNpZ25lZC1vZmYtYnk6IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0LmNvbT4K
VGVzdGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Ci0tLQogYmxvY2sv
bnZtZS5jIHwgMTEgKysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyks
IDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYmxvY2svbnZtZS5jIGIvYmxvY2svbnZtZS5j
CmluZGV4IGYxZTJmZDM0Y2QuLmM4ZWY2OWNiYjIgMTAwNjQ0Ci0tLSBhL2Jsb2NrL252bWUuYwor
KysgYi9ibG9jay9udm1lLmMKQEAgLTk0LDYgKzk0LDcgQEAgdHlwZWRlZiBzdHJ1Y3Qgewogc3Ry
dWN0IEJEUlZOVk1lU3RhdGUgewogICAgIEFpb0NvbnRleHQgKmFpb19jb250ZXh0OwogICAgIFFF
TVVWRklPU3RhdGUgKnZmaW87CisgICAgdm9pZCAqYmFyMF93b19tYXA7CiAgICAgLyogTWVtb3J5
IG1hcHBlZCByZWdpc3RlcnMgKi8KICAgICB2b2xhdGlsZSBzdHJ1Y3QgewogICAgICAgICB1aW50
MzJfdCBzcV90YWlsOwpAQCAtNzc3LDggKzc3OCwxMCBAQCBzdGF0aWMgaW50IG52bWVfaW5pdChC
bG9ja0RyaXZlclN0YXRlICpicywgY29uc3QgY2hhciAqZGV2aWNlLCBpbnQgbmFtZXNwYWNlLAog
ICAgICAgICB9CiAgICAgfQogCi0gICAgcy0+ZG9vcmJlbGxzID0gcWVtdV92ZmlvX3BjaV9tYXBf
YmFyKHMtPnZmaW8sIDAsIHNpemVvZihOdm1lQmFyKSwKLSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgTlZNRV9ET09SQkVMTF9TSVpFLCBQUk9UX1dSSVRFLCBlcnJwKTsK
KyAgICBzLT5iYXIwX3dvX21hcCA9IHFlbXVfdmZpb19wY2lfbWFwX2JhcihzLT52ZmlvLCAwLCAw
LAorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNpemVvZihOdm1l
QmFyKSArIE5WTUVfRE9PUkJFTExfU0laRSwKKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBQUk9UX1dSSVRFLCBlcnJwKTsKKyAgICBzLT5kb29yYmVsbHMgPSAodm9p
ZCAqKSgodWludHB0cl90KXMtPmJhcjBfd29fbWFwICsgc2l6ZW9mKE52bWVCYXIpKTsKICAgICBp
ZiAoIXMtPmRvb3JiZWxscykgewogICAgICAgICByZXQgPSAtRUlOVkFMOwogICAgICAgICBnb3Rv
IG91dDsKQEAgLTkxMCw4ICs5MTMsOCBAQCBzdGF0aWMgdm9pZCBudm1lX2Nsb3NlKEJsb2NrRHJp
dmVyU3RhdGUgKmJzKQogICAgICAgICAgICAgICAgICAgICAgICAgICAgJnMtPmlycV9ub3RpZmll
cltNU0lYX1NIQVJFRF9JUlFfSURYXSwKICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZhbHNl
LCBOVUxMLCBOVUxMKTsKICAgICBldmVudF9ub3RpZmllcl9jbGVhbnVwKCZzLT5pcnFfbm90aWZp
ZXJbTVNJWF9TSEFSRURfSVJRX0lEWF0pOwotICAgIHFlbXVfdmZpb19wY2lfdW5tYXBfYmFyKHMt
PnZmaW8sIDAsICh2b2lkICopcy0+ZG9vcmJlbGxzLAotICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHNpemVvZihOdm1lQmFyKSwgTlZNRV9ET09SQkVMTF9TSVpFKTsKKyAgICBxZW11X3ZmaW9f
cGNpX3VubWFwX2JhcihzLT52ZmlvLCAwLCBzLT5iYXIwX3dvX21hcCwKKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAwLCBzaXplb2YoTnZtZUJhcikgKyBOVk1FX0RPT1JCRUxMX1NJWkUpOwog
ICAgIHFlbXVfdmZpb19jbG9zZShzLT52ZmlvKTsKIAogICAgIGdfZnJlZShzLT5kZXZpY2UpOwot
LSAKMi4yOC4wCgo=

