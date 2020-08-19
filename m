Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0F424A301
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 17:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgHSP0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 11:26:52 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:11065 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbgHSP0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 11:26:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597850808; x=1629386808;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=N5quNAKhzDaoc9/UrOmyXOrtvGVqofhbFlKIKEtEzFc=;
  b=e4Y1nOmVYDLjHcva5cCDvc8O+kWsPUalbLUCOX/4vPYwIhIMFS6t2B9B
   uQnfH7IyxqaZJA+fDRFWD3XHohYamhUuboW4vKbJcqsBND24fZRp+cFr5
   MuZFg7ySXDexGAI6MOTQkNHfP8LLO7wRAZoP39dhOn/XCKxnZXWAHZxHR
   o=;
X-IronPort-AV: E=Sophos;i="5.76,331,1592870400"; 
   d="scan'208";a="50162119"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 19 Aug 2020 15:26:47 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 7E6D2C07B3;
        Wed, 19 Aug 2020 15:26:44 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 15:26:43 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.71) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 15:26:42 +0000
Subject: Re: [PATCH v3 07/12] KVM: x86: Ensure the MSR bitmap never clears
 userspace tracked MSRs
To:     Aaron Lewis <aaronlewis@google.com>, <jmattson@google.com>
CC:     <pshier@google.com>, <oupton@google.com>, <kvm@vger.kernel.org>
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-8-aaronlewis@google.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <522d8a2f-8047-32f6-a329-c9ace7bf3693@amazon.com>
Date:   Wed, 19 Aug 2020 17:26:37 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200818211533.849501-8-aaronlewis@google.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.71]
X-ClientProxiedBy: EX13D06UWC003.ant.amazon.com (10.43.162.86) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxOC4wOC4yMCAyMzoxNSwgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4gU0RNIHZvbHVtZSAz
OiAyNC42LjkgIk1TUi1CaXRtYXAgQWRkcmVzcyIgYW5kIEFQTSB2b2x1bWUgMjogMTUuMTEgIk1T
Cj4gaW50ZXJjZXB0cyIgZGVzY3JpYmUgTVNSIHBlcm1pc3Npb24gYml0bWFwcy4gIFBlcm1pc3Np
b24gYml0bWFwcyBhcmUKPiB1c2VkIHRvIGNvbnRyb2wgd2hldGhlciBhbiBleGVjdXRpb24gb2Yg
cmRtc3Igb3Igd3Jtc3Igd2lsbCBjYXVzZSBhCj4gdm0gZXhpdC4gIEZvciB1c2Vyc3BhY2UgdHJh
Y2tlZCBNU1JzIGl0IGlzIHJlcXVpcmVkIHRoZXkgY2F1c2UgYSB2bQo+IGV4aXQsIHNvIHRoZSBo
b3N0IGlzIGFibGUgdG8gZm9yd2FyZCB0aGUgTVNSIHRvIHVzZXJzcGFjZS4gIFRoaXMgY2hhbmdl
Cj4gYWRkcyB2bXgvc3ZtIHN1cHBvcnQgdG8gZW5zdXJlIHRoZSBwZXJtaXNzaW9uIGJpdG1hcCBp
cyBwcm9wZXJseSBzZXQgdG8KPiBjYXVzZSBhIHZtX2V4aXQgdG8gdGhlIGhvc3Qgd2hlbiByZG1z
ciBvciB3cm1zciBpcyB1c2VkIGJ5IG9uZSBvZiB0aGUKPiB1c2Vyc3BhY2UgdHJhY2tlZCBNU1Jz
LiAgQWxzbywgdG8gYXZvaWQgcmVwZWF0ZWRseSBzZXR0aW5nIHRoZW0sCj4ga3ZtX21ha2VfcmVx
dWVzdCgpIGlzIHVzZWQgdG8gY29hbGVzY2UgdGhlc2UgaW50byBhIHNpbmdsZSBjYWxsLgo+IAo+
IFNpZ25lZC1vZmYtYnk6IEFhcm9uIExld2lzIDxhYXJvbmxld2lzQGdvb2dsZS5jb20+Cj4gUmV2
aWV3ZWQtYnk6IE9saXZlciBVcHRvbiA8b3VwdG9uQGdvb2dsZS5jb20+CgpUaGlzIGlzIGluY29t
cGxldGUsIGFzIGl0IGRvZXNuJ3QgY292ZXIgYWxsIG9mIHRoZSB4MmFwaWMgcmVnaXN0ZXJzLiAK
VGhlcmUgYXJlIGFsc28gYSBmZXcgTVNScyB0aGF0IElJUkMgYXJlIGhhbmRsZWQgZGlmZmVyZW50
bHkgZnJvbSB0aGlzIApsb2dpYywgc3VjaCBhcyBFRkVSLgoKSSdtIHJlYWxseSBjdXJpb3VzIGlm
IHRoaXMgaXMgd29ydGggdGhlIGVmZm9ydD8gSSB3b3VsZCBiZSBpbmNsaW5lZCB0byAKc2F5IHRo
YXQgTVNScyB0aGF0IEtWTSBoYXMgZGlyZWN0IGFjY2VzcyBmb3IgbmVlZCBzcGVjaWFsIGhhbmRs
aW5nIG9uZSAKd2F5IG9yIGFub3RoZXIuCgoKQWxleAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2Vu
dGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1
ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBh
bSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVy
bGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

