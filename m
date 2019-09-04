Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21844A8426
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 15:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbfIDNGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 09:06:16 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:16152 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbfIDNGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 09:06:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1567602375; x=1599138375;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=PmVGScMxxaCJ7nxDCBRqEB2AF61UmPN9JngtFX5rBhk=;
  b=agK2KBnTEkK2jWAJmbQlpfAVQ7GJqoOO3EcmcTGvtpHzSG1GoVZa5dS8
   +TflBuCaOnJ4TKR7oWTJLER9FT3k1ldeTd3fbnyrWjcmU7nF8YZqVT+3G
   CHabDREGsuLHutIpmxMKsQ9kZd3kX7PVEeq6XNQ+OZrZ69WxXJDestuiR
   Y=;
X-IronPort-AV: E=Sophos;i="5.64,467,1559520000"; 
   d="scan'208";a="748973286"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 04 Sep 2019 13:06:12 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id A20B41A0998;
        Wed,  4 Sep 2019 13:06:11 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 4 Sep 2019 13:06:11 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.125) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 4 Sep 2019 13:06:07 +0000
Subject: Re: [PATCH 2/2] KVM: SVM: Disable posted interrupts for odd IRQs
To:     Liran Alon <liran.alon@oracle.com>
CC:     kvm list <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190903142954.3429-1-graf@amazon.com>
 <20190903142954.3429-3-graf@amazon.com>
 <7AEDDBE7-138A-455F-957C-C2DE64BD8B06@oracle.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <ff1bad8b-31dc-042b-7b90-ccc31e1a80de@amazon.com>
Date:   Wed, 4 Sep 2019 15:06:05 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7AEDDBE7-138A-455F-957C-C2DE64BD8B06@oracle.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.125]
X-ClientProxiedBy: EX13D13UWA004.ant.amazon.com (10.43.160.251) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNC4wOS4xOSAwMToyMCwgTGlyYW4gQWxvbiB3cm90ZToKPiAKPiAKPj4gT24gMyBTZXAg
MjAxOSwgYXQgMTc6MjksIEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpvbi5jb20+IHdyb3RlOgo+
Pgo+PiBXZSBjYW4gZWFzaWx5IHJvdXRlIGhhcmR3YXJlIGludGVycnVwdHMgZGlyZWN0bHkgaW50
byBWTSBjb250ZXh0IHdoZW4KPj4gdGhleSB0YXJnZXQgdGhlICJGaXhlZCIgb3IgIkxvd1ByaW9y
aXR5IiBkZWxpdmVyeSBtb2Rlcy4KPj4KPj4gSG93ZXZlciwgb24gbW9kZXMgc3VjaCBhcyAiU01J
IiBvciAiSW5pdCIsIHdlIG5lZWQgdG8gZ28gdmlhIEtWTSBjb2RlCj4+IHRvIGFjdHVhbGx5IHB1
dCB0aGUgdkNQVSBpbnRvIGEgZGlmZmVyZW50IG1vZGUgb2Ygb3BlcmF0aW9uLCBzbyB3ZSBjYW4K
Pj4gbm90IHBvc3QgdGhlIGludGVycnVwdAo+Pgo+PiBBZGQgY29kZSBpbiB0aGUgU1ZNIFBJIGxv
Z2ljIHRvIGV4cGxpY2l0bHkgcmVmdXNlIHRvIGVzdGFibGlzaCBwb3N0ZWQKPj4gbWFwcGluZ3Mg
Zm9yIGFkdmFuY2VkIElSUSBkZWxpdmVyIG1vZGVzLgo+Pgo+PiBUaGlzIGZpeGVzIGEgYnVnIEkg
aGF2ZSB3aXRoIGNvZGUgd2hpY2ggY29uZmlndXJlcyByZWFsIGhhcmR3YXJlIHRvCj4+IGluamVj
dCB2aXJ0dWFsIFNNSXMgaW50byBteSBndWVzdC4KPj4KPj4gU2lnbmVkLW9mZi1ieTogQWxleGFu
ZGVyIEdyYWYgPGdyYWZAYW1hem9uLmNvbT4KPiAKPiBOaXQ6IEkgcHJlZmVyIHRvIHNxdWFzaCBi
b3RoIGNvbW1pdHMgaW50byBvbmUgdGhhdCBjaGFuZ2UgYm90aCBWTVggJiBTVk0uCj4gQXMgaXTi
gJlzIGV4YWN0bHkgdGhlIHNhbWUgY2hhbmdlLgoKSXQncyB0aGUgc2FtZSBjaGFuZ2UgKGhlbmNl
IHRoZSBzYW1lIHBhdGNoIHNldCksIGJ1dCB0aGV5IHRvdWNoIApkaWZmZXJlbnQgZmlsZXMgYW5k
IHNvIGZvciBiaXNlY3RhYmlsaXR5IGl0J3Mgc3RpbGwgY29udmVuaWVudCB0byBoYXZlIAp0aGVt
IGFzIGRpZmZlcmVudCBjb21taXRzLiBJJ2QgcmVhbGx5IHByZWZlciB0byBoYXZlIHRoZW0gc3Rh
eSBzZXBhcmF0ZS4KClRoYW5rcyBhIGxvdCBmb3IgdGhlIHJldmlldyEgOikKCgpBbGV4CgoKCkFt
YXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3
IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIFJhbGYgSGVy
YnJpY2gKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJC
IDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

