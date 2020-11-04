Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DCA2A6766
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbgKDPUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:20:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730663AbgKDPUq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:20:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hBGbTbP0mIaJCRUrfStVTozZGOjxjeHijDHeNpd3GaM=;
        b=OW61n5OPv7rZ9GIGJ2pi7BV4cERRy5MuPWJ0vIv76teU2GJpE85AtVNSoO8pdJt9/fgXX6
        HD0y8KoaQVoG3ndYIXicjVpjH35YPh3wGvKGhwi+jjlPrqV5PLYgkoanOEd4K+NVjGgvI0
        IXtbPAVIZylG0MSYgCqgsLjdwDzCfSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-CBk2r6niPzOef1cOM25H6Q-1; Wed, 04 Nov 2020 10:20:43 -0500
X-MC-Unique: CBk2r6niPzOef1cOM25H6Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA7D96D582;
        Wed,  4 Nov 2020 15:20:40 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2EE65D9CC;
        Wed,  4 Nov 2020 15:20:36 +0000 (UTC)
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
Subject: [PULL 17/33] block/nvme: Simplify ADMIN queue access
Date:   Wed,  4 Nov 2020 15:18:12 +0000
Message-Id: <20201104151828.405824-18-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKV2UgZG9u
J3QgbmVlZCB0byBkZXJlZmVyZW5jZSBmcm9tIEJEUlZOVk1lU3RhdGUgZWFjaCB0aW1lLgpVc2Ug
YSBOVk1lUXVldWVQYWlyIHBvaW50ZXIgb24gdGhlIGFkbWluIHF1ZXVlLgpUaGUgbnZtZV9pbml0
KCkgYmVjb21lcyBlYXNpZXIgdG8gcmV2aWV3LCBtYXRjaGluZyB0aGUgc3R5bGUKb2YgbnZtZV9h
ZGRfaW9fcXVldWUoKS4KClJldmlld2VkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhh
dC5jb20+ClJldmlld2VkLWJ5OiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+
ClRlc3RlZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgpTaWduZWQtb2Zm
LWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1kQHJlZGhhdC5jb20+Ck1lc3NhZ2Ut
aWQ6IDIwMjAxMDI5MDkzMzA2LjEwNjM4NzktMTYtcGhpbG1kQHJlZGhhdC5jb20KU2lnbmVkLW9m
Zi1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUByZWRoYXQuY29tPgpUZXN0ZWQtYnk6IEVy
aWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KLS0tCiBibG9jay9udm1lLmMgfCAxMiAr
KysrKystLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvYmxvY2svbnZtZS5jIGIvYmxvY2svbnZtZS5jCmluZGV4IDA5MDJh
YTU1NDIuLmVlZDEyZjQ5MzMgMTAwNjQ0Ci0tLSBhL2Jsb2NrL252bWUuYworKysgYi9ibG9jay9u
dm1lLmMKQEAgLTcwMCw2ICs3MDAsNyBAQCBzdGF0aWMgaW50IG52bWVfaW5pdChCbG9ja0RyaXZl
clN0YXRlICpicywgY29uc3QgY2hhciAqZGV2aWNlLCBpbnQgbmFtZXNwYWNlLAogICAgICAgICAg
ICAgICAgICAgICAgRXJyb3IgKiplcnJwKQogewogICAgIEJEUlZOVk1lU3RhdGUgKnMgPSBicy0+
b3BhcXVlOworICAgIE5WTWVRdWV1ZVBhaXIgKnE7CiAgICAgQWlvQ29udGV4dCAqYWlvX2NvbnRl
eHQgPSBiZHJ2X2dldF9haW9fY29udGV4dChicyk7CiAgICAgaW50IHJldDsKICAgICB1aW50NjRf
dCBjYXA7CkBAIC03ODEsMTkgKzc4MiwxOCBAQCBzdGF0aWMgaW50IG52bWVfaW5pdChCbG9ja0Ry
aXZlclN0YXRlICpicywgY29uc3QgY2hhciAqZGV2aWNlLCBpbnQgbmFtZXNwYWNlLAogCiAgICAg
LyogU2V0IHVwIGFkbWluIHF1ZXVlLiAqLwogICAgIHMtPnF1ZXVlcyA9IGdfbmV3KE5WTWVRdWV1
ZVBhaXIgKiwgMSk7Ci0gICAgcy0+cXVldWVzW0lOREVYX0FETUlOXSA9IG52bWVfY3JlYXRlX3F1
ZXVlX3BhaXIocywgYWlvX2NvbnRleHQsIDAsCi0gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgTlZNRV9RVUVVRV9TSVpFLAotICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVycnApOwot
ICAgIGlmICghcy0+cXVldWVzW0lOREVYX0FETUlOXSkgeworICAgIHEgPSBudm1lX2NyZWF0ZV9x
dWV1ZV9wYWlyKHMsIGFpb19jb250ZXh0LCAwLCBOVk1FX1FVRVVFX1NJWkUsIGVycnApOworICAg
IGlmICghcSkgewogICAgICAgICByZXQgPSAtRUlOVkFMOwogICAgICAgICBnb3RvIG91dDsKICAg
ICB9CisgICAgcy0+cXVldWVzW0lOREVYX0FETUlOXSA9IHE7CiAgICAgcy0+cXVldWVfY291bnQg
PSAxOwogICAgIFFFTVVfQlVJTERfQlVHX09OKChOVk1FX1FVRVVFX1NJWkUgLSAxKSAmIDB4RjAw
MCk7CiAgICAgcmVncy0+YXFhID0gY3B1X3RvX2xlMzIoKChOVk1FX1FVRVVFX1NJWkUgLSAxKSA8
PCBBUUFfQUNRU19TSElGVCkgfAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICgoTlZNRV9R
VUVVRV9TSVpFIC0gMSkgPDwgQVFBX0FTUVNfU0hJRlQpKTsKLSAgICByZWdzLT5hc3EgPSBjcHVf
dG9fbGU2NChzLT5xdWV1ZXNbSU5ERVhfQURNSU5dLT5zcS5pb3ZhKTsKLSAgICByZWdzLT5hY3Eg
PSBjcHVfdG9fbGU2NChzLT5xdWV1ZXNbSU5ERVhfQURNSU5dLT5jcS5pb3ZhKTsKKyAgICByZWdz
LT5hc3EgPSBjcHVfdG9fbGU2NChxLT5zcS5pb3ZhKTsKKyAgICByZWdzLT5hY3EgPSBjcHVfdG9f
bGU2NChxLT5jcS5pb3ZhKTsKIAogICAgIC8qIEFmdGVyIHNldHRpbmcgdXAgYWxsIGNvbnRyb2wg
cmVnaXN0ZXJzIHdlIGNhbiBlbmFibGUgZGV2aWNlIG5vdy4gKi8KICAgICByZWdzLT5jYyA9IGNw
dV90b19sZTMyKChjdHozMihOVk1FX0NRX0VOVFJZX0JZVEVTKSA8PCBDQ19JT0NRRVNfU0hJRlQp
IHwKLS0gCjIuMjguMAoK

