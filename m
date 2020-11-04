Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626712A675A
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgKDPUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:20:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59757 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730466AbgKDPUT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:20:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ulu5WTfKThvFXhMzWf4fb+RajwQ6zNcJy1DLo80GnU=;
        b=F0/El/KDBGMxtN1seDD3hqpc3FDcGZwK+/kj5WWTtvAQfjXOQa2LoFhaFNitzJHcMWb0in
        dBvdPnFxUsR61c342VADaLaTxG43Qk2ZuJBYqR1CLQVdoLsSdHujnYFQfdpjbhQMMRrMJH
        AdhfL7fSi/3hQpTrcAmTRhfDx/51aKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-Z4_V7bn5OGqRVM8fS94deQ-1; Wed, 04 Nov 2020 10:20:12 -0500
X-MC-Unique: Z4_V7bn5OGqRVM8fS94deQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EFD464164;
        Wed,  4 Nov 2020 15:20:10 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3AE05C3E1;
        Wed,  4 Nov 2020 15:20:03 +0000 (UTC)
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
Subject: [PULL 13/33] block/nvme: Make nvme_init_queue() return boolean indicating error
Date:   Wed,  4 Nov 2020 15:18:08 +0000
Message-Id: <20201104151828.405824-14-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKSnVzdCBm
b3IgY29uc2lzdGVuY3ksIGZvbGxvd2luZyB0aGUgZXhhbXBsZSBkb2N1bWVudGVkIHNpbmNlCmNv
bW1pdCBlM2ZlMzk4OGQ3ICgiZXJyb3I6IERvY3VtZW50IEVycm9yIEFQSSB1c2FnZSBydWxlcyIp
LApyZXR1cm4gYSBib29sZWFuIHZhbHVlIGluZGljYXRpbmcgYW4gZXJyb3IgaXMgc2V0IG9yIG5v
dC4KRGlyZWN0bHkgcGFzcyBlcnJwIGFzIHRoZSBsb2NhbF9lcnIgaXMgbm90IHJlcXVlc3RlZCBp
biBvdXIKY2FzZS4gVGhpcyBzaW1wbGlmaWVzIGEgYml0IG52bWVfY3JlYXRlX3F1ZXVlX3BhaXIo
KS4KClJldmlld2VkLWJ5OiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+ClRl
c3RlZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5
OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1kQHJlZGhhdC5jb20+Ck1lc3NhZ2UtaWQ6
IDIwMjAxMDI5MDkzMzA2LjEwNjM4NzktMTItcGhpbG1kQHJlZGhhdC5jb20KU2lnbmVkLW9mZi1i
eTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUByZWRoYXQuY29tPgpUZXN0ZWQtYnk6IEVyaWMg
QXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KLS0tCiBibG9jay9udm1lLmMgfCAxNiArKysr
KysrLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2Jsb2NrL252bWUuYyBiL2Jsb2NrL252bWUuYwppbmRleCA5ODMz
NTAxMjQ1Li42ZWFiYTRlNzAzIDEwMDY0NAotLS0gYS9ibG9jay9udm1lLmMKKysrIGIvYmxvY2sv
bnZtZS5jCkBAIC0xNjAsNyArMTYwLDggQEAgc3RhdGljIFFlbXVPcHRzTGlzdCBydW50aW1lX29w
dHMgPSB7CiAgICAgfSwKIH07CiAKLXN0YXRpYyB2b2lkIG52bWVfaW5pdF9xdWV1ZShCRFJWTlZN
ZVN0YXRlICpzLCBOVk1lUXVldWUgKnEsCisvKiBSZXR1cm5zIHRydWUgb24gc3VjY2VzcywgZmFs
c2Ugb24gZmFpbHVyZS4gKi8KK3N0YXRpYyBib29sIG52bWVfaW5pdF9xdWV1ZShCRFJWTlZNZVN0
YXRlICpzLCBOVk1lUXVldWUgKnEsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWdu
ZWQgbmVudHJpZXMsIHNpemVfdCBlbnRyeV9ieXRlcywgRXJyb3IgKiplcnJwKQogewogICAgIHNp
emVfdCBieXRlczsKQEAgLTE3MSwxMyArMTcyLDE1IEBAIHN0YXRpYyB2b2lkIG52bWVfaW5pdF9x
dWV1ZShCRFJWTlZNZVN0YXRlICpzLCBOVk1lUXVldWUgKnEsCiAgICAgcS0+cXVldWUgPSBxZW11
X3RyeV9tZW1hbGlnbihzLT5wYWdlX3NpemUsIGJ5dGVzKTsKICAgICBpZiAoIXEtPnF1ZXVlKSB7
CiAgICAgICAgIGVycm9yX3NldGcoZXJycCwgIkNhbm5vdCBhbGxvY2F0ZSBxdWV1ZSIpOwotICAg
ICAgICByZXR1cm47CisgICAgICAgIHJldHVybiBmYWxzZTsKICAgICB9CiAgICAgbWVtc2V0KHEt
PnF1ZXVlLCAwLCBieXRlcyk7CiAgICAgciA9IHFlbXVfdmZpb19kbWFfbWFwKHMtPnZmaW8sIHEt
PnF1ZXVlLCBieXRlcywgZmFsc2UsICZxLT5pb3ZhKTsKICAgICBpZiAocikgewogICAgICAgICBl
cnJvcl9zZXRnKGVycnAsICJDYW5ub3QgbWFwIHF1ZXVlIik7CisgICAgICAgIHJldHVybiBmYWxz
ZTsKICAgICB9CisgICAgcmV0dXJuIHRydWU7CiB9CiAKIHN0YXRpYyB2b2lkIG52bWVfZnJlZV9x
dWV1ZV9wYWlyKE5WTWVRdWV1ZVBhaXIgKnEpCkBAIC0yMTAsNyArMjEzLDYgQEAgc3RhdGljIE5W
TWVRdWV1ZVBhaXIgKm52bWVfY3JlYXRlX3F1ZXVlX3BhaXIoQkRSVk5WTWVTdGF0ZSAqcywKICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEVycm9yICoqZXJycCkK
IHsKICAgICBpbnQgaSwgcjsKLSAgICBFcnJvciAqbG9jYWxfZXJyID0gTlVMTDsKICAgICBOVk1l
UXVldWVQYWlyICpxOwogICAgIHVpbnQ2NF90IHBycF9saXN0X2lvdmE7CiAKQEAgLTI0NywxNiAr
MjQ5LDEyIEBAIHN0YXRpYyBOVk1lUXVldWVQYWlyICpudm1lX2NyZWF0ZV9xdWV1ZV9wYWlyKEJE
UlZOVk1lU3RhdGUgKnMsCiAgICAgICAgIHJlcS0+cHJwX2xpc3RfaW92YSA9IHBycF9saXN0X2lv
dmEgKyBpICogcy0+cGFnZV9zaXplOwogICAgIH0KIAotICAgIG52bWVfaW5pdF9xdWV1ZShzLCAm
cS0+c3EsIHNpemUsIE5WTUVfU1FfRU5UUllfQllURVMsICZsb2NhbF9lcnIpOwotICAgIGlmIChs
b2NhbF9lcnIpIHsKLSAgICAgICAgZXJyb3JfcHJvcGFnYXRlKGVycnAsIGxvY2FsX2Vycik7Cisg
ICAgaWYgKCFudm1lX2luaXRfcXVldWUocywgJnEtPnNxLCBzaXplLCBOVk1FX1NRX0VOVFJZX0JZ
VEVTLCBlcnJwKSkgewogICAgICAgICBnb3RvIGZhaWw7CiAgICAgfQogICAgIHEtPnNxLmRvb3Ji
ZWxsID0gJnMtPmRvb3JiZWxsc1tpZHggKiBzLT5kb29yYmVsbF9zY2FsZV0uc3FfdGFpbDsKIAot
ICAgIG52bWVfaW5pdF9xdWV1ZShzLCAmcS0+Y3EsIHNpemUsIE5WTUVfQ1FfRU5UUllfQllURVMs
ICZsb2NhbF9lcnIpOwotICAgIGlmIChsb2NhbF9lcnIpIHsKLSAgICAgICAgZXJyb3JfcHJvcGFn
YXRlKGVycnAsIGxvY2FsX2Vycik7CisgICAgaWYgKCFudm1lX2luaXRfcXVldWUocywgJnEtPmNx
LCBzaXplLCBOVk1FX0NRX0VOVFJZX0JZVEVTLCBlcnJwKSkgewogICAgICAgICBnb3RvIGZhaWw7
CiAgICAgfQogICAgIHEtPmNxLmRvb3JiZWxsID0gJnMtPmRvb3JiZWxsc1tpZHggKiBzLT5kb29y
YmVsbF9zY2FsZV0uY3FfaGVhZDsKLS0gCjIuMjguMAoK

