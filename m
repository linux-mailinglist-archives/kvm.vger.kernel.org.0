Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BB84C492A
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242215AbiBYPil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236500AbiBYPij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:38:39 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D907F14F2A6;
        Fri, 25 Feb 2022 07:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1645803487; x=1677339487;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zufo2VqoW12ZsZWjP7rvFxXLnq5dHqI9qda+WDGbeVc=;
  b=LH3E8N31LzI0vBMcwEQnj77bqKXOwFg2SK2cqy2Axa87s6jvM0GgadPN
   LUpLCWB13QUkYPzPJXgx02xEPz5Bha1NbnBkxdfAZv4XT2JJCo0DG8Kei
   h7swsUR4lDGXKc0/4BaBEDwL4224I1Kr8z/LAakbv38WPNh+SXt+aRW04
   8=;
X-IronPort-AV: E=Sophos;i="5.90,136,1643673600"; 
   d="scan'208";a="197753896"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6435a935.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 25 Feb 2022 15:37:52 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6435a935.us-west-2.amazon.com (Postfix) with ESMTPS id DD055418D1;
        Fri, 25 Feb 2022 15:37:51 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Fri, 25 Feb 2022 15:37:51 +0000
Received: from [0.0.0.0] (10.43.161.217) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.28; Fri, 25 Feb
 2022 15:37:45 +0000
Message-ID: <b6c5c4d4-88a5-1ac5-a4d4-2f6895065834@amazon.com>
Date:   Fri, 25 Feb 2022 16:37:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing RNG
 on VM fork
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>, <adrian@parity.io>
CC:     KVM list <kvm@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        <linux-hyperv@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        <ben@skyportsystems.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        "Colm MacCarthaigh" <colmmacc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        Eric Biggers <ebiggers@kernel.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Igor Mammedov" <imammedo@redhat.com>,
        Jann Horn <jannh@google.com>,
        KY Srinivasan <kys@microsoft.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "QEMU Developers" <qemu-devel@nongnu.org>,
        "Weiss, Radu" <raduweis@amazon.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Wei Liu <wei.liu@kernel.org>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
 <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
 <YhjjuMOeV7+T7thS@zx2c4.com>
 <88ebdc32-2e94-ef28-37ed-1c927c12af43@amazon.com>
 <YhjoyIUv2+18BwiR@zx2c4.com>
 <9ac68552-c1fc-22c8-13e6-4f344f85a4fb@amazon.com>
 <CAMj1kXEue6cDCSG0N7WGTVF=JYZx3jwE7EK4tCdhO-HzMtWwVw@mail.gmail.com>
 <Yhj288aE5rW15Qpj@zx2c4.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <Yhj288aE5rW15Qpj@zx2c4.com>
X-Originating-IP: [10.43.161.217]
X-ClientProxiedBy: EX13D15UWA003.ant.amazon.com (10.43.160.182) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDI1LjAyLjIyIDE2OjM0LCBKYXNvbiBBLiBEb25lbmZlbGQgd3JvdGU6Cj4gT24gRnJpLCBG
ZWIgMjUsIDIwMjIgYXQgMDQ6MTY6MjdQTSArMDEwMCwgQXJkIEJpZXNoZXV2ZWwgd3JvdGU6Cj4+
Pj4gSSBqdXN0IGJvb3RlZCB1cCBhIFdpbmRvd3MgVk0sIGFuZCBpdCBsb29rcyBsaWtlIEh5cGVy
LVYgdXNlcwo+Pj4+ICJIeXBlcl9WX0dlbl9Db3VudGVyX1YxIiwgd2hpY2ggaXMgYWxzbyBxdWl0
ZSBsb25nLCBzbyB3ZSBjYW4ndCByZWFsbHkKPj4+PiBISUQgbWF0Y2ggb24gdGhhdCBlaXRoZXIu
Cj4+Pgo+Pj4gWWVzLCBkdWUgdG8gdGhlIHNhbWUgcHJvYmxlbS4gSSdkIHJlYWxseSBwcmVmZXIg
d2Ugc29ydCBvdXQgdGhlIEFDUEkKPj4+IG1hdGNoaW5nIGJlZm9yZSB0aGlzIGdvZXMgbWFpbmxp
bmUuIE1hdGNoaW5nIG9uIF9ISUQgaXMgZXhwbGljaXRseQo+Pj4gZGlzY291cmFnZWQgaW4gdGhl
IFZNR2VuSUQgc3BlYy4KPj4+Cj4+IE9LLCB0aGlzIHJlYWxseSBzdWNrcy4gUXVvdGluZyB0aGUg
QUNQSSBzcGVjOgo+Pgo+PiAiIiIKPj4gQSBfSElEIG9iamVjdCBldmFsdWF0ZXMgdG8gZWl0aGVy
IGEgbnVtZXJpYyAzMi1iaXQgY29tcHJlc3NlZCBFSVNBCj4+IHR5cGUgSUQgb3IgYSBzdHJpbmcu
IElmIGEgc3RyaW5nLCB0aGUgZm9ybWF0IG11c3QgYmUgYW4gYWxwaGFudW1lcmljCj4+IFBOUCBv
ciBBQ1BJIElEIHdpdGggbm8gYXN0ZXJpc2sgb3Igb3RoZXIgbGVhZGluZyBjaGFyYWN0ZXJzLgo+
PiBBIHZhbGlkIFBOUCBJRCBtdXN0IGJlIG9mIHRoZSBmb3JtICJBQUEjIyMjIiB3aGVyZSBBIGlz
IGFuIHVwcGVyY2FzZQo+PiBsZXR0ZXIgYW5kICMgaXMgYSBoZXggZGlnaXQuCj4+IEEgdmFsaWQg
QUNQSSBJRCBtdXN0IGJlIG9mIHRoZSBmb3JtICJOTk5OIyMjIyIgd2hlcmUgTiBpcyBhbiB1cHBl
cmNhc2UKPj4gbGV0dGVyIG9yIGEgZGlnaXQgKCcwJy0nOScpIGFuZCAjIGlzIGEgaGV4IGRpZ2l0
LiBUaGlzIHNwZWNpZmljYXRpb24KPj4gcmVzZXJ2ZXMgdGhlIHN0cmluZyAiQUNQSSIgZm9yIHVz
ZSBvbmx5IHdpdGggZGV2aWNlcyBkZWZpbmVkIGhlcmVpbi4KPj4gSXQgZnVydGhlciByZXNlcnZl
cyBhbGwgc3RyaW5ncyByZXByZXNlbnRpbmcgNCBIRVggZGlnaXRzIGZvcgo+PiBleGNsdXNpdmUg
dXNlIHdpdGggUENJLWFzc2lnbmVkIFZlbmRvciBJRHMuCj4+ICIiIgo+Pgo+PiBTbyBub3cgd2Ug
aGF2ZSB0byBpbXBsZW1lbnQgTWljcm9zb2Z0J3MgZm9yayBvZiBBQ1BJIHRvIGJlIGFibGUgdG8g
dXNlCj4+IHRoaXMgZGV2aWNlLCBldmVuIGlmIHdlIGV4cG9zZSBpdCBmcm9tIFFFTVUgaW5zdGVh
ZCBvZiBIeXBlci1WPyBJCj4+IHN0cm9uZ2x5IG9iamVjdCB0byB0aGF0Lgo+Pgo+PiBJbnN0ZWFk
LCB3ZSBjYW4gbWF0Y2ggb24gX0hJRCBleHBvc2VkIGJ5IFFFTVUsIGFuZCBjb3JkaWFsbHkgaW52
aXRlCj4+IE1pY3Jvc29mdCB0byBhbGlnbiB0aGVpciBzcGVjIHdpdGggdGhlIEFDUEkgc3BlYy4K
PiBJIGRvbid0IGtub3cgYWJvdXQgdGhhdC4uLiBTZWVtcyBhIGJpdCBleHRyZW1lLiBIb3BlZnVs
bHkgQWxleCB3aWxsIGJlCj4gYWJsZSB0byBzb3J0IHNvbWV0aGluZyBvdXQgd2l0aCB0aGUgQUNQ
SSBwZW9wbGUsIGFuZCB0aGlzIGRyaXZlciB3aWxsCj4gd29yayBpbnNpZGUgb2YgSHlwZXItVi4K
Pgo+IEhlcmUncyB3aGF0IHdlIGN1cnJlbnRseSBoYXZlOgo+Cj4gICAgc3RhdGljIGNvbnN0IHN0
cnVjdCBhY3BpX2RldmljZV9pZCB2bWdlbmlkX2lkc1tdID0gewo+ICAgICAgeyAiVk1HRU5JRCIs
IDAgfSwgIDwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gPz8/Cj4gICAgICB7
ICJRRU1VVkdJRCIsIDAgfSwgPC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSBR
RU1VCj4gICAgICB7IH0sCj4gICAgfTsKPgo+IEFkcmlhbiBhZGRlZCAiVk1HRU5JRCIgaW4gbGFz
dCB5ZWFyJ3MgdjQsIHNvIEkgY29waWVkIHRoYXQgZm9yIHRoaXMgbmV3Cj4gZHJpdmVyIGhlcmUu
IEJ1dCBkb2VzIGFueWJvZHkga25vdyB3aGljaCBoeXBlcnZpc29yIGl0IGlzIGZvcj8gU29tZQo+
IGludGVybmFsIEFtYXpvbiB0aGluZz8gRmlyZWNyYWNrZXI/IFZNd2FyZT8gSW4gY2FzZSBBbGV4
IGRvZXMgbm90Cj4gc3VjY2VlZCB3aXRoIHRoZSBBQ1BJIGNoYW5nZXMsIGl0J2QgYmUgbmljZSB0
byBrbm93IHdoaWNoIEhJRHMgZm9yCj4gd2hpY2ggaHlwZXJ2aXNvcnMgd2UgZG8gYW5kIGRvIG5v
dCBzdXBwb3J0LgoKCkkgYmVsaWV2ZSAiVk1HRU5JRCIgd2FzIGZvciB0aGUgZmlyZWNyYWNrZXIg
cHJvdG90eXBlIHRoYXQgQWRyaWFuIGJ1aWx0IApiYWNrIHRoZW4sIHllYWguIE1hdGNoaW5nIG9u
IF9ISUQgZm9yIHRoaXMgaXMgYSByYXQgaG9sZSB1bmZvcnR1bmF0ZWx5LCAKc28gbGV0J3Mgc2Vl
IHdoYXQgdGhlIEFDUEkgcGF0Y2ggZ2V0cyB1cyA6KS4KCgpBbGV4CgoKCgoKQW1hem9uIERldmVs
b3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdl
c2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWlu
Z2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBC
ClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

