Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C3A2A6749
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbgKDPSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:18:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730596AbgKDPSr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:18:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G0IJggGzUw2GPdTll1DH6CRZ2qMV3yjaBdQfe9tm6qw=;
        b=gPSF/XvtfCIQ8B4NXm/VScF1EzK22nfpK0+AR1vfk7O2jX+5tQA/LWfqpRF8h3olszBw0D
        6YembEmf+Y/nx/rf6rGgbOtfBH7RxvJtiZNlGWpbomU0HlE+cmNQfxb48X+yDWPT0wvcXO
        HKMkwx7ynro1PcjQ8POVRoHY1mELl9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-jY2_geqPPsmyTdX4PI8Uvw-1; Wed, 04 Nov 2020 10:18:44 -0500
X-MC-Unique: jY2_geqPPsmyTdX4PI8Uvw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 925E81087D71;
        Wed,  4 Nov 2020 15:18:42 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEFFE1007517;
        Wed,  4 Nov 2020 15:18:38 +0000 (UTC)
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
        Elena Afanasova <eafanasova@gmail.com>
Subject: [PULL 02/33] softmmu/memory: fix memory_region_ioeventfd_equal()
Date:   Wed,  4 Nov 2020 15:17:57 +0000
Message-Id: <20201104151828.405824-3-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogRWxlbmEgQWZhbmFzb3ZhIDxlYWZhbmFzb3ZhQGdtYWlsLmNvbT4KCkV2ZW50ZmQgY2Fu
IGJlIHJlZ2lzdGVyZWQgd2l0aCBhIHplcm8gbGVuZ3RoIHdoZW4gZmFzdF9tbWlvIGlzIHRydWUu
CkhhbmRsZSB0aGlzIGNhc2UgcHJvcGVybHkgd2hlbiBkaXNwYXRjaGluZyB0aHJvdWdoIFFFTVUu
CgpTaWduZWQtb2ZmLWJ5OiBFbGVuYSBBZmFuYXNvdmEgPGVhZmFuYXNvdmFAZ21haWwuY29tPgpN
ZXNzYWdlLWlkOiBjZjcxYTYyZWIwNGU2MTkzMmZmOGZmZGQwMmUwYjJhYWI0ZjQ5NWEwLmNhbWVs
QGdtYWlsLmNvbQpTaWduZWQtb2ZmLWJ5OiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhh
dC5jb20+Ci0tLQogc29mdG1tdS9tZW1vcnkuYyB8IDExICsrKysrKysrKy0tCiAxIGZpbGUgY2hh
bmdlZCwgOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3NvZnRt
bXUvbWVtb3J5LmMgYi9zb2Z0bW11L21lbW9yeS5jCmluZGV4IDIxZDUzM2Q4ZWQuLjhhYmE0MTE0
Y2YgMTAwNjQ0Ci0tLSBhL3NvZnRtbXUvbWVtb3J5LmMKKysrIGIvc29mdG1tdS9tZW1vcnkuYwpA
QCAtMjA1LDggKzIwNSwxNSBAQCBzdGF0aWMgYm9vbCBtZW1vcnlfcmVnaW9uX2lvZXZlbnRmZF9i
ZWZvcmUoTWVtb3J5UmVnaW9uSW9ldmVudGZkICphLAogc3RhdGljIGJvb2wgbWVtb3J5X3JlZ2lv
bl9pb2V2ZW50ZmRfZXF1YWwoTWVtb3J5UmVnaW9uSW9ldmVudGZkICphLAogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgTWVtb3J5UmVnaW9uSW9ldmVudGZkICpiKQog
ewotICAgIHJldHVybiAhbWVtb3J5X3JlZ2lvbl9pb2V2ZW50ZmRfYmVmb3JlKGEsIGIpCi0gICAg
ICAgICYmICFtZW1vcnlfcmVnaW9uX2lvZXZlbnRmZF9iZWZvcmUoYiwgYSk7CisgICAgaWYgKGlu
dDEyOF9lcShhLT5hZGRyLnN0YXJ0LCBiLT5hZGRyLnN0YXJ0KSAmJgorICAgICAgICAoIWludDEy
OF9ueihhLT5hZGRyLnNpemUpIHx8ICFpbnQxMjhfbnooYi0+YWRkci5zaXplKSB8fAorICAgICAg
ICAgKGludDEyOF9lcShhLT5hZGRyLnNpemUsIGItPmFkZHIuc2l6ZSkgJiYKKyAgICAgICAgICAo
YS0+bWF0Y2hfZGF0YSA9PSBiLT5tYXRjaF9kYXRhKSAmJgorICAgICAgICAgICgoYS0+bWF0Y2hf
ZGF0YSAmJiAoYS0+ZGF0YSA9PSBiLT5kYXRhKSkgfHwgIWEtPm1hdGNoX2RhdGEpICYmCisgICAg
ICAgICAgKGEtPmUgPT0gYi0+ZSkpKSkKKyAgICAgICAgcmV0dXJuIHRydWU7CisKKyAgICByZXR1
cm4gZmFsc2U7CiB9CiAKIC8qIFJhbmdlIG9mIG1lbW9yeSBpbiB0aGUgZ2xvYmFsIG1hcC4gIEFk
ZHJlc3NlcyBhcmUgYWJzb2x1dGUuICovCi0tIAoyLjI4LjAKCg==

