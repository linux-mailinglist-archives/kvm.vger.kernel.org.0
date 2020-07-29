Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5013823262B
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 22:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgG2U3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 16:29:09 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:18648 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgG2U3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 16:29:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596054548; x=1627590548;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=RJ4gUEPwSqRV2+z7YTBzeU1z9TUiwVmPEqQmGefYNdM=;
  b=FwRkNgSFkzXqqIvhCsDHEYpY5F17ci66XE5Z8GVfi7GzIkUgrKvL69G0
   cpdkskpvdY185ud3rzKxBDcltOvp2xVXSBfeeUpd9QU9EXaemT689rmjy
   SkpyLXLOF9/we+3+COzD9rHCPDREjNUKTGlkiztf3la2taMN9arSUYzd2
   E=;
IronPort-SDR: qxaJZbDS6tvN8jjtNyd4UTF/CI14Fwu2ejw6yzNlY+BJkt3mDPWeFMPwQmSaUwCH6fBIByf9dk
 vOnmRlwLzLcw==
X-IronPort-AV: E=Sophos;i="5.75,411,1589241600"; 
   d="scan'208";a="46343573"
Subject: Re: [PATCH] KVM: x86: Deflect unknown MSR accesses to user space
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 29 Jul 2020 20:29:06 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 7C79AC05AA;
        Wed, 29 Jul 2020 20:29:04 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 20:29:03 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.48) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 20:29:00 +0000
To:     Jim Mattson <jmattson@google.com>
CC:     Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <20200728004446.932-1-graf@amazon.com>
 <87d04gm4ws.fsf@vitty.brq.redhat.com>
 <a1f30fc8-09f5-fe2f-39e2-136b881ed15a@amazon.com>
 <CALMp9eQ3OxhQZYiHPiebX=KyvjWQgxQEO-owjSoxgPKsOMRvjw@mail.gmail.com>
 <14035057-ea80-603b-0466-bb50767f9f7e@amazon.com>
 <CALMp9eSxWDPcu2=K4NHbx_ZcYjA_jmnoD7gXbUp=cnEbiU0jLA@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <69d8c4cd-0d36-0135-d1fc-0af7d81ce062@amazon.com>
Date:   Wed, 29 Jul 2020 22:28:59 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSxWDPcu2=K4NHbx_ZcYjA_jmnoD7gXbUp=cnEbiU0jLA@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.48]
X-ClientProxiedBy: EX13D01UWA001.ant.amazon.com (10.43.160.60) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyOS4wNy4yMCAyMDoyNywgSmltIE1hdHRzb24gd3JvdGU6Cj4gQ0FVVElPTjogVGhpcyBl
bWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3Qg
Y2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGNhbiBjb25maXJtIHRo
ZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4KPiAKPiAKPiAKPiBPbiBXZWQs
IEp1bCAyOSwgMjAyMCBhdCAyOjA2IEFNIEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpvbi5jb20+
IHdyb3RlOgo+Pgo+Pgo+Pgo+PiBPbiAyOC4wNy4yMCAxOToxMywgSmltIE1hdHRzb24gd3JvdGU6
Cj4gCj4+PiBUaGlzIHNvdW5kcyBzaW1pbGFyIHRvIFBldGVyIEhvcm55YWNrJ3MgUkZDIGZyb20g
NSB5ZWFycyBhZ286Cj4+PiBodHRwczovL3d3dy5tYWlsLWFyY2hpdmUuY29tL2t2bUB2Z2VyLmtl
cm5lbC5vcmcvbXNnMTI0NDQ4Lmh0bWwuCj4+Cj4+IFllYWgsIGxvb2tzIHZlcnkgc2ltaWxhci4g
RG8geW91IGtub3cgdGhlIGhpc3Rvcnkgd2h5IGl0IG5ldmVyIGdvdAo+PiBtZXJnZWQ/IEkgY291
bGRuJ3Qgc3BvdCBhIG5vbi1SRkMgdmVyc2lvbiBvZiB0aGlzIG9uIHRoZSBNTC4KPiAKPiBJIGJl
bGlldmUgUGV0ZXIgZ290IGZydXN0cmF0ZWQgd2l0aCBhbGwgb2YgdGhlIHB1c2hiYWNrIGhlIHdh
cwo+IGdldHRpbmcsIGFuZCBoZSBtb3ZlZCBvbiB0byBvdGhlciB0aGluZ3MuIFdoaWxlIEdvb2ds
ZSBzdGlsbCB1c2VzIHRoYXQKPiBjb2RlLCBBYXJvbidzIG5ldyBhcHByb2FjaCBzaG91bGQgZ2l2
ZSB1cyBlcXVpdmFsZW50IGZ1bmN0aW9uYWxpdHkKPiB3aXRob3V0IGhhdmluZyB0byBjb21tZW50
IG91dCB0aGUgTVNScyB0aGF0IGt2bSBwcmV2aW91c2x5IGRpZG4ndCBrbm93Cj4gYWJvdXQsIGFu
ZCB3aGljaCB3ZSBzdGlsbCB3YW50IHJlZGlyZWN0ZWQgdG8gdXNlcnNwYWNlLgo+IAo+Pj4gSXQg
c2VlbXMgdW5saWtlbHkgdGhhdCB1c2Vyc3BhY2UgaXMgZ29pbmcgdG8ga25vdyB3aGF0IHRvIGRv
IHdpdGggYQo+Pj4gbGFyZ2UgbnVtYmVyIG9mIE1TUnMuIEkgc3VzcGVjdCB0aGF0IGEgc21hbGwg
ZW51bWVyYXRlZCBsaXN0IHdpbGwKPj4+IHN1ZmZpY2UuIEluIGZhY3QsICtBYXJvbiBMZXdpcyBp
cyB3b3JraW5nIG9uIHVwc3RyZWFtaW5nIGEgbG9jYWwKPj4+IEdvb2dsZSBwYXRjaCBzZXQgdGhh
dCBkb2VzIGp1c3QgdGhhdC4KPj4KPj4gSSB0ZW5kIHRvIGRpc2FncmVlIG9uIHRoYXQgc2VudGlt
ZW50LiBPbmUgb2YgdGhlIG1vdGl2YXRpb25zIGJlaGluZCB0aGlzCj4+IHBhdGNoIGlzIHRvIHBv
cHVsYXRlIGludmFsaWQgTVNSIGFjY2Vzc2VzIGludG8gdXNlciBzcGFjZSwgdG8gbW92ZSBsb2dp
Ywo+PiBsaWtlICJpZ25vcmVfbXNycyJbMV0gaW50byB1c2VyIHNwYWNlLiBUaGlzIGlzIG5vdCB2
ZXJ5IHVzZWZ1bCBmb3IgdGhlCj4+IGNsb3VkIHVzZSBjYXNlLCBidXQgaXQgZG9lcyBjb21lIGlu
IGhhbmR5IHdoZW4geW91IHdhbnQgdG8gaGF2ZSBWTXMgdGhhdAo+PiBjYW4gaGFuZGxlIHVuaW1w
bGVtZW50ZWQgTVNScyBpbiBwYXJhbGxlbCB0byBvbmVzIHRoYXQgZG8gbm90Lgo+Pgo+PiBTbyB3
aGF0ZXZlciB3ZSBpbXBsZW1lbnQsIEkgd291bGQgaWRlYWxseSB3YW50IGEgbWVjaGFuaXNtIGF0
IHRoZSBlbmQgb2YKPj4gdGhlIGRheSB0aGF0IGFsbG93cyBtZSB0byAidHJhcCB0aGUgcmVzdCIg
aW50byB1c2VyIHNwYWNlLgo+IAo+IEkgZG8gdGhpbmsgInRoZSByZXN0IiBzaG91bGQgYmUgZXhw
bGljaXRseSBzcGVjaWZpZWQsIHNvIHRoYXQKPiB1c2Vyc3BhY2UgZG9lc24ndCBnZXQgc3VycHJp
c2VzIHdoZW4ga3ZtIGV2b2x2ZXMuIE1heWJlIHRoaXMgY2FuIGJlCj4gZG9uZSB1c2luZyB0aGUg
YWxsb3ctbGlzdCB5b3UgcmVmZXIgdG8gbGF0ZXIsIGFsb25nIHdpdGggYSBzcGVjaWZpZWQKPiBh
Y3Rpb24gZm9yIGRpc2FsbG93ZWQgTVNSczogKDEpIHJhaXNlICNHUCwgKDIpIGlnbm9yZSwgb3Ig
KDMpIGV4aXQgdG8KPiB1c2Vyc3BhY2UuIFRoaXMgYWN0dWFsbHkgc2VlbXMgb3J0aG9nb25hbCB0
byB3aGF0IEFhcm9uIGlzIHdvcmtpbmcgb24sCj4gd2hpY2ggaXMgdG8gcmVxdWVzdCB0aGF0IHNw
ZWNpZmljIE1TUiBhY2Nlc3NlcyBleGl0IHRvIHVzZXJzcGFjZS4gQnV0LAo+IGF0IGxlYXN0IHRo
ZSBwbHVtYmluZyBmb3Ige1JELFdSfU1TUiBjb21wbGV0aW9uIHdoZW4gY29taW5nIGJhY2sgZnJv
bQo+IHVzZXJzcGFjZSBjYW4gYmUgbGV2ZXJhZ2VkIGJ5IGJvdGguCgoKVGhpbmtpbmcgYWJvdXQg
dGhpcyBmb3IgYSB3aGlsZSwgSSBhbSBxdWl0ZSBjb25maWRlbnQgdGhhdCB3ZSBkb24ndCBuZWVk
IAp0byBjb21wbGV4aWZ5IHRoaXMgYWxsIHRoYXQgbXVjaC4gVGhlICNHUCBwYXRoIGlzIG5ldmVy
IHBlcmZvcm1hbmNlIApjcml0aWNhbCBhbmQgdGh1cyBjYW4gZWFzaWx5IGJlIGhhbmRsZWQgaW4g
dXNlciBzcGFjZS4gVGhlcmUgYXJlIGEgZmV3IApuaWNoZSBjYXNlcyB3aGVyZSBleGl0aW5nIHRv
IHVzZXIgc3BhY2UgaXMgInRvbyBjb21wbGljYXRlZCIgKHRoaW5rIG5WTVggCk1TUiByZXN0b3Jl
IHBhdGgpLiBCdXQgdGhleSBhcmUgbmljaGUgYW5kIGp1c3QgYmFpbGluZyBvdXQgZm9yIHRoZSB1
c2VyIApzcGFjZSBleGl0IHBhdGggb24gdGhlbSBpcyBmaW5lLgoKU28gSSB0aGluayBhIHBhdGNo
IHRoYXQgYWxsb3dzIHVzIHRvIGFsbG93IGxpc3QgTVNScyB0aGF0IHNob3VsZCBiZSAKaGFuZGxl
ZCBpbiBLVk0gYW5kIGFub3RoZXIgcGF0Y2ggdGhhdCBhbGxvd3MgdXMgdG8gZGVmbGVjdCBhbnkg
TVNSIAppbmZsaWN0ZWQgI0dQcyBpbnRvIHVzZXIgc3BhY2UgaXMgYWxsIGl0IHRha2VzIHRvIG1h
a2UgdGhpcyBhIGZsZXhpYmxlIAphbmQgc3RhYmxlIEFCSS4KClRoZSBncmVhdCB0aGluZyBpcyB0
aGF0IGJ5IHVudGFuZ2xpbmcgdGhlIHR3byBiaXRzLCB3ZSBjYW4gYWxzbyBzdXBwb3J0IAp0aGUg
InVzZXIgc3BhY2Ugd2FudHMgdG8gbGVhdmUgaXQgYWxsIHRvIEtWTSwgYnV0IGJlIGFibGUgdG8g
aW1wbGVtZW50IAppZ25vcmVfbXNycyBpdHNlbGYiIHVzZSBjYXNlIGVhc2lseS4gVXNlciBzcGFj
ZSB3b3VsZCBqdXN0IG5vdCBzZXQgYW4gCmFsbG93IGxpc3QuCgpNZWFud2hpbGUsIEkgaGF2ZSBj
bGVhbmVkIHVwIEthcmltJ3Mgb2xkIHBhdGNoIHRvIGFkZCBhbGxvdyBsaXN0aW5nIHRvIApLVk0g
YW5kIHdvdWxkIHBvc3QgaXQgaWYgQWFyb24gZG9lc24ndCBiZWF0IG1lIHRvIGl0IDopLgoKCkFs
ZXgKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4g
MzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwg
Sm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcg
dW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

