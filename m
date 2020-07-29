Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE60232667
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 22:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgG2UqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 16:46:03 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:22022 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgG2UqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 16:46:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596055562; x=1627591562;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=BzuyOP1b4PztqG2V1+OAhXQVg8bMxv07rK/gpE40p2c=;
  b=BfiaRBCHrsJZ09hdEQxkXJxdRQWZR4tRmqqjZQU4MCn5YMmHqz1kbZx/
   oJDy/0XFYIQbkYg/H+n9fF/5oK7iDG9/xrJYr89rF+7shtHkxetIZy72s
   fPDKXr0k67Fm3Gn6YCXAt6bIYjL8b4/2+6IgrPGMRIzL1CejxWoOGGSAA
   8=;
IronPort-SDR: /RUd/420zsosAuUM9sE4DXLd+Nryo7ZKl0qL4+pRQsMOfZgPw64I72doI6iBdCFaXTArb7tubx
 1V0pLA8Iwbqw==
X-IronPort-AV: E=Sophos;i="5.75,411,1589241600"; 
   d="scan'208";a="46346182"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 29 Jul 2020 20:46:01 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id B8801A25F4;
        Wed, 29 Jul 2020 20:45:57 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 20:45:56 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.100) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 20:45:53 +0000
Subject: Re: [PATCH] KVM: x86: Deflect unknown MSR accesses to user space
To:     Jim Mattson <jmattson@google.com>
CC:     Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Raslan, KarimAllah" <karahmed@amazon.de>
References: <20200728004446.932-1-graf@amazon.com>
 <87d04gm4ws.fsf@vitty.brq.redhat.com>
 <a1f30fc8-09f5-fe2f-39e2-136b881ed15a@amazon.com>
 <CALMp9eQ3OxhQZYiHPiebX=KyvjWQgxQEO-owjSoxgPKsOMRvjw@mail.gmail.com>
 <14035057-ea80-603b-0466-bb50767f9f7e@amazon.com>
 <CALMp9eSxWDPcu2=K4NHbx_ZcYjA_jmnoD7gXbUp=cnEbiU0jLA@mail.gmail.com>
 <69d8c4cd-0d36-0135-d1fc-0af7d81ce062@amazon.com>
 <CALMp9eSD=_soihVJD_8QVKkgGAieeaBcRcNf2gKBzKE7gU1Tjg@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <13877428-be3a-85a8-bcdc-3a21872ba0e6@amazon.com>
Date:   Wed, 29 Jul 2020 22:45:51 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSD=_soihVJD_8QVKkgGAieeaBcRcNf2gKBzKE7gU1Tjg@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D23UWA001.ant.amazon.com (10.43.160.68) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyOS4wNy4yMCAyMjozNywgSmltIE1hdHRzb24gd3JvdGU6Cj4gCj4gT24gV2VkLCBKdWwg
MjksIDIwMjAgYXQgMToyOSBQTSBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPiB3cm90
ZToKPiAKPj4gTWVhbndoaWxlLCBJIGhhdmUgY2xlYW5lZCB1cCBLYXJpbSdzIG9sZCBwYXRjaCB0
byBhZGQgYWxsb3cgbGlzdGluZyB0bwo+PiBLVk0gYW5kIHdvdWxkIHBvc3QgaXQgaWYgQWFyb24g
ZG9lc24ndCBiZWF0IG1lIHRvIGl0IDopLgo+IAo+IElkZWFsbHksIHRoaXMgYmVjb21lcyBhIGNv
bGxhYm9yYXRpb24gcmF0aGVyIHRoYW4gYSByYWNlIHRvIHRoZQo+IGZpbmlzaC4gSSdkIGxpa2Ug
dG8gc2VlIGJvdGggcHJvcG9zYWxzLCBzbyB0aGF0IHdlIGNhbiB0YWtlIHRoZSBiZXN0Cj4gcGFy
dHMgb2YgZWFjaCEKPiAKCk9oLCBkZWZpbml0ZWx5ISBJJ20gbm90IHJlYWxseSBtYXJyaWVkIHRv
IEthcmltJ3MgcGF0Y2ggaGVyZSwgaXQgd2FzIApqdXN0IHNpbXBseSB0aGVyZSBhbmQgaXMgZGVh
ZCBzaW1wbGUuCgpEbyB5b3UgaGF2ZSBhIHJvdWdoIEVUQSBmb3IgQWFyb24ncyBwYXRjaCBzZXQg
eWV0PyA6KQoKCkFsZXgKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgK
S3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFu
IFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hh
cmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4
OSAyMzcgODc5CgoK

