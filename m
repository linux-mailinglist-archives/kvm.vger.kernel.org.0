Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59666606A0B
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 23:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiJTVHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 17:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJTVHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 17:07:02 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B75821CD50
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 14:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666300022; x=1697836022;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zlT60H8qCV2hTBu//FILjjs7ZK1m/No0L1KsLeY5nbU=;
  b=YMK+7A/WUVZh4j/VZNoyUsSjSupFB/61Gd6yzFF/pLdm/kpFZm1Zff1u
   06lnnRyfOhfvKAOj2PpLXiyxeuXrgK3ZtODt/0F2/3Klge0QJcKyPwOaR
   IhNb2Y9ReGX4YQ4xMxRJ3eLdCfoCWrk7HhNgAenO8b9bB1Jn8ucSlPXSD
   U=;
X-IronPort-AV: E=Sophos;i="5.95,199,1661817600"; 
   d="scan'208";a="271786421"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 21:06:56 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com (Postfix) with ESMTPS id 638E441732;
        Thu, 20 Oct 2022 21:06:55 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 20 Oct 2022 21:06:55 +0000
Received: from [10.95.67.64] (10.43.161.58) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.15; Thu, 20 Oct
 2022 21:06:53 +0000
Message-ID: <cdaf34bc-b2ab-1a9d-22d0-3d9dc3364bf2@amazon.com>
Date:   Thu, 20 Oct 2022 23:06:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        <kvm@vger.kernel.org>, Xiao Guangrong <guangrong.xiao@gmail.com>,
        "Chandrasekaran, Siddharth" <sidcha@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190813100458.70b7d82d@x1.home>
 <20190813170440.GC13991@linux.intel.com> <20190813115737.5db7d815@x1.home>
 <20190813133316.6fc6f257@x1.home> <20190813201914.GI13991@linux.intel.com>
 <20190815092324.46bb3ac1@x1.home>
 <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
 <20190820200318.GA15808@linux.intel.com>
 <20200626173250.GD6583@linux.intel.com>
 <590c9312-a21f-8569-9da3-34508300afcc@amazon.com>
 <Y1GxnGo3A8UF3iTt@google.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <Y1GxnGo3A8UF3iTt@google.com>
X-Originating-IP: [10.43.161.58]
X-ClientProxiedBy: EX13D45UWA004.ant.amazon.com (10.43.160.151) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDIwLjEwLjIyIDIyOjM3LCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOgo+IE9uIFRodSwg
T2N0IDIwLCAyMDIyLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4gT24gMjYuMDYuMjAgMTk6MzIs
IFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4+PiAvY2FzdCA8dGhyZWFkIG5lY3JvbWFuY3k+
Cj4+Pgo+Pj4gT24gVHVlLCBBdWcgMjAsIDIwMTkgYXQgMDE6MDM6MTlQTSAtMDcwMCwgU2VhbiBD
aHJpc3RvcGhlcnNvbiB3cm90ZToKPj4gWy4uLl0KPj4KPj4+IEkgZG9uJ3QgdGhpbmsgYW55IG9m
IHRoaXMgZXhwbGFpbnMgdGhlIHBhc3MtdGhyb3VnaCBHUFUgaXNzdWUuICBCdXQsIHdlCj4+PiBo
YXZlIGEgZmV3IHVzZSBjYXNlcyB3aGVyZSB6YXBwaW5nIHRoZSBlbnRpcmUgTU1VIGlzIHVuZGVz
aXJhYmxlLCBzbyBJJ20KPj4+IGdvaW5nIHRvIHJldHJ5IHVwc3RyZWFtaW5nIHRoaXMgcGF0Y2gg
YXMgd2l0aCBwZXItVk0gb3B0LWluLiAgSSB3YW50ZWQgdG8KPj4+IHNldCB0aGUgcmVjb3JkIHN0
cmFpZ2h0IGZvciBwb3N0ZXJpdHkgYmVmb3JlIGRvaW5nIHNvLgo+PiBIZXkgU2VhbiwKPj4KPj4g
RGlkIHlvdSBldmVyIGdldCBhcm91bmQgdG8gdXBzdHJlYW0gb3IgcmV3b3JrIHRoZSB6YXAgb3B0
aW1pemF0aW9uPyBUaGUgd2F5Cj4+IEkgcmVhZCBjdXJyZW50IHVwc3RyZWFtLCBhIG1lbXNsb3Qg
Y2hhbmdlIHN0aWxsIGFsd2F5cyB3aXBlcyBhbGwgU1BURXMsIG5vdAo+PiBvbmx5IHRoZSBvbmVz
IHRoYXQgd2VyZSBjaGFuZ2VkLgo+IE5vcGUsIEkndmUgbW9yZSBvciBsZXNzIGdpdmVuIHVwIGhv
cGUgb24gemFwcGluZyBvbmx5IHRoZSBkZWxldGVkL21vdmVkIG1lbXNsb3QuCj4gVERYIChhbmQg
U05QPykgd2lsbCBwcmVzZXJ2ZSBTUFRFcyBmb3IgZ3Vlc3QgcHJpdmF0ZSBtZW1vcnksIGJ1dCB0
aGV5J3JlIHZlcnkKPiBtdWNoIGEgc3BlY2lhbCBjYXNlLgo+Cj4gRG8geW91IGhhdmUgdXNlIGNh
c2UgYW5kL29yIGlzc3VlIHRoYXQgZG9lc24ndCBwbGF5IG5pY2Ugd2l0aCB0aGUgInphcCBhbGwi
IGJlaGF2aW9yPwoKClllYWgsIHdlJ3JlIGxvb2tpbmcgYXQgYWRkaW5nIHN1cHBvcnQgZm9yIHRo
ZSBIeXBlci1WIFZTTSBleHRlbnNpb25zIAp3aGljaCBXaW5kb3dzIHVzZXMgdG8gaW1wbGVtZW50
IENyZWRlbnRpYWwgR3VhcmQuIFdpdGggdGhhdCwgdGhlIGd1ZXN0IApnZXRzIGFjY2VzcyB0byBo
eXBlcmNhbGxzIHRoYXQgYWxsb3cgaXQgdG8gc2V0IHJlZHVjZWQgcGVybWlzc2lvbnMgZm9yIAph
cmJpdHJhcnkgZ2Zucy4gVG8gZW5zdXJlIHRoYXQgdXNlciBzcGFjZSBoYXMgZnVsbCB2aXNpYmls
aXR5IGludG8gdGhvc2UgCmZvciBsaXZlIG1pZ3JhdGlvbiwgbWVtb3J5IHNsb3RzIHRvIG1vZGVs
IGFjY2VzcyB3b3VsZCBiZSBhIGdyZWF0IGZpdC4gCkJ1dCBpdCBtZWFucyB3ZSdkIGRvIH4xMDBr
IG1lbXNsb3QgbW9kaWZpY2F0aW9ucyBvbiBib290LgoKCkFsZXgKCgoKCgpBbWF6b24gRGV2ZWxv
cG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2Vz
Y2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5n
ZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIK
U2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

