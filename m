Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAD16E4998
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 15:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjDQNMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 09:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjDQNML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 09:12:11 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C931FB74A;
        Mon, 17 Apr 2023 06:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681737105; x=1713273105;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IAokaNAEfHl9C8LoKjZyuJqQZ99655BjjMZAcAR45iw=;
  b=gwnRnzPbF3mjrA4Ckb0Aku7/1Ved380InxTJTQXRNfGH5DNfnho4q9U2
   4rgZF3UsdS44wz6V5TOtFPP2n5gYDOrSWjMXlSGwMwxGtgwuGti9rLix7
   JsoLbIfR5qgTFce3UsmPgWjMJve0Nog2pQKnTiCbQPbMQpYF0mKHiDAZ4
   Q=;
X-IronPort-AV: E=Sophos;i="5.99,204,1677542400"; 
   d="scan'208";a="314793493"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-e651a362.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 13:05:28 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-e651a362.us-east-1.amazon.com (Postfix) with ESMTPS id 640BB82D70;
        Mon, 17 Apr 2023 13:05:13 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 17 Apr 2023 13:05:12 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.26; Mon, 17 Apr
 2023 13:05:04 +0000
Message-ID: <1b17d7d5-1181-5156-07fd-9c50ee7b1e5c@amazon.com>
Date:   Mon, 17 Apr 2023 15:05:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v8 45/56] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Rapan, Sabin" <sabrapan@amazon.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-46-michael.roth@amd.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <20230220183847.59159-46-michael.roth@amd.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D036UWC003.ant.amazon.com (10.13.139.214) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDIwLjAyLjIzIDE5OjM4LCBNaWNoYWVsIFJvdGggd3JvdGU6Cgo+IEZyb206IEJyaWplc2gg
U2luZ2ggPGJyaWplc2guc2luZ2hAYW1kLmNvbT4KPgo+IFZlcnNpb24gMiBvZiBHSENCIHNwZWNp
ZmljYXRpb24gYWRkZWQgdGhlIHN1cHBvcnQgZm9yIHR3byBTTlAgR3Vlc3QKPiBSZXF1ZXN0IE1l
c3NhZ2UgTkFFIGV2ZW50cy4gVGhlIGV2ZW50cyBhbGxvd3MgZm9yIGFuIFNFVi1TTlAgZ3Vlc3Qg
dG8KPiBtYWtlIHJlcXVlc3QgdG8gdGhlIFNFVi1TTlAgZmlybXdhcmUgdGhyb3VnaCBoeXBlcnZp
c29yIHVzaW5nIHRoZQo+IFNOUF9HVUVTVF9SRVFVRVNUIEFQSSBkZWZpbmUgaW4gdGhlIFNFVi1T
TlAgZmlybXdhcmUgc3BlY2lmaWNhdGlvbi4KPgo+IFRoZSBTTlBfRVhUX0dVRVNUX1JFUVVFU1Qg
aXMgc2ltaWxhciB0byBTTlBfR1VFU1RfUkVRVUVTVCB3aXRoIHRoZQo+IGRpZmZlcmVuY2Ugb2Yg
YW4gYWRkaXRpb25hbCBjZXJ0aWZpY2F0ZSBibG9iIHRoYXQgY2FuIGJlIHBhc3NlZCB0aHJvdWdo
Cj4gdGhlIFNOUF9TRVRfQ09ORklHIGlvY3RsIGRlZmluZWQgaW4gdGhlIENDUCBkcml2ZXIuIFRo
ZSBDQ1AgZHJpdmVyCj4gcHJvdmlkZXMgc25wX2d1ZXN0X2V4dF9ndWVzdF9yZXF1ZXN0KCkgdGhh
dCBpcyB1c2VkIGJ5IHRoZSBLVk0gdG8gZ2V0Cj4gYm90aCB0aGUgcmVwb3J0IGFuZCBjZXJ0aWZp
Y2F0ZSBkYXRhIGF0IG9uY2UuCj4KPiBTaWduZWQtb2ZmLWJ5OiBCcmlqZXNoIFNpbmdoIDxicmlq
ZXNoLnNpbmdoQGFtZC5jb20+Cj4gU2lnbmVkLW9mZi1ieTogQXNoaXNoIEthbHJhIDxhc2hpc2gu
a2FscmFAYW1kLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIFJvdGggPG1pY2hhZWwucm90
aEBhbWQuY29tPgo+IC0tLQo+ICAgYXJjaC94ODYva3ZtL3N2bS9zZXYuYyB8IDE4NSArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQo+ICAgYXJjaC94ODYva3ZtL3N2bS9z
dm0uaCB8ICAgMiArCj4gICAyIGZpbGVzIGNoYW5nZWQsIDE4MSBpbnNlcnRpb25zKCspLCA2IGRl
bGV0aW9ucygtKQo+Cj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9zdm0vc2V2LmMgYi9hcmNo
L3g4Ni9rdm0vc3ZtL3Nldi5jCj4gaW5kZXggMTk3YjFmOTA0NTY3Li45MjE3OTYxNDEwMmUgMTAw
NjQ0Cj4gLS0tIGEvYXJjaC94ODYva3ZtL3N2bS9zZXYuYwo+ICsrKyBiL2FyY2gveDg2L2t2bS9z
dm0vc2V2LmMKPiBAQCAtMzI3LDYgKzMyNyw3IEBAIHN0YXRpYyBpbnQgc2V2X2d1ZXN0X2luaXQo
c3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3Nldl9jbWQgKmFyZ3ApCj4gICAgICAgICAgICAg
ICAgICBpZiAocmV0KQo+ICAgICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGVfZnJlZTsKPgo+
ICsgICAgICAgICAgICAgICBtdXRleF9pbml0KCZzZXYtPmd1ZXN0X3JlcV9sb2NrKTsKPiAgICAg
ICAgICAgICAgICAgIHJldCA9IHNldl9zbnBfaW5pdCgmYXJncC0+ZXJyb3IsIGZhbHNlKTsKPiAg
ICAgICAgICB9IGVsc2Ugewo+ICAgICAgICAgICAgICAgICAgcmV0ID0gc2V2X3BsYXRmb3JtX2lu
aXQoJmFyZ3AtPmVycm9yKTsKPiBAQCAtMjA1OSwyMyArMjA2MCwzNCBAQCBpbnQgc2V2X3ZtX21v
dmVfZW5jX2NvbnRleHRfZnJvbShzdHJ1Y3Qga3ZtICprdm0sIHVuc2lnbmVkIGludCBzb3VyY2Vf
ZmQpCj4gICAgKi8KPiAgIHN0YXRpYyB2b2lkICpzbnBfY29udGV4dF9jcmVhdGUoc3RydWN0IGt2
bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3Nldl9jbWQgKmFyZ3ApCj4gICB7Cj4gKyAgICAgICBzdHJ1Y3Qg
a3ZtX3Nldl9pbmZvICpzZXYgPSAmdG9fa3ZtX3N2bShrdm0pLT5zZXZfaW5mbzsKPiAgICAgICAg
ICBzdHJ1Y3Qgc2V2X2RhdGFfc25wX2FkZHIgZGF0YSA9IHt9Owo+IC0gICAgICAgdm9pZCAqY29u
dGV4dDsKPiArICAgICAgIHZvaWQgKmNvbnRleHQsICpjZXJ0c19kYXRhOwo+ICAgICAgICAgIGlu
dCByYzsKPgo+ICsgICAgICAgLyogQWxsb2NhdGUgbWVtb3J5IHVzZWQgZm9yIHRoZSBjZXJ0cyBk
YXRhIGluIFNOUCBndWVzdCByZXF1ZXN0ICovCj4gKyAgICAgICBjZXJ0c19kYXRhID0ga3phbGxv
YyhTRVZfRldfQkxPQl9NQVhfU0laRSwgR0ZQX0tFUk5FTF9BQ0NPVU5UKTsKPiArICAgICAgIGlm
ICghY2VydHNfZGF0YSkKPiArICAgICAgICAgICAgICAgcmV0dXJuIE5VTEw7Cj4gKwo+ICAgICAg
ICAgIC8qIEFsbG9jYXRlIG1lbW9yeSBmb3IgY29udGV4dCBwYWdlICovCj4gICAgICAgICAgY29u
dGV4dCA9IHNucF9hbGxvY19maXJtd2FyZV9wYWdlKEdGUF9LRVJORUxfQUNDT1VOVCk7Cj4gICAg
ICAgICAgaWYgKCFjb250ZXh0KQo+IC0gICAgICAgICAgICAgICByZXR1cm4gTlVMTDsKPiArICAg
ICAgICAgICAgICAgZ290byBlX2ZyZWU7Cj4KPiAgICAgICAgICBkYXRhLmdjdHhfcGFkZHIgPSBf
X3BzcF9wYShjb250ZXh0KTsKPiAgICAgICAgICByYyA9IF9fc2V2X2lzc3VlX2NtZChhcmdwLT5z
ZXZfZmQsIFNFVl9DTURfU05QX0dDVFhfQ1JFQVRFLCAmZGF0YSwgJmFyZ3AtPmVycm9yKTsKPiAt
ICAgICAgIGlmIChyYykgewo+IC0gICAgICAgICAgICAgICBzbnBfZnJlZV9maXJtd2FyZV9wYWdl
KGNvbnRleHQpOwo+IC0gICAgICAgICAgICAgICByZXR1cm4gTlVMTDsKPiAtICAgICAgIH0KPiAr
ICAgICAgIGlmIChyYykKPiArICAgICAgICAgICAgICAgZ290byBlX2ZyZWU7Cj4gKwo+ICsgICAg
ICAgc2V2LT5zbnBfY2VydHNfZGF0YSA9IGNlcnRzX2RhdGE7Cj4KPiAgICAgICAgICByZXR1cm4g
Y29udGV4dDsKPiArCj4gK2VfZnJlZToKPiArICAgICAgIHNucF9mcmVlX2Zpcm13YXJlX3BhZ2Uo
Y29udGV4dCk7Cj4gKyAgICAgICBrZnJlZShjZXJ0c19kYXRhKTsKPiArICAgICAgIHJldHVybiBO
VUxMOwo+ICAgfQo+Cj4gICBzdGF0aWMgaW50IHNucF9iaW5kX2FzaWQoc3RydWN0IGt2bSAqa3Zt
LCBpbnQgKmVycm9yKQo+IEBAIC0yNjkzLDYgKzI3MDUsOCBAQCBzdGF0aWMgaW50IHNucF9kZWNv
bW1pc3Npb25fY29udGV4dChzdHJ1Y3Qga3ZtICprdm0pCj4gICAgICAgICAgc25wX2ZyZWVfZmly
bXdhcmVfcGFnZShzZXYtPnNucF9jb250ZXh0KTsKPiAgICAgICAgICBzZXYtPnNucF9jb250ZXh0
ID0gTlVMTDsKPgo+ICsgICAgICAga2ZyZWUoc2V2LT5zbnBfY2VydHNfZGF0YSk7Cj4gKwo+ICAg
ICAgICAgIHJldHVybiAwOwo+ICAgfQo+Cj4gQEAgLTMxNTMsNiArMzE2Nyw4IEBAIHN0YXRpYyBp
bnQgc2V2X2VzX3ZhbGlkYXRlX3ZtZ2V4aXQoc3RydWN0IHZjcHVfc3ZtICpzdm0pCj4gICAgICAg
ICAgY2FzZSBTVk1fVk1HRVhJVF9VTlNVUFBPUlRFRF9FVkVOVDoKPiAgICAgICAgICBjYXNlIFNW
TV9WTUdFWElUX0hWX0ZFQVRVUkVTOgo+ICAgICAgICAgIGNhc2UgU1ZNX1ZNR0VYSVRfUFNDOgo+
ICsgICAgICAgY2FzZSBTVk1fVk1HRVhJVF9HVUVTVF9SRVFVRVNUOgo+ICsgICAgICAgY2FzZSBT
Vk1fVk1HRVhJVF9FWFRfR1VFU1RfUkVRVUVTVDoKPiAgICAgICAgICAgICAgICAgIGJyZWFrOwo+
ICAgICAgICAgIGRlZmF1bHQ6Cj4gICAgICAgICAgICAgICAgICByZWFzb24gPSBHSENCX0VSUl9J
TlZBTElEX0VWRU5UOwo+IEBAIC0zMzg0LDYgKzM0MDAsMTQ5IEBAIHN0YXRpYyBpbnQgc25wX2Nv
bXBsZXRlX3BzYyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4gICAgICAgICAgcmV0dXJuIDE7Cj4g
ICB9Cj4KPiArc3RhdGljIHVuc2lnbmVkIGxvbmcgc25wX3NldHVwX2d1ZXN0X2J1ZihzdHJ1Y3Qg
dmNwdV9zdm0gKnN2bSwKPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHN0cnVjdCBzZXZfZGF0YV9zbnBfZ3Vlc3RfcmVxdWVzdCAqZGF0YSwKPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGdwYV90IHJlcV9ncGEsIGdwYV90IHJlc3BfZ3Bh
KQo+ICt7Cj4gKyAgICAgICBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUgPSAmc3ZtLT52Y3B1Owo+ICsg
ICAgICAgc3RydWN0IGt2bSAqa3ZtID0gdmNwdS0+a3ZtOwo+ICsgICAgICAga3ZtX3Bmbl90IHJl
cV9wZm4sIHJlc3BfcGZuOwo+ICsgICAgICAgc3RydWN0IGt2bV9zZXZfaW5mbyAqc2V2Owo+ICsK
PiArICAgICAgIHNldiA9ICZ0b19rdm1fc3ZtKGt2bSktPnNldl9pbmZvOwo+ICsKPiArICAgICAg
IGlmICghSVNfQUxJR05FRChyZXFfZ3BhLCBQQUdFX1NJWkUpIHx8ICFJU19BTElHTkVEKHJlc3Bf
Z3BhLCBQQUdFX1NJWkUpKQo+ICsgICAgICAgICAgICAgICByZXR1cm4gU0VWX1JFVF9JTlZBTElE
X1BBUkFNOwo+ICsKPiArICAgICAgIHJlcV9wZm4gPSBnZm5fdG9fcGZuKGt2bSwgZ3BhX3RvX2dm
bihyZXFfZ3BhKSk7Cj4gKyAgICAgICBpZiAoaXNfZXJyb3Jfbm9zbG90X3BmbihyZXFfcGZuKSkK
PiArICAgICAgICAgICAgICAgcmV0dXJuIFNFVl9SRVRfSU5WQUxJRF9BRERSRVNTOwo+ICsKPiAr
ICAgICAgIHJlc3BfcGZuID0gZ2ZuX3RvX3Bmbihrdm0sIGdwYV90b19nZm4ocmVzcF9ncGEpKTsK
PiArICAgICAgIGlmIChpc19lcnJvcl9ub3Nsb3RfcGZuKHJlc3BfcGZuKSkKPiArICAgICAgICAg
ICAgICAgcmV0dXJuIFNFVl9SRVRfSU5WQUxJRF9BRERSRVNTOwo+ICsKPiArICAgICAgIGlmIChy
bXBfbWFrZV9wcml2YXRlKHJlc3BfcGZuLCAwLCBQR19MRVZFTF80SywgMCwgdHJ1ZSkpCj4gKyAg
ICAgICAgICAgICAgIHJldHVybiBTRVZfUkVUX0lOVkFMSURfQUREUkVTUzsKPiArCj4gKyAgICAg
ICBkYXRhLT5nY3R4X3BhZGRyID0gX19wc3BfcGEoc2V2LT5zbnBfY29udGV4dCk7Cj4gKyAgICAg
ICBkYXRhLT5yZXFfcGFkZHIgPSBfX3NtZV9zZXQocmVxX3BmbiA8PCBQQUdFX1NISUZUKTsKPiAr
ICAgICAgIGRhdGEtPnJlc19wYWRkciA9IF9fc21lX3NldChyZXNwX3BmbiA8PCBQQUdFX1NISUZU
KTsKPiArCj4gKyAgICAgICByZXR1cm4gMDsKPiArfQo+ICsKPiArc3RhdGljIHZvaWQgc25wX2Ns
ZWFudXBfZ3Vlc3RfYnVmKHN0cnVjdCBzZXZfZGF0YV9zbnBfZ3Vlc3RfcmVxdWVzdCAqZGF0YSwg
dW5zaWduZWQgbG9uZyAqcmMpCj4gK3sKPiArICAgICAgIHU2NCBwZm4gPSBfX3NtZV9jbHIoZGF0
YS0+cmVzX3BhZGRyKSA+PiBQQUdFX1NISUZUOwo+ICsgICAgICAgaW50IHJldDsKPiArCj4gKyAg
ICAgICByZXQgPSBzbnBfcGFnZV9yZWNsYWltKHBmbik7Cj4gKyAgICAgICBpZiAocmV0KQo+ICsg
ICAgICAgICAgICAgICAqcmMgPSBTRVZfUkVUX0lOVkFMSURfQUREUkVTUzsKPiArCj4gKyAgICAg
ICByZXQgPSBybXBfbWFrZV9zaGFyZWQocGZuLCBQR19MRVZFTF80Syk7Cj4gKyAgICAgICBpZiAo
cmV0KQo+ICsgICAgICAgICAgICAgICAqcmMgPSBTRVZfUkVUX0lOVkFMSURfQUREUkVTUzsKPiAr
fQo+ICsKPiArc3RhdGljIHZvaWQgc25wX2hhbmRsZV9ndWVzdF9yZXF1ZXN0KHN0cnVjdCB2Y3B1
X3N2bSAqc3ZtLCBncGFfdCByZXFfZ3BhLCBncGFfdCByZXNwX2dwYSkKPiArewo+ICsgICAgICAg
c3RydWN0IHNldl9kYXRhX3NucF9ndWVzdF9yZXF1ZXN0IGRhdGEgPSB7MH07Cj4gKyAgICAgICBz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUgPSAmc3ZtLT52Y3B1Owo+ICsgICAgICAgc3RydWN0IGt2bSAq
a3ZtID0gdmNwdS0+a3ZtOwo+ICsgICAgICAgc3RydWN0IGt2bV9zZXZfaW5mbyAqc2V2Owo+ICsg
ICAgICAgdW5zaWduZWQgbG9uZyByYzsKPiArICAgICAgIGludCBlcnI7Cj4gKwo+ICsgICAgICAg
aWYgKCFzZXZfc25wX2d1ZXN0KHZjcHUtPmt2bSkpIHsKPiArICAgICAgICAgICAgICAgcmMgPSBT
RVZfUkVUX0lOVkFMSURfR1VFU1Q7Cj4gKyAgICAgICAgICAgICAgIGdvdG8gZV9mYWlsOwo+ICsg
ICAgICAgfQo+ICsKPiArICAgICAgIHNldiA9ICZ0b19rdm1fc3ZtKGt2bSktPnNldl9pbmZvOwo+
ICsKPiArICAgICAgIG11dGV4X2xvY2soJnNldi0+Z3Vlc3RfcmVxX2xvY2spOwo+ICsKPiArICAg
ICAgIHJjID0gc25wX3NldHVwX2d1ZXN0X2J1Zihzdm0sICZkYXRhLCByZXFfZ3BhLCByZXNwX2dw
YSk7Cj4gKyAgICAgICBpZiAocmMpCj4gKyAgICAgICAgICAgICAgIGdvdG8gdW5sb2NrOwo+ICsK
PiArICAgICAgIHJjID0gc2V2X2lzc3VlX2NtZChrdm0sIFNFVl9DTURfU05QX0dVRVNUX1JFUVVF
U1QsICZkYXRhLCAmZXJyKTsKPiArICAgICAgIGlmIChyYykKPiArICAgICAgICAgICAgICAgLyog
dXNlIHRoZSBmaXJtd2FyZSBlcnJvciBjb2RlICovCj4gKyAgICAgICAgICAgICAgIHJjID0gZXJy
OwoKClRoZXJlIGFyZSBjYXNlcyB3aGVyZSBzZXZfaXNzdWVfY21kIGNhbiBmYWlsLCBidXQgbm90
IHNldCBlcnIuIEZvciAKZXhhbXBsZSwgd2hlbiB0aGUgZmlsZSBkZXNjcmlwdG9yIGlzIGluY29y
cmVjdC4gSW4gdGhhdCBjYXNlLCB0aGlzIGNvZGUgCnBhdGggbGVha3MgdW5pbml0aWFsaXplZCBz
dGF0ZSBmcm9tIHRoZSBob3N0IHN0YWNrIChlcnIpIGFsbCB0aGUgd2F5IAppbnRvIGEgZ3Vlc3Qu
CgoKQWxleAoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNl
bnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxh
ZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRl
bmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcg
ODc5CgoK

