Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0AFB1470CC
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 19:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAWScP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 13:32:15 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:34004 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgAWScP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 13:32:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579804334; x=1611340334;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=2xa9r2C+xBeeJ86aG/9m7hfIYKWMIFAuiJ/h8jAAxYE=;
  b=HtzG7D29ooctDLQ1zqtIwppscx9rA42b6YqMjMdf6AzDrJnY2sb3RTPp
   sYetkIQZEynNNOZhkMenLdSi3hU+B+bMlKB2VEzaWmdkORFLbYOEbwFve
   c+OyzMHrV5k3QIegl9Z3SnRrmQeLK8QS4aCLSlehccGoNx9HFgTMkAaTY
   M=;
IronPort-SDR: +2L0xmRrWbvTKQlyaG2z/heQkMzyNdb/uJcJK+pzTnAlUOG9H1za64NWyeaTHG5X0ZMIdkr0M/
 /iRkIh4f4ORg==
X-IronPort-AV: E=Sophos;i="5.70,354,1574121600"; 
   d="scan'208";a="20650102"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 23 Jan 2020 18:31:58 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id B237728251D;
        Thu, 23 Jan 2020 18:31:56 +0000 (UTC)
Received: from EX13D20UWA001.ant.amazon.com (10.43.160.34) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 18:31:56 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D20UWA001.ant.amazon.com (10.43.160.34) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 18:31:55 +0000
Received: from uc3ce012741425f.ant.amazon.com (10.28.84.89) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 23 Jan 2020 18:31:54 +0000
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
 <01dc5863-91b4-6ee0-2985-8c2bf41e73e9@amazon.com>
 <f71763ad-2336-0436-39fc-bb476b559eee@redhat.com>
From:   <milanpa@amazon.com>
Message-ID: <45329483-5a7c-089e-fa85-4b3ada231493@amazon.com>
Date:   Thu, 23 Jan 2020 19:31:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f71763ad-2336-0436-39fc-bb476b559eee@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMS8yMy8yMCA1OjE1IFBNLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+IE9uIDIzLzAxLzIwIDE2
OjI3LCBtaWxhbnBhQGFtYXpvbi5jb20gd3JvdGU6Cj4+Pgo+Pj4gUGFvbG8KPj4+Cj4+IEkgYWdy
ZWUsIGV4dGVuZGluZyB0aGUgQVBJIHdpdGggR0VUX0FWQUlMQUJMRV9PTkVfUkVHUyAoYW5kIHBv
c3NpYmx5IGEKPj4gYml0bWFzayBhcmd1bWVudCB0byBuYXJyb3cgZG93biB3aGljaCB0eXBlIG9m
IHJlZ2lzdGVycyB1c2Vyc3BhY2UgaXMKPj4gaW50ZXJlc3RlZCBpbikgaXMgYSBjbGVhbiBzb2x1
dGlvbi4gV2Ugd29uJ3QgcmVxdWlyZSB1c2Vyc3BhY2UgdG8gcmVseQo+PiBvbiBjb25zdGFudHMg
aW4gY29tcGlsZSB0aW1lIGlmIGl0IGRvZXNuJ3QgbmVlZCB0by4KPj4KPj4gT25seSBjb25jZXJu
IGlzIHRoYXQgbm93IHdlIG5lZWQgdG8gaGF2ZSBzb21lIGtpbmQgb2YgZGF0YXN0cnVjdHVyZSBm
b3IKPj4ga2VlcGluZyB0aGUgbWFwcGluZ3MgYmV0d2VlbiBhbGwgYXZhaWxhYmxlIE9ORV9SRUcg
SURzIGFuZCB0aGVpcgo+PiBzdHJpbmdzL2Rlc2NyaXB0aW9ucy4gQWRkaXRpb25hbGx5IGVuZm9y
Y2luZyB0aGF0IG5ld2x5IGFkZGVkIE9ORV9SRUdzCj4+IGFsd2F5cyBnZXQgYWRkZWQgdG8gdGhh
dCBtYXBwaW5nLCBpcyBhbHNvIG5lY2Vzc2FyeS4KPiBGb3Igbm93IGp1c3QgZG8gdGhlIGltcGxl
bWVudGF0aW9uIGZvciBWTSBPTkVfUkVHcy4gIFdlJ2xsIHdvcnJ5IGFib3V0Cj4gdGhlIGV4aXN0
aW5nIFZDUFUgcmVnaXN0ZXJzIGxhdGVyLgo+Cj4gUGFvbG8KPgpTb3VuZHMgZ29vZC4KClRoYW5r
cyBmb3IgdGhlIGhlbHAsIEkgd2lsbCB1cGRhdGUgdGhlIHBhdGNoIHNvb24uCgpNaWxhbgoKCgoK
QW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAx
MTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRo
YW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIg
SFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

