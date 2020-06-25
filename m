Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8142F20A066
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 15:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405194AbgFYN6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 09:58:08 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50936 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404890AbgFYN6H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 09:58:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593093485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I02RA+QYEkrvsrT/YPtoqYBWwQdCy39TUmoOUKOxREo=;
        b=a/wItYx+hLrle+LsB2fIkCtWyzfoIbFk9gIszn3n5aCLqGAjNxO4O6W+4V48GN+k02jbH3
        JX2krh4NLSnscjOkg/wrT0HjdqbFmhVM/Xbu9J8Io1CAp+n/2QD5EqEi6r/yScXYtGyFHR
        FjRQVLYrb5iIhgD+Z9Yhuc9BwkDp1PM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-K8C6TJENOjamXr91Nc0bMQ-1; Thu, 25 Jun 2020 09:58:03 -0400
X-MC-Unique: K8C6TJENOjamXr91Nc0bMQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69B86804001;
        Thu, 25 Jun 2020 13:58:02 +0000 (UTC)
Received: from localhost (ovpn-115-49.ams2.redhat.com [10.36.115.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F94619D61;
        Thu, 25 Jun 2020 13:57:58 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC 1/3] virtio-pci: use NUMA-aware memory allocation in probe
Date:   Thu, 25 Jun 2020 14:57:50 +0100
Message-Id: <20200625135752.227293-2-stefanha@redhat.com>
In-Reply-To: <20200625135752.227293-1-stefanha@redhat.com>
References: <20200625135752.227293-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWxsb2NhdGUgZnJlcXVlbnRseS1hY2Nlc3NlZCBkYXRhIHN0cnVjdHVyZXMgZnJvbSB0aGUgTlVN
QSBub2RlCmFzc29jaWF0ZWQgd2l0aCB0aGlzIHZpcnRpby1wY2kgZGV2aWNlLiBUaGlzIGF2b2lk
cyBzbG93IGNyb3NzLU5VTUEgbm9kZQptZW1vcnkgYWNjZXNzZXMuCgpPbmx5IHRoZSBmb2xsb3dp
bmcgbWVtb3J5IGFsbG9jYXRpb25zIGFyZSBtYWRlIE5VTUEtYXdhcmU6CgoxLiBDYWxsZWQgZHVy
aW5nIHByb2JlLiBJZiBjYWxsZWQgaW4gdGhlIGRhdGEgcGF0aCB0aGVuIGhvcGVmdWxseSB3ZSdy
ZQogICBleGVjdXRpbmcgb24gYSBDUFUgaW4gdGhlIHNhbWUgTlVNQSBub2RlIGFzIHRoZSBkZXZp
Y2UuIElmIHRoZSBDUFUgaXMKICAgbm90IGluIHRoZSByaWdodCBOVU1BIG5vZGUgdGhlbiBpdCdz
IHVuY2xlYXIgd2hldGhlciBmb3JjaW5nIG1lbW9yeQogICBhbGxvY2F0aW9ucyB0byB1c2UgdGhl
IGRldmljZSdzIE5VTUEgbm9kZSB3aWxsIGluY3JlYXNlIG9yIGRlY3JlYXNlCiAgIHBlcmZvcm1h
bmNlLgoKMi4gTWVtb3J5IHdpbGwgYmUgZnJlcXVlbnRseSBhY2Nlc3NlZCBmcm9tIHRoZSBkYXRh
IHBhdGguIFRoZXJlIGlzIG5vCiAgIG5lZWQgdG8gd29ycnkgYWJvdXQgZGF0YSB0aGF0IGlzIG5v
dCBhY2Nlc3NlZCBmcm9tCiAgIHBlcmZvcm1hbmNlLWNyaXRpY2FsIGNvZGUgcGF0aHMuCgpTaWdu
ZWQtb2ZmLWJ5OiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+Ci0tLQogZHJp
dmVycy92aXJ0aW8vdmlydGlvX3BjaV9jb21tb24uYyB8IDE2ICsrKysrKysrKysrKy0tLS0KIDEg
ZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdmlydGlvL3ZpcnRpb19wY2lfY29tbW9uLmMgYi9kcml2ZXJzL3ZpcnRpby92
aXJ0aW9fcGNpX2NvbW1vbi5jCmluZGV4IDIyMmQ2MzBjNDFmYy4uY2M2ZTQ5ZjljNjk4IDEwMDY0
NAotLS0gYS9kcml2ZXJzL3ZpcnRpby92aXJ0aW9fcGNpX2NvbW1vbi5jCisrKyBiL2RyaXZlcnMv
dmlydGlvL3ZpcnRpb19wY2lfY29tbW9uLmMKQEAgLTE3OCwxMSArMTc4LDEzIEBAIHN0YXRpYyBz
dHJ1Y3QgdmlydHF1ZXVlICp2cF9zZXR1cF92cShzdHJ1Y3QgdmlydGlvX2RldmljZSAqdmRldiwg
dW5zaWduZWQgaW5kZXgsCiAJCQkJICAgICB1MTYgbXNpeF92ZWMpCiB7CiAJc3RydWN0IHZpcnRp
b19wY2lfZGV2aWNlICp2cF9kZXYgPSB0b192cF9kZXZpY2UodmRldik7Ci0Jc3RydWN0IHZpcnRp
b19wY2lfdnFfaW5mbyAqaW5mbyA9IGttYWxsb2Moc2l6ZW9mICppbmZvLCBHRlBfS0VSTkVMKTsK
KwlpbnQgbm9kZSA9IGRldl90b19ub2RlKCZ2ZGV2LT5kZXYpOworCXN0cnVjdCB2aXJ0aW9fcGNp
X3ZxX2luZm8gKmluZm87CiAJc3RydWN0IHZpcnRxdWV1ZSAqdnE7CiAJdW5zaWduZWQgbG9uZyBm
bGFnczsKIAogCS8qIGZpbGwgb3V0IG91ciBzdHJ1Y3R1cmUgdGhhdCByZXByZXNlbnRzIGFuIGFj
dGl2ZSBxdWV1ZSAqLworCWluZm8gPSBrbWFsbG9jX25vZGUoc2l6ZW9mICppbmZvLCBHRlBfS0VS
TkVMLCBub2RlKTsKIAlpZiAoIWluZm8pCiAJCXJldHVybiBFUlJfUFRSKC1FTk9NRU0pOwogCkBA
IC0yODMsMTAgKzI4NSwxMiBAQCBzdGF0aWMgaW50IHZwX2ZpbmRfdnFzX21zaXgoc3RydWN0IHZp
cnRpb19kZXZpY2UgKnZkZXYsIHVuc2lnbmVkIG52cXMsCiAJCXN0cnVjdCBpcnFfYWZmaW5pdHkg
KmRlc2MpCiB7CiAJc3RydWN0IHZpcnRpb19wY2lfZGV2aWNlICp2cF9kZXYgPSB0b192cF9kZXZp
Y2UodmRldik7CisJaW50IG5vZGUgPSBkZXZfdG9fbm9kZSgmdmRldi0+ZGV2KTsKIAl1MTYgbXNp
eF92ZWM7CiAJaW50IGksIGVyciwgbnZlY3RvcnMsIGFsbG9jYXRlZF92ZWN0b3JzLCBxdWV1ZV9p
ZHggPSAwOwogCi0JdnBfZGV2LT52cXMgPSBrY2FsbG9jKG52cXMsIHNpemVvZigqdnBfZGV2LT52
cXMpLCBHRlBfS0VSTkVMKTsKKwl2cF9kZXYtPnZxcyA9IGtjYWxsb2Nfbm9kZShudnFzLCBzaXpl
b2YoKnZwX2Rldi0+dnFzKSwKKwkJCQkgICBHRlBfS0VSTkVMLCBub2RlKTsKIAlpZiAoIXZwX2Rl
di0+dnFzKQogCQlyZXR1cm4gLUVOT01FTTsKIApAQCAtMzU1LDkgKzM1OSwxMSBAQCBzdGF0aWMg
aW50IHZwX2ZpbmRfdnFzX2ludHgoc3RydWN0IHZpcnRpb19kZXZpY2UgKnZkZXYsIHVuc2lnbmVk
IG52cXMsCiAJCWNvbnN0IGNoYXIgKiBjb25zdCBuYW1lc1tdLCBjb25zdCBib29sICpjdHgpCiB7
CiAJc3RydWN0IHZpcnRpb19wY2lfZGV2aWNlICp2cF9kZXYgPSB0b192cF9kZXZpY2UodmRldik7
CisJaW50IG5vZGUgPSBkZXZfdG9fbm9kZSgmdmRldi0+ZGV2KTsKIAlpbnQgaSwgZXJyLCBxdWV1
ZV9pZHggPSAwOwogCi0JdnBfZGV2LT52cXMgPSBrY2FsbG9jKG52cXMsIHNpemVvZigqdnBfZGV2
LT52cXMpLCBHRlBfS0VSTkVMKTsKKwl2cF9kZXYtPnZxcyA9IGtjYWxsb2Nfbm9kZShudnFzLCBz
aXplb2YoKnZwX2Rldi0+dnFzKSwKKwkJCQkgICBHRlBfS0VSTkVMLCBub2RlKTsKIAlpZiAoIXZw
X2Rldi0+dnFzKQogCQlyZXR1cm4gLUVOT01FTTsKIApAQCAtNTEzLDEwICs1MTksMTIgQEAgc3Rh
dGljIGludCB2aXJ0aW9fcGNpX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwY2lfZGV2LAogCQkJICAg
IGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICppZCkKIHsKIAlzdHJ1Y3QgdmlydGlvX3BjaV9k
ZXZpY2UgKnZwX2RldiwgKnJlZ19kZXYgPSBOVUxMOworCWludCBub2RlID0gZGV2X3RvX25vZGUo
JnBjaV9kZXYtPmRldik7CiAJaW50IHJjOwogCiAJLyogYWxsb2NhdGUgb3VyIHN0cnVjdHVyZSBh
bmQgZmlsbCBpdCBvdXQgKi8KLQl2cF9kZXYgPSBremFsbG9jKHNpemVvZihzdHJ1Y3QgdmlydGlv
X3BjaV9kZXZpY2UpLCBHRlBfS0VSTkVMKTsKKwl2cF9kZXYgPSBremFsbG9jX25vZGUoc2l6ZW9m
KHN0cnVjdCB2aXJ0aW9fcGNpX2RldmljZSksCisJCQkgICAgICBHRlBfS0VSTkVMLCBub2RlKTsK
IAlpZiAoIXZwX2RldikKIAkJcmV0dXJuIC1FTk9NRU07CiAKLS0gCjIuMjYuMgoK

