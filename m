Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5484D146CC4
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 16:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgAWP1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 10:27:52 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:16836 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgAWP1w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 10:27:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579793271; x=1611329271;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=U9uR4MOLWb0JHbPKaVmW801A9ypyqXZ1qb/WboNCkL4=;
  b=Cl8uddNwLiF93JKvDct64gYMm0NR+xR2X04Oo3mkoaXYq04G+qH+7Ryu
   wySVpwl4h4ai+fb9VTyl80e+C/ZLsrzTs28LBm3H1XUA0HM8rSctSso8R
   xAVUnSRaooLXl1kVJTKXdDToKh2cXm3O/R26t2BltSbZJr8nqIQGiAotZ
   g=;
IronPort-SDR: a8C8CrtETwu9kUniGyOMeTqvlAtA50dhWRaRV4mL7sZs2qm2NXJTgzxBFtaEFjOog7fVmKzuGC
 FnMjIaP/lZqw==
X-IronPort-AV: E=Sophos;i="5.70,354,1574121600"; 
   d="scan'208";a="14399224"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 23 Jan 2020 15:27:49 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 630FFA2307;
        Thu, 23 Jan 2020 15:27:49 +0000 (UTC)
Received: from EX13D20UWC004.ant.amazon.com (10.43.162.41) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 15:27:48 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D20UWC004.ant.amazon.com (10.43.162.41) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 15:27:48 +0000
Received: from uc3ce012741425f.ant.amazon.com (10.28.84.89) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 23 Jan 2020 15:27:47 +0000
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.de>,
        Milan Pandurov <milanpa@amazon.de>, <kvm@vger.kernel.org>
CC:     <rkrcmar@redhat.com>, <borntraeger@de.ibm.com>
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
 <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
 <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
 <e77a2477-6010-ae1d-0afd-0c5498ba2117@amazon.de>
 <30358a22-084c-6b0b-ae67-acfb7e69ba8e@amazon.com>
 <7f206904-be2b-7901-1a88-37ed033b4de3@amazon.de>
 <7e6093f1-1d80-8278-c843-b4425ce098bf@redhat.com>
 <6f13c197-b242-90a5-3f53-b75aa8a0e5aa@amazon.de>
 <b69546be-a25c-bbea-7e37-c07f019dcf85@redhat.com>
 <c3b61fff-b40e-07f8-03c4-b177fbaab1a3@amazon.de>
 <3d3d9374-a92b-0be0-1d6c-82b39fe7ef16@redhat.com>
 <25821210-50c4-93f4-2daf-5b572f0bcf31@amazon.de>
 <2e2cd423-ab6c-87ec-b856-2c7ca191d809@redhat.com>
From:   <milanpa@amazon.com>
Message-ID: <01dc5863-91b4-6ee0-2985-8c2bf41e73e9@amazon.com>
Date:   Thu, 23 Jan 2020 16:27:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2e2cd423-ab6c-87ec-b856-2c7ca191d809@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMS8yMy8yMCA0OjA1IFBNLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+IE9uIDIzLzAxLzIwIDE1
OjU4LCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4+IHRoZSBjYXNlLCBvZiBjb3Vyc2UgaXQgd291
bGQgYmUgZmluZSBmb3IgbWUgdG8gdXNlIE9ORV9SRUcgb24gYSBWTS7CoCBUaGUKPj4+IHBhcnQg
d2hpY2ggSSBkb24ndCBsaWtlIGlzIGhhdmluZyB0byBtYWtlIGFsbCBPTkVfUkVHIHBhcnQgb2Yg
dGhlCj4+PiB1c2Vyc3BhY2UgQUJJL0FQSS4KPj4gV2UgZG9uJ3QgaGF2ZSBhbGwgb2YgT05FX1JF
RyBhcyBwYXJ0IG9mIHRoZSB1c2VyIHNwYWNlIEFCSSB0b2RheS4KPiBTdGlsbCB0aG9zZSB0aGF0
IGV4aXN0IGNhbm5vdCBjaGFuZ2UgdGhlaXIgaWQuICBUaGlzIG1ha2VzIHRoZW0gYSBwYXJ0Cj4g
b2YgdGhlIHVzZXJzcGFjZSBBQkkuCj4KPj4gQnV0IEkgbGlrZSB0aGUgaWRlYSBvZiBhIE9ORV9S
RUcgcXVlcnkgaW50ZXJmYWNlIHRoYXQgZ2l2ZXMgeW91IHRoZSBsaXN0Cj4+IG9mIGF2YWlsYWJs
ZSByZWdpc3RlcnMgYW5kIGEgc3RyaW5nIHJlcHJlc2VudGF0aW9uIG9mIHRoZW0uIEl0IHdvdWxk
Cj4+IG1ha2UgcHJvZ3JhbW1pbmcga3ZtIGZyb20gUHl0aG9uIHNvIGVhc3khCj4gWWVhaCwgd291
bGRuJ3QgaXQ/ICBNaWxhbiwgd2hhdCBkbyB5b3UgdGhpbmsgYWJvdXQgaXQ/Cj4KPiBQYW9sbwo+
CkkgYWdyZWUsIGV4dGVuZGluZyB0aGUgQVBJIHdpdGggR0VUX0FWQUlMQUJMRV9PTkVfUkVHUyAo
YW5kIHBvc3NpYmx5IGEgCmJpdG1hc2sgYXJndW1lbnQgdG8gbmFycm93IGRvd24gd2hpY2ggdHlw
ZSBvZiByZWdpc3RlcnMgdXNlcnNwYWNlIGlzIAppbnRlcmVzdGVkIGluKSBpcyBhIGNsZWFuIHNv
bHV0aW9uLiBXZSB3b24ndCByZXF1aXJlIHVzZXJzcGFjZSB0byByZWx5IApvbiBjb25zdGFudHMg
aW4gY29tcGlsZSB0aW1lIGlmIGl0IGRvZXNuJ3QgbmVlZCB0by4KCk9ubHkgY29uY2VybiBpcyB0
aGF0IG5vdyB3ZSBuZWVkIHRvIGhhdmUgc29tZSBraW5kIG9mIGRhdGFzdHJ1Y3R1cmUgZm9yIApr
ZWVwaW5nIHRoZSBtYXBwaW5ncyBiZXR3ZWVuIGFsbCBhdmFpbGFibGUgT05FX1JFRyBJRHMgYW5k
IHRoZWlyIApzdHJpbmdzL2Rlc2NyaXB0aW9ucy4gQWRkaXRpb25hbGx5IGVuZm9yY2luZyB0aGF0
IG5ld2x5IGFkZGVkIE9ORV9SRUdzIAphbHdheXMgZ2V0IGFkZGVkIHRvIHRoYXQgbWFwcGluZywg
aXMgYWxzbyBuZWNlc3NhcnkuCgpNaWxhbgoKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIg
R2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1
bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFt
dHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4K
VXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

