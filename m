Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D274F3DBA9C
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 16:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbhG3ObS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 10:31:18 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:10509 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239153AbhG3ObR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 10:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1627655474; x=1659191474;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=Eo2k2WtpUhMgtuVMWemOrr66kqRiEGYzgKR0jKb9Ywo=;
  b=Voqma7jqoOWP/+LCin0XpYn8fqVjFblIJA/aruBlvqdCwbe29p6G46rG
   0OctId+aqbq/0OEByaJ7dAlbFWgb7WpcpcPiTBDrrsZBe5AMDcIBkgfa+
   /IsbeKMVMMrtfPGneOoTppAU5GEDturVJsYrpWH2U8rNFQRYyY7i0c9pG
   I=;
X-IronPort-AV: E=Sophos;i="5.84,282,1620691200"; 
   d="scan'208";a="130538387"
Subject: Re: [PATCH 3/4] KVM: x86: hyper-v: Check if guest is allowed to use XMM
 registers for hypercall input
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 30 Jul 2021 14:31:05 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id 918A5A2155;
        Fri, 30 Jul 2021 14:31:03 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.162.248) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 30 Jul 2021 14:30:59 +0000
Date:   Fri, 30 Jul 2021 16:30:55 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        <linux-kernel@vger.kernel.org>
Message-ID: <20210730143054.GC20232@u366d62d47e3651.ant.amazon.com>
References: <20210730122625.112848-1-vkuznets@redhat.com>
 <20210730122625.112848-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210730122625.112848-4-vkuznets@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.162.248]
X-ClientProxiedBy: EX13D31UWC001.ant.amazon.com (10.43.162.152) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCBKdWwgMzAsIDIwMjEgYXQgMDI6MjY6MjRQTSArMDIwMCwgVml0YWx5IEt1em5ldHNv
diB3cm90ZToKPiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9m
IHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBp
cyBzYWZlLgo+IAo+IAo+IAo+IFRMRlMgc3RhdGVzIHRoYXQgIkF2YWlsYWJpbGl0eSBvZiB0aGUg
WE1NIGZhc3QgaHlwZXJjYWxsIGludGVyZmFjZSBpcwo+IGluZGljYXRlZCB2aWEgdGhlIOKAnEh5
cGVydmlzb3IgRmVhdHVyZSBJZGVudGlmaWNhdGlvbuKAnSBDUFVJRCBMZWFmCj4gKDB4NDAwMDAw
MDMsIHNlZSBzZWN0aW9uIDIuNC40KSAuLi4gQW55IGF0dGVtcHQgdG8gdXNlIHRoaXMgaW50ZXJm
YWNlCj4gd2hlbiB0aGUgaHlwZXJ2aXNvciBkb2VzIG5vdCBpbmRpY2F0ZSBhdmFpbGFiaWxpdHkg
d2lsbCByZXN1bHQgaW4gYSAjVUQKPiBmYXVsdC4iCj4gCj4gSW1wbGVtZW50IHRoZSBjaGVjayBm
b3IgJ3N0cmljdCcgbW9kZSAoS1ZNX0NBUF9IWVBFUlZfRU5GT1JDRV9DUFVJRCkuCj4gCj4gU2ln
bmVkLW9mZi1ieTogVml0YWx5IEt1em5ldHNvdiA8dmt1em5ldHNAcmVkaGF0LmNvbT4KClJldmll
d2VkLWJ5OiBTaWRkaGFydGggQ2hhbmRyYXNla2FyYW4gPHNpZGNoYUBhbWF6b24uZGU+CgoKCkFt
YXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3
IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFu
IFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhS
QiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

