Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1476C3EBF
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 00:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCUXqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 19:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCUXqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 19:46:22 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63CC5650B
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 16:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679442382; x=1710978382;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pRCGRjzOjDYfKaOfK5OVeXpAP5iLAJwnEhKbL8zuqIU=;
  b=l4FhScGbGz6l7wD/GAj/+8MVmhykapucH5AkARWv0ZWo0AfUZIwRoN8F
   o6CyXtdCjHAgl34FCq5J8oit0dRs5zIZ3lnW6hUiJNv8lYOf/3KLx6Pbe
   83PtUVezyvC2LG+Lhhi58HYsGc5FM3T3V9jB0iQNAtiIjOpHvPF+W0zfZ
   s=;
X-IronPort-AV: E=Sophos;i="5.98,280,1673913600"; 
   d="scan'208";a="271371947"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 23:46:15 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com (Postfix) with ESMTPS id 9F6EE40E60;
        Tue, 21 Mar 2023 23:46:13 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 21 Mar 2023 23:46:13 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.24; Tue, 21 Mar
 2023 23:46:11 +0000
Message-ID: <8dcd6141-85c9-aed5-2f50-9c9cd08d8e21@amazon.com>
Date:   Wed, 22 Mar 2023 00:46:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH] KVM: x86: Allow restore of some sregs with protected
 state
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>, <x86@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Sabin Rapan <sabrapan@amazon.com>
References: <20230320225159.92771-1-graf@amazon.com>
 <ZBnjZg6jxPtBPXc2@google.com>
 <CAMkAt6ozZ5LwvRNn+hP5-ZGOyrtDMmBUR+x5iJ37xVZyQk4kBw@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <CAMkAt6ozZ5LwvRNn+hP5-ZGOyrtDMmBUR+x5iJ37xVZyQk4kBw@mail.gmail.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D035UWB003.ant.amazon.com (10.13.138.85) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDIxLjAzLjIzIDE5OjE1LCBQZXRlciBHb25kYSB3cm90ZToKCj4gT24gVHVlLCBNYXIgMjEs
IDIwMjMgYXQgMTE6MDPigK9BTSBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNv
bT4gd3JvdGU6Cj4+ICtQZXRlcgo+Pgo+PiBPbiBNb24sIE1hciAyMCwgMjAyMywgQWxleGFuZGVy
IEdyYWYgd3JvdGU6Cj4+PiBXaXRoIHByb3RlY3RlZCBzdGF0ZSAobGlrZSBTRVYtRVMgYW5kIFNF
Vi1TTlApLCBLVk0gZG9lcyBub3QgaGF2ZSBkaXJlY3QKPj4+IGFjY2VzcyB0byBndWVzdCByZWdp
c3RlcnMuIEhvd2V2ZXIsIHdlIGRlZmxlY3QgbW9kaWZpY2F0aW9ucyB0byBDUjAsCj4+IFBsZWFz
ZSBhdm9pZCBwcm9ub3VucyBpbiBjaGFuZ2Vsb2dzIGFuZCBjb21tZW50cy4KPj4KPj4+IENSNCBh
bmQgRUZFUiB0byB0aGUgaG9zdC4gV2UgYWxzbyBjYXJyeSB0aGUgYXBpY19iYXNlIHJlZ2lzdGVy
IGFuZCBsZWFybgo+Pj4gYWJvdXQgQ1I4IGRpcmVjdGx5IGZyb20gYSBWTUNCIGZpZWxkLgo+Pj4K
Pj4+IFRoYXQgbWVhbnMgdGhlc2UgYml0cyBvZiBpbmZvcm1hdGlvbiBkbyBleGlzdCBpbiB0aGUg
aG9zdCdzIEtWTSBkYXRhCj4+PiBzdHJ1Y3R1cmVzLiBJZiB3ZSBldmVyIHdhbnQgdG8gcmVzdW1l
IGNvbnN1bXB0aW9uIG9mIGFuIGFscmVhZHkKPj4+IGluaXRpYWxpemVkIFZNU0EgKGd1ZXN0IHN0
YXRlKSwgd2Ugd2lsbCBuZWVkIHRvIGFsc28gcmVzdG9yZSB0aGVzZQo+Pj4gYWRkaXRpb25hbCBi
aXRzIG9mIEtWTSBzdGF0ZS4KPj4gRm9yIHNvbWUgZGVmaW5pdGlvbnMgb2YgIm5lZWQiLiAgSSd2
ZSBsb29rZWQgYXQgdGhpcyBjb2RlIG11bHRpcGxlIHRpbWVzIGluIHRoZQo+PiBwYXN0LCBhbmQg
ZXZlbiBwb3N0ZWQgcGF0Y2hlc1sxXSwgYnV0IEknbSBzdGlsbCB1bmNvbnZpbmNlZCB0aGF0IHRy
YXBwaW5nCj4+IENSMCwgQ1I0LCBhbmQgRUZFUiB1cGRhdGVzIGlzIG5lY2Vzc2FyeVsyXSwgd2hp
Y2ggaXMgcGFydGx5IHdoeSBzZXJpZXMgdG8gZml4Cj4+IHRoaXMgc3RhbGxlZCBvdXQuCj4+Cj4+
ICAgOiBJZiBLVk0gY2h1Z3MgYWxvbmcgaGFwcGlseSB3aXRob3V0IHRoZXNlIHBhdGNoZXMsIEkn
ZCBsb3ZlIHRvIHBpdm90IGFuZCB5YW5rIG91dAo+PiAgIDogYWxsIG9mIHRoZSBDUjAvNC84IGFu
ZCBFRkVSIHRyYXBwaW5nL3RyYWNraW5nLCBhbmQgdGhlbiBtYWtlIEtWTV9HRVRfU1JFR1MgYSBu
b3AKPj4gICA6IGFzIHdlbGwuCj4+Cj4+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwv
MjAyMTA1MDcxNjU5NDcuMjUwMjQxMi0xLXNlYW5qY0Bnb29nbGUuY29tCj4+IFsyXSBodHRwczov
L2xvcmUua2VybmVsLm9yZy9hbGwvWUpsYTh2cHdxQ3hxZ1M4Q0Bnb29nbGUuY29tCj4gWWVhIHdl
IGFyZSB1c2luZyBzaW1pbGFyIHBhdGNoZXMgdG8gZG8gaW50cmEtaG9zdCBtaWdyYXRpb24gZm9y
IFNOUCBWTXMuCj4KPiBJIGhhdmUgZHJvcHBlZCB0aGUgYmFsbCBvbiBteSBBSSBmcm9tIHRoYXQg
dGhyZWFkLiBMZXQgbWUgbG9vay90ZXN0IHRoaXMgcGF0Y2guCgoKQXdlc29tZSwgdGhhbmtzLiBJ
ZiB3ZSBjYW4gZ2V0IGF3YXkgd2l0aG91dCBhbnkgb2YgdGhlIGFib3ZlIHN0YXRlcyBhbmQgCm1h
a2Ugc3JlZ3MgY29tcGxldGVseSB1c2VsZXNzIGZvciBwcm90ZWN0ZWQgc3RhdGUsIEknZCBiZSBl
dmVuIGhhcHBpZXIgOikKCgpBbGV4CgoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJt
YW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzog
Q2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dl
cmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3Qt
SUQ6IERFIDI4OSAyMzcgODc5CgoK

