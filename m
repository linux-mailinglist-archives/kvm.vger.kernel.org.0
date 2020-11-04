Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933FC2A676D
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgKDPVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:21:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55049 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730697AbgKDPVK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:21:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2tnggx0PjpW2FI/fnM212J+0RjWe6HBl7UPP21HCu48=;
        b=X84ORzymcVRTGkMkc5jpueTMAdvC++9SQ9jVEgBbDW0au9+C5KN4oCmLBnKm2U8Y1ZH6dO
        DxjciA+Y9v6CHx/W3IQqE+hw74pS0gIrtQBvQqUC7HdUOYXK9YUivThGbwo2Yeo3AQar39
        pc/ScjNUnNwwpz2oIgK5lE39TqXsvA0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588--2WqZDsTM-GgKXR0C3XS-g-1; Wed, 04 Nov 2020 10:21:06 -0500
X-MC-Unique: -2WqZDsTM-GgKXR0C3XS-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF218801F9A;
        Wed,  4 Nov 2020 15:21:03 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 732E060C84;
        Wed,  4 Nov 2020 15:21:01 +0000 (UTC)
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
Subject: [PULL 22/33] block/nvme: Change size and alignment of queue
Date:   Wed,  4 Nov 2020 15:18:17 +0000
Message-Id: <20201104151828.405824-23-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgoKSW4gcHJlcGFyYXRpb24g
b2YgNjRrQiBob3N0IHBhZ2Ugc3VwcG9ydCwgbGV0J3MgY2hhbmdlIHRoZSBzaXplCmFuZCBhbGln
bm1lbnQgb2YgdGhlIHF1ZXVlIHNvIHRoYXQgdGhlIFZGSU8gRE1BIE1BUCBzdWNjZWVkcy4KV2Ug
YWxpZ24gb24gdGhlIGhvc3QgcGFnZSBzaXplLgoKU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8
ZXJpYy5hdWdlckByZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVm
YW5oYUByZWRoYXQuY29tPgpUZXN0ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0
LmNvbT4KU2lnbmVkLW9mZi1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRo
YXQuY29tPgpNZXNzYWdlLWlkOiAyMDIwMTAyOTA5MzMwNi4xMDYzODc5LTIxLXBoaWxtZEByZWRo
YXQuY29tClNpZ25lZC1vZmYtYnk6IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0LmNv
bT4KVGVzdGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Ci0tLQogYmxv
Y2svbnZtZS5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Jsb2NrL252bWUuYyBiL2Jsb2NrL252bWUuYwppbmRl
eCA3NjI4NjIzYzA1Li40YTg1ODlkMmQyIDEwMDY0NAotLS0gYS9ibG9jay9udm1lLmMKKysrIGIv
YmxvY2svbnZtZS5jCkBAIC0xNjcsOSArMTY3LDkgQEAgc3RhdGljIGJvb2wgbnZtZV9pbml0X3F1
ZXVlKEJEUlZOVk1lU3RhdGUgKnMsIE5WTWVRdWV1ZSAqcSwKICAgICBzaXplX3QgYnl0ZXM7CiAg
ICAgaW50IHI7CiAKLSAgICBieXRlcyA9IFJPVU5EX1VQKG5lbnRyaWVzICogZW50cnlfYnl0ZXMs
IHMtPnBhZ2Vfc2l6ZSk7CisgICAgYnl0ZXMgPSBST1VORF9VUChuZW50cmllcyAqIGVudHJ5X2J5
dGVzLCBxZW11X3JlYWxfaG9zdF9wYWdlX3NpemUpOwogICAgIHEtPmhlYWQgPSBxLT50YWlsID0g
MDsKLSAgICBxLT5xdWV1ZSA9IHFlbXVfdHJ5X21lbWFsaWduKHMtPnBhZ2Vfc2l6ZSwgYnl0ZXMp
OworICAgIHEtPnF1ZXVlID0gcWVtdV90cnlfbWVtYWxpZ24ocWVtdV9yZWFsX2hvc3RfcGFnZV9z
aXplLCBieXRlcyk7CiAgICAgaWYgKCFxLT5xdWV1ZSkgewogICAgICAgICBlcnJvcl9zZXRnKGVy
cnAsICJDYW5ub3QgYWxsb2NhdGUgcXVldWUiKTsKICAgICAgICAgcmV0dXJuIGZhbHNlOwotLSAK
Mi4yOC4wCgo=

