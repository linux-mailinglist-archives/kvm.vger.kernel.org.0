Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8527C88E7
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 17:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbjJMPlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 11:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbjJMPlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 11:41:00 -0400
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96B2BB
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 08:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1697211658; x=1728747658;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=+WMjQv6PYaqrft1OvG2kp1YAwxihJrr7iCkxSDlP7tw=;
  b=WgHNkgc2RuyigI5k3gHltUy1b6LsX0guqHWGsAgZvr69nZDLmN1cAd25
   QK9S57mkcEovrR9Qcx79hh2/vlmkwEhz5X78C4B9Sxuvbn3MmfUtJeJxy
   w2C9bP6Uhlr5jhqKJfQWxJNG9gz/aP5MdmdMCP2X7iQe4dDvjXnLiheKs
   w=;
X-IronPort-AV: E=Sophos;i="6.03,222,1694736000"; 
   d="scan'208";a="35687121"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 15:40:55 +0000
Received: from EX19D001EUA004.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com (Postfix) with ESMTPS id 826864875D;
        Fri, 13 Oct 2023 15:40:53 +0000 (UTC)
Received: from EX19D026EUB002.ant.amazon.com (10.252.61.110) by
 EX19D001EUA004.ant.amazon.com (10.252.50.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Fri, 13 Oct 2023 15:40:52 +0000
Received: from EX19D047EUB002.ant.amazon.com (10.252.61.57) by
 EX19D026EUB002.ant.amazon.com (10.252.61.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Fri, 13 Oct 2023 15:40:52 +0000
Received: from EX19D047EUB002.ant.amazon.com ([fe80::a00c:a6ac:280e:2ca7]) by
 EX19D047EUB002.ant.amazon.com ([fe80::a00c:a6ac:280e:2ca7%3]) with mapi id
 15.02.1118.037; Fri, 13 Oct 2023 15:40:52 +0000
From:   "Mancini, Riccardo" <mancio@amazon.com>
To:     Gavin Shan <gshan@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Teragni, Matias" <mteragni@amazon.com>,
        "Batalov, Eugene" <bataloe@amazon.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: RE: Bug? Incompatible APF for 4.14 guest on 5.10 and later host
Thread-Topic: Bug? Incompatible APF for 4.14 guest on 5.10 and later host
Thread-Index: Adn94wvULB16boopSLqi0qjVGsqqjw==
Date:   Fri, 13 Oct 2023 15:40:52 +0000
Message-ID: <51bec52172df4a0a8bd5486dee7c0c26@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.82.29]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBBZGRpbmcgTWFyYywgT2xpdmVyIGFuZCBrdm1hcm1AbGlzdHMubGludXguZGV2DQo+IA0KPiBJ
IHRyaWVkIHRvIG1ha2UgdGhlIGZlYXR1cmUgYXZhaWxhYmxlIHRvIEFSTTY0IGxvbmcgdGltZSBh
Z28sIGJ1dCB0aGUNCj4gZWZmb3J0cyB3ZXJlIGRpc2NvbnRpbnVlZCBhcyB0aGUgc2lnbmlmaWNh
bnQgY29uY2VybiB3YXMgbm8gdXNlcnMNCj4gZGVtYW5kaW5nIGZvciBpdCBbMV0uDQo+IEl0J3Mg
ZGVmaW5pdGVseSBleGNpdGluZyBuZXdzIHRvIGtub3cgaXQncyBhIGltcG9ydGFudCBmZWF0dXJl
IHRvIEFXUy4gSQ0KPiBndWVzcyBpdCdzIHByb2JhYmx5IGFub3RoZXIgY2hhbmNlIHRvIHJlLWV2
YWx1YXRlIHRoZSBmZWF0dXJlIGZvciBBUk02ND8NCj4gDQo+IFsxXSBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9rdm1hcm0vODdpbG9xMm9rZS53bC1tYXpAa2VybmVsLm9yZy8NCj4gDQo+IEFzeW5j
IFBGIG5lZWRzIHR3byBzaWduYWxzIHNlbnQgZnJvbSBob3N0IHRvIGd1ZXN0LCBTREVJIChTb2Z0
d2FyZQ0KPiBEZWxlZ2F0ZWQgRXhjZXB0aW9uIEludGVyZmFjZSkgaXMgbGV2ZXJhZ2VkIGZvciB0
aGF0LiBTbyB0aGVyZSB3ZXJlIHR3bw0KPiBzZXJpZXMgdG8gc3VwcG9ydCBTREVJIHZpcnR1YWxp
emF0aW9uIFsxXSBhbmQgQXN5bmMgUEYgb24gQVJNNjQgWzJdLg0KPiANCj4gWzFdIGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2t2bWFybS8yMDIyMDUyNzA4MDI1My4xNTYyNTM4LTEtDQo+IGdzaGFu
QHJlZGhhdC5jb20vDQo+IFsyXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm1hcm0vMjAyMTA4
MTUwMDU5NDcuODM2OTktMS0NCj4gZ3NoYW5AcmVkaGF0LmNvbS8NCg0KVGhhbmtzIGZvciBhbGwg
dGhlIGluZm9ybWF0aW9uISBUaGlzIG1pZ2h0IGJlY29tZSB1c2VmdWwgaW4gdGhlIGZ1dHVyZSwN
CndoZW4gd2UnbGwgZW5hYmxlIHRoaXMgZmVhdHVyZSBvbiBBUk0sIGdpdmVuIHRoZSBpbXByb3Zl
bWVudHMgd2Ugc2F3IGluIHg4Ni4NCg0KPiANCj4gSSBnb3Qgc2V2ZXJhbCBxdWVzdGlvbnMgZm9y
IE1hbmNpbmkgdG8gYW5zd2VyLCBoZWxwZnVsIHVuZGVyc3RhbmQgdGhlDQo+IHNpdHVhdGlvbiBi
ZXR0ZXIuDQo+IA0KPiAtIFZNIHNoYXBzaG90IGlzIHN0b3JlZCBzb21ld2hlcmUgcmVtb3RlbHku
IEl0IG1lYW5zIHRoZSBwYWdlIGZhdWx0IG9uDQo+ICAgIGluc3RydWN0aW9uIGZldGNoIGJlY29t
ZXMgZXhwZW5zaXZlLiBEbyB3ZSBoYXZlIGJlbmNobWFya3MgaG93IG11Y2gNCj4gICAgYmVuZWZp
dHMgYnJvdWdodCBieSBBc3luYyBQRiBvbiB4ODYgaW4gQVdTIGVudmlyb25tZW50Pw0KDQpJbiBv
dXIgc21hbGwgbG9jYWwgcmVwcm8gKG9ubHkgbG9jYWwgZGlzayBhY2Nlc3MpIHdoaWNoIHJ1bnMg
YSBKYXZhIGxvYWQgYWZ0ZXINCnJlc3VtZSBvZiB0aGUgRmlyZWNyYWNrZXIgVk0sIHdlIHNhdyBh
IDIwJSBwZXJmb3JtYW5jZSByZWdyZXNzaW9uIChmcm9tIH44MG1zIA0KdG8gfjEwMG1zKSBhbmQg
dGhlIHRpbWUgc3BlbnQgb3V0c2lkZSB0aGUgVk0gZHVlIHRvIEVQVF9WSU9MQVRJT04gaW5jcmVh
c2VkIDN4IA0KZnJvbSAzMG1zIHRvIDkwbXMuIFRoaXMgaW1wYWN0IGlzIGFtcGxpZmllZCB3aGVu
IGFjY2VzcyBpcyBub3QgbG9jYWwuDQoNCj4gDQo+IC0gSSdtIHdhbmRlcmluZyBpZiB0aGUgZGF0
YSBjYW4gYmUgZmV0Y2hlZCBmcm9tIHNvbWV3aGVyZSByZW1vdGVseSBpbiBBV1MNCj4gICAgZW52
aXJvbm1lbnQ/DQoNCldpdGhvdXQgZ2V0dGluZyBpbnRvIGRldGFpbHMsIHllcywgYW55IG1lbW9y
eSBwYWdlIGNvdWxkIGJlIHJlbW90ZWx5IGFjY2Vzc2VkDQppbiB0aGUgd29yc3QgY2FzZS4NCg0K
PiANCj4gLSBUaGUgZGF0YSBjYW4gYmUgc3RvcmVkIGluIGxvY2FsIERSQU0gb3Igc3dhcHBpbmcg
c3BhY2UsIHRoZSBwYWdlIGZhdWx0DQo+ICAgIHRvIGZldGNoIGRhdGEgYmVjb21lcyBleHBlbnNp
dmUgaWYgdGhlIGRhdGEgaXMgc3RvcmVkIGluIHN3YXBwaW5nDQo+IHNwYWNlLg0KPiAgICBJJ20g
bm90IHN1cmUgaWYgaXQncyBwb3NzaWJsZSB0aGUgZGF0YSByZXNpZGVzIGluIHRoZSBzd2FwcGlu
ZyBzcGFjZSBpbg0KPiAgICBBV1MgZW52aXJvbm1lbnQ/IE5vdGUgdGhhdCB0aGUgc3dhcHBpbmcg
c3BhY2UsIGNvcnJlc3BvbmRpbmcgdG8gZGlzaywNCj4gICAgY291bGQgYmUgc29tZXdoZXJlIHJl
bW90ZWx5IHNlYXRlZC4NCg0KSW4gb3VyIHVzYWdlLCBkdXJpbmcgcmVzdW1wdGlvbiBhbG1vc3Qg
YWxsIHBhZ2VzIGFyZSBtaXNzaW5nIGFuZCBhcmUgcG9wdWxhdGVkDQpvbiBkZW1hbmQgd2l0aCBh
IHVzZXJmYXVsdGZkLCBlaXRoZXIgZnJvbSBhIGxvY2FsIGNhY2hlIChtZW1vcnkgb3IgZGlzaykg
b3INCmZyb20gdGhlIG5ldHdvcmsuDQoNClRoYW5rcywNClJpY2NhcmRvDQoNCj4gDQo+IFRoYW5r
cywNCj4gR2F2aW4NCj4gDQoNCg==
