Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BD52A6772
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbgKDPVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:21:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730196AbgKDPVk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:21:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vuNz3GkacsWeTmhvyPsZFHJuTLmoIxG/n/YnP03+TvU=;
        b=Fkds53Qoq+LHdZ/yDbyCdH4PxYDfRsMlyb0wItLyzOsdX20guAh2LE6B+Sx/X72EbUp7KA
        PCrfQmfDF8d7aoXbL7l/dq5SdcshHW3WRgbhDx8cYRnHJyMHwqSJfXCizcYcEFw8AGn/fV
        DUe0oo/x+DLJhcOEk73F5FC9AWrMyfk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-43FzwHe2PIC-fJ0orVjPnA-1; Wed, 04 Nov 2020 10:21:34 -0500
X-MC-Unique: 43FzwHe2PIC-fJ0orVjPnA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEFD6101F7A7;
        Wed,  4 Nov 2020 15:21:32 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68F8F5DA6B;
        Wed,  4 Nov 2020 15:21:23 +0000 (UTC)
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
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PULL 27/33] util/vfio-helpers: Improve reporting unsupported IOMMU type
Date:   Wed,  4 Nov 2020 15:18:22 +0000
Message-Id: <20201104151828.405824-28-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKQ2hhbmdl
IHRoZSBjb25mdXNlICJWRklPIElPTU1VIGNoZWNrIGZhaWxlZCIgZXJyb3IgbWVzc2FnZSBieQp0
aGUgZXhwbGljaXQgIlZGSU8gSU9NTVUgVHlwZTEgaXMgbm90IHN1cHBvcnRlZCIgb25jZS4KCkV4
YW1wbGUgb24gUE9XRVI6CgogJCBxZW11LXN5c3RlbS1wcGM2NCAtZHJpdmUgaWY9bm9uZSxpZD1u
dm1lMCxmaWxlPW52bWU6Ly8wMDAxOjAxOjAwLjAvMSxmb3JtYXQ9cmF3CiBxZW11LXN5c3RlbS1w
cGM2NDogLWRyaXZlIGlmPW5vbmUsaWQ9bnZtZTAsZmlsZT1udm1lOi8vMDAwMTowMTowMC4wLzEs
Zm9ybWF0PXJhdzogVkZJTyBJT01NVSBUeXBlMSBpcyBub3Qgc3VwcG9ydGVkCgpTdWdnZXN0ZWQt
Ynk6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+ClJldmlld2Vk
LWJ5OiBGYW0gWmhlbmcgPGZhbUBldXBob24ubmV0PgpSZXZpZXdlZC1ieTogU3RlZmFuIEhham5v
Y3ppIDxzdGVmYW5oYUByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBQaGlsaXBwZSBNYXRoaWV1
LURhdWTDqSA8cGhpbG1kQHJlZGhhdC5jb20+Ck1lc3NhZ2UtaWQ6IDIwMjAxMTAzMDIwNzMzLjIz
MDMxNDgtMi1waGlsbWRAcmVkaGF0LmNvbQpTaWduZWQtb2ZmLWJ5OiBTdGVmYW4gSGFqbm9jemkg
PHN0ZWZhbmhhQHJlZGhhdC5jb20+ClRlc3RlZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckBy
ZWRoYXQuY29tPgotLS0KIHV0aWwvdmZpby1oZWxwZXJzLmMgfCAyICstCiAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS91dGlsL3ZmaW8t
aGVscGVycy5jIGIvdXRpbC92ZmlvLWhlbHBlcnMuYwppbmRleCBjNDY5YmViMDYxLi4xNGE1NDk1
MTBmIDEwMDY0NAotLS0gYS91dGlsL3ZmaW8taGVscGVycy5jCisrKyBiL3V0aWwvdmZpby1oZWxw
ZXJzLmMKQEAgLTMwMCw3ICszMDAsNyBAQCBzdGF0aWMgaW50IHFlbXVfdmZpb19pbml0X3BjaShR
RU1VVkZJT1N0YXRlICpzLCBjb25zdCBjaGFyICpkZXZpY2UsCiAgICAgfQogCiAgICAgaWYgKCFp
b2N0bChzLT5jb250YWluZXIsIFZGSU9fQ0hFQ0tfRVhURU5TSU9OLCBWRklPX1RZUEUxX0lPTU1V
KSkgewotICAgICAgICBlcnJvcl9zZXRnX2Vycm5vKGVycnAsIGVycm5vLCAiVkZJTyBJT01NVSBj
aGVjayBmYWlsZWQiKTsKKyAgICAgICAgZXJyb3Jfc2V0Z19lcnJubyhlcnJwLCBlcnJubywgIlZG
SU8gSU9NTVUgVHlwZTEgaXMgbm90IHN1cHBvcnRlZCIpOwogICAgICAgICByZXQgPSAtRUlOVkFM
OwogICAgICAgICBnb3RvIGZhaWxfY29udGFpbmVyOwogICAgIH0KLS0gCjIuMjguMAoK

