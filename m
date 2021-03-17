Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3B933F92A
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 20:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhCQTaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 15:30:04 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:56020 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbhCQT36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 15:29:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1616009399; x=1647545399;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=zWFFxO49wOr1BOYJ6yLvDqa+VJlcJIeydWFFzWXQEkE=;
  b=YEwUfZmXMUuE5n+5wKhit0ECvkI0O/CrZ3vnxh6FoBoR3jboMd7NQAqS
   YF3Vq/2k9jKBJTpA2BFeJL8FhOc6AKmJKSO1lRFZUXgsds1ggYSlU6/JR
   dVRHwAdLZMSmANmLhSm/E1eWR/ot+xltrEqNuXQS7EX3Ua/K8zjpx2RHo
   U=;
X-IronPort-AV: E=Sophos;i="5.81,257,1610409600"; 
   d="scan'208";a="98296044"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 17 Mar 2021 19:29:50 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id AF232A2146;
        Wed, 17 Mar 2021 19:29:49 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 17 Mar 2021 19:29:49 +0000
Received: from Alexanders-MacBook-Air.local (10.43.160.67) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 17 Mar 2021 19:29:47 +0000
Subject: Re: [PATCH 1/4] KVM: x86: Protect userspace MSR filter with SRCU, and
 set atomically-ish
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Yuan Yao <yaoyuan0329os@gmail.com>
References: <20210316184436.2544875-1-seanjc@google.com>
 <20210316184436.2544875-2-seanjc@google.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <08ac1383-27d0-e5f9-a618-b9e43dc5dc12@amazon.com>
Date:   Wed, 17 Mar 2021 20:29:44 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210316184436.2544875-2-seanjc@google.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.67]
X-ClientProxiedBy: EX13D31UWA004.ant.amazon.com (10.43.160.217) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxNi4wMy4yMSAxOTo0NCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToKPiAKPiBGaXgg
YSBwbGV0aG9yYSBvZiBpc3N1ZXMgd2l0aCBNU1IgZmlsdGVyaW5nIGJ5IGluc3RhbGxpbmcgdGhl
IHJlc3VsdGluZwo+IGZpbHRlciBhcyBhbiBhdG9taWMgYnVuZGxlIGluc3RlYWQgb2YgdXBkYXRp
bmcgdGhlIGxpdmUgZmlsdGVyIG9uZSByYW5nZQo+IGF0IGEgdGltZS4gIFRoZSBLVk1fWDg2X1NF
VF9NU1JfRklMVEVSIGlvY3RsKCkgaXNuJ3QgdHJ1bHkgYXRvbWljLCBhcwo+IHRoZSBoYXJkd2Fy
ZSBNU1IgYml0bWFwcyB3b24ndCBiZSB1cGRhdGVkIHVudGlsIHRoZSBuZXh0IFZNLUVudGVyLCBi
dXQKPiB0aGUgcmVsZXZhbnQgc29mdHdhcmUgc3RydWN0IGlzIGF0b21pY2FsbHkgdXBkYXRlZCwg
d2hpY2ggaXMgd2hhdCBLVk0KPiByZWFsbHkgbmVlZHMuCj4gCj4gU2ltaWxhciB0byB0aGUgYXBw
cm9hY2ggdXNlZCBmb3IgbW9kaWZ5aW5nIG1lbXNsb3RzLCBtYWtlIGFyY2gubXNyX2ZpbHRlcgo+
IGEgU1JDVS1wcm90ZWN0ZWQgcG9pbnRlciwgZG8gYWxsIHRoZSB3b3JrIGNvbmZpZ3VyaW5nIHRo
ZSBuZXcgZmlsdGVyCj4gb3V0c2lkZSBvZiBrdm0tPmxvY2ssIGFuZCB0aGVuIGFjcXVpcmUga3Zt
LT5sb2NrIG9ubHkgd2hlbiB0aGUgbmV3IGZpbHRlcgo+IGhhcyBiZWVuIHZldHRlZCBhbmQgY3Jl
YXRlZC4gIFRoYXQgd2F5IHZDUFUgcmVhZGVycyBlaXRoZXIgc2VlIHRoZSBvbGQKPiBmaWx0ZXIg
b3IgdGhlIG5ldyBmaWx0ZXIgaW4gdGhlaXIgZW50aXJldHksIG5vdCBzb21lIGhhbGYtYmFrZWQg
c3RhdGUuCj4gCj4gWXVhbiBZYW8gcG9pbnRlZCBvdXQgYSB1c2UtYWZ0ZXItZnJlZSBpbiBrc21f
bXNyX2FsbG93ZWQoKSBkdWUgdG8gYQo+IFRPQ1RPVSBidWcsIGJ1dCB0aGF0J3MganVzdCB0aGUg
dGlwIG9mIHRoZSBpY2ViZXJnLi4uCj4gCj4gICAgLSBOb3RoaW5nIGlzIF9fcmN1IGFubm90YXRl
ZCwgbWFraW5nIGl0IG5pZ2ggaW1wb3NzaWJsZSB0byBhdWRpdCB0aGUKPiAgICAgIGNvZGUgZm9y
IGNvcnJlY3RuZXNzLgo+ICAgIC0ga3ZtX2FkZF9tc3JfZmlsdGVyKCkgaGFzIGFuIHVucGFpcmVk
IHNtcF93bWIoKS4gIFZpb2xhdGlvbiBvZiBrZXJuZWwKPiAgICAgIGNvZGluZyBzdHlsZSBhc2lk
ZSwgdGhlIGxhY2sgb2YgYSBzbWJfcm1iKCkgYW55d2hlcmUgY2FzdHMgYWxsIGNvZGUKPiAgICAg
IGludG8gZG91YnQuCj4gICAgLSBrdm1fY2xlYXJfbXNyX2ZpbHRlcigpIGhhcyBhIGRvdWJsZSBm
cmVlIFRPQ1RPVSBidWcsIGFzIGl0IGdyYWJzCj4gICAgICBjb3VudCBiZWZvcmUgdGFraW5nIHRo
ZSBsb2NrLgo+ICAgIC0ga3ZtX2NsZWFyX21zcl9maWx0ZXIoKSBhbHNvIGhhcyBtZW1vcnkgbGVh
ayBkdWUgdG8gdGhlIHNhbWUgVE9DVE9VIGJ1Zy4KPiAKPiBUaGUgZW50aXJlIGFwcHJvYWNoIG9m
IHVwZGF0aW5nIHRoZSBsaXZlIGZpbHRlciBpcyBhbHNvIGZsYXdlZC4gIFdoaWxlCj4gaW5zdGFs
bGluZyBhIG5ldyBmaWx0ZXIgaXMgaW5oZXJlbnRseSByYWN5IGlmIHZDUFVzIGFyZSBydW5uaW5n
LCBmaXhpbmcKPiB0aGUgYWJvdmUgaXNzdWVzIGFsc28gbWFrZXMgaXQgdHJpdmlhbCB0byBlbnN1
cmUgY2VydGFpbiBiZWhhdmlvciBpcwo+IGRldGVybWluaXN0aWMsIGUuZy4gS1ZNIGNhbiBwcm92
aWRlIGRldGVybWluaXN0aWMgYmVoYXZpb3IgZm9yIE1TUnMgd2l0aAo+IGlkZW50aWNhbCBzZXR0
aW5ncyBpbiB0aGUgb2xkIGFuZCBuZXcgZmlsdGVycy4gIEFuIGF0b21pYyB1cGRhdGUgb2YgdGhl
Cj4gZmlsdGVyIGFsc28gcHJldmVudHMgS1ZNIGZyb20gZ2V0dGluZyBpbnRvIGEgaGFsZi1iYWtl
ZCBzdGF0ZSwgZS5nLiBpZgo+IGluc3RhbGxpbmcgYSBmaWx0ZXIgZmFpbHMsIHRoZSBleGlzdGlu
ZyBhcHByb2FjaCB3b3VsZCBsZWF2ZSB0aGUgZmlsdGVyCj4gaW4gYSBoYWxmLWJha2VkIHN0YXRl
LCBoYXZpbmcgYWxyZWFkeSBjb21taXR0ZWQgd2hhdGV2ZXIgYml0cyBvZiB0aGUKPiBmaWx0ZXIg
d2VyZSBhbHJlYWR5IHByb2Nlc3NlZC4KPiAKPiBbKl0gaHR0cHM6Ly9sa21sLmtlcm5lbC5vcmcv
ci8yMDIxMDMxMjA4MzE1Ny4yNTQwMy0xLXlhb3l1YW4wMzI5b3NAZ21haWwuY29tCj4gCj4gRml4
ZXM6IDFhMTU1MjU0ZmY5MyAoIktWTTogeDg2OiBJbnRyb2R1Y2UgTVNSIGZpbHRlcmluZyIpCj4g
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKPiBDYzogQWxleGFuZGVyIEdyYWYgPGdyYWZAYW1h
em9uLmNvbT4KPiBSZXBvcnRlZC1ieTogWXVhbiBZYW8gPHlhb3l1YW4wMzI5b3NAZ21haWwuY29t
Pgo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29t
PgoKVGhhbmtzIGEgbG90IFNlYW4gZm9yIGNsZWFuaW5nIHVwIGFmdGVyIG1lISBJIHdhcyB0cnlp
bmcgdG8gYmUgYSBiaXQgdG9vIApzbWFydCB3aXRoIHRoZSBpbmJhbmQgY291bnQgYXMgdG9rZW4g
dW5mb3J0dW5hdGVseSA6KQoKUmV2aWV3ZWQtYnk6IEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpv
bi5jb20+CgoKQWxleAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApL
cmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4g
U2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFy
bG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5
IDIzNyA4NzkKCgo=

