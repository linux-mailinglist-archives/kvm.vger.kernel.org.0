Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DD02A6754
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgKDPTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:19:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730198AbgKDPTj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:19:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1SDFk5PbT1fcpoJeoCbXDc0HMullXY8b21Cyi2Mg2wg=;
        b=Y74OA9ybUIHyetqH3ze4G6uRc5X/C+ZeiAANYTwqdSF1qWNFeq6r24NrxmjvYnuhW/QsIm
        jz3eEAAzWF/8WRQVPGEfY9ugQVDU7m2fjaMoaBpJJZZ3WZREOyP2Q0lBaUztyLgQ96lwYI
        43yGIZ2O5lfzzWSOZfY3AQhLL+q4wzM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-MlGACpTqNpqKyKx8kiBOOg-1; Wed, 04 Nov 2020 10:19:35 -0500
X-MC-Unique: MlGACpTqNpqKyKx8kiBOOg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE2E48049C3;
        Wed,  4 Nov 2020 15:19:33 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B27DE19C4F;
        Wed,  4 Nov 2020 15:19:27 +0000 (UTC)
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
Subject: [PULL 08/33] block/nvme: Improve nvme_free_req_queue_wait() trace information
Date:   Wed,  4 Nov 2020 15:18:03 +0000
Message-Id: <20201104151828.405824-9-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKV2hhdCB3
ZSB3YW50IHRvIHRyYWNlIGlzIHRoZSBibG9jayBkcml2ZXIgc3RhdGUgYW5kIHRoZSBxdWV1ZSBp
bmRleC4KClN1Z2dlc3RlZC1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUByZWRoYXQuY29t
PgpSZXZpZXdlZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgpSZXZpZXdl
ZC1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUByZWRoYXQuY29tPgpUZXN0ZWQtYnk6IEVy
aWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogUGhpbGlwcGUg
TWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgpNZXNzYWdlLWlkOiAyMDIwMTAyOTA5
MzMwNi4xMDYzODc5LTctcGhpbG1kQHJlZGhhdC5jb20KU2lnbmVkLW9mZi1ieTogU3RlZmFuIEhh
am5vY3ppIDxzdGVmYW5oYUByZWRoYXQuY29tPgpUZXN0ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMu
YXVnZXJAcmVkaGF0LmNvbT4KLS0tCiBibG9jay9udm1lLmMgICAgICAgfCAyICstCiBibG9jay90
cmFjZS1ldmVudHMgfCAyICstCiAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9ibG9jay9udm1lLmMgYi9ibG9jay9udm1lLmMKaW5k
ZXggOGQ3NDQwMWFlNy4uMjlkMjU0MWI5MSAxMDA2NDQKLS0tIGEvYmxvY2svbnZtZS5jCisrKyBi
L2Jsb2NrL252bWUuYwpAQCAtMjkyLDcgKzI5Miw3IEBAIHN0YXRpYyBOVk1lUmVxdWVzdCAqbnZt
ZV9nZXRfZnJlZV9yZXEoTlZNZVF1ZXVlUGFpciAqcSkKIAogICAgIHdoaWxlIChxLT5mcmVlX3Jl
cV9oZWFkID09IC0xKSB7CiAgICAgICAgIGlmIChxZW11X2luX2Nvcm91dGluZSgpKSB7Ci0gICAg
ICAgICAgICB0cmFjZV9udm1lX2ZyZWVfcmVxX3F1ZXVlX3dhaXQocSk7CisgICAgICAgICAgICB0
cmFjZV9udm1lX2ZyZWVfcmVxX3F1ZXVlX3dhaXQocS0+cywgcS0+aW5kZXgpOwogICAgICAgICAg
ICAgcWVtdV9jb19xdWV1ZV93YWl0KCZxLT5mcmVlX3JlcV9xdWV1ZSwgJnEtPmxvY2spOwogICAg
ICAgICB9IGVsc2UgewogICAgICAgICAgICAgcWVtdV9tdXRleF91bmxvY2soJnEtPmxvY2spOwpk
aWZmIC0tZ2l0IGEvYmxvY2svdHJhY2UtZXZlbnRzIGIvYmxvY2svdHJhY2UtZXZlbnRzCmluZGV4
IDg2MjkyZjMzMTIuLmNjNWUyYjU1Y2IgMTAwNjQ0Ci0tLSBhL2Jsb2NrL3RyYWNlLWV2ZW50cwor
KysgYi9ibG9jay90cmFjZS1ldmVudHMKQEAgLTE1NCw3ICsxNTQsNyBAQCBudm1lX3J3X2RvbmUo
dm9pZCAqcywgaW50IGlzX3dyaXRlLCB1aW50NjRfdCBvZmZzZXQsIHVpbnQ2NF90IGJ5dGVzLCBp
bnQgcmV0KSAicwogbnZtZV9kc20odm9pZCAqcywgdWludDY0X3Qgb2Zmc2V0LCB1aW50NjRfdCBi
eXRlcykgInMgJXAgb2Zmc2V0IDB4JSJQUkl4NjQiIGJ5dGVzICUiUFJJZDY0IiIKIG52bWVfZHNt
X2RvbmUodm9pZCAqcywgdWludDY0X3Qgb2Zmc2V0LCB1aW50NjRfdCBieXRlcywgaW50IHJldCkg
InMgJXAgb2Zmc2V0IDB4JSJQUkl4NjQiIGJ5dGVzICUiUFJJZDY0IiByZXQgJWQiCiBudm1lX2Rt
YV9tYXBfZmx1c2godm9pZCAqcykgInMgJXAiCi1udm1lX2ZyZWVfcmVxX3F1ZXVlX3dhaXQodm9p
ZCAqcSkgInEgJXAiCitudm1lX2ZyZWVfcmVxX3F1ZXVlX3dhaXQodm9pZCAqcywgdW5zaWduZWQg
cV9pbmRleCkgInMgJXAgcSAjJXUiCiBudm1lX2NtZF9tYXBfcWlvdih2b2lkICpzLCB2b2lkICpj
bWQsIHZvaWQgKnJlcSwgdm9pZCAqcWlvdiwgaW50IGVudHJpZXMpICJzICVwIGNtZCAlcCByZXEg
JXAgcWlvdiAlcCBlbnRyaWVzICVkIgogbnZtZV9jbWRfbWFwX3Fpb3ZfcGFnZXModm9pZCAqcywg
aW50IGksIHVpbnQ2NF90IHBhZ2UpICJzICVwIHBhZ2VbJWRdIDB4JSJQUkl4NjQKIG52bWVfY21k
X21hcF9xaW92X2lvdih2b2lkICpzLCBpbnQgaSwgdm9pZCAqcGFnZSwgaW50IHBhZ2VzKSAicyAl
cCBpb3ZbJWRdICVwIHBhZ2VzICVkIgotLSAKMi4yOC4wCgo=

