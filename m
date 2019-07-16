Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863BA6AB43
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 17:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387966AbfGPPCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 11:02:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:21257 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbfGPPCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 11:02:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 08:02:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,498,1557212400"; 
   d="scan'208";a="172567023"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga006.jf.intel.com with ESMTP; 16 Jul 2019 08:02:15 -0700
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 16 Jul 2019 08:01:55 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 FMSMSX154.amr.corp.intel.com (10.18.116.70) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 16 Jul 2019 08:01:54 -0700
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.3]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.162]) with mapi id 14.03.0439.000;
 Tue, 16 Jul 2019 23:01:53 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
CC:     "nitesh@redhat.com" <nitesh@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "yang.zhang.wz@gmail.com" <yang.zhang.wz@gmail.com>,
        "pagupta@redhat.com" <pagupta@redhat.com>,
        "riel@surriel.com" <riel@surriel.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "lcapitulino@redhat.com" <lcapitulino@redhat.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>
Subject: RE: [PATCH v1 6/6] virtio-balloon: Add support for aerating memory
 via hinting
Thread-Topic: [PATCH v1 6/6] virtio-balloon: Add support for aerating memory
 via hinting
Thread-Index: AQHVJu8N4NsmOWYgsECNUD5FmiWYMqbMpTqAgABEaICAAANlAIAAB/cAgACHiYA=
Date:   Tue, 16 Jul 2019 15:01:52 +0000
Message-ID: <286AC319A985734F985F78AFA26841F73E16AB21@shsmsx102.ccr.corp.intel.com>
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
 <20190619223338.1231.52537.stgit@localhost.localdomain>
 <20190716055017-mutt-send-email-mst@kernel.org>
 <cad839c0-bbe6-b065-ac32-f32c117cf07e@intel.com>
 <3f8b2a76-b2ce-fb73-13d4-22a33fc1eb17@redhat.com>
 <bdb9564d-640d-138f-6695-3fa2c084fcc7@intel.com>
In-Reply-To: <bdb9564d-640d-138f-6695-3fa2c084fcc7@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNWRjOTlkMGQtNWY3NS00ZmFiLTg2MmQtYzE4NGNjZTcxNDA5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRFBDUXE2ZGhIUmg3UlwvaHNkeGxlVmVnR3BJSmF3SG05WkNCMlwvemR2R2ZEcEJHdmY0RjdIOGpCM3NWRTRGKzMzIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlc2RheSwgSnVseSAxNiwgMjAxOSAxMDo0MSBQTSwgSGFuc2VuLCBEYXZlIHdyb3RlOg0K
PiBXaGVyZSBpcyB0aGUgcGFnZSBhbGxvY2F0b3IgaW50ZWdyYXRpb24/ICBUaGUgc2V0IHlvdSBs
aW5rZWQgdG8gaGFzIDUgcGF0Y2hlcywNCj4gYnV0IG9ubHkgNCB3ZXJlIG1lcmdlZC4gIFRoaXMg
b25lIGlzIG1pc3Npbmc6DQo+IA0KPiAJaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcGF0Y2h3b3Jr
L3BhdGNoLzk2MTAzOC8NCg0KRm9yIHNvbWUgcmVhc29uLCB3ZSB1c2VkIHRoZSByZWd1bGFyIHBh
Z2UgYWxsb2NhdGlvbiB0byBnZXQgcGFnZXMNCmZyb20gdGhlIGZyZWUgbGlzdCBhdCB0aGF0IHN0
YWdlLiBUaGlzIHBhcnQgY291bGQgYmUgaW1wcm92ZWQgYnkgQWxleA0Kb3IgTml0ZXNoJ3MgYXBw
cm9hY2guDQoNClRoZSBwYWdlIGFkZHJlc3MgdHJhbnNtaXNzaW9uIGZyb20gdGhlIGJhbGxvb24g
ZHJpdmVyIHRvIHRoZSBob3N0DQpkZXZpY2UgY291bGQgcmV1c2Ugd2hhdCdzIHVwc3RyZWFtZWQg
dGhlcmUuIEkgdGhpbmsgeW91IGNvdWxkIGFkZCBhDQpuZXcgVklSVElPX0JBTExPT05fQ01EX3h4
IGZvciB5b3VyIHVzYWdlcy4NCg0KQmVzdCwNCldlaQ0K
