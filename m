Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554FA476BD6
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 09:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhLPI0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 03:26:09 -0500
Received: from mga18.intel.com ([134.134.136.126]:45242 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhLPI0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 03:26:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639643168; x=1671179168;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bi2ZQJ6FrZq2iL6VsUI2CR7xMzLnMFInEN8ODbNOIe8=;
  b=jM2WZyOOH15gFvr93oamLxPZXQGubE74JN9bqwN69aYv4HR8dCrHF8mf
   J9LPkpPFPgYaiMVCDFF6HPvv7LABlI64Y+tLKxaZ5ITnN+o4lA712jvhN
   3xqvD6LJU8O+B15g/GwX2fOSakFlYGuHiegGBmCJf2Site8xUQ4XmzLKN
   Moe58mqqF0im4ROukXStTTegZVb+PELgP7CDC+Ooc2j+uirYe6DbdB9cy
   uYf6T0GzMQHuveu/q8ZY3VtBNkjAgrjaSrQ4oDM6jHP9gOGSIEJ3mDU1x
   nWOSWWJiC1gEIGHyRpApPT3j+HTWU4xnZoJdjwqFwleLdsRA7munE24+7
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="226292520"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="226292520"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 00:26:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="464588759"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 16 Dec 2021 00:26:05 -0800
Received: from shsmsx605.ccr.corp.intel.com (10.109.6.215) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 00:26:04 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX605.ccr.corp.intel.com (10.109.6.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 16:25:54 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Thu, 16 Dec 2021 16:25:54 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Thread-Topic: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Thread-Index: AQHX63yobhR7xaimuUSU4jknnLqQN6wraUsAgABf8YCABEZs0P//mZ4AgAHaVHD//4REgIAB1a7QgAA4qwCAAbnSIA==
Date:   Thu, 16 Dec 2021 08:25:54 +0000
Message-ID: <d6828340c5a64da88caf90bd283b62c9@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
 <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
 <86d3c3a5d61649079800a2038370365b@intel.com>
 <bdda79b5-79e4-22fd-9af8-ec6e87a412ab@redhat.com>
 <3ec6019a551249d6994063e56a448625@intel.com>
 <ba78d142-6a97-99dd-9d00-465f7d6aa712@redhat.com>
 <0c2dae4264ae4d3b87d023879c51833c@intel.com>
 <cf329949-b81c-3e8c-0f38-4a28de22c456@redhat.com>
In-Reply-To: <cf329949-b81c-3e8c-0f38-4a28de22c456@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkbmVzZGF5LCBEZWNlbWJlciAxNSwgMjAyMSA5OjQzIFBNLCBQYW9sbyBCb256aW5pIHdy
b3RlOg0KPiBJdCdzIHN0aWxsIGVhc2llciB0byByZXR1cm4gdGhlIGZ1bGwgc2l6ZSBvZiB0aGUg
YnVmZmVyIGZyb20NCj4gS1ZNX0NIRUNLX0VYVEVOU0lPTihLVk1fQ0FQX1hTQVZFMikuICBJdCBt
YWtlcyB0aGUgdXNlcnNwYWNlIGNvZGUgYQ0KPiBiaXQgZWFzaWVyLg0KDQpPSy4gRm9yIHRoZSAi
ZnVsbCBzaXplIiByZXR1cm5lZCB0byB1c2Vyc3BhY2UsIHdvdWxkIHlvdSBwcmVmZXIgdG8gZGly
ZWN0bHkgdXNlIHRoZSB2YWx1ZSByZXRyaWV2ZWQgZnJvbSBndWVzdCBDUFVJRCgweGQpLA0Kb3Ig
Z2V0IGl0IGZyb20gZ3Vlc3RfZnB1IChpLmUuIGZwc3RhdGUtPnVzZXJfc2l6ZSk/DQoocmV0cmll
dmVkIGZyb20gQ1BVSUQgd2lsbCBiZSB0aGUgbWF4IHNpemUgYW5kIHNob3VsZCB3b3JrIGZpbmUg
YXMgd2VsbCkNCg0KPiANCj4gSSdtIGFsc28gdGhpbmtpbmcgdGhhdCBJIHByZWZlciBLVk1fR0VU
X1hTQVZFMiB0bw0KPiBLVk1fRU5BQkxFX0NBUChLVk1fQ0FQX1hTQVZFMiksIGFmdGVyIGFsbC4g
IFNpbmNlIGl0IHdvdWxkIGJlIGENCj4gYmFja3dhcmRzLWluY29tcGF0aWJsZSBjaGFuZ2UgdG8g
YW4gX29sZF8gaW9jdGwgKEtWTV9HRVRfWFNBVkUpLCBJIHByZWZlcg0KPiB0byBsaW1pdCB0aGUg
d2F5cyB0aGF0IHVzZXJzcGFjZSBjYW4gc2hvb3QgaXRzZWxmIGluIHRoZSBmb290Lg0KDQpPSywg
d2Ugd2lsbCB1c2UgS1ZNX0dFVF9YU0FWRTIuDQoNClRoYW5rcywNCldlaQ0K
