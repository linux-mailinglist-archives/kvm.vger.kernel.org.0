Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF50126CA15
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 21:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgIPTp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 15:45:58 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:63532 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbgIPTpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 15:45:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600285524; x=1631821524;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=bPL9ALhcpi5BrsWWkKTPd1toAEPb6RfwgA0Kgzn99Wk=;
  b=L2Vwa+aOA0VgfMTtmzTTIeqRHpg4JPxNY4+dDNWmJpU2Kcj59xeVOz9/
   v/7arpXVrs1B7aEy3pvwH2xcpIulo15A+AjLf6rhM2gEHoZ6FlVDV+47E
   dZ9EWjCjdqe0WoOdM+LE0k2h0MxnVDwkGQuJJMvIrq5n5WMO+V0u7CYt6
   k=;
X-IronPort-AV: E=Sophos;i="5.76,434,1592870400"; 
   d="scan'208";a="68651091"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 16 Sep 2020 19:44:14 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 5ACA0A1859;
        Wed, 16 Sep 2020 19:44:10 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 19:44:09 +0000
Received: from freeip.amazon.com (10.43.161.146) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 19:44:06 +0000
Subject: Re: [PATCH v6 5/7] KVM: x86: VMX: Prevent MSR passthrough when MSR
 access is denied
To:     Aaron Lewis <aaronlewis@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kvm list <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200902125935.20646-1-graf@amazon.com>
 <20200902125935.20646-6-graf@amazon.com>
 <CAAAPnDH2D6fANhZzy3fAL2XKO4ROrvbOoqPme2Ww6q5XcVJfog@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <c90a705d-8768-efd1-e744-b56cd6ab3c0f@amazon.com>
Date:   Wed, 16 Sep 2020 21:44:03 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <CAAAPnDH2D6fANhZzy3fAL2XKO4ROrvbOoqPme2Ww6q5XcVJfog@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.146]
X-ClientProxiedBy: EX13D49UWC004.ant.amazon.com (10.43.162.106) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNC4wOS4yMCAwNDoxOCwgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4+ICsvKgo+PiArICog
TGlzdCBvZiBNU1JzIHRoYXQgY2FuIGJlIGRpcmVjdGx5IHBhc3NlZCB0byB0aGUgZ3Vlc3QuCj4+
ICsgKiBJbiBhZGRpdGlvbiB0byB0aGVzZSB4MmFwaWMgYW5kIFBUIE1TUnMgYXJlIGhhbmRsZWQg
c3BlY2lhbGx5Lgo+PiArICovCj4+ICtzdGF0aWMgdTMyIHZteF9wb3NzaWJsZV9wYXNzdGhyb3Vn
aF9tc3JzW01BWF9QT1NTSUJMRV9QQVNTR0hST1VHSF9NU1JTXSA9IHsKPiAKPiBNQVhfUE9TU0lC
TEVfUEFTU0dIUk9VR0hfTVNSUyBzaG91bGQgYmUgTUFYX1BPU1NJQkxFX1BBU1NUSFJPVUdIX01T
UlMKCk91Y2guIFRoYW5rcyA6KS4KCj4gCj4+ICsgICAgICAgTVNSX0lBMzJfU1BFQ19DVFJMLAo+
PiArICAgICAgIE1TUl9JQTMyX1BSRURfQ01ELAo+PiArICAgICAgIE1TUl9JQTMyX1RTQywKPj4g
KyAgICAgICBNU1JfRlNfQkFTRSwKPj4gKyAgICAgICBNU1JfR1NfQkFTRSwKPj4gKyAgICAgICBN
U1JfS0VSTkVMX0dTX0JBU0UsCj4+ICsgICAgICAgTVNSX0lBMzJfU1lTRU5URVJfQ1MsCj4+ICsg
ICAgICAgTVNSX0lBMzJfU1lTRU5URVJfRVNQLAo+PiArICAgICAgIE1TUl9JQTMyX1NZU0VOVEVS
X0VJUCwKPj4gKyAgICAgICBNU1JfQ09SRV9DMV9SRVMsCj4+ICsgICAgICAgTVNSX0NPUkVfQzNf
UkVTSURFTkNZLAo+PiArICAgICAgIE1TUl9DT1JFX0M2X1JFU0lERU5DWSwKPj4gKyAgICAgICBN
U1JfQ09SRV9DN19SRVNJREVOQ1ksCj4+ICt9Owo+IAo+IElzIHRoZXJlIGFueSByZWFzb24gbm90
IHRvIGNvbnN0cnVjdCB0aGlzIGxpc3Qgb24gdGhlIGZseT8gIFRoYXQgY291bGQKPiBoZWxwIHBy
ZXZlbnQgdGhlIGxpc3QgZnJvbSBiZWNvbWluZyBzdGFsZSBvdmVyIHRpbWUgaWYgdGhpcyBpcyBt
aXNzZWQKPiB3aGVuIGNhbGxzIHRvIHZteF9kaXNhYmxlX2ludGVyY2VwdF9mb3JfbXNyKCkgYXJl
IGFkZGVkLgoKVGhlIHByb2JsZW0gaXMgdGhhdCB3ZSBoYXZlIGFuIHVwcGVyIGJvdW5kIG9mIGVs
ZW1lbnRzIHRoYXQgd2UgY2FuIHN0b3JlIAppbiB0aGUgYml0bWFwLiBXZSBjYW4gZWl0aGVyIG1h
a2UgdGhhdCBudW1iZXIgYXJiaXRyYXJ5IGFuZCB0aGVuIGhhdmUgCnJlYWxseSBhd2t3YXJkIGZh
aWx1cmUgbW9kZXMgb3IgYmUgaW5jcmVkaWJseSBwaWNreSBpbnN0ZWFkLgoKSSB3ZW50IGZvciBp
bmNyZWRpYmx5IHBpY2t5LiBJZiBhbnl0aGluZyBnb2VzIG91dCBvZiBzeW5jLCBsaWtlIHdoZW4g
CnNvbWVvbmUgYWRkcyBhbiBNU1IgdG8gdGhlIGxpc3Qgd2l0aG91dCBjaGFuZ2luZyAKTUFYX1BP
U1NJQkxFX1BBU1NUSFJPVUdIX01TUlMsIGEgY2FsbCB0byAKdm14X3tlbixkaXN9YWJsZV9pbnRl
cmNlcHRfZm9yX21zcigpIGlzIGRvbmUgb24gYW4gTVNSIHRoYXQgaXMgbm90IHBhcnQgCm9mIHRo
ZSBsaXN0LCB3ZSB3aWxsIGFib3J0IGVhcmx5IGFuZCBpbiB0aGUgZm9ybWVyIGNhc2UgYWxyZWFk
eSB0aHJvdWdoIAp0aGUgY29tcGlsZXIuCgpJZiB5b3UgY2FuIHRoaW5rIG9mIGEgZ29vZCB3YXkg
dG8gY29uc3RydWN0IHRoZSBsaXN0IGR5bmFtaWNhbGx5IGFuZCAKc3RpbGwgaGF2ZSBhIHdvcmtp
bmcgYml0bWFwIG9mICJkZXNpcmVkIiBwYXNzdGhyb3VnaCBzdGF0ZXMsIEknbSBhbGwgCmVhcnMg
OikuCgo+IAo+PiArCj4+ICAgLyoKPj4gICAgKiBUaGVzZSAyIHBhcmFtZXRlcnMgYXJlIHVzZWQg
dG8gY29uZmlnIHRoZSBjb250cm9scyBmb3IgUGF1c2UtTG9vcCBFeGl0aW5nOgo+PiAgICAqIHBs
ZV9nYXA6ICAgIHVwcGVyIGJvdW5kIG9uIHRoZSBhbW91bnQgb2YgdGltZSBiZXR3ZWVuIHR3byBz
dWNjZXNzaXZlCj4+IEBAIC02MjIsNiArNjQyLDQxIEBAIHN0YXRpYyBpbmxpbmUgYm9vbCByZXBv
cnRfZmxleHByaW9yaXR5KHZvaWQpCj4+ICAgICAgICAgIHJldHVybiBmbGV4cHJpb3JpdHlfZW5h
YmxlZDsKPj4gICB9Cj4gCj4gT25lIHRoaW5nIHRoYXQgc2VlbXMgdG8gYmUgbWlzc2luZyBpcyBy
ZW1vdmluZyBNU1JzIGZyb20gdGhlCj4gcGVybWlzc2lvbiBiaXRtYXAgb3IgcmVzZXR0aW5nIHRo
ZSBwZXJtaXNzaW9uIGJpdG1hcCB0byBpdHMgb3JpZ2luYWwKPiBzdGF0ZSBiZWZvcmUgYWRkaW5n
IGNoYW5nZXMgb24gdG9wIG9mIGl0LiAgVGhpcyB3b3VsZCBiZSBuZWVkZWQgb24KPiBzdWJzZXF1
ZW50IGNhbGxzIHRvIGt2bV92bV9pb2N0bF9zZXRfbXNyX2ZpbHRlcigpLiAgV2hlbiB0aGF0IGhh
cHBlbnMKPiB0aGUgb3JpZ2luYWwgY2hhbmdlcyBtYWRlIGJ5IEtWTV9SRVFfTVNSX0ZJTFRFUl9D
SEFOR0VEIG5lZWQgdG8gYmUKPiBiYWNrZWQgb3V0IGJlZm9yZSBhcHBseWluZyB0aGUgbmV3IHNl
dC4KCkknbSBub3Qgc3VyZSBJIGZvbGxvdy4gU3Vic2VxdWVudCBjYWxscyB0byBzZXRfbXNyX2Zp
bHRlcigpIHdpbGwgaW52b2tlIAp0aGUgInBsZWFzZSByZXNldCB0aGUgd2hvbGUgTVNSIHBhc3N0
aHJvdWdoIGJpdG1hcCB0byBhIGNvbnNpc3RlbnQgCnN0YXRlIiB3aGljaCB3aWxsIHRoZW4gcmVh
cHBseSB0aGUgaW4ta3ZtIGRlc2lyZWQgc3RhdGUgdGhyb3VnaCB0aGUgCmJpdG1hcCBhbmQgZmls
dGVyIHN0YXRlIG9uIHRvcCBvbiBlYWNoIG9mIHRob3NlLgoKCkFsZXgKCgoKCkFtYXpvbiBEZXZl
bG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpH
ZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVp
bmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMg
QgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

