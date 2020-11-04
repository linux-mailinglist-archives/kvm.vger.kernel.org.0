Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8172A6770
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730736AbgKDPVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:21:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730725AbgKDPV2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:21:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Epts384DsHq2EDzB8osaYgcnKC56AH4XpG7OYuTiA9w=;
        b=OYrsUg0LxJ49yXftfWmAurZd8eI+CUDfV2o2YzSrQiQ4usKyXp1B0oUXwBKYxe4wT+J0k0
        B32FuWwUa4sMi348b/TbV4UgsdBQ/QEyGxw93fCkfAVUZszB8XR3i7qRYj8rriR+ZLf/j7
        5COBRn6mOmUFHaEjRrw/VxkYCADULmo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-qzUYfoSWNO-DAUgAeQpwZg-1; Wed, 04 Nov 2020 10:21:23 -0500
X-MC-Unique: qzUYfoSWNO-DAUgAeQpwZg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 407B11891E88;
        Wed,  4 Nov 2020 15:21:22 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF4005C3E1;
        Wed,  4 Nov 2020 15:21:21 +0000 (UTC)
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
Subject: [PULL 26/33] block/nvme: Fix nvme_submit_command() on big-endian host
Date:   Wed,  4 Nov 2020 15:18:21 +0000
Message-Id: <20201104151828.405824-27-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKVGhlIENv
bXBsZXRpb24gUXVldWUgQ29tbWFuZCBJZGVudGlmaWVyIGlzIGEgMTYtYml0IHZhbHVlLApzbyBu
dm1lX3N1Ym1pdF9jb21tYW5kKCkgaXMgdW5saWtlbHkgdG8gd29yayBvbiBiaWctZW5kaWFuCmhv
c3RzLCBhcyB0aGUgcmVsZXZhbnQgYml0cyBhcmUgdHJ1bmNhdGVkLgpGaXggYnkgdXNpbmcgdGhl
IGNvcnJlY3QgYnl0ZS1zd2FwIGZ1bmN0aW9uLgoKRml4ZXM6IGJkZDZhOTBhOWU1ICgiYmxvY2s6
IEFkZCBWRklPIGJhc2VkIE5WTWUgZHJpdmVyIikKUmVwb3J0ZWQtYnk6IEtlaXRoIEJ1c2NoIDxr
YnVzY2hAa2VybmVsLm9yZz4KU2lnbmVkLW9mZi1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kg
PHBoaWxtZEByZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5o
YUByZWRoYXQuY29tPgpNZXNzYWdlLWlkOiAyMDIwMTAyOTA5MzMwNi4xMDYzODc5LTI1LXBoaWxt
ZEByZWRoYXQuY29tClNpZ25lZC1vZmYtYnk6IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVk
aGF0LmNvbT4KVGVzdGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Ci0t
LQogYmxvY2svbnZtZS5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvYmxvY2svbnZtZS5jIGIvYmxvY2svbnZtZS5jCmlu
ZGV4IGM4ZWY2OWNiYjIuLmEwNmExODhkNTMgMTAwNjQ0Ci0tLSBhL2Jsb2NrL252bWUuYworKysg
Yi9ibG9jay9udm1lLmMKQEAgLTQ2OSw3ICs0NjksNyBAQCBzdGF0aWMgdm9pZCBudm1lX3N1Ym1p
dF9jb21tYW5kKE5WTWVRdWV1ZVBhaXIgKnEsIE5WTWVSZXF1ZXN0ICpyZXEsCiAgICAgYXNzZXJ0
KCFyZXEtPmNiKTsKICAgICByZXEtPmNiID0gY2I7CiAgICAgcmVxLT5vcGFxdWUgPSBvcGFxdWU7
Ci0gICAgY21kLT5jaWQgPSBjcHVfdG9fbGUzMihyZXEtPmNpZCk7CisgICAgY21kLT5jaWQgPSBj
cHVfdG9fbGUxNihyZXEtPmNpZCk7CiAKICAgICB0cmFjZV9udm1lX3N1Ym1pdF9jb21tYW5kKHEt
PnMsIHEtPmluZGV4LCByZXEtPmNpZCk7CiAgICAgbnZtZV90cmFjZV9jb21tYW5kKGNtZCk7Ci0t
IAoyLjI4LjAKCg==

