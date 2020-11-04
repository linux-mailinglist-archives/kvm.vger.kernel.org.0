Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABAA2A675F
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbgKDPU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:20:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbgKDPU1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:20:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nmZBS99iFDnZn7fva4LVrBMSpGF1u0oIe5AGDQxIRi0=;
        b=Tcrl4dDOgT8BD2NFm4JotzlCp+K3nSERotg+p5FFQ/UE7rlWSP43O47qfcVM0N+UhjbVpN
        nFMpR5aR92RG7/9/nGm9sS5zlHfZz+Cu8muGSYIADr+eODsCWTR+NJz59xoLLJHzza9Rpl
        OBYtuC0DNMkUqwL2Hh5ZY205TNo7I54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-C0lmJPs9MImVDsI707OigA-1; Wed, 04 Nov 2020 10:20:20 -0500
X-MC-Unique: C0lmJPs9MImVDsI707OigA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 922EE804763;
        Wed,  4 Nov 2020 15:20:18 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC2C55B4C7;
        Wed,  4 Nov 2020 15:20:11 +0000 (UTC)
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
Subject: [PULL 14/33] block/nvme: Introduce Completion Queue definitions
Date:   Wed,  4 Nov 2020 15:18:09 +0000
Message-Id: <20201104151828.405824-15-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKUmVuYW1l
IFN1Ym1pc3Npb24gUXVldWUgZmxhZ3Mgd2l0aCAnU3EnIHRvIGRpZmZlcmVudGlhdGUKc3VibWlz
c2lvbiBxdWV1ZSBmbGFncyBmcm9tIGNvbW1hbmQgcXVldWUgZmxhZ3MsIGFuZCBpbnRyb2R1Y2UK
Q29tcGxldGlvbiBRdWV1ZSBmbGFnIGRlZmluaXRpb25zLgoKUmV2aWV3ZWQtYnk6IEVyaWMgQXVn
ZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KVGVzdGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1
Z2VyQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIDxw
aGlsbWRAcmVkaGF0LmNvbT4KUmV2aWV3ZWQtYnk6IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFA
cmVkaGF0LmNvbT4KTWVzc2FnZS1pZDogMjAyMDEwMjkwOTMzMDYuMTA2Mzg3OS0xMy1waGlsbWRA
cmVkaGF0LmNvbQpTaWduZWQtb2ZmLWJ5OiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhh
dC5jb20+ClRlc3RlZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgotLS0K
IGluY2x1ZGUvYmxvY2svbnZtZS5oIHwgMTggKysrKysrKysrKysrLS0tLS0tCiAxIGZpbGUgY2hh
bmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNs
dWRlL2Jsb2NrL252bWUuaCBiL2luY2x1ZGUvYmxvY2svbnZtZS5oCmluZGV4IDhhNDZkOWNmMDEu
LjNlMDJkOWNhOTggMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvYmxvY2svbnZtZS5oCisrKyBiL2luY2x1
ZGUvYmxvY2svbnZtZS5oCkBAIC01MDEsNiArNTAxLDExIEBAIHR5cGVkZWYgc3RydWN0IFFFTVVf
UEFDS0VEIE52bWVDcmVhdGVDcSB7CiAjZGVmaW5lIE5WTUVfQ1FfRkxBR1NfUEMoY3FfZmxhZ3Mp
ICAoY3FfZmxhZ3MgJiAweDEpCiAjZGVmaW5lIE5WTUVfQ1FfRkxBR1NfSUVOKGNxX2ZsYWdzKSAo
KGNxX2ZsYWdzID4+IDEpICYgMHgxKQogCitlbnVtIE52bWVGbGFnc0NxIHsKKyAgICBOVk1FX0NR
X1BDICAgICAgICAgID0gMSwKKyAgICBOVk1FX0NRX0lFTiAgICAgICAgID0gMiwKK307CisKIHR5
cGVkZWYgc3RydWN0IFFFTVVfUEFDS0VEIE52bWVDcmVhdGVTcSB7CiAgICAgdWludDhfdCAgICAg
b3Bjb2RlOwogICAgIHVpbnQ4X3QgICAgIGZsYWdzOwpAQCAtNTE4LDEyICs1MjMsMTMgQEAgdHlw
ZWRlZiBzdHJ1Y3QgUUVNVV9QQUNLRUQgTnZtZUNyZWF0ZVNxIHsKICNkZWZpbmUgTlZNRV9TUV9G
TEFHU19QQyhzcV9mbGFncykgICAgICAoc3FfZmxhZ3MgJiAweDEpCiAjZGVmaW5lIE5WTUVfU1Ff
RkxBR1NfUVBSSU8oc3FfZmxhZ3MpICAgKChzcV9mbGFncyA+PiAxKSAmIDB4MykKIAotZW51bSBO
dm1lUXVldWVGbGFncyB7Ci0gICAgTlZNRV9RX1BDICAgICAgICAgICA9IDEsCi0gICAgTlZNRV9R
X1BSSU9fVVJHRU5UICA9IDAsCi0gICAgTlZNRV9RX1BSSU9fSElHSCAgICA9IDEsCi0gICAgTlZN
RV9RX1BSSU9fTk9STUFMICA9IDIsCi0gICAgTlZNRV9RX1BSSU9fTE9XICAgICA9IDMsCitlbnVt
IE52bWVGbGFnc1NxIHsKKyAgICBOVk1FX1NRX1BDICAgICAgICAgID0gMSwKKworICAgIE5WTUVf
U1FfUFJJT19VUkdFTlQgPSAwLAorICAgIE5WTUVfU1FfUFJJT19ISUdIICAgPSAxLAorICAgIE5W
TUVfU1FfUFJJT19OT1JNQUwgPSAyLAorICAgIE5WTUVfU1FfUFJJT19MT1cgICAgPSAzLAogfTsK
IAogdHlwZWRlZiBzdHJ1Y3QgUUVNVV9QQUNLRUQgTnZtZUlkZW50aWZ5IHsKLS0gCjIuMjguMAoK

