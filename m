Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7442CF406
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387782AbgLDS1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:27:55 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:17022 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730166AbgLDS1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:27:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607106473; x=1638642473;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=lu0Rsx52S+ZaNkZvuDFmbKIWbg2CGxlGvjqrdyvhZ1c=;
  b=M8zCCxrfXHYVOUmeAAVoO9hehi8amIc3mgIp3kPCPJhmbpDCsZk3RmJH
   jZQ01Fr0ZW2D+k1hMRvEcxiWU67p94cj3U0Ur8LoWZOyYuwbxNgNDRtcb
   RpZ14PMxzhrXQcSFi1QHtq3hf1Y1Ty27Zwu8kZeoPLXaGCeGLNycxhRP9
   U=;
X-IronPort-AV: E=Sophos;i="5.78,393,1599523200"; 
   d="scan'208";a="101860477"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 04 Dec 2020 18:27:03 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 0BFACA1F38;
        Fri,  4 Dec 2020 18:27:00 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 18:26:59 +0000
Received: from Alexanders-MacBook-Air.local (10.43.160.21) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 18:26:56 +0000
Subject: Re: [PATCH 03/15] KVM: x86/xen: intercept xen hypercalls if enabled
To:     David Woodhouse <dwmw2@infradead.org>, <kvm@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
 <20201204011848.2967588-4-dwmw2@infradead.org>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <776337d6-c00b-754a-c9f6-830b76e47c30@amazon.com>
Date:   Fri, 4 Dec 2020 19:26:54 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204011848.2967588-4-dwmw2@infradead.org>
Content-Language: en-US
X-Originating-IP: [10.43.160.21]
X-ClientProxiedBy: EX13D19UWA004.ant.amazon.com (10.43.160.102) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMDQuMTIuMjAgMDI6MTgsIERhdmlkIFdvb2Rob3VzZSB3cm90ZToKPiBGcm9tOiBKb2FvIE1h
cnRpbnMgPGpvYW8ubS5tYXJ0aW5zQG9yYWNsZS5jb20+Cj4gCj4gQWRkIGEgbmV3IGV4aXQgcmVh
c29uIGZvciBlbXVsYXRvciB0byBoYW5kbGUgWGVuIGh5cGVyY2FsbHMuCj4gCj4gU2luY2UgdGhp
cyBtZWFucyBLVk0gb3ducyB0aGUgQUJJLCBkaXNwZW5zZSB3aXRoIHRoZSBmYWNpbGl0eSBmb3Ig
dGhlCj4gVk1NIHRvIHByb3ZpZGUgaXRzIG93biBjb3B5IG9mIHRoZSBoeXBlcmNhbGwgcGFnZXM7
IGp1c3QgZmlsbCB0aGVtIGluCj4gZGlyZWN0bHkgdXNpbmcgVk1DQUxML1ZNTUNBTEwgYXMgd2Ug
ZG8gZm9yIHRoZSBIeXBlci1WIGh5cGVyY2FsbCBwYWdlLgo+IAo+IFRoaXMgYmVoYXZpb3VyIGlz
IGVuYWJsZWQgYnkgYSBuZXcgSU5URVJDRVBUX0hDQUxMIGZsYWcgaW4gdGhlCj4gS1ZNX1hFTl9I
Vk1fQ09ORklHIGlvY3RsIHN0cnVjdHVyZSwgYW5kIGFkdmVydGlzZWQgYnkgdGhlIHNhbWUgZmxh
Zwo+IGJlaW5nIHJldHVybmVkIGZyb20gdGhlIEtWTV9DQVBfWEVOX0hWTSBjaGVjay4KPiAKPiBB
ZGQgYSB0ZXN0IGNhc2UgYW5kIHNoaWZ0IHhlbl9odm1fY29uZmlnKCkgdG8gdGhlIG5hc2NlbnQg
eGVuLmMgd2hpbGUKPiB3ZSdyZSBhdCBpdC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBKb2FvIE1hcnRp
bnMgPGpvYW8ubS5tYXJ0aW5zQG9yYWNsZS5jb20+Cj4gU2lnbmVkLW9mZi1ieTogRGF2aWQgV29v
ZGhvdXNlIDxkd213QGFtYXpvbi5jby51az4KCldoeSBkb2VzIGFueSBvZiB0aGlzIGhhdmUgdG8g
bGl2ZSBpbiBrZXJuZWwgc3BhY2U/IEkgd291bGQgZXhwZWN0IHVzZXIgCnNwYWNlIHRvIG93biB0
aGUgTVNSIGFuZCBoY2FsbCBudW1iZXIgc3BhY2UgYW5kIHB1c2ggaXQgZG93biB0byBLVk0uIApU
aGF0IG1lYW5zIGl0IGNhbiBhbHNvIHByb3ZpZGUgdGhlIHNoaW1zIGl0IG5lZWRzLgoKCkFsZXgK
CgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgK
MTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9u
YXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50
ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

