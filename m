Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113092A674A
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbgKDPSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:18:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730490AbgKDPSo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:18:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uWbsFp7DBE9N9DNywJF9TpUh112RLQk5tV8p3cqgf6g=;
        b=i+iOPrzoqcn1c53qEt1TcfEvO7YDVWjyoJGdqF45ETgdzpYskv/FJZRRT6LxG++jeTC84S
        gfkZJ6sIrUXXXm6LxsTzVDPk6ccIp2ClGJpLscnYtgQh4+YwdwL/gPjPtySBoi68dsnRJB
        29bF1QURnb90cKtHs51y4JLMfLRO/18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-VPQui5vfNhu2ohf8eAiOMQ-1; Wed, 04 Nov 2020 10:18:39 -0500
X-MC-Unique: VPQui5vfNhu2ohf8eAiOMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 892431018F64;
        Wed,  4 Nov 2020 15:18:37 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBF5673664;
        Wed,  4 Nov 2020 15:18:33 +0000 (UTC)
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
Subject: [PULL 01/33] accel/kvm: add PIO ioeventfds only in case kvm_eventfds_allowed is true
Date:   Wed,  4 Nov 2020 15:17:56 +0000
Message-Id: <20201104151828.405824-2-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogRWxlbmEgQWZhbmFzb3ZhIDxlYWZhbmFzb3ZhQGdtYWlsLmNvbT4KClNpZ25lZC1vZmYt
Ynk6IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTog
RWxlbmEgQWZhbmFzb3ZhIDxlYWZhbmFzb3ZhQGdtYWlsLmNvbT4KTWVzc2FnZS1JZDogPDIwMjAx
MDE3MjEwMTAyLjI2MDM2LTEtZWFmYW5hc292YUBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0
ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0LmNvbT4KLS0tCiBhY2NlbC9rdm0va3ZtLWFs
bC5jIHwgNiArKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvYWNjZWwva3ZtL2t2bS1hbGwuYyBiL2FjY2VsL2t2bS9rdm0t
YWxsLmMKaW5kZXggOWVmNWRhZjRjNS4uYmFhYTU0MjQ5ZCAxMDA2NDQKLS0tIGEvYWNjZWwva3Zt
L2t2bS1hbGwuYworKysgYi9hY2NlbC9rdm0va3ZtLWFsbC5jCkBAIC0yMjM5LDggKzIyMzksMTAg
QEAgc3RhdGljIGludCBrdm1faW5pdChNYWNoaW5lU3RhdGUgKm1zKQogCiAgICAga3ZtX21lbW9y
eV9saXN0ZW5lcl9yZWdpc3RlcihzLCAmcy0+bWVtb3J5X2xpc3RlbmVyLAogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgJmFkZHJlc3Nfc3BhY2VfbWVtb3J5LCAwKTsKLSAgICBtZW1v
cnlfbGlzdGVuZXJfcmVnaXN0ZXIoJmt2bV9pb19saXN0ZW5lciwKLSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgJmFkZHJlc3Nfc3BhY2VfaW8pOworICAgIGlmIChrdm1fZXZlbnRmZHNfYWxs
b3dlZCkgeworICAgICAgICBtZW1vcnlfbGlzdGVuZXJfcmVnaXN0ZXIoJmt2bV9pb19saXN0ZW5l
ciwKKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZhZGRyZXNzX3NwYWNlX2lvKTsK
KyAgICB9CiAgICAgbWVtb3J5X2xpc3RlbmVyX3JlZ2lzdGVyKCZrdm1fY29hbGVzY2VkX3Bpb19s
aXN0ZW5lciwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJmFkZHJlc3Nfc3BhY2VfaW8p
OwogCi0tIAoyLjI4LjAKCg==

