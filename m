Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC2920A068
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 15:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405221AbgFYN6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 09:58:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34079 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405218AbgFYN6N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 09:58:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593093492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HP9THfq0e57aimyJmnA5TRP+h5ylmLpPTeTOZs2TrL8=;
        b=TGA8QPs1CLc/mZaLSCExffKxwkck00FCcBzwTxgWfdbIHMbPs1JjUBcxPDW7yGLeUXLNU6
        5nyM0aTgl6hro70k9ZWq7NFbCsYxpuUPH1dTDuag6EbUg7lX/gWWTQAolpnotin37Chrad
        zGaNrRq3hcVAarw3jpngMJVcVzJRFx4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-qAq2OK1TOByuX1mhSoJ6uQ-1; Thu, 25 Jun 2020 09:58:10 -0400
X-MC-Unique: qAq2OK1TOByuX1mhSoJ6uQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EBC7464;
        Thu, 25 Jun 2020 13:58:09 +0000 (UTC)
Received: from localhost (ovpn-115-49.ams2.redhat.com [10.36.115.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D98C860C1D;
        Thu, 25 Jun 2020 13:58:08 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC 3/3] virtio-blk: use NUMA-aware memory allocation in probe
Date:   Thu, 25 Jun 2020 14:57:52 +0100
Message-Id: <20200625135752.227293-4-stefanha@redhat.com>
In-Reply-To: <20200625135752.227293-1-stefanha@redhat.com>
References: <20200625135752.227293-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWxsb2NhdGUgZnJlcXVlbnRseS1hY2Nlc3NlZCBkYXRhIHN0cnVjdHVyZXMgZnJvbSB0aGUgTlVN
QSBub2RlCmFzc29jaWF0ZWQgd2l0aCB0aGlzIGRldmljZSB0byBhdm9pZCBzbG93IGNyb3NzLU5V
TUEgbm9kZSBtZW1vcnkKYWNjZXNzZXMuCgpPbmx5IHRoZSBmb2xsb3dpbmcgbWVtb3J5IGFsbG9j
YXRpb25zIGFyZSBtYWRlIE5VTUEtYXdhcmU6CgoxLiBDYWxsZWQgZHVyaW5nIHByb2JlLiBJZiBj
YWxsZWQgaW4gdGhlIGRhdGEgcGF0aCB0aGVuIGhvcGVmdWxseSB3ZSdyZQogICBleGVjdXRpbmcg
b24gYSBDUFUgaW4gdGhlIHNhbWUgTlVNQSBub2RlIGFzIHRoZSBkZXZpY2UuIElmIHRoZSBDUFUg
aXMKICAgbm90IGluIHRoZSByaWdodCBOVU1BIG5vZGUgdGhlbiBpdCdzIHVuY2xlYXIgd2hldGhl
ciBmb3JjaW5nIG1lbW9yeQogICBhbGxvY2F0aW9ucyB0byB1c2UgdGhlIGRldmljZSdzIE5VTUEg
bm9kZSB3aWxsIGluY3JlYXNlIG9yIGRlY3JlYXNlCiAgIHBlcmZvcm1hbmNlLgoKMi4gTWVtb3J5
IHdpbGwgYmUgZnJlcXVlbnRseSBhY2Nlc3NlZCBmcm9tIHRoZSBkYXRhIHBhdGguIFRoZXJlIGlz
IG5vCiAgIG5lZWQgdG8gd29ycnkgYWJvdXQgZGF0YSB0aGF0IGlzIG5vdCBhY2Nlc3NlZCBmcm9t
CiAgIHBlcmZvcm1hbmNlLWNyaXRpY2FsIGNvZGUgcGF0aHMuCgpTaWduZWQtb2ZmLWJ5OiBTdGVm
YW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+Ci0tLQogZHJpdmVycy9ibG9jay92aXJ0
aW9fYmxrLmMgfCA3ICsrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9jay92aXJ0aW9fYmxrLmMgYi9k
cml2ZXJzL2Jsb2NrL3ZpcnRpb19ibGsuYwppbmRleCA5ZDIxYmYwZjE1NWUuLjQwODQ1ZTlhZDNi
MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ibG9jay92aXJ0aW9fYmxrLmMKKysrIGIvZHJpdmVycy9i
bG9jay92aXJ0aW9fYmxrLmMKQEAgLTQ4Miw2ICs0ODIsNyBAQCBzdGF0aWMgaW50IGluaXRfdnEo
c3RydWN0IHZpcnRpb19ibGsgKnZibGspCiAJdW5zaWduZWQgc2hvcnQgbnVtX3ZxczsKIAlzdHJ1
Y3QgdmlydGlvX2RldmljZSAqdmRldiA9IHZibGstPnZkZXY7CiAJc3RydWN0IGlycV9hZmZpbml0
eSBkZXNjID0geyAwLCB9OworCWludCBub2RlID0gZGV2X3RvX25vZGUoJnZkZXYtPmRldik7CiAK
IAllcnIgPSB2aXJ0aW9fY3JlYWRfZmVhdHVyZSh2ZGV2LCBWSVJUSU9fQkxLX0ZfTVEsCiAJCQkJ
ICAgc3RydWN0IHZpcnRpb19ibGtfY29uZmlnLCBudW1fcXVldWVzLApAQCAtNDkxLDcgKzQ5Miw4
IEBAIHN0YXRpYyBpbnQgaW5pdF92cShzdHJ1Y3QgdmlydGlvX2JsayAqdmJsaykKIAogCW51bV92
cXMgPSBtaW5fdCh1bnNpZ25lZCBpbnQsIG5yX2NwdV9pZHMsIG51bV92cXMpOwogCi0JdmJsay0+
dnFzID0ga21hbGxvY19hcnJheShudW1fdnFzLCBzaXplb2YoKnZibGstPnZxcyksIEdGUF9LRVJO
RUwpOworCXZibGstPnZxcyA9IGttYWxsb2NfYXJyYXlfbm9kZShudW1fdnFzLCBzaXplb2YoKnZi
bGstPnZxcyksCisJCQkJICAgICAgIEdGUF9LRVJORUwsIG5vZGUpOwogCWlmICghdmJsay0+dnFz
KQogCQlyZXR1cm4gLUVOT01FTTsKIApAQCAtNjgzLDYgKzY4NSw3IEBAIG1vZHVsZV9wYXJhbV9u
YW1lZChxdWV1ZV9kZXB0aCwgdmlydGJsa19xdWV1ZV9kZXB0aCwgdWludCwgMDQ0NCk7CiAKIHN0
YXRpYyBpbnQgdmlydGJsa19wcm9iZShzdHJ1Y3QgdmlydGlvX2RldmljZSAqdmRldikKIHsKKwlp
bnQgbm9kZSA9IGRldl90b19ub2RlKCZ2ZGV2LT5kZXYpOwogCXN0cnVjdCB2aXJ0aW9fYmxrICp2
YmxrOwogCXN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxOwogCWludCBlcnIsIGluZGV4OwpAQCAtNzE0
LDcgKzcxNyw3IEBAIHN0YXRpYyBpbnQgdmlydGJsa19wcm9iZShzdHJ1Y3QgdmlydGlvX2Rldmlj
ZSAqdmRldikKIAogCS8qIFdlIG5lZWQgYW4gZXh0cmEgc2cgZWxlbWVudHMgYXQgaGVhZCBhbmQg
dGFpbC4gKi8KIAlzZ19lbGVtcyArPSAyOwotCXZkZXYtPnByaXYgPSB2YmxrID0ga21hbGxvYyhz
aXplb2YoKnZibGspLCBHRlBfS0VSTkVMKTsKKwl2ZGV2LT5wcml2ID0gdmJsayA9IGttYWxsb2Nf
bm9kZShzaXplb2YoKnZibGspLCBHRlBfS0VSTkVMLCBub2RlKTsKIAlpZiAoIXZibGspIHsKIAkJ
ZXJyID0gLUVOT01FTTsKIAkJZ290byBvdXRfZnJlZV9pbmRleDsKLS0gCjIuMjYuMgoK

