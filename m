Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B60D26CBE3
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgIPUgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:36:24 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:13213 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728388AbgIPUgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 16:36:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600288580; x=1631824580;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=dGZqVnUoL1EJHSp3OUeSnhcSg8wLbGG2vxHUgbmqNo4=;
  b=BY1r0hvXKDxFwRfd9tq5GV/+D7P+fyujuuZgrIJ4DIVTMixNrAiC+kRP
   duqMSg74MW634LBF4yI30NTjqpNtfLP3L3kWgu5HZfkMOvEwPem1zVaia
   jgK3tP7P5f1gVT5RwBf58hm3GUDETsFLbUJQfYQflRokUaaP61dPyJgB/
   Q=;
X-IronPort-AV: E=Sophos;i="5.76,434,1592870400"; 
   d="scan'208";a="68664417"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 16 Sep 2020 20:36:15 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 929BFA1783;
        Wed, 16 Sep 2020 20:36:14 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 20:36:14 +0000
Received: from freeip.amazon.com (10.43.161.237) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 16 Sep 2020 20:36:10 +0000
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
 <c90a705d-8768-efd1-e744-b56cd6ab3c0f@amazon.com>
 <CAAAPnDEoQhtXuiqHwUtrsL7codcToAVwaR=+qVczZrz6RCWe0A@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <e61772b5-4c64-8407-2b52-dbba2d488f90@amazon.com>
Date:   Wed, 16 Sep 2020 22:36:08 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <CAAAPnDEoQhtXuiqHwUtrsL7codcToAVwaR=+qVczZrz6RCWe0A@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.237]
X-ClientProxiedBy: EX13D44UWB001.ant.amazon.com (10.43.161.32) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxNi4wOS4yMCAyMjoxMywgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4+Pgo+Pj4+ICsKPj4+
PiAgICAvKgo+Pj4+ICAgICAqIFRoZXNlIDIgcGFyYW1ldGVycyBhcmUgdXNlZCB0byBjb25maWcg
dGhlIGNvbnRyb2xzIGZvciBQYXVzZS1Mb29wIEV4aXRpbmc6Cj4+Pj4gICAgICogcGxlX2dhcDog
ICAgdXBwZXIgYm91bmQgb24gdGhlIGFtb3VudCBvZiB0aW1lIGJldHdlZW4gdHdvIHN1Y2Nlc3Np
dmUKPj4+PiBAQCAtNjIyLDYgKzY0Miw0MSBAQCBzdGF0aWMgaW5saW5lIGJvb2wgcmVwb3J0X2Zs
ZXhwcmlvcml0eSh2b2lkKQo+Pj4+ICAgICAgICAgICByZXR1cm4gZmxleHByaW9yaXR5X2VuYWJs
ZWQ7Cj4+Pj4gICAgfQo+Pj4KPj4+IE9uZSB0aGluZyB0aGF0IHNlZW1zIHRvIGJlIG1pc3Npbmcg
aXMgcmVtb3ZpbmcgTVNScyBmcm9tIHRoZQo+Pj4gcGVybWlzc2lvbiBiaXRtYXAgb3IgcmVzZXR0
aW5nIHRoZSBwZXJtaXNzaW9uIGJpdG1hcCB0byBpdHMgb3JpZ2luYWwKPj4+IHN0YXRlIGJlZm9y
ZSBhZGRpbmcgY2hhbmdlcyBvbiB0b3Agb2YgaXQuICBUaGlzIHdvdWxkIGJlIG5lZWRlZCBvbgo+
Pj4gc3Vic2VxdWVudCBjYWxscyB0byBrdm1fdm1faW9jdGxfc2V0X21zcl9maWx0ZXIoKS4gIFdo
ZW4gdGhhdCBoYXBwZW5zCj4+PiB0aGUgb3JpZ2luYWwgY2hhbmdlcyBtYWRlIGJ5IEtWTV9SRVFf
TVNSX0ZJTFRFUl9DSEFOR0VEIG5lZWQgdG8gYmUKPj4+IGJhY2tlZCBvdXQgYmVmb3JlIGFwcGx5
aW5nIHRoZSBuZXcgc2V0Lgo+Pgo+PiBJJ20gbm90IHN1cmUgSSBmb2xsb3cuIFN1YnNlcXVlbnQg
Y2FsbHMgdG8gc2V0X21zcl9maWx0ZXIoKSB3aWxsIGludm9rZQo+PiB0aGUgInBsZWFzZSByZXNl
dCB0aGUgd2hvbGUgTVNSIHBhc3N0aHJvdWdoIGJpdG1hcCB0byBhIGNvbnNpc3RlbnQKPj4gc3Rh
dGUiIHdoaWNoIHdpbGwgdGhlbiByZWFwcGx5IHRoZSBpbi1rdm0gZGVzaXJlZCBzdGF0ZSB0aHJv
dWdoIHRoZQo+PiBiaXRtYXAgYW5kIGZpbHRlciBzdGF0ZSBvbiB0b3Agb24gZWFjaCBvZiB0aG9z
ZS4KPj4KPiAKPiBZZXMsIHlvdSdyZSBjb3JyZWN0LiAgSSBkaXNjb3ZlcmVkIHRoaXMgYWZ0ZXIg
dGhlIGZhY3QgYnkgYWRkaW5nIGEKPiB0ZXN0IHRvIHRoZSBzZWxmdGVzdCBJIHdyb3RlIGZvciB0
aGUgZGVueSBsaXN0IHN5c3RlbSB3aGljaCBJIHJldmFtcGVkCj4gdG8gd29yayBmb3IgeW91ciBm
aWx0ZXIgc3lzdGVtLiAgSXQgcHJvdmVkIHRoZSBwZXJtaXNzaW9uIGJpdG1hcHMgYXJlCj4gaW4g
ZmFjdCBzZXQgYXMgZXhwZWN0ZWQgb24gc3Vic2VxdWVudCBjYWxscy4gIFlvdSBjYW4gZGlzcmVn
YXJkIHRoaXMKPiBjb21tZW50Lgo+IAo+IEFzIGEgc2lkZSBub3RlLCBJJ20gaGFwcHkgdG8gc2hh
cmUgdGhlIHRlc3QgaWYgeW91J2QgbGlrZS4gSSBhbHNvIHVzZWQKPiBpdCB0byB1bmNvdmVyIGFu
IGlzc3VlIGluIHRoZSBmaXJzdCBjb21taXQgb2YgdGhpcyBzZXJpZXMuCgpJIHJlYWxseSBlbmpv
eSB0aGUgdGVzdHMgdGhhdCB5b3Ugc3VibWl0dGVkIGFuZCB3b3VsZCBsb3ZlIHRvIHNlZSB5b3Ug
CmFkZCB5b3VyIHRlc3QgY292ZXJhZ2UgdG8gdGhlIGZpbHRlcmluZyBwYXRjaCBzZXQgOikKCgpU
aGFua3MhCgpBbGV4CgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApL
cmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4g
U2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFy
bG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5
IDIzNyA4NzkKCgo=

