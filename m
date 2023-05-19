Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C4A70A325
	for <lists+kvm@lfdr.de>; Sat, 20 May 2023 01:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjESXFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 19:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbjESXFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 19:05:48 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E1DE5C
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 16:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1684537547; x=1716073547;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=Akk4jTbKS3jfpenCIs2AwQ4BVyOqzRVqFaYz14y/3kM=;
  b=SPYbgq0pz0WXLjZPH+1FJZ8tU/HesWBTmLd166ssnv+oRVtzExsvGJwz
   /xdu3YBHN/7sngjQ+Ou0oGRnVd1xuvy17I8Hc4AcCfhw7NZ6pIg+MPtTv
   lq2hiU6OofkRE87awl23MgdO50L67NQrsmd3vZmtMtn1lAZMit+0VqZac
   s=;
X-IronPort-AV: E=Sophos;i="6.00,178,1681171200"; 
   d="scan'208";a="340102134"
Subject: Re: [PATCH v8 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
Thread-Topic: [PATCH v8 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 23:05:45 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com (Postfix) with ESMTPS id 518D380C58;
        Fri, 19 May 2023 23:05:35 +0000 (UTC)
Received: from EX19D030UWB004.ant.amazon.com (10.13.139.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 19 May 2023 23:04:53 +0000
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX19D030UWB004.ant.amazon.com (10.13.139.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 19 May 2023 23:04:53 +0000
Received: from EX19D030UWB002.ant.amazon.com ([fe80::8cbd:fcae:56ad:4dfa]) by
 EX19D030UWB002.ant.amazon.com ([fe80::8cbd:fcae:56ad:4dfa%6]) with mapi id
 15.02.1118.026; Fri, 19 May 2023 23:04:53 +0000
From:   "Jitindar Singh, Suraj" <surajjs@amazon.com>
To:     "maz@kernel.org" <maz@kernel.org>
CC:     "jingzhangos@google.com" <jingzhangos@google.com>,
        "oupton@google.com" <oupton@google.com>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "rananta@google.com" <rananta@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "reijiw@google.com" <reijiw@google.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tabba@google.com" <tabba@google.com>
Thread-Index: AQHZiQr5jQzeF1NLLE28Gk+kHNwsuq9fE1YAgAF0SwCAAMt4AIAA53MA
Date:   Fri, 19 May 2023 23:04:53 +0000
Message-ID: <bdba9f6db5bc2f617f2242c3ddbff8adb7c00c91.camel@amazon.com>
References: <20230503171618.2020461-1-jingzhangos@google.com>
         <20230503171618.2020461-7-jingzhangos@google.com>
         <b64e5639b1b9bb5e5e4ff8eaa10554ae0d9a6016.camel@amazon.com>
         <CAAdAUtibBVuMGhh9NEOxpEyMQ6bxde674ME+hHqERoT5hctETA@mail.gmail.com>
         <7a4a7d86c851563d5ad631070611918906e92015.camel@amazon.com>
         <86bkigllzn.wl-maz@kernel.org>
In-Reply-To: <86bkigllzn.wl-maz@kernel.org>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.187.171.30]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9767FDCD2A2E045A81B050985E98CCB@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTE5IGF0IDEwOjE2ICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9yZ2Fu
aXphdGlvbi4gRG8NCj4gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBjYW4gY29uZmlybSB0aGUgc2VuZGVyDQo+IGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNh
ZmUuDQo+IA0KPiANCj4gDQo+IE9uIFRodSwgMTggTWF5IDIwMjMgMjI6MDg6MTUgKzAxMDAsDQo+
ICJKaXRpbmRhciBTaW5naCwgU3VyYWoiIDxzdXJhampzQGFtYXpvbi5jb20+IHdyb3RlOg0KPiA+
IA0KPiA+IFJlYWRpbmcgaW5pdF9jcHVfZnRyX3JlZygpIGlzIGh1cnRpbmcgbXkgaGVhZCA6cCBi
dXQgZG9uJ3Qgd2UgaGF2ZQ0KPiA+IGJhc2ljYWxseSAyIGNhc2VzIGhlcmU/DQo+ID4gDQo+ID4g
MS4gV2UgYXJlIHVuYWZmZWN0ZWQgYnkgc3BlY3RyZXxtZWx0ZG93biBpLmUuDQo+ID4gYXJtNjRf
Z2V0X1tzcGVjdHJlfG1lbHRkb3duXV92Ml9zdGF0ZSgpIHdpbGwgcmV0dXJuDQo+ID4gU1BFQ1RS
RV9VTkFGRkVDVEVEDQo+ID4gYW5kIHdlIHdpbGwgc2V0IHRoZSBsaW1pdCB0byAxIGZvciB0aGUg
Y3N2WzF8Ml0gYml0IGZpZWxkcyBpbg0KPiA+IHJlYWRfc2FuaXRpc2VkX2lkX2FhNjRwZnIwX2Vs
MSgpDQo+ID4gDQo+ID4gb3INCj4gPiANCj4gPiAyLiBXZSBBUkUgYWZmZWN0ZWQgYnkgc3BlY3Ry
ZXxtZWx0ZG93biBpbiB3aGljaCBjYXNlDQo+ID4gYXJtNjRfZ2V0X1tzcGVjdHJlfG1lbHRkb3du
XV92Ml9zdGF0ZSgpIHdpbGwgYmUNCj4gPiBTUEVDVFJFX1ZVTE5FUkFCTEV8U1BFQ1RSRV9NSVRJ
R0FURUQgaW4gd2hpY2ggY2FzZQ0KPiA+IHJlYWRfc2FuaXRpc2VkX2Z0cl9yZWcoKSB3aWxsIHJl
dHVybiBhIHZhbHVlIHdpdGggY3N2WzF8Ml0gc2V0IHRvIDANCj4gPiBlc3NlbnRpYWxseSBzZXR0
aW5nIHRoZSBsaW1pdCBmb3IgZWl0aGVyIG9mIHRoZXNlIGJpdCBmaWVsZHMgdG8gMA0KPiA+IGlu
DQo+ID4gcmVhZF9zYW5pdGlzZWRfaWRfYWE2NHBmcjBfZWwxKCkuDQo+IA0KPiBXaGF0IGlzICJX
RSI/DQoNClRoZSBDUFUNCg0KPiANCj4gPiANCj4gPiBBcmUgd2UgdHJ5aW5nIHRvIGNhdGNoIHRo
ZSBjYXNlIHdoZXJlIGNzdlsxfDJdIGlzIDAgb24gdGhlIGhvc3QgYnV0DQo+ID4gd2UNCj4gPiBh
cmUgdW5hZmZlY3RlZCBhcyBkZXRlY3RlZCBieSBlLmcuIGNwdWlkIGFuZCB0aGF0IGNwdSBoYXBw
ZW5zIHRvDQo+ID4gaW5jb3JyZWN0bHkgbm90IHNldCBjc3ZbMXwyXSBpbiB0aGUgSUQgcmVnaXN0
ZXIgYnV0IHdlIHN0aWxsIHdhbnQNCj4gPiB0bw0KPiA+IGFsbG93IHRoZSBndWVzdCB0byBzZWUg
dGhvc2UgYml0cyBhcyBzZXQ/DQo+ID4gDQo+ID4gVGhpcyBpc24ndCByZWFsbHkgcmVsYXRlZCB0
byB0aGUgQ1IgYXMgSSBrbm93IHRoaXMgaXMgZXhpc3RpbmcgY29kZQ0KPiA+IHdoaWNoIGhhcyBq
dXN0IGJlZW4gbW92ZWQgYXJvdW5kIGFuZCBzb3JyeSBpZiBJJ20gbWlzc2luZyBzb21ldGhpbmcN
Cj4gPiBvYnZpb3VzLg0KPiANCj4gVGhpcyBjb2RlIGlzIGNhbGxlZCBmcm9tICp1c2Vyc3BhY2Uq
LCBhbmQgdHJpZXMgdG8gY29wZSB3aXRoIGEgVk0NCj4gYmVpbmcgcmVzdG9yZWQuIFNvIHdlIGhh
dmUgMyAobm90IDIgY2FzZXMpOg0KPiANCj4gLSBib3RoIHRoZSBzb3VyY2UgYW5kIHRoZSBkZXN0
aW5hdGlvbiBoYXZlIHRoZSBzYW1lIGxldmVsIG9mIENTVngNCj4gwqAgc3VwcG9ydCwgYW5kIGFs
bCBpcyBncmVhdCBpbiB0aGUgd29ybGQNCj4gDQo+IC0gdGhlIHNvdXJjZSBoYXMgQ1NWeD09MCwg
d2hpbGUgdGhlIGRlc3RpbmF0aW9uIGhhcyBDU1Z4PTEuIEFsbCBnb29kLA0KPiDCoCBhcyB3ZSB3
b24ndCBiZSBseWluZyB0byB0aGUgZ3Vlc3QsIGFuZCB0aGUgZXh0cmEgbWl0aWdhdGlvbg0KPiDC
oCBleGVjdXRlZCBieSB0aGUgZ3Vlc3QgaXNuJ3QgYSBmdW5jdGlvbmFsIHByb2JsZW0uIFRoZSBn
dWVzdCB3aWxsDQo+IMKgIHN0aWxsIHNlZSBDU1Z4PTAgYWZ0ZXIgbWlncmF0aW9uLg0KPiANCj4g
LSB0aGUgc291cmNlIGhhcyBDU1Z4PTEsIHdoaWxlIHRoZSBkZXN0aW5hdGlvbiBoYXMgQ1NWeD0w
LiBUaGlzIGlzbid0DQo+IMKgIGFuIGFjY2VwdGFibGUgc2l0dWF0aW9uLCBhbmQgd2UgcmV0dXJu
IGFuIGVycm9yDQo+IA0KPiBJcyB0aGF0IGNsZWFyZXI/DQoNClllcyB0aGFua3MsIHRoYXQgYWxs
IG1ha2VzIHNlbnNlLg0KDQpNeSBpbml0aWFsIHF1ZXN0aW9uIHdhcyB3aHkgd2UgbmVlZGVkIHRv
IGVuZm9yY2UgdGhlIGxpbWl0IGVzc2VudGlhbGx5DQp0d2ljZSBpbiBzZXRfaWRfYWE2NHBmcjBf
ZWwxKCkuDQoNCk9uY2Ugd2l0aDoNCiAgICAgICAgLyogIA0KICAgICAgICAgKiBBbGxvdyBBQTY0
UEZSMF9FTDEuQ1NWMiB0byBiZSBzZXQgZnJvbSB1c2Vyc3BhY2UgYXMgbG9uZyBhcw0KICAgICAg
ICAgKiBpdCBkb2Vzbid0IHByb21pc2UgbW9yZSB0aGFuIHdoYXQgaXMgYWN0dWFsbHkgcHJvdmlk
ZWQgKHRoZQ0KICAgICAgICAgKiBndWVzdCBjb3VsZCBvdGhlcndpc2UgYmUgY292ZXJlZCBpbiBl
Y3RvcGxhc21pYyByZXNpZHVlKS4NCiAgICAgICAgICovDQogICAgICAgIGNzdjIgPSBjcHVpZF9m
ZWF0dXJlX2V4dHJhY3RfdW5zaWduZWRfZmllbGQodmFsLA0KSURfQUE2NFBGUjBfRUwxX0NTVjJf
U0hJRlQpOw0KICAgICAgICBpZiAoY3N2MiA+IDEgfHwNCiAgICAgICAgICAgIChjc3YyICYmIGFy
bTY0X2dldF9zcGVjdHJlX3YyX3N0YXRlKCkgIT0NClNQRUNUUkVfVU5BRkZFQ1RFRCkpDQogICAg
ICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQoNCiAgICAgICAgLyogU2FtZSB0aGluZyBmb3Ig
Q1NWMyAqLw0KICAgICAgICBjc3YzID0gY3B1aWRfZmVhdHVyZV9leHRyYWN0X3Vuc2lnbmVkX2Zp
ZWxkKHZhbCwNCklEX0FBNjRQRlIwX0VMMV9DU1YzX1NISUZUKTsNCiAgICAgICAgaWYgKGNzdjMg
PiAxIHx8DQogICAgICAgICAgICAoY3N2MyAmJiBhcm02NF9nZXRfbWVsdGRvd25fc3RhdGUoKSAh
PSBTUEVDVFJFX1VOQUZGRUNURUQpKQ0KICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0K
DQpBbmQgdGhlbiBhZ2FpbiB3aXRoIHRoZSBjaGVjayBpbiBhcm02NF9jaGVja19mZWF0dXJlcygp
Lg0KDQpUaGFua3MsDQpTdXJhag0KDQo+IA0KPiDCoMKgwqDCoMKgwqDCoCBNLg0KPiANCj4gLS0N
Cj4gV2l0aG91dCBkZXZpYXRpb24gZnJvbSB0aGUgbm9ybSwgcHJvZ3Jlc3MgaXMgbm90IHBvc3Np
YmxlLg0KDQo=
