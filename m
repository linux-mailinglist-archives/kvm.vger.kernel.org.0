Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABB82A6781
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgKDPWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:22:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730435AbgKDPWM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:22:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1AFHdjTsEEWyU+9Ji73dICGnEMrarbV23JrcVT7tAvA=;
        b=AelltDVdVBK3HA3q1su9+SkEyqrYa+1590bwNqbmqv0oCteqUngLoE8EBE73Er3DvhdqO6
        clS/ZB3qo5PPJZNv2PgRrUksWN8rMBQxlSwB+AU+RUvW3PM4ucobz477yDbDl8H67FxqAb
        rh1BCeMu832YV0xUf1DYeSTzA4fXzPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-b6RACBuLMhOaRenmdG-Slg-1; Wed, 04 Nov 2020 10:22:09 -0500
X-MC-Unique: b6RACBuLMhOaRenmdG-Slg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B77081007284;
        Wed,  4 Nov 2020 15:22:07 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57AE360C84;
        Wed,  4 Nov 2020 15:22:07 +0000 (UTC)
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
Subject: [PULL 33/33] util/vfio-helpers: Assert offset is aligned to page size
Date:   Wed,  4 Nov 2020 15:18:28 +0000
Message-Id: <20201104151828.405824-34-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKbW1hcCgy
KSBzdGF0ZXM6CgogICdvZmZzZXQnIG11c3QgYmUgYSBtdWx0aXBsZSBvZiB0aGUgcGFnZSBzaXpl
IGFzIHJldHVybmVkCiAgIGJ5IHN5c2NvbmYoX1NDX1BBR0VfU0laRSkuCgpBZGQgYW4gYXNzZXJ0
aW9uIHRvIGJlIHN1cmUgd2UgZG9uJ3QgYnJlYWsgdGhpcyBjb250cmFjdC4KClNpZ25lZC1vZmYt
Ynk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIDxwaGlsbWRAcmVkaGF0LmNvbT4KTWVzc2FnZS1p
ZDogMjAyMDExMDMwMjA3MzMuMjMwMzE0OC04LXBoaWxtZEByZWRoYXQuY29tClNpZ25lZC1vZmYt
Ynk6IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0LmNvbT4KVGVzdGVkLWJ5OiBFcmlj
IEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Ci0tLQogdXRpbC92ZmlvLWhlbHBlcnMuYyB8
IDEgKwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCgpkaWZmIC0tZ2l0IGEvdXRpbC92
ZmlvLWhlbHBlcnMuYyBiL3V0aWwvdmZpby1oZWxwZXJzLmMKaW5kZXggNzNmN2JmYTc1NC4uODA0
NzY4ZDVjNiAxMDA2NDQKLS0tIGEvdXRpbC92ZmlvLWhlbHBlcnMuYworKysgYi91dGlsL3ZmaW8t
aGVscGVycy5jCkBAIC0xNjIsNiArMTYyLDcgQEAgdm9pZCAqcWVtdV92ZmlvX3BjaV9tYXBfYmFy
KFFFTVVWRklPU3RhdGUgKnMsIGludCBpbmRleCwKICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBFcnJvciAqKmVycnApCiB7CiAgICAgdm9pZCAqcDsKKyAgICBhc3NlcnQoUUVNVV9JU19BTElH
TkVEKG9mZnNldCwgcWVtdV9yZWFsX2hvc3RfcGFnZV9zaXplKSk7CiAgICAgYXNzZXJ0X2Jhcl9p
bmRleF92YWxpZChzLCBpbmRleCk7CiAgICAgcCA9IG1tYXAoTlVMTCwgTUlOKHNpemUsIHMtPmJh
cl9yZWdpb25faW5mb1tpbmRleF0uc2l6ZSAtIG9mZnNldCksCiAgICAgICAgICAgICAgcHJvdCwg
TUFQX1NIQVJFRCwKLS0gCjIuMjguMAoK

