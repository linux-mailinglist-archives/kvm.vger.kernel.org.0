Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20DC24985F
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 10:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgHSImU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 04:42:20 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:54074 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgHSImU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 04:42:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597826540; x=1629362540;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=n+Vll29VHoW+ze73ZQgQsHQkyv7rVwIbGR0mhywMB+k=;
  b=aPAYitvPJDw4ZIaIlJFfImv20fpt1W8SyPUKFLJiG9wx5VIEUJKCBpoL
   zc2bkA7/2NYEyILNXqwWNg2BQhv1Uq9E5FbfyJy6k9kYmJD4eo6skNKd4
   NscxxJUfGLflYxyaLItzCe08jW+6cjVxXGzuQmJDKlzq+zlbjeaHYzsAL
   Y=;
X-IronPort-AV: E=Sophos;i="5.76,330,1592870400"; 
   d="scan'208";a="48751602"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 19 Aug 2020 08:42:18 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 93089A0567;
        Wed, 19 Aug 2020 08:42:16 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 08:42:15 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.228) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 08:42:14 +0000
Subject: Re: [PATCH v3 01/12] KVM: x86: Deflect unknown MSR accesses to user
 space
To:     Aaron Lewis <aaronlewis@google.com>, <jmattson@google.com>
CC:     <pshier@google.com>, <oupton@google.com>, <kvm@vger.kernel.org>
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-2-aaronlewis@google.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <6a54e6a1-8572-b1fd-21c8-1f0ec0e4dd77@amazon.com>
Date:   Wed, 19 Aug 2020 10:42:09 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200818211533.849501-2-aaronlewis@google.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.228]
X-ClientProxiedBy: EX13D36UWB003.ant.amazon.com (10.43.161.118) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxOC4wOC4yMCAyMzoxNSwgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4gTVNScyBhcmUgd2Vp
cmQuIFNvbWUgb2YgdGhlbSBhcmUgbm9ybWFsIGNvbnRyb2wgcmVnaXN0ZXJzLCBzdWNoIGFzIEVG
RVIuCj4gU29tZSBob3dldmVyIGFyZSByZWdpc3RlcnMgdGhhdCByZWFsbHkgYXJlIG1vZGVsIHNw
ZWNpZmljLCBub3QgdmVyeQo+IGludGVyZXN0aW5nIHRvIHZpcnR1YWxpemF0aW9uIHdvcmtsb2Fk
cywgYW5kIG5vdCBwZXJmb3JtYW5jZSBjcml0aWNhbC4KPiBPdGhlcnMgYWdhaW4gYXJlIHJlYWxs
eSBqdXN0IHdpbmRvd3MgaW50byBwYWNrYWdlIGNvbmZpZ3VyYXRpb24uCj4gCj4gT3V0IG9mIHRo
ZXNlIE1TUnMsIG9ubHkgdGhlIGZpcnN0IGNhdGVnb3J5IGlzIG5lY2Vzc2FyeSB0byBpbXBsZW1l
bnQgaW4KPiBrZXJuZWwgc3BhY2UuIFJhcmVseSBhY2Nlc3NlZCBNU1JzLCBNU1JzIHRoYXQgc2hv
dWxkIGJlIGZpbmUgdHVuZXMgYWdhaW5zdAo+IGNlcnRhaW4gQ1BVIG1vZGVscyBhbmQgTVNScyB0
aGF0IGNvbnRhaW4gaW5mb3JtYXRpb24gb24gdGhlIHBhY2thZ2UgbGV2ZWwKPiBhcmUgbXVjaCBi
ZXR0ZXIgc3VpdGVkIGZvciB1c2VyIHNwYWNlIHRvIHByb2Nlc3MuIEhvd2V2ZXIsIG92ZXIgdGlt
ZSB3ZSBoYXZlCj4gYWNjdW11bGF0ZWQgYSBsb3Qgb2YgTVNScyB0aGF0IGFyZSBub3QgdGhlIGZp
cnN0IGNhdGVnb3J5LCBidXQgc3RpbGwgaGFuZGxlZAo+IGJ5IGluLWtlcm5lbCBLVk0gY29kZS4K
PiAKPiBUaGlzIHBhdGNoIGFkZHMgYSBnZW5lcmljIGludGVyZmFjZSB0byBoYW5kbGUgV1JNU1Ig
YW5kIFJETVNSIGZyb20gdXNlcgo+IHNwYWNlLiBXaXRoIHRoaXMsIGFueSBmdXR1cmUgTVNSIHRo
YXQgaXMgcGFydCBvZiB0aGUgbGF0dGVyIGNhdGVnb3JpZXMgY2FuCj4gYmUgaGFuZGxlZCBpbiB1
c2VyIHNwYWNlLgo+IAo+IEZ1cnRoZXJtb3JlLCBpdCBhbGxvd3MgdXMgdG8gcmVwbGFjZSB0aGUg
ZXhpc3RpbmcgImlnbm9yZV9tc3JzIiBsb2dpYyB3aXRoCj4gc29tZXRoaW5nIHRoYXQgYXBwbGll
cyBwZXItVk0gcmF0aGVyIHRoYW4gb24gdGhlIGZ1bGwgc3lzdGVtLiBUaGF0IHdheSB5b3UKPiBj
YW4gcnVuIHByb2R1Y3RpdmUgVk1zIGluIHBhcmFsbGVsIHRvIGV4cGVyaW1lbnRhbCBvbmVzIHdo
ZXJlIHlvdSBkb24ndCBjYXJlCj4gYWJvdXQgcHJvcGVyIE1TUiBoYW5kbGluZy4KPiAKPiBTaWdu
ZWQtb2ZmLWJ5OiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPgo+IFJldmlld2VkLWJ5
OiBKaW0gTWF0dHNvbiA8am1hdHRzb25AZ29vZ2xlLmNvbT4KCllvdSBuZWVkIHRvIGFkZCB5b3Vy
IFNpZ25lZC1vZmYtYnkgbGluZSBoZXJlIGFzIHdlbGwgOikuCgoKQWxleAoKCgpBbWF6b24gRGV2
ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4K
R2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpF
aW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTcz
IEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

