Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C03D2A6763
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbgKDPUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:20:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730162AbgKDPUj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:20:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/hVBkSqMuUr4UE/U0FuuYTYiQI3xMorwQO1VFLRTQk=;
        b=HTmWIDlzYOZ8gw+Nhk0DJWvJJB5xhe3YUjb6fCbvIxdqynAYtBJ7FLjIroynu7M8REgIfh
        fvRSSZYj7b3jsh60b4Z5W2GVxUx1IZ/OTitF5TZw29beJLn3S9XdGD6F2LCOhe6JR0qTuC
        5Bui1UeM99UwpYDYyTiabT9xZSlOzH8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-_CrcIWF9OiaBmOH8qWfZ2A-1; Wed, 04 Nov 2020 10:20:36 -0500
X-MC-Unique: _CrcIWF9OiaBmOH8qWfZ2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 231226D240;
        Wed,  4 Nov 2020 15:20:35 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCAB45DA76;
        Wed,  4 Nov 2020 15:20:27 +0000 (UTC)
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
Subject: [PULL 16/33] block/nvme: Correctly initialize Admin Queue Attributes
Date:   Wed,  4 Nov 2020 15:18:11 +0000
Message-Id: <20201104151828.405824-17-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKRnJvbSB0
aGUgc3BlY2lmaWNhdGlvbiBjaGFwdGVyIDMuMS44ICJBUUEgLSBBZG1pbiBRdWV1ZSBBdHRyaWJ1
dGVzIgp0aGUgQWRtaW4gU3VibWlzc2lvbiBRdWV1ZSBTaXplIGZpZWxkIGlzIGEgMOKAmXMgYmFz
ZWQgdmFsdWU6CgogIEFkbWluIFN1Ym1pc3Npb24gUXVldWUgU2l6ZSAoQVNRUyk6CgogICAgRGVm
aW5lcyB0aGUgc2l6ZSBvZiB0aGUgQWRtaW4gU3VibWlzc2lvbiBRdWV1ZSBpbiBlbnRyaWVzLgog
ICAgRW5hYmxpbmcgYSBjb250cm9sbGVyIHdoaWxlIHRoaXMgZmllbGQgaXMgY2xlYXJlZCB0byAw
MGgKICAgIHByb2R1Y2VzIHVuZGVmaW5lZCByZXN1bHRzLiBUaGUgbWluaW11bSBzaXplIG9mIHRo
ZSBBZG1pbgogICAgU3VibWlzc2lvbiBRdWV1ZSBpcyB0d28gZW50cmllcy4gVGhlIG1heGltdW0g
c2l6ZSBvZiB0aGUKICAgIEFkbWluIFN1Ym1pc3Npb24gUXVldWUgaXMgNDA5NiBlbnRyaWVzLgog
ICAgVGhpcyBpcyBhIDDigJlzIGJhc2VkIHZhbHVlLgoKVGhpcyBidWcgaGFzIG5ldmVyIGJlZW4g
aGl0IGJlY2F1c2UgdGhlIGRldmljZSBpbml0aWFsaXphdGlvbgp1c2VzIGEgc2luZ2xlIGNvbW1h
bmQgc3luY2hyb25vdXNseSA6KQoKUmV2aWV3ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJA
cmVkaGF0LmNvbT4KUmV2aWV3ZWQtYnk6IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0
LmNvbT4KVGVzdGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+ClNpZ25l
ZC1vZmYtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIDxwaGlsbWRAcmVkaGF0LmNvbT4KTWVz
c2FnZS1pZDogMjAyMDEwMjkwOTMzMDYuMTA2Mzg3OS0xNS1waGlsbWRAcmVkaGF0LmNvbQpTaWdu
ZWQtb2ZmLWJ5OiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+ClRlc3RlZC1i
eTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgotLS0KIGJsb2NrL252bWUuYyB8
IDYgKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2Jsb2NrL252bWUuYyBiL2Jsb2NrL252bWUuYwppbmRleCA3Mjg1YmQy
ZTI3Li4wOTAyYWE1NTQyIDEwMDY0NAotLS0gYS9ibG9jay9udm1lLmMKKysrIGIvYmxvY2svbnZt
ZS5jCkBAIC03ODksOSArNzg5LDkgQEAgc3RhdGljIGludCBudm1lX2luaXQoQmxvY2tEcml2ZXJT
dGF0ZSAqYnMsIGNvbnN0IGNoYXIgKmRldmljZSwgaW50IG5hbWVzcGFjZSwKICAgICAgICAgZ290
byBvdXQ7CiAgICAgfQogICAgIHMtPnF1ZXVlX2NvdW50ID0gMTsKLSAgICBRRU1VX0JVSUxEX0JV
R19PTihOVk1FX1FVRVVFX1NJWkUgJiAweEYwMDApOwotICAgIHJlZ3MtPmFxYSA9IGNwdV90b19s
ZTMyKChOVk1FX1FVRVVFX1NJWkUgPDwgQVFBX0FDUVNfU0hJRlQpIHwKLSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAoTlZNRV9RVUVVRV9TSVpFIDw8IEFRQV9BU1FTX1NISUZUKSk7CisgICAg
UUVNVV9CVUlMRF9CVUdfT04oKE5WTUVfUVVFVUVfU0laRSAtIDEpICYgMHhGMDAwKTsKKyAgICBy
ZWdzLT5hcWEgPSBjcHVfdG9fbGUzMigoKE5WTUVfUVVFVUVfU0laRSAtIDEpIDw8IEFRQV9BQ1FT
X1NISUZUKSB8CisgICAgICAgICAgICAgICAgICAgICAgICAgICAgKChOVk1FX1FVRVVFX1NJWkUg
LSAxKSA8PCBBUUFfQVNRU19TSElGVCkpOwogICAgIHJlZ3MtPmFzcSA9IGNwdV90b19sZTY0KHMt
PnF1ZXVlc1tJTkRFWF9BRE1JTl0tPnNxLmlvdmEpOwogICAgIHJlZ3MtPmFjcSA9IGNwdV90b19s
ZTY0KHMtPnF1ZXVlc1tJTkRFWF9BRE1JTl0tPmNxLmlvdmEpOwogCi0tIAoyLjI4LjAKCg==

