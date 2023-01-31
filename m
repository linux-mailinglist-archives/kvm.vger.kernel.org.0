Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB0D683896
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 22:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjAaV1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 16:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjAaV1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 16:27:11 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06B814226;
        Tue, 31 Jan 2023 13:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675200431; x=1706736431;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vYK2NpO+ExFxzqnG6ZjWnmzVegQDyJD3/VETJklLIPY=;
  b=ujo/dWQh0wEJfpGRNiseiydB5qh1/8c6XjjfeuqKubKFFdZzM7b8Uj+i
   0DGHqJRTsuLqL+RauA+EW5tZjTVC1Bcfo7Et0/xiqUFzFpV6v53L+WLBU
   1xhtfs0NAJ+dnTS5XEmEK0T/a5NDoRNmGDXsdx/zN5nt70PMWpi1nAqT0
   w=;
X-IronPort-AV: E=Sophos;i="5.97,261,1669075200"; 
   d="scan'208";a="292221146"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 21:27:04 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id CE22BC3759;
        Tue, 31 Jan 2023 21:27:00 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 31 Jan 2023 21:26:58 +0000
Received: from [0.0.0.0] (10.43.162.56) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.24; Tue, 31 Jan
 2023 21:26:50 +0000
Message-ID: <854a0caf-6940-8381-1e20-0ddb5ed94858@amazon.com>
Date:   Tue, 31 Jan 2023 22:26:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH RFC v7 16/64] x86/sev: Add helper functions for RMPUPDATE
 and PSMASH instruction
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>
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
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Rapan, Sabin" <sabrapan@amazon.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-17-michael.roth@amd.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <20221214194056.161492-17-michael.roth@amd.com>
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D31UWA004.ant.amazon.com (10.43.160.217) To
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

Ck9uIDE0LjEyLjIyIDIwOjQwLCBNaWNoYWVsIFJvdGggd3JvdGU6Cj4gRnJvbTogQnJpamVzaCBT
aW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPgo+Cj4gVGhlIFJNUFVQREFURSBpbnN0cnVjdGlv
biB3cml0ZXMgYSBuZXcgUk1QIGVudHJ5IGluIHRoZSBSTVAgVGFibGUuIFRoZQo+IGh5cGVydmlz
b3Igd2lsbCB1c2UgdGhlIGluc3RydWN0aW9uIHRvIGFkZCBwYWdlcyB0byB0aGUgUk1QIHRhYmxl
LiBTZWUKPiBBUE0zIGZvciBkZXRhaWxzIG9uIHRoZSBpbnN0cnVjdGlvbiBvcGVyYXRpb25zLgo+
Cj4gVGhlIFBTTUFTSCBpbnN0cnVjdGlvbiBleHBhbmRzIGEgMk1CIFJNUCBlbnRyeSBpbnRvIGEg
Y29ycmVzcG9uZGluZyBzZXQKPiBvZiBjb250aWd1b3VzIDRLQi1QYWdlIFJNUCBlbnRyaWVzLiBU
aGUgaHlwZXJ2aXNvciB3aWxsIHVzZSB0aGlzCj4gaW5zdHJ1Y3Rpb24gdG8gYWRqdXN0IHRoZSBS
TVAgZW50cnkgd2l0aG91dCBpbnZhbGlkYXRpbmcgdGhlIHByZXZpb3VzCj4gUk1QIGVudHJ5Lgo+
Cj4gQWRkIHRoZSBmb2xsb3dpbmcgZXh0ZXJuYWwgaW50ZXJmYWNlIEFQSSBmdW5jdGlvbnM6Cj4K
PiBpbnQgcHNtYXNoKHU2NCBwZm4pOwo+IHBzbWFzaCBpcyB1c2VkIHRvIHNtYXNoIGEgMk1CIGFs
aWduZWQgcGFnZSBpbnRvIDRLCj4gcGFnZXMgd2hpbGUgcHJlc2VydmluZyB0aGUgVmFsaWRhdGVk
IGJpdCBpbiB0aGUgUk1QLgo+Cj4gaW50IHJtcF9tYWtlX3ByaXZhdGUodTY0IHBmbiwgdTY0IGdw
YSwgZW51bSBwZ19sZXZlbCBsZXZlbCwgaW50IGFzaWQsIGJvb2wgaW1tdXRhYmxlKTsKPiBVc2Vk
IHRvIGFzc2lnbiBhIHBhZ2UgdG8gZ3Vlc3QgdXNpbmcgdGhlIFJNUFVQREFURSBpbnN0cnVjdGlv
bi4KPgo+IGludCBybXBfbWFrZV9zaGFyZWQodTY0IHBmbiwgZW51bSBwZ19sZXZlbCBsZXZlbCk7
Cj4gVXNlZCB0byB0cmFuc2l0aW9uIGEgcGFnZSB0byBoeXBlcnZpc29yL3NoYXJlZCBzdGF0ZSB1
c2luZyB0aGUgUk1QVVBEQVRFIGluc3RydWN0aW9uLgo+Cj4gU2lnbmVkLW9mZi1ieTogQXNoaXNo
IEthbHJhIDxhc2hpc2gua2FscmFAYW1kLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBCcmlqZXNoIFNp
bmdoIDxicmlqZXNoLnNpbmdoQGFtZC5jb20+Cj4gW21kcjogYWRkIFJNUFVQREFURSByZXRyeSBs
b2dpYyBmb3IgdHJhbnNpZW50IEZBSUxfT1ZFUkxBUCBlcnJvcnNdCj4gU2lnbmVkLW9mZi1ieTog
TWljaGFlbCBSb3RoIDxtaWNoYWVsLnJvdGhAYW1kLmNvbT4KPiAtLS0KPiAgIGFyY2gveDg2L2lu
Y2x1ZGUvYXNtL3Nldi5oIHwgMjQgKysrKysrKysrKwo+ICAgYXJjaC94ODYva2VybmVsL3Nldi5j
ICAgICAgfCA5NSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+ICAgMiBm
aWxlcyBjaGFuZ2VkLCAxMTkgaW5zZXJ0aW9ucygrKQo+Cj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2luY2x1ZGUvYXNtL3Nldi5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vc2V2LmgKPiBpbmRleCA4
ZDNjZTJhZDI3ZGEuLjRlZWVkY2FjYTU5MyAxMDA2NDQKPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9zZXYuaAo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Nldi5oCj4gQEAgLTgwLDEw
ICs4MCwxNSBAQCBleHRlcm4gYm9vbCBoYW5kbGVfdmNfYm9vdF9naGNiKHN0cnVjdCBwdF9yZWdz
ICpyZWdzKTsKPgo+ICAgLyogU29mdHdhcmUgZGVmaW5lZCAod2hlbiByRmxhZ3MuQ0YgPSAxKSAq
Lwo+ICAgI2RlZmluZSBQVkFMSURBVEVfRkFJTF9OT1VQREFURSAgICAgICAgICAgICAgICAyNTUK
PiArLyogUk1VUERBVEUgZGV0ZWN0ZWQgNEsgcGFnZSBhbmQgMk1CIHBhZ2Ugb3ZlcmxhcC4gKi8K
PiArI2RlZmluZSBSTVBVUERBVEVfRkFJTF9PVkVSTEFQICAgICAgICAgNwo+Cj4gICAvKiBSTVAg
cGFnZSBzaXplICovCj4gICAjZGVmaW5lIFJNUF9QR19TSVpFXzRLICAgICAgICAgICAgICAgICAw
Cj4gKyNkZWZpbmUgUk1QX1BHX1NJWkVfMk0gICAgICAgICAgICAgICAgIDEKPiAgICNkZWZpbmUg
Uk1QX1RPX1g4Nl9QR19MRVZFTChsZXZlbCkgICAgICgoKGxldmVsKSA9PSBSTVBfUEdfU0laRV80
SykgPyBQR19MRVZFTF80SyA6IFBHX0xFVkVMXzJNKQo+ICsjZGVmaW5lIFg4Nl9UT19STVBfUEdf
TEVWRUwobGV2ZWwpICAgICAoKChsZXZlbCkgPT0gUEdfTEVWRUxfNEspID8gUk1QX1BHX1NJWkVf
NEsgOiBSTVBfUEdfU0laRV8yTSkKPiArCj4gICAjZGVmaW5lIFJNUEFESlVTVF9WTVNBX1BBR0Vf
QklUICAgICAgICAgICAgICAgIEJJVCgxNikKPgo+ICAgLyogU05QIEd1ZXN0IG1lc3NhZ2UgcmVx
dWVzdCAqLwo+IEBAIC0xMzMsNiArMTM4LDE1IEBAIHN0cnVjdCBzbnBfc2VjcmV0c19wYWdlX2xh
eW91dCB7Cj4gICAgICAgICAgdTggcnN2ZDNbMzg0MF07Cj4gICB9IF9fcGFja2VkOwo+Cj4gK3N0
cnVjdCBybXBfc3RhdGUgewo+ICsgICAgICAgdTY0IGdwYTsKPiArICAgICAgIHU4IGFzc2lnbmVk
Owo+ICsgICAgICAgdTggcGFnZXNpemU7Cj4gKyAgICAgICB1OCBpbW11dGFibGU7Cj4gKyAgICAg
ICB1OCByc3ZkOwo+ICsgICAgICAgdTMyIGFzaWQ7Cj4gK30gX19wYWNrZWQ7Cj4gKwo+ICAgI2lm
ZGVmIENPTkZJR19BTURfTUVNX0VOQ1JZUFQKPiAgIGV4dGVybiBzdHJ1Y3Qgc3RhdGljX2tleV9m
YWxzZSBzZXZfZXNfZW5hYmxlX2tleTsKPiAgIGV4dGVybiB2b2lkIF9fc2V2X2VzX2lzdF9lbnRl
cihzdHJ1Y3QgcHRfcmVncyAqcmVncyk7Cj4gQEAgLTE5OCw2ICsyMTIsOSBAQCBib29sIHNucF9p
bml0KHN0cnVjdCBib290X3BhcmFtcyAqYnApOwo+ICAgdm9pZCBfX2luaXQgX19ub3JldHVybiBz
bnBfYWJvcnQodm9pZCk7Cj4gICBpbnQgc25wX2lzc3VlX2d1ZXN0X3JlcXVlc3QodTY0IGV4aXRf
Y29kZSwgc3RydWN0IHNucF9yZXFfZGF0YSAqaW5wdXQsIHVuc2lnbmVkIGxvbmcgKmZ3X2Vycik7
Cj4gICBpbnQgc25wX2xvb2t1cF9ybXBlbnRyeSh1NjQgcGZuLCBpbnQgKmxldmVsKTsKPiAraW50
IHBzbWFzaCh1NjQgcGZuKTsKPiAraW50IHJtcF9tYWtlX3ByaXZhdGUodTY0IHBmbiwgdTY0IGdw
YSwgZW51bSBwZ19sZXZlbCBsZXZlbCwgaW50IGFzaWQsIGJvb2wgaW1tdXRhYmxlKTsKPiAraW50
IHJtcF9tYWtlX3NoYXJlZCh1NjQgcGZuLCBlbnVtIHBnX2xldmVsIGxldmVsKTsKPiAgICNlbHNl
Cj4gICBzdGF0aWMgaW5saW5lIHZvaWQgc2V2X2VzX2lzdF9lbnRlcihzdHJ1Y3QgcHRfcmVncyAq
cmVncykgeyB9Cj4gICBzdGF0aWMgaW5saW5lIHZvaWQgc2V2X2VzX2lzdF9leGl0KHZvaWQpIHsg
fQo+IEBAIC0yMjMsNiArMjQwLDEzIEBAIHN0YXRpYyBpbmxpbmUgaW50IHNucF9pc3N1ZV9ndWVz
dF9yZXF1ZXN0KHU2NCBleGl0X2NvZGUsIHN0cnVjdCBzbnBfcmVxX2RhdGEgKmluCj4gICAgICAg
ICAgcmV0dXJuIC1FTk9UVFk7Cj4gICB9Cj4gICBzdGF0aWMgaW5saW5lIGludCBzbnBfbG9va3Vw
X3JtcGVudHJ5KHU2NCBwZm4sIGludCAqbGV2ZWwpIHsgcmV0dXJuIDA7IH0KPiArc3RhdGljIGlu
bGluZSBpbnQgcHNtYXNoKHU2NCBwZm4pIHsgcmV0dXJuIC1FTlhJTzsgfQo+ICtzdGF0aWMgaW5s
aW5lIGludCBybXBfbWFrZV9wcml2YXRlKHU2NCBwZm4sIHU2NCBncGEsIGVudW0gcGdfbGV2ZWwg
bGV2ZWwsIGludCBhc2lkLAo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYm9v
bCBpbW11dGFibGUpCj4gK3sKPiArICAgICAgIHJldHVybiAtRU5PREVWOwo+ICt9Cj4gK3N0YXRp
YyBpbmxpbmUgaW50IHJtcF9tYWtlX3NoYXJlZCh1NjQgcGZuLCBlbnVtIHBnX2xldmVsIGxldmVs
KSB7IHJldHVybiAtRU5PREVWOyB9Cj4gICAjZW5kaWYKPgo+ICAgI2VuZGlmCj4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2tlcm5lbC9zZXYuYyBiL2FyY2gveDg2L2tlcm5lbC9zZXYuYwo+IGluZGV4
IDcwNjY3NTU2MWY0OS4uNjcwMzVkMzRhZGFkIDEwMDY0NAo+IC0tLSBhL2FyY2gveDg2L2tlcm5l
bC9zZXYuYwo+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9zZXYuYwo+IEBAIC0yNTIzLDMgKzI1MjMs
OTggQEAgaW50IHNucF9sb29rdXBfcm1wZW50cnkodTY0IHBmbiwgaW50ICpsZXZlbCkKPiAgICAg
ICAgICByZXR1cm4gISFybXBlbnRyeV9hc3NpZ25lZChlKTsKPiAgIH0KPiAgIEVYUE9SVF9TWU1C
T0xfR1BMKHNucF9sb29rdXBfcm1wZW50cnkpOwo+ICsKPiArLyoKPiArICogcHNtYXNoIGlzIHVz
ZWQgdG8gc21hc2ggYSAyTUIgYWxpZ25lZCBwYWdlIGludG8gNEsKPiArICogcGFnZXMgd2hpbGUg
cHJlc2VydmluZyB0aGUgVmFsaWRhdGVkIGJpdCBpbiB0aGUgUk1QLgo+ICsgKi8KPiAraW50IHBz
bWFzaCh1NjQgcGZuKQo+ICt7Cj4gKyAgICAgICB1bnNpZ25lZCBsb25nIHBhZGRyID0gcGZuIDw8
IFBBR0VfU0hJRlQ7Cj4gKyAgICAgICBpbnQgcmV0Owo+ICsKPiArICAgICAgIGlmICghcGZuX3Zh
bGlkKHBmbikpCj4gKyAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOwoKCldlIChhbmQgbWFu
eSBvdGhlciBjbG91ZHMpIHVzZSBhIG5lYXQgdHJpY2sgdG8gcmVkdWNlIHRoZSBudW1iZXIgb2Yg
CnN0cnVjdCBwYWdlcyBMaW51eCBhbGxvY2F0ZXMgZm9yIGd1ZXN0IG1lbW9yeTogSW4gaXRzIHNp
bXBsZXN0IGZvcm0sIGFkZCAKbWVtPSB0byB0aGUga2VybmVsIGNtZGxpbmUgYW5kIG1tYXAoKSAv
ZGV2L21lbSB0byBhY2Nlc3MgdGhlIHJlc2VydmVkIAptZW1vcnkgaW5zdGVhZC4KClRoaXMgbWVh
bnMgdGhhdCB0aGUgc3lzdGVtIGNvdmVycyBtb3JlIFJBTSB0aGFuIExpbnV4IGNvbnRhaW5zLCB3
aGljaCAKbWVhbnMgcGZuX3ZhbGlkKCkgaXMgbm8gbG9uZ2VyIGEgZ29vZCBpbmRpY2F0aW9uIHdo
ZXRoZXIgYSBwYWdlIGlzIAppbmRlZWQgdmFsaWQuIEtWTSBoYW5kbGVzIHRoaXMgY2FzZSBmaW5l
LCBidXQgdGhpcyBjb2RlIGRvZXMgbm90LgoKSXMgdGhlcmUgYW55IHBhcnRpY3VsYXIgcmVhc29u
IHdoeSB3ZSBuZWVkIHRoaXMgY2hlY2sgKGFuZCBzaW1pbGFyIG9uZXMgCmJlbG93IGFuZCBpbiBv
dGhlciBSTVAgcmVsYXRlZCBwYXRjaGVzKSBpbiB0aGUgZmlyc3QgcGxhY2U/IEkgd291bGQgCmV4
cGVjdCB0aGF0IFBTTUFTSCBhbmQgZnJpZW5kcyByZXR1cm4gZmFpbHVyZSBjb2RlcyBmb3IgaW52
YWxpZCBwZm5zLgoKCkFsZXgKCgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkg
R21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJp
c3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNo
dCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDog
REUgMjg5IDIzNyA4NzkKCgo=

