Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C477A609A3D
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 08:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJXGMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 02:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiJXGMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 02:12:31 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AAB5E315
        for <kvm@vger.kernel.org>; Sun, 23 Oct 2022 23:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666591950; x=1698127950;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BADtGQ7u8e0Lxgh8LFM/Un5uYcBXmIXp2bLkFxnJCUM=;
  b=YsT8H1t225uRjGPjIHHt0jjjOEbISX2KbdIpzFt12jVithGfExsn7y24
   wZUCsF/IKMs6ajpISo+FLI6MhjUAYxNqhVwjbhfc8c/5086J2+UOZKm1y
   VtoYoG1edR1i/A8m6ky01kh6WzAUggKf8zEnSV8aV4TufxvQX0EstRDDJ
   A=;
X-IronPort-AV: E=Sophos;i="5.95,207,1661817600"; 
   d="scan'208";a="143498965"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 06:12:27 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com (Postfix) with ESMTPS id 262CE60B15;
        Mon, 24 Oct 2022 06:12:27 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 24 Oct 2022 06:12:26 +0000
Received: from [10.95.66.166] (10.43.160.223) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.15; Mon, 24 Oct
 2022 06:12:24 +0000
Message-ID: <490509f6-ae1a-4fc8-42a1-b037d6bffada@amazon.com>
Date:   Mon, 24 Oct 2022 08:12:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.0
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
To:     Sean Christopherson <seanjc@google.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        <kvm@vger.kernel.org>, Xiao Guangrong <guangrong.xiao@gmail.com>,
        "Chandrasekaran, Siddharth" <sidcha@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190813115737.5db7d815@x1.home>
 <20190813133316.6fc6f257@x1.home> <20190813201914.GI13991@linux.intel.com>
 <20190815092324.46bb3ac1@x1.home>
 <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
 <20190820200318.GA15808@linux.intel.com>
 <20200626173250.GD6583@linux.intel.com>
 <590c9312-a21f-8569-9da3-34508300afcc@amazon.com>
 <Y1GxnGo3A8UF3iTt@google.com>
 <cdaf34bc-b2ab-1a9d-22d0-3d9dc3364bf2@amazon.com>
 <Y1L1t6Qw2CaLwJk3@google.com>
Content-Language: en-US
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <Y1L1t6Qw2CaLwJk3@google.com>
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGV5IFNlYW4sCgpPbiAyMS4xMC4yMiAyMTo0MCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToK
Pgo+IE9uIFRodSwgT2N0IDIwLCAyMDIyLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4gT24gMjAu
MTAuMjIgMjI6MzcsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4+PiBPbiBUaHUsIE9jdCAy
MCwgMjAyMiwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Pj4gT24gMjYuMDYuMjAgMTk6MzIsIFNl
YW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4+Pj4+IC9jYXN0IDx0aHJlYWQgbmVjcm9tYW5jeT4K
Pj4+Pj4KPj4+Pj4gT24gVHVlLCBBdWcgMjAsIDIwMTkgYXQgMDE6MDM6MTlQTSAtMDcwMCwgU2Vh
biBDaHJpc3RvcGhlcnNvbiB3cm90ZToKPj4+PiBbLi4uXQo+Pj4+Cj4+Pj4+IEkgZG9uJ3QgdGhp
bmsgYW55IG9mIHRoaXMgZXhwbGFpbnMgdGhlIHBhc3MtdGhyb3VnaCBHUFUgaXNzdWUuICBCdXQs
IHdlCj4+Pj4+IGhhdmUgYSBmZXcgdXNlIGNhc2VzIHdoZXJlIHphcHBpbmcgdGhlIGVudGlyZSBN
TVUgaXMgdW5kZXNpcmFibGUsIHNvIEknbQo+Pj4+PiBnb2luZyB0byByZXRyeSB1cHN0cmVhbWlu
ZyB0aGlzIHBhdGNoIGFzIHdpdGggcGVyLVZNIG9wdC1pbi4gIEkgd2FudGVkIHRvCj4+Pj4+IHNl
dCB0aGUgcmVjb3JkIHN0cmFpZ2h0IGZvciBwb3N0ZXJpdHkgYmVmb3JlIGRvaW5nIHNvLgo+Pj4+
IEhleSBTZWFuLAo+Pj4+Cj4+Pj4gRGlkIHlvdSBldmVyIGdldCBhcm91bmQgdG8gdXBzdHJlYW0g
b3IgcmV3b3JrIHRoZSB6YXAgb3B0aW1pemF0aW9uPyBUaGUgd2F5Cj4+Pj4gSSByZWFkIGN1cnJl
bnQgdXBzdHJlYW0sIGEgbWVtc2xvdCBjaGFuZ2Ugc3RpbGwgYWx3YXlzIHdpcGVzIGFsbCBTUFRF
cywgbm90Cj4+Pj4gb25seSB0aGUgb25lcyB0aGF0IHdlcmUgY2hhbmdlZC4KPj4+IE5vcGUsIEkn
dmUgbW9yZSBvciBsZXNzIGdpdmVuIHVwIGhvcGUgb24gemFwcGluZyBvbmx5IHRoZSBkZWxldGVk
L21vdmVkIG1lbXNsb3QuCj4+PiBURFggKGFuZCBTTlA/KSB3aWxsIHByZXNlcnZlIFNQVEVzIGZv
ciBndWVzdCBwcml2YXRlIG1lbW9yeSwgYnV0IHRoZXkncmUgdmVyeQo+Pj4gbXVjaCBhIHNwZWNp
YWwgY2FzZS4KPj4+Cj4+PiBEbyB5b3UgaGF2ZSB1c2UgY2FzZSBhbmQvb3IgaXNzdWUgdGhhdCBk
b2Vzbid0IHBsYXkgbmljZSB3aXRoIHRoZSAiemFwIGFsbCIgYmVoYXZpb3I/Cj4+Cj4+IFllYWgs
IHdlJ3JlIGxvb2tpbmcgYXQgYWRkaW5nIHN1cHBvcnQgZm9yIHRoZSBIeXBlci1WIFZTTSBleHRl
bnNpb25zIHdoaWNoCj4+IFdpbmRvd3MgdXNlcyB0byBpbXBsZW1lbnQgQ3JlZGVudGlhbCBHdWFy
ZC4gV2l0aCB0aGF0LCB0aGUgZ3Vlc3QgZ2V0cyBhY2Nlc3MKPj4gdG8gaHlwZXJjYWxscyB0aGF0
IGFsbG93IGl0IHRvIHNldCByZWR1Y2VkIHBlcm1pc3Npb25zIGZvciBhcmJpdHJhcnkgZ2Zucy4K
Pj4gVG8gZW5zdXJlIHRoYXQgdXNlciBzcGFjZSBoYXMgZnVsbCB2aXNpYmlsaXR5IGludG8gdGhv
c2UgZm9yIGxpdmUgbWlncmF0aW9uLAo+PiBtZW1vcnkgc2xvdHMgdG8gbW9kZWwgYWNjZXNzIHdv
dWxkIGJlIGEgZ3JlYXQgZml0LiBCdXQgaXQgbWVhbnMgd2UnZCBkbwo+PiB+MTAwayBtZW1zbG90
IG1vZGlmaWNhdGlvbnMgb24gYm9vdC4KPiBPb2YuICAxMDBrIG1lbXNsb3QgdXBkYXRlcyBpcyBn
b2luZyB0byBiZSBwYWluZnVsIGlycmVzcGVjdGl2ZSBvZiBmbHVzaGluZy4gIEFuZAo+IG1lbXNs
b3RzIChpbiB0aGVpciBjdXJyZW50IGZvcm0pIHdvbid0IHdvcmsgaWYgdGhlIGd1ZXN0IGNhbiBk
cm9wIGV4ZWN1dGFibGUKPiBwZXJtaXNzaW9ucy4KPgo+IEFzc3VtaW5nIEtWTSBuZWVkcyB0byBz
dXBwb3J0IGEgS1ZNX01FTV9OT19FWEVDIGZsYWcsIHJhdGhlciB0aGFuIHRyeWluZyB0byBzb2x2
ZQo+IHRoZSAiS1ZNIGZsdXNoZXMgZXZlcnl0aGluZyBvbiBtZW1zbG90IGRlbGV0aW9uIiwgSSB0
aGluayB3ZSBzaG91bGQgaW5zdGVhZAo+IHByb3Blcmx5IHN1cHBvcnQgdG9nZ2xpbmcgS1ZNX01F
TV9SRUFET05MWSAoYW5kIEtWTV9NRU1fTk9fRVhFQykgd2l0aG91dCBmb3JjaW5nCj4gdXNlcnNw
YWNlIHRvIGRlbGV0ZSB0aGUgbWVtc2xvdC4gIENvbW1pdCA3NWQ2MWZiY2Y1NjMgKCJLVk06IHNl
dF9tZW1vcnlfcmVnaW9uOgoKClRoYXQgd291bGQgYmUgYSBjdXRlIGFjY2VsZXJhdGlvbiBmb3Ig
dGhlIGNhc2Ugd2hlcmUgd2UgaGF2ZSB0byBjaGFuZ2UgCnBlcm1pc3Npb25zIGZvciBhIGZ1bGwg
c2xvdC4gVW5mb3J0dW5hdGVseSwgdGhlIGJ1bGsgb2YgdGhlIGNoYW5nZXMgYXJlIApzbG90IHNw
bGl0cy4gTGV0IG1lIGV4cGxhaW4gd2l0aCBudW1iZXJzIGZyb20gYSAxIHZjcHUsIDhHQiBXaW5k
b3dzIApTZXJ2ZXIgMjAxOSBib290OgoKR0ZOIHBlcm1pc3Npb24gbW9kaWZpY2F0aW9uIHJlcXVl
c3RzOiA0NjI5NApVbmlxdWUgR0ZOczogMjEyMDAKClRoYXQgbWVhbnMgb24gYm9vdCwgd2Ugc3Rh
cnQgb2ZmIHdpdGggYSBmZXcgaHVnZSBtZW1zbG90cyBmb3IgZ3Vlc3QgUkFNLiAKVGhlbiBkb3du
IHRoZSByb2FkLCB3ZSBuZWVkIHRvIGNoYW5nZSBwZXJtaXNzaW9ucyBmb3IgaW5kaXZpZHVhbCBw
YWdlcyAKaW5zaWRlIHRoZXNlIGxhcmdlciByZWdpb25zLiBUaGUgb2J2aW91cyBvcHRpb24gZm9y
IHRoYXQgaXMgYSBtZW1zbG90IApzcGxpdCAtIGRlbGV0ZSwgY3JlYXRlLCBjcmVhdGUsIGNyZWF0
ZS4gTm93IHdlIGhhdmUgMiBsYXJnZSBtZW1zbG90cyBhbmQgCjEgdGhhdCBvbmx5IHNwYW5zIGEg
c2luZ2xlIHBhZ2UuCgpMYXRlciBpbiB0aGUgYm9vdCBwcm9jZXNzLCBXaW5kb3dzIHRoZW4gc29t
ZSB0aW1lcyBhbHNvIHRvZ2dsZXMgCnBlcm1pc3Npb25zIGZvciBwYWdlcyB0aGF0IGl0IGFscmVh
ZHkgc3BsaXQgb2ZmIGVhcmxpZXIuIFRoYXQncyB0aGUgY2FzZSAKd2UgY2FuIG9wdGltaXplIHdp
dGggdGhlIG1vZGlmeSBvcHRpbWl6YXRpb24geW91IGRlc2NyaWJlZCBpbiB0aGUgCnByZXZpb3Vz
IGVtYWlsLiBCdXQgdGhhdCdzIG9ubHkgYWJvdXQgaGFsZiB0aGUgcmVxdWVzdHMuIFRoZSBvdGhl
ciBoYWxmIAphcmUgbWVtc2xvdCBzcGxpdCByZXF1ZXN0cy4KCldlIGFscmVhZHkgYnVpbHQgYSBw
cm90b3R5cGUgaW1wbGVtZW50YXRpb24gb2YgYW4gYXRvbWljIG1lbXNsb3QgdXBkYXRlIAppb2N0
bCB0aGF0IGFsbG93cyB1cyB0byBrZWVwIG90aGVyIHZDUFVzIHJ1bm5pbmcgd2hpbGUgd2UgZG8g
dGhlIApkZWxldGUvY3JlYXRlL2NyZWF0ZS9jcmVhdGUgb3BlcmF0aW9uLiBCdXQgZXZlbiB3aXRo
IHRoYXQsIHdlIHNlZSB1cCB0byAKMzAgbWluIGJvb3QgdGltZXMgZm9yIGxhcmdlciBndWVzdHMg
dGhhdCBtb3N0IG9mIHRoZSB0aW1lIGFyZSBzdHVjayBpbiAKemFwcGluZyBwYWdlcy4KCkkgZ3Vl
c3Mgd2UgaGF2ZSAyIG9wdGlvbnMgdG8gbWFrZSB0aGlzIHZpYWJsZToKCiDCoCAxKSBPcHRpbWl6
ZSBtZW1zbG90IHNwbGl0cyArIG1vZGlmaWNhdGlvbnMgdG8gYSBwb2ludCB3aGVyZSB0aGV5J3Jl
IApmYXN0IGVub3VnaAogwqAgMikgQWRkIGEgZGlmZmVyZW50LCBmYXN0ZXIgbWVjaGFuaXNtIG9u
IHRvcCBvZiBtZW1zbG90cyBmb3IgcGFnZSAKZ3JhbnVsYXIgcGVybWlzc2lvbiBiaXRzCgpBbHNv
IHNvcnJ5IGZvciBub3QgcG9zdGluZyB0aGUgdW5kZXJseWluZyBjcmVkZ3VhcmQgYW5kIGF0b21p
YyBtZW1zbG90IApwYXRjaGVzIHlldC4gSSB3YW50ZWQgdG8ga2ljayBvZmYgdGhpcyBjb252ZXJz
YXRpb24gYmVmb3JlIHNlbmRpbmcgdGhlbSAKb3V0IC0gdGhleSdyZSBzdGlsbCB0b28gcmF3IGZv
ciB1cHN0cmVhbSByZXZpZXcgYXRtIDopLgoKClRoYW5rcywKCkFsZXgKCgoKCkFtYXpvbiBEZXZl
bG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpH
ZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVp
bmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMg
QgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

