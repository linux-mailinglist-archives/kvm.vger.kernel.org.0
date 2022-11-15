Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CEE629693
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbiKOLA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiKOLAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:00:16 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C141D5593;
        Tue, 15 Nov 2022 02:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1668509983; x=1700045983;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iqUkLKMWetxacvM0s/sm7PL0RcUbsTjPh/d4FqV8Klw=;
  b=YLisgLf3GHtGkLQecV1jOwwuM14EdQc/urMRMG4LWL6fnLpo/2ttPhxH
   Qicx/FihRKtWl50c6oRnzjaDLGSy1M4m1Smrx17e308yk4Nr/cFZRRs2p
   sJ+ffQdH2O0TKNhC7Y4eoBsLmwf/UnqtP9OjdiJtzonw7Nen9sfi1siuj
   g=;
X-IronPort-AV: E=Sophos;i="5.96,165,1665446400"; 
   d="scan'208";a="280055256"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 10:59:37 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com (Postfix) with ESMTPS id DBF93609AD;
        Tue, 15 Nov 2022 10:59:36 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 15 Nov 2022 10:59:30 +0000
Received: from [0.0.0.0] (10.43.162.178) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.20; Tue, 15 Nov
 2022 10:59:28 +0000
Message-ID: <3a902a4a-207a-6c5c-d2a6-61c9a5d6e1c5@amazon.de>
Date:   Tue, 15 Nov 2022 11:59:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH] KVM: x86/vmx: Do not skip segment attributes if unusable
 bit is set
Content-Language: en-US
To:     Hendrik Borghorst <hborghor@amazon.de>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20221114164823.69555-1-hborghor@amazon.de>
From:   Alexander Graf <graf@amazon.de>
In-Reply-To: <20221114164823.69555-1-hborghor@amazon.de>
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D45UWB002.ant.amazon.com (10.43.161.78) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDE0LjExLjIyIDE3OjQ4LCBIZW5kcmlrIEJvcmdob3JzdCB3cm90ZToKPiBXaGVuIHNlcmlh
bGl6aW5nIGFuZCBkZXNlcmlhbGl6aW5nIGt2bV9zcmVncywgYXR0cmlidXRlcyBvZiB0aGUgc2Vn
bWVudAo+IGRlc2NyaXB0b3JzIGFyZSBzdG9yZWQgYnkgdXNlciBzcGFjZS4gRm9yIHVudXNhYmxl
IHNlZ21lbnRzLAo+IHZteF9zZWdtZW50X2FjY2Vzc19yaWdodHMgc2tpcHMgYWxsIGF0dHJpYnV0
ZXMgYW5kIHNldHMgdGhlbSB0byAwLgo+Cj4gVGhpcyBtZWFucyB3ZSB6ZXJvIG91dCB0aGUgRFBM
IChEZXNjcmlwdG9yIFByaXZpbGVnZSBMZXZlbCkgZm9yIHVudXNhYmxlCj4gZW50cmllcy4KPgo+
IFVudXNhYmxlIHNlZ21lbnRzIGFyZSAtIGNvbnRyYXJ5IHRvIHRoZWlyIG5hbWUgLSB1c2FibGUg
aW4gNjRiaXQgbW9kZSBhbmQKPiBhcmUgdXNlZCBieSBndWVzdHMgdG8gZm9yIGV4YW1wbGUgY3Jl
YXRlIGEgbGluZWFyIG1hcCB0aHJvdWdoIHRoZQo+IE5VTEwgc2VsZWN0b3IuCj4KPiBWTUVOVEVS
IGNoZWNrcyBpZiBTUy5EUEwgaXMgY29ycmVjdCBkZXBlbmRpbmcgb24gdGhlIENTIHNlZ21lbnQg
dHlwZS4KPiBGb3IgdHlwZXMgOSAoRXhlY3V0ZSBPbmx5KSBhbmQgMTEgKEV4ZWN1dGUgUmVhZCks
IENTLkRQTCBtdXN0IGJlIGVxdWFsIHRvCj4gU1MuRFBMIFsxXS4KPgo+IFdlIGhhdmUgc2VlbiBy
ZWFsIHdvcmxkIGd1ZXN0cyBzZXR0aW5nIENTIHRvIGEgdXNhYmxlIHNlZ21lbnQgd2l0aCBEUEw9
Mwo+IGFuZCBTUyB0byBhbiB1bnVzYWJsZSBzZWdtZW50IHdpdGggRFBMPTMuIE9uY2Ugd2UgZ28g
dGhyb3VnaCBhbiBzcmVncwo+IGdldC9zZXQgY3ljbGUsIFNTLkRQTCB0dXJucyB0byAwLiBUaGlz
IGNhdXNlcyB0aGUgdmlydHVhbCBtYWNoaW5lIHRvIGNyYXNoCj4gcmVwcm9kdWNpYmx5Lgo+Cj4g
VGhpcyBjb21taXQgY2hhbmdlcyB0aGUgYXR0cmlidXRlIGxvZ2ljIHRvIGFsd2F5cyBwcmVzZXJ2
ZSBhdHRyaWJ1dGVzIGZvcgo+IHVudXNhYmxlIHNlZ21lbnRzLiBBY2NvcmRpbmcgdG8gWzJdIFNT
LkRQTCBpcyBhbHdheXMgc2F2ZWQgb24gVk0gZXhpdHMsCj4gcmVnYXJkbGVzcyBvZiB0aGUgdW51
c2FibGUgYml0IHNvIHVzZXIgc3BhY2UgYXBwbGljYXRpb25zIHNob3VsZCBoYXZlIHNhdmVkCj4g
dGhlIGluZm9ybWF0aW9uIG9uIHNlcmlhbGl6YXRpb24gY29ycmVjdGx5Lgo+Cj4gWzNdIHNwZWNp
ZmllcyB0aGF0IGJlc2lkZXMgU1MuRFBMIHRoZSByZXN0IG9mIHRoZSBhdHRyaWJ1dGVzIG9mIHRo
ZQo+IGRlc2NyaXB0b3JzIGFyZSB1bmRlZmluZWQgYWZ0ZXIgVk0gZW50cnkgaWYgdW51c2FibGUg
Yml0IGlzIHNldC4gU28sIHRoZXJlCj4gc2hvdWxkIGJlIG5vIGhhcm0gaW4gc2V0dGluZyB0aGVt
IGFsbCB0byB0aGUgcHJldmlvdXMgc3RhdGUuCj4KPiBbMV0gSW50ZWwgU0RNIFZvbCAzQyAyNi4z
LjEuMiBDaGVja3Mgb24gR3Vlc3QgU2VnbWVudCBSZWdpc3RlcnMKPiBbMl0gSW50ZWwgU0RNIFZv
bCAzQyAyNy4zLjIgU2F2aW5nIFNlZ21lbnQgUmVnaXN0ZXJzIGFuZCBEZXNjcmlwdG9yLVRhYmxl
Cj4gUmVnaXN0ZXJzCj4gWzNdIEludGVsIFNETSBWb2wgM0MgMjYuMy4yLjIgTG9hZGluZyBHdWVz
dCBTZWdtZW50IFJlZ2lzdGVycyBhbmQKPiBEZXNjcmlwdG9yLVRhYmxlIFJlZ2lzdGVycwo+Cj4g
Q2M6IEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpvbi5kZT4KPiBTaWduZWQtb2ZmLWJ5OiBIZW5k
cmlrIEJvcmdob3JzdCA8aGJvcmdob3JAYW1hem9uLmRlPgoKCkknbSBzdGlsbCBmYXNjaW5hdGVk
IGJ5IHRoZSBmYWN0IHRoYXQgInVudXNhYmxlIiBtZWFucyAiaXMgYSB2YWxpZCAKc2VnbWVudCB1
bmRlciB0aGVzZSBjb25kaXRpb25zIiA6KS4KClJldmlld2VkLWJ5OiBBbGV4YW5kZXIgR3JhZiA8
Z3JhZkBhbWF6b24uY29tPgoKQWxleAoKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2Vy
bWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6
IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNn
ZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0
LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

