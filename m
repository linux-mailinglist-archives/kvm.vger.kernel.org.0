Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD4F4C48F8
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242111AbiBYPbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbiBYPbw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:31:52 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545A1218CD9;
        Fri, 25 Feb 2022 07:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1645803080; x=1677339080;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eN9+O0QeW+Uix9xoRJt85GwthBkk74Jy4BjJPjZhA8Y=;
  b=YhMRBxvfJGZT7Us4IsuVS6CHmYqUnzXnc1QjozOJHEcgbUJ4p/AOCm2t
   oBRsQy8HKOdEfaDSrXj6EwZRklpGin8UEiBdiW0PcmuoUru4Ky+/F6DDd
   rOCIEo+XNZ5CtWLjcWvuEPMMM6mOq/eYfI18EtV6AEtJp7RyHmQrzKj5r
   A=;
X-IronPort-AV: E=Sophos;i="5.90,136,1643673600"; 
   d="scan'208";a="66229061"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1box-d-74e80b3c.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 25 Feb 2022 15:31:18 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1box-d-74e80b3c.us-east-1.amazon.com (Postfix) with ESMTPS id E9E1387A16;
        Fri, 25 Feb 2022 15:31:11 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Fri, 25 Feb 2022 15:31:10 +0000
Received: from [0.0.0.0] (10.43.162.216) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.28; Fri, 25 Feb
 2022 15:31:04 +0000
Message-ID: <0b8a2c25-df48-143d-7fac-dc9b4ef68d3c@amazon.com>
Date:   Fri, 25 Feb 2022 16:31:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing RNG
 on VM fork
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "Jason A. Donenfeld" <Jason@zx2c4.com>, <kvm@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <adrian@parity.io>,
        <ardb@kernel.org>, <ben@skyportsystems.com>, <berrange@redhat.com>,
        <colmmacc@amazon.com>, <decui@microsoft.com>, <dwmw@amazon.co.uk>,
        <ebiggers@kernel.org>, <ehabkost@redhat.com>,
        <haiyangz@microsoft.com>, <imammedo@redhat.com>,
        <jannh@google.com>, <kys@microsoft.com>, <lersek@redhat.com>,
        <linux@dominikbrodowski.net>, <mst@redhat.com>,
        <qemu-devel@nongnu.org>, <raduweis@amazon.com>,
        <sthemmin@microsoft.com>, <tytso@mit.edu>, <wei.liu@kernel.org>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
 <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
 <YhjphtYyXoYZ9lXY@kroah.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <YhjphtYyXoYZ9lXY@kroah.com>
X-Originating-IP: [10.43.162.216]
X-ClientProxiedBy: EX13D41UWC004.ant.amazon.com (10.43.162.31) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDI1LjAyLjIyIDE1OjM2LCBHcmVnIEtIIHdyb3RlOgo+IE9uIEZyaSwgRmViIDI1LCAyMDIy
IGF0IDAyOjU3OjM4UE0gKzAxMDAsIEFsZXhhbmRlciBHcmFmIHdyb3RlOgo+Pj4gKwo+Pj4gKyAg
ICAgICBwaHlzX2FkZHIgPSAob2JqLT5wYWNrYWdlLmVsZW1lbnRzWzBdLmludGVnZXIudmFsdWUg
PDwgMCkgfAo+Pj4gKyAgICAgICAgICAgICAgICAgICAob2JqLT5wYWNrYWdlLmVsZW1lbnRzWzFd
LmludGVnZXIudmFsdWUgPDwgMzIpOwo+Pj4gKyAgICAgICBzdGF0ZS0+bmV4dF9pZCA9IGRldm1f
bWVtcmVtYXAoJmRldmljZS0+ZGV2LCBwaHlzX2FkZHIsIFZNR0VOSURfU0laRSwgTUVNUkVNQVBf
V0IpOwo+Pj4gKyAgICAgICBpZiAoIXN0YXRlLT5uZXh0X2lkKSB7Cj4+PiArICAgICAgICAgICAg
ICAgcmV0ID0gLUVOT01FTTsKPj4+ICsgICAgICAgICAgICAgICBnb3RvIG91dDsKPj4+ICsgICAg
ICAgfQo+Pj4gKwo+Pj4gKyAgICAgICBtZW1jcHkoc3RhdGUtPnRoaXNfaWQsIHN0YXRlLT5uZXh0
X2lkLCBzaXplb2Yoc3RhdGUtPnRoaXNfaWQpKTsKPj4+ICsgICAgICAgYWRkX2RldmljZV9yYW5k
b21uZXNzKHN0YXRlLT50aGlzX2lkLCBzaXplb2Yoc3RhdGUtPnRoaXNfaWQpKTsKPj4KPj4gUGxl
YXNlIGV4cG9zZSB0aGUgdm1nZW5pZCB2aWEgL3N5c2ZzIHNvIHRoYXQgdXNlciBzcGFjZSBldmVu
IHJlbW90ZWx5IGhhcyBhCj4+IGNoYW5jZSB0byBjaGVjayBpZiBpdCdzIGJlZW4gY2xvbmVkLgo+
IEV4cG9ydCBpdCBob3c/ICBBbmQgd2h5LCB3aG8gd291bGQgY2FyZT8KCgpZb3UgY2FuIGp1c3Qg
Y3JlYXRlIGEgc3lzZnMgZmlsZSB0aGF0IGNvbnRhaW5zIGl0LiBUaGUgc2FtZSB3YXkgd2UgaGF2
ZSAKc3lzZnMgZmlsZXMgZm9yIFVFRkkgY29uZmlnIHRhYmxlcy4gT3Igc3lzZnMgZmlsZXMgZm9y
IHRoZSBhY3BpIGRldmljZSAKbm9kZXMgdGhlbXNlbHZlcy4KCkkgcGVyc29uYWxseSBkb24ndCBj
YXJlIGlmIHdlIHB1dCB0aGlzIGludG8gYSBnZW5lcmljIGxvY2F0aW9uIAooL3N5cy9oeXBlcnZp
c29yIGZvciBleGFtcGxlKSBvciBpbnRvIHRoZSBleGlzdGluZyBhY3BpIGRldmljZSBub2RlIGFz
IAphZGRpdGlvbmFsIGZpbGUgeW91IGNhbiBqdXN0IHJlYWQuCgpXaG8gd291bGQgY2FyZT8gV2Vs
bCwgZm9yIHN0YXJ0ZXJzIEkgd291bGQgY2FyZSBmb3IgZGVidWdnaW5nIHB1cnBvc2VzIAo6KS4g
RXh0cmFjdGluZyB0aGUgSUQgYW5kIHZhbGlkYXRpbmcgdGhhdCBpdCdzIGRpZmZlcmVudCB0aGFu
IGJlZm9yZSBpcyAKcXVpdGUgdXNlZnVsIHdoZW4geW91IHdhbnQgdG8gY2hlY2sgaWYgdGhlIGNs
b25lIHJuZyBhZGp1c3RtZW50IGFjdHVhbGx5IAp3b3JrZWQuCgpJIGRvbid0IGhhdmUgdmVyeSBz
dHJvbmcgZmVlbGluZ3Mgb24gaXQgdGhvdWdoIC0gdW5saWtlIHRoZSBfQ0lEIApjb252ZXJzYXRp
b24uCgoKQWxleAoKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICkty
YXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBT
Y2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJs
b3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkg
MjM3IDg3OQoKCg==

