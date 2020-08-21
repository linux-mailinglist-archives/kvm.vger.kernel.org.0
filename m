Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E014124D964
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 18:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgHUQIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 12:08:14 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:28951 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgHUQIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 12:08:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598026091; x=1629562091;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=n/ZfqN75zK4wbDJNTwSI0gUUOSKPihuaxr+WJSXC0is=;
  b=SVyYw2rXYXZigeUC3rrCyszyXMzGpIUELYjzFZciqStLSW7qFeH/YxnP
   lm3hWhlKt5MfhnlL/2CyymQtzFf3vqUhV2jLlja6q9/JD8uDiXGVp9aEg
   G1jbeasAkaT9UBvgT11wvnschSdR380eFlQecFYZcILuubS8dYJpKLnqC
   s=;
X-IronPort-AV: E=Sophos;i="5.76,337,1592870400"; 
   d="scan'208";a="68703958"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Aug 2020 16:07:54 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id E98ACA044A;
        Fri, 21 Aug 2020 16:07:53 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 21 Aug 2020 16:07:53 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.145) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 21 Aug 2020 16:07:52 +0000
Subject: Re: [PATCH v3 07/12] KVM: x86: Ensure the MSR bitmap never clears
 userspace tracked MSRs
To:     Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>
CC:     kvm list <kvm@vger.kernel.org>
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-8-aaronlewis@google.com>
 <522d8a2f-8047-32f6-a329-c9ace7bf3693@amazon.com>
 <CAAAPnDFEKOQjTKcmkFjP6hr6dgmR-61NL_W9=7Fs0THdOOJ7+Q@mail.gmail.com>
 <d75a3862-d4f4-e057-5d45-9edcb3f9b696@amazon.com>
 <CALMp9eRQ3FYOW08tbLJ79KJ32dD8K7djSoze9rcV0tuGbfVgLw@mail.gmail.com>
 <CAAAPnDGiBw7U6G61kGuAJOn+vSonvkhm_RQ_nL5_G-4yNSdPPw@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <161f8df0-9667-8f52-6230-a073590d4646@amazon.com>
Date:   Fri, 21 Aug 2020 18:07:49 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAAAPnDGiBw7U6G61kGuAJOn+vSonvkhm_RQ_nL5_G-4yNSdPPw@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13P01UWB003.ant.amazon.com (10.43.161.209) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMS4wOC4yMCAxNjoyNywgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4gT24gVGh1LCBBdWcg
MjAsIDIwMjAgYXQgMzozNSBQTSBKaW0gTWF0dHNvbiA8am1hdHRzb25AZ29vZ2xlLmNvbT4gd3Jv
dGU6Cj4+Cj4+IE9uIFRodSwgQXVnIDIwLCAyMDIwIGF0IDM6MDQgUE0gQWxleGFuZGVyIEdyYWYg
PGdyYWZAYW1hem9uLmNvbT4gd3JvdGU6Cj4+Pgo+Pj4KPj4+Cj4+PiBPbiAyMC4wOC4yMCAwMjox
OCwgQWFyb24gTGV3aXMgd3JvdGU6Cj4+Pj4KPj4+PiBPbiBXZWQsIEF1ZyAxOSwgMjAyMCBhdCA4
OjI2IEFNIEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpvbi5jb20+IHdyb3RlOgo+Pj4+Pgo+Pj4+
Pgo+Pj4+Pgo+Pj4+PiBPbiAxOC4wOC4yMCAyMzoxNSwgQWFyb24gTGV3aXMgd3JvdGU6Cj4+Pj4+
Pgo+Pj4+Pj4gU0RNIHZvbHVtZSAzOiAyNC42LjkgIk1TUi1CaXRtYXAgQWRkcmVzcyIgYW5kIEFQ
TSB2b2x1bWUgMjogMTUuMTEgIk1TCj4+Pj4+PiBpbnRlcmNlcHRzIiBkZXNjcmliZSBNU1IgcGVy
bWlzc2lvbiBiaXRtYXBzLiAgUGVybWlzc2lvbiBiaXRtYXBzIGFyZQo+Pj4+Pj4gdXNlZCB0byBj
b250cm9sIHdoZXRoZXIgYW4gZXhlY3V0aW9uIG9mIHJkbXNyIG9yIHdybXNyIHdpbGwgY2F1c2Ug
YQo+Pj4+Pj4gdm0gZXhpdC4gIEZvciB1c2Vyc3BhY2UgdHJhY2tlZCBNU1JzIGl0IGlzIHJlcXVp
cmVkIHRoZXkgY2F1c2UgYSB2bQo+Pj4+Pj4gZXhpdCwgc28gdGhlIGhvc3QgaXMgYWJsZSB0byBm
b3J3YXJkIHRoZSBNU1IgdG8gdXNlcnNwYWNlLiAgVGhpcyBjaGFuZ2UKPj4+Pj4+IGFkZHMgdm14
L3N2bSBzdXBwb3J0IHRvIGVuc3VyZSB0aGUgcGVybWlzc2lvbiBiaXRtYXAgaXMgcHJvcGVybHkg
c2V0IHRvCj4+Pj4+PiBjYXVzZSBhIHZtX2V4aXQgdG8gdGhlIGhvc3Qgd2hlbiByZG1zciBvciB3
cm1zciBpcyB1c2VkIGJ5IG9uZSBvZiB0aGUKPj4+Pj4+IHVzZXJzcGFjZSB0cmFja2VkIE1TUnMu
ICBBbHNvLCB0byBhdm9pZCByZXBlYXRlZGx5IHNldHRpbmcgdGhlbSwKPj4+Pj4+IGt2bV9tYWtl
X3JlcXVlc3QoKSBpcyB1c2VkIHRvIGNvYWxlc2NlIHRoZXNlIGludG8gYSBzaW5nbGUgY2FsbC4K
Pj4+Pj4+Cj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBBYXJvbiBMZXdpcyA8YWFyb25sZXdpc0Bnb29n
bGUuY29tPgo+Pj4+Pj4gUmV2aWV3ZWQtYnk6IE9saXZlciBVcHRvbiA8b3VwdG9uQGdvb2dsZS5j
b20+Cj4+Pj4+Cj4+Pj4+IFRoaXMgaXMgaW5jb21wbGV0ZSwgYXMgaXQgZG9lc24ndCBjb3ZlciBh
bGwgb2YgdGhlIHgyYXBpYyByZWdpc3RlcnMuCj4+Pj4+IFRoZXJlIGFyZSBhbHNvIGEgZmV3IE1T
UnMgdGhhdCBJSVJDIGFyZSBoYW5kbGVkIGRpZmZlcmVudGx5IGZyb20gdGhpcwo+Pj4+PiBsb2dp
Yywgc3VjaCBhcyBFRkVSLgo+Pj4+Pgo+Pj4+PiBJJ20gcmVhbGx5IGN1cmlvdXMgaWYgdGhpcyBp
cyB3b3J0aCB0aGUgZWZmb3J0PyBJIHdvdWxkIGJlIGluY2xpbmVkIHRvCj4+Pj4+IHNheSB0aGF0
IE1TUnMgdGhhdCBLVk0gaGFzIGRpcmVjdCBhY2Nlc3MgZm9yIG5lZWQgc3BlY2lhbCBoYW5kbGlu
ZyBvbmUKPj4+Pj4gd2F5IG9yIGFub3RoZXIuCj4+Pj4+Cj4+Pj4KPj4+PiBDYW4geW91IHBsZWFz
ZSBlbGFib3JhdGUgb24gdGhpcz8gIEl0IHdhcyBteSB1bmRlcnN0YW5kaW5nIHRoYXQgdGhlCj4+
Pj4gcGVybWlzc2lvbiBiaXRtYXAgY292ZXJzIHRoZSB4MmFwaWMgcmVnaXN0ZXJzLiAgQWxzbywg
SeKAmW0gbm90IHN1cmUgaG93Cj4+Pgo+Pj4gU28geDJhcGljIE1TUiBwYXNzdGhyb3VnaCBpcyBj
b25maWd1cmVkIHNwZWNpYWxseToKPj4+Cj4+Pgo+Pj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L3RyZWUvYXJjaC94ODYv
a3ZtL3ZteC92bXguYyNuMzc5Ngo+Pj4KPj4+IGFuZCBJIHRoaW5rIG5vdCBoYW5kbGVkIGJ5IHRo
aXMgcGF0Y2g/Cj4+Cj4+IEJ5IGhhcHBlbnN0YW5jZSBvbmx5LCBJIHRoaW5rLCBzaW5jZSB0aGVy
ZSBpcyBhbHNvIGEgY2FsbCB0aGVyZSB0bwo+PiB2bXhfZGlzYWJsZV9pbnRlcmNlcHRfZm9yX21z
cigpIGZvciB0aGUgVFBSIHdoZW4geDJBUElDIGlzIGVuYWJsZWQuCj4gCj4gSWYgd2Ugd2FudCB0
byBiZSBtb3JlIGV4cGxpY2l0IGFib3V0IGl0IHdlIGNvdWxkIGFkZAo+IGt2bV9tYWtlX3JlcXVl
c3QoS1ZNX1JFUV9VU0VSX01TUl9VUERBVEUsIHZjcHUpIEFmdGVyIHRoZSBiaXRtYXAgaXMKPiBt
b2RpZmllZCwgYnV0IHRoYXQgZG9lc24ndCBzZWVtIHRvIGJlIG5lY2Vzc2FyeSBhcyBKaW0gcG9p
bnRlZCBvdXQgYXMKPiB0aGVyZSBhcmUgY2FsbHMgdG8gdm14X2Rpc2FibGVfaW50ZXJjZXB0X2Zv
cl9tc3IoKSB0aGVyZSB3aGljaCB3aWxsCj4gc2V0IHRoZSB1cGRhdGUgcmVxdWVzdCBmb3IgdXMu
ICBBbmQgd2Ugb25seSBoYXZlIHRvIHdvcnJ5IGFib3V0IHRoYXQKPiBpZiB0aGUgYml0bWFwIGlz
IGNsZWFyZWQgd2hpY2ggbWVhbnMgTVNSX0JJVE1BUF9NT0RFX1gyQVBJQ19BUElDViBpcwo+IHNl
dCwgYW5kIHRoYXQgZmxhZyBjYW4gb25seSBiZSBzZXQgaWYgTVNSX0JJVE1BUF9NT0RFX1gyQVBJ
QyBpcyBzZXQuCj4gU28sIEFGQUlDVCB0aGF0IGlzIGNvdmVyZWQgYnkgbXkgY2hhbmdlcy4KPiAK
CkkgZG9uJ3QgdW5kZXJzdGFuZCAtIGZvciBtb3N0IHgyQVBJQyBNU1JzLCAKdm14X3tlbixkaXN9
YWJsZV9pbnRlcmNlcHRfZm9yX21zcigpIG5ldmVyIGdldHMgY2FsbGVkLCBubz8KCgpBbGV4CgoK
CkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEw
MTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0
aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVy
IEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

