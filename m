Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DF81E1559
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 22:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390750AbgEYUxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 16:53:31 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:65014 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388714AbgEYUxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 16:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590440011; x=1621976011;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=KzX3JJFuQclynlosLD9NtvZTWnDtMffEO6pL3DzQ4sc=;
  b=u2CNIimpqQoyPb+p15xwWNIlMA4ie8BObmxYYU/WQNMVglIW3+sdnkm6
   g+iO4WEvEDfVf7Sl/+jk0UckK/G/n4VxsEF8D3wq/0Um3IVYlaEJHR7r/
   OKoFDJh8hwvlaN6mJjtDwPh24fKId2WLEJusirk11EHWb5v+3Z0Xjn6QA
   g=;
IronPort-SDR: 0oQ21Kd8MxtYwKRdBpHSkjsCDOABvvyMksssdGqKxIC5CVd3J2wjE7m8QlO2r/uhLo1QvvMfIB
 OfNKZdIWm/rQ==
X-IronPort-AV: E=Sophos;i="5.73,434,1583193600"; 
   d="scan'208";a="45832664"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 25 May 2020 20:53:30 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 80C46A1C7A;
        Mon, 25 May 2020 20:53:27 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 20:53:26 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.253) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 20:53:18 +0000
Subject: Re: [PATCH v2 08/18] nitro_enclaves: Add logic for enclave vm
 creation
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Alexander Graf" <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-9-andraprs@amazon.com>
 <20200522070828.GD771317@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <736f5245-af92-9d6d-6d17-7cd50fbe6c2a@amazon.com>
Date:   Mon, 25 May 2020 23:53:13 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522070828.GD771317@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D05UWC002.ant.amazon.com (10.43.162.92) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMi8wNS8yMDIwIDEwOjA4LCBHcmVnIEtIIHdyb3RlOgo+IE9uIEZyaSwgTWF5IDIyLCAy
MDIwIGF0IDA5OjI5OjM2QU0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4gQWRkIGlv
Y3RsIGNvbW1hbmQgbG9naWMgZm9yIGVuY2xhdmUgVk0gY3JlYXRpb24uIEl0IHRyaWdnZXJzIGEg
c2xvdAo+PiBhbGxvY2F0aW9uLiBUaGUgZW5jbGF2ZSByZXNvdXJjZXMgd2lsbCBiZSBhc3NvY2lh
dGVkIHdpdGggdGhpcyBzbG90IGFuZAo+PiBpdCB3aWxsIGJlIHVzZWQgYXMgYW4gaWRlbnRpZmll
ciBmb3IgdHJpZ2dlcmluZyBlbmNsYXZlIHJ1bi4KPj4KPj4gUmV0dXJuIGEgZmlsZSBkZXNjcmlw
dG9yLCBuYW1lbHkgZW5jbGF2ZSBmZC4gVGhpcyBpcyBmdXJ0aGVyIHVzZWQgYnkgdGhlCj4+IGFz
c29jaWF0ZWQgdXNlciBzcGFjZSBlbmNsYXZlIHByb2Nlc3MgdG8gc2V0IGVuY2xhdmUgcmVzb3Vy
Y2VzIGFuZAo+PiB0cmlnZ2VyIGVuY2xhdmUgdGVybWluYXRpb24uCj4+Cj4+IFRoZSBwb2xsIGZ1
bmN0aW9uIGlzIGltcGxlbWVudGVkIGluIG9yZGVyIHRvIG5vdGlmeSB0aGUgZW5jbGF2ZSBwcm9j
ZXNzCj4+IHdoZW4gYW4gZW5jbGF2ZSBleGl0cyB3aXRob3V0IGEgc3BlY2lmaWMgZW5jbGF2ZSB0
ZXJtaW5hdGlvbiBjb21tYW5kCj4+IHRyaWdnZXIgZS5nLiB3aGVuIGFuIGVuY2xhdmUgY3Jhc2hl
cy4KPj4KPj4gU2lnbmVkLW9mZi1ieTogQWxleGFuZHJ1IFZhc2lsZSA8bGV4bnZAYW1hem9uLmNv
bT4KPj4gU2lnbmVkLW9mZi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29t
Pgo+PiAtLS0KPj4gICBkcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYyB8
IDE2OSArKysrKysrKysrKysrKysrKysrKysrCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDE2OSBpbnNl
cnRpb25zKCspCj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMv
bmVfbWlzY19kZXYuYyBiL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9taXNjX2Rldi5j
Cj4+IGluZGV4IGUxODY2ZmFjODIyMC4uMTAzNjIyMTIzOGY0IDEwMDY0NAo+PiAtLS0gYS9kcml2
ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYwo+PiArKysgYi9kcml2ZXJzL3Zp
cnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYwo+PiBAQCAtNjMsNiArNjMsMTQ2IEBAIHN0
cnVjdCBuZV9jcHVfcG9vbCB7Cj4+ICAgCj4+ICAgc3RhdGljIHN0cnVjdCBuZV9jcHVfcG9vbCBu
ZV9jcHVfcG9vbDsKPj4gICAKPj4gK3N0YXRpYyBpbnQgbmVfZW5jbGF2ZV9vcGVuKHN0cnVjdCBp
bm9kZSAqbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCj4+ICt7Cj4+ICsJcmV0dXJuIDA7Cj4+ICt9
Cj4gQWdhaW4sIGlmIGEgZmlsZSBvcGVyYXRpb24gZG9lcyBub3RoaW5nLCBkb24ndCBldmVuIHBy
b3ZpZGUgaXQuCgpJIHJlbW92ZWQgb3BlbigpIGluIHYzLgoKVGhhbmsgeW91LgoKQW5kcmEKCgoK
QW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2Zm
aWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3Vu
dHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24g
bnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==

