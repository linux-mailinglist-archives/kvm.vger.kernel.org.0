Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C91676F1D8
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 20:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbjHCS2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 14:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjHCS2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 14:28:11 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457FA110;
        Thu,  3 Aug 2023 11:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1691087287; x=1722623287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   content-id:mime-version:content-transfer-encoding;
  bh=dU7FhD9vg9CDvnRfzIXtvR7vPuzQleLv4BUkDfepjCk=;
  b=loyjJ0Nkhbkmzv90mngg8M+qc0afK4SSmBS9xNM0G706Fz/nrhL28zVw
   HojYvmpDne89nDofr1cj08Hc3znJ0ahEmHevC/kWXl5coruod57uOGn0z
   IIpNeg726xobAK5QAC8CvMxE9Doj/UAJ2ND1sMted90/Y+XuHHXbPzPWV
   k=;
X-IronPort-AV: E=Sophos;i="6.01,252,1684800000"; 
   d="scan'208";a="350627819"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 18:28:01 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com (Postfix) with ESMTPS id 8B90F40DE0;
        Thu,  3 Aug 2023 18:27:58 +0000 (UTC)
Received: from EX19D020UWA002.ant.amazon.com (10.13.138.222) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Thu, 3 Aug 2023 18:27:58 +0000
Received: from EX19D033EUC001.ant.amazon.com (10.252.61.132) by
 EX19D020UWA002.ant.amazon.com (10.13.138.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Thu, 3 Aug 2023 18:27:57 +0000
Received: from EX19D033EUC001.ant.amazon.com ([fe80::6dc8:500e:fe63:454c]) by
 EX19D033EUC001.ant.amazon.com ([fe80::6dc8:500e:fe63:454c%3]) with mapi id
 15.02.1118.030; Thu, 3 Aug 2023 18:27:56 +0000
From:   "Schander, Johanna 'Mimoja' Amelie" <mimoja@amazon.de>
To:     "Graf (AWS), Alexander" <graf@amazon.de>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alpergun@google.com" <alpergun@google.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pgonda@google.com" <pgonda@google.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH RFC v8 00/56] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Thread-Topic: [PATCH RFC v8 00/56] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Thread-Index: AQHZxjg5EcZaH17x7USkn+te0u//TQ==
Date:   Thu, 3 Aug 2023 18:27:56 +0000
Message-ID: <f4905c32f4054d4ce254b3acb9339aa1c59728b8.camel@amazon.de>
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.82.18]
Content-Type: text/plain; charset="utf-8"
Content-ID: <21BE49845F41F240B8334E1AF103963F@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

V2UgZGlzY292ZXJlZCB0aGF0IHRoZSBrZHVtcCBjcmFzaGtlcm5lbCB3b3VsZCBub3Qgd29yayB3
aXRoIG91ciBTRVYtDQpTTlAgY29uZmlndXJhdGlvbi4NCg0KQWZ0ZXIgcmVhZGluZyB0aGUgZGV2
aWNlIHRhYmxlIGZyb20gdGhlIHByZXZpb3VyIGtlcm5lbCB3ZSB3b3VsZA0Kc2VlIGEgbG90IG9m
DQogIEFNRC1WaTogQ29tcGxldGlvbi1XYWl0IGxvb3AgdGltZWQgb3V0DQplcnJvcnMgYW5kIGZp
bmFsbHkgY3Jhc2g6DQogIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiB0aW1lciBkb2Vzbid0
IHdvcmsgdGhyb3VnaCBJbnRlcnJ1cHQtDQpyZW1hcHBlZCBJTy1BUElDDQoNCldlIGZvdW5kIHRo
YXQgZGlzYWJlbGluZyBTTlAgaW4gdGhlIG91dGdvaW5nIChjcmFzaGluZykga2VybmVsDQp3b3Vs
ZCBlbmFibGUgdGhlIGNyYXNoa2VybmVsIHRvIHRha2Ugb3ZlciB0aGUgaW9tbXUgY29uZmlnIGFu
ZA0KYm9vdCBmcm9tIHRoZXJlLg0KDQpXZSBvcGVuZWQgYSBQUiBvdmVyIG9uIGdpdGh1YiBhZ2Fp
bnN0IHRoZSByZmMtdjkgYnJhbmNoIHRvIGRpc2N1c3MNCnRoZSBpc3N1ZToNCmh0dHBzOi8vZ2l0
aHViLmNvbS9BTURFU0UvbGludXgvcHVsbC81DQoNCkNoZWVycyBKb2hhbm5hDQoNCg0KDQoNCgoK
CkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEw
MTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0
aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVy
IEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

