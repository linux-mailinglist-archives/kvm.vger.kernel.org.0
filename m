Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C4C686CBD
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 18:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjBARVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 12:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbjBARU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 12:20:58 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C222E5CE7A;
        Wed,  1 Feb 2023 09:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675272050; x=1706808050;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r3+1R9eof3Rid7BA198DtwB/M24a62e7cpNgDf7b0qU=;
  b=JIOPno+w/v8pOcLUIJDJpYyQPQZIWqPRJZuo+45vBMBh3r/HeD+LokR1
   dvESIXPJNWtDout1fdgG2sh7Z69xFC6aXCt5QzwGVu4iOnvxB91ETBT0Y
   bGzNZ9pB+pqJzoz4px9U+kFQzzObyAIcq0CugNk8M9XIKvFGcydBAyc7A
   o=;
X-IronPort-AV: E=Sophos;i="5.97,263,1669075200"; 
   d="scan'208";a="292542619"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 17:20:47 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id 748DBC1D54;
        Wed,  1 Feb 2023 17:20:36 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Wed, 1 Feb 2023 17:20:34 +0000
Received: from [0.0.0.0] (10.43.160.120) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.24; Wed, 1 Feb
 2023 17:20:26 +0000
Message-ID: <7e73cb2d-5046-66cd-5a9b-8e2faa8458dc@amazon.com>
Date:   Wed, 1 Feb 2023 18:20:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH RFC v7 16/64] x86/sev: Add helper functions for RMPUPDATE
 and PSMASH instruction
Content-Language: en-US
To:     "Kalra, Ashish" <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <harald@profian.com>, Brijesh Singh <brijesh.singh@amd.com>,
        "Rapan, Sabin" <sabrapan@amazon.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-17-michael.roth@amd.com>
 <854a0caf-6940-8381-1e20-0ddb5ed94858@amazon.com>
 <59dd6291-6a99-ab7a-865f-b333a5f57bb9@amd.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <59dd6291-6a99-ab7a-865f-b333a5f57bb9@amd.com>
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D44UWB002.ant.amazon.com (10.43.161.192) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDAxLjAyLjIzIDE4OjE0LCBLYWxyYSwgQXNoaXNoIHdyb3RlOgo+Cj4gT24gMS8zMS8yMDIz
IDM6MjYgUE0sIEFsZXhhbmRlciBHcmFmIHdyb3RlOgo+Pgo+PiBPbiAxNC4xMi4yMiAyMDo0MCwg
TWljaGFlbCBSb3RoIHdyb3RlOgo+Pj4gRnJvbTogQnJpamVzaCBTaW5naCA8YnJpamVzaC5zaW5n
aEBhbWQuY29tPgo+Pj4KPj4+IFRoZSBSTVBVUERBVEUgaW5zdHJ1Y3Rpb24gd3JpdGVzIGEgbmV3
IFJNUCBlbnRyeSBpbiB0aGUgUk1QIFRhYmxlLiBUaGUKPj4+IGh5cGVydmlzb3Igd2lsbCB1c2Ug
dGhlIGluc3RydWN0aW9uIHRvIGFkZCBwYWdlcyB0byB0aGUgUk1QIHRhYmxlLiBTZWUKPj4+IEFQ
TTMgZm9yIGRldGFpbHMgb24gdGhlIGluc3RydWN0aW9uIG9wZXJhdGlvbnMuCj4+Pgo+Pj4gVGhl
IFBTTUFTSCBpbnN0cnVjdGlvbiBleHBhbmRzIGEgMk1CIFJNUCBlbnRyeSBpbnRvIGEgY29ycmVz
cG9uZGluZyBzZXQKPj4+IG9mIGNvbnRpZ3VvdXMgNEtCLVBhZ2UgUk1QIGVudHJpZXMuIFRoZSBo
eXBlcnZpc29yIHdpbGwgdXNlIHRoaXMKPj4+IGluc3RydWN0aW9uIHRvIGFkanVzdCB0aGUgUk1Q
IGVudHJ5IHdpdGhvdXQgaW52YWxpZGF0aW5nIHRoZSBwcmV2aW91cwo+Pj4gUk1QIGVudHJ5Lgo+
Pj4KPj4+IEFkZCB0aGUgZm9sbG93aW5nIGV4dGVybmFsIGludGVyZmFjZSBBUEkgZnVuY3Rpb25z
Ogo+Pj4KPj4+IGludCBwc21hc2godTY0IHBmbik7Cj4+PiBwc21hc2ggaXMgdXNlZCB0byBzbWFz
aCBhIDJNQiBhbGlnbmVkIHBhZ2UgaW50byA0Swo+Pj4gcGFnZXMgd2hpbGUgcHJlc2VydmluZyB0
aGUgVmFsaWRhdGVkIGJpdCBpbiB0aGUgUk1QLgo+Pj4KPj4+IGludCBybXBfbWFrZV9wcml2YXRl
KHU2NCBwZm4sIHU2NCBncGEsIGVudW0gcGdfbGV2ZWwgbGV2ZWwsIGludCBhc2lkLAo+Pj4gYm9v
bCBpbW11dGFibGUpOwo+Pj4gVXNlZCB0byBhc3NpZ24gYSBwYWdlIHRvIGd1ZXN0IHVzaW5nIHRo
ZSBSTVBVUERBVEUgaW5zdHJ1Y3Rpb24uCj4+Pgo+Pj4gaW50IHJtcF9tYWtlX3NoYXJlZCh1NjQg
cGZuLCBlbnVtIHBnX2xldmVsIGxldmVsKTsKPj4+IFVzZWQgdG8gdHJhbnNpdGlvbiBhIHBhZ2Ug
dG8gaHlwZXJ2aXNvci9zaGFyZWQgc3RhdGUgdXNpbmcgdGhlCj4+PiBSTVBVUERBVEUgaW5zdHJ1
Y3Rpb24uCj4+Pgo+Pj4gU2lnbmVkLW9mZi1ieTogQXNoaXNoIEthbHJhIDxhc2hpc2gua2FscmFA
YW1kLmNvbT4KPj4+IFNpZ25lZC1vZmYtYnk6IEJyaWplc2ggU2luZ2ggPGJyaWplc2guc2luZ2hA
YW1kLmNvbT4KPj4+IFttZHI6IGFkZCBSTVBVUERBVEUgcmV0cnkgbG9naWMgZm9yIHRyYW5zaWVu
dCBGQUlMX09WRVJMQVAgZXJyb3JzXQo+Pj4gU2lnbmVkLW9mZi1ieTogTWljaGFlbCBSb3RoIDxt
aWNoYWVsLnJvdGhAYW1kLmNvbT4KPj4+IC0tLQo+Pj4gwqAgYXJjaC94ODYvaW5jbHVkZS9hc20v
c2V2LmggfCAyNCArKysrKysrKysrCj4+PiDCoCBhcmNoL3g4Ni9rZXJuZWwvc2V2LmPCoMKgwqDC
oMKgIHwgOTUgCj4+PiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+Pj4g
wqAgMiBmaWxlcyBjaGFuZ2VkLCAxMTkgaW5zZXJ0aW9ucygrKQo+Pj4KPj4+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zZXYuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Nldi5o
Cj4+PiBpbmRleCA4ZDNjZTJhZDI3ZGEuLjRlZWVkY2FjYTU5MyAxMDA2NDQKPj4+IC0tLSBhL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL3Nldi5oCj4+PiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9z
ZXYuaAo+Pj4gQEAgLTgwLDEwICs4MCwxNSBAQCBleHRlcm4gYm9vbCBoYW5kbGVfdmNfYm9vdF9n
aGNiKHN0cnVjdCBwdF9yZWdzCj4+PiAqcmVncyk7Cj4+Pgo+Pj4gwqAgLyogU29mdHdhcmUgZGVm
aW5lZCAod2hlbiByRmxhZ3MuQ0YgPSAxKSAqLwo+Pj4gwqAgI2RlZmluZSBQVkFMSURBVEVfRkFJ
TF9OT1VQREFURcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAyNTUKPj4+ICsvKiBSTVVQ
REFURSBkZXRlY3RlZCA0SyBwYWdlIGFuZCAyTUIgcGFnZSBvdmVybGFwLiAqLwo+Pj4gKyNkZWZp
bmUgUk1QVVBEQVRFX0ZBSUxfT1ZFUkxBUMKgwqDCoMKgwqDCoMKgwqAgNwo+Pj4KPj4+IMKgIC8q
IFJNUCBwYWdlIHNpemUgKi8KPj4+IMKgICNkZWZpbmUgUk1QX1BHX1NJWkVfNEvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAwCj4+PiArI2RlZmluZSBSTVBfUEdfU0laRV8yTcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDEKPj4+IMKgICNkZWZpbmUgUk1QX1RPX1g4Nl9Q
R19MRVZFTChsZXZlbCnCoMKgwqDCoCAoKChsZXZlbCkgPT0gUk1QX1BHX1NJWkVfNEspCj4+PiA/
IFBHX0xFVkVMXzRLIDogUEdfTEVWRUxfMk0pCj4+PiArI2RlZmluZSBYODZfVE9fUk1QX1BHX0xF
VkVMKGxldmVsKcKgwqDCoMKgICgoKGxldmVsKSA9PSBQR19MRVZFTF80SykgPwo+Pj4gUk1QX1BH
X1NJWkVfNEsgOiBSTVBfUEdfU0laRV8yTSkKPj4+ICsKPj4+IMKgICNkZWZpbmUgUk1QQURKVVNU
X1ZNU0FfUEFHRV9CSVTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgQklUKDE2KQo+Pj4K
Pj4+IMKgIC8qIFNOUCBHdWVzdCBtZXNzYWdlIHJlcXVlc3QgKi8KPj4+IEBAIC0xMzMsNiArMTM4
LDE1IEBAIHN0cnVjdCBzbnBfc2VjcmV0c19wYWdlX2xheW91dCB7Cj4+PiDCoMKgwqDCoMKgwqDC
oMKgIHU4IHJzdmQzWzM4NDBdOwo+Pj4gwqAgfSBfX3BhY2tlZDsKPj4+Cj4+PiArc3RydWN0IHJt
cF9zdGF0ZSB7Cj4+PiArwqDCoMKgwqDCoMKgIHU2NCBncGE7Cj4+PiArwqDCoMKgwqDCoMKgIHU4
IGFzc2lnbmVkOwo+Pj4gK8KgwqDCoMKgwqDCoCB1OCBwYWdlc2l6ZTsKPj4+ICvCoMKgwqDCoMKg
wqAgdTggaW1tdXRhYmxlOwo+Pj4gK8KgwqDCoMKgwqDCoCB1OCByc3ZkOwo+Pj4gK8KgwqDCoMKg
wqDCoCB1MzIgYXNpZDsKPj4+ICt9IF9fcGFja2VkOwo+Pj4gKwo+Pj4gwqAgI2lmZGVmIENPTkZJ
R19BTURfTUVNX0VOQ1JZUFQKPj4+IMKgIGV4dGVybiBzdHJ1Y3Qgc3RhdGljX2tleV9mYWxzZSBz
ZXZfZXNfZW5hYmxlX2tleTsKPj4+IMKgIGV4dGVybiB2b2lkIF9fc2V2X2VzX2lzdF9lbnRlcihz
dHJ1Y3QgcHRfcmVncyAqcmVncyk7Cj4+PiBAQCAtMTk4LDYgKzIxMiw5IEBAIGJvb2wgc25wX2lu
aXQoc3RydWN0IGJvb3RfcGFyYW1zICpicCk7Cj4+PiDCoCB2b2lkIF9faW5pdCBfX25vcmV0dXJu
IHNucF9hYm9ydCh2b2lkKTsKPj4+IMKgIGludCBzbnBfaXNzdWVfZ3Vlc3RfcmVxdWVzdCh1NjQg
ZXhpdF9jb2RlLCBzdHJ1Y3Qgc25wX3JlcV9kYXRhCj4+PiAqaW5wdXQsIHVuc2lnbmVkIGxvbmcg
KmZ3X2Vycik7Cj4+PiDCoCBpbnQgc25wX2xvb2t1cF9ybXBlbnRyeSh1NjQgcGZuLCBpbnQgKmxl
dmVsKTsKPj4+ICtpbnQgcHNtYXNoKHU2NCBwZm4pOwo+Pj4gK2ludCBybXBfbWFrZV9wcml2YXRl
KHU2NCBwZm4sIHU2NCBncGEsIGVudW0gcGdfbGV2ZWwgbGV2ZWwsIGludCBhc2lkLAo+Pj4gYm9v
bCBpbW11dGFibGUpOwo+Pj4gK2ludCBybXBfbWFrZV9zaGFyZWQodTY0IHBmbiwgZW51bSBwZ19s
ZXZlbCBsZXZlbCk7Cj4+PiDCoCAjZWxzZQo+Pj4gwqAgc3RhdGljIGlubGluZSB2b2lkIHNldl9l
c19pc3RfZW50ZXIoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpIHsgfQo+Pj4gwqAgc3RhdGljIGlubGlu
ZSB2b2lkIHNldl9lc19pc3RfZXhpdCh2b2lkKSB7IH0KPj4+IEBAIC0yMjMsNiArMjQwLDEzIEBA
IHN0YXRpYyBpbmxpbmUgaW50IHNucF9pc3N1ZV9ndWVzdF9yZXF1ZXN0KHU2NAo+Pj4gZXhpdF9j
b2RlLCBzdHJ1Y3Qgc25wX3JlcV9kYXRhICppbgo+Pj4gwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4g
LUVOT1RUWTsKPj4+IMKgIH0KPj4+IMKgIHN0YXRpYyBpbmxpbmUgaW50IHNucF9sb29rdXBfcm1w
ZW50cnkodTY0IHBmbiwgaW50ICpsZXZlbCkgeyByZXR1cm4KPj4+IDA7IH0KPj4+ICtzdGF0aWMg
aW5saW5lIGludCBwc21hc2godTY0IHBmbikgeyByZXR1cm4gLUVOWElPOyB9Cj4+PiArc3RhdGlj
IGlubGluZSBpbnQgcm1wX21ha2VfcHJpdmF0ZSh1NjQgcGZuLCB1NjQgZ3BhLCBlbnVtIHBnX2xl
dmVsCj4+PiBsZXZlbCwgaW50IGFzaWQsCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJvb2wgaW1tdXRhYmxlKQo+
Pj4gK3sKPj4+ICvCoMKgwqDCoMKgwqAgcmV0dXJuIC1FTk9ERVY7Cj4+PiArfQo+Pj4gK3N0YXRp
YyBpbmxpbmUgaW50IHJtcF9tYWtlX3NoYXJlZCh1NjQgcGZuLCBlbnVtIHBnX2xldmVsIGxldmVs
KSB7Cj4+PiByZXR1cm4gLUVOT0RFVjsgfQo+Pj4gwqAgI2VuZGlmCj4+Pgo+Pj4gwqAgI2VuZGlm
Cj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL3Nldi5jIGIvYXJjaC94ODYva2VybmVs
L3Nldi5jCj4+PiBpbmRleCA3MDY2NzU1NjFmNDkuLjY3MDM1ZDM0YWRhZCAxMDA2NDQKPj4+IC0t
LSBhL2FyY2gveDg2L2tlcm5lbC9zZXYuYwo+Pj4gKysrIGIvYXJjaC94ODYva2VybmVsL3Nldi5j
Cj4+PiBAQCAtMjUyMywzICsyNTIzLDk4IEBAIGludCBzbnBfbG9va3VwX3JtcGVudHJ5KHU2NCBw
Zm4sIGludCAqbGV2ZWwpCj4+PiDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAhIXJtcGVudHJ5X2Fz
c2lnbmVkKGUpOwo+Pj4gwqAgfQo+Pj4gwqAgRVhQT1JUX1NZTUJPTF9HUEwoc25wX2xvb2t1cF9y
bXBlbnRyeSk7Cj4+PiArCj4+PiArLyoKPj4+ICsgKiBwc21hc2ggaXMgdXNlZCB0byBzbWFzaCBh
IDJNQiBhbGlnbmVkIHBhZ2UgaW50byA0Swo+Pj4gKyAqIHBhZ2VzIHdoaWxlIHByZXNlcnZpbmcg
dGhlIFZhbGlkYXRlZCBiaXQgaW4gdGhlIFJNUC4KPj4+ICsgKi8KPj4+ICtpbnQgcHNtYXNoKHU2
NCBwZm4pCj4+PiArewo+Pj4gK8KgwqDCoMKgwqDCoCB1bnNpZ25lZCBsb25nIHBhZGRyID0gcGZu
IDw8IFBBR0VfU0hJRlQ7Cj4+PiArwqDCoMKgwqDCoMKgIGludCByZXQ7Cj4+PiArCj4+PiArwqDC
oMKgwqDCoMKgIGlmICghcGZuX3ZhbGlkKHBmbikpCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPj4KPj4KPj4gV2UgKGFuZCBtYW55IG90aGVyIGNsb3Vk
cykgdXNlIGEgbmVhdCB0cmljayB0byByZWR1Y2UgdGhlIG51bWJlciBvZgo+PiBzdHJ1Y3QgcGFn
ZXMgTGludXggYWxsb2NhdGVzIGZvciBndWVzdCBtZW1vcnk6IEluIGl0cyBzaW1wbGVzdCBmb3Jt
LCBhZGQKPj4gbWVtPSB0byB0aGUga2VybmVsIGNtZGxpbmUgYW5kIG1tYXAoKSAvZGV2L21lbSB0
byBhY2Nlc3MgdGhlIHJlc2VydmVkCj4+IG1lbW9yeSBpbnN0ZWFkLgo+Pgo+PiBUaGlzIG1lYW5z
IHRoYXQgdGhlIHN5c3RlbSBjb3ZlcnMgbW9yZSBSQU0gdGhhbiBMaW51eCBjb250YWlucywgd2hp
Y2gKPj4gbWVhbnMgcGZuX3ZhbGlkKCkgaXMgbm8gbG9uZ2VyIGEgZ29vZCBpbmRpY2F0aW9uIHdo
ZXRoZXIgYSBwYWdlIGlzCj4+IGluZGVlZCB2YWxpZC4gS1ZNIGhhbmRsZXMgdGhpcyBjYXNlIGZp
bmUsIGJ1dCB0aGlzIGNvZGUgZG9lcyBub3QuCj4KPiBIbW0uLi5idXQgdGhlbiBpcyBhbHNvIHVz
aW5nIG1heF9wZm4gcmVsaWFibGUgPwoKCkkgd291bGQgZXhwZWN0IGl0IHRvIG5vdCBiZSByZWxp
YWJsZSBhcyBpdCBvbmx5IGxvb2tzIGF0IEU4MjBfVFlQRV9SQU0sIAp5ZXMuIERvIHlvdSByZWx5
IG9uIG1heF9wZm4gYW55d2hlcmU/CgoKPgo+Pgo+PiBJcyB0aGVyZSBhbnkgcGFydGljdWxhciBy
ZWFzb24gd2h5IHdlIG5lZWQgdGhpcyBjaGVjayAoYW5kIHNpbWlsYXIgb25lcwo+PiBiZWxvdyBh
bmQgaW4gb3RoZXIgUk1QIHJlbGF0ZWQgcGF0Y2hlcykgaW4gdGhlIGZpcnN0IHBsYWNlLiBJIHdv
dWxkID4gCj4+IGV4cGVjdCB0aGF0IFBTTUFTSCBhbmQgZnJpZW5kcyByZXR1cm4gZmFpbHVyZSBj
b2RlcyBmb3IgaW52YWxpZCBwZm5zLgo+Pgo+Cj4gWWVzLCBQU01BU0ggZG9lcyBvdXQgb2YgYm91
bmRzIGNoZWNrIG9uIHRoZSBpbnB1dCBTUEEgYW5kIGFkZGl0aW9uYWxseQo+IGNoZWNrcyBpZiBT
UEEgaXMgMk0gYWxpZ25lZCwgc28gZ3Vlc3Mgd2UgY2FuIHJlbHkgb24gdXNpbmcgUFNNQVNICj4g
ZmFpbGluZyBvbiBpbnZhbGlkIHBmbnMuCgoKUGVyZmVjdCwgcGxlYXNlIHJlbW92ZSBhbGwgdGhl
IHN1cGVyZmx1b3VzIGNoZWNrcyB0aGVuLiBJZiB5b3Ugd2FudCB0byAKbWFrZSBvdXIgbGlmZSBl
YXN5LCBJJ2QgcmVjb21tZW5kIHlvdSB0cnkgdG8gdHJ5IHRoZSBwYXRjaCBzZXQgd2l0aCBtZW09
IApwYXNzZWQgb24gdGhlIGhvc3QgYW5kIHRlbGwgUUVNVSB0byBtbWFwKCkgL2Rldi9tZW0gZm9y
IGd1ZXN0IFJBTS4gVGhhdCAKd2F5IHlvdSBzaG91bGQgYmUgYWJsZSB0byBmaW5kIGFueSBvdGhl
ciBwaXRmYWxscyA6KQoKCkFsZXgKCgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1h
bnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBD
aHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2Vy
aWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1J
RDogREUgMjg5IDIzNyA4NzkKCgo=

