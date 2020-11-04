Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F292A676B
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbgKDPU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:20:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729457AbgKDPU6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:20:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dHvoV2B3WQz+lxhYN6O++y+eS6CLPSgx/ZnTCxfcSRc=;
        b=AqkvnK0uOfdLSpHBJEboev0a46sCgxtNMmrzGbnqtyMkrqfR82zda08/79D0jL09NDVJ1t
        CRann+98mBQ+XSdA/vSMI2d2hF0lDy3760ffTJUsLe7ij410dJ2yz/uz44g03erIP+A1vt
        RwSOodwWDZqY8dNKCiP1ZssvNRQllQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-01OgfL0VPa6UVujx8NoT_w-1; Wed, 04 Nov 2020 10:20:53 -0500
X-MC-Unique: 01OgfL0VPa6UVujx8NoT_w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D41C16D58E;
        Wed,  4 Nov 2020 15:20:51 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D0B161177;
        Wed,  4 Nov 2020 15:20:45 +0000 (UTC)
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
Subject: [PULL 20/33] block/nvme: Correct minimum device page size
Date:   Wed,  4 Nov 2020 15:18:15 +0000
Message-Id: <20201104151828.405824-21-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKV2hpbGUg
dHJ5aW5nIHRvIHNpbXBsaWZ5IHRoZSBjb2RlIHVzaW5nIGEgbWFjcm8sIHdlIGZvcmdvdAp0aGUg
MTItYml0IHNoaWZ0Li4uIENvcnJlY3QgdGhhdC4KCkZpeGVzOiBmYWQxZWI2ODg2MiAoImJsb2Nr
L252bWU6IFVzZSByZWdpc3RlciBkZWZpbml0aW9ucyBmcm9tICdibG9jay9udm1lLmgnIikKUmVw
b3J0ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KUmV2aWV3ZWQtYnk6
IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0LmNvbT4KUmV2aWV3ZWQtYnk6IEVyaWMg
QXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KVGVzdGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmlj
LmF1Z2VyQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOp
IDxwaGlsbWRAcmVkaGF0LmNvbT4KTWVzc2FnZS1pZDogMjAyMDEwMjkwOTMzMDYuMTA2Mzg3OS0x
OS1waGlsbWRAcmVkaGF0LmNvbQpTaWduZWQtb2ZmLWJ5OiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZh
bmhhQHJlZGhhdC5jb20+ClRlc3RlZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQu
Y29tPgotLS0KIGJsb2NrL252bWUuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2Jsb2NrL252bWUuYyBiL2Jsb2NrL252
bWUuYwppbmRleCBiYjc1NDQ4YTA5Li5iZDM4NjBhYzRlIDEwMDY0NAotLS0gYS9ibG9jay9udm1l
LmMKKysrIGIvYmxvY2svbnZtZS5jCkBAIC03NTUsNyArNzU1LDcgQEAgc3RhdGljIGludCBudm1l
X2luaXQoQmxvY2tEcml2ZXJTdGF0ZSAqYnMsIGNvbnN0IGNoYXIgKmRldmljZSwgaW50IG5hbWVz
cGFjZSwKICAgICAgICAgZ290byBvdXQ7CiAgICAgfQogCi0gICAgcy0+cGFnZV9zaXplID0gTUFY
KDQwOTYsIDEgPDwgTlZNRV9DQVBfTVBTTUlOKGNhcCkpOworICAgIHMtPnBhZ2Vfc2l6ZSA9IDF1
IDw8ICgxMiArIE5WTUVfQ0FQX01QU01JTihjYXApKTsKICAgICBzLT5kb29yYmVsbF9zY2FsZSA9
ICg0IDw8IE5WTUVfQ0FQX0RTVFJEKGNhcCkpIC8gc2l6ZW9mKHVpbnQzMl90KTsKICAgICBicy0+
Ymwub3B0X21lbV9hbGlnbm1lbnQgPSBzLT5wYWdlX3NpemU7CiAgICAgYnMtPmJsLnJlcXVlc3Rf
YWxpZ25tZW50ID0gcy0+cGFnZV9zaXplOwotLSAKMi4yOC4wCgo=

