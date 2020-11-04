Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124EC2A6759
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730561AbgKDPUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:20:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43331 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730473AbgKDPUH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:20:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vc0NwBAYp9PUVSZXf09QtzF61OX71oHpVzROsVcIOQc=;
        b=bg8dh0Ig3yyJ8m5rFOUVAvS++CqX0mc+7e4qzOVxn6DhVGl5/Wxdt/uc+D4bPkpwQnpb99
        Dae/AyOX3UHxIzcLvMY6hLWoqeZZTI7Gp7eiJL7jcmIybF3H/rL2ZxdJkt2YCtnwsXk1uQ
        MZtREZwymtrrA1lXyUVg35DLkxtIqYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-hX5bbP4SPmK680cQBQNzkg-1; Wed, 04 Nov 2020 10:20:04 -0500
X-MC-Unique: hX5bbP4SPmK680cQBQNzkg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 768F4186DD25;
        Wed,  4 Nov 2020 15:20:02 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D297319D61;
        Wed,  4 Nov 2020 15:19:55 +0000 (UTC)
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
Subject: [PULL 12/33] block/nvme: Make nvme_identify() return boolean indicating error
Date:   Wed,  4 Nov 2020 15:18:07 +0000
Message-Id: <20201104151828.405824-13-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKSnVzdCBm
b3IgY29uc2lzdGVuY3ksIGZvbGxvd2luZyB0aGUgZXhhbXBsZSBkb2N1bWVudGVkIHNpbmNlCmNv
bW1pdCBlM2ZlMzk4OGQ3ICgiZXJyb3I6IERvY3VtZW50IEVycm9yIEFQSSB1c2FnZSBydWxlcyIp
LApyZXR1cm4gYSBib29sZWFuIHZhbHVlIGluZGljYXRpbmcgYW4gZXJyb3IgaXMgc2V0IG9yIG5v
dC4KRGlyZWN0bHkgcGFzcyBlcnJwIGFzIHRoZSBsb2NhbF9lcnIgaXMgbm90IHJlcXVlc3RlZCBp
biBvdXIKY2FzZS4KClRlc3RlZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29t
PgpTaWduZWQtb2ZmLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1kQHJlZGhhdC5j
b20+ClJldmlld2VkLWJ5OiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+Ck1l
c3NhZ2UtaWQ6IDIwMjAxMDI5MDkzMzA2LjEwNjM4NzktMTEtcGhpbG1kQHJlZGhhdC5jb20KU2ln
bmVkLW9mZi1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUByZWRoYXQuY29tPgpUZXN0ZWQt
Ynk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KLS0tCiBibG9jay9udm1lLmMg
fCAxMiArKysrKysrLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDUgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYmxvY2svbnZtZS5jIGIvYmxvY2svbnZtZS5jCmluZGV4
IGM0NTA0OTkxMTEuLjk4MzM1MDEyNDUgMTAwNjQ0Ci0tLSBhL2Jsb2NrL252bWUuYworKysgYi9i
bG9jay9udm1lLmMKQEAgLTUwNiw5ICs1MDYsMTEgQEAgc3RhdGljIGludCBudm1lX2NtZF9zeW5j
KEJsb2NrRHJpdmVyU3RhdGUgKmJzLCBOVk1lUXVldWVQYWlyICpxLAogICAgIHJldHVybiByZXQ7
CiB9CiAKLXN0YXRpYyB2b2lkIG52bWVfaWRlbnRpZnkoQmxvY2tEcml2ZXJTdGF0ZSAqYnMsIGlu
dCBuYW1lc3BhY2UsIEVycm9yICoqZXJycCkKKy8qIFJldHVybnMgdHJ1ZSBvbiBzdWNjZXNzLCBm
YWxzZSBvbiBmYWlsdXJlLiAqLworc3RhdGljIGJvb2wgbnZtZV9pZGVudGlmeShCbG9ja0RyaXZl
clN0YXRlICpicywgaW50IG5hbWVzcGFjZSwgRXJyb3IgKiplcnJwKQogewogICAgIEJEUlZOVk1l
U3RhdGUgKnMgPSBicy0+b3BhcXVlOworICAgIGJvb2wgcmV0ID0gZmFsc2U7CiAgICAgdW5pb24g
ewogICAgICAgICBOdm1lSWRDdHJsIGN0cmw7CiAgICAgICAgIE52bWVJZE5zIG5zOwpAQCAtNTg1
LDEwICs1ODcsMTMgQEAgc3RhdGljIHZvaWQgbnZtZV9pZGVudGlmeShCbG9ja0RyaXZlclN0YXRl
ICpicywgaW50IG5hbWVzcGFjZSwgRXJyb3IgKiplcnJwKQogICAgICAgICBnb3RvIG91dDsKICAg
ICB9CiAKKyAgICByZXQgPSB0cnVlOwogICAgIHMtPmJsa3NoaWZ0ID0gbGJhZi0+ZHM7CiBvdXQ6
CiAgICAgcWVtdV92ZmlvX2RtYV91bm1hcChzLT52ZmlvLCBpZCk7CiAgICAgcWVtdV92ZnJlZShp
ZCk7CisKKyAgICByZXR1cm4gcmV0OwogfQogCiBzdGF0aWMgYm9vbCBudm1lX3BvbGxfcXVldWUo
TlZNZVF1ZXVlUGFpciAqcSkKQEAgLTcwMSw3ICs3MDYsNiBAQCBzdGF0aWMgaW50IG52bWVfaW5p
dChCbG9ja0RyaXZlclN0YXRlICpicywgY29uc3QgY2hhciAqZGV2aWNlLCBpbnQgbmFtZXNwYWNl
LAogICAgIHVpbnQ2NF90IGNhcDsKICAgICB1aW50NjRfdCB0aW1lb3V0X21zOwogICAgIHVpbnQ2
NF90IGRlYWRsaW5lLCBub3c7Ci0gICAgRXJyb3IgKmxvY2FsX2VyciA9IE5VTEw7CiAgICAgdm9s
YXRpbGUgTnZtZUJhciAqcmVncyA9IE5VTEw7CiAKICAgICBxZW11X2NvX211dGV4X2luaXQoJnMt
PmRtYV9tYXBfbG9jayk7CkBAIC04MTgsOSArODIyLDcgQEAgc3RhdGljIGludCBudm1lX2luaXQo
QmxvY2tEcml2ZXJTdGF0ZSAqYnMsIGNvbnN0IGNoYXIgKmRldmljZSwgaW50IG5hbWVzcGFjZSwK
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICZzLT5pcnFfbm90aWZpZXJbTVNJWF9TSEFSRURf
SVJRX0lEWF0sCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBmYWxzZSwgbnZtZV9oYW5kbGVf
ZXZlbnQsIG52bWVfcG9sbF9jYik7CiAKLSAgICBudm1lX2lkZW50aWZ5KGJzLCBuYW1lc3BhY2Us
ICZsb2NhbF9lcnIpOwotICAgIGlmIChsb2NhbF9lcnIpIHsKLSAgICAgICAgZXJyb3JfcHJvcGFn
YXRlKGVycnAsIGxvY2FsX2Vycik7CisgICAgaWYgKCFudm1lX2lkZW50aWZ5KGJzLCBuYW1lc3Bh
Y2UsIGVycnApKSB7CiAgICAgICAgIHJldCA9IC1FSU87CiAgICAgICAgIGdvdG8gb3V0OwogICAg
IH0KLS0gCjIuMjguMAoK

