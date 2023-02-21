Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A9869E4A9
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 17:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbjBUQ3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 11:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbjBUQ3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 11:29:31 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D758F11661
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 08:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1676996923; x=1708532923;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=An3ZyYPjzm/F1tOVGPO3OL+S+08Pygd7okUCpWph0KM=;
  b=ktRvifHjlkmSz8i+EE5q5eCylYudUaQJcEQ/RIIGgKky/S18+I94TtXA
   t/OFMagvbVVmPiqAvyhRh3VNbVMlbK9lRcda89/+V1v9ktqI3ZEuR53Ft
   XSt/yvSaEcXajUvnrvULvGxDSpmDUzO5Yj6buy8dbtU9NpbUqJttz+jLB
   w=;
X-IronPort-AV: E=Sophos;i="5.97,315,1669075200"; 
   d="scan'208";a="299455621"
Subject: Re: [PATCH 00/16] KVM: arm64: Rework timer offsetting for fun and profit
Thread-Topic: [PATCH 00/16] KVM: arm64: Rework timer offsetting for fun and profit
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 16:28:40 +0000
Received: from EX19D018EUC004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com (Postfix) with ESMTPS id 914E4A293A;
        Tue, 21 Feb 2023 16:28:37 +0000 (UTC)
Received: from EX19D018EUC003.ant.amazon.com (10.252.51.231) by
 EX19D018EUC004.ant.amazon.com (10.252.51.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 21 Feb 2023 16:28:36 +0000
Received: from EX19D018EUC003.ant.amazon.com ([fe80::8a6b:2af5:3f32:8cfe]) by
 EX19D018EUC003.ant.amazon.com ([fe80::8a6b:2af5:3f32:8cfe%3]) with mapi id
 15.02.1118.024; Tue, 21 Feb 2023 16:28:36 +0000
From:   "Veith, Simon" <sveith@amazon.de>
To:     "maz@kernel.org" <maz@kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "ricarkol@google.com" <ricarkol@google.com>
Thread-Index: AQHZQhIhiotZ8QeTIUeBSHOWoG2ULa7ZnmqA
Date:   Tue, 21 Feb 2023 16:28:36 +0000
Message-ID: <5404a3554c3a1efd1e8e098072a4cf03d1b01152.camel@amazon.de>
References: <20230216142123.2638675-1-maz@kernel.org>
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.212.17]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B285DF88BE57D8478127CC5E2935E5BB@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGVsbG8gTWFyYywNCg0KT24gVGh1LCAyMDIzLTAyLTE2IGF0IDE0OjIxICswMDAwLCBNYXJjIFp5
bmdpZXIgd3JvdGU6DQo+IFRoaXMgc2VyaWVzIGFpbXMgYXQgc2F0aXNmeWluZyBtdWx0aXBsZSBn
b2FsczoNCj4gDQo+IC0gYWxsb3cgYSBWTU0gdG8gYXRvbWljYWxseSByZXN0b3JlIGEgdGltZXIg
b2Zmc2V0IGZvciBhIHdob2xlIFZNDQo+IMKgIGluc3RlYWQgb2YgdXBkYXRpbmcgdGhlIG9mZnNl
dCBlYWNoIHRpbWUgYSB2Y3B1IGdldCBpdHMgY291bnRlcg0KPiDCoCB3cml0dGVuDQo+IA0KPiAt
IGFsbG93IGEgVk1NIHRvIHNhdmUvcmVzdG9yZSB0aGUgcGh5c2ljYWwgdGltZXIgY29udGV4dCwg
c29tZXRoaW5nDQo+IMKgIHRoYXQgd2UgY2Fubm90IGRvIGF0IHRoZSBtb21lbnQgZHVlIHRvIHRo
ZSBsYWNrIG9mIG9mZnNldHRpbmcNCj4gDQo+IC0gcHJvdmlkZSBhIGZyYW1ld29yayB0aGF0IGlz
IHN1aXRhYmxlIGZvciBOViBzdXBwb3J0LCB3aGVyZSB3ZSBnZXQNCj4gwqAgYm90aCBnbG9iYWwg
YW5kIHBlciB0aW1lciwgcGVyIHZjcHUgb2Zmc2V0dGluZw0KDQpUaGFuayB5b3Ugc28gbXVjaCBm
b3IgZm9sbG93aW5nIHVwIG9uIG15IChhZG1pdHRlZGx5IHZlcnkgYmFzaWMpIHBhdGNoDQp3aXRo
IHlvdXIgb3duIHByb3Bvc2FsIQ0KDQo+IFRoaXMgaGFzIGJlZW4gbW9kZXJhdGVseSB0ZXN0ZWQg
d2l0aCBuVkhFLCBWSEUgYW5kIE5WLiBJIGRvIG5vdCBoYXZlDQo+IGFjY2VzcyB0byBDTlRQT0ZG
LWF3YXJlIEhXLCBzbyB0aGUganVyeSBpcyBzdGlsbCBvdXQgb24gdGhhdCBvbmUNCg0KU2FtZSBo
ZXJlIGFib3V0IENOVFBPRkYgLS0gSSBnYXZlIGl0IGEgcXVpY2sgc3BpbiBvbiBHcmF2aXRvbjIg
YW5kDQpHcmF2aXRvbjMsIGFuZCBuZWl0aGVyIGNoaXAgY2xhaW1zIHRoZSBBUk02NF9IQVNfRUNW
X0NOVFBPRkYgY2FwYWJpbGl0eQ0KZnJvbSB5b3VyIHBhdGNoLg0KDQpJIGFtIHdvcmtpbmcgb24g
dGVzdGluZyB5b3VyIHNlcmllcyB3aXRoIG91ciB1c2Vyc3BhY2UgYW5kIHdpbGwgcmVwb3J0DQpi
YWNrLg0KDQpUaGFua3MNClNpbW9uDQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1h
bnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBD
aHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2Vy
aWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1J
RDogREUgMjg5IDIzNyA4NzkKCgo=

