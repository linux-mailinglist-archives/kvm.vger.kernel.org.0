Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361775EF192
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 11:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbiI2JNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 05:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235728AbiI2JNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 05:13:13 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F711449E1;
        Thu, 29 Sep 2022 02:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664442767; x=1695978767;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gbX7+1PHfMiTfg5A2mAeVk2kLj1W8TIaBDtUydjsZQ8=;
  b=MVFn1kVR7s9OyB5fKU6YjBHRT4M40Gg+IvtzF7tyCLl0G1pFibuFcVk/
   G/GXh0JBB6QfBbM+aenFW89WLOPLG2DFs9DCcawJrV0dRFkU7HTgMBgEu
   byXx42Kb03q9B1S6KYTZYUK8rfxPgnultG1Qy9pbFrQC5tMgnszib33JL
   U=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-9a235a16.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 09:12:24 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-9a235a16.us-east-1.amazon.com (Postfix) with ESMTPS id 446D78015E;
        Thu, 29 Sep 2022 09:12:18 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 29 Sep 2022 09:12:17 +0000
Received: from [10.95.64.54] (10.43.160.111) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.12; Thu, 29 Sep
 2022 09:12:11 +0000
Message-ID: <1f1beb97-2a36-dcc0-f09a-59af19663ae2@amazon.com>
Date:   Thu, 29 Sep 2022 10:12:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.0
Subject: Re: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
Content-Language: en-US
To:     Ajay Kaher <akaher@vmware.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        "er.ajay.kaher@gmail.com" <er.ajay.kaher@gmail.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "Nadav Amit" <namit@vmware.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jailhouse-dev@googlegroups.com" <jailhouse-dev@googlegroups.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "acrn-dev@lists.projectacrn.org" <acrn-dev@lists.projectacrn.org>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <9FEC6622-780D-41E6-B7CA-8D39EDB2C093@vmware.com>
 <87zgf3pfd1.fsf@redhat.com> <B64FD502-E794-4E94-A267-D690476C57EE@vmware.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <B64FD502-E794-4E94-A267-D690476C57EE@vmware.com>
X-Originating-IP: [10.43.160.111]
X-ClientProxiedBy: EX13D23UWA004.ant.amazon.com (10.43.160.72) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDI5LjA5LjIyIDA3OjM2LCBBamF5IEthaGVyIHdyb3RlOgo+PiDvu79PbiAxMy8wOS8yMiwg
NzowNSBQTSwgIlZpdGFseSBLdXpuZXRzb3YiIDx2a3V6bmV0c0ByZWRoYXQuY29tPiB3cm90ZToK
Pj4+IFRoYW5rcyBWaXRhbHkgZm9yIHlvdXIgcmVzcG9uc2UuCj4+Pgo+Pj4gMS4gd2UgaGF2ZSBt
dWx0aXBsZSBvYmplY3RzIG9mIHN0cnVjdCBwY2lfcmF3X29wcywgMi4gYWRkaW5nICdwcmlvcml0
eScgZmllbGQgdG8gc3RydWN0IHBjaV9yYXdfb3BzCj4+PiBkb2Vzbid0IHNlZW1zIHRvIGJlIGFw
cHJvcHJpYXRlIGFzIG5lZWQgdG8gdGFrZSBkZWNpc2lvbiB3aGljaCBvYmplY3Qgb2Ygc3RydWN0
IHBjaV9yYXdfb3BzIGhhcwo+Pj4gdG8gYmUgdXNlZCwgbm90IHNvbWV0aGluZyB3aXRoLWluIHN0
cnVjdCBwY2lfcmF3X29wcy4KPj4gSSdtIG5vdCBzdXJlIEkgZm9sbG93LCB5b3UgaGF2ZSB0d28g
aW5zdGFuY2VzIG9mICdzdHJ1Y3QgcGNpX3Jhd19vcHMnCj4+IHdoaWNoIGFyZSBjYWxsZWQgJ3Jh
d19wY2lfb3BzJyBhbmQgJ3Jhd19wY2lfZXh0X29wcycuIFdoYXQgaWYgeW91IGRvCj4+IHNvbWV0
aGluZyBsaWtlIChjb21wbGV0ZWx5IHVudGVzdGVkKToKPj4KPj4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL3BjaV94ODYuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BjaV94ODYu
aAo+PiBpbmRleCA3MDUzM2ZkY2JmMDIuLmZiODI3MGZhNmM3OCAxMDA2NDQKPj4gLS0tIGEvYXJj
aC94ODYvaW5jbHVkZS9hc20vcGNpX3g4Ni5oCj4+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNt
L3BjaV94ODYuaAo+PiBAQCAtMTE2LDYgKzExNiw3IEBAIGV4dGVybiB2b2lkICgqcGNpYmlvc19k
aXNhYmxlX2lycSkoc3RydWN0IHBjaV9kZXYgKmRldik7Cj4+IGV4dGVybiBib29sIG1wX3Nob3Vs
ZF9rZWVwX2lycShzdHJ1Y3QgZGV2aWNlICpkZXYpOwo+Pgo+PiBzdHJ1Y3QgcGNpX3Jhd19vcHMg
ewo+PiArICAgICAgIGludCByYXRpbmc7Cj4+ICAgICAgICAgICBpbnQgKCpyZWFkKSh1bnNpZ25l
ZCBpbnQgZG9tYWluLCB1bnNpZ25lZCBpbnQgYnVzLCB1bnNpZ25lZCBpbnQgZGV2Zm4sCj4+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCByZWcsIGlu
dCBsZW4sIHUzMiAqdmFsKTsKPj4gICAgICAgICAgIGludCAoKndyaXRlKSh1bnNpZ25lZCBpbnQg
ZG9tYWluLCB1bnNpZ25lZCBpbnQgYnVzLCB1bnNpZ25lZCBpbnQgZGV2Zm4sCj4+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9wY2kvY29tbW9uLmMgYi9hcmNoL3g4Ni9wY2kvY29tbW9uLmMKPj4gaW5k
ZXggZGRiNzk4NjAzMjAxLi5lOTk2NWZkMTE1NzYgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gveDg2L3Bj
aS9jb21tb24uYwo+PiArKysgYi9hcmNoL3g4Ni9wY2kvY29tbW9uLmMKPj4gQEAgLTQwLDcgKzQw
LDggQEAgY29uc3Qgc3RydWN0IHBjaV9yYXdfb3BzICpfX3JlYWRfbW9zdGx5IHJhd19wY2lfZXh0
X29wczsKPj4gICBpbnQgcmF3X3BjaV9yZWFkKHVuc2lnbmVkIGludCBkb21haW4sIHVuc2lnbmVk
IGludCBidXMsIHVuc2lnbmVkIGludCBkZXZmbiwKPj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGludCByZWcsIGludCBsZW4sIHUzMiAqdmFsKQo+PiB7
Cj4+IC0gICAgICAgaWYgKGRvbWFpbiA9PSAwICYmIHJlZyA8IDI1NiAmJiByYXdfcGNpX29wcykK
Pj4gKyAgICAgICBpZiAoZG9tYWluID09IDAgJiYgcmVnIDwgMjU2ICYmIHJhd19wY2lfb3BzICYm
Cj4+ICsgICAgICAgICAgICghcmF3X3BjaV9leHRfb3BzIHx8IHJhd19wY2lfZXh0X29wcy0+cmF0
aW5nIDw9IHJhd19wY2lfb3BzLT5yYXRpbmcpKQo+PiAgICAgICAgICAgICAgICAgIHJldHVybiBy
YXdfcGNpX29wcy0+cmVhZChkb21haW4sIGJ1cywgZGV2Zm4sIHJlZywgbGVuLCB2YWwpOwo+PiAg
ICAgICAgICBpZiAocmF3X3BjaV9leHRfb3BzKQo+PiAgICAgICAgICAgICAgICAgIHJldHVybiBy
YXdfcGNpX2V4dF9vcHMtPnJlYWQoZG9tYWluLCBidXMsIGRldmZuLCByZWcsIGxlbiwgdmFsKTsK
Pj4gQEAgLTUwLDcgKzUxLDggQEAgaW50IHJhd19wY2lfcmVhZCh1bnNpZ25lZCBpbnQgZG9tYWlu
LCB1bnNpZ25lZCBpbnQgYnVzLCB1bnNpZ25lZCBpbnQgZGV2Zm4sCj4+ICAgaW50IHJhd19wY2lf
d3JpdGUodW5zaWduZWQgaW50IGRvbWFpbiwgdW5zaWduZWQgaW50IGJ1cywgdW5zaWduZWQgaW50
IGRldmZuLAo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgaW50IHJlZywgaW50IGxlbiwgdTMyIHZhbCkKPj4gewo+PiAtICAgICAgIGlmIChkb21haW4g
PT0gMCAmJiByZWcgPCAyNTYgJiYgcmF3X3BjaV9vcHMpCj4+ICsgICAgICAgaWYgKGRvbWFpbiA9
PSAwICYmIHJlZyA8IDI1NiAmJiByYXdfcGNpX29wcyAmJgo+PiArICAgICAgICAgICAoIXJhd19w
Y2lfZXh0X29wcyB8fCByYXdfcGNpX2V4dF9vcHMtPnJhdGluZyA8PSByYXdfcGNpX29wcy0+cmF0
aW5nKSkKPj4gICAgICAgICAgICAgICAgICByZXR1cm4gcmF3X3BjaV9vcHMtPndyaXRlKGRvbWFp
biwgYnVzLCBkZXZmbiwgcmVnLCBsZW4sIHZhbCk7Cj4+ICAgICAgICAgICBpZiAocmF3X3BjaV9l
eHRfb3BzKQo+PiAgICAgICAgICAgICAgICAgIHJldHVybiByYXdfcGNpX2V4dF9vcHMtPndyaXRl
KGRvbWFpbiwgYnVzLCBkZXZmbiwgcmVnLCBsZW4sIHZhbCk7Cj4+Cj4+IGFuZCB0aGVuIHNvbWV3
aGVyZSBpbiBWbXdhcmUgaHlwZXJ2aXNvciBpbml0aWFsaXphdGlvbiBjb2RlCj4+IChhcmNoL3g4
Ni9rZXJuZWwvY3B1L3Ztd2FyZS5jKSB5b3UgZG8KPj4KPj4gICByYXdfcGNpX2V4dF9vcHMtPnJh
dGluZyA9IDEwMDsKPiBUaGFua3MgVml0YWx5LCBmb3IgeW91ciByZXZpZXcgYW5kIGhlbHBpbmcg
dXMgdG8gaW1wcm92ZSB0aGUgY29kZS4KPgo+IEkgd2FzIHdvcmtpbmcgdG8gbWFrZSBjaGFuZ2Vz
IGFzIHlvdSBzdWdnZXN0ZWQsIGJ1dCBiZWZvcmUgc2VuZGluZyB2MyB3b3VsZCBsaWtlIHRvCj4g
ZGlzY3VzcyBvbiBmb2xsb3dpbmc6Cj4KPiBJZiB3ZSBhZGQgcmF0aW5nIHdpdGgtaW4gc3RydWN0
IHBjaV9yYXdfb3BzIHRoZW4gd2UgY2FuJ3QgaGF2ZSBwY2lfbW1jZmcgYXMgY29uc3QsCj4gYW5k
IGZvbGxvd2luZyBjaGFuZ2UgaXMgbXVzdCBpbiBhcmNoL3g4Ni9wY2kvbW1jb25maWdfNjQuYzoK
Pgo+IC1jb25zdCBzdHJ1Y3QgcGNpX3Jhd19vcHMgcGNpX21tY2ZnID0gewo+ICtzdHJ1Y3QgcGNp
X3Jhd19vcHMgcGNpX21tY2ZnID0gewo+ICAgICAgICAgIC5yZWFkID0gICAgICAgICBwY2lfbW1j
ZmdfcmVhZCwKPiAgICAgICAgICAud3JpdGUgPSAgICAgICAgcGNpX21tY2ZnX3dyaXRlLAo+IH07
Cj4KPiBTbyB0byBhdm9pZCB0aGlzIGNoYW5nZSwgaXMgaXQgZmluZSB0byBoYXZlIGdsb2JhbCBi
b29sIHByZWZlcl9yYXdfcGNpX2V4dF9vcHM/Cj4KPiBBbmQgcmF3X3BjaV9yZWFkKCkgd2lsbCBo
YXZlIGZvbGxvd2luZyBjaGFuZ2U6Cj4KPiAtICAgICAgIGlmIChkb21haW4gPT0gMCAmJiByZWcg
PCAyNTYgJiYgcmF3X3BjaV9vcHMpCj4gKyAgICAgICBpZiAoZG9tYWluID09IDAgJiYgcmVnIDwg
MjU2ICYmIHJhd19wY2lfb3BzICYmCj4gKyAgICAgICAgICAgICghcHJlZmVyX3Jhd19wY2lfZXh0
X29wcyB8fCAgIXJhd19wY2lfZXh0X29wcykKPgo+PiB3aHkgd291bGRuJ3QgaXQgd29yaz8KPj4K
Pj4gKGRpY2xhaW1lcjogY29tcGxldGVseSB1bnRlc3RlZCwgcmF3X3BjaV9vcHMvcmF3X3BjaV9l
eHRfb3BzCj4+IGluaXRpYWxpemF0aW9uIGhhcyB0byBiZSBjaGVja2VkIHNvICdyYXRpbmcnIGlz
IG5vdCBnYXJiYWdlKS4KPj4KPj4+IEl0J3MgYSBnZW5lcmljIHNvbHV0aW9uIGZvciBhbGwgaHlw
ZXJ2aXNvciAoc29ycnkgZm9yIGVhcmxpZXIgd3JvbmcKPj4+IFN1YmplY3QpLCBub3Qgc3BlY2lm
aWMgdG8gVk13YXJlLiBGdXJ0aGVyIGxvb2tpbmcgZm9yIGZlZWRiYWNrIGlmIGl0J3MKPj4+IGlt
cGFjdGluZyB0byBhbnkgaHlwZXJ2aXNvci4KPj4gVGhhdCdzIHRoZSB0cmlja3kgcGFydC4gV2Ug
Y2FuIGNoZWNrIG1vZGVybiBoeXBlcnZpc29yIHZlcnNpb25zLCBidXQKPj4gd2hhdCBhYm91dCBh
bGwgb3RoZXIgdmVyc2lvbnMgaW4gZXhpc3RlbmNlPyBIb3cgY2FuIHdlIGtub3cgdGhhdCB0aGVy
ZSdzCj4+IG5vIFFFTVUvSHlwZXItVi8uLi4gdmVyc2lvbiBvdXQgdGhlcmUgd2hlcmUgTU1JTyBw
YXRoIGlzIGJyb2tlbj8gSSdkCj4+IHN1Z2dlc3Qgd2UgbGltaXQgdGhlIGNoYW5nZSB0byBWbXdh
cmUgaHlwZXJ2aXNvciwgb3RoZXIgaHlwZXJ2aXNvcnMgbWF5Cj4+IHVzZSB0aGUgc2FtZSBtZWNo
YW5pc20gKGxpa2UgdGhlIG9uZSBhYm92ZSkgbGF0ZXIgKGJ1dCB0aGUgcGVyc29uCj4+IHN1Z2dl
c3RpbmcgdGhlIHBhdGNoIGlzIGFsd2F5cyByZXNwb25zaWJsZSBmb3IgdGhlIHJlc2VhcmNoIHdo
eSBpdCBpcwo+PiBzYWZlIHRvIGRvIHNvKS4KPiBPaywgYXMgb2Ygbm93IHdlIHdpbGwgbWFrZSB0
aGlzIGNoYW5nZSBzcGVjaWZpYyB0byBWTXdhcmUgaHlwZXJ2aXNvci4KCgpJcyB0aGVyZSBhIHdh
eSB3ZSBjYW4gbWFrZSBpdCBhbiBBQ1BJIHByb3BlcnR5IGluIE1DRkcgdG8gaGF2ZSB0aGUgCmVu
dmlyb25tZW50IHNlbGYtZGVzY3JpYmUgdGhlIGZhY3QgdGhhdCBpdCdzIHNhZmUgdG8gZG8gRUNB
TSBhY2Nlc3MgZm9yIApjb25maWcgc3BhY2UgYWNjZXNzIG92ZXIgbGVnYWN5IFBJTz8gVGhhdCB3
YXkgd2UgZG9uJ3QgbmVlZCB0byBwYXRjaCAKZ3Vlc3RzIGV2ZXJ5IHRpbWUgYSBoeXBlcnZpc29y
IGRlY2lkZXMgdGhhdCBpdCdzIHNhZmUgdG8gcHJlZmVyIEVDQU0uCgpBbHNvLCBNaWNoYWVsIChD
QydlZCkgbWVudGlvbmVkIHRoYXQgYWNjb3JkaW5nIHRvIHNwZWMsIHlvdXIgUENJZSBob3N0IApi
cmlkZ2Ugd2l0aCBQQ0lfQ09NTUFORC5NRU1PUlk9MCB3b3VsZCBzdG9wIHJlc3BvbmRpbmcgdG8g
aXRzIEVDQU0gCndpbmRvdy4gR2l2ZW4gdGhhdCBtb3N0IEFSTSBzeXN0ZW1zIGhhdmUgbm8gUElP
IGZhbGxiYWNrIHBhdGgsIHdlIHdhbnQgCnRvIG1ha2Ugc3VyZSB3ZSBuZXZlciBoaXQgdGhhdCBj
b25kaXRpb24uCgoKQWxleAoKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBH
bWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlz
dGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0
IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBE
RSAyODkgMjM3IDg3OQoKCg==

