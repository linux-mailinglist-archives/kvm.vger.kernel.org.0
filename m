Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9FC2A6769
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730709AbgKDPUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:20:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26620 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730663AbgKDPUt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:20:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kiVtIXdwQ9KVMu0FHvAuY0DkhOuVMD1KuqG5i65tga4=;
        b=cdURSxvFeXWHgEyH1evML0JNMxwd4dpPcW/Gq2G44xxA2gi35Qe7dDGaFC7DwPzIEnHVwP
        4qP54wb2p2f6qus65hCTDLbvyRkjoGHx2AssTfH94KHkH6aSZKCNpmnh1iu1v0bhCN6DAu
        vOnaH4BsXvPakqpF2fac06D+QeYJ7mM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-MoXFsoAfPsShyPViThmXOg-1; Wed, 04 Nov 2020 10:20:46 -0500
X-MC-Unique: MoXFsoAfPsShyPViThmXOg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 598428030A8;
        Wed,  4 Nov 2020 15:20:44 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EED9D5D9CC;
        Wed,  4 Nov 2020 15:20:43 +0000 (UTC)
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
Subject: [PULL 19/33] block/nvme: Set request_alignment at initialization
Date:   Wed,  4 Nov 2020 15:18:14 +0000
Message-Id: <20201104151828.405824-20-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKQ29tbWl0
IGJkZDZhOTBhOWU1ICgiYmxvY2s6IEFkZCBWRklPIGJhc2VkIE5WTWUgZHJpdmVyIikKc2V0cyB0
aGUgcmVxdWVzdF9hbGlnbm1lbnQgaW4gbnZtZV9yZWZyZXNoX2xpbWl0cygpLgpGb3IgY29uc2lz
dGVuY3ksIGFsc28gc2V0IGl0IGR1cmluZyBpbml0aWFsaXphdGlvbi4KClJlcG9ydGVkLWJ5OiBT
dGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+ClJldmlld2VkLWJ5OiBFcmljIEF1
Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+ClJldmlld2VkLWJ5OiBTdGVmYW4gSGFqbm9jemkg
PHN0ZWZhbmhhQHJlZGhhdC5jb20+ClRlc3RlZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckBy
ZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1k
QHJlZGhhdC5jb20+Ck1lc3NhZ2UtaWQ6IDIwMjAxMDI5MDkzMzA2LjEwNjM4NzktMTgtcGhpbG1k
QHJlZGhhdC5jb20KU2lnbmVkLW9mZi1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUByZWRo
YXQuY29tPgpUZXN0ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KLS0t
CiBibG9jay9udm1lLmMgfCAxICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQoKZGlm
ZiAtLWdpdCBhL2Jsb2NrL252bWUuYyBiL2Jsb2NrL252bWUuYwppbmRleCBjZDg3NTU1NWNhLi5i
Yjc1NDQ4YTA5IDEwMDY0NAotLS0gYS9ibG9jay9udm1lLmMKKysrIGIvYmxvY2svbnZtZS5jCkBA
IC03NTgsNiArNzU4LDcgQEAgc3RhdGljIGludCBudm1lX2luaXQoQmxvY2tEcml2ZXJTdGF0ZSAq
YnMsIGNvbnN0IGNoYXIgKmRldmljZSwgaW50IG5hbWVzcGFjZSwKICAgICBzLT5wYWdlX3NpemUg
PSBNQVgoNDA5NiwgMSA8PCBOVk1FX0NBUF9NUFNNSU4oY2FwKSk7CiAgICAgcy0+ZG9vcmJlbGxf
c2NhbGUgPSAoNCA8PCBOVk1FX0NBUF9EU1RSRChjYXApKSAvIHNpemVvZih1aW50MzJfdCk7CiAg
ICAgYnMtPmJsLm9wdF9tZW1fYWxpZ25tZW50ID0gcy0+cGFnZV9zaXplOworICAgIGJzLT5ibC5y
ZXF1ZXN0X2FsaWdubWVudCA9IHMtPnBhZ2Vfc2l6ZTsKICAgICB0aW1lb3V0X21zID0gTUlOKDUw
MCAqIE5WTUVfQ0FQX1RPKGNhcCksIDMwMDAwKTsKIAogICAgIC8qIFJlc2V0IGRldmljZSB0byBn
ZXQgYSBjbGVhbiBzdGF0ZS4gKi8KLS0gCjIuMjguMAoK

