Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4903A2A676E
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbgKDPVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:21:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47186 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730723AbgKDPVP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:21:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JNv0TiZ4zapmbEnazkUflaFJKUKWSwL5ypDHx6qKNHE=;
        b=bIDLxp3udR5cfpnejRe6YPA94xUe8FwGOkfSMdcUnIXARxyVVsk62j8miWjOW3In5kIU5/
        Hcr+pf/q053hpHRTRVyFMz9+nE8ahSeveWn7YAOT18IXevspd8f++1G9j79TKntAGbl7oK
        Xe+o2ifb37wxoEWatdZMN5CGVn7wKf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-hchZ_auEOBu6uBGDy9Pwww-1; Wed, 04 Nov 2020 10:21:12 -0500
X-MC-Unique: hchZ_auEOBu6uBGDy9Pwww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10753101F005;
        Wed,  4 Nov 2020 15:21:11 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00E3960C84;
        Wed,  4 Nov 2020 15:21:04 +0000 (UTC)
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
Subject: [PULL 23/33] block/nvme: Change size and alignment of prp_list_pages
Date:   Wed,  4 Nov 2020 15:18:18 +0000
Message-Id: <20201104151828.405824-24-stefanha@redhat.com>
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
bm1lbnQgb2YgdGhlIHBycF9saXN0X3BhZ2VzIHNvIHRoYXQgdGhlIFZGSU8gRE1BIE1BUCBzdWNj
ZWVkcwp3aXRoIDY0a0IgaG9zdCBwYWdlIHNpemUuIFdlIGFsaWduIG9uIHRoZSBob3N0IHBhZ2Ug
c2l6ZS4KClJldmlld2VkLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1kQHJlZGhh
dC5jb20+ClNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4K
UmV2aWV3ZWQtYnk6IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0LmNvbT4KVGVzdGVk
LWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFBo
aWxpcHBlIE1hdGhpZXUtRGF1ZMOpIDxwaGlsbWRAcmVkaGF0LmNvbT4KTWVzc2FnZS1pZDogMjAy
MDEwMjkwOTMzMDYuMTA2Mzg3OS0yMi1waGlsbWRAcmVkaGF0LmNvbQpTaWduZWQtb2ZmLWJ5OiBT
dGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+ClRlc3RlZC1ieTogRXJpYyBBdWdl
ciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgotLS0KIGJsb2NrL252bWUuYyB8IDExICsrKysrKy0t
LS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2Jsb2NrL252bWUuYyBiL2Jsb2NrL252bWUuYwppbmRleCA0YTg1ODlkMmQyLi5l
ODA3ZGQ1NmRmIDEwMDY0NAotLS0gYS9ibG9jay9udm1lLmMKKysrIGIvYmxvY2svbnZtZS5jCkBA
IC0yMTUsNiArMjE1LDcgQEAgc3RhdGljIE5WTWVRdWV1ZVBhaXIgKm52bWVfY3JlYXRlX3F1ZXVl
X3BhaXIoQkRSVk5WTWVTdGF0ZSAqcywKICAgICBpbnQgaSwgcjsKICAgICBOVk1lUXVldWVQYWly
ICpxOwogICAgIHVpbnQ2NF90IHBycF9saXN0X2lvdmE7CisgICAgc2l6ZV90IGJ5dGVzOwogCiAg
ICAgcSA9IGdfdHJ5X25ldzAoTlZNZVF1ZXVlUGFpciwgMSk7CiAgICAgaWYgKCFxKSB7CkBAIC0y
MjIsMTkgKzIyMywxOSBAQCBzdGF0aWMgTlZNZVF1ZXVlUGFpciAqbnZtZV9jcmVhdGVfcXVldWVf
cGFpcihCRFJWTlZNZVN0YXRlICpzLAogICAgIH0KICAgICB0cmFjZV9udm1lX2NyZWF0ZV9xdWV1
ZV9wYWlyKGlkeCwgcSwgc2l6ZSwgYWlvX2NvbnRleHQsCiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBldmVudF9ub3RpZmllcl9nZXRfZmQocy0+aXJxX25vdGlmaWVyKSk7Ci0gICAg
cS0+cHJwX2xpc3RfcGFnZXMgPSBxZW11X3RyeV9tZW1hbGlnbihzLT5wYWdlX3NpemUsCi0gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzLT5wYWdlX3NpemUgKiBOVk1F
X05VTV9SRVFTKTsKKyAgICBieXRlcyA9IFFFTVVfQUxJR05fVVAocy0+cGFnZV9zaXplICogTlZN
RV9OVU1fUkVRUywKKyAgICAgICAgICAgICAgICAgICAgICAgICAgcWVtdV9yZWFsX2hvc3RfcGFn
ZV9zaXplKTsKKyAgICBxLT5wcnBfbGlzdF9wYWdlcyA9IHFlbXVfdHJ5X21lbWFsaWduKHFlbXVf
cmVhbF9ob3N0X3BhZ2Vfc2l6ZSwgYnl0ZXMpOwogICAgIGlmICghcS0+cHJwX2xpc3RfcGFnZXMp
IHsKICAgICAgICAgZ290byBmYWlsOwogICAgIH0KLSAgICBtZW1zZXQocS0+cHJwX2xpc3RfcGFn
ZXMsIDAsIHMtPnBhZ2Vfc2l6ZSAqIE5WTUVfTlVNX1JFUVMpOworICAgIG1lbXNldChxLT5wcnBf
bGlzdF9wYWdlcywgMCwgYnl0ZXMpOwogICAgIHFlbXVfbXV0ZXhfaW5pdCgmcS0+bG9jayk7CiAg
ICAgcS0+cyA9IHM7CiAgICAgcS0+aW5kZXggPSBpZHg7CiAgICAgcWVtdV9jb19xdWV1ZV9pbml0
KCZxLT5mcmVlX3JlcV9xdWV1ZSk7CiAgICAgcS0+Y29tcGxldGlvbl9iaCA9IGFpb19iaF9uZXco
YWlvX2NvbnRleHQsIG52bWVfcHJvY2Vzc19jb21wbGV0aW9uX2JoLCBxKTsKLSAgICByID0gcWVt
dV92ZmlvX2RtYV9tYXAocy0+dmZpbywgcS0+cHJwX2xpc3RfcGFnZXMsCi0gICAgICAgICAgICAg
ICAgICAgICAgICAgIHMtPnBhZ2Vfc2l6ZSAqIE5WTUVfTlVNX1JFUVMsCisgICAgciA9IHFlbXVf
dmZpb19kbWFfbWFwKHMtPnZmaW8sIHEtPnBycF9saXN0X3BhZ2VzLCBieXRlcywKICAgICAgICAg
ICAgICAgICAgICAgICAgICAgZmFsc2UsICZwcnBfbGlzdF9pb3ZhKTsKICAgICBpZiAocikgewog
ICAgICAgICBnb3RvIGZhaWw7Ci0tIAoyLjI4LjAKCg==

