Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B6C2A674D
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbgKDPTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:19:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42300 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730245AbgKDPTO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:19:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hxDVLOr8xwRV8sjIEMjjd9BMHpXbgUmTJTFi4H6YsS8=;
        b=CDIm2o7diuFUHyZLkOeR8OzG2kCUWcdf99xm3kk6gjwIVLTnoUTDDDvX9OMKBAMhpXbtPD
        Y1LffLbJnnJeTwvCA3JpaDvaFset2fdMwEsjomIa5zIjDgKU9Z62+L8Oy1KbJry5qSWdy8
        qxt0sVZegdvmK2lLdHcpq2ucEDE8Cyw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-aFds57BUPTGtQO2KKuMpcg-1; Wed, 04 Nov 2020 10:19:11 -0500
X-MC-Unique: aFds57BUPTGtQO2KKuMpcg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71DFF1087D64;
        Wed,  4 Nov 2020 15:19:09 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8797919C4F;
        Wed,  4 Nov 2020 15:19:02 +0000 (UTC)
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
Subject: [PULL 05/33] block/nvme: Report warning with warn_report()
Date:   Wed,  4 Nov 2020 15:18:00 +0000
Message-Id: <20201104151828.405824-6-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKSW5zdGVh
ZCBvZiBkaXNwbGF5aW5nIHdhcm5pbmcgb24gc3RkZXJyLCB1c2Ugd2Fybl9yZXBvcnQoKQp3aGlj
aCBhbHNvIGRpc3BsYXlzIGl0IG9uIHRoZSBtb25pdG9yLgoKUmV2aWV3ZWQtYnk6IEVyaWMgQXVn
ZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KUmV2aWV3ZWQtYnk6IFN0ZWZhbiBIYWpub2N6aSA8
c3RlZmFuaGFAcmVkaGF0LmNvbT4KVGVzdGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJl
ZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIDxwaGlsbWRA
cmVkaGF0LmNvbT4KTWVzc2FnZS1pZDogMjAyMDEwMjkwOTMzMDYuMTA2Mzg3OS00LXBoaWxtZEBy
ZWRoYXQuY29tClNpZ25lZC1vZmYtYnk6IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0
LmNvbT4KVGVzdGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Ci0tLQog
YmxvY2svbnZtZS5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Jsb2NrL252bWUuYyBiL2Jsb2NrL252bWUuYwpp
bmRleCA3MzlhMGE3MDBjLi42ZjFkN2Y5YjJhIDEwMDY0NAotLS0gYS9ibG9jay9udm1lLmMKKysr
IGIvYmxvY2svbnZtZS5jCkBAIC0zOTksOCArMzk5LDggQEAgc3RhdGljIGJvb2wgbnZtZV9wcm9j
ZXNzX2NvbXBsZXRpb24oTlZNZVF1ZXVlUGFpciAqcSkKICAgICAgICAgfQogICAgICAgICBjaWQg
PSBsZTE2X3RvX2NwdShjLT5jaWQpOwogICAgICAgICBpZiAoY2lkID09IDAgfHwgY2lkID4gTlZN
RV9RVUVVRV9TSVpFKSB7Ci0gICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIlVuZXhwZWN0ZWQg
Q0lEIGluIGNvbXBsZXRpb24gcXVldWU6ICUiIFBSSXUzMiAiXG4iLAotICAgICAgICAgICAgICAg
ICAgICBjaWQpOworICAgICAgICAgICAgd2Fybl9yZXBvcnQoIk5WTWU6IFVuZXhwZWN0ZWQgQ0lE
IGluIGNvbXBsZXRpb24gcXVldWU6ICUiUFJJdTMyIiwgIgorICAgICAgICAgICAgICAgICAgICAg
ICAgInF1ZXVlIHNpemU6ICV1IiwgY2lkLCBOVk1FX1FVRVVFX1NJWkUpOwogICAgICAgICAgICAg
Y29udGludWU7CiAgICAgICAgIH0KICAgICAgICAgdHJhY2VfbnZtZV9jb21wbGV0ZV9jb21tYW5k
KHMsIHEtPmluZGV4LCBjaWQpOwotLSAKMi4yOC4wCgo=

