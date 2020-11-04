Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A61F2A676C
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730441AbgKDPVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:21:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41033 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729457AbgKDPVF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:21:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EVT/KVUIXsVLz0AZTMnyWFtSTWyK78cI6I9B6y85dzw=;
        b=FONkG08nBE42vFXhR2mTq+KorL7qiLh4KU4pFJIpXUMSRAeReQQwePDtSIHNl73JZFcKz2
        VK/5ZaPt8pMh9/suX7cdpEEHNfPs1vRASvLemRgMNZysQQR/WpArvPNMcpikcG/9i5vp5G
        FTqzXfvAgSTpilPxcbmtvVL/tp1gnhQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-yHsa2DOeMlKFrkvklLmg4Q-1; Wed, 04 Nov 2020 10:21:02 -0500
X-MC-Unique: yHsa2DOeMlKFrkvklLmg4Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF55C809DEB;
        Wed,  4 Nov 2020 15:20:59 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D69310013D9;
        Wed,  4 Nov 2020 15:20:53 +0000 (UTC)
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
        Eric Auger <eric.auger@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PULL 21/33] block/nvme: Change size and alignment of IDENTIFY response buffer
Date:   Wed,  4 Nov 2020 15:18:16 +0000
Message-Id: <20201104151828.405824-22-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgoKSW4gcHJlcGFyYXRpb24g
b2YgNjRrQiBob3N0IHBhZ2Ugc3VwcG9ydCwgbGV0J3MgY2hhbmdlIHRoZSBzaXplCmFuZCBhbGln
bm1lbnQgb2YgdGhlIElERU5USUZZIGNvbW1hbmQgcmVzcG9uc2UgYnVmZmVyIHNvIHRoYXQKdGhl
IFZGSU8gRE1BIE1BUCBzdWNjZWVkcy4gV2UgYWxpZ24gb24gdGhlIGhvc3QgcGFnZSBzaXplLgoK
U2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgpSZXZpZXdl
ZC1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgpSZXZpZXdl
ZC1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUByZWRoYXQuY29tPgpUZXN0ZWQtYnk6IEVy
aWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogUGhpbGlwcGUg
TWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgpNZXNzYWdlLWlkOiAyMDIwMTAyOTA5
MzMwNi4xMDYzODc5LTIwLXBoaWxtZEByZWRoYXQuY29tClNpZ25lZC1vZmYtYnk6IFN0ZWZhbiBI
YWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0LmNvbT4KVGVzdGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmlj
LmF1Z2VyQHJlZGhhdC5jb20+Ci0tLQogYmxvY2svbnZtZS5jIHwgOSArKysrKy0tLS0KIDEgZmls
ZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
YmxvY2svbnZtZS5jIGIvYmxvY2svbnZtZS5jCmluZGV4IGJkMzg2MGFjNGUuLjc2Mjg2MjNjMDUg
MTAwNjQ0Ci0tLSBhL2Jsb2NrL252bWUuYworKysgYi9ibG9jay9udm1lLmMKQEAgLTUyMiwxOSAr
NTIyLDIwIEBAIHN0YXRpYyBib29sIG52bWVfaWRlbnRpZnkoQmxvY2tEcml2ZXJTdGF0ZSAqYnMs
IGludCBuYW1lc3BhY2UsIEVycm9yICoqZXJycCkKICAgICAgICAgLm9wY29kZSA9IE5WTUVfQURN
X0NNRF9JREVOVElGWSwKICAgICAgICAgLmNkdzEwID0gY3B1X3RvX2xlMzIoMHgxKSwKICAgICB9
OworICAgIHNpemVfdCBpZF9zaXplID0gUUVNVV9BTElHTl9VUChzaXplb2YoKmlkKSwgcWVtdV9y
ZWFsX2hvc3RfcGFnZV9zaXplKTsKIAotICAgIGlkID0gcWVtdV90cnlfbWVtYWxpZ24ocy0+cGFn
ZV9zaXplLCBzaXplb2YoKmlkKSk7CisgICAgaWQgPSBxZW11X3RyeV9tZW1hbGlnbihxZW11X3Jl
YWxfaG9zdF9wYWdlX3NpemUsIGlkX3NpemUpOwogICAgIGlmICghaWQpIHsKICAgICAgICAgZXJy
b3Jfc2V0ZyhlcnJwLCAiQ2Fubm90IGFsbG9jYXRlIGJ1ZmZlciBmb3IgaWRlbnRpZnkgcmVzcG9u
c2UiKTsKICAgICAgICAgZ290byBvdXQ7CiAgICAgfQotICAgIHIgPSBxZW11X3ZmaW9fZG1hX21h
cChzLT52ZmlvLCBpZCwgc2l6ZW9mKCppZCksIHRydWUsICZpb3ZhKTsKKyAgICByID0gcWVtdV92
ZmlvX2RtYV9tYXAocy0+dmZpbywgaWQsIGlkX3NpemUsIHRydWUsICZpb3ZhKTsKICAgICBpZiAo
cikgewogICAgICAgICBlcnJvcl9zZXRnKGVycnAsICJDYW5ub3QgbWFwIGJ1ZmZlciBmb3IgRE1B
Iik7CiAgICAgICAgIGdvdG8gb3V0OwogICAgIH0KIAotICAgIG1lbXNldChpZCwgMCwgc2l6ZW9m
KCppZCkpOworICAgIG1lbXNldChpZCwgMCwgaWRfc2l6ZSk7CiAgICAgY21kLmRwdHIucHJwMSA9
IGNwdV90b19sZTY0KGlvdmEpOwogICAgIGlmIChudm1lX2FkbWluX2NtZF9zeW5jKGJzLCAmY21k
KSkgewogICAgICAgICBlcnJvcl9zZXRnKGVycnAsICJGYWlsZWQgdG8gaWRlbnRpZnkgY29udHJv
bGxlciIpOwpAQCAtNTU2LDcgKzU1Nyw3IEBAIHN0YXRpYyBib29sIG52bWVfaWRlbnRpZnkoQmxv
Y2tEcml2ZXJTdGF0ZSAqYnMsIGludCBuYW1lc3BhY2UsIEVycm9yICoqZXJycCkKICAgICBzLT5z
dXBwb3J0c193cml0ZV96ZXJvZXMgPSAhIShvbmNzICYgTlZNRV9PTkNTX1dSSVRFX1pFUk9FUyk7
CiAgICAgcy0+c3VwcG9ydHNfZGlzY2FyZCA9ICEhKG9uY3MgJiBOVk1FX09OQ1NfRFNNKTsKIAot
ICAgIG1lbXNldChpZCwgMCwgc2l6ZW9mKCppZCkpOworICAgIG1lbXNldChpZCwgMCwgaWRfc2l6
ZSk7CiAgICAgY21kLmNkdzEwID0gMDsKICAgICBjbWQubnNpZCA9IGNwdV90b19sZTMyKG5hbWVz
cGFjZSk7CiAgICAgaWYgKG52bWVfYWRtaW5fY21kX3N5bmMoYnMsICZjbWQpKSB7Ci0tIAoyLjI4
LjAKCg==

