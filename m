Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3364C48B8
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242013AbiBYPXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242004AbiBYPXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:23:52 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1B849CA2;
        Fri, 25 Feb 2022 07:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1645802599; x=1677338599;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GrQeGewCJ5JoqTHYFh/mQ3OvnHNrjbbXdoSjqxalEjU=;
  b=hTLt22PvU5hVj+0lEHW6Qgz4APM0XJdcq+/tZ3KEizONtmkrGBmXMZ7E
   Jv6IWA8QHlTwAm+RW2WtPhlBwTCrfN0IBsoQUju/uysSP5zpVgMeXgLik
   L/2KXaQsXTkkreGiDHNqYwor+1MpKtIZABvZ7ScylLk+jCwkbqQiTK9aV
   o=;
X-IronPort-AV: E=Sophos;i="5.90,136,1643673600"; 
   d="scan'208";a="181265345"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 25 Feb 2022 15:23:04 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com (Postfix) with ESMTPS id 8D25A9602A;
        Fri, 25 Feb 2022 15:23:02 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Fri, 25 Feb 2022 15:23:02 +0000
Received: from [0.0.0.0] (10.43.162.43) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.28; Fri, 25 Feb
 2022 15:22:56 +0000
Message-ID: <c8066caf-8bbb-b148-57e6-98d8449a64c3@amazon.com>
Date:   Fri, 25 Feb 2022 16:22:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing RNG
 on VM fork
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        KVM list <kvm@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        <linux-hyperv@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <adrian@parity.io>, <ben@skyportsystems.com>,
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
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <CAMj1kXEue6cDCSG0N7WGTVF=JYZx3jwE7EK4tCdhO-HzMtWwVw@mail.gmail.com>
X-Originating-IP: [10.43.162.43]
X-ClientProxiedBy: EX13D42UWA003.ant.amazon.com (10.43.160.101) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDI1LjAyLjIyIDE2OjE2LCBBcmQgQmllc2hldXZlbCB3cm90ZToKPiBPbiBGcmksIDI1IEZl
YiAyMDIyIGF0IDE2OjEyLCBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPiB3cm90ZToK
Pj4KPj4gT24gMjUuMDIuMjIgMTU6MzMsIEphc29uIEEuIERvbmVuZmVsZCB3cm90ZToKPj4+IE9u
IEZyaSwgRmViIDI1LCAyMDIyIGF0IDAzOjE4OjQzUE0gKzAxMDAsIEFsZXhhbmRlciBHcmFmIHdy
b3RlOgo+Pj4+PiBJIHJlY2FsbCB0aGlzIHBhcnQgb2YgdGhlIG9sZCB0aHJlYWQuIEZyb20gd2hh
dCBJIHVuZGVyc3Rvb2QsIHVzaW5nCj4+Pj4+ICJWTUdFTklEIiArICJRRU1VVkdJRCIgd29ya2Vk
IC93ZWxsIGVub3VnaC8sIGV2ZW4gaWYgdGhhdCB3YXNuJ3QKPj4+Pj4gdGVjaG5pY2FsbHkgaW4t
c3BlYy4gQXJkIG5vdGVkIHRoYXQgcmVseWluZyBvbiBfQ0lEIGxpa2UgdGhhdCBpcwo+Pj4+PiB0
ZWNobmljYWxseSBhbiBBQ1BJIHNwZWMgbm90aWZpY2F0aW9uLiBTbyB3ZSdyZSBiZXR3ZWVuIG9u
ZSBzcGVjIGFuZAo+Pj4+PiBhbm90aGVyLCBiYXNpY2FsbHksIGFuZCBkb2luZyAiVk1HRU5JRCIg
KyAiUUVNVVZHSUQiIHJlcXVpcmVzIGZld2VyCj4+Pj4+IGNoYW5nZXMsIGFzIG1lbnRpb25lZCwg
YXBwZWFycyB0byB3b3JrIGZpbmUgaW4gbXkgdGVzdGluZy4KPj4+Pj4KPj4+Pj4gSG93ZXZlciwg
d2l0aCB0aGF0IHNhaWQsIEkgdGhpbmsgc3VwcG9ydGluZyB0aGlzIHZpYSAiVk1fR2VuX0NvdW50
ZXIiCj4+Pj4+IHdvdWxkIGJlIGEgYmV0dGVyIGV2ZW50dWFsIHRoaW5nIHRvIGRvLCBidXQgd2ls
bCByZXF1aXJlIGFja3MgYW5kCj4+Pj4+IGNoYW5nZXMgZnJvbSB0aGUgQUNQSSBtYWludGFpbmVy
cy4gRG8geW91IHRoaW5rIHlvdSBjb3VsZCBwcmVwYXJlIHlvdXIKPj4+Pj4gcGF0Y2ggcHJvcG9z
YWwgYWJvdmUgYXMgc29tZXRoaW5nIG9uLXRvcCBvZiBteSB0cmVlIFsxXT8gQW5kIGlmIHlvdSBj
YW4KPj4+Pj4gY29udmluY2UgdGhlIEFDUEkgbWFpbnRhaW5lcnMgdGhhdCB0aGF0J3Mgb2theSwg
dGhlbiBJJ2xsIGhhcHBpbHkgdGFrZQo+Pj4+PiB0aGUgcGF0Y2guCj4+Pj4gU3VyZSwgbGV0IG1l
IHNlbmQgdGhlIEFDUEkgcGF0Y2ggc3RhbmQgYWxvbmUuIE5vIG5lZWQgdG8gaW5jbHVkZSB0aGUK
Pj4+PiBWTUdlbklEIGNoYW5nZSBpbiB0aGVyZS4KPj4+IFRoYXQncyBmaW5lLiBJZiB0aGUgQUNQ
SSBwZW9wbGUgdGFrZSBpdCBmb3IgNS4xOCwgdGhlbiB3ZSBjYW4gY291bnQgb24KPj4+IGl0IGJl
aW5nIHRoZXJlIGFuZCBhZGp1c3QgdGhlIHZtZ2VuaWQgZHJpdmVyIGFjY29yZGluZ2x5IGFsc28g
Zm9yIDUuMTguCj4+Pgo+Pj4gSSBqdXN0IGJvb3RlZCB1cCBhIFdpbmRvd3MgVk0sIGFuZCBpdCBs
b29rcyBsaWtlIEh5cGVyLVYgdXNlcwo+Pj4gIkh5cGVyX1ZfR2VuX0NvdW50ZXJfVjEiLCB3aGlj
aCBpcyBhbHNvIHF1aXRlIGxvbmcsIHNvIHdlIGNhbid0IHJlYWxseQo+Pj4gSElEIG1hdGNoIG9u
IHRoYXQgZWl0aGVyLgo+Pgo+PiBZZXMsIGR1ZSB0byB0aGUgc2FtZSBwcm9ibGVtLiBJJ2QgcmVh
bGx5IHByZWZlciB3ZSBzb3J0IG91dCB0aGUgQUNQSQo+PiBtYXRjaGluZyBiZWZvcmUgdGhpcyBn
b2VzIG1haW5saW5lLiBNYXRjaGluZyBvbiBfSElEIGlzIGV4cGxpY2l0bHkKPj4gZGlzY291cmFn
ZWQgaW4gdGhlIFZNR2VuSUQgc3BlYy4KPj4KPiBPSywgdGhpcyByZWFsbHkgc3Vja3MuIFF1b3Rp
bmcgdGhlIEFDUEkgc3BlYzoKPgo+ICIiIgo+IEEgX0hJRCBvYmplY3QgZXZhbHVhdGVzIHRvIGVp
dGhlciBhIG51bWVyaWMgMzItYml0IGNvbXByZXNzZWQgRUlTQQo+IHR5cGUgSUQgb3IgYSBzdHJp
bmcuIElmIGEgc3RyaW5nLCB0aGUgZm9ybWF0IG11c3QgYmUgYW4gYWxwaGFudW1lcmljCj4gUE5Q
IG9yIEFDUEkgSUQgd2l0aCBubyBhc3RlcmlzayBvciBvdGhlciBsZWFkaW5nIGNoYXJhY3RlcnMu
Cj4gQSB2YWxpZCBQTlAgSUQgbXVzdCBiZSBvZiB0aGUgZm9ybSAiQUFBIyMjIyIgd2hlcmUgQSBp
cyBhbiB1cHBlcmNhc2UKPiBsZXR0ZXIgYW5kICMgaXMgYSBoZXggZGlnaXQuCj4gQSB2YWxpZCBB
Q1BJIElEIG11c3QgYmUgb2YgdGhlIGZvcm0gIk5OTk4jIyMjIiB3aGVyZSBOIGlzIGFuIHVwcGVy
Y2FzZQo+IGxldHRlciBvciBhIGRpZ2l0ICgnMCctJzknKSBhbmQgIyBpcyBhIGhleCBkaWdpdC4g
VGhpcyBzcGVjaWZpY2F0aW9uCj4gcmVzZXJ2ZXMgdGhlIHN0cmluZyAiQUNQSSIgZm9yIHVzZSBv
bmx5IHdpdGggZGV2aWNlcyBkZWZpbmVkIGhlcmVpbi4KPiBJdCBmdXJ0aGVyIHJlc2VydmVzIGFs
bCBzdHJpbmdzIHJlcHJlc2VudGluZyA0IEhFWCBkaWdpdHMgZm9yCj4gZXhjbHVzaXZlIHVzZSB3
aXRoIFBDSS1hc3NpZ25lZCBWZW5kb3IgSURzLgo+ICIiIgo+Cj4gU28gbm93IHdlIGhhdmUgdG8g
aW1wbGVtZW50IE1pY3Jvc29mdCdzIGZvcmsgb2YgQUNQSSB0byBiZSBhYmxlIHRvIHVzZQo+IHRo
aXMgZGV2aWNlLCBldmVuIGlmIHdlIGV4cG9zZSBpdCBmcm9tIFFFTVUgaW5zdGVhZCBvZiBIeXBl
ci1WPyBJCj4gc3Ryb25nbHkgb2JqZWN0IHRvIHRoYXQuCj4KPiBJbnN0ZWFkLCB3ZSBjYW4gbWF0
Y2ggb24gX0hJRCBleHBvc2VkIGJ5IFFFTVUsIGFuZCBjb3JkaWFsbHkgaW52aXRlCj4gTWljcm9z
b2Z0IHRvIGFsaWduIHRoZWlyIHNwZWMgd2l0aCB0aGUgQUNQSSBzcGVjLgoKCkRvaW5nIHRoYXQg
d291bGQgYmUgYSBiYWNrd2FyZHMgaW5jb21wYXRpYmxlIGNoYW5nZSBmb3IgSHlwZXItViwgbm8/
IEkgCnVuZGVyc3RhbmQgdGhhdCB5b3UncmUgdXBzZXQgYWJvdXQgdGhlaXIgc3BlYywgYnV0IHRo
YXQgZG9lc24ndCBtZWFuIHdlIApjYW4ndCBmaW5kIGEgcGF0aCBmb3J3YXJkIHRvIG1ha2UgaXQg
YWxsIGNvbXBhdGlibGUuCgpJTUhPIGp1c3QgbWF0Y2hpbmcgb24gdGhlIGZpcnN0IDkgYnl0ZXMg
b2YgdGhlIF9DSUQvX0hJRCBzdHJpbmcgaXMgCnBlcmZlY3RseSBmaW5lLiBJdCBmb2xsb3dzIHRo
ZSBzcGVjLCBidXQgc3RpbGwgYWxsb3dzIGZvciB3ZWlyZCAKaWRlbnRpZmllcnMgbGlrZSB0aGlz
IG9uZSB0byB3b3JrLgoKSSBkb24ndCB1bmRlcnN0YW5kIHRoZSBydXNoIGhlcmUuIFRoaXMgaGFk
IGJlZW4gc2l0dGluZyBvbiB0aGUgTUwgZm9yIDEgCnllYXIgLSBhbmQgbm93IHN1ZGRlbmx5IHRh
bGtpbmcgdGhlIG1hdGNoIHRocm91Z2ggcHJvcGVybHkgYW5kIGdldHRpbmcgClZNR2VuSUQgc3Bl
YyBjb21wYXRpYmxlIG1hdGNoaW5nIHN1cHBvcnQgaW50byB0aGUgQUNQSSBjb3JlIGlzIGEgCnBy
b2JsZW0/IFdoYXQgZGlkIEkgbWlzcz8gOikKCgpBbGV4CgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQg
Q2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0
c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdl
biBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejog
QmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

