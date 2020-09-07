Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05ACB25FAC9
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 14:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbgIGMzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 08:55:46 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:32077 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgIGMzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 08:55:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599483325; x=1631019325;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=uJrbmK8bXrLFAotyNZ9AuGYGDQNx6Tp+tMA5g8uD3P4=;
  b=c6QvMc2GRg9WJJkCB0kzPOTQazLfg11l0YoMKEhdO8pUxn0jcan4vV5C
   aD9LHpkUqfMG/DefihZ2m1jMiSvJfw1V/YeNECrcIn28huxmJfNC42kFE
   hnrZzL+bAqrU0EP5tGqgYzHgrrS3+TDZP+P0UDdL9Muit2bol/KJJH6dO
   k=;
X-IronPort-AV: E=Sophos;i="5.76,401,1592870400"; 
   d="scan'208";a="52553785"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 07 Sep 2020 12:55:23 +0000
Received: from EX13D16EUB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 55A91A2039;
        Mon,  7 Sep 2020 12:55:21 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.215) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Sep 2020 12:55:09 +0000
Subject: Re: [PATCH v8 08/18] nitro_enclaves: Add logic for creating an
 enclave VM
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Karen Noel" <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20200904173718.64857-1-andraprs@amazon.com>
 <20200904173718.64857-9-andraprs@amazon.com>
 <20200907085721.GA1101646@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <48e3b34c-eae0-4153-9d64-fcdcc88b4241@amazon.com>
Date:   Mon, 7 Sep 2020 15:54:59 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907085721.GA1101646@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.215]
X-ClientProxiedBy: EX13D01UWA004.ant.amazon.com (10.43.160.99) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNy8wOS8yMDIwIDExOjU3LCBHcmVnIEtIIHdyb3RlOgo+Cj4gT24gRnJpLCBTZXAgMDQs
IDIwMjAgYXQgMDg6Mzc6MDhQTSArMDMwMCwgQW5kcmEgUGFyYXNjaGl2IHdyb3RlOgo+PiArc3Rh
dGljIGxvbmcgbmVfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGUsIHVuc2lnbmVkIGludCBjbWQsIHVu
c2lnbmVkIGxvbmcgYXJnKQo+PiArewo+PiArICAgICBzd2l0Y2ggKGNtZCkgewo+PiArICAgICBj
YXNlIE5FX0NSRUFURV9WTTogewo+PiArICAgICAgICAgICAgIGludCBlbmNsYXZlX2ZkID0gLTE7
Cj4+ICsgICAgICAgICAgICAgc3RydWN0IGZpbGUgKmVuY2xhdmVfZmlsZSA9IE5VTEw7Cj4+ICsg
ICAgICAgICAgICAgc3RydWN0IG5lX3BjaV9kZXYgKm5lX3BjaV9kZXYgPSBOVUxMOwo+PiArICAg
ICAgICAgICAgIHN0cnVjdCBwY2lfZGV2ICpwZGV2ID0gdG9fcGNpX2RldihuZV9taXNjX2Rldi5w
YXJlbnQpOwo+IFRoYXQgY2FsbCBpcyByZWFsbHkgInJpc2t5Ii4gIFlvdSAia25vdyIgdGhhdCB0
aGUgbWlzYyBkZXZpY2UncyBwYXJlbnQKPiBpcyBhIHNwZWNpZmljIFBDSSBkZXZpY2UsIHRoYXQg
anVzdCBoYXBwZW5zIHRvIGJlIHlvdXIgcGNpIGRldmljZSwKPiByaWdodD8KCkNvcnJlY3QsIHRo
YXQncyBob3cgaXQncyBhc3NpZ25lZCB0aGUgbWlzYyBkZXZpY2UncyBwYXJlbnQsIHRvIHBvaW50
IHRvIAphIHBhcnRpY3VsYXIgUENJIGRldmljZSB0aGF0J3MgdGhlIE5FIFBDSSBkZXZpY2UuCgo+
Cj4gQnV0IHdoeSBub3QganVzdCBoYXZlIHlvdXIgbWlzYyBkZXZpY2UgaG9sZCB0aGUgcG9pbnRl
ciB0byB0aGUgc3RydWN0dXJlCj4geW91IHJlYWxseSB3YW50LCBzbyB5b3UgZG9uJ3QgaGF2ZSB0
byBtZXNzIHdpdGggdGhlIGRldmljZSB0cmVlIGluIGFueQo+IHdheSwgYW5kIHlvdSBhbHdheXMg
Imtub3ciIHlvdSBoYXZlIHRoZSBjb3JyZWN0IHBvaW50ZXI/ICBJdCBzaG91bGQgc2F2ZQo+IHlv
dSB0aGlzIHR3by1zdGVwIGxvb2t1cCBhbGwgdGhlIHRpbWUsIHJpZ2h0Pwo+CgpUaGF0IHdvdWxk
IGhlbHAsIHllcywgdG8ga2VlcCB0aGUgcG9pbnRlciBkaXJlY3RseSB0byB0aGUgbmVfcGNpX2Rl
diAKZGF0YSBzdHJ1Y3R1cmUuIEp1c3QgdGhhdCB0aGUgbWlzYyBkZXZpY2UncyBwYXJlbnQgZGF0
YSBzdHJ1Y3R1cmUgaXMgYSAKc3RydWN0IGRldmljZSBwb2ludGVyLiBJIGNhbiBjcmVhdGUgYSBu
ZXcgaW50ZXJuYWwgZGF0YSBzdHJ1Y3R1cmUgdG8gCmtlZXAgdGhlIG1pc2NkZXZpY2UgZGF0YSBz
dHJ1Y3R1cmUgYW5kIGEgcG9pbnRlciB0byB0aGUgbmVfcGNpX2Rldi4KClRoYW5rcywKQW5kcmEK
CgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQg
b2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBD
b3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRp
b24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==

