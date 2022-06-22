Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7A9554CE2
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 16:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbiFVOZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 10:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358527AbiFVOY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 10:24:56 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27F2369C8;
        Wed, 22 Jun 2022 07:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1655907893; x=1687443893;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=51C7STjo9soGVumHM19bbsfNeQcBRA/3OS6i/6pYTtM=;
  b=Rwqzv0KEdznzNHrGlPBYxXT1HRP3Q/4v3mm5pEAAQ6kLkivu1aYOIG2s
   DQiuPzaGSfOF1dyfssAgX1oajKjhZ/uezIqoUvDB4Tbs/QXeEz80AVk3C
   P16T0qJ0x01a/FRI6cAA1lUht9Y2zw9OpOHlE6WbdabbNJkf+vpxP7AZw
   8=;
X-IronPort-AV: E=Sophos;i="5.92,212,1650931200"; 
   d="scan'208";a="100777950"
Subject: RE: [PATCH v2] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Thread-Topic: [PATCH v2] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 22 Jun 2022 14:22:10 +0000
Received: from EX13D32EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com (Postfix) with ESMTPS id DBFA6817BA;
        Wed, 22 Jun 2022 14:22:09 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC003.ant.amazon.com (10.43.164.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 22 Jun 2022 14:22:08 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.036;
 Wed, 22 Jun 2022 14:22:08 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     David Woodhouse <dwmw2@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Thread-Index: AQHYhh7hXAu4qxBonEWdTaRZ6uuulK1bcRwAgAAFCdA=
Date:   Wed, 22 Jun 2022 14:22:07 +0000
Message-ID: <2d939a362e384a28bcd576b4c21a0376@EX13D32EUC003.ant.amazon.com>
References: <20220622095750.30563-1-pdurrant@amazon.com>
 <0b4c451c6967ffb7bd20b6e5bf7812628aa173c5.camel@infradead.org>
In-Reply-To: <0b4c451c6967ffb7bd20b6e5bf7812628aa173c5.camel@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.13]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-12.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBXb29kaG91c2UgPGR3
bXcyQGluZnJhZGVhZC5vcmc+DQo+IFNlbnQ6IDIyIEp1bmUgMjAyMiAxNDo0OA0KPiBUbzogRHVy
cmFudCwgUGF1bCA8cGR1cnJhbnRAYW1hem9uLmNvLnVrPjsgeDg2QGtlcm5lbC5vcmc7IGt2bUB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IENjOiBQ
YW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPjsgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+OyBWaXRhbHkgS3V6bmV0c292DQo+IDx2a3V6bmV0c0ByZWRoYXQu
Y29tPjsgV2FucGVuZyBMaSA8d2FucGVuZ2xpQHRlbmNlbnQuY29tPjsgSmltIE1hdHRzb24gPGpt
YXR0c29uQGdvb2dsZS5jb20+OyBKb2VyZw0KPiBSb2VkZWwgPGpvcm9AOGJ5dGVzLm9yZz47IFRo
b21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPjsgSW5nbyBNb2xuYXIgPG1pbmdvQHJl
ZGhhdC5jb20+Ow0KPiBCb3Jpc2xhdiBQZXRrb3YgPGJwQGFsaWVuOC5kZT47IERhdmUgSGFuc2Vu
IDxkYXZlLmhhbnNlbkBsaW51eC5pbnRlbC5jb20+OyBILiBQZXRlciBBbnZpbg0KPiA8aHBhQHp5
dG9yLmNvbT4NCj4gU3ViamVjdDogUkU6IFtFWFRFUk5BTF1bUEFUQ0ggdjJdIEtWTTogeDg2L3hl
bjogVXBkYXRlIFhlbiBDUFVJRCBMZWFmIDQgKHRzYyBpbmZvKSBzdWItbGVhdmVzLCBpZg0KPiBw
cmVzZW50DQo+IA0KPiBPbiBXZWQsIDIwMjItMDYtMjIgYXQgMTA6NTcgKzAxMDAsIFBhdWwgRHVy
cmFudCB3cm90ZToNCj4gPiArdm9pZCBrdm1feGVuX3NldF9jcHVpZChzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUpDQo+ID4gK3sNCj4gPiArCXUzMiBiYXNlID0gMDsNCj4gPiArCXUzMiBmdW5jdGlvbjsN
Cj4gPiArDQo+ID4gKwl2Y3B1LT5hcmNoLnhlbi50c2NfaW5mb18xID0gTlVMTDsNCj4gPiArCXZj
cHUtPmFyY2gueGVuLnRzY19pbmZvXzIgPSBOVUxMOw0KPiA+ICsNCj4gPiArCWZvcl9lYWNoX3Bv
c3NpYmxlX2h5cGVydmlzb3JfY3B1aWRfYmFzZShmdW5jdGlvbikgew0KPiA+ICsJCXN0cnVjdCBr
dm1fY3B1aWRfZW50cnkyICplbnRyeSA9IGt2bV9maW5kX2NwdWlkX2VudHJ5KHZjcHUsIGZ1bmN0
aW9uLCAwKTsNCj4gPiArDQo+ID4gKwkJaWYgKGVudHJ5ICYmDQo+ID4gKwkJICAgIGVudHJ5LT5l
YnggPT0gWEVOX0NQVUlEX1NJR05BVFVSRV9FQlggJiYNCj4gPiArCQkgICAgZW50cnktPmVjeCA9
PSBYRU5fQ1BVSURfU0lHTkFUVVJFX0VDWCAmJg0KPiA+ICsJCSAgICBlbnRyeS0+ZWR4ID09IFhF
Tl9DUFVJRF9TSUdOQVRVUkVfRURYKSB7DQo+ID4gKwkJCWJhc2UgPSBmdW5jdGlvbjsNCj4gPiAr
CQkJYnJlYWs7DQo+ID4gKwkJfQ0KPiA+ICsJfQ0KPiANCj4gUGxlYXNlIG1ha2UgaXQgcmV0dXJu
IGlmIGVudHJ5LT5lYXggPCAzIGhlcmUuIFRoZXJlIHByb2JhYmx5IGFyZW4ndCBhbnkNCj4gKmdv
b2QqIHJlYXNvbnMgd2h5IGEgbGVhZiBhdCAweDQwMDAweDAzIHdvdWxkIGV4aXN0IGFuZCBiZWxv
bmcgdG8gc29tZQ0KPiBvdGhlciBlbnRpdHkgKEh5cGVyLVYsIGV0Yy4pLiBUaG9zZSBvdGhlciBl
eHRyYSByYW5nZXMgb2YgQ1BVSUQgYXJlDQo+IGdlbmVyYWxseSBhbGlnbmVkIGF0IG11bHRpcGxl
cyBvZiAweDEwMCwgbm90IGp1c3QgdGhlICpuZXh0KiBhdmFpbGFibGUNCj4gbGVhZi4NCj4gDQo+
IEJ1dCBJIGRvbid0IGNhcmUuIFVubGVzcyBlYXggb24gdGhlIG1haW4gWGVuIGxlYWYgaXMgMyBv
ciBtb3JlLCB0aGUNCj4gbGVhZiBhdCBOKzMgaXNuJ3QgeW91cnMgdG8gcmVhc29uIGFib3V0IDop
DQo+IA0KDQpBY2NvcmRpbmcgdG8gaHR0cHM6Ly9sd24ubmV0L0FydGljbGVzLzMwMTg4OCAod2hp
Y2ggaXMgYW5jaWVudCksIHRoZSBNaWNyb3NvZnQgVExGUyBhbmQgbXkgY29weSBvZiB0aGUgWGVu
IHNvdXJjZSBjb2RlLCBpdCBzZWVtcyBldmVyeW9uZSBkb2VzIGFncmVlIHRoYXQgdGhlIGh5cGVy
dmlzb3IgYmFzZSBsZWFmIEVBWCBkb2VzIHNwZWNpZnkgdGhlIG1heGltdW0gbGVhZiAoaW4gYWJz
b2x1dGUgdGVybXMgcmF0aGVyIHRoYW4gdGhlIG9mZnNldCkgc28gSSdsbCBhZGQgdGhhdCBjaGVj
ayBpbnRvIHYzLg0KDQogIFBhdWwNCg0KPiA+ICsJaWYgKCFiYXNlKQ0KPiA+ICsJCXJldHVybjsN
Cj4gPiArDQo+ID4gKwlmdW5jdGlvbiA9IGJhc2UgfCBYRU5fQ1BVSURfTEVBRigzKTsNCj4gPiAr
CXZjcHUtPmFyY2gueGVuLnRzY19pbmZvXzEgPSBrdm1fZmluZF9jcHVpZF9lbnRyeSh2Y3B1LCBm
dW5jdGlvbiwgMSk7DQo+ID4gKwl2Y3B1LT5hcmNoLnhlbi50c2NfaW5mb18yID0ga3ZtX2ZpbmRf
Y3B1aWRfZW50cnkodmNwdSwgZnVuY3Rpb24sIDIpOw0KPiA+ICt9DQo+ID4gKw0K
