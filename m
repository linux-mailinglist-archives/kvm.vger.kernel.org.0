Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0EBB5A8BD4
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 05:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbiIADM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 23:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIADMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 23:12:24 -0400
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65315E0FCF;
        Wed, 31 Aug 2022 20:12:23 -0700 (PDT)
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: RE: [PATCH 05/19] KVM: SVM: Compute dest based on sender's x2APIC
 status for AVIC kick
Thread-Topic: [PATCH 05/19] KVM: SVM: Compute dest based on sender's x2APIC
 status for AVIC kick
Thread-Index: AQHYvNGMxhPiKGt0AESRHXzY/kqZ3K3J4aVQ
Date:   Thu, 1 Sep 2022 02:56:42 +0000
Message-ID: <0e8caaf698e048a295be68530d15dcfd@baidu.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-6-seanjc@google.com>
In-Reply-To: <20220831003506.4117148-6-seanjc@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.28]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.56
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBBdWd1c3QgMzEsIDIwMjIg
ODozNSBBTQ0KPiBUbzogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+OyBQ
YW9sbyBCb256aW5pDQo+IDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBDYzoga3ZtQHZnZXIua2Vy
bmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgU3VyYXZlZSBTdXRoaWt1bHBh
bml0DQo+IDxzdXJhdmVlLnN1dGhpa3VscGFuaXRAYW1kLmNvbT47IE1heGltIExldml0c2t5IDxt
bGV2aXRza0ByZWRoYXQuY29tPjsNCj4gTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29t
Pg0KPiBTdWJqZWN0OiBbUEFUQ0ggMDUvMTldIEtWTTogU1ZNOiBDb21wdXRlIGRlc3QgYmFzZWQg
b24gc2VuZGVyJ3MgeDJBUElDDQo+IHN0YXR1cyBmb3IgQVZJQyBraWNrDQo+IA0KPiBDb21wdXRl
IHRoZSBkZXN0aW5hdGlvbiBmcm9tIElDUkggdXNpbmcgdGhlIHNlbmRlcidzIHgyQVBJQyBzdGF0
dXMsIG5vdCBlYWNoDQo+IChwb3RlbnRpYWwpIHRhcmdldCdzIHgyQVBJQyBzdGF0dXMuDQo+IA0K
PiBGaXhlczogYzUxNGQzYTM0OGFjICgiS1ZNOiBTVk06IFVwZGF0ZSBhdmljX2tpY2tfdGFyZ2V0
X3ZjcHVzIHRvIHN1cHBvcnQNCj4gMzItYml0IEFQSUMgSUQiKQ0KPiBDYzogTGkgUm9uZ1Fpbmcg
PGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVy
c29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vc3ZtL2F2aWMu
YyB8IDggKy0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgNyBkZWxl
dGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtL2F2aWMuYyBiL2Fy
Y2gveDg2L2t2bS9zdm0vYXZpYy5jIGluZGV4DQo+IGI1OWY4ZWUyNjcxZi4uM2FjZTBmMmY1MmYw
IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtL2F2aWMuYw0KPiArKysgYi9hcmNoL3g4
Ni9rdm0vc3ZtL2F2aWMuYw0KPiBAQCAtNDQxLDYgKzQ0MSw3IEBAIHN0YXRpYyBpbnQgYXZpY19r
aWNrX3RhcmdldF92Y3B1c19mYXN0KHN0cnVjdCBrdm0gKmt2bSwNCj4gc3RydWN0IGt2bV9sYXBp
YyAqc291cmNlICBzdGF0aWMgdm9pZCBhdmljX2tpY2tfdGFyZ2V0X3ZjcHVzKHN0cnVjdCBrdm0g
Kmt2bSwNCj4gc3RydWN0IGt2bV9sYXBpYyAqc291cmNlLA0KPiAgCQkJCSAgIHUzMiBpY3JsLCB1
MzIgaWNyaCwgdTMyIGluZGV4KQ0KPiAgew0KPiArCXUzMiBkZXN0ID0gYXBpY194MmFwaWNfbW9k
ZShzb3VyY2UpID8gaWNyaCA6DQo+ICtHRVRfWEFQSUNfREVTVF9GSUVMRChpY3JoKTsNCj4gIAl1
bnNpZ25lZCBsb25nIGk7DQo+ICAJc3RydWN0IGt2bV92Y3B1ICp2Y3B1Ow0KPiANCj4gQEAgLTQ1
NiwxMyArNDU3LDYgQEAgc3RhdGljIHZvaWQgYXZpY19raWNrX3RhcmdldF92Y3B1cyhzdHJ1Y3Qg
a3ZtICprdm0sDQo+IHN0cnVjdCBrdm1fbGFwaWMgKnNvdXJjZSwNCj4gIAkgKiBzaW5jZSBlbnRl
cmVkIHRoZSBndWVzdCB3aWxsIGhhdmUgcHJvY2Vzc2VkIHBlbmRpbmcgSVJRcyBhdCBWTVJVTi4N
Cj4gIAkgKi8NCj4gIAlrdm1fZm9yX2VhY2hfdmNwdShpLCB2Y3B1LCBrdm0pIHsNCj4gLQkJdTMy
IGRlc3Q7DQo+IC0NCj4gLQkJaWYgKGFwaWNfeDJhcGljX21vZGUodmNwdS0+YXJjaC5hcGljKSkN
Cj4gLQkJCWRlc3QgPSBpY3JoOw0KPiAtCQllbHNlDQo+IC0JCQlkZXN0ID0gR0VUX1hBUElDX0RF
U1RfRklFTEQoaWNyaCk7DQo+IC0NCj4gIAkJaWYgKGt2bV9hcGljX21hdGNoX2Rlc3QodmNwdSwg
c291cmNlLCBpY3JsICYgQVBJQ19TSE9SVF9NQVNLLA0KPiAgCQkJCQlkZXN0LCBpY3JsICYgQVBJ
Q19ERVNUX01BU0spKSB7DQo+ICAJCQl2Y3B1LT5hcmNoLmFwaWMtPmlycl9wZW5kaW5nID0gdHJ1
ZTsNCj4gLS0NCj4gMi4zNy4yLjY3Mi5nOTQ3NjlkMDZmMC1nb29nDQoNClJldmlld2VkLWJ5OiBM
aSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQoNClRoYW5rcy4NCg0KLUxpDQo=
