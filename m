Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728C12A6751
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgKDPT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:19:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726919AbgKDPTZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:19:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BjM2kasnawtpzgGpfjhWZ6lqZjslto+EambDgfSaRbc=;
        b=KAmRNmSa47ygBm6QRm83pK/YbYFP/rfHGvimrg5s1VxbokBOygyyAFc9hb6Bi53Oga9ePz
        vLo2L3YimKiQvX4BiKC+uSPjvoBAosjdkjXAHmcXT2RA0TzER9WAf2x6qLeQpSPSErEuJt
        9puac/qpyb0L6M24rQmW5iodjy/xRX8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-65iT7XPcNveu--tHGxoDQg-1; Wed, 04 Nov 2020 10:19:19 -0500
X-MC-Unique: 65iT7XPcNveu--tHGxoDQg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 884858015A3;
        Wed,  4 Nov 2020 15:19:17 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C78A45D9CC;
        Wed,  4 Nov 2020 15:19:10 +0000 (UTC)
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
Subject: [PULL 06/33] block/nvme: Trace controller capabilities
Date:   Wed,  4 Nov 2020 15:18:01 +0000
Message-Id: <20201104151828.405824-7-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKQ29udHJv
bGxlcnMgaGF2ZSBkaWZmZXJlbnQgY2FwYWJpbGl0aWVzIGFuZCByZXBvcnQgdGhlbSBpbiB0aGUK
Q0FQIHJlZ2lzdGVyLiBXZSBhcmUgcGFydGljdWxhcmx5IGludGVyZXN0ZWQgYnkgdGhlIHBhZ2Ug
c2l6ZQpsaW1pdHMuCgpSZXZpZXdlZC1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUByZWRo
YXQuY29tPgpSZXZpZXdlZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgpU
ZXN0ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1i
eTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgpNZXNzYWdlLWlk
OiAyMDIwMTAyOTA5MzMwNi4xMDYzODc5LTUtcGhpbG1kQHJlZGhhdC5jb20KU2lnbmVkLW9mZi1i
eTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUByZWRoYXQuY29tPgpUZXN0ZWQtYnk6IEVyaWMg
QXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KLS0tCiBibG9jay9udm1lLmMgICAgICAgfCAx
MyArKysrKysrKysrKysrCiBibG9jay90cmFjZS1ldmVudHMgfCAgMiArKwogMiBmaWxlcyBjaGFu
Z2VkLCAxNSBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvYmxvY2svbnZtZS5jIGIvYmxvY2sv
bnZtZS5jCmluZGV4IDZmMWQ3ZjliMmEuLjM2MWI1NzcyYjcgMTAwNjQ0Ci0tLSBhL2Jsb2NrL252
bWUuYworKysgYi9ibG9jay9udm1lLmMKQEAgLTcyNyw2ICs3MjcsMTkgQEAgc3RhdGljIGludCBu
dm1lX2luaXQoQmxvY2tEcml2ZXJTdGF0ZSAqYnMsIGNvbnN0IGNoYXIgKmRldmljZSwgaW50IG5h
bWVzcGFjZSwKICAgICAgKiBJbml0aWFsaXphdGlvbiIuICovCiAKICAgICBjYXAgPSBsZTY0X3Rv
X2NwdShyZWdzLT5jYXApOworICAgIHRyYWNlX252bWVfY29udHJvbGxlcl9jYXBhYmlsaXR5X3Jh
dyhjYXApOworICAgIHRyYWNlX252bWVfY29udHJvbGxlcl9jYXBhYmlsaXR5KCJNYXhpbXVtIFF1
ZXVlIEVudHJpZXMgU3VwcG9ydGVkIiwKKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAxICsgTlZNRV9DQVBfTVFFUyhjYXApKTsKKyAgICB0cmFjZV9udm1lX2NvbnRyb2xsZXJf
Y2FwYWJpbGl0eSgiQ29udGlndW91cyBRdWV1ZXMgUmVxdWlyZWQiLAorICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIE5WTUVfQ0FQX0NRUihjYXApKTsKKyAgICB0cmFjZV9udm1l
X2NvbnRyb2xsZXJfY2FwYWJpbGl0eSgiRG9vcmJlbGwgU3RyaWRlIiwKKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAyIDw8ICgyICsgTlZNRV9DQVBfRFNUUkQoY2FwKSkpOwor
ICAgIHRyYWNlX252bWVfY29udHJvbGxlcl9jYXBhYmlsaXR5KCJTdWJzeXN0ZW0gUmVzZXQgU3Vw
cG9ydGVkIiwKKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBOVk1FX0NBUF9O
U1NSUyhjYXApKTsKKyAgICB0cmFjZV9udm1lX2NvbnRyb2xsZXJfY2FwYWJpbGl0eSgiTWVtb3J5
IFBhZ2UgU2l6ZSBNaW5pbXVtIiwKKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAxIDw8ICgxMiArIE5WTUVfQ0FQX01QU01JTihjYXApKSk7CisgICAgdHJhY2VfbnZtZV9jb250
cm9sbGVyX2NhcGFiaWxpdHkoIk1lbW9yeSBQYWdlIFNpemUgTWF4aW11bSIsCisgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgMSA8PCAoMTIgKyBOVk1FX0NBUF9NUFNNQVgoY2Fw
KSkpOwogICAgIGlmICghTlZNRV9DQVBfQ1NTKGNhcCkpIHsKICAgICAgICAgZXJyb3Jfc2V0Zyhl
cnJwLCAiRGV2aWNlIGRvZXNuJ3Qgc3VwcG9ydCBOVk1lIGNvbW1hbmQgc2V0Iik7CiAgICAgICAg
IHJldCA9IC1FSU5WQUw7CmRpZmYgLS1naXQgYS9ibG9jay90cmFjZS1ldmVudHMgYi9ibG9jay90
cmFjZS1ldmVudHMKaW5kZXggMDk1NWM4NWM3OC4uYjkwYjA3YjE1ZiAxMDA2NDQKLS0tIGEvYmxv
Y2svdHJhY2UtZXZlbnRzCisrKyBiL2Jsb2NrL3RyYWNlLWV2ZW50cwpAQCAtMTM0LDYgKzEzNCw4
IEBAIHFlZF9haW9fd3JpdGVfcG9zdGZpbGwodm9pZCAqcywgdm9pZCAqYWNiLCB1aW50NjRfdCBz
dGFydCwgc2l6ZV90IGxlbiwgdWludDY0X3QKIHFlZF9haW9fd3JpdGVfbWFpbih2b2lkICpzLCB2
b2lkICphY2IsIGludCByZXQsIHVpbnQ2NF90IG9mZnNldCwgc2l6ZV90IGxlbikgInMgJXAgYWNi
ICVwIHJldCAlZCBvZmZzZXQgJSJQUkl1NjQiIGxlbiAlenUiCiAKICMgbnZtZS5jCitudm1lX2Nv
bnRyb2xsZXJfY2FwYWJpbGl0eV9yYXcodWludDY0X3QgdmFsdWUpICIweCUwOCJQUkl4NjQKK252
bWVfY29udHJvbGxlcl9jYXBhYmlsaXR5KGNvbnN0IGNoYXIgKmRlc2MsIHVpbnQ2NF90IHZhbHVl
KSAiJXM6ICUiUFJJdTY0CiBudm1lX2tpY2sodm9pZCAqcywgaW50IHF1ZXVlKSAicyAlcCBxdWV1
ZSAlZCIKIG52bWVfZG1hX2ZsdXNoX3F1ZXVlX3dhaXQodm9pZCAqcykgInMgJXAiCiBudm1lX2Vy
cm9yKGludCBjbWRfc3BlY2lmaWMsIGludCBzcV9oZWFkLCBpbnQgc3FpZCwgaW50IGNpZCwgaW50
IHN0YXR1cykgImNtZF9zcGVjaWZpYyAlZCBzcV9oZWFkICVkIHNxaWQgJWQgY2lkICVkIHN0YXR1
cyAweCV4IgotLSAKMi4yOC4wCgo=

