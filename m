Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2448B2A676F
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730485AbgKDPVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:21:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21788 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728380AbgKDPVS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:21:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Li0kacoWjiU1qKe4Pgxu8UAIlHC/67ypPcd5NsRWeKE=;
        b=eJkMvKFfLrRdoJHNfcaXWBFUCGqidkfPzuImZWhCpIiiY0nm2Y7oMbS8j9F3dBYFXcW1fa
        DI2ZBOMAv247KAop6M97gJdd1UMF2ykoJfGy0aDdowImUWmFqp3eVhOyD4IDVNjQqzNxl6
        UAfezcoxBQjMoFVtRhlSICcP++KTZ+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-mlYUIw-2Oq2pqX_53v-5ZA-1; Wed, 04 Nov 2020 10:21:14 -0500
X-MC-Unique: mlYUIw-2Oq2pqX_53v-5ZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAA369CC05;
        Wed,  4 Nov 2020 15:21:12 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B6A460C84;
        Wed,  4 Nov 2020 15:21:12 +0000 (UTC)
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
Subject: [PULL 24/33] block/nvme: Align iov's va and size on host page size
Date:   Wed,  4 Nov 2020 15:18:19 +0000
Message-Id: <20201104151828.405824-25-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgoKTWFrZSBzdXJlIGlvdidz
IHZhIGFuZCBzaXplIGFyZSBwcm9wZXJseSBhbGlnbmVkIG9uIHRoZQpob3N0IHBhZ2Ugc2l6ZS4K
ClNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KUmV2aWV3
ZWQtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIDxwaGlsbWRAcmVkaGF0LmNvbT4KUmV2aWV3
ZWQtYnk6IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0LmNvbT4KVGVzdGVkLWJ5OiBF
cmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFBoaWxpcHBl
IE1hdGhpZXUtRGF1ZMOpIDxwaGlsbWRAcmVkaGF0LmNvbT4KTWVzc2FnZS1pZDogMjAyMDEwMjkw
OTMzMDYuMTA2Mzg3OS0yMy1waGlsbWRAcmVkaGF0LmNvbQpTaWduZWQtb2ZmLWJ5OiBTdGVmYW4g
SGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+ClRlc3RlZC1ieTogRXJpYyBBdWdlciA8ZXJp
Yy5hdWdlckByZWRoYXQuY29tPgotLS0KIGJsb2NrL252bWUuYyB8IDE0ICsrKysrKysrLS0tLS0t
CiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2Jsb2NrL252bWUuYyBiL2Jsb2NrL252bWUuYwppbmRleCBlODA3ZGQ1NmRmLi5mMWUy
ZmQzNGNkIDEwMDY0NAotLS0gYS9ibG9jay9udm1lLmMKKysrIGIvYmxvY2svbnZtZS5jCkBAIC0x
MDE1LDExICsxMDE1LDEyIEBAIHN0YXRpYyBjb3JvdXRpbmVfZm4gaW50IG52bWVfY21kX21hcF9x
aW92KEJsb2NrRHJpdmVyU3RhdGUgKmJzLCBOdm1lQ21kICpjbWQsCiAgICAgZm9yIChpID0gMDsg
aSA8IHFpb3YtPm5pb3Y7ICsraSkgewogICAgICAgICBib29sIHJldHJ5ID0gdHJ1ZTsKICAgICAg
ICAgdWludDY0X3QgaW92YTsKKyAgICAgICAgc2l6ZV90IGxlbiA9IFFFTVVfQUxJR05fVVAocWlv
di0+aW92W2ldLmlvdl9sZW4sCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHFl
bXVfcmVhbF9ob3N0X3BhZ2Vfc2l6ZSk7CiB0cnlfbWFwOgogICAgICAgICByID0gcWVtdV92Zmlv
X2RtYV9tYXAocy0+dmZpbywKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHFpb3YtPmlv
dltpXS5pb3ZfYmFzZSwKLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHFpb3YtPmlvdltp
XS5pb3ZfbGVuLAotICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdHJ1ZSwgJmlvdmEpOwor
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGVuLCB0cnVlLCAmaW92YSk7CiAgICAgICAg
IGlmIChyID09IC1FTk9NRU0gJiYgcmV0cnkpIHsKICAgICAgICAgICAgIHJldHJ5ID0gZmFsc2U7
CiAgICAgICAgICAgICB0cmFjZV9udm1lX2RtYV9mbHVzaF9xdWV1ZV93YWl0KHMpOwpAQCAtMTE2
Myw4ICsxMTY0LDkgQEAgc3RhdGljIGlubGluZSBib29sIG52bWVfcWlvdl9hbGlnbmVkKEJsb2Nr
RHJpdmVyU3RhdGUgKmJzLAogICAgIEJEUlZOVk1lU3RhdGUgKnMgPSBicy0+b3BhcXVlOwogCiAg
ICAgZm9yIChpID0gMDsgaSA8IHFpb3YtPm5pb3Y7ICsraSkgewotICAgICAgICBpZiAoIVFFTVVf
UFRSX0lTX0FMSUdORUQocWlvdi0+aW92W2ldLmlvdl9iYXNlLCBzLT5wYWdlX3NpemUpIHx8Ci0g
ICAgICAgICAgICAhUUVNVV9JU19BTElHTkVEKHFpb3YtPmlvdltpXS5pb3ZfbGVuLCBzLT5wYWdl
X3NpemUpKSB7CisgICAgICAgIGlmICghUUVNVV9QVFJfSVNfQUxJR05FRChxaW92LT5pb3ZbaV0u
aW92X2Jhc2UsCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBxZW11X3JlYWxfaG9z
dF9wYWdlX3NpemUpIHx8CisgICAgICAgICAgICAhUUVNVV9JU19BTElHTkVEKHFpb3YtPmlvdltp
XS5pb3ZfbGVuLCBxZW11X3JlYWxfaG9zdF9wYWdlX3NpemUpKSB7CiAgICAgICAgICAgICB0cmFj
ZV9udm1lX3Fpb3ZfdW5hbGlnbmVkKHFpb3YsIGksIHFpb3YtPmlvdltpXS5pb3ZfYmFzZSwKICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcWlvdi0+aW92W2ldLmlvdl9sZW4s
IHMtPnBhZ2Vfc2l6ZSk7CiAgICAgICAgICAgICByZXR1cm4gZmFsc2U7CkBAIC0xMTgwLDcgKzEx
ODIsNyBAQCBzdGF0aWMgaW50IG52bWVfY29fcHJ3KEJsb2NrRHJpdmVyU3RhdGUgKmJzLCB1aW50
NjRfdCBvZmZzZXQsIHVpbnQ2NF90IGJ5dGVzLAogICAgIGludCByOwogICAgIHVpbnQ4X3QgKmJ1
ZiA9IE5VTEw7CiAgICAgUUVNVUlPVmVjdG9yIGxvY2FsX3Fpb3Y7Ci0KKyAgICBzaXplX3QgbGVu
ID0gUUVNVV9BTElHTl9VUChieXRlcywgcWVtdV9yZWFsX2hvc3RfcGFnZV9zaXplKTsKICAgICBh
c3NlcnQoUUVNVV9JU19BTElHTkVEKG9mZnNldCwgcy0+cGFnZV9zaXplKSk7CiAgICAgYXNzZXJ0
KFFFTVVfSVNfQUxJR05FRChieXRlcywgcy0+cGFnZV9zaXplKSk7CiAgICAgYXNzZXJ0KGJ5dGVz
IDw9IHMtPm1heF90cmFuc2Zlcik7CkBAIC0xMTkwLDcgKzExOTIsNyBAQCBzdGF0aWMgaW50IG52
bWVfY29fcHJ3KEJsb2NrRHJpdmVyU3RhdGUgKmJzLCB1aW50NjRfdCBvZmZzZXQsIHVpbnQ2NF90
IGJ5dGVzLAogICAgIH0KICAgICBzLT5zdGF0cy51bmFsaWduZWRfYWNjZXNzZXMrKzsKICAgICB0
cmFjZV9udm1lX3Byd19idWZmZXJlZChzLCBvZmZzZXQsIGJ5dGVzLCBxaW92LT5uaW92LCBpc193
cml0ZSk7Ci0gICAgYnVmID0gcWVtdV90cnlfbWVtYWxpZ24ocy0+cGFnZV9zaXplLCBieXRlcyk7
CisgICAgYnVmID0gcWVtdV90cnlfbWVtYWxpZ24ocWVtdV9yZWFsX2hvc3RfcGFnZV9zaXplLCBs
ZW4pOwogCiAgICAgaWYgKCFidWYpIHsKICAgICAgICAgcmV0dXJuIC1FTk9NRU07Ci0tIAoyLjI4
LjAKCg==

