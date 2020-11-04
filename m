Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE302A6756
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgKDPTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:19:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730162AbgKDPTm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:19:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pzuXVeQJ2VZeXPN39nJ7L5qwBZo2wyj0g1Y6BEr9LAQ=;
        b=NguAE4RJzjm+HUqdIAvLUYHFoZMbdUD3wrPwDAF9tsUVhbLtol6pYsy22p4RlsG5cBp0Nf
        GIiGJ1DKbzXdMLCGGBJlbE6IgS1V1DZSsHCN9xKzvZxJe5voqREUcWiFw0cjgNR3lNv//q
        kJSdzjuA1y94p/gxES8nJfl5wAZSDC8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-7IKcfCjVNduoFfx_sU7AAw-1; Wed, 04 Nov 2020 10:19:39 -0500
X-MC-Unique: 7IKcfCjVNduoFfx_sU7AAw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D87BF186DD29;
        Wed,  4 Nov 2020 15:19:37 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DE5355794;
        Wed,  4 Nov 2020 15:19:35 +0000 (UTC)
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
Subject: [PULL 09/33] block/nvme: Trace queue pair creation/deletion
Date:   Wed,  4 Nov 2020 15:18:04 +0000
Message-Id: <20201104151828.405824-10-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKUmV2aWV3
ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KUmV2aWV3ZWQtYnk6IFN0
ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0LmNvbT4KVGVzdGVkLWJ5OiBFcmljIEF1Z2Vy
IDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFBoaWxpcHBlIE1hdGhpZXUt
RGF1ZMOpIDxwaGlsbWRAcmVkaGF0LmNvbT4KTWVzc2FnZS1pZDogMjAyMDEwMjkwOTMzMDYuMTA2
Mzg3OS04LXBoaWxtZEByZWRoYXQuY29tClNpZ25lZC1vZmYtYnk6IFN0ZWZhbiBIYWpub2N6aSA8
c3RlZmFuaGFAcmVkaGF0LmNvbT4KVGVzdGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJl
ZGhhdC5jb20+Ci0tLQogYmxvY2svbnZtZS5jICAgICAgIHwgMyArKysKIGJsb2NrL3RyYWNlLWV2
ZW50cyB8IDIgKysKIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0
IGEvYmxvY2svbnZtZS5jIGIvYmxvY2svbnZtZS5jCmluZGV4IDI5ZDI1NDFiOTEuLmU5NWQ1OWQz
MTIgMTAwNjQ0Ci0tLSBhL2Jsb2NrL252bWUuYworKysgYi9ibG9jay9udm1lLmMKQEAgLTE4MSw2
ICsxODEsNyBAQCBzdGF0aWMgdm9pZCBudm1lX2luaXRfcXVldWUoQkRSVk5WTWVTdGF0ZSAqcywg
TlZNZVF1ZXVlICpxLAogCiBzdGF0aWMgdm9pZCBudm1lX2ZyZWVfcXVldWVfcGFpcihOVk1lUXVl
dWVQYWlyICpxKQogeworICAgIHRyYWNlX252bWVfZnJlZV9xdWV1ZV9wYWlyKHEtPmluZGV4LCBx
KTsKICAgICBpZiAocS0+Y29tcGxldGlvbl9iaCkgewogICAgICAgICBxZW11X2JoX2RlbGV0ZShx
LT5jb21wbGV0aW9uX2JoKTsKICAgICB9CkBAIC0yMTYsNiArMjE3LDggQEAgc3RhdGljIE5WTWVR
dWV1ZVBhaXIgKm52bWVfY3JlYXRlX3F1ZXVlX3BhaXIoQkRSVk5WTWVTdGF0ZSAqcywKICAgICBp
ZiAoIXEpIHsKICAgICAgICAgcmV0dXJuIE5VTEw7CiAgICAgfQorICAgIHRyYWNlX252bWVfY3Jl
YXRlX3F1ZXVlX3BhaXIoaWR4LCBxLCBzaXplLCBhaW9fY29udGV4dCwKKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGV2ZW50X25vdGlmaWVyX2dldF9mZChzLT5pcnFfbm90aWZpZXIp
KTsKICAgICBxLT5wcnBfbGlzdF9wYWdlcyA9IHFlbXVfdHJ5X21lbWFsaWduKHMtPnBhZ2Vfc2l6
ZSwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHMtPnBhZ2Vfc2l6
ZSAqIE5WTUVfTlVNX1JFUVMpOwogICAgIGlmICghcS0+cHJwX2xpc3RfcGFnZXMpIHsKZGlmZiAt
LWdpdCBhL2Jsb2NrL3RyYWNlLWV2ZW50cyBiL2Jsb2NrL3RyYWNlLWV2ZW50cwppbmRleCBjYzVl
MmI1NWNiLi5mNmEwZjk5ZGYxIDEwMDY0NAotLS0gYS9ibG9jay90cmFjZS1ldmVudHMKKysrIGIv
YmxvY2svdHJhY2UtZXZlbnRzCkBAIC0xNTUsNiArMTU1LDggQEAgbnZtZV9kc20odm9pZCAqcywg
dWludDY0X3Qgb2Zmc2V0LCB1aW50NjRfdCBieXRlcykgInMgJXAgb2Zmc2V0IDB4JSJQUkl4NjQi
IGJ5dGUKIG52bWVfZHNtX2RvbmUodm9pZCAqcywgdWludDY0X3Qgb2Zmc2V0LCB1aW50NjRfdCBi
eXRlcywgaW50IHJldCkgInMgJXAgb2Zmc2V0IDB4JSJQUkl4NjQiIGJ5dGVzICUiUFJJZDY0IiBy
ZXQgJWQiCiBudm1lX2RtYV9tYXBfZmx1c2godm9pZCAqcykgInMgJXAiCiBudm1lX2ZyZWVfcmVx
X3F1ZXVlX3dhaXQodm9pZCAqcywgdW5zaWduZWQgcV9pbmRleCkgInMgJXAgcSAjJXUiCitudm1l
X2NyZWF0ZV9xdWV1ZV9wYWlyKHVuc2lnbmVkIHFfaW5kZXgsIHZvaWQgKnEsIHVuc2lnbmVkIHNp
emUsIHZvaWQgKmFpb19jb250ZXh0LCBpbnQgZmQpICJpbmRleCAldSBxICVwIHNpemUgJXUgYWlv
Y3R4ICVwIGZkICVkIgorbnZtZV9mcmVlX3F1ZXVlX3BhaXIodW5zaWduZWQgcV9pbmRleCwgdm9p
ZCAqcSkgImluZGV4ICV1IHEgJXAiCiBudm1lX2NtZF9tYXBfcWlvdih2b2lkICpzLCB2b2lkICpj
bWQsIHZvaWQgKnJlcSwgdm9pZCAqcWlvdiwgaW50IGVudHJpZXMpICJzICVwIGNtZCAlcCByZXEg
JXAgcWlvdiAlcCBlbnRyaWVzICVkIgogbnZtZV9jbWRfbWFwX3Fpb3ZfcGFnZXModm9pZCAqcywg
aW50IGksIHVpbnQ2NF90IHBhZ2UpICJzICVwIHBhZ2VbJWRdIDB4JSJQUkl4NjQKIG52bWVfY21k
X21hcF9xaW92X2lvdih2b2lkICpzLCBpbnQgaSwgdm9pZCAqcGFnZSwgaW50IHBhZ2VzKSAicyAl
cCBpb3ZbJWRdICVwIHBhZ2VzICVkIgotLSAKMi4yOC4wCgo=

