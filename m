Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CA42344AF
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 13:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732685AbgGaLmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 07:42:35 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:57761 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732104AbgGaLme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 07:42:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596195753; x=1627731753;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=K3AiM2F/clmnqut2Znxq+qWVgeBAAqvTi2Syfi39/mc=;
  b=haQKNtVfFf/YQk+GfU0r0g1LgmT4zGoF9mpmDbnnNnCjFTpN9yGtvbAf
   4QiFaenwp7BGhgZ2NbRfZpc78Q5yrvDa7hv69l+39lmZq7RjAV1oYHfXK
   FSFZ0SUy8En6RwK6KmPNlryEy83BiLSLabGypXa8epX3/kvo2SjEA0ZvH
   w=;
IronPort-SDR: LC8zCw1EdTzbrGurmmeoqTUHqPnnCNOnTYTVsS/5NQhpGOFuhOowz3TYeExDKBsBSb7ISZT/KS
 6CSRvBNR49Tg==
X-IronPort-AV: E=Sophos;i="5.75,418,1589241600"; 
   d="scan'208";a="46683797"
Subject: Re: [PATCH v2 1/3] KVM: x86: Deflect unknown MSR accesses to user space
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 31 Jul 2020 11:42:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 19CCB241D46;
        Fri, 31 Jul 2020 11:42:28 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 31 Jul 2020 11:42:28 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.34) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 31 Jul 2020 11:42:25 +0000
To:     Jim Mattson <jmattson@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        kvm list <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>
References: <20200729235929.379-1-graf@amazon.com>
 <20200729235929.379-2-graf@amazon.com>
 <CALMp9eRq3QUG64BwSGLbehFr8k-OLSM3phcw7mhuZ9hVk_N2-A@mail.gmail.com>
 <e7cbf218-fb01-2f30-6c5c-a4b6e441b5e4@amazon.com>
 <CALMp9eRQRaw7raxeH1nOTGr0rBk5bqbmoxUo7txGyQfaBs0=4g@mail.gmail.com>
 <CALMp9eSSKra+Vic0U9kDeiT1y+Jfq6Vmrqsw+S8jqD0_oqH9zA@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <8d0bae24-c83d-df89-01cb-e52cddd8ba92@amazon.com>
Date:   Fri, 31 Jul 2020 13:42:22 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSSKra+Vic0U9kDeiT1y+Jfq6Vmrqsw+S8jqD0_oqH9zA@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D04UWB001.ant.amazon.com (10.43.161.46) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAzMS4wNy4yMCAwNToyMCwgSmltIE1hdHRzb24gd3JvdGU6Cj4gQ0FVVElPTjogVGhpcyBl
bWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3Qg
Y2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGNhbiBjb25maXJtIHRo
ZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4KPiAKPiAKPiAKPiBPbiBUaHUs
IEp1bCAzMCwgMjAyMCBhdCA0OjUzIFBNIEppbSBNYXR0c29uIDxqbWF0dHNvbkBnb29nbGUuY29t
PiB3cm90ZToKPj4KPj4gT24gVGh1LCBKdWwgMzAsIDIwMjAgYXQgNDowOCBQTSBBbGV4YW5kZXIg
R3JhZiA8Z3JhZkBhbWF6b24uY29tPiB3cm90ZToKPj4+IERvIHlvdSBoYXZlIGEgcGFydGljdWxh
ciBzaXR1YXRpb24gaW4gbWluZCB3aGVyZSB0aGF0IHdvdWxkIG5vdCBiZSB0aGUKPj4+IGNhc2Ug
YW5kIHdoZXJlIHdlIHdvdWxkIHN0aWxsIHdhbnQgdG8gYWN0dWFsbHkgY29tcGxldGUgYW4gTVNS
IG9wZXJhdGlvbgo+Pj4gYWZ0ZXIgdGhlIGVudmlyb25tZW50IGNoYW5nZWQ/Cj4+Cj4+IEFzIGZh
ciBhcyB1c2Vyc3BhY2UgaXMgY29uY2VybmVkLCBpZiBpdCBoYXMgcmVwbGllZCB3aXRoIGVycm9y
PTAsIHRoZQo+PiBpbnN0cnVjdGlvbiBoYXMgY29tcGxldGVkIGFuZCByZXRpcmVkLiBJZiB0aGUg
a2VybmVsIGV4ZWN1dGVzIGEKPj4gZGlmZmVyZW50IGluc3RydWN0aW9uIGF0IENTOlJJUCwgdGhl
IHN0YXRlIGlzIGNlcnRhaW5seSBpbmNvbnNpc3RlbnQKPj4gZm9yIFdSTVNSIGV4aXRzLiBJdCB3
b3VsZCBhbHNvIGJlIGluY29uc2lzdGVudCBmb3IgUkRNU1IgZXhpdHMgaWYgdGhlCj4+IFJETVNS
IGVtdWxhdGlvbiBvbiB0aGUgdXNlcnNwYWNlIHNpZGUgaGFkIGFueSBzaWRlLWVmZmVjdHMuCj4g
Cj4gQWN0dWFsbHksIEkgdGhpbmsgdGhlcmUncyBhIHBvdGVudGlhbCBwcm9ibGVtIHdpdGggaW50
ZXJydXB0IGRlbGl2ZXJ5Cj4gZXZlbiBpZiB0aGUgaW5zdHJ1Y3Rpb24gYnl0ZXMgYXJlIHRoZSBz
YW1lLiBPbiB0aGUgc2Vjb25kIHBhc3MsIGFuCj4gaW50ZXJydXB0IGNvdWxkIGJlIGRlbGl2ZXJl
ZCBvbiB0aGUgQ1M6SVAgb2YgYSBXUk1TUiwgZXZlbiB0aG91Z2gKPiB1c2Vyc3BhY2UgaGFzIGFs
cmVhZHkgZW11bGF0ZWQgdGhlIFdSTVNSIGluc3RydWN0aW9uLiBUaGlzIGNvdWxkIGJlCj4gcGFy
dGljdWxhcmx5IGF3a3dhcmQgaWYgdGhlIFdSTVNSIHdhcyB0byB0aGUgeDJBUElDIFRQUiByZWdp
c3RlciwgYW5kCj4gaW4gZmFjdCBsb3dlcmVkIHRoZSBUUFIgc3VmZmljaWVudGx5IHRvIGFsbG93
IGEgcGVuZGluZyBpbnRlcnJ1cHQgdG8KPiBiZSBkZWxpdmVyZWQuCgpPaywgeW91IGdvdCBtZSBj
b252aW5jZWQgaGVyZSA6KS4gVGhlIGZvbGxvd2luZyBmbG93IGJyZWFrcyB3aXRoIG15IG1vZGVs
OgoKICAgKiByZG1zciBvbiAweDEyMywgdHJhcHMgdG8gdXNlciBzcGFjZQogICAqIHVzZXIgc3Bh
Y2UgaGFuZGxlcyBpdCwgd3JpdGVzIGRhdGEgaW50byBydW4tPm1zcgogICAqIGtlcm5lbCBpbmpl
Y3RzIHBlbmRpbmcgSVJRCiAgICogSVJRIGhhbmRsZXIgZG9lcyByZG1zciBvbiAweDEyNCwgd2hp
Y2ggd291bGQgYmUgaGFuZGxlZCBieSB1c2VyIHNwYWNlCiAgICoga2VybmVsIHJldHVybnMgdmFs
dWUgZm9yIDB4MTIzIHRvIHRoZSByZWFkCgpTbyB5ZXMsIEkgYWdyZWUsIHdlIGhhdmUgdG8gZmlu
aXNoIHRoZSBpbnN0cnVjdGlvbiBoYW5kbGluZyBiZWZvcmUgd2UgCmNhbiBnbyBiYWNrIGludG8g
bm9ybWFsIG9wZXJhdGlvbiBmbG93LgoKCkFsZXgKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRl
ciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVo
cnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0g
QW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxp
bgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

