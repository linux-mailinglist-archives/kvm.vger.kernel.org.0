Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34592630E7D
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 12:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiKSLkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 06:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiKSLkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 06:40:16 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B975B86D
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 03:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1668858014; x=1700394014;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=hXyayVo5HH4IzLfQ/wSFlZTu3kqsv9FQxeKqm28QxTA=;
  b=CB76OlolmPAsRKijKT6eOrrT/bU5yIwOtRctjjyUFiWGExvH4KEr44kx
   nKhqxtdy46iGaKkj9KLLEMgAerlYdeqcxtNuSZHQVl9ctofbgyNKqc6Xd
   oWqeQHVgC7CUItUL4+T42l3UuPy5zZXj6Y38MYINsjw8cIxQATIb1VM3G
   c=;
X-IronPort-AV: E=Sophos;i="5.96,176,1665446400"; 
   d="scan'208";a="268517093"
Subject: RE: [PATCH 3/4] KVM: Update gfn_to_pfn_cache khva when it moves within the
 same page
Thread-Topic: [PATCH 3/4] KVM: Update gfn_to_pfn_cache khva when it moves within the same
 page
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2022 11:40:10 +0000
Received: from EX13D41EUC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com (Postfix) with ESMTPS id 068714191C;
        Sat, 19 Nov 2022 11:40:10 +0000 (UTC)
Received: from EX19D032EUC001.ant.amazon.com (10.252.61.222) by
 EX13D41EUC002.ant.amazon.com (10.43.164.230) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sat, 19 Nov 2022 11:40:09 +0000
Received: from EX19D032EUC002.ant.amazon.com (10.252.61.185) by
 EX19D032EUC001.ant.amazon.com (10.252.61.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.20; Sat, 19 Nov 2022 11:40:09 +0000
Received: from EX19D032EUC002.ant.amazon.com ([fe80::e696:121c:a227:174]) by
 EX19D032EUC002.ant.amazon.com ([fe80::e696:121c:a227:174%3]) with mapi id
 15.02.1118.020; Sat, 19 Nov 2022 11:40:09 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mhal@rbox.co" <mhal@rbox.co>
Thread-Index: AQHY+/v4LNSX1SK8G0CP0NFHKXkva65GHyeQ
Date:   Sat, 19 Nov 2022 11:40:09 +0000
Message-ID: <681cf1b4edf04563bba651efb854e77f@amazon.co.uk>
References: <20221119094659.11868-1-dwmw2@infradead.org>
 <20221119094659.11868-3-dwmw2@infradead.org>
In-Reply-To: <20221119094659.11868-3-dwmw2@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.51.69]
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
bXcyQGluZnJhZGVhZC5vcmc+DQo+IFNlbnQ6IDE5IE5vdmVtYmVyIDIwMjIgMDk6NDcNCj4gVG86
IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+OyBTZWFuIENocmlzdG9waGVyc29u
DQo+IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gQ2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IG1oYWxA
cmJveC5jbw0KPiBTdWJqZWN0OiBbRVhURVJOQUxdIFtQQVRDSCAzLzRdIEtWTTogVXBkYXRlIGdm
bl90b19wZm5fY2FjaGUga2h2YSB3aGVuIGl0DQo+IG1vdmVzIHdpdGhpbiB0aGUgc2FtZSBwYWdl
DQo+IA0KPiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRo
ZSBvcmdhbml6YXRpb24uIERvIG5vdA0KPiBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdw0KPiB0aGUgY29udGVu
dCBpcyBzYWZlLg0KPiANCj4gDQo+IA0KPiBGcm9tOiBEYXZpZCBXb29kaG91c2UgPGR3bXdAYW1h
em9uLmNvLnVrPg0KPiANCj4gSW4gdGhlIGNhc2Ugd2hlcmUgYSBHUEMgaXMgcmVmcmVzaGVkIHRv
IGEgZGlmZmVyZW50IGxvY2F0aW9uIHdpdGhpbiB0aGUNCj4gc2FtZSBwYWdlLCB3ZSBkaWRuJ3Qg
Ym90aGVyIHRvIHVwZGF0ZSBpdC4gTW9zdGx5IHdlIGRvbid0IG5lZWQgdG8sIGJ1dA0KPiBzaW5j
ZSB0aGUgLT5raHZhIGZpZWxkIGFsc28gaW5jbHVkZXMgdGhlIG9mZnNldCB3aXRoaW4gdGhlIHBh
Z2UsIHRoYXQgZG9lcw0KPiBoYXZlIHRvIGJlIHVwZGF0ZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBEYXZpZCBXb29kaG91c2UgPGR3bXdAYW1hem9uLmNvLnVrPg0KDQpSZXZpZXdlZC1ieTogPHBh
dWxAeGVuLm9yZz4NCg==
