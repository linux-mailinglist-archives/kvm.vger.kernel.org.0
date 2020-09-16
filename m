Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8C526C09D
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 11:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgIPJcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 05:32:03 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:14763 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgIPJbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 05:31:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600248711; x=1631784711;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=j0FQ0m4Q6N26iiRThQsRwlC33/2n3AHGpWayuoJn1GE=;
  b=Hixz21G2AQ1Jl0YyUx+Km/hE57Z54WW83l5gZpl+hIjD5SKkezV1UMdm
   Sdx4k14Q+wc3SQYD42sVt6/alrpYWNZSJ27IyOH7yldJQ17yrBEEICqo3
   rIqqgVsn24qeNSKuDDL8zOQ0qg+i8SH8I7PTPE1GPnpKf0t68rE8tSkgn
   s=;
X-IronPort-AV: E=Sophos;i="5.76,432,1592870400"; 
   d="scan'208";a="75377086"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 16 Sep 2020 09:31:38 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id C8299A1C39;
        Wed, 16 Sep 2020 09:31:36 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 09:31:36 +0000
Received: from freeip.amazon.com (10.43.160.183) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 09:31:33 +0000
Subject: Re: [PATCH v6 1/7] KVM: x86: Deflect unknown MSR accesses to user
 space
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
 <20200902125935.20646-2-graf@amazon.com>
 <CAAAPnDFGD8+5KBCLKERrH0hajHEwU9UdEEGqp3RZu3Lws+5rmw@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <186ccace-2fad-3db3-0848-cd272b1a64ba@amazon.com>
Date:   Wed, 16 Sep 2020 11:31:30 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <CAAAPnDFGD8+5KBCLKERrH0hajHEwU9UdEEGqp3RZu3Lws+5rmw@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.183]
X-ClientProxiedBy: EX13D45UWB003.ant.amazon.com (10.43.161.67) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgQWFyb24sCgpUaGFua3MgYSBsb3QgZm9yIHRoZSBhbWF6aW5nIHJldmlldyEgSSd2ZSBiZWVu
IGNhdWdodCBpbiBzb21lIG90aGVyIAp0aGluZ3MgcmVjZW50bHksIHNvIHNvcnJ5IGZvciB0aGUg
ZGVsYXllZCByZXNwb25zZS4KCk9uIDAzLjA5LjIwIDIxOjI3LCBBYXJvbiBMZXdpcyB3cm90ZToK
PiAKPj4gKzo6Cj4+ICsKPj4gKyAgICAgICAgICAgICAgIC8qIEtWTV9FWElUX1g4Nl9SRE1TUiAv
IEtWTV9FWElUX1g4Nl9XUk1TUiAqLwo+PiArICAgICAgICAgICAgICAgc3RydWN0IHsKPj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgX191OCBlcnJvcjsgLyogdXNlciAtPiBrZXJuZWwgKi8KPj4g
KyAgICAgICAgICAgICAgICAgICAgICAgX191OCBwYWRbM107Cj4+ICsgICAgICAgICAgICAgICAg
ICAgICAgIF9fdTMyIHJlYXNvbjsgLyoga2VybmVsIC0+IHVzZXIgKi8KPj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgX191MzIgaW5kZXg7IC8qIGtlcm5lbCAtPiB1c2VyICovCj4+ICsgICAgICAg
ICAgICAgICAgICAgICAgIF9fdTY0IGRhdGE7IC8qIGtlcm5lbCA8LT4gdXNlciAqLwo+PiArICAg
ICAgICAgICAgICAgfSBtc3I7Cj4+ICsKPj4gK1VzZWQgb24geDg2IHN5c3RlbXMuIFdoZW4gdGhl
IFZNIGNhcGFiaWxpdHkgS1ZNX0NBUF9YODZfVVNFUl9TUEFDRV9NU1IgaXMKPj4gK2VuYWJsZWQs
IE1TUiBhY2Nlc3NlcyB0byByZWdpc3RlcnMgdGhhdCB3b3VsZCBpbnZva2UgYSAjR1AgYnkgS1ZN
IGtlcm5lbCBjb2RlCj4+ICt3aWxsIGluc3RlYWQgdHJpZ2dlciBhIEtWTV9FWElUX1g4Nl9SRE1T
UiBleGl0IGZvciByZWFkcyBhbmQgS1ZNX0VYSVRfWDg2X1dSTVNSCj4+ICtleGl0IGZvciB3cml0
ZXMuCj4+ICsKPj4gK1RoZSAicmVhc29uIiBmaWVsZCBzcGVjaWZpZXMgd2h5IHRoZSBNU1IgdHJh
cCBvY2N1cnJlZC4gVXNlciBzcGFjZSB3aWxsIG9ubHkKPj4gK3JlY2VpdmUgTVNSIGV4aXQgdHJh
cHMgd2hlbiBhIHBhcnRpY3VsYXIgcmVhc29uIHdhcyByZXF1ZXN0ZWQgZHVyaW5nIHRocm91Z2gK
Pj4gK0VOQUJMRV9DQVAuIEN1cnJlbnRseSB2YWxpZCBleGl0IHJlYXNvbnMgYXJlOgo+PiArCj4+
ICsgICAgICAgS1ZNX01TUl9FWElUX1JFQVNPTl9JTlZBTCAtIGFjY2VzcyB0byBpbnZhbGlkIE1T
UnMgb3IgcmVzZXJ2ZWQgYml0cwo+IAo+IAo+IENhbiB3ZSBhbHNvIGhhdmUgRU5PRU5UPwo+ICAg
ICAgICAgIEtWTV9NU1JfRVhJVF9SRUFTT05fRU5PRU5UIC0gVW5rbm93biBNU1IKCkkgdHJpZWQg
dG8gYWRkIHRoYXQgYXQgZmlyc3QsIGJ1dCBpdCBnZXRzIHRyaWNreSByZWFsbHkgZmFzdC4gV2h5
IHNob3VsZCAKdXNlciBzcGFjZSBoYXZlIGEgdmVzdGVkIGludGVyZXN0IGluIGRpZmZlcmVudGlh
dGluZyBiZXR3ZWVuICJNU1IgaXMgbm90IAppbXBsZW1lbnRlZCIgYW5kICJNU1IgaXMgZ3VhcmRl
ZCBieSBhIENQVUlEIGZsYWcgYW5kIHRodXMgbm90IGhhbmRsZWQiIApvciAiTVNSIGlzIGd1YXJk
ZWQgYnkgYSBDQVAiPwoKVGhlIG1vcmUgZGV0YWlscyB3ZSByZXZlYWwsIHRoZSBtb3JlIGxpa2Vs
eSB3ZSdyZSB0byBicmVhayBBQkkgCmNvbXBhdGliaWxpdHkuCgo+IAo+Pgo+PiArCj4+ICtGb3Ig
S1ZNX0VYSVRfWDg2X1JETVNSLCB0aGUgImluZGV4IiBmaWVsZCB0ZWxscyB1c2VyIHNwYWNlIHdo
aWNoIE1TUiB0aGUgZ3Vlc3QKPj4gK3dhbnRzIHRvIHJlYWQuIFRvIHJlc3BvbmQgdG8gdGhpcyBy
ZXF1ZXN0IHdpdGggYSBzdWNjZXNzZnVsIHJlYWQsIHVzZXIgc3BhY2UKPj4gK3dyaXRlcyB0aGUg
cmVzcGVjdGl2ZSBkYXRhIGludG8gdGhlICJkYXRhIiBmaWVsZCBhbmQgbXVzdCBjb250aW51ZSBn
dWVzdAo+PiArZXhlY3V0aW9uIHRvIGVuc3VyZSB0aGUgcmVhZCBkYXRhIGlzIHRyYW5zZmVycmVk
IGludG8gZ3Vlc3QgcmVnaXN0ZXIgc3RhdGUuCj4+Cj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9r
dm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMKPj4gaW5kZXggODhjNTkzZjgzYjI4Li40ZDI4
NWJmMDU0ZmIgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYwo+PiArKysgYi9hcmNo
L3g4Ni9rdm0veDg2LmMKPj4gQEAgLTE1NDksMTIgKzE1NDksODggQEAgaW50IGt2bV9zZXRfbXNy
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIGluZGV4LCB1NjQgZGF0YSkKPj4gICB9Cj4+ICAg
RVhQT1JUX1NZTUJPTF9HUEwoa3ZtX3NldF9tc3IpOwo+Pgo+PiArc3RhdGljIGludCBjb21wbGV0
ZV9lbXVsYXRlZF9tc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBib29sIGlzX3JlYWQpCj4+ICt7
Cj4+ICsgICAgICAgaWYgKHZjcHUtPnJ1bi0+bXNyLmVycm9yKSB7Cj4+ICsgICAgICAgICAgICAg
ICBrdm1faW5qZWN0X2dwKHZjcHUsIDApOwo+IAo+IEFkZCByZXR1cm4gMS4gVGhlIFJJUCBkb2Vz
buKAmXQgYWR2YW5jZSB3aGVuIHRoZSBpbnN0cnVjdGlvbiByYWlzZXMgYSBmYXVsdC4KCllpa2Vz
LiBHb29kIGNhdGNoISBUaGFuayB5b3UhCgo+IAo+Pgo+PiArICAgICAgIH0gZWxzZSBpZiAoaXNf
cmVhZCkgewo+PiArICAgICAgICAgICAgICAga3ZtX3JheF93cml0ZSh2Y3B1LCAodTMyKXZjcHUt
PnJ1bi0+bXNyLmRhdGEpOwo+PiArICAgICAgICAgICAgICAga3ZtX3JkeF93cml0ZSh2Y3B1LCB2
Y3B1LT5ydW4tPm1zci5kYXRhID4+IDMyKTsKPj4gKyAgICAgICB9Cj4+ICsKPj4gKyAgICAgICBy
ZXR1cm4ga3ZtX3NraXBfZW11bGF0ZWRfaW5zdHJ1Y3Rpb24odmNwdSk7Cj4+ICt9Cj4+ICsKPj4g
K3N0YXRpYyBpbnQgY29tcGxldGVfZW11bGF0ZWRfcmRtc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1
KQo+PiArewo+PiArICAgICAgIHJldHVybiBjb21wbGV0ZV9lbXVsYXRlZF9tc3IodmNwdSwgdHJ1
ZSk7Cj4+ICt9Cj4+ICsKPj4KPj4gICAvKiBGb3IgS1ZNX0VYSVRfSU5URVJOQUxfRVJST1IgKi8K
Pj4gICAvKiBFbXVsYXRlIGluc3RydWN0aW9uIGZhaWxlZC4gKi8KPj4gQEAgLTQxMiw2ICs0MTQs
MTUgQEAgc3RydWN0IGt2bV9ydW4gewo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgX191NjQg
ZXNyX2lzczsKPj4gICAgICAgICAgICAgICAgICAgICAgICAgIF9fdTY0IGZhdWx0X2lwYTsKPj4g
ICAgICAgICAgICAgICAgICB9IGFybV9uaXN2Owo+PiArICAgICAgICAgICAgICAgLyogS1ZNX0VY
SVRfWDg2X1JETVNSIC8gS1ZNX0VYSVRfWDg2X1dSTVNSICovCj4+ICsgICAgICAgICAgICAgICBz
dHJ1Y3Qgewo+PiArICAgICAgICAgICAgICAgICAgICAgICBfX3U4IGVycm9yOyAvKiB1c2VyIC0+
IGtlcm5lbCAqLwo+PiArICAgICAgICAgICAgICAgICAgICAgICBfX3U4IHBhZFszXTsKPiAKPiBf
X3U4IHBhZFs3XSB0byBtYWludGFpbiA4IGJ5dGUgYWxpZ25tZW50PyAgdW5sZXNzIHdlIGNhbiBn
ZXQgYXdheSB3aXRoCj4gZmV3ZXIgYml0cyBmb3IgJ3JlYXNvbicgYW5kCj4gZ2V0IHRoZW0gZnJv
bSAncGFkJy4KCldoeSB3b3VsZCB3ZSBuZWVkIGFuIDggYnl0ZSBhbGlnbm1lbnQgaGVyZT8gSSBh
bHdheXMgdGhvdWdodCBuYXR1cmFsIHU2NCAKYWxpZ25tZW50IG9uIHg4Nl82NCB3YXMgb24gNCBi
eXRlcz8KCgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICkty
YXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBT
Y2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJs
b3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkg
MjM3IDg3OQoKCg==

