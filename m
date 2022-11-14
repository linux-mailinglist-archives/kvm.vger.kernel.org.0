Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA48627C48
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 12:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbiKNL2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 06:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236480AbiKNL2e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 06:28:34 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C7C1B8;
        Mon, 14 Nov 2022 03:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1668425271; x=1699961271;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=EKaNBkM/mr4z1EzacJF1XB0oHO557xsn5TcBYFdi/cY=;
  b=J7CD9pPeMNPRUv/L2kDen8RLywT1wLrZ0W6eyEgextyq5wI+Qdo1pXEK
   o5LRauayfMCk/cqrAQImHOPOrKdLGr/WzNloatHXKFNUhxrL2L+Cf2Tsg
   oHjqF5eSInwWZlDmhFGsyNgwwb8hI1pgZot0njq0nKJSEd7ZSTRVJVpOV
   o=;
X-IronPort-AV: E=Sophos;i="5.96,161,1665446400"; 
   d="scan'208";a="266316986"
Subject: RE: [PATCH 03/16] KVM: x86: set gfn-to-pfn cache length consistently with VM
 word size
Thread-Topic: [PATCH 03/16] KVM: x86: set gfn-to-pfn cache length consistently with VM
 word size
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 11:27:48 +0000
Received: from EX13D44EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com (Postfix) with ESMTPS id C058941771;
        Mon, 14 Nov 2022 11:27:45 +0000 (UTC)
Received: from EX19D043EUC003.ant.amazon.com (10.252.61.176) by
 EX13D44EUC001.ant.amazon.com (10.43.164.236) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 14 Nov 2022 11:27:44 +0000
Received: from EX19D032EUC002.ant.amazon.com (10.252.61.185) by
 EX19D043EUC003.ant.amazon.com (10.252.61.176) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.20; Mon, 14 Nov 2022 11:27:44 +0000
Received: from EX19D032EUC002.ant.amazon.com ([fe80::e696:121c:a227:174]) by
 EX19D032EUC002.ant.amazon.com ([fe80::e696:121c:a227:174%3]) with mapi id
 15.02.1118.020; Mon, 14 Nov 2022 11:27:44 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mhal@rbox.co" <mhal@rbox.co>,
        "Kaya, Metin" <metikaya@amazon.co.uk>
Thread-Index: AQHY92SFmObiXdVPIUW/qubrVXRQSK482zAAgAFtZ4A=
Date:   Mon, 14 Nov 2022 11:27:44 +0000
Message-ID: <000fac2ae9394da6b51c2138c5816a45@amazon.co.uk>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
         <20221027161849.2989332-4-pbonzini@redhat.com>
         <Y1q+a3gtABqJPmmr@google.com>
         <c61f6089-57b7-e00f-d5ed-68e62237eab0@redhat.com>
         <c30b46557c9c59b9f4c8c3a2139bd506a81f7ee1.camel@infradead.org>
 <89ea0f72514d93967b679a01960d05b34a90ea14.camel@infradead.org>
In-Reply-To: <89ea0f72514d93967b679a01960d05b34a90ea14.camel@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.82.12]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBXb29kaG91c2UgPGR3
bXcyQGluZnJhZGVhZC5vcmc+DQo+IFNlbnQ6IDEzIE5vdmVtYmVyIDIwMjIgMTM6MzcNCj4gVG86
IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+OyBTZWFuIENocmlzdG9waGVyc29u
DQo+IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IG1oYWxAcmJveC5jbzsNCj4gRHVycmFudCwgUGF1bCA8
cGR1cnJhbnRAYW1hem9uLmNvLnVrPjsgS2F5YSwgTWV0aW4gPG1ldGlrYXlhQGFtYXpvbi5jby51
az4NCj4gU3ViamVjdDogUkU6IFtFWFRFUk5BTF1bUEFUQ0ggMDMvMTZdIEtWTTogeDg2OiBzZXQg
Z2ZuLXRvLXBmbiBjYWNoZSBsZW5ndGgNCj4gY29uc2lzdGVudGx5IHdpdGggVk0gd29yZCBzaXpl
DQo+IA0KPiBPbiBTdW4sIDIwMjItMTEtMTMgYXQgMTM6MzIgKzAwMDAsIERhdmlkIFdvb2Rob3Vz
ZSB3cm90ZToNCj4gPiBGb3IgdGhlIHJ1bnN0YXRlIGFyZWEsIEkgdGhpbmsgd2UgY2FuIGxpdmUg
d2l0aCB1c2luZyBhIGdmbl90b19odmENCj4gPiBjYWNoZSBpbnN0ZWFkLCBhbmQgd3JpdGluZyB2
aWEgdGhlIHVzZXJzcGFjZSBhZGRyZXNzICh3aXRoIGFwcHJvcHJpYXRlDQo+ID4gYXRvbWljaXR5
IGZvciB0aGUgUlVOU1RBVEVfcnVubmFibGUgY2FzZSBhcyB3ZSBoYXZlIGF0IHRoZSBtb21lbnQN
Cj4gPiBnYXRpbmcgdGhlIHJlZnJlc2gpLg0KPiANCj4gV2hpY2ggbW9zdGx5IGludm9sdmVzIGp1
c3QgcmV2ZXJ0aW5nIGNvbW1pdCBhNzk1Y2Q0M2M1YjUgSSB0aGluaz8NCj4gDQo+IElJUkMgdGhl
IHJlYXNvbiBmb3IgdGhhdCBjb21taXQgd2FzIG1vc3RseSBjb25zaXN0ZW5jeSB3aXRoIG90aGVy
DQo+IHRoaW5ncyB0aGF0IHJlYWxseSAqZGlkKiB3YW50IHRvIGJlIHN3aXRjaGVkIHRvIGdwYy4N
Cg0KQSBzdHJhaWdodCByZXZlcnNpb24gd291bGQgcmUtaW50cm9kdWNlIHRoZSBwYWdlLXNwYW5u
aW5nIGNoZWNrIGluIGt2bV94ZW5fdmNwdV9zZXRfYXR0cigpIGJ1dCBJIHRoaW5rIHdlIGNhbiBq
dXN0IGxlYXZlIHRoYXQgb3V0Lg0KDQogIFBhdWwNCg==
