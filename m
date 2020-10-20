Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D49C293875
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 11:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403988AbgJTJsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 05:48:22 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:11609 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728775AbgJTJsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 05:48:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1603187301; x=1634723301;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=j/NUF3xtHrXDreYAVOkD2ynQtHTp+nkCsES1G/39Yp8=;
  b=RzZ/YSEFx3pj0UWOC//+73Diu6STOJ00lg1MTkXI3R0uhGrsNzj22fnI
   HkAVx2jmGtWnlS/0KfkfFdwX9ElKrENqmgpnlqSZ8PQwK/Dijn42rYoeZ
   zJCsPQxO8RQGafkzf8MvTAq97BhDFtzkV7I48btp+uxPpHOyRpHYz/du0
   M=;
X-IronPort-AV: E=Sophos;i="5.77,396,1596499200"; 
   d="scan'208";a="78118472"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-42f764a0.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 20 Oct 2020 09:48:14 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-42f764a0.us-east-1.amazon.com (Postfix) with ESMTPS id 31173BA6E4;
        Tue, 20 Oct 2020 09:48:11 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Oct 2020 09:48:11 +0000
Received: from Alexanders-MacBook-Air.local (10.43.162.231) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Oct 2020 09:48:10 +0000
Subject: Re: [PATCH] KVM: VMX: Forbid userspace MSR filters for x2APIC
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20201019170519.1855564-1-pbonzini@redhat.com>
 <618E2129-7AB5-4F0D-A6C9-E782937FE935@amazon.de>
 <c9dd6726-2783-2dfd-14d1-5cec6f69f051@redhat.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <bce2aee1-bfac-0640-066b-068fa5f12cf8@amazon.de>
Date:   Tue, 20 Oct 2020 11:48:07 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <c9dd6726-2783-2dfd-14d1-5cec6f69f051@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.231]
X-ClientProxiedBy: EX13D44UWB001.ant.amazon.com (10.43.161.32) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMC4xMC4yMCAxMToyNywgUGFvbG8gQm9uemluaSB3cm90ZToKPiAKPiBPbiAxOS8xMC8y
MCAxOTo0NSwgR3JhZiAoQVdTKSwgQWxleGFuZGVyIHdyb3RlOgo+Pj4gKyAgICAgICAgKiBJbiBw
cmluY2lwbGUgaXQgd291bGQgYmUgcG9zc2libGUgdG8gdHJhcCB4MmFwaWMgcmFuZ2VzCj4+PiAr
ICAgICAgICAqIGlmICFsYXBpY19pbl9rZXJuZWwuICBUaGlzIGhvd2V2ZXIgd291bGQgYmUgY29t
cGxpY2F0ZWQKPj4+ICsgICAgICAgICogYmVjYXVzZSBLVk1fWDg2X1NFVF9NU1JfRklMVEVSIGNh
biBiZSBjYWxsZWQgYmVmb3JlCj4+PiArICAgICAgICAqIEtWTV9DUkVBVEVfSVJRQ0hJUCBvciBL
Vk1fRU5BQkxFX0NBUC4KPj4+ICsgICAgICAgICovCj4+PiArICAgICAgIGZvciAoaSA9IDA7IGkg
PCBBUlJBWV9TSVpFKGZpbHRlci5yYW5nZXMpOyBpKyspCj4+PiArICAgICAgICAgICAgICAgaWYg
KHJhbmdlX292ZXJsYXBzX3gyYXBpYygmZmlsdGVyLnJhbmdlc1tpXSkpCj4+PiArICAgICAgICAg
ICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsKPj4KPj4gV2hhdCBpZiB0aGUgZGVmYXVsdCBh
Y3Rpb24gb2YgdGhlIGZpbHRlciBpcyB0byAiZGVueSI/IFRoZW4gb25seSBhbgo+PiBNU1IgZmls
dGVyIHRvIGFsbG93IGFjY2VzcyB0byB4MmFwaWMgTVNScyB3b3VsZCBtYWtlIHRoZSBmdWxsCj4+
IGZpbHRlcmluZyBsb2dpYyBhZGhlcmUgdG8gdGhlIGNvbnN0cmFpbnRzLCBubz8KPiAKPiBSaWdo
dDsgb3IgbW9yZSBwcmVjaXNlbHksIHRoYXQgaXMgaGFuZGxlZCBieSBTZWFuJ3MgcGF0Y2ggdGhh
dCBoZSBoYWQKPiBwb3N0ZWQgZWFybGllci4gIFRoaXMgcGF0Y2ggb25seSBtYWtlcyBpdCBpbXBv
c3NpYmxlIHRvIHNldCB1cCBzdWNoIGEKPiBmaWx0ZXIuCgpXaGF0IEknbSBzYXlpbmcgaXMgdGhh
dCBhICJmaWx0ZXIgcnVsZSIgY2FuIGVpdGhlciBtZWFuICJhbGxvdyIgb3IgCiJkZW55Ii4gSGVy
ZSB5b3UncmUgb25seSBjaGVja2luZyBpZiB0aGVyZSBpcyBhIHJ1bGUuIFdoYXQgeW91IHdhbnQg
dG8gCmZpbHRlciBmb3IgaXMgd2hldGhlciB0aGVyZSBpcyBhIGRlbnlpbmcgcnVsZSAoaW5jbHVk
aW5nIGRlZmF1bHQgCmZhbGxiYWNrKSBmb3IgeDJhcGljIGFmdGVyIGFsbCBydWxlcyBhcmUgaW4g
cGxhY2UuCgpJbWFnaW5lIHlvdSBhZGQgdGhlIGZvbGxvd2luZyBmaWx0ZXI6Cgp7CiAgICAgY291
bnQ6IDEsCiAgICAgZGVmYXVsdF9hbGxvdzogZmFsc2UsCiAgICAgcmFuZ2VzOiBbCiAgICAgICAg
IHsKICAgICAgICAgICAgIGZsYWdzOiBLVk1fTVNSX0ZJTFRFUl9SRUFELAogICAgICAgICAgICAg
bm1zcnM6IDEsCiAgICAgICAgICAgICBiYXNlOiBNU1JfRUZFUiwKICAgICAgICAgICAgIGJpdG1h
cDogeyAxIH0sCiAgICAgICAgIH0sCiAgICAgXSwKfQoKVGhhdCBmaWx0ZXIgd291bGQgc2V0IGFs
bCB4MmFwaWMgcmVnaXN0ZXJzIHRvICJkZW55IiwgYnV0IHdvdWxkIG5vdCBiZSAKY2F1Z2h0IGJ5
IHRoZSBjb2RlIGFib3ZlLiBDb252ZXJzZWx5LCBhIHJhbmdlIHRoYXQgZXhwbGljaXRseSBhbGxv
d3MgCngyYXBpYyByYW5nZXMgd2l0aCBkZWZhdWx0X2FsbG93PTAgd291bGQgYmUgcmVqZWN0ZWQg
YnkgdGhpcyBwYXRjaC4KCgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFu
eSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENo
cmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJp
Y2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlE
OiBERSAyODkgMjM3IDg3OQoKCg==

