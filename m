Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D31920A064
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 15:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405145AbgFYN6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 09:58:04 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23056 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404890AbgFYN6D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 09:58:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593093482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=a3sOV0ZHvCtW1jwkrpJy23JJcAH66RTksrishZc28jc=;
        b=YPKwJLXGrBpLwxeIymWJ+tB3RiMv/gznx0/2Sac2F5Y0Lnx3tJXOv8VXCfq19gLk2vFDbf
        NpjJtkZxgkRNI3MhnYxgRim1vwOWnV14lmd85WHqwD0Y506GEJhKVfgj+7MyNvfepec5k+
        k0I8vNa1nPQqRTO4nsx4eFLZpDXIzFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-rMkuzU0sPliCfnKdECi-2w-1; Thu, 25 Jun 2020 09:57:58 -0400
X-MC-Unique: rMkuzU0sPliCfnKdECi-2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E5751940920;
        Thu, 25 Jun 2020 13:57:57 +0000 (UTC)
Received: from localhost (ovpn-115-49.ams2.redhat.com [10.36.115.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCF521DC;
        Thu, 25 Jun 2020 13:57:53 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC 0/3] virtio: NUMA-aware memory allocation
Date:   Thu, 25 Jun 2020 14:57:49 +0100
Message-Id: <20200625135752.227293-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlc2UgcGF0Y2hlcyBhcmUgbm90IHJlYWR5IHRvIGJlIG1lcmdlZCBiZWNhdXNlIEkgd2FzIHVu
YWJsZSB0byBtZWFzdXJlIGENCnBlcmZvcm1hbmNlIGltcHJvdmVtZW50LiBJJ20gcHVibGlzaGlu
ZyB0aGVtIHNvIHRoZXkgYXJlIGFyY2hpdmVkIGluIGNhc2UNCnNvbWVvbmUgcGlja3MgdXAgdGhp
cyB3b3JrIGFnYWluIGluIHRoZSBmdXR1cmUuDQoNClRoZSBnb2FsIG9mIHRoZXNlIHBhdGNoZXMg
aXMgdG8gYWxsb2NhdGUgdmlydHF1ZXVlcyBhbmQgZHJpdmVyIHN0YXRlIGZyb20gdGhlDQpkZXZp
Y2UncyBOVU1BIG5vZGUgZm9yIG9wdGltYWwgbWVtb3J5IGFjY2VzcyBsYXRlbmN5LiBPbmx5IGd1
ZXN0cyB3aXRoIGEgdk5VTUENCnRvcG9sb2d5IGFuZCB2aXJ0aW8gZGV2aWNlcyBzcHJlYWQgYWNy
b3NzIHZOVU1BIG5vZGVzIGJlbmVmaXQgZnJvbSB0aGlzLiAgSW4NCm90aGVyIGNhc2VzIHRoZSBt
ZW1vcnkgcGxhY2VtZW50IGlzIGZpbmUgYW5kIHdlIGRvbid0IG5lZWQgdG8gdGFrZSBOVU1BIGlu
dG8NCmFjY291bnQgaW5zaWRlIHRoZSBndWVzdC4NCg0KVGhlc2UgcGF0Y2hlcyBjb3VsZCBiZSBl
eHRlbmRlZCB0byB2aXJ0aW9fbmV0LmtvIGFuZCBvdGhlciBkZXZpY2VzIGluIHRoZQ0KZnV0dXJl
LiBJIG9ubHkgdGVzdGVkIHZpcnRpb19ibGsua28uDQoNClRoZSBiZW5jaG1hcmsgY29uZmlndXJh
dGlvbiB3YXMgZGVzaWduZWQgdG8gdHJpZ2dlciB3b3JzdC1jYXNlIE5VTUEgcGxhY2VtZW50Og0K
ICogUGh5c2ljYWwgTlZNZSBzdG9yYWdlIGNvbnRyb2xsZXIgb24gaG9zdCBOVU1BIG5vZGUgMA0K
ICogSU9UaHJlYWQgcGlubmVkIHRvIGhvc3QgTlVNQSBub2RlIDANCiAqIHZpcnRpby1ibGstcGNp
IGRldmljZSBpbiB2TlVNQSBub2RlIDENCiAqIHZDUFUgMCBvbiBob3N0IE5VTUEgbm9kZSAxIGFu
ZCB2Q1BVIDEgb24gaG9zdCBOVU1BIG5vZGUgMA0KICogdkNQVSAwIGluIHZOVU1BIG5vZGUgMCBh
bmQgdkNQVSAxIGluIHZOVU1BIG5vZGUgMQ0KDQpUaGUgaW50ZW50IGlzIHRvIGhhdmUgLnByb2Jl
KCkgY29kZSBydW4gb24gdkNQVSAwIGluIHZOVU1BIG5vZGUgMCAoaG9zdCBOVU1BDQpub2RlIDEp
IHNvIHRoYXQgbWVtb3J5IGlzIGluIHRoZSB3cm9uZyBOVU1BIG5vZGUgZm9yIHRoZSB2aXJ0aW8t
YmxrLXBjaSBkZXZpYz0NCmUuDQpBcHBseWluZyB0aGVzZSBwYXRjaGVzIGZpeGVzIG1lbW9yeSBw
bGFjZW1lbnQgc28gdGhhdCB2aXJ0cXVldWVzIGFuZCBkcml2ZXINCnN0YXRlIGlzIGFsbG9jYXRl
ZCBpbiB2TlVNQSBub2RlIDEgd2hlcmUgdGhlIHZpcnRpby1ibGstcGNpIGRldmljZSBpcyBsb2Nh
dGVkLg0KDQpUaGUgZmlvIDRLQiByYW5kcmVhZCBiZW5jaG1hcmsgcmVzdWx0cyBkbyBub3Qgc2hv
dyBhIHNpZ25pZmljYW50IGltcHJvdmVtZW50Og0KDQpOYW1lICAgICAgICAgICAgICAgICAgSU9Q
UyAgIEVycm9yDQp2aXJ0aW8tYmxrICAgICAgICA0MjM3My43OSA9QzI9QjEgMC41NCUNCnZpcnRp
by1ibGstbnVtYSAgIDQyNTE3LjA3ID1DMj1CMSAwLjc5JQ0KDQpTdGVmYW4gSGFqbm9jemkgKDMp
Og0KICB2aXJ0aW8tcGNpOiB1c2UgTlVNQS1hd2FyZSBtZW1vcnkgYWxsb2NhdGlvbiBpbiBwcm9i
ZQ0KICB2aXJ0aW9fcmluZzogdXNlIE5VTUEtYXdhcmUgbWVtb3J5IGFsbG9jYXRpb24gaW4gcHJv
YmUNCiAgdmlydGlvLWJsazogdXNlIE5VTUEtYXdhcmUgbWVtb3J5IGFsbG9jYXRpb24gaW4gcHJv
YmUNCg0KIGluY2x1ZGUvbGludXgvZ2ZwLmggICAgICAgICAgICAgICAgfCAgMiArLQ0KIGRyaXZl
cnMvYmxvY2svdmlydGlvX2Jsay5jICAgICAgICAgfCAgNyArKysrKy0tDQogZHJpdmVycy92aXJ0
aW8vdmlydGlvX3BjaV9jb21tb24uYyB8IDE2ICsrKysrKysrKysrKy0tLS0NCiBkcml2ZXJzL3Zp
cnRpby92aXJ0aW9fcmluZy5jICAgICAgIHwgMjYgKysrKysrKysrKysrKysrKystLS0tLS0tLS0N
CiBtbS9wYWdlX2FsbG9jLmMgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0NCiA1IGZpbGVzIGNo
YW5nZWQsIDM2IGluc2VydGlvbnMoKyksIDE3IGRlbGV0aW9ucygtKQ0KDQotLT0yMA0KMi4yNi4y
DQoNCg==

